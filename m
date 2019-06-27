Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4A3E57949
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 04:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfF0CJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 22:09:21 -0400
Received: from m97188.mail.qiye.163.com ([220.181.97.188]:47009 "EHLO
        m97188.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbfF0CJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 22:09:21 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m97188.mail.qiye.163.com (Hmail) with ESMTPA id 153D79668C3;
        Thu, 27 Jun 2019 10:09:18 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/2 nf-next] netfilter: nft_meta: add NFT_META_BRI_VLAN_PROTO support
Date:   Thu, 27 Jun 2019 10:09:16 +0800
Message-Id: <1561601357-20486-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVIQ0NLS0tLSkpPT09LQllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NEk6PBw*NjgrIgswOR0hHx8t
        FjwwC0JVSlVKTk1KTUtKSE5DSUxKVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlNS0w3Bg++
X-HM-Tid: 0a6b96b1b96420bckuqy153d79668c3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch provide a meta to get the bridge vlan proto

nft add rule bridge firewall zones counter meta br_vlan_proto 0x8100

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 ++
 net/netfilter/nft_meta.c                 | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 8859535..0b18646 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -796,6 +796,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
  * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
  * @NFT_META_BRI_PVID: packet input bridge port pvid
+ * @NFT_META_BRI_VLAN_PROTO: packet input bridge vlan proto
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -827,6 +828,7 @@ enum nft_meta_keys {
 	NFT_META_IIFKIND,
 	NFT_META_OIFKIND,
 	NFT_META_BRI_PVID,
+	NFT_META_BRI_VLAN_PROTO,
 };
 
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 4f8116d..e3adf6a 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -248,6 +248,14 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 			return;
 		}
 		goto err;
+	case NFT_META_BRI_VLAN_PROTO:
+		if (in == NULL || (p = br_port_get_rtnl_rcu(in)) == NULL)
+			goto err;
+		if (br_opt_get(p->br, BROPT_VLAN_ENABLED)) {
+			nft_reg_store16(dest, p->br->vlan_proto);
+			return;
+		}
+		goto err;
 #endif
 	case NFT_META_IIFKIND:
 		if (in == NULL || in->rtnl_link_ops == NULL)
@@ -376,6 +384,7 @@ static int nft_meta_get_init(const struct nft_ctx *ctx,
 		len = IFNAMSIZ;
 		break;
 	case NFT_META_BRI_PVID:
+	case NFT_META_BRI_VLAN_PROTO:
 		if (ctx->family != NFPROTO_BRIDGE)
 			return -EOPNOTSUPP;
 		len = sizeof(u16);
-- 
1.8.3.1

