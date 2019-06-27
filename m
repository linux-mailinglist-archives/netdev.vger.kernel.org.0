Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41C065831C
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 15:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfF0NHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 09:07:20 -0400
Received: from m9783.mail.qiye.163.com ([220.181.97.83]:42646 "EHLO
        m9783.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfF0NHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 09:07:20 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9783.mail.qiye.163.com (Hmail) with ESMTPA id CD85FC1B54;
        Thu, 27 Jun 2019 21:07:16 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2/2 nf-next v2] netfilter:nft_meta: add NFT_META_VLAN support
Date:   Thu, 27 Jun 2019 21:07:15 +0800
Message-Id: <1561640835-4507-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1561640835-4507-1-git-send-email-wenxu@ucloud.cn>
References: <1561640835-4507-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS09DS0tLSUpNT0NPS0xZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Kxg6HCo4GjgzMgs3VigQUQMf
        NRVPCStVSlVKTk1KTU9LQ0hNQk9LVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU9ITUw3Bg++
X-HM-Tid: 0a6b990c1eff2085kuqycd85fc1b54
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch provide a meta vlan to set the vlan tag of the packet.

for q-in-q vlan id 20:
meta vlan set 0x88a8:20

set the default 0x8100 vlan type with vlan id 20
meta vlan set 20

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/uapi/linux/netfilter/nf_tables.h |  4 ++++
 net/netfilter/nft_meta.c                 | 27 ++++++++++++++++++++++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 0f75a6d..acb8b75 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -798,6 +798,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_BRI_PVID: packet input bridge port pvid
  * @NFT_META_BRI_IIFVPROTO: packet input bridge port vlan proto
  * @NFT_META_BRI_OIFVPROTO: packet output bridge port vlan proto
+ * @NFT_META_VLAN: packet vlan metadata
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -831,6 +832,7 @@ enum nft_meta_keys {
 	NFT_META_BRI_PVID,
 	NFT_META_BRI_IIFVPROTO,
 	NFT_META_BRI_OIFVPROTO,
+	NFT_META_VLAN,
 };
 
 /**
@@ -897,12 +899,14 @@ enum nft_hash_attributes {
  * @NFTA_META_DREG: destination register (NLA_U32)
  * @NFTA_META_KEY: meta data item to load (NLA_U32: nft_meta_keys)
  * @NFTA_META_SREG: source register (NLA_U32)
+ * @NFTA_META_SREG2: source register (NLA_U32)
  */
 enum nft_meta_attributes {
 	NFTA_META_UNSPEC,
 	NFTA_META_DREG,
 	NFTA_META_KEY,
 	NFTA_META_SREG,
+	NFTA_META_SREG2,
 	__NFTA_META_MAX
 };
 #define NFTA_META_MAX		(__NFTA_META_MAX - 1)
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index e7e10fb..53f4547 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -28,7 +28,10 @@ struct nft_meta {
 	enum nft_meta_keys	key:8;
 	union {
 		enum nft_registers	dreg:8;
-		enum nft_registers	sreg:8;
+		struct {
+			enum nft_registers	sreg:8;
+			enum nft_registers	sreg2:8;
+		};
 	};
 };
 
@@ -320,6 +323,17 @@ static void nft_meta_set_eval(const struct nft_expr *expr,
 		skb->secmark = value;
 		break;
 #endif
+	case NFT_META_VLAN: {
+		u32 *sreg2 = &regs->data[meta->sreg2];
+		__be16 vlan_proto;
+		u16 vlan_tci;
+
+		vlan_tci = nft_reg_load16(sreg);
+		vlan_proto = nft_reg_load16(sreg2);
+
+		__vlan_hwaccel_put_tag(skb, vlan_proto, vlan_tci);
+		break;
+	}
 	default:
 		WARN_ON(1);
 	}
@@ -329,6 +343,7 @@ static void nft_meta_set_eval(const struct nft_expr *expr,
 	[NFTA_META_DREG]	= { .type = NLA_U32 },
 	[NFTA_META_KEY]		= { .type = NLA_U32 },
 	[NFTA_META_SREG]	= { .type = NLA_U32 },
+	[NFTA_META_SREG2]	= { .type = NLA_U32 },
 };
 
 static int nft_meta_get_init(const struct nft_ctx *ctx,
@@ -492,6 +507,13 @@ static int nft_meta_set_init(const struct nft_ctx *ctx,
 	case NFT_META_PKTTYPE:
 		len = sizeof(u8);
 		break;
+	case NFT_META_VLAN:
+		len = sizeof(u16);
+		priv->sreg2 = nft_parse_register(tb[NFTA_META_SREG2]);
+		err = nft_validate_register_load(priv->sreg2, len);
+		if (err < 0)
+			return err;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -530,6 +552,9 @@ static int nft_meta_set_dump(struct sk_buff *skb, const struct nft_expr *expr)
 		goto nla_put_failure;
 	if (nft_dump_register(skb, NFTA_META_SREG, priv->sreg))
 		goto nla_put_failure;
+	if (priv->key == NFT_META_VLAN &&
+	    nft_dump_register(skb, NFTA_META_SREG2, priv->sreg2))
+		goto nla_put_failure;
 
 	return 0;
 
-- 
1.8.3.1

