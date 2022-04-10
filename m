Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55EE24FB000
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 22:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241875AbiDJUJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 16:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbiDJUJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 16:09:10 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBC2427FD
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 13:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1649621203;
    s=strato-dkim-0002; d=hartkopp.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=CjV+5Z2SgTnbGABEq3DhwEH35ogTl/RFJasyUpy5GAk=;
    b=GVL2cuq98UW4TgaeUaZ7tB5LRCA+gPPi6I7bhxPtWg9vJQWYFQt3qMsOLaHEXMqKjB
    bL4pxn0txb6N80AEoPC6aQICvAgayR5Nf2aXnYatjCnt/9buRPfFp+tZ6nBLtXwrreDN
    68vk2MNNb94LaMMUQYIdbI1/IFBDVST06WwQ6UWfFhdYdhITL2gXSr/BuHzLyq277k0b
    aiLtMc6dutgL5l2fplqfGtJ+upCxJVq1OQW9LDMohHA3dahj1YKuhs0YzyYrdyBLtHOS
    Mw8DNSIuzMONuswCNzzxfuG6Lp7jgSUs9jmu2h/yGp4AQweFfJoIRLeltt00IYR+0OmT
    kq7w==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS/xvEBL7X5sbo3UIh9IyLecSWJafUvprl4"
X-RZG-CLASS-ID: mo00
Received: from silver.lan
    by smtp.strato.de (RZmta 47.42.2 AUTH)
    with ESMTPSA id 4544c9y3AK6gfIV
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 10 Apr 2022 22:06:42 +0200 (CEST)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH net-next v2] net: remove noblock parameter from recvmsg() entities
Date:   Sun, 10 Apr 2022 22:06:35 +0200
Message-Id: <20220410200635.174327-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The internal recvmsg() functions have two parameters 'flags' and 'noblock'
that were merged inside skb_recv_datagram(). As a follow up patch to commit
f4b41f062c42 ("net: remove noblock parameter from skb_recv_datagram()")
this patch removes the separate 'noblock' parameter for recvmsg().

Analogue to the referenced patch for skb_recv_datagram() the 'flags' and
'noblock' parameters are unnecessarily split up with e.g.

err = sk->sk_prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
                           flags & ~MSG_DONTWAIT, &addr_len);

or in

err = INDIRECT_CALL_2(sk->sk_prot->recvmsg, tcp_recvmsg, udp_recvmsg,
                      sk, msg, size, flags & MSG_DONTWAIT,
                      flags & ~MSG_DONTWAIT, &addr_len);

instead of simply using only 'flags' all the time and check for MSG_DONTWAIT
flags where needed to check for the former separated no(n)block condition.

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 .../chelsio/inline_crypto/chtls/chtls.h       |  2 +-
 .../chelsio/inline_crypto/chtls/chtls_io.c    | 20 +++++++++----------
 include/net/ping.h                            |  2 +-
 include/net/sock.h                            |  3 +--
 include/net/tcp.h                             |  2 +-
 include/net/tls.h                             |  2 +-
 include/net/udp.h                             |  6 +++---
 net/core/sock.c                               |  3 +--
 net/ieee802154/socket.c                       |  6 ++----
 net/ipv4/af_inet.c                            |  5 ++---
 net/ipv4/ping.c                               |  3 +--
 net/ipv4/raw.c                                |  3 +--
 net/ipv4/tcp.c                                | 14 ++++++-------
 net/ipv4/tcp_bpf.c                            | 15 +++++++-------
 net/ipv4/udp.c                                |  9 ++++-----
 net/ipv4/udp_bpf.c                            | 16 +++++++--------
 net/ipv4/udp_impl.h                           |  2 +-
 net/ipv6/af_inet6.c                           |  5 ++---
 net/ipv6/raw.c                                |  3 +--
 net/ipv6/udp.c                                |  4 ++--
 net/ipv6/udp_impl.h                           |  2 +-
 net/l2tp/l2tp_ip.c                            |  3 +--
 net/l2tp/l2tp_ip6.c                           |  3 +--
 net/mptcp/protocol.c                          |  4 ++--
 net/phonet/datagram.c                         |  3 +--
 net/phonet/pep.c                              |  3 +--
 net/tls/tls_sw.c                              |  3 ---
 net/unix/af_unix.c                            |  6 ++----
 net/unix/unix_bpf.c                           |  5 ++---
 net/xfrm/espintcp.c                           |  4 +---
 30 files changed, 69 insertions(+), 92 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
index 9e2378013642..41714203ace8 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls.h
@@ -565,11 +565,11 @@ void chtls_close(struct sock *sk, long timeout);
 int chtls_disconnect(struct sock *sk, int flags);
 void chtls_shutdown(struct sock *sk, int how);
 void chtls_destroy_sock(struct sock *sk);
 int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
 int chtls_recvmsg(struct sock *sk, struct msghdr *msg,
-		  size_t len, int nonblock, int flags, int *addr_len);
+		  size_t len, int flags, int *addr_len);
 int chtls_sendpage(struct sock *sk, struct page *page,
 		   int offset, size_t size, int flags);
 int send_tx_flowc_wr(struct sock *sk, int compl,
 		     u32 snd_nxt, u32 rcv_nxt);
 void chtls_tcp_push(struct sock *sk, int flags);
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
index c320cc8ca68d..0e7ed2d85482 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_io.c
@@ -1424,11 +1424,11 @@ static void chtls_cleanup_rbuf(struct sock *sk, int copied)
 	if (must_send || credits >= thres)
 		tp->rcv_wup += send_rx_credits(csk, credits);
 }
 
 static int chtls_pt_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
