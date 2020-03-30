Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22638197167
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 02:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgC3AiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 20:38:01 -0400
Received: from correo.us.es ([193.147.175.20]:57148 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727821AbgC3AhX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Mar 2020 20:37:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 11BB9EF429
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 02:37:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F04B1100A5C
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 02:37:21 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E5A1C100A55; Mon, 30 Mar 2020 02:37:21 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 02B3A100A42;
        Mon, 30 Mar 2020 02:37:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 02:37:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D05B642EF42A;
        Mon, 30 Mar 2020 02:37:19 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 12/26] netfilter: flowtable: add counter support
Date:   Mon, 30 Mar 2020 02:36:54 +0200
Message-Id: <20200330003708.54017-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200330003708.54017-1-pablo@netfilter.org>
References: <20200330003708.54017-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new flag to turn on flowtable counters which are stored in the
conntrack entry.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h    | 1 +
 include/uapi/linux/netfilter/nf_tables.h | 5 ++++-
 net/netfilter/nf_flow_table_ip.c         | 7 +++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 4beb7f13bc50..4a2ec6fd9ad2 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -63,6 +63,7 @@ struct nf_flowtable_type {
 
 enum nf_flowtable_flags {
 	NF_FLOWTABLE_HW_OFFLOAD		= 0x1,	/* NFT_FLOWTABLE_HW_OFFLOAD */
+	NF_FLOWTABLE_COUNTER		= 0x2,	/* NFT_FLOWTABLE_COUNTER */
 };
 
 struct nf_flowtable {
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 717ee3aa05d7..30f2a87270dc 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1557,10 +1557,13 @@ enum nft_object_attributes {
  * enum nft_flowtable_flags - nf_tables flowtable flags
  *
  * @NFT_FLOWTABLE_HW_OFFLOAD: flowtable hardware offload is enabled
+ * @NFT_FLOWTABLE_COUNTER: enable flow counters
  */
 enum nft_flowtable_flags {
 	NFT_FLOWTABLE_HW_OFFLOAD	= 0x1,
-	NFT_FLOWTABLE_MASK		= NFT_FLOWTABLE_HW_OFFLOAD
+	NFT_FLOWTABLE_COUNTER		= 0x2,
+	NFT_FLOWTABLE_MASK		= (NFT_FLOWTABLE_HW_OFFLOAD |
+					   NFT_FLOWTABLE_COUNTER)
 };
 
 /**
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 5272721080f8..553cc0d5695a 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -12,6 +12,7 @@
 #include <net/ip6_route.h>
 #include <net/neighbour.h>
 #include <net/netfilter/nf_flow_table.h>
+#include <net/netfilter/nf_conntrack_acct.h>
 /* For layer 4 checksum field offset. */
 #include <linux/tcp.h>
 #include <linux/udp.h>
@@ -286,6 +287,9 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	ip_decrease_ttl(iph);
 	skb->tstamp = 0;
 
+	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
+		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
+
 	if (unlikely(dst_xfrm(&rt->dst))) {
 		memset(skb->cb, 0, sizeof(struct inet_skb_parm));
 		IPCB(skb)->iif = skb->dev->ifindex;
@@ -516,6 +520,9 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	ip6h->hop_limit--;
 	skb->tstamp = 0;
 
+	if (flow_table->flags & NF_FLOWTABLE_COUNTER)
+		nf_ct_acct_update(flow->ct, tuplehash->tuple.dir, skb->len);
+
 	if (unlikely(dst_xfrm(&rt->dst))) {
 		memset(skb->cb, 0, sizeof(struct inet6_skb_parm));
 		IP6CB(skb)->iif = skb->dev->ifindex;
-- 
2.11.0

