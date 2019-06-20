Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 820D54C4D4
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 03:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfFTBRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 21:17:45 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:2916 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbfFTBRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 21:17:45 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id E08185C1894;
        Thu, 20 Jun 2019 09:17:40 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH nf-next v2 2/2] netfilter: nft_meta: Add NFT_META_BRI_VLAN support
Date:   Thu, 20 Jun 2019 09:17:40 +0800
Message-Id: <1560993460-25569-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560993460-25569-1-git-send-email-wenxu@ucloud.cn>
References: <1560993460-25569-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSkJNQkJCQktMT0JITkJZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OTI6Syo4GTg8EBcrFg8YLRZP
        GE8wCzZVSlVKTk1LQkJIT01KS0lJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhDSk43Bg++
X-HM-Tid: 0a6b7275f2e52087kuqye08185c1894
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

nft add table bridge firewall
nft add chain bridge firewall zones { type filter hook prerouting priority - 300 \; }
nft add rule bridge firewall zones counter ct zone set vlan id map { 100 : 1, 200 : 2 }

As above set the bridge port with pvid, the received packet don't contain
the vlan tag which means the packet should belong to vlan 200 through pvid.
With this pacth user can set the pvid in the prerouting hook before set zone
id and conntrack.

So add the following rule for as the first rule in the chain of zones.

nft add rule bridge firewall zones counter meta brvlan set meta brpvid

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nft_meta.c                 | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 4a16124..7be0307 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -794,6 +794,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
  * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
  * @NFT_META_BRI_PVID: packet input bridge port pvid
+ * @NFT_META_BRI_VLAN: set vlan tag on packet
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -825,6 +826,7 @@ enum nft_meta_keys {
 	NFT_META_IIFKIND,
 	NFT_META_OIFKIND,
 	NFT_META_BRI_PVID,
+	NFT_META_BRI_VLAN,
 };
 
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index cb877e01..f30d11b 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -278,8 +278,13 @@ static void nft_meta_set_eval(const struct nft_expr *expr,
 {
 	const struct nft_meta *meta = nft_expr_priv(expr);
 	struct sk_buff *skb = pkt->skb;
+	const struct net_device *in = nft_in(pkt);
 	u32 *sreg = &regs->data[meta->sreg];
+#ifdef CONFIG_NF_TABLES_BRIDGE
+	const struct net_bridge_port *p;
+#endif
 	u32 value = *sreg;
+	u16 value16;
 	u8 value8;
 
 	switch (meta->key) {
@@ -302,6 +307,13 @@ static void nft_meta_set_eval(const struct nft_expr *expr,
 
 		skb->nf_trace = !!value8;
 		break;
+#ifdef CONFIG_NF_TABLES_BRIDGE
+	case NFT_META_BRI_VLAN:
+		value16 = nft_reg_load16(sreg);
+		if (in && (p = br_port_get_rtnl_rcu(in)))
+			__vlan_hwaccel_put_tag(skb, p->br->vlan_proto, value16);
+		break;
+#endif
 #ifdef CONFIG_NETWORK_SECMARK
 	case NFT_META_SECMARK:
 		skb->secmark = value;
@@ -477,6 +489,13 @@ static int nft_meta_set_init(const struct nft_ctx *ctx,
 	case NFT_META_PKTTYPE:
 		len = sizeof(u8);
 		break;
+#ifdef CONFIG_NF_TABLES_BRIDGE
+	case NFT_META_BRI_VLAN:
+		if (ctx->family != NFPROTO_BRIDGE)
+			return -EOPNOTSUPP;
+		len = sizeof(u16);
+		break;
+#endif
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
1.8.3.1