-			    int nonblock, int flags, int *addr_len)
+			    int flags, int *addr_len)
 {
 	struct chtls_sock *csk = rcu_dereference_sk_user_data(sk);
 	struct chtls_hws *hws = &csk->tlshws;
 	struct net_device *dev = csk->egress_dev;
 	struct adapter *adap = netdev2adap(dev);
@@ -1439,11 +1439,11 @@ static int chtls_pt_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	int target;
 	long timeo;
 
 	buffers_freed = 0;
 
-	timeo = sock_rcvtimeo(sk, nonblock);
+	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
 
 	if (unlikely(csk_flag(sk, CSK_UPDATE_RCV_WND)))
 		chtls_cleanup_rbuf(sk, copied);
 
@@ -1614,21 +1614,21 @@ static int chtls_pt_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 
 /*
  * Peek at data in a socket's receive buffer.
  */
 static int peekmsg(struct sock *sk, struct msghdr *msg,
-		   size_t len, int nonblock, int flags)
+		   size_t len, int flags)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	u32 peek_seq, offset;
 	struct sk_buff *skb;
 	int copied = 0;
 	size_t avail;          /* amount of available data in current skb */
 	long timeo;
 
 	lock_sock(sk);
-	timeo = sock_rcvtimeo(sk, nonblock);
+	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 	peek_seq = tp->copied_seq;
 
 	do {
 		if (unlikely(tp->urg_data && tp->urg_seq == peek_seq)) {
 			if (copied)
@@ -1735,11 +1735,11 @@ static int peekmsg(struct sock *sk, struct msghdr *msg,
 	release_sock(sk);
 	return copied;
 }
 
 int chtls_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
-		  int nonblock, int flags, int *addr_len)
+		  int flags, int *addr_len)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct chtls_sock *csk;
 	unsigned long avail;    /* amount of available data in current skb */
 	int buffers_freed;
@@ -1748,29 +1748,29 @@ int chtls_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	int target;             /* Read at least this many bytes */
 
 	buffers_freed = 0;
 
 	if (unlikely(flags & MSG_OOB))
-		return tcp_prot.recvmsg(sk, msg, len, nonblock, flags,
+		return tcp_prot.recvmsg(sk, msg, len, flags,
 					addr_len);
 
 	if (unlikely(flags & MSG_PEEK))
-		return peekmsg(sk, msg, len, nonblock, flags);
+		return peekmsg(sk, msg, len, flags);
 
 	if (sk_can_busy_loop(sk) &&
 	    skb_queue_empty_lockless(&sk->sk_receive_queue) &&
 	    sk->sk_state == TCP_ESTABLISHED)
-		sk_busy_loop(sk, nonblock);
+		sk_busy_loop(sk, flags & MSG_DONTWAIT);
 
 	lock_sock(sk);
 	csk = rcu_dereference_sk_user_data(sk);
 
 	if (is_tls_rx(csk))
-		return chtls_pt_recvmsg(sk, msg, len, nonblock,
+		return chtls_pt_recvmsg(sk, msg, len,
 					flags, addr_len);
 
-	timeo = sock_rcvtimeo(sk, nonblock);
+	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
 
 	if (unlikely(csk_flag(sk, CSK_UPDATE_RCV_WND)))
 		chtls_cleanup_rbuf(sk, copied);
 
diff --git a/include/net/ping.h b/include/net/ping.h
index 2fe78874318c..a873c1ac7368 100644
--- a/include/net/ping.h
+++ b/include/net/ping.h
@@ -69,11 +69,11 @@ void ping_close(struct sock *sk, long timeout);
 int  ping_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len);
 void ping_err(struct sk_buff *skb, int offset, u32 info);
 int  ping_getfrag(void *from, char *to, int offset, int fraglen, int odd,
 		  struct sk_buff *);
 
-int  ping_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
+int  ping_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		  int flags, int *addr_len);
 int  ping_common_sendmsg(int family, struct msghdr *msg, size_t len,
 			 void *user_icmph, size_t icmph_len);
 int  ping_queue_rcv_skb(struct sock *sk, struct sk_buff *skb);
 bool ping_rcv(struct sk_buff *skb);
