Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9B62B9B24
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 20:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgKSTER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 14:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbgKSTER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 14:04:17 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18514C0613D4
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 11:04:17 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id k4so6425389qko.13
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 11:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=0YtGoHueYGNUCpG0ghR5XLFVwiNR9rpqK5SxYyjWmWo=;
        b=uAqjHLhPLd0euo9g035Sw6Jrx8AQmGpNVEkP62CydXq4CISgD+wANg6sgs8/NDzTCY
         8GJAjyXbwXzC9LS3FeXZKj7eJ5twGbxwku5O6aT99IZHg4aHasjDFMFvJ4hgX0YtN02A
         0KFfaujLscXUXjhVHg5TWURqmiU6tBuZyBp4ZxMQrsp9PFftMwbZilRKYbJhdaNLZ2E/
         7OQYd7POKLgpHYj2Du5fP1428qifWa+LyRrXzzlD7bB4FqQFPlKjVRqiGIgaKEbD1AGX
         gZIE6LJTWAFWwUQoeOdEa0dTArG16u5kiNT0kpuNz0wmKz8/oo0p3OpIcE6PXqA6IRSQ
         uIPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=0YtGoHueYGNUCpG0ghR5XLFVwiNR9rpqK5SxYyjWmWo=;
        b=qDpq/JaYsF5axDPxMP2BPa2rpotCMYl65Ty7USo919I7KRa5wX/iviJH7NljqbtUZX
         97O4z3ehYc9tJ+UEMJj9/XS+B8qoENnTiUjeknBnKx5lxRs73Vs9hduTXGHQpreDQD10
         dK9NmUO6YZlZQr/eybA5E1iALQ8+Op+taqZtZOBB71O7fFHz/o0E4gIvADzNQyvIxUUD
         TBFM3RMTRbVKjMuHB0Eq4NEppE/oedJRVDgBewcSv9egcgIjkBxDGLs2SWRb/B1z+BSk
         tkcpxVbeiKVYMSuMhdGAIMtKmCdgkTKOVLIDPlhJ8aeGjK+sK3AiZg+g7SKVxmD1Gihu
         nl+A==
X-Gm-Message-State: AOAM531sl8MbmG+MCv1jphHPRym48IKxac8GT3KJberbOm3u+806LDgM
        40LkJCvpvPBpsRIUYaxIqfBj
X-Google-Smtp-Source: ABdhPJzaYOj72Xnd5gYnzt+repWP+nkKD+TlrAu/lTS46mU3/LGLcfxjEPH8Z+84PW9ctlqTJCOaKQ==
X-Received: by 2002:a37:a7d1:: with SMTP id q200mr12001247qke.283.1605812655849;
        Thu, 19 Nov 2020 11:04:15 -0800 (PST)
Received: from localhost (pool-96-230-24-152.bstnma.fios.verizon.net. [96.230.24.152])
        by smtp.gmail.com with ESMTPSA id l22sm453721qke.118.2020.11.19.11.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 11:04:15 -0800 (PST)
Subject: [PATCH] lsm,selinux: pass flowi_common instead of flowi to the LSM
 hooks
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        selinux@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu, 19 Nov 2020 14:04:14 -0500
Message-ID: <160581265397.2575.2287441525647057669.stgit@sifl>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As pointed out by Herbert in a recent related patch, the LSM hooks do
not have the necessary address family information to use the flowi
struct safely.  As none of the LSMs currently use any of the protocol
specific flowi information, replace the flowi pointers with pointers
to the address family independent flowi_common struct.

Reported-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 .../chelsio/inline_crypto/chtls/chtls_cm.c         |    2 +-
 drivers/net/wireguard/socket.c                     |    4 ++-
 include/linux/lsm_hook_defs.h                      |    4 ++-
 include/linux/lsm_hooks.h                          |    2 +-
 include/linux/security.h                           |   23 ++++++++++++--------
 include/net/flow.h                                 |   10 +++++++++
 include/net/route.h                                |    6 +++--
 net/dccp/ipv4.c                                    |    2 +-
 net/dccp/ipv6.c                                    |    6 +++--
 net/ipv4/icmp.c                                    |    4 ++-
 net/ipv4/inet_connection_sock.c                    |    4 ++-
 net/ipv4/ip_output.c                               |    2 +-
 net/ipv4/ping.c                                    |    2 +-
 net/ipv4/raw.c                                     |    2 +-
 net/ipv4/syncookies.c                              |    2 +-
 net/ipv4/udp.c                                     |    2 +-
 net/ipv6/af_inet6.c                                |    2 +-
 net/ipv6/datagram.c                                |    2 +-
 net/ipv6/icmp.c                                    |    6 +++--
 net/ipv6/inet6_connection_sock.c                   |    4 ++-
 net/ipv6/netfilter/nf_reject_ipv6.c                |    2 +-
 net/ipv6/ping.c                                    |    2 +-
 net/ipv6/raw.c                                     |    2 +-
 net/ipv6/syncookies.c                              |    2 +-
 net/ipv6/tcp_ipv6.c                                |    4 ++-
 net/ipv6/udp.c                                     |    2 +-
 net/l2tp/l2tp_ip6.c                                |    2 +-
 net/netfilter/nf_synproxy_core.c                   |    2 +-
 net/xfrm/xfrm_state.c                              |    6 +++--
 security/security.c                                |   17 ++++++++-------
 security/selinux/hooks.c                           |    4 ++-
 security/selinux/include/xfrm.h                    |    2 +-
 security/selinux/xfrm.c                            |   13 ++++++-----
 33 files changed, 85 insertions(+), 66 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index ec4f79049a06..42e4e43cdd91 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -1148,7 +1148,7 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 		fl6.daddr = ip6h->saddr;
 		fl6.fl6_dport = inet_rsk(oreq)->ir_rmt_port;
 		fl6.fl6_sport = htons(inet_rsk(oreq)->ir_num);
