Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEED112D88
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 15:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbfLDOgX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Dec 2019 09:36:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38965 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727878AbfLDOgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 09:36:23 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-FHob5C9YNM25LJI_fnnnxg-1; Wed, 04 Dec 2019 09:36:18 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 786BC1005502;
        Wed,  4 Dec 2019 14:36:17 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-31.ams2.redhat.com [10.36.116.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B2BA5D6BB;
        Wed,  4 Dec 2019 14:36:16 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, Xiumei Mu <xmu@redhat.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net 1/2] net: ipv6: add net argument to ip6_dst_lookup_flow
Date:   Wed,  4 Dec 2019 15:35:52 +0100
Message-Id: <ca140d23d5181cee3d1279de07517461cb4de03b.1575458463.git.sd@queasysnail.net>
In-Reply-To: <cover.1575458463.git.sd@queasysnail.net>
References: <cover.1575458463.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: FHob5C9YNM25LJI_fnnnxg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will be used in the conversion of ipv6_stub to ip6_dst_lookup_flow,
as some modules currently pass a net argument without a socket to
ip6_dst_lookup. This is equivalent to commit 343d60aada5a ("ipv6: change
ipv6_stub_impl.ipv6_dst_lookup to take net argument").

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 include/net/ipv6.h               | 2 +-
 net/dccp/ipv6.c                  | 6 +++---
 net/ipv6/af_inet6.c              | 2 +-
 net/ipv6/datagram.c              | 2 +-
 net/ipv6/inet6_connection_sock.c | 4 ++--
 net/ipv6/ip6_output.c            | 8 ++++----
 net/ipv6/raw.c                   | 2 +-
 net/ipv6/syncookies.c            | 2 +-
 net/ipv6/tcp_ipv6.c              | 4 ++--
 net/l2tp/l2tp_ip6.c              | 2 +-
 net/sctp/ipv6.c                  | 4 ++--
 11 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index d04b7abe2a4c..4e95f6df508c 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1022,7 +1022,7 @@ static inline struct sk_buff *ip6_finish_skb(struct sock *sk)
 
 int ip6_dst_lookup(struct net *net, struct sock *sk, struct dst_entry **dst,
 		   struct flowi6 *fl6);
-struct dst_entry *ip6_dst_lookup_flow(const struct sock *sk, struct flowi6 *fl6,
+struct dst_entry *ip6_dst_lookup_flow(struct net *net, const struct sock *sk, struct flowi6 *fl6,
 				      const struct in6_addr *final_dst);
 struct dst_entry *ip6_sk_dst_lookup_flow(struct sock *sk, struct flowi6 *fl6,
 					 const struct in6_addr *final_dst,
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 25aab672fc99..1e5e08cc0bfc 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -210,7 +210,7 @@ static int dccp_v6_send_response(const struct sock *sk, struct request_sock *req
 	final_p = fl6_update_dst(&fl6, rcu_dereference(np->opt), &final);
 	rcu_read_unlock();
 
-	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		dst = NULL;
@@ -282,7 +282,7 @@ static void dccp_v6_ctl_send_reset(const struct sock *sk, struct sk_buff *rxskb)
 	security_skb_classify_flow(rxskb, flowi6_to_flowi(&fl6));
 
 	/* sk = NULL, but it is safe for now. RST socket required. */
-	dst = ip6_dst_lookup_flow(ctl_sk, &fl6, NULL);
+	dst = ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NULL);
 	if (!IS_ERR(dst)) {
 		skb_dst_set(skb, dst);
 		ip6_xmit(ctl_sk, skb, &fl6, 0, NULL, 0, 0);
@@ -912,7 +912,7 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	opt = rcu_dereference_protected(np->opt, lockdep_sock_is_held(sk));
 	final_p = fl6_update_dst(&fl6, opt, &final);
 
-	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		goto failure;
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 60e2ff91a5b3..e84e8b1ffbc7 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -765,7 +765,7 @@ int inet6_sk_rebuild_header(struct sock *sk)
 					 &final);
 		rcu_read_unlock();
 
-		dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+		dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 		if (IS_ERR(dst)) {
 			sk->sk_route_caps = 0;
 			sk->sk_err_soft = -PTR_ERR(dst);
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 96f939248d2f..390bedde21a5 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -85,7 +85,7 @@ int ip6_datagram_dst_update(struct sock *sk, bool fix_sk_saddr)
 	final_p = fl6_update_dst(&fl6, opt, &final);
 	rcu_read_unlock();
 
-	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		goto out;
diff --git a/net/ipv6/inet6_connection_sock.c b/net/ipv6/inet6_connection_sock.c
index 0a0945a5b30d..fe9cb8d1adca 100644
--- a/net/ipv6/inet6_connection_sock.c
+++ b/net/ipv6/inet6_connection_sock.c
@@ -48,7 +48,7 @@ struct dst_entry *inet6_csk_route_req(const struct sock *sk,
 	fl6->flowi6_uid = sk->sk_uid;
 	security_req_classify_flow(req, flowi6_to_flowi(fl6));
 
-	dst = ip6_dst_lookup_flow(sk, fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_p);
 	if (IS_ERR(dst))
 		return NULL;
 
@@ -103,7 +103,7 @@ static struct dst_entry *inet6_csk_route_socket(struct sock *sk,
 
 	dst = __inet6_csk_dst_check(sk, np->dst_cookie);
 	if (!dst) {
-		dst = ip6_dst_lookup_flow(sk, fl6, final_p);
+		dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_p);
 
 		if (!IS_ERR(dst))
 			ip6_dst_store(sk, dst, NULL, NULL);
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 945508a7cb0f..087304427bbb 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1144,19 +1144,19 @@ EXPORT_SYMBOL_GPL(ip6_dst_lookup);
  *	It returns a valid dst pointer on success, or a pointer encoded
  *	error code.
  */
-struct dst_entry *ip6_dst_lookup_flow(const struct sock *sk, struct flowi6 *fl6,
+struct dst_entry *ip6_dst_lookup_flow(struct net *net, const struct sock *sk, struct flowi6 *fl6,
 				      const struct in6_addr *final_dst)
 {
 	struct dst_entry *dst = NULL;
 	int err;
 
-	err = ip6_dst_lookup_tail(sock_net(sk), sk, &dst, fl6);
+	err = ip6_dst_lookup_tail(net, sk, &dst, fl6);
 	if (err)
 		return ERR_PTR(err);
 	if (final_dst)
 		fl6->daddr = *final_dst;
 
-	return xfrm_lookup_route(sock_net(sk), dst, flowi6_to_flowi(fl6), sk, 0);
+	return xfrm_lookup_route(net, dst, flowi6_to_flowi(fl6), sk, 0);
 }
 EXPORT_SYMBOL_GPL(ip6_dst_lookup_flow);
 
@@ -1188,7 +1188,7 @@ struct dst_entry *ip6_sk_dst_lookup_flow(struct sock *sk, struct flowi6 *fl6,
 	if (dst)
 		return dst;
 
-	dst = ip6_dst_lookup_flow(sk, fl6, final_dst);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_dst);
 	if (connected && !IS_ERR(dst))
 		ip6_sk_dst_store_flow(sk, dst_clone(dst), fl6);
 
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index a77f6b7d3a7c..dfe5e603ffe1 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -925,7 +925,7 @@ static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	fl6.flowlabel = ip6_make_flowinfo(ipc6.tclass, fl6.flowlabel);
 
-	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		goto out;
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index 16632e02e9b0..30915f6f31e3 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -235,7 +235,7 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 		fl6.flowi6_uid = sk->sk_uid;
 		security_req_classify_flow(req, flowi6_to_flowi(&fl6));
 
-		dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+		dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 		if (IS_ERR(dst))
 			goto out_free;
 	}
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 81f51335e326..df5fd9109696 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -275,7 +275,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 
 	security_sk_classify_flow(sk, flowi6_to_flowi(&fl6));
 
-	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		goto failure;
@@ -906,7 +906,7 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	 * Underlying function will use this to retrieve the network
 	 * namespace
 	 */
-	dst = ip6_dst_lookup_flow(ctl_sk, &fl6, NULL);
+	dst = ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NULL);
 	if (!IS_ERR(dst)) {
 		skb_dst_set(buff, dst);
 		ip6_xmit(ctl_sk, buff, &fl6, fl6.flowi6_mark, NULL, tclass,
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 802f19aba7e3..d148766f40d1 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -615,7 +615,7 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	fl6.flowlabel = ip6_make_flowinfo(ipc6.tclass, fl6.flowlabel);
 
-	dst = ip6_dst_lookup_flow(sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		goto out;
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index dd860fea0148..bc734cfaa29e 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -275,7 +275,7 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 	final_p = fl6_update_dst(fl6, rcu_dereference(np->opt), &final);
 	rcu_read_unlock();
 
-	dst = ip6_dst_lookup_flow(sk, fl6, final_p);
+	dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_p);
 	if (!asoc || saddr)
 		goto out;
 
@@ -328,7 +328,7 @@ static void sctp_v6_get_dst(struct sctp_transport *t, union sctp_addr *saddr,
 		fl6->saddr = laddr->a.v6.sin6_addr;
 		fl6->fl6_sport = laddr->a.v6.sin6_port;
 		final_p = fl6_update_dst(fl6, rcu_dereference(np->opt), &final);
-		bdst = ip6_dst_lookup_flow(sk, fl6, final_p);
+		bdst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_p);
 
 		if (IS_ERR(bdst))
 			continue;
-- 
2.23.0