diff --git a/include/net/sock.h b/include/net/sock.h
index c4b91fc19b9c..e6564d238d0e 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1200,12 +1200,11 @@ struct proto {
 					unsigned int cmd, unsigned long arg);
 #endif
 	int			(*sendmsg)(struct sock *sk, struct msghdr *msg,
 					   size_t len);
 	int			(*recvmsg)(struct sock *sk, struct msghdr *msg,
-					   size_t len, int noblock, int flags,
-					   int *addr_len);
+					   size_t len, int flags, int *addr_len);
 	int			(*sendpage)(struct sock *sk, struct page *page,
 					int offset, size_t size, int flags);
 	int			(*bind)(struct sock *sk,
 					struct sockaddr *addr, int addr_len);
 	int			(*bind_add)(struct sock *sk,
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 6d50a662bf89..679b1964d494 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -405,11 +405,11 @@ int tcp_getsockopt(struct sock *sk, int level, int optname,
 bool tcp_bpf_bypass_getsockopt(int level, int optname);
 int tcp_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
 		   unsigned int optlen);
 void tcp_set_keepalive(struct sock *sk, int val);
 void tcp_syn_ack_timeout(const struct request_sock *req);
-int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
+int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		int flags, int *addr_len);
 int tcp_set_rcvlowat(struct sock *sk, int val);
 int tcp_set_window_clamp(struct sock *sk, int val);
 void tcp_update_recv_tstamps(struct sk_buff *skb,
 			     struct scm_timestamping_internal *tss);
diff --git a/include/net/tls.h b/include/net/tls.h
index 6fe78361c8c8..b59f0a63292b 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -369,11 +369,11 @@ void tls_sw_release_resources_tx(struct sock *sk);
 void tls_sw_free_ctx_tx(struct tls_context *tls_ctx);
 void tls_sw_free_resources_rx(struct sock *sk);
 void tls_sw_release_resources_rx(struct sock *sk);
 void tls_sw_free_ctx_rx(struct tls_context *tls_ctx);
 int tls_sw_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
-		   int nonblock, int flags, int *addr_len);
+		   int flags, int *addr_len);
 bool tls_sw_sock_is_readable(struct sock *sk);
 ssize_t tls_sw_splice_read(struct socket *sock, loff_t *ppos,
 			   struct pipe_inode_info *pipe,
 			   size_t len, unsigned int flags);
 
diff --git a/include/net/udp.h b/include/net/udp.h
index f1c2a88c9005..c2dfe95f4da5 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -249,17 +249,17 @@ static inline bool udp_sk_bound_dev_eq(struct net *net, int bound_dev_if,
 void udp_destruct_sock(struct sock *sk);
 void skb_consume_udp(struct sock *sk, struct sk_buff *skb, int len);
 int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb);
 void udp_skb_destructor(struct sock *sk, struct sk_buff *skb);
 struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
-			       int noblock, int *off, int *err);
+			       int *off, int *err);
 static inline struct sk_buff *skb_recv_udp(struct sock *sk, unsigned int flags,
-					   int noblock, int *err)
+					   int *err)
 {
 	int off = 0;
 
-	return __skb_recv_udp(sk, flags, noblock, &off, err);
+	return __skb_recv_udp(sk, flags, &off, err);
 }
 
 int udp_v4_early_demux(struct sk_buff *skb);
 bool udp_sk_rx_dst_set(struct sock *sk, struct dst_entry *dst);
 int udp_get_port(struct sock *sk, unsigned short snum,
diff --git a/net/core/sock.c b/net/core/sock.c
index 7000403eaeb2..60f5ceca36f9 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3486,12 +3486,11 @@ int sock_common_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 {
 	struct sock *sk = sock->sk;
 	int addr_len = 0;
 	int err;
 
-	err = sk->sk_prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
-				   flags & ~MSG_DONTWAIT, &addr_len);
+	err = sk->sk_prot->recvmsg(sk, msg, size, flags, &addr_len);
 	if (err >= 0)
 		msg->msg_namelen = addr_len;
 	return err;
 }
 EXPORT_SYMBOL(sock_common_recvmsg);
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index a725dd9bbda8..f24852814fa3 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -306,17 +306,16 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 out:
 	return err;
 }
 
 static int raw_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
-		       int noblock, int flags, int *addr_len)
+		       int flags, int *addr_len)
 {
 	size_t copied = 0;
 	int err = -EOPNOTSUPP;
 	struct sk_buff *skb;
 
-	flags |= (noblock ? MSG_DONTWAIT : 0);
 	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto out;
 
 	copied = skb->len;
@@ -694,19 +693,18 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 out:
 	return err;
 }
 
 static int dgram_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