-		security_req_classify_flow(oreq, flowi6_to_flowi(&fl6));
+		security_req_classify_flow(oreq, flowi6_to_flowi_common(&fl6));
 		dst = ip6_dst_lookup_flow(sock_net(lsk), lsk, &fl6, NULL);
 		if (IS_ERR(dst))
 			goto free_sk;
diff --git a/drivers/net/wireguard/socket.c b/drivers/net/wireguard/socket.c
index c33e2c81635f..410b318e57fb 100644
--- a/drivers/net/wireguard/socket.c
+++ b/drivers/net/wireguard/socket.c
@@ -49,7 +49,7 @@ static int send4(struct wg_device *wg, struct sk_buff *skb,
 		rt = dst_cache_get_ip4(cache, &fl.saddr);
 
 	if (!rt) {
-		security_sk_classify_flow(sock, flowi4_to_flowi(&fl));
+		security_sk_classify_flow(sock, flowi4_to_flowi_common(&fl));
 		if (unlikely(!inet_confirm_addr(sock_net(sock), NULL, 0,
 						fl.saddr, RT_SCOPE_HOST))) {
 			endpoint->src4.s_addr = 0;
@@ -129,7 +129,7 @@ static int send6(struct wg_device *wg, struct sk_buff *skb,
 		dst = dst_cache_get_ip6(cache, &fl.saddr);
 
 	if (!dst) {
-		security_sk_classify_flow(sock, flowi6_to_flowi(&fl));
+		security_sk_classify_flow(sock, flowi6_to_flowi_common(&fl));
 		if (unlikely(!ipv6_addr_any(&fl.saddr) &&
 			     !ipv6_chk_addr(sock_net(sock), &fl.saddr, NULL, 0))) {
 			endpoint->src6 = fl.saddr = in6addr_any;
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 32a940117e7a..f70984c8318b 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -311,7 +311,7 @@ LSM_HOOK(int, 0, secmark_relabel_packet, u32 secid)
 LSM_HOOK(void, LSM_RET_VOID, secmark_refcount_inc, void)
 LSM_HOOK(void, LSM_RET_VOID, secmark_refcount_dec, void)
 LSM_HOOK(void, LSM_RET_VOID, req_classify_flow, const struct request_sock *req,
-	 struct flowi *fl)
+	 struct flowi_common *flic)
 LSM_HOOK(int, 0, tun_dev_alloc_security, void **security)
 LSM_HOOK(void, LSM_RET_VOID, tun_dev_free_security, void *security)
 LSM_HOOK(int, 0, tun_dev_create, void)
@@ -351,7 +351,7 @@ LSM_HOOK(int, 0, xfrm_state_delete_security, struct xfrm_state *x)
 LSM_HOOK(int, 0, xfrm_policy_lookup, struct xfrm_sec_ctx *ctx, u32 fl_secid,
 	 u8 dir)
 LSM_HOOK(int, 1, xfrm_state_pol_flow_match, struct xfrm_state *x,
-	 struct xfrm_policy *xp, const struct flowi *fl)
+	 struct xfrm_policy *xp, const struct flowi_common *flic)
 LSM_HOOK(int, 0, xfrm_decode_session, struct sk_buff *skb, u32 *secid,
 	 int ckall)
 #endif /* CONFIG_SECURITY_NETWORK_XFRM */
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index c503f7ab8afb..a19adef1f088 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1105,7 +1105,7 @@
  * @xfrm_state_pol_flow_match:
  *	@x contains the state to match.
  *	@xp contains the policy to check for a match.
- *	@fl contains the flow to check for a match.
+ *	@flic contains the flowi_common struct to check for a match.
  *	Return 1 if there is a match.
  * @xfrm_decode_session:
  *	@skb points to skb to decode.
diff --git a/include/linux/security.h b/include/linux/security.h
index bc2725491560..469273e8b46d 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -167,7 +167,7 @@ struct sk_buff;
 struct sock;
 struct sockaddr;
 struct socket;
-struct flowi;
+struct flowi_common;
 struct dst_entry;
 struct xfrm_selector;
 struct xfrm_policy;
@@ -1355,8 +1355,9 @@ int security_socket_getpeersec_dgram(struct socket *sock, struct sk_buff *skb, u
 int security_sk_alloc(struct sock *sk, int family, gfp_t priority);
 void security_sk_free(struct sock *sk);
 void security_sk_clone(const struct sock *sk, struct sock *newsk);
-void security_sk_classify_flow(struct sock *sk, struct flowi *fl);
-void security_req_classify_flow(const struct request_sock *req, struct flowi *fl);
+void security_sk_classify_flow(struct sock *sk, struct flowi_common *flic);
+void security_req_classify_flow(const struct request_sock *req,
+				struct flowi_common *flic);
 void security_sock_graft(struct sock*sk, struct socket *parent);
 int security_inet_conn_request(struct sock *sk,
 			struct sk_buff *skb, struct request_sock *req);
@@ -1507,11 +1508,13 @@ static inline void security_sk_clone(const struct sock *sk, struct sock *newsk)
 {
 }
 
-static inline void security_sk_classify_flow(struct sock *sk, struct flowi *fl)
+static inline void security_sk_classify_flow(struct sock *sk,
+					     struct flowi_common *flic)
 {
 }
 
-static inline void security_req_classify_flow(const struct request_sock *req, struct flowi *fl)
+static inline void security_req_classify_flow(const struct request_sock *req,
+					      struct flowi_common *flic)
 {
 }
 
@@ -1638,9 +1641,9 @@ void security_xfrm_state_free(struct xfrm_state *x);
 int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir);
 int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
 				       struct xfrm_policy *xp,
-				       const struct flowi *fl);
+				       const struct flowi_common *flic);
 int security_xfrm_decode_session(struct sk_buff *skb, u32 *secid);
-void security_skb_classify_flow(struct sk_buff *skb, struct flowi *fl);
+void security_skb_classify_flow(struct sk_buff *skb, struct flowi_common *flic);
 
 #else	/* CONFIG_SECURITY_NETWORK_XFRM */
 
@@ -1692,7 +1695,8 @@ static inline int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_s
 }
 
 static inline int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
-			struct xfrm_policy *xp, const struct flowi *fl)
+						     struct xfrm_policy *xp,
+						     const struct flowi_common *flic)
 {
 	return 1;
 }
