Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62C544C4D6
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 03:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730973AbfFTBRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 21:17:46 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:2914 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfFTBRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 21:17:45 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id B3EC85C1865;
        Thu, 20 Jun 2019 09:17:40 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH nf-next v2 1/2] netfilter: nft_meta: add NFT_META_BRI_PVID support
Date:   Thu, 20 Jun 2019 09:17:39 +0800
Message-Id: <1560993460-25569-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVJQ0pCQkJDSU1PSEpJTFlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6N006Ijo6Tzg2OhccSw43LRA8
        IjIKCyJVSlVKTk1LQkJIT01LQ05NVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhKT043Bg++
X-HM-Tid: 0a6b7275f2172087kuqyb3ec85c1865
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
With this pacth user can get the pvid of bridge ports.

So add the following rule for as the first rule in the chain of zones.

nft add rule bridge firewall zones counter meta brvlan set meta brpvid

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nft_meta.c                 | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 31a6b8f..4a16124 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -793,6 +793,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_SECPATH: boolean, secpath_exists (!!skb->sp)
  * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
  * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
+ * @NFT_META_BRI_PVID: packet input bridge port pvid
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -823,6 +824,7 @@ enum nft_meta_keys {
 	NFT_META_SECPATH,
 	NFT_META_IIFKIND,
 	NFT_META_OIFKIND,
+	NFT_META_BRI_PVID,
 };
 
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 987d2d6..cb877e01 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -243,6 +243,14 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 			goto err;
 		strncpy((char *)dest, p->br->dev->name, IFNAMSIZ);
 		return;
+	case NFT_META_BRI_PVID:
+		if (in == NULL || (p = br_port_get_rtnl_rcu(in)) == NULL)
+			goto err;
+		if (br_opt_get(p->br, BROPT_VLAN_ENABLED)) {
+			nft_reg_store16(dest, br_get_pvid(nbp_vlan_group_rcu(p)));
+			return;
+		}
+		goto err;
 #endif
 	case NFT_META_IIFKIND:
 		if (in == NULL || in->rtnl_link_ops == NULL)
@@ -370,6 +378,11 @@ static int nft_meta_get_init(const struct nft_ctx *ctx,
 			return -EOPNOTSUPP;
 		len = IFNAMSIZ;
 		break;
+	case NFT_META_BRI_PVID:
+		if (ctx->family != NFPROTO_BRIDGE)
+			return -EOPNOTSUPP;
+		len = sizeof(u16);
+		break;
 #endif
 	default:
 		return -EOPNOTSUPP;
-- 
1.8.3.1