-			 int noblock, int flags, int *addr_len)
+			 int flags, int *addr_len)
 {
 	size_t copied = 0;
 	int err = -EOPNOTSUPP;
 	struct sk_buff *skb;
 	struct dgram_sock *ro = dgram_sk(sk);
 	DECLARE_SOCKADDR(struct sockaddr_ieee802154 *, saddr, msg->msg_name);
 
-	flags |= (noblock ? MSG_DONTWAIT : 0);
 	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto out;
 
 	copied = skb->len;
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 72fde2888ad2..195ecfa2f000 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -834,11 +834,11 @@ ssize_t inet_sendpage(struct socket *sock, struct page *page, int offset,
 	return sock_no_sendpage(sock, page, offset, size, flags);
 }
 EXPORT_SYMBOL(inet_sendpage);
 
 INDIRECT_CALLABLE_DECLARE(int udp_recvmsg(struct sock *, struct msghdr *,
-					  size_t, int, int, int *));
+					  size_t, int, int *));
 int inet_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		 int flags)
 {
 	struct sock *sk = sock->sk;
 	int addr_len = 0;
@@ -846,12 +846,11 @@ int inet_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 
 	if (likely(!(flags & MSG_ERRQUEUE)))
 		sock_rps_record_flow(sk);
 
 	err = INDIRECT_CALL_2(sk->sk_prot->recvmsg, tcp_recvmsg, udp_recvmsg,
-			      sk, msg, size, flags & MSG_DONTWAIT,
-			      flags & ~MSG_DONTWAIT, &addr_len);
+			      sk, msg, size, flags, &addr_len);
 	if (err >= 0)
 		msg->msg_namelen = addr_len;
 	return err;
 }
 EXPORT_SYMBOL(inet_recvmsg);
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 550dc5c795c0..64a5f02426ed 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -842,11 +842,11 @@ static int ping_v4_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		goto back_from_confirm;
 	err = 0;
 	goto out;
 }
 
-int ping_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
+int ping_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		 int flags, int *addr_len)
 {
 	struct inet_sock *isk = inet_sk(sk);
 	int family = sk->sk_family;
 	struct sk_buff *skb;
@@ -859,11 +859,10 @@ int ping_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 		goto out;
 
 	if (flags & MSG_ERRQUEUE)
 		return inet_recv_error(sk, msg, len, addr_len);
 
-	flags |= (noblock ? MSG_DONTWAIT : 0);
 	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto out;
 
 	copied = skb->len;
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index c9dd9603f2e7..4056b0da85ea 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -751,11 +751,11 @@ static int raw_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
  *	This should be easy, if there is something there
  *	we return it, otherwise we block.
  */
 
 static int raw_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
-		       int noblock, int flags, int *addr_len)
+		       int flags, int *addr_len)
 {
 	struct inet_sock *inet = inet_sk(sk);
 	size_t copied = 0;
 	int err = -EOPNOTSUPP;
 	DECLARE_SOCKADDR(struct sockaddr_in *, sin, msg->msg_name);
@@ -767,11 +767,10 @@ static int raw_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (flags & MSG_ERRQUEUE) {
 		err = ip_recv_error(sk, msg, len, addr_len);
 		goto out;
 	}
 
-	flags |= (noblock ? MSG_DONTWAIT : 0);
 	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto out;
 
 	copied = skb->len;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e31cf137c614..1e003a3dd678 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1875,11 +1875,11 @@ static void tcp_zerocopy_set_hint_for_skb(struct sock *sk,
 	mappable_offset = find_next_mappable_frag(frag, zc->recv_skip_hint);
 	zc->recv_skip_hint = mappable_offset + partial_frag_remainder;
 }
 
 static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
-			      int nonblock, int flags,
+			      int flags,
 			      struct scm_timestamping_internal *tss,
 			      int *cmsg_flags);
 static int receive_fallback_to_copy(struct sock *sk,
 				    struct tcp_zerocopy_receive *zc, int inq,
 				    struct scm_timestamping_internal *tss)
@@ -1898,11 +1898,11 @@ static int receive_fallback_to_copy(struct sock *sk,
 	err = import_single_range(READ, (void __user *)copy_address,
 				  inq, &iov, &msg.msg_iter);
 	if (err)
 		return err;
 
-	err = tcp_recvmsg_locked(sk, &msg, inq, /*nonblock=*/1, /*flags=*/0,
+	err = tcp_recvmsg_locked(sk, &msg, inq, MSG_DONTWAIT,
 				 tss, &zc->msg_flags);
 	if (err < 0)
 		return err;
 
 	zc->copybuf_len = err;
@@ -2314,11 +2314,11 @@ static int tcp_inq_hint(struct sock *sk)
  *	tricks with *seq access order and skb->users are not required.
  *	Probably, code can be easily improved even more.
  */
 
 static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
-			      int nonblock, int flags,
+			      int flags,
 			      struct scm_timestamping_internal *tss,
 			      int *cmsg_flags)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	int copied = 0;
@@ -2335,11 +2335,11 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 	if (sk->sk_state == TCP_LISTEN)
 		goto out;
 
 	if (tp->recvmsg_inq)
 		*cmsg_flags = TCP_CMSG_INQ;
-	timeo = sock_rcvtimeo(sk, nonblock);
+	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 
 	/* Urgent data needs to be handled specially. */
 	if (flags & MSG_OOB)
 		goto recv_urg;
 
@@ -2554,11 +2554,11 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 recv_sndq:
 	err = tcp_peek_sndq(sk, msg, len);
 	goto out;
 }
 
