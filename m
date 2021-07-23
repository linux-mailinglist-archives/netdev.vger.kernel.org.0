Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547873D3CEA
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 17:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235749AbhGWPOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:14:03 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57294 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235597AbhGWPNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 11:13:53 -0400
Received: from localhost.localdomain (unknown [78.30.39.111])
        by mail.netfilter.org (Postfix) with ESMTPSA id 96EC264175;
        Fri, 23 Jul 2021 17:53:54 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/6] netfilter: nf_tables: fix audit memory leak in nf_tables_commit
Date:   Fri, 23 Jul 2021 17:54:07 +0200
Message-Id: <20210723155412.17916-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210723155412.17916-1-pablo@netfilter.org>
References: <20210723155412.17916-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

In nf_tables_commit, if nf_tables_commit_audit_alloc fails, it does not
free the adp variable.

Fix this by adding nf_tables_commit_audit_free which frees
the linked list with the head node adl.

backtrace:
  kmalloc include/linux/slab.h:591 [inline]
  kzalloc include/linux/slab.h:721 [inline]
  nf_tables_commit_audit_alloc net/netfilter/nf_tables_api.c:8439 [inline]
  nf_tables_commit+0x16e/0x1760 net/netfilter/nf_tables_api.c:8508
  nfnetlink_rcv_batch+0x512/0xa80 net/netfilter/nfnetlink.c:562
  nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
  nfnetlink_rcv+0x1fa/0x220 net/netfilter/nfnetlink.c:652
  netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
  netlink_unicast+0x2c7/0x3e0 net/netlink/af_netlink.c:1340
  netlink_sendmsg+0x36b/0x6b0 net/netlink/af_netlink.c:1929
  sock_sendmsg_nosec net/socket.c:702 [inline]
  sock_sendmsg+0x56/0x80 net/socket.c:722

Reported-by: syzbot <syzkaller@googlegroups.com>
Reported-by: kernel test robot <lkp@intel.com>
Fixes: c520292f29b8 ("audit: log nftables configuration change events once per table")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index de182d1f7c4e..081437dd75b7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8445,6 +8445,16 @@ static int nf_tables_commit_audit_alloc(struct list_head *adl,
 	return 0;
 }
 
+static void nf_tables_commit_audit_free(struct list_head *adl)
+{
+	struct nft_audit_data *adp, *adn;
+
+	list_for_each_entry_safe(adp, adn, adl, list) {
+		list_del(&adp->list);
+		kfree(adp);
+	}
+}
+
 static void nf_tables_commit_audit_collect(struct list_head *adl,
 					   struct nft_table *table, u32 op)
 {
@@ -8509,6 +8519,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		ret = nf_tables_commit_audit_alloc(&adl, trans->ctx.table);
 		if (ret) {
 			nf_tables_commit_chain_prepare_cancel(net);
+			nf_tables_commit_audit_free(&adl);
 			return ret;
 		}
 		if (trans->msg_type == NFT_MSG_NEWRULE ||
@@ -8518,6 +8529,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			ret = nf_tables_commit_chain_prepare(net, chain);
 			if (ret < 0) {
 				nf_tables_commit_chain_prepare_cancel(net);
+				nf_tables_commit_audit_free(&adl);
 				return ret;
 			}
 		}
-- 
2.20.1

