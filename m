Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F199636B7A4
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235546AbhDZRLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:11:49 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51468 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235389AbhDZRLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 13:11:46 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7B46264124;
        Mon, 26 Apr 2021 19:10:26 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 02/22] netfilter: nft_socket: add support for cgroupsv2
Date:   Mon, 26 Apr 2021 19:10:36 +0200
Message-Id: <20210426171056.345271-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210426171056.345271-1-pablo@netfilter.org>
References: <20210426171056.345271-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow to match on the cgroupsv2 id from ancestor level.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  4 ++
 net/netfilter/nft_socket.c               | 48 +++++++++++++++++++++++-
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 79bab7a36b30..467365ed59a7 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1014,11 +1014,13 @@ enum nft_rt_attributes {
  *
  * @NFTA_SOCKET_KEY: socket key to match
  * @NFTA_SOCKET_DREG: destination register
+ * @NFTA_SOCKET_LEVEL: cgroups2 ancestor level (only for cgroupsv2)
  */
 enum nft_socket_attributes {
 	NFTA_SOCKET_UNSPEC,
 	NFTA_SOCKET_KEY,
 	NFTA_SOCKET_DREG,
+	NFTA_SOCKET_LEVEL,
 	__NFTA_SOCKET_MAX
 };
 #define NFTA_SOCKET_MAX		(__NFTA_SOCKET_MAX - 1)
@@ -1029,11 +1031,13 @@ enum nft_socket_attributes {
  * @NFT_SOCKET_TRANSPARENT: Value of the IP(V6)_TRANSPARENT socket option
  * @NFT_SOCKET_MARK: Value of the socket mark
  * @NFT_SOCKET_WILDCARD: Whether the socket is zero-bound (e.g. 0.0.0.0 or ::0)
+ * @NFT_SOCKET_CGROUPV2: Match on cgroups version 2
  */
 enum nft_socket_keys {
 	NFT_SOCKET_TRANSPARENT,
 	NFT_SOCKET_MARK,
 	NFT_SOCKET_WILDCARD,
+	NFT_SOCKET_CGROUPV2,
 	__NFT_SOCKET_MAX
 };
 #define NFT_SOCKET_MAX	(__NFT_SOCKET_MAX - 1)
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index c9b8a2b03b71..9c169d100651 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -9,6 +9,7 @@
 
 struct nft_socket {
 	enum nft_socket_keys		key:8;
+	u8				level;
 	union {
 		u8			dreg;
 	};
@@ -33,6 +34,26 @@ static void nft_socket_wildcard(const struct nft_pktinfo *pkt,
 	}
 }
 
+#ifdef CONFIG_CGROUPS
+static noinline bool
+nft_sock_get_eval_cgroupv2(u32 *dest, const struct nft_pktinfo *pkt, u32 level)
+{
+	struct sock *sk = skb_to_full_sk(pkt->skb);
+	struct cgroup *cgrp;
+
+	if (!sk || !sk_fullsock(sk) || !net_eq(nft_net(pkt), sock_net(sk)))
+		return false;
+
+	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
+	if (level > cgrp->level)
+		return false;
+
+	memcpy(dest, &cgrp->ancestor_ids[level], sizeof(u64));
+
+	return true;
+}
+#endif
+
 static void nft_socket_eval(const struct nft_expr *expr,
 			    struct nft_regs *regs,
 			    const struct nft_pktinfo *pkt)
@@ -85,6 +106,14 @@ static void nft_socket_eval(const struct nft_expr *expr,
 		}
 		nft_socket_wildcard(pkt, regs, sk, dest);
 		break;
+#ifdef CONFIG_CGROUPS
+	case NFT_SOCKET_CGROUPV2:
+		if (!nft_sock_get_eval_cgroupv2(dest, pkt, priv->level)) {
+			regs->verdict.code = NFT_BREAK;
+			return;
+		}
+		break;
+#endif
 	default:
 		WARN_ON(1);
 		regs->verdict.code = NFT_BREAK;
@@ -97,6 +126,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
 static const struct nla_policy nft_socket_policy[NFTA_SOCKET_MAX + 1] = {
 	[NFTA_SOCKET_KEY]		= { .type = NLA_U32 },
 	[NFTA_SOCKET_DREG]		= { .type = NLA_U32 },
+	[NFTA_SOCKET_LEVEL]		= { .type = NLA_U32 },
 };
 
 static int nft_socket_init(const struct nft_ctx *ctx,
@@ -104,7 +134,7 @@ static int nft_socket_init(const struct nft_ctx *ctx,
 			   const struct nlattr * const tb[])
 {
 	struct nft_socket *priv = nft_expr_priv(expr);
-	unsigned int len;
+	unsigned int len, level;
 
 	if (!tb[NFTA_SOCKET_DREG] || !tb[NFTA_SOCKET_KEY])
 		return -EINVAL;
@@ -129,6 +159,19 @@ static int nft_socket_init(const struct nft_ctx *ctx,
 	case NFT_SOCKET_MARK:
 		len = sizeof(u32);
 		break;
+#ifdef CONFIG_CGROUPS
+	case NFT_SOCKET_CGROUPV2:
+		if (!tb[NFTA_SOCKET_LEVEL])
+			return -EINVAL;
+
+		level = ntohl(nla_get_u32(tb[NFTA_SOCKET_LEVEL]));
+		if (level > 255)
+			return -EOPNOTSUPP;
+
+		priv->level = level;
+		len = sizeof(u64);
+		break;
+#endif
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -146,6 +189,9 @@ static int nft_socket_dump(struct sk_buff *skb,
 		return -1;
 	if (nft_dump_register(skb, NFTA_SOCKET_DREG, priv->dreg))
 		return -1;
+	if (priv->key == NFT_SOCKET_CGROUPV2 &&
+	    nla_put_u32(skb, NFTA_SOCKET_LEVEL, htonl(priv->level)))
+		return -1;
 	return 0;
 }
 
-- 
2.30.2