@@ -1702,7 +1706,8 @@ static inline int security_xfrm_decode_session(struct sk_buff *skb, u32 *secid)
 	return 0;
 }
 
-static inline void security_skb_classify_flow(struct sk_buff *skb, struct flowi *fl)
+static inline void security_skb_classify_flow(struct sk_buff *skb,
+					      struct flowi_common *flic)
 {
 }
 
diff --git a/include/net/flow.h b/include/net/flow.h
index b2531df3f65f..39d0cedcddee 100644
--- a/include/net/flow.h
+++ b/include/net/flow.h
@@ -195,11 +195,21 @@ static inline struct flowi *flowi4_to_flowi(struct flowi4 *fl4)
 	return container_of(fl4, struct flowi, u.ip4);
 }
 
+static inline struct flowi_common *flowi4_to_flowi_common(struct flowi4 *fl4)
+{
+	return &(flowi4_to_flowi(fl4)->u.__fl_common);
+}
+
 static inline struct flowi *flowi6_to_flowi(struct flowi6 *fl6)
 {
 	return container_of(fl6, struct flowi, u.ip6);
 }
 
+static inline struct flowi_common *flowi6_to_flowi_common(struct flowi6 *fl6)
+{
+	return &(flowi6_to_flowi(fl6)->u.__fl_common);
+}
+
 static inline struct flowi *flowidn_to_flowi(struct flowidn *fldn)
 {
 	return container_of(fldn, struct flowi, u.dn);
diff --git a/include/net/route.h b/include/net/route.h
index ff021cab657e..2e6c0e153e3a 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -165,7 +165,7 @@ static inline struct rtable *ip_route_output_ports(struct net *net, struct flowi
 			   sk ? inet_sk_flowi_flags(sk) : 0,
 			   daddr, saddr, dport, sport, sock_net_uid(net, sk));
 	if (sk)
-		security_sk_classify_flow(sk, flowi4_to_flowi(fl4));
+		security_sk_classify_flow(sk, flowi4_to_flowi_common(fl4));
 	return ip_route_output_flow(net, fl4, sk);
 }
 