-int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
+int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		int flags, int *addr_len)
 {
 	int cmsg_flags = 0, ret, inq;
 	struct scm_timestamping_internal tss;
 
@@ -2566,14 +2566,14 @@ int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int nonblock,
 		return inet_recv_error(sk, msg, len, addr_len);
 
 	if (sk_can_busy_loop(sk) &&
 	    skb_queue_empty_lockless(&sk->sk_receive_queue) &&
 	    sk->sk_state == TCP_ESTABLISHED)
-		sk_busy_loop(sk, nonblock);
+		sk_busy_loop(sk, flags & MSG_DONTWAIT);
 
 	lock_sock(sk);
-	ret = tcp_recvmsg_locked(sk, msg, len, nonblock, flags, &tss,
+	ret = tcp_recvmsg_locked(sk, msg, len, flags, &tss,
 				 &cmsg_flags);
 	release_sock(sk);
 	sk_defer_free_flush(sk);
 
 	if (cmsg_flags && ret >= 0) {
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 1cdcb4df0eb7..be3947e70fec 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -172,11 +172,10 @@ static int tcp_msg_wait_data(struct sock *sk, struct sk_psock *psock,
 }
 
 static int tcp_bpf_recvmsg_parser(struct sock *sk,
 				  struct msghdr *msg,
 				  size_t len,
-				  int nonblock,
 				  int flags,
 				  int *addr_len)
 {
 	struct sk_psock *psock;
 	int copied;
@@ -184,11 +183,11 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
 
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
-		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
+		return tcp_recvmsg(sk, msg, len, flags, addr_len);
 
 	lock_sock(sk);
 msg_bytes_ready:
 	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
 	if (!copied) {
@@ -209,11 +208,11 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 		if (sk->sk_state == TCP_CLOSE) {
 			copied = -ENOTCONN;
 			goto out;
 		}
 
-		timeo = sock_rcvtimeo(sk, nonblock);
+		timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 		if (!timeo) {
 			copied = -EAGAIN;
 			goto out;
 		}
 
@@ -232,41 +231,41 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 	sk_psock_put(sk, psock);
 	return copied;
 }
 
 static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
-		    int nonblock, int flags, int *addr_len)
+			   int flags, int *addr_len)
 {
 	struct sk_psock *psock;
 	int copied, ret;
 
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
 
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
-		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
+		return tcp_recvmsg(sk, msg, len, flags, addr_len);
 	if (!skb_queue_empty(&sk->sk_receive_queue) &&
 	    sk_psock_queue_empty(psock)) {
 		sk_psock_put(sk, psock);
-		return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
+		return tcp_recvmsg(sk, msg, len, flags, addr_len);
 	}
 	lock_sock(sk);
 msg_bytes_ready:
 	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
 	if (!copied) {
 		long timeo;
 		int data;
 
-		timeo = sock_rcvtimeo(sk, nonblock);
+		timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 		data = tcp_msg_wait_data(sk, psock, timeo);
 		if (data) {
 			if (!sk_psock_queue_empty(psock))
 				goto msg_bytes_ready;
 			release_sock(sk);
 			sk_psock_put(sk, psock);
-			return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
+			return tcp_recvmsg(sk, msg, len, flags, addr_len);
 		}
 		copied = -EAGAIN;
 	}
 	ret = copied;
 	release_sock(sk);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 6b4d8361560f..ad9722cfa0f2 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1724,20 +1724,19 @@ int udp_ioctl(struct sock *sk, int cmd, unsigned long arg)
 	return 0;
 }
 EXPORT_SYMBOL(udp_ioctl);
 
 struct sk_buff *__skb_recv_udp(struct sock *sk, unsigned int flags,
-			       int noblock, int *off, int *err)
+			       int *off, int *err)
 {
 	struct sk_buff_head *sk_queue = &sk->sk_receive_queue;
 	struct sk_buff_head *queue;
 	struct sk_buff *last;
 	long timeo;
 	int error;
 
 	queue = &udp_sk(sk)->reader_queue;
-	flags |= noblock ? MSG_DONTWAIT : 0;
 	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 	do {
 		struct sk_buff *skb;
 
 		error = sock_error(sk);
@@ -1803,11 +1802,11 @@ int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
 
 	while (1) {
 		struct sk_buff *skb;
 		int err, used;
 
-		skb = skb_recv_udp(sk, 0, 1, &err);
+		skb = skb_recv_udp(sk, MSG_DONTWAIT, &err);
 		if (!skb)
 			return err;
 
 		if (udp_lib_checksum_complete(skb)) {
 			__UDP_INC_STATS(sock_net(sk), UDP_MIB_CSUMERRORS,
@@ -1841,11 +1840,11 @@ EXPORT_SYMBOL(udp_read_sock);
 /*
  * 	This should be easy, if there is something there we
  * 	return it, otherwise we block.
  */
 
-int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
+int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		int flags, int *addr_len)
 {
 	struct inet_sock *inet = inet_sk(sk);
 	DECLARE_SOCKADDR(struct sockaddr_in *, sin, msg->msg_name);
 	struct sk_buff *skb;
@@ -1857,11 +1856,11 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 	if (flags & MSG_ERRQUEUE)
 		return ip_recv_error(sk, msg, len, addr_len);
 
 try_again:
 	off = sk_peek_offset(sk, flags);
-	skb = __skb_recv_udp(sk, flags, noblock, &off, &err);
+	skb = __skb_recv_udp(sk, flags, &off, &err);
 	if (!skb)
 		return err;
 
 	ulen = udp_skb_len(skb);
 	copied = len;
diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
index bbe6569c9ad3..5da2e2ae5de5 100644
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -9,18 +9,18 @@
 #include "udp_impl.h"
 
 static struct proto *udpv6_prot_saved __read_mostly;
 
 static int sk_udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
-			  int noblock, int flags, int *addr_len)
+			  int flags, int *addr_len)
 {
 #if IS_ENABLED(CONFIG_IPV6)
 	if (sk->sk_family == AF_INET6)
-		return udpv6_prot_saved->recvmsg(sk, msg, len, noblock, flags,
+		return udpv6_prot_saved->recvmsg(sk, msg, len, flags,
 						 addr_len);
 #endif
-	return udp_prot.recvmsg(sk, msg, len, noblock, flags, addr_len);
+	return udp_prot.recvmsg(sk, msg, len, flags, addr_len);
 }
 
 static bool udp_sk_has_data(struct sock *sk)
 {
 	return !skb_queue_empty(&udp_sk(sk)->reader_queue) ||
@@ -59,39 +59,39 @@ static int udp_msg_wait_data(struct sock *sk, struct sk_psock *psock,
 	remove_wait_queue(sk_sleep(sk), &wait);
 	return ret;
 }
 
 static int udp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
-			   int nonblock, int flags, int *addr_len)
+			   int flags, int *addr_len)
 {
 	struct sk_psock *psock;
 	int copied, ret;
 
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
 
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock))
-		return sk_udp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
+		return sk_udp_recvmsg(sk, msg, len, flags, addr_len);
 
 	if (!psock_has_data(psock)) {
-		ret = sk_udp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
+		ret = sk_udp_recvmsg(sk, msg, len, flags, addr_len);
 		goto out;
 	}
 
 msg_bytes_ready:
 	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
 	if (!copied) {
 		long timeo;
 		int data;
 
-		timeo = sock_rcvtimeo(sk, nonblock);
+		timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 		data = udp_msg_wait_data(sk, psock, timeo);
 		if (data) {
 			if (psock_has_data(psock))
 				goto msg_bytes_ready;
-			ret = sk_udp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
+			ret = sk_udp_recvmsg(sk, msg, len, flags, addr_len);
 			goto out;
 		}
 		copied = -EAGAIN;
 	}
 	ret = copied;
diff --git a/net/ipv4/udp_impl.h b/net/ipv4/udp_impl.h
index 2878d8285caf..a6574ac08472 100644
--- a/net/ipv4/udp_impl.h
+++ b/net/ipv4/udp_impl.h
@@ -15,11 +15,11 @@ void udp_v4_rehash(struct sock *sk);
 int udp_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
 		   unsigned int optlen);
 int udp_getsockopt(struct sock *sk, int level, int optname,
 		   char __user *optval, int __user *optlen);
 
-int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
+int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		int flags, int *addr_len);
 int udp_sendpage(struct sock *sk, struct page *page, int offset, size_t size,
 		 int flags);
 void udp_destroy_sock(struct sock *sk);
 
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 7d7b7523d126..6595a78672c8 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -652,11 +652,11 @@ int inet6_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	return INDIRECT_CALL_2(prot->sendmsg, tcp_sendmsg, udpv6_sendmsg,
 			       sk, msg, size);
 }
 
 INDIRECT_CALLABLE_DECLARE(int udpv6_recvmsg(struct sock *, struct msghdr *,
-					    size_t, int, int, int *));
+					    size_t, int, int *));
 int inet6_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		  int flags)
 {
 	struct sock *sk = sock->sk;
 	const struct proto *prot;
@@ -667,12 +667,11 @@ int inet6_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		sock_rps_record_flow(sk);
 
 	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
 	prot = READ_ONCE(sk->sk_prot);
 	err = INDIRECT_CALL_2(prot->recvmsg, tcp_recvmsg, udpv6_recvmsg,
-			      sk, msg, size, flags & MSG_DONTWAIT,
-			      flags & ~MSG_DONTWAIT, &addr_len);
+			      sk, msg, size, flags, &addr_len);
 	if (err >= 0)
 		msg->msg_namelen = addr_len;
 	return err;
 }
 
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 8bb41f3b246a..0d7c13d33d1a 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -458,11 +458,11 @@ int rawv6_rcv(struct sock *sk, struct sk_buff *skb)
  *	This should be easy, if there is something there
  *	we return it, otherwise we block.
  */
 
 static int rawv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
