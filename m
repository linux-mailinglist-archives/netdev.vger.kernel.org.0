Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A897A3D1479
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235120AbhGUQFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 12:05:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46607 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235088AbhGUQE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 12:04:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626885931;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T+VSQANDtJEmceTdjzdkoW5CoFJtWgBn/llc4BbwYlA=;
        b=bml0F2tQSM0soFZbA+X9LDy+fyqADHrO4Z9s56VqddUzwcLYLG5rNrhSXcezKwuNZisWIb
        rZdj5S8MYfcvBPU9gXCDmxflNr0J5rjHUuXOmb5oele3W9JZ8lk+okGp/Pv5702mKoa70g
        +M4zWur0fpanWqDbdCrfWyTrba9DU/E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-Ss2ZgFVJM_-NdQlcJEhKnQ-1; Wed, 21 Jul 2021 12:45:28 -0400
X-MC-Unique: Ss2ZgFVJM_-NdQlcJEhKnQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F2EA824F89;
        Wed, 21 Jul 2021 16:45:27 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-219.ams2.redhat.com [10.36.114.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D10AA797CB;
        Wed, 21 Jul 2021 16:45:25 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Subject: [PATCH RFC 9/9] sk_buff: access secmark via getter/setter
Date:   Wed, 21 Jul 2021 18:44:41 +0200
Message-Id: <aa0d2603aeaf70ec4d40997e65a95520087792d3.1626882513.git.pabeni@redhat.com>
In-Reply-To: <cover.1626882513.git.pabeni@redhat.com>
References: <cover.1626882513.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So we can track the field status and move it after tail.

After this commit the skb lifecycle for simple cases (no ct, no secmark,
no vlan, no UDP tunnel) uses 3 cacheline instead of 4 cachelines required
before this series.

e.g. GRO for non vlan traffic will consistently uses 3 cacheline for
each packet.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/linux/skbuff.h           | 40 ++++++++++++++++++++++----------
 net/core/skbuff.c                |  7 +++---
 net/netfilter/nfnetlink_queue.c  |  6 +++--
 net/netfilter/nft_meta.c         |  6 ++---
 net/netfilter/xt_CONNSECMARK.c   |  8 +++----
 net/netfilter/xt_SECMARK.c       |  2 +-
 security/apparmor/lsm.c          | 15 +++++++-----
 security/selinux/hooks.c         | 10 ++++----
 security/smack/smack_lsm.c       |  4 ++--
 security/smack/smack_netfilter.c |  4 ++--
 10 files changed, 62 insertions(+), 40 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 7acf2a203918..941c0f858c65 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -688,6 +688,7 @@ typedef unsigned char *sk_buff_data_t;
  *		CHECKSUM_UNNECESSARY (max 3)
  *	@dst_pending_confirm: need to confirm neighbour
  *	@decrypted: Decrypted SKB
+ *	@secmark_present: the secmark tag is present
  *	@_state: bitmap reporting the presence of some skb state info
  *	@has_nfct: @_state bit for nfct info
  *	@has_dst: @_state bit for dst pointer
@@ -695,7 +696,7 @@ typedef unsigned char *sk_buff_data_t;
  *	@active_extensions: @_state bits for active extensions (skb_ext_id types)
  *	@napi_id: id of the NAPI struct this skb came from
  *	@sender_cpu: (aka @napi_id) source CPU in XPS
- *	@secmark: security marking
+ *	@_secmark: security marking
  *	@mark: Generic packet mark
  *	@reserved_tailroom: (aka @mark) number of bytes of free space available
  *		at the tail of an sk_buff
@@ -870,6 +871,9 @@ struct sk_buff {
 #endif
 #ifdef CONFIG_TLS_DEVICE
 	__u8			decrypted:1;
+#endif
+#ifdef CONFIG_NETWORK_SECMARK
+	__u8			secmark_present:1;
 #endif
 	union {
 		__u8		_state;		/* state of extended fields */
@@ -903,9 +907,6 @@ struct sk_buff {
 		unsigned int	sender_cpu;
 	};
 #endif
-#ifdef CONFIG_NETWORK_SECMARK
-	__u32		secmark;
-#endif
 
 	union {
 		__u32		mark;
@@ -961,6 +962,9 @@ struct sk_buff {
 		};
 		__u32		vlan_info;
 	};
+#ifdef CONFIG_NETWORK_SECMARK
+	__u32			_secmark;
+#endif
 };
 
 #ifdef __KERNEL__
@@ -4228,6 +4232,23 @@ static inline void skb_remcsum_process(struct sk_buff *skb, void *ptr,
 	skb->csum = csum_add(skb->csum, delta);
 }
 
+static inline __u32 skb_secmark(const struct sk_buff *skb)
+{
+#if IS_ENABLED(CONFIG_NETWORK_SECMARK)
+	return skb->secmark_present ? skb->_secmark : 0;
+#else
+	return NULL;
+#endif
+}
+
+static inline void skb_set_secmark(struct sk_buff *skb, __u32 secmark)
+{
+#if IS_ENABLED(CONFIG_NETWORK_SECMARK)
+	skb->secmark_present = 1;
+	skb->_secmark = secmark;
+#endif
+}
+
 static inline struct nf_conntrack *skb_nfct(const struct sk_buff *skb)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
@@ -4414,19 +4435,14 @@ static inline void nf_copy(struct sk_buff *dst, const struct sk_buff *src)
 #ifdef CONFIG_NETWORK_SECMARK
 static inline void skb_copy_secmark(struct sk_buff *to, const struct sk_buff *from)
 {
-	to->secmark = from->secmark;
-}
-
-static inline void skb_init_secmark(struct sk_buff *skb)
-{
-	skb->secmark = 0;
+	to->secmark_present = from->secmark_present;
+	if (from->_secmark)
+		to->_secmark = from->_secmark;
 }
 #else
 static inline void skb_copy_secmark(struct sk_buff *to, const struct sk_buff *from)
 { }
 
-static inline void skb_init_secmark(struct sk_buff *skb)
-{ }
 #endif
 
 static inline int secpath_exists(const struct sk_buff *skb)
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index c59e90db80d5..704aecbde60d 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -998,6 +998,10 @@ static void __copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
 	__skb_copy_inner_headers(new, old);
 	if (old->vlan_present)
 		new->vlan_info = old->vlan_info;
+#ifdef CONFIG_NETWORK_SECMARK
+	if (old->_secmark)
+		new->_secmark = old->_secmark;
+#endif
 
 	/* Note : this field could be in headers_start/headers_end section
 	 * It is not yet because we do not want to have a 16 bit hole
@@ -1019,9 +1023,6 @@ static void __copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
 	CHECK_SKB_FIELD(network_header);
 	CHECK_SKB_FIELD(mac_header);
 	CHECK_SKB_FIELD(mark);
-#ifdef CONFIG_NETWORK_SECMARK
-	CHECK_SKB_FIELD(secmark);
-#endif
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	CHECK_SKB_FIELD(napi_id);
 #endif
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index f774de0fc24f..cf00d4286187 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -304,14 +304,16 @@ static int nfqnl_put_sk_uidgid(struct sk_buff *skb, struct sock *sk)
 static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
 {
 	u32 seclen = 0;
+	u32 secmark;
 #if IS_ENABLED(CONFIG_NETWORK_SECMARK)
 	if (!skb || !sk_fullsock(skb->sk))
 		return 0;
 
 	read_lock_bh(&skb->sk->sk_callback_lock);
 
-	if (skb->secmark)
-		security_secid_to_secctx(skb->secmark, secdata, &seclen);
+	secmark = skb_secmark(skb);
+	if (secmark)
+		security_secid_to_secctx(secmark, secdata, &seclen);
 
 	read_unlock_bh(&skb->sk->sk_callback_lock);
 #endif
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index a7e01e9952f1..da4bc455d8bd 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -363,7 +363,7 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 #endif
 #ifdef CONFIG_NETWORK_SECMARK
 	case NFT_META_SECMARK:
-		*dest = skb->secmark;
+		*dest = skb_secmark(skb);
 		break;
 #endif
 	case NFT_META_PKTTYPE:
@@ -451,7 +451,7 @@ void nft_meta_set_eval(const struct nft_expr *expr,
 		break;
 #ifdef CONFIG_NETWORK_SECMARK
 	case NFT_META_SECMARK:
-		skb->secmark = value;
+		skb_set_secmark(skb, value);
 		break;
 #endif
 	default:
@@ -833,7 +833,7 @@ static void nft_secmark_obj_eval(struct nft_object *obj, struct nft_regs *regs,
 	const struct nft_secmark *priv = nft_obj_data(obj);
 	struct sk_buff *skb = pkt->skb;
 
-	skb->secmark = priv->secid;
+	skb_set_secmark(skb, priv->secid);
 }
 
 static int nft_secmark_obj_init(const struct nft_ctx *ctx,
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 76acecf3e757..26f4fbc04c0b 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -31,13 +31,13 @@ MODULE_ALIAS("ip6t_CONNSECMARK");
  */
 static void secmark_save(const struct sk_buff *skb)
 {
-	if (skb->secmark) {
+	if (skb_secmark(skb)) {
 		struct nf_conn *ct;
 		enum ip_conntrack_info ctinfo;
 
 		ct = nf_ct_get(skb, &ctinfo);
 		if (ct && !ct->secmark) {
-			ct->secmark = skb->secmark;
+			ct->secmark = skb_secmark(skb);
 			nf_conntrack_event_cache(IPCT_SECMARK, ct);
 		}
 	}
@@ -49,13 +49,13 @@ static void secmark_save(const struct sk_buff *skb)
  */
 static void secmark_restore(struct sk_buff *skb)
 {
-	if (!skb->secmark) {
+	if (!skb_secmark(skb)) {
 		const struct nf_conn *ct;
 		enum ip_conntrack_info ctinfo;
 
 		ct = nf_ct_get(skb, &ctinfo);
 		if (ct && ct->secmark)
-			skb->secmark = ct->secmark;
+			skb_set_secmark(skb, ct->secmark);
 	}
 }
 
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 498a0bf6f044..bc383bc2bba9 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -36,7 +36,7 @@ secmark_tg(struct sk_buff *skb, const struct xt_secmark_target_info_v1 *info)
 		BUG();
 	}
 
-	skb->secmark = secmark;
+	skb_set_secmark(skb, secmark);
 	return XT_CONTINUE;
 }
 
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index f72406fe1bf2..afbae187b920 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -1053,12 +1053,13 @@ static int apparmor_socket_shutdown(struct socket *sock, int how)
 static int apparmor_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 {
 	struct aa_sk_ctx *ctx = SK_CTX(sk);
+	u32 secmark = skb_secmark(skb);
 
-	if (!skb->secmark)
+	if (!secmark)
 		return 0;
 
 	return apparmor_secmark_check(ctx->label, OP_RECVMSG, AA_MAY_RECEIVE,
-				      skb->secmark, sk);
+				      secmark, sk);
 }
 #endif
 
@@ -1160,12 +1161,13 @@ static int apparmor_inet_conn_request(const struct sock *sk, struct sk_buff *skb
 				      struct request_sock *req)
 {
 	struct aa_sk_ctx *ctx = SK_CTX(sk);
+	u32 secmark = skb_secmark(skb);
 
-	if (!skb->secmark)
+	if (!secmark)
 		return 0;
 
 	return apparmor_secmark_check(ctx->label, OP_CONNECT, AA_MAY_CONNECT,
-				      skb->secmark, sk);
+				      secmark, sk);
 }
 #endif
 
@@ -1754,10 +1756,11 @@ static unsigned int apparmor_ip_postroute(void *priv,
 					  struct sk_buff *skb,
 					  const struct nf_hook_state *state)
 {
+	u32 secmark = skb_secmark(skb);
 	struct aa_sk_ctx *ctx;
 	struct sock *sk;
 
-	if (!skb->secmark)
+	if (!secmark)
 		return NF_ACCEPT;
 
 	sk = skb_to_full_sk(skb);
@@ -1766,7 +1769,7 @@ static unsigned int apparmor_ip_postroute(void *priv,
 
 	ctx = SK_CTX(sk);
 	if (!apparmor_secmark_check(ctx->label, OP_SENDMSG, AA_MAY_SEND,
-				    skb->secmark, sk))
+				    secmark, sk))
 		return NF_ACCEPT;
 
 	return NF_DROP_ERR(-ECONNREFUSED);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index b0032c42333e..898b81ba7566 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5138,7 +5138,7 @@ static int selinux_sock_rcv_skb_compat(struct sock *sk, struct sk_buff *skb,
 
 	if (selinux_secmark_enabled()) {
 		err = avc_has_perm(&selinux_state,
-				   sk_sid, skb->secmark, SECCLASS_PACKET,
+				   sk_sid, skb_secmark(skb), SECCLASS_PACKET,
 				   PACKET__RECV, &ad);
 		if (err)
 			return err;
@@ -5214,7 +5214,7 @@ static int selinux_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 
 	if (secmark_active) {
 		err = avc_has_perm(&selinux_state,
-				   sk_sid, skb->secmark, SECCLASS_PACKET,
+				   sk_sid, skb_secmark(skb), SECCLASS_PACKET,
 				   PACKET__RECV, &ad);
 		if (err)
 			return err;
@@ -5727,7 +5727,7 @@ static unsigned int selinux_ip_forward(struct sk_buff *skb,
 
 	if (secmark_active)
 		if (avc_has_perm(&selinux_state,
-				 peer_sid, skb->secmark,
+				 peer_sid, skb_secmark(skb),
 				 SECCLASS_PACKET, PACKET__FORWARD_IN, &ad))
 			return NF_DROP;
 
@@ -5840,7 +5840,7 @@ static unsigned int selinux_ip_postroute_compat(struct sk_buff *skb,
 
 	if (selinux_secmark_enabled())
 		if (avc_has_perm(&selinux_state,
-				 sksec->sid, skb->secmark,
+				 sksec->sid, skb_secmark(skb),
 				 SECCLASS_PACKET, PACKET__SEND, &ad))
 			return NF_DROP_ERR(-ECONNREFUSED);
 
@@ -5964,7 +5964,7 @@ static unsigned int selinux_ip_postroute(struct sk_buff *skb,
 
 	if (secmark_active)
 		if (avc_has_perm(&selinux_state,
-				 peer_sid, skb->secmark,
+				 peer_sid, skb_secmark(skb),
 				 SECCLASS_PACKET, secmark_perm, &ad))
 			return NF_DROP_ERR(-ECONNREFUSED);
 
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 223a6da0e6dc..2ed19e2db66a 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3840,10 +3840,10 @@ static int smk_skb_to_addr_ipv6(struct sk_buff *skb, struct sockaddr_in6 *sip)
 #ifdef CONFIG_NETWORK_SECMARK
 static struct smack_known *smack_from_skb(struct sk_buff *skb)
 {
-	if (skb == NULL || skb->secmark == 0)
+	if (skb == NULL || skb_secmark(skb) == 0)
 		return NULL;
 
-	return smack_from_secid(skb->secmark);
+	return smack_from_secid(skb_secmark(skb));
 }
 #else
 static inline struct smack_known *smack_from_skb(struct sk_buff *skb)
diff --git a/security/smack/smack_netfilter.c b/security/smack/smack_netfilter.c
index fc7399b45373..881143e62eb4 100644
--- a/security/smack/smack_netfilter.c
+++ b/security/smack/smack_netfilter.c
@@ -31,7 +31,7 @@ static unsigned int smack_ipv6_output(void *priv,
 	if (sk && sk->sk_security) {
 		ssp = sk->sk_security;
 		skp = ssp->smk_out;
-		skb->secmark = skp->smk_secid;
+		skb_set_secmark(skb, skp->smk_secid);
 	}
 
 	return NF_ACCEPT;
@@ -49,7 +49,7 @@ static unsigned int smack_ipv4_output(void *priv,
 	if (sk && sk->sk_security) {
 		ssp = sk->sk_security;
 		skp = ssp->smk_out;
-		skb->secmark = skp->smk_secid;
+		skb_set_secmark(skb, skp->smk_secid);
 	}
 
 	return NF_ACCEPT;
-- 
2.26.3