@@ -322,7 +322,7 @@ static inline struct rtable *ip_route_connect(struct flowi4 *fl4,
 		ip_rt_put(rt);
 		flowi4_update_output(fl4, oif, tos, fl4->daddr, fl4->saddr);
 	}
-	security_sk_classify_flow(sk, flowi4_to_flowi(fl4));
+	security_sk_classify_flow(sk, flowi4_to_flowi_common(fl4));
 	return ip_route_output_flow(net, fl4, sk);
 }
 
@@ -338,7 +338,7 @@ static inline struct rtable *ip_route_newports(struct flowi4 *fl4, struct rtable
 		flowi4_update_output(fl4, sk->sk_bound_dev_if,
 				     RT_CONN_FLAGS(sk), fl4->daddr,
 				     fl4->saddr);
-		security_sk_classify_flow(sk, flowi4_to_flowi(fl4));
+		security_sk_classify_flow(sk, flowi4_to_flowi_common(fl4));
 		return ip_route_output_flow(sock_net(sk), fl4, sk);
 	}
 	return rt;
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index bb3d70664dde..3d0b58d7bf3f 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -464,7 +464,7 @@ static struct dst_entry* dccp_v4_route_skb(struct net *net, struct sock *sk,
 		.fl4_dport = dccp_hdr(skb)->dccph_sport,
 	};
 
-	security_skb_classify_flow(skb, flowi4_to_flowi(&fl4));
+	security_skb_classify_flow(skb, flowi4_to_flowi_common(&fl4));
 	rt = ip_route_output_flow(net, &fl4, sk);
 	if (IS_ERR(rt)) {
 		IP_INC_STATS(net, IPSTATS_MIB_OUTNOROUTES);
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index ef4ab28cfde0..179dcf02a572 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -203,7 +203,7 @@ static int dccp_v6_send_response(const struct sock *sk, struct request_sock *req
 	fl6.flowi6_oif = ireq->ir_iif;
 	fl6.fl6_dport = ireq->ir_rmt_port;
 	fl6.fl6_sport = htons(ireq->ir_num);
-	security_req_classify_flow(req, flowi6_to_flowi(&fl6));
+	security_req_classify_flow(req, flowi6_to_flowi_common(&fl6));
 
 
 	rcu_read_lock();
@@ -279,7 +279,7 @@ static void dccp_v6_ctl_send_reset(const struct sock *sk, struct sk_buff *rxskb)
 	fl6.flowi6_oif = inet6_iif(rxskb);
 	fl6.fl6_dport = dccp_hdr(skb)->dccph_dport;
 	fl6.fl6_sport = dccp_hdr(skb)->dccph_sport;
-	security_skb_classify_flow(rxskb, flowi6_to_flowi(&fl6));
+	security_skb_classify_flow(rxskb, flowi6_to_flowi_common(&fl6));
 
 	/* sk = NULL, but it is safe for now. RST socket required. */
 	dst = ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NULL);
@@ -907,7 +907,7 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	fl6.flowi6_oif = sk->sk_bound_dev_if;
 	fl6.fl6_dport = usin->sin6_port;
 	fl6.fl6_sport = inet->inet_sport;
-	security_sk_classify_flow(sk, flowi6_to_flowi(&fl6));
+	security_sk_classify_flow(sk, flowi6_to_flowi_common(&fl6));
 
 	opt = rcu_dereference_protected(np->opt, lockdep_sock_is_held(sk));
 	final_p = fl6_update_dst(&fl6, opt, &final);
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 005faea415a4..396b492c804f 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -447,7 +447,7 @@ static void icmp_reply(struct icmp_bxm *icmp_param, struct sk_buff *skb)
 	fl4.flowi4_tos = RT_TOS(ip_hdr(skb)->tos);
 	fl4.flowi4_proto = IPPROTO_ICMP;
 	fl4.flowi4_oif = l3mdev_master_ifindex(skb->dev);
-	security_skb_classify_flow(skb, flowi4_to_flowi(&fl4));
+	security_skb_classify_flow(skb, flowi4_to_flowi_common(&fl4));
 	rt = ip_route_output_key(net, &fl4);
 	if (IS_ERR(rt))
 		goto out_unlock;
@@ -503,7 +503,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
 	route_lookup_dev = icmp_get_route_lookup_dev(skb_in);
 	fl4->flowi4_oif = l3mdev_master_ifindex(route_lookup_dev);
 
-	security_skb_classify_flow(skb_in, flowi4_to_flowi(fl4));
+	security_skb_classify_flow(skb_in, flowi4_to_flowi_common(fl4));
 	rt = ip_route_output_key_hash(net, fl4, skb_in);
 	if (IS_ERR(rt))
 		return rt;
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 4148f5f78f31..1b7801371f7d 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -602,7 +602,7 @@ struct dst_entry *inet_csk_route_req(const struct sock *sk,
 			   (opt && opt->opt.srr) ? opt->opt.faddr : ireq->ir_rmt_addr,
 			   ireq->ir_loc_addr, ireq->ir_rmt_port,
 			   htons(ireq->ir_num), sk->sk_uid);
-	security_req_classify_flow(req, flowi4_to_flowi(fl4));
+	security_req_classify_flow(req, flowi4_to_flowi_common(fl4));
 	rt = ip_route_output_flow(net, fl4, sk);
 	if (IS_ERR(rt))
 		goto no_route;
@@ -640,7 +640,7 @@ struct dst_entry *inet_csk_route_child_sock(const struct sock *sk,
 			   (opt && opt->opt.srr) ? opt->opt.faddr : ireq->ir_rmt_addr,
 			   ireq->ir_loc_addr, ireq->ir_rmt_port,
 			   htons(ireq->ir_num), sk->sk_uid);
-	security_req_classify_flow(req, flowi4_to_flowi(fl4));
+	security_req_classify_flow(req, flowi4_to_flowi_common(fl4));
 	rt = ip_route_output_flow(net, fl4, sk);
 	if (IS_ERR(rt))
 		goto no_route;
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 879b76ae4435..89fff5f59eea 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1700,7 +1700,7 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
 			   daddr, saddr,
 			   tcp_hdr(skb)->source, tcp_hdr(skb)->dest,
 			   arg->uid);