-			 int noblock, int flags, int *addr_len)
+			 int flags, int *addr_len)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	DECLARE_SOCKADDR(struct sockaddr_in6 *, sin6, msg->msg_name);
 	struct sk_buff *skb;
 	size_t copied;
@@ -475,11 +475,10 @@ static int rawv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		return ipv6_recv_error(sk, msg, len, addr_len);
 
 	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
 		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
-	flags |= (noblock ? MSG_DONTWAIT : 0);
 	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto out;
 
 	copied = skb->len;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 7f0fa9bd9ffe..db9449b52dbe 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -320,11 +320,11 @@ static int udp6_skb_len(struct sk_buff *skb)
  *	This should be easy, if there is something there we
  *	return it, otherwise we block.
  */
 
 int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
-		  int noblock, int flags, int *addr_len)
+		  int flags, int *addr_len)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct inet_sock *inet = inet_sk(sk);
 	struct sk_buff *skb;
 	unsigned int ulen, copied;
@@ -340,11 +340,11 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
 		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
 try_again:
 	off = sk_peek_offset(sk, flags);
-	skb = __skb_recv_udp(sk, flags, noblock, &off, &err);
+	skb = __skb_recv_udp(sk, flags, &off, &err);
 	if (!skb)
 		return err;
 
 	ulen = udp6_skb_len(skb);
 	copied = len;
