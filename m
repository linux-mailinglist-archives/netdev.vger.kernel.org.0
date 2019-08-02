Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91EAC7F9DF
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 15:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404149AbfHBNaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 09:30:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394164AbfHBNYZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 09:24:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2BC820880;
        Fri,  2 Aug 2019 13:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752264;
        bh=CRT6hjYjLu1G9zSoUf8J0kz6L/Cb4arX6stNuAGgddA=;
        h=From:To:Cc:Subject:Date:From;
        b=0/a/k4Mx924kLYZ+YkteEC8IxlgAWcBLSAJCihrR1uidOT6sn0PcpBBY5Qk+1mgWJ
         vTn6oEQ4mEdZGI+Aw0SB+hQCG5Bc/WbZwYcn4XUTtwD6v+vTn2Im9yyyAgzsJjRDyR
         KFTEbU0i+DvxovTdJRtUjDxwAIH0TMze4ydOUjPc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 01/30] netfilter: nfnetlink: avoid deadlock due to synchronous request_module
Date:   Fri,  2 Aug 2019 09:23:53 -0400
Message-Id: <20190802132422.13963-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 1b0890cd60829bd51455dc5ad689ed58c4408227 ]

Thomas and Juliana report a deadlock when running:

(rmmod nf_conntrack_netlink/xfrm_user)

  conntrack -e NEW -E &
  modprobe -v xfrm_user

They provided following analysis:

conntrack -e NEW -E
    netlink_bind()
        netlink_lock_table() -> increases "nl_table_users"
            nfnetlink_bind()
            # does not unlock the table as it's locked by netlink_bind()
                __request_module()
                    call_usermodehelper_exec()

This triggers "modprobe nf_conntrack_netlink" from kernel, netlink_bind()
won't return until modprobe process is done.

"modprobe xfrm_user":
    xfrm_user_init()
        register_pernet_subsys()
            -> grab pernet_ops_rwsem
                ..
                netlink_table_grab()
                    calls schedule() as "nl_table_users" is non-zero

so modprobe is blocked because netlink_bind() increased
nl_table_users while also holding pernet_ops_rwsem.

"modprobe nf_conntrack_netlink" runs and inits nf_conntrack_netlink:
    ctnetlink_init()
        register_pernet_subsys()
            -> blocks on "pernet_ops_rwsem" thanks to xfrm_user module

both modprobe processes wait on one another -- neither can make
progress.

Switch netlink_bind() to "nowait" modprobe -- this releases the netlink
table lock, which then allows both modprobe instances to complete.

Reported-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Reported-by: Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 733d3e4a30d85..2cee032af46d2 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -530,7 +530,7 @@ static int nfnetlink_bind(struct net *net, int group)
 	ss = nfnetlink_get_subsys(type << 8);
 	rcu_read_unlock();
 	if (!ss)
-		request_module("nfnetlink-subsys-%d", type);
+		request_module_nowait("nfnetlink-subsys-%d", type);
 	return 0;
 }
 #endif
-- 
2.20.1