-	security_skb_classify_flow(skb, flowi4_to_flowi(&fl4));
+	security_skb_classify_flow(skb, flowi4_to_flowi_common(&fl4));
 	rt = ip_route_output_key(net, &fl4);
 	if (IS_ERR(rt))
 		return;
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 248856b301c4..8b943f85fff9 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -778,7 +778,7 @@ static int ping_v4_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	fl4.fl4_icmp_type = user_icmph.type;
 	fl4.fl4_icmp_code = user_icmph.code;
 
-	security_sk_classify_flow(sk, flowi4_to_flowi(&fl4));
+	security_sk_classify_flow(sk, flowi4_to_flowi_common(&fl4));
 	rt = ip_route_output_flow(net, &fl4, sk);
 	if (IS_ERR(rt)) {
 		err = PTR_ERR(rt);
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 7d26e0f8bdae..50a73178d63a 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -640,7 +640,7 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			goto done;
 	}
 
-	security_sk_classify_flow(sk, flowi4_to_flowi(&fl4));
+	security_sk_classify_flow(sk, flowi4_to_flowi_common(&fl4));
 	rt = ip_route_output_flow(net, &fl4, sk);
 	if (IS_ERR(rt)) {
 		err = PTR_ERR(rt);
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 6ac473b47f30..36b3b9b72b75 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -418,7 +418,7 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 			   inet_sk_flowi_flags(sk),
 			   opt->srr ? opt->faddr : ireq->ir_rmt_addr,
 			   ireq->ir_loc_addr, th->source, th->dest, sk->sk_uid);
-	security_req_classify_flow(req, flowi4_to_flowi(&fl4));
+	security_req_classify_flow(req, flowi4_to_flowi_common(&fl4));
 	rt = ip_route_output_key(sock_net(sk), &fl4);
 	if (IS_ERR(rt)) {
 		reqsk_free(req);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 09f0a23d1a01..594632ff094f 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1197,7 +1197,7 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 				   faddr, saddr, dport, inet->inet_sport,
 				   sk->sk_uid);
 
