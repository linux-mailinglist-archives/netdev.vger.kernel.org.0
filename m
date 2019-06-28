Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B33658F34
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 02:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfF1Atl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 20:49:41 -0400
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:34418 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbfF1Atl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 20:49:41 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id CB503E016FA;
        Fri, 28 Jun 2019 08:49:36 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/2 nf-next v3] netfilter: nft_meta: Add NFT_META_BRI_IIFVPROTO support
Date:   Fri, 28 Jun 2019 08:49:34 +0800
Message-Id: <1561682975-21790-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVOSkxCQkJDQ0xPTU1PSFlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NBQ6Cxw4Nzg0HAs0Ik9PKxQX
        F01PC0lVSlVKTk1KTUNJQkxNQ0NLVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlNS0w3Bg++
X-HM-Tid: 0a6b9b8f205020bdkuqycb503e016fa
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
+ * @NFT_META_BRI_IIFVPROTO: packet input bridge vlan proto
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -827,6 +828,7 @@ enum nft_meta_keys {
 	NFT_META_IIFKIND,
 	NFT_META_OIFKIND,
 	NFT_META_BRI_PVID,
+	NFT_META_BRI_IIFVPROTO,
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
+	case NFT_META_BRI_IIFVPROTO:
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
+	case NFT_META_BRI_IIFVPROTO:
 		if (ctx->family != NFPROTO_BRIDGE)
 			return -EOPNOTSUPP;
 		len = sizeof(u16);
-- 
1.8.3.1