diff --git a/net/ipv6/udp_impl.h b/net/ipv6/udp_impl.h
index b2fcc46c1630..1cd65d03c257 100644
--- a/net/ipv6/udp_impl.h
+++ b/net/ipv6/udp_impl.h
@@ -18,11 +18,11 @@ void udp_v6_rehash(struct sock *sk);
 int udpv6_getsockopt(struct sock *sk, int level, int optname,
 		     char __user *optval, int __user *optlen);
 int udpv6_setsockopt(struct sock *sk, int level, int optname, sockptr_t optval,
 		     unsigned int optlen);
 int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len);
-int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
+int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		  int flags, int *addr_len);
 void udpv6_destroy_sock(struct sock *sk);
 
 #ifdef CONFIG_PROC_FS
 int udp6_seq_show(struct seq_file *seq, void *v);
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index c6a5cc2d88e7..6af09e188e52 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -513,22 +513,21 @@ static int l2tp_ip_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	rc = -EHOSTUNREACH;
 	goto out;
 }
 
 static int l2tp_ip_recvmsg(struct sock *sk, struct msghdr *msg,
-			   size_t len, int noblock, int flags, int *addr_len)
+			   size_t len, int flags, int *addr_len)
 {
 	struct inet_sock *inet = inet_sk(sk);
 	size_t copied = 0;
 	int err = -EOPNOTSUPP;
 	DECLARE_SOCKADDR(struct sockaddr_in *, sin, msg->msg_name);
 	struct sk_buff *skb;
 
 	if (flags & MSG_OOB)
 		goto out;
 
-	flags |= (noblock ? MSG_DONTWAIT : 0);
 	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto out;
 
 	copied = skb->len;
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 97fde8a9209b..217c7192691e 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -655,11 +655,11 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	err = 0;
 	goto done;
 }
 
 static int l2tp_ip6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
-			    int noblock, int flags, int *addr_len)
+			    int flags, int *addr_len)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	DECLARE_SOCKADDR(struct sockaddr_l2tpip6 *, lsa, msg->msg_name);
 	size_t copied = 0;
 	int err = -EOPNOTSUPP;
@@ -669,11 +669,10 @@ static int l2tp_ip6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		goto out;
 
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len, addr_len);
 
-	flags |= (noblock ? MSG_DONTWAIT : 0);
 	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto out;
 
 	copied = skb->len;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 0cbea3b6d0a4..56baeae0b960 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2010,11 +2010,11 @@ static unsigned int mptcp_inq_hint(const struct sock *sk)
 
 	return 0;
 }
 
 static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
-			 int nonblock, int flags, int *addr_len)
+			 int flags, int *addr_len)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct scm_timestamping_internal tss;
 	int copied = 0, cmsg_flags = 0;
 	int target;
@@ -2028,11 +2028,11 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (unlikely(sk->sk_state == TCP_LISTEN)) {
 		copied = -ENOTCONN;
 		goto out_err;
 	}
 
-	timeo = sock_rcvtimeo(sk, nonblock);
+	timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 
 	len = min_t(size_t, len, INT_MAX);
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
 
 	if (unlikely(msk->recvmsg_inq))
diff --git a/net/phonet/datagram.c b/net/phonet/datagram.c
index 3f2e62b63dd4..ff5f49ab236e 100644
--- a/net/phonet/datagram.c
+++ b/net/phonet/datagram.c
@@ -110,22 +110,21 @@ static int pn_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	/* If ok, return len. */
 	return (err >= 0) ? len : err;
 }
 
 static int pn_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
-		      int noblock, int flags, int *addr_len)
+		      int flags, int *addr_len)
 {
 	struct sk_buff *skb = NULL;
 	struct sockaddr_pn sa;
 	int rval = -EOPNOTSUPP;
 	int copylen;
 
 	if (flags & ~(MSG_PEEK|MSG_TRUNC|MSG_DONTWAIT|MSG_NOSIGNAL|
 			MSG_CMSG_COMPAT))
 		goto out_nofree;
 
-	flags |= (noblock ? MSG_DONTWAIT : 0);
 	skb = skb_recv_datagram(sk, flags, &rval);
 	if (skb == NULL)
 		goto out_nofree;
 
 	pn_skb_get_src_sockaddr(skb, &sa);
diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index 441a26706592..83ea13a50690 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -1237,11 +1237,11 @@ struct sk_buff *pep_read(struct sock *sk)
 		pipe_grant_credits(sk, GFP_ATOMIC);
 	return skb;
 }
 
 static int pep_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
