Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8E612BA50
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 19:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbfL0SRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 13:17:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:40830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727728AbfL0SPx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 13:15:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7C442173E;
        Fri, 27 Dec 2019 18:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577470552;
        bh=zfGGtj2NSGPTgMeo8XkeDOGLRWCosge9y98lw8PN9LQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NUTSSYb5gwmk+5iyURc3gbLrynxaX8RczxmXNNFlBbEGLMjVgjinyBdhvm0uEbUEO
         8VcQp7QUv4b9zu6YanoYGnAtN7N62wATgVf9bPHDLLkife5riRE10mCg2ICSNtBmOk
         JoPAkJwN/bQ7fZtJIvq6LOiOP8hdOxdan8NyHxGQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 02/25] netfilter: ctnetlink: netns exit must wait for callbacks
Date:   Fri, 27 Dec 2019 13:15:26 -0500
Message-Id: <20191227181549.8040-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227181549.8040-1-sashal@kernel.org>
References: <20191227181549.8040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 18a110b022a5c02e7dc9f6109d0bd93e58ac6ebb ]

Curtis Taylor and Jon Maxwell reported and debugged a crash on 3.10
based kernel.

Crash occurs in ctnetlink_conntrack_events because net->nfnl socket is
NULL.  The nfnl socket was set to NULL by netns destruction running on
another cpu.

The exiting network namespace calls the relevant destructors in the
following order:

1. ctnetlink_net_exit_batch

This nulls out the event callback pointer in struct netns.

2. nfnetlink_net_exit_batch

This nulls net->nfnl socket and frees it.

3. nf_conntrack_cleanup_net_list

This removes all remaining conntrack entries.

This is order is correct. The only explanation for the crash so ar is:

cpu1: conntrack is dying, eviction occurs:
 -> nf_ct_delete()
   -> nf_conntrack_event_report \
     -> nf_conntrack_eventmask_report
       -> notify->fcn() (== ctnetlink_conntrack_events).

cpu1: a. fetches rcu protected pointer to obtain ctnetlink event callback.
      b. gets interrupted.
 cpu2: runs netns exit handlers:
     a runs ctnetlink destructor, event cb pointer set to NULL.
     b runs nfnetlink destructor, nfnl socket is closed and set to NULL.
cpu1: c. resumes and trips over NULL net->nfnl.

Problem appears to be that ctnetlink_net_exit_batch only prevents future
callers of nf_conntrack_eventmask_report() from obtaining the callback.
It doesn't wait of other cpus that might have already obtained the
callbacks address.

I don't see anything in upstream kernels that would prevent similar
crash: We need to wait for all cpus to have exited the event callback.

Fixes: 9592a5c01e79dbc59eb56fa ("netfilter: ctnetlink: netns support")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3a24c01cb909..f324a1124418 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3390,6 +3390,9 @@ static void __net_exit ctnetlink_net_exit_batch(struct list_head *net_exit_list)
 
 	list_for_each_entry(net, net_exit_list, exit_list)
 		ctnetlink_net_exit(net);
+
+	/* wait for other cpus until they are done with ctnl_notifiers */
+	synchronize_rcu();
 }
 
 static struct pernet_operations ctnetlink_net_ops = {
-- 
2.20.1

