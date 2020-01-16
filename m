Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5128A13F82B
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387430AbgAPTQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:16:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:41440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732777AbgAPQzr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:55:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59C9A20730;
        Thu, 16 Jan 2020 16:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193747;
        bh=Qo96X3SSaZ1LtA/89TScd5NsivCR6oe1aoBgbuVYLwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WZ8aqI+JQGXYSBnkABvzKBeNjPYe4jev6RF2ur+os0DP3aYBsfzUvTW9ejpKT5Efj
         oPNl6v4zcwds0S0QC7shqqoKW7ZtXWrTpkpheQTFQuSe/vpEvb4GugwpNy4fU7aN+2
         lYOapDeACY6qEehP3Cb3rzEHVMSd8E0YxFLDC2oE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 037/671] netfilter: nf_flow_table: do not remove offload when other netns's interface is down
Date:   Thu, 16 Jan 2020 11:44:28 -0500
Message-Id: <20200116165502.8838-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit a3fb3698cadf27dc142b24394c401625e14d80d0 ]

When interface is down, offload cleanup function(nf_flow_table_do_cleanup)
is called and that checks whether interface index of offload and
index of link down interface is same. but only interface index checking
is not enough because flowtable is not pernet list.
So that, if other netns's interface that has index is same with offload
is down, that offload will be removed.
This patch adds netns checking code to the offload cleanup routine.

Fixes: 59c466dd68e7 ("netfilter: nf_flow_table: add a new flow state for tearing down offloading")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_core.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 70bd730ca059..890799c16aa4 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -491,14 +491,17 @@ EXPORT_SYMBOL_GPL(nf_flow_table_init);
 static void nf_flow_table_do_cleanup(struct flow_offload *flow, void *data)
 {
 	struct net_device *dev = data;
+	struct flow_offload_entry *e;
+
+	e = container_of(flow, struct flow_offload_entry, flow);
 
 	if (!dev) {
 		flow_offload_teardown(flow);
 		return;
 	}
-
-	if (flow->tuplehash[0].tuple.iifidx == dev->ifindex ||
-	    flow->tuplehash[1].tuple.iifidx == dev->ifindex)
+	if (net_eq(nf_ct_net(e->ct), dev_net(dev)) &&
+	    (flow->tuplehash[0].tuple.iifidx == dev->ifindex ||
+	     flow->tuplehash[1].tuple.iifidx == dev->ifindex))
 		flow_offload_dead(flow);
 }
 
-- 
2.20.1