-		       int noblock, int flags, int *addr_len)
+		       int flags, int *addr_len)
 {
 	struct sk_buff *skb;
 	int err;
 
 	if (flags & ~(MSG_OOB|MSG_PEEK|MSG_TRUNC|MSG_DONTWAIT|MSG_WAITALL|
@@ -1266,11 +1266,10 @@ static int pep_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		}
 		if (flags & MSG_OOB)
 			return -EINVAL;
 	}
 
-	flags |= (noblock ? MSG_DONTWAIT : 0);
 	skb = skb_recv_datagram(sk, flags, &err);
 	lock_sock(sk);
 	if (skb == NULL) {
 		if (err == -ENOTCONN && sk->sk_state == TCP_CLOSE_WAIT)
 			err = -ECONNRESET;
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 2e8a896af81a..17c4e236ec8b 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1720,11 +1720,10 @@ static int process_rx_list(struct tls_sw_context_rx *ctx,
 }
 
 int tls_sw_recvmsg(struct sock *sk,
 		   struct msghdr *msg,
 		   size_t len,
-		   int nonblock,
 		   int flags,
 		   int *addr_len)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
@@ -1742,12 +1741,10 @@ int tls_sw_recvmsg(struct sock *sk,
 	bool is_kvec = iov_iter_is_kvec(&msg->msg_iter);
 	bool is_peek = flags & MSG_PEEK;
 	bool bpf_strp_enabled;
 	bool zc_capable;
 
-	flags |= nonblock;
-
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return sock_recv_errqueue(sk, msg, len, SOL_IP, IP_RECVERR);
 
 	psock = sk_psock_get(sk);
 	lock_sock(sk);
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index fecbd95da918..e1dd9e9c8452 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2482,12 +2482,11 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg, size_t si
 
 #ifdef CONFIG_BPF_SYSCALL
 	const struct proto *prot = READ_ONCE(sk->sk_prot);
 
 	if (prot != &unix_dgram_proto)
-		return prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
-					    flags & ~MSG_DONTWAIT, NULL);
+		return prot->recvmsg(sk, msg, size, flags, NULL);
 #endif
 	return __unix_dgram_recvmsg(sk, msg, size, flags);
 }
 
 static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
@@ -2915,12 +2914,11 @@ static int unix_stream_recvmsg(struct socket *sock, struct msghdr *msg,
 #ifdef CONFIG_BPF_SYSCALL
 	struct sock *sk = sock->sk;
 	const struct proto *prot = READ_ONCE(sk->sk_prot);
 
 	if (prot != &unix_stream_proto)
-		return prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
-					    flags & ~MSG_DONTWAIT, NULL);
+		return prot->recvmsg(sk, msg, size, flags, NULL);
 #endif
 	return unix_stream_read_generic(&state, true);
 }
 
 static int unix_stream_splice_actor(struct sk_buff *skb,
diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
index 452376c6f419..7cf14c6b1725 100644
--- a/net/unix/unix_bpf.c
+++ b/net/unix/unix_bpf.c
@@ -46,12 +46,11 @@ static int __unix_recvmsg(struct sock *sk, struct msghdr *msg,
 	else
 		return __unix_stream_recvmsg(sk, msg, len, flags);
 }
 
 static int unix_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
-			    size_t len, int nonblock, int flags,
-			    int *addr_len)
+			    size_t len, int flags, int *addr_len)
 {
 	struct unix_sock *u = unix_sk(sk);
 	struct sk_psock *psock;
 	int copied;
 
@@ -71,11 +70,11 @@ static int unix_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
 	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
 	if (!copied) {
 		long timeo;
 		int data;
 
-		timeo = sock_rcvtimeo(sk, nonblock);
+		timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 		data = unix_msg_wait_data(sk, psock, timeo);
 		if (data) {
 			if (!sk_psock_queue_empty(psock))
 				goto msg_bytes_ready;
 			mutex_unlock(&u->iolock);
diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index 1f08ebf7d80c..82d14eea1b5a 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -129,20 +129,18 @@ static int espintcp_parse(struct strparser *strp, struct sk_buff *skb)
 
 	return len;
 }
 
 static int espintcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
-			    int nonblock, int flags, int *addr_len)
+			    int flags, int *addr_len)
 {
 	struct espintcp_ctx *ctx = espintcp_getctx(sk);
 	struct sk_buff *skb;
 	int err = 0;
 	int copied;
 	int off = 0;
 
-	flags |= nonblock ? MSG_DONTWAIT : 0;
-
 	skb = __skb_recv_datagram(sk, &ctx->ike_queue, flags, &off, &err);
 	if (!skb) {
 		if (err == -EAGAIN && sk->sk_shutdown & RCV_SHUTDOWN)
 			return 0;
 		return err;
-- 
2.30.2