-		security_sk_classify_flow(sk, flowi4_to_flowi(fl4));
+		security_sk_classify_flow(sk, flowi4_to_flowi_common(fl4));
 		rt = ip_route_output_flow(net, fl4, sk);
 		if (IS_ERR(rt)) {
 			err = PTR_ERR(rt);
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index e648fbebb167..b8e491d3acf0 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -819,7 +819,7 @@ int inet6_sk_rebuild_header(struct sock *sk)
 		fl6.fl6_dport = inet->inet_dport;
 		fl6.fl6_sport = inet->inet_sport;
 		fl6.flowi6_uid = sk->sk_uid;
-		security_sk_classify_flow(sk, flowi6_to_flowi(&fl6));
+		security_sk_classify_flow(sk, flowi6_to_flowi_common(&fl6));
 
 		rcu_read_lock();
 		final_p = fl6_update_dst(&fl6, rcu_dereference(np->opt),
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index cc8ad7ddecda..206f66310a88 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -60,7 +60,7 @@ static void ip6_datagram_flow_key_init(struct flowi6 *fl6, struct sock *sk)
 	if (!fl6->flowi6_oif && ipv6_addr_is_multicast(&fl6->daddr))
 		fl6->flowi6_oif = np->mcast_oif;
 
-	security_sk_classify_flow(sk, flowi6_to_flowi(fl6));
+	security_sk_classify_flow(sk, flowi6_to_flowi_common(fl6));
 }
 
 int ip6_datagram_dst_update(struct sock *sk, bool fix_sk_saddr)
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index ec448b71bf9a..91d9136b6e9c 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -567,7 +567,7 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 	fl6.fl6_icmp_code = code;
 	fl6.flowi6_uid = sock_net_uid(net, NULL);
 	fl6.mp_hash = rt6_multipath_hash(net, &fl6, skb, NULL);
-	security_skb_classify_flow(skb, flowi6_to_flowi(&fl6));
+	security_skb_classify_flow(skb, flowi6_to_flowi_common(&fl6));
 
 	np = inet6_sk(sk);
 
@@ -749,7 +749,7 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 	fl6.fl6_icmp_type = ICMPV6_ECHO_REPLY;
 	fl6.flowi6_mark = mark;
 	fl6.flowi6_uid = sock_net_uid(net, NULL);
-	security_skb_classify_flow(skb, flowi6_to_flowi(&fl6));
+	security_skb_classify_flow(skb, flowi6_to_flowi_common(&fl6));
 
 	local_bh_disable();
 	sk = icmpv6_xmit_lock(net);
@@ -1002,7 +1002,7 @@ void icmpv6_flow_init(struct sock *sk, struct flowi6 *fl6,
 	fl6->fl6_icmp_type	= type;
 	fl6->fl6_icmp_code	= 0;
 	fl6->flowi6_oif		= oif;
-	security_sk_classify_flow(sk, flowi6_to_flowi(fl6));
+	security_sk_classify_flow(sk, flowi6_to_flowi_common(fl6));
 }
 
 static void __net_exit icmpv6_sk_exit(struct net *net)
diff --git a/net/ipv6/inet6_connection_sock.c b/net/ipv6/inet6_connection_sock.c
index e315526fa244..5a9f4d722f35 100644
--- a/net/ipv6/inet6_connection_sock.c
+++ b/net/ipv6/inet6_connection_sock.c
@@ -46,7 +46,7 @@ struct dst_entry *inet6_csk_route_req(const struct sock *sk,
 	fl6->fl6_dport = ireq->ir_rmt_port;
 	fl6->fl6_sport = htons(ireq->ir_num);
 	fl6->flowi6_uid = sk->sk_uid;
-	security_req_classify_flow(req, flowi6_to_flowi(fl6));
+	security_req_classify_flow(req, flowi6_to_flowi_common(fl6));
 
 	dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_p);
 	if (IS_ERR(dst))
@@ -95,7 +95,7 @@ static struct dst_entry *inet6_csk_route_socket(struct sock *sk,
 	fl6->fl6_sport = inet->inet_sport;
 	fl6->fl6_dport = inet->inet_dport;
 	fl6->flowi6_uid = sk->sk_uid;
-	security_sk_classify_flow(sk, flowi6_to_flowi(fl6));
+	security_sk_classify_flow(sk, flowi6_to_flowi_common(fl6));
 
 	rcu_read_lock();
 	final_p = fl6_update_dst(fl6, rcu_dereference(np->opt), &final);
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 4aef6baaa55e..bf95513736c9 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -179,7 +179,7 @@ void nf_send_reset6(struct net *net, struct sk_buff *oldskb, int hook)
 
 	fl6.flowi6_oif = l3mdev_master_ifindex(skb_dst(oldskb)->dev);
 	fl6.flowi6_mark = IP6_REPLY_MARK(net, oldskb->mark);
-	security_skb_classify_flow(oldskb, flowi6_to_flowi(&fl6));
+	security_skb_classify_flow(oldskb, flowi6_to_flowi_common(&fl6));
 	dst = ip6_route_output(net, NULL, &fl6);
 	if (dst->error) {
 		dst_release(dst);
diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index 6caa062f68e7..6ac88fe24a8e 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -111,7 +111,7 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	fl6.flowi6_uid = sk->sk_uid;
 	fl6.fl6_icmp_type = user_icmph.icmp6_type;
 	fl6.fl6_icmp_code = user_icmph.icmp6_code;
-	security_sk_classify_flow(sk, flowi6_to_flowi(&fl6));
+	security_sk_classify_flow(sk, flowi6_to_flowi_common(&fl6));
 
 	ipcm6_init_sk(&ipc6, np);
 	ipc6.sockc.mark = sk->sk_mark;
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 6e4ab80a3b94..1f56d9aae589 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -915,7 +915,7 @@ static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		fl6.flowi6_oif = np->mcast_oif;
 	else if (!fl6.flowi6_oif)
 		fl6.flowi6_oif = np->ucast_oif;
-	security_sk_classify_flow(sk, flowi6_to_flowi(&fl6));
+	security_sk_classify_flow(sk, flowi6_to_flowi_common(&fl6));
 
 	if (hdrincl)
 		fl6.flowi6_flags |= FLOWI_FLAG_KNOWN_NH;
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index e796a64be308..0351e2ffc707 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -233,7 +233,7 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 		fl6.fl6_dport = ireq->ir_rmt_port;
 		fl6.fl6_sport = inet_sk(sk)->inet_sport;
 		fl6.flowi6_uid = sk->sk_uid;
-		security_req_classify_flow(req, flowi6_to_flowi(&fl6));
+		security_req_classify_flow(req, flowi6_to_flowi_common(&fl6));
 
 		dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 		if (IS_ERR(dst))
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 8db59f4e5f13..e5f75bbcc66f 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -278,7 +278,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	opt = rcu_dereference_protected(np->opt, lockdep_sock_is_held(sk));
 	final_p = fl6_update_dst(&fl6, opt, &final);
 
-	security_sk_classify_flow(sk, flowi6_to_flowi(&fl6));
+	security_sk_classify_flow(sk, flowi6_to_flowi_common(&fl6));
 
 	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
@@ -954,7 +954,7 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	fl6.fl6_dport = t1->dest;
 	fl6.fl6_sport = t1->source;
 	fl6.flowi6_uid = sock_net_uid(net, sk && sk_fullsock(sk) ? sk : NULL);
-	security_skb_classify_flow(skb, flowi6_to_flowi(&fl6));
+	security_skb_classify_flow(skb, flowi6_to_flowi_common(&fl6));
 
 	/* Pass a socket to ip6_dst_lookup either it is for RST
 	 * Underlying function will use this to retrieve the network
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 29d9691359b9..724942afc035 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1496,7 +1496,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	} else if (!fl6.flowi6_oif)
 		fl6.flowi6_oif = np->ucast_oif;
 
-	security_sk_classify_flow(sk, flowi6_to_flowi(&fl6));
+	security_sk_classify_flow(sk, flowi6_to_flowi_common(&fl6));
 
 	if (ipc6.tclass < 0)
 		ipc6.tclass = np->tclass;
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index e5e5036257b0..96f975777438 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -606,7 +606,7 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	else if (!fl6.flowi6_oif)
 		fl6.flowi6_oif = np->ucast_oif;
 
-	security_sk_classify_flow(sk, flowi6_to_flowi(&fl6));
+	security_sk_classify_flow(sk, flowi6_to_flowi_common(&fl6));
 
 	if (ipc6.tclass < 0)
 		ipc6.tclass = np->tclass;
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 9cca35d22927..fb64e8515f7d 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -849,7 +849,7 @@ synproxy_send_tcp_ipv6(struct net *net,
 	fl6.fl6_sport = nth->source;
 	fl6.fl6_dport = nth->dest;
 	security_skb_classify_flow((struct sk_buff *)skb,
-				   flowi6_to_flowi(&fl6));
+				   flowi6_to_flowi_common(&fl6));
 	err = nf_ip6_route(net, &dst, flowi6_to_flowi(&fl6), false);
 	if (err) {
 		goto free_nskb;
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index bbd4643d7e82..ac25b0c2d87e 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1021,7 +1021,8 @@ static void xfrm_state_look_at(struct xfrm_policy *pol, struct xfrm_state *x,
 		if ((x->sel.family &&
 		     (x->sel.family != family ||
 		      !xfrm_selector_match(&x->sel, fl, family))) ||
-		    !security_xfrm_state_pol_flow_match(x, pol, fl))
+		    !security_xfrm_state_pol_flow_match(x, pol,
+							&fl->u.__fl_common))
 			return;
 
 		if (!*best ||
@@ -1036,7 +1037,8 @@ static void xfrm_state_look_at(struct xfrm_policy *pol, struct xfrm_state *x,
 		if ((!x->sel.family ||
 		     (x->sel.family == family &&
 		      xfrm_selector_match(&x->sel, fl, family))) &&
-		    security_xfrm_state_pol_flow_match(x, pol, fl))
+		    security_xfrm_state_pol_flow_match(x, pol,
+						       &fl->u.__fl_common))
 			*error = -ESRCH;
 	}
 }
diff --git a/security/security.c b/security/security.c
index a28045dc9e7f..c08e0eec8b9e 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2207,15 +2207,16 @@ void security_sk_clone(const struct sock *sk, struct sock *newsk)
 }
 EXPORT_SYMBOL(security_sk_clone);
 
-void security_sk_classify_flow(struct sock *sk, struct flowi *fl)
+void security_sk_classify_flow(struct sock *sk, struct flowi_common *flic)
 {
-	call_void_hook(sk_getsecid, sk, &fl->flowi_secid);
+	call_void_hook(sk_getsecid, sk, &flic->flowic_secid);
 }
 EXPORT_SYMBOL(security_sk_classify_flow);
 
-void security_req_classify_flow(const struct request_sock *req, struct flowi *fl)
+void security_req_classify_flow(const struct request_sock *req,
+				struct flowi_common *flic)
 {
-	call_void_hook(req_classify_flow, req, fl);
+	call_void_hook(req_classify_flow, req, flic);
 }
 EXPORT_SYMBOL(security_req_classify_flow);
 
@@ -2407,7 +2408,7 @@ int security_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir)
 
 int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
 				       struct xfrm_policy *xp,
-				       const struct flowi *fl)
+				       const struct flowi_common *flic)
 {
 	struct security_hook_list *hp;
 	int rc = LSM_RET_DEFAULT(xfrm_state_pol_flow_match);
@@ -2423,7 +2424,7 @@ int security_xfrm_state_pol_flow_match(struct xfrm_state *x,
 	 */
 	hlist_for_each_entry(hp, &security_hook_heads.xfrm_state_pol_flow_match,
 				list) {
-		rc = hp->hook.xfrm_state_pol_flow_match(x, xp, fl);
+		rc = hp->hook.xfrm_state_pol_flow_match(x, xp, flic);
 		break;
 	}
 	return rc;
@@ -2434,9 +2435,9 @@ int security_xfrm_decode_session(struct sk_buff *skb, u32 *secid)
 	return call_int_hook(xfrm_decode_session, 0, skb, secid, 1);
 }
 
-void security_skb_classify_flow(struct sk_buff *skb, struct flowi *fl)
+void security_skb_classify_flow(struct sk_buff *skb, struct flowi_common *flic)
 {
-	int rc = call_int_hook(xfrm_decode_session, 0, skb, &fl->flowi_secid,
+	int rc = call_int_hook(xfrm_decode_session, 0, skb, &flic->flowic_secid,
 				0);
 
 	BUG_ON(rc);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index ca5c5623b46d..362bd154553e 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5436,9 +5436,9 @@ static void selinux_secmark_refcount_dec(void)
 }
 
 static void selinux_req_classify_flow(const struct request_sock *req,
-				      struct flowi *fl)
+				      struct flowi_common *flic)
 {
-	fl->flowi_secid = req->secid;
+	flic->flowic_secid = req->secid;
 }
 
 static int selinux_tun_dev_alloc_security(void **security)
diff --git a/security/selinux/include/xfrm.h b/security/selinux/include/xfrm.h
index a0b465316292..0a6f34a7a971 100644
--- a/security/selinux/include/xfrm.h
+++ b/security/selinux/include/xfrm.h
@@ -26,7 +26,7 @@ int selinux_xfrm_state_delete(struct xfrm_state *x);
 int selinux_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir);
 int selinux_xfrm_state_pol_flow_match(struct xfrm_state *x,
 				      struct xfrm_policy *xp,
-				      const struct flowi *fl);
+				      const struct flowi_common *flic);
 
 #ifdef CONFIG_SECURITY_NETWORK_XFRM
 extern atomic_t selinux_xfrm_refcount;
diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index 7314196185d1..c367d36965d4 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -175,9 +175,10 @@ int selinux_xfrm_policy_lookup(struct xfrm_sec_ctx *ctx, u32 fl_secid, u8 dir)
  */
 int selinux_xfrm_state_pol_flow_match(struct xfrm_state *x,
 				      struct xfrm_policy *xp,
-				      const struct flowi *fl)
+				      const struct flowi_common *flic)
 {
 	u32 state_sid;
+	u32 flic_sid;
 
 	if (!xp->security)
 		if (x->security)
@@ -196,17 +197,17 @@ int selinux_xfrm_state_pol_flow_match(struct xfrm_state *x,
 				return 0;
 
 	state_sid = x->security->ctx_sid;
+	flic_sid = flic->flowic_secid;
 
-	if (fl->flowi_secid != state_sid)
+	if (flic_sid != state_sid)
 		return 0;
 
 	/* We don't need a separate SA Vs. policy polmatch check since the SA
 	 * is now of the same label as the flow and a flow Vs. policy polmatch
 	 * check had already happened in selinux_xfrm_policy_lookup() above. */
-	return (avc_has_perm(&selinux_state,
-			     fl->flowi_secid, state_sid,
-			    SECCLASS_ASSOCIATION, ASSOCIATION__SENDTO,
-			    NULL) ? 0 : 1);
+	return (avc_has_perm(&selinux_state, flic_sid, state_sid,
+			     SECCLASS_ASSOCIATION, ASSOCIATION__SENDTO,
+			     NULL) ? 0 : 1);
 }
 
 static u32 selinux_xfrm_skb_sid_egress(struct sk_buff *skb)

