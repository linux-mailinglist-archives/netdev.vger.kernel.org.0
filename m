Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E033B4932
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 21:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhFYTVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 15:21:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29727 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229850AbhFYTVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 15:21:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624648720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oupoHnB3UEE5HdNbxVuZe8S7XUPHQ6IGOD0QF4b8OHA=;
        b=Us5IrImyqANdHD3Ad4FJDRLyf3FKEiClbMb1sUkwzNJPsyAp/+hcLji5W3wQBqUpBhbv3N
        S2cIWvnnqkcyL0G6ZZmSYpqaf5YMDZThIjOz70tnHmZlMfBsvnUIxwXeGNTrkg04Sbup5d
        ad1Mj1hvRe8E+FbPoTTyrkeVSjzes6E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-keTuWDenNdayh_jIG0QxlA-1; Fri, 25 Jun 2021 15:18:38 -0400
X-MC-Unique: keTuWDenNdayh_jIG0QxlA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13E8AA40C1;
        Fri, 25 Jun 2021 19:18:37 +0000 (UTC)
Received: from carbon.redhat.com (ovpn-114-32.rdu2.redhat.com [10.10.114.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D2AD17C5F;
        Fri, 25 Jun 2021 19:18:36 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org
Subject: [PATCH net-next 1/2] net: sock: introduce sk_error_report
Date:   Fri, 25 Jun 2021 15:18:21 -0400
Message-Id: <20210625191822.77721-2-aahringo@redhat.com>
In-Reply-To: <20210625191822.77721-1-aahringo@redhat.com>
References: <20210625191822.77721-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces a function wrapper to call the sk_error_report
callback. That will prepare to add additional handling whenever
sk_error_report is called, for example to trace socket errors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 .../chelsio/inline_crypto/chtls/chtls_cm.c    |  2 +-
 drivers/vhost/vsock.c                         |  2 +-
 include/linux/skmsg.h                         |  2 +-
 include/net/sock.h                            |  2 ++
 include/net/tls.h                             |  2 +-
 net/caif/caif_socket.c                        |  2 +-
 net/can/bcm.c                                 |  4 ++--
 net/can/isotp.c                               | 20 +++++++++----------
 net/can/j1939/socket.c                        |  4 ++--
 net/can/raw.c                                 |  6 +++---
 net/core/skbuff.c                             |  6 +++---
 net/core/sock.c                               |  6 ++++++
 net/dccp/ipv4.c                               |  4 ++--
 net/dccp/ipv6.c                               |  4 ++--
 net/dccp/proto.c                              |  2 +-
 net/dccp/timer.c                              |  2 +-
 net/ipv4/ping.c                               |  2 +-
 net/ipv4/raw.c                                |  4 ++--
 net/ipv4/tcp.c                                |  4 ++--
 net/ipv4/tcp_input.c                          |  2 +-
 net/ipv4/tcp_ipv4.c                           |  4 ++--
 net/ipv4/tcp_timer.c                          |  2 +-
 net/ipv4/udp.c                                |  4 ++--
 net/ipv6/raw.c                                |  2 +-
 net/ipv6/tcp_ipv6.c                           |  4 ++--
 net/ipv6/udp.c                                |  2 +-
 net/kcm/kcmsock.c                             |  2 +-
 net/mptcp/subflow.c                           |  2 +-
 net/netlink/af_netlink.c                      |  8 ++++----
 net/nfc/rawsock.c                             |  2 +-
 net/packet/af_packet.c                        |  4 ++--
 net/qrtr/qrtr.c                               |  2 +-
 net/sctp/input.c                              |  2 +-
 net/sctp/ipv6.c                               |  2 +-
 net/smc/af_smc.c                              |  2 +-
 net/strparser/strparser.c                     |  2 +-
 net/unix/af_unix.c                            |  2 +-
 net/vmw_vsock/af_vsock.c                      |  2 +-
 net/vmw_vsock/virtio_transport.c              |  2 +-
 net/vmw_vsock/virtio_transport_common.c       |  2 +-
 net/vmw_vsock/vmci_transport.c                |  4 ++--
 net/xdp/xsk.c                                 |  2 +-
 42 files changed, 75 insertions(+), 67 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index 19dc7dc054a2..bcad69c48074 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -2134,7 +2134,7 @@ static void chtls_abort_req_rss(struct sock *sk, struct sk_buff *skb)
 		sk->sk_err = ETIMEDOUT;
 
 		if (!sock_flag(sk, SOCK_DEAD))
-			sk->sk_error_report(sk);
+			sk_error_report(sk);
 
 		if (sk->sk_state == TCP_SYN_RECV && !abort_syn_rcv(sk, skb))
 			return;
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 119f08491d3c..d38c996b4f46 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -734,7 +734,7 @@ static void vhost_vsock_reset_orphans(struct sock *sk)
 	vsk->peer_shutdown = SHUTDOWN_MASK;
 	sk->sk_state = SS_UNCONNECTED;
 	sk->sk_err = ECONNRESET;
-	sk->sk_error_report(sk);
+	sk_error_report(sk);
 }
 
 static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index fcaa9a7996c8..31866031e370 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -347,7 +347,7 @@ static inline void sk_psock_report_error(struct sk_psock *psock, int err)
 	struct sock *sk = psock->sk;
 
 	sk->sk_err = err;
-	sk->sk_error_report(sk);
+	sk_error_report(sk);
 }
 
 struct sk_psock *sk_psock_init(struct sock *sk, int node);
diff --git a/include/net/sock.h b/include/net/sock.h
index ced2fc965ec7..8bdd80027ffb 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2281,6 +2281,8 @@ static inline int sock_error(struct sock *sk)
 	return -err;
 }
 
+void sk_error_report(struct sock *sk);
+
 static inline unsigned long sock_wspace(struct sock *sk)
 {
 	int amt = 0;
diff --git a/include/net/tls.h b/include/net/tls.h
index 8d398a5de3ee..be4b3e1cac46 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -469,7 +469,7 @@ static inline bool tls_is_sk_tx_device_offloaded(struct sock *sk)
 static inline void tls_err_abort(struct sock *sk, int err)
 {
 	sk->sk_err = err;
-	sk->sk_error_report(sk);
+	sk_error_report(sk);
 }
 
 static inline bool tls_bigint_increment(unsigned char *seq, int len)
diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 3ad0a1df6712..647554c9813b 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -243,7 +243,7 @@ static void caif_ctrl_cb(struct cflayer *layr,
 		cf_sk->sk.sk_shutdown = SHUTDOWN_MASK;
 		cf_sk->sk.sk_err = ECONNRESET;
 		set_rx_flow_on(cf_sk);
-		cf_sk->sk.sk_error_report(&cf_sk->sk);
+		sk_error_report(&cf_sk->sk);
 		break;
 
 	default:
diff --git a/net/can/bcm.c b/net/can/bcm.c
index f3e4d9528fa3..e15a7dbe5f6c 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1417,7 +1417,7 @@ static void bcm_notify(struct bcm_sock *bo, unsigned long msg,
 		if (notify_enodev) {
 			sk->sk_err = ENODEV;
 			if (!sock_flag(sk, SOCK_DEAD))
-				sk->sk_error_report(sk);
+				sk_error_report(sk);
 		}
 		break;
 
@@ -1425,7 +1425,7 @@ static void bcm_notify(struct bcm_sock *bo, unsigned long msg,
 		if (bo->bound && bo->ifindex == dev->ifindex) {
 			sk->sk_err = ENETDOWN;
 			if (!sock_flag(sk, SOCK_DEAD))
-				sk->sk_error_report(sk);
+				sk_error_report(sk);
 		}
 	}
 }
diff --git a/net/can/isotp.c b/net/can/isotp.c
index bd49299319a1..9fd274cf166b 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -168,7 +168,7 @@ static enum hrtimer_restart isotp_rx_timer_handler(struct hrtimer *hrtimer)
 		/* report 'connection timed out' */
 		sk->sk_err = ETIMEDOUT;
 		if (!sock_flag(sk, SOCK_DEAD))
-			sk->sk_error_report(sk);
+			sk_error_report(sk);
 
 		/* reset rx state */
 		so->rx.state = ISOTP_IDLE;
@@ -339,7 +339,7 @@ static int isotp_rcv_fc(struct isotp_sock *so, struct canfd_frame *cf, int ae)
 		/* malformed PDU - report 'not a data message' */
 		sk->sk_err = EBADMSG;
 		if (!sock_flag(sk, SOCK_DEAD))
-			sk->sk_error_report(sk);
+			sk_error_report(sk);
 
 		so->tx.state = ISOTP_IDLE;
 		wake_up_interruptible(&so->wait);
@@ -392,7 +392,7 @@ static int isotp_rcv_fc(struct isotp_sock *so, struct canfd_frame *cf, int ae)
 		/* overflow on receiver side - report 'message too long' */
 		sk->sk_err = EMSGSIZE;
 		if (!sock_flag(sk, SOCK_DEAD))
-			sk->sk_error_report(sk);
+			sk_error_report(sk);
 		fallthrough;
 
 	default:
@@ -420,7 +420,7 @@ static int isotp_rcv_sf(struct sock *sk, struct canfd_frame *cf, int pcilen,
 		/* malformed PDU - report 'not a data message' */
 		sk->sk_err = EBADMSG;
 		if (!sock_flag(sk, SOCK_DEAD))
-			sk->sk_error_report(sk);
+			sk_error_report(sk);
 		return 1;
 	}
 
@@ -535,7 +535,7 @@ static int isotp_rcv_cf(struct sock *sk, struct canfd_frame *cf, int ae,
 		/* wrong sn detected - report 'illegal byte sequence' */
 		sk->sk_err = EILSEQ;
 		if (!sock_flag(sk, SOCK_DEAD))
-			sk->sk_error_report(sk);
+			sk_error_report(sk);
 
 		/* reset rx state */
 		so->rx.state = ISOTP_IDLE;
@@ -559,7 +559,7 @@ static int isotp_rcv_cf(struct sock *sk, struct canfd_frame *cf, int ae,
 			/* malformed PDU - report 'not a data message' */
 			sk->sk_err = EBADMSG;
 			if (!sock_flag(sk, SOCK_DEAD))
-				sk->sk_error_report(sk);
+				sk_error_report(sk);
 			return 1;
 		}
 
@@ -758,7 +758,7 @@ static enum hrtimer_restart isotp_tx_timer_handler(struct hrtimer *hrtimer)
 		/* report 'communication error on send' */
 		sk->sk_err = ECOMM;
 		if (!sock_flag(sk, SOCK_DEAD))
-			sk->sk_error_report(sk);
+			sk_error_report(sk);
 
 		/* reset tx state */
 		so->tx.state = ISOTP_IDLE;
@@ -1157,7 +1157,7 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	if (notify_enetdown) {
 		sk->sk_err = ENETDOWN;
 		if (!sock_flag(sk, SOCK_DEAD))
-			sk->sk_error_report(sk);
+			sk_error_report(sk);
 	}
 
 	return err;
@@ -1356,13 +1356,13 @@ static void isotp_notify(struct isotp_sock *so, unsigned long msg,
 
 		sk->sk_err = ENODEV;
 		if (!sock_flag(sk, SOCK_DEAD))
-			sk->sk_error_report(sk);
+			sk_error_report(sk);
 		break;
 
 	case NETDEV_DOWN:
 		sk->sk_err = ENETDOWN;
 		if (!sock_flag(sk, SOCK_DEAD))
-			sk->sk_error_report(sk);
+			sk_error_report(sk);
 		break;
 	}
 }
diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 56aa66147d5a..bf18a32dc6ae 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -1009,7 +1009,7 @@ void j1939_sk_send_loop_abort(struct sock *sk, int err)
 {
 	sk->sk_err = err;
 
-	sk->sk_error_report(sk);
+	sk_error_report(sk);
 }
 
 static int j1939_sk_send_loop(struct j1939_priv *priv,  struct sock *sk,
@@ -1189,7 +1189,7 @@ void j1939_sk_netdev_event_netdown(struct j1939_priv *priv)
 	list_for_each_entry(jsk, &priv->j1939_socks, list) {
 		jsk->sk.sk_err = error_code;
 		if (!sock_flag(&jsk->sk, SOCK_DEAD))
-			jsk->sk.sk_error_report(&jsk->sk);
+			sk_error_report(&jsk->sk);
 
 		j1939_sk_queue_drop_all(priv, jsk, error_code);
 	}
diff --git a/net/can/raw.c b/net/can/raw.c
index ac96fc210025..ed4fcb7ab0c3 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -295,13 +295,13 @@ static void raw_notify(struct raw_sock *ro, unsigned long msg,
 
 		sk->sk_err = ENODEV;
 		if (!sock_flag(sk, SOCK_DEAD))
-			sk->sk_error_report(sk);
+			sk_error_report(sk);
 		break;
 
 	case NETDEV_DOWN:
 		sk->sk_err = ENETDOWN;
 		if (!sock_flag(sk, SOCK_DEAD))
-			sk->sk_error_report(sk);
+			sk_error_report(sk);
 		break;
 	}
 }
@@ -488,7 +488,7 @@ static int raw_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	if (notify_enetdown) {
 		sk->sk_err = ENETDOWN;
 		if (!sock_flag(sk, SOCK_DEAD))
-			sk->sk_error_report(sk);
+			sk_error_report(sk);
 	}
 
 	return err;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2531ac4ffa69..12aabcda6db2 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1294,7 +1294,7 @@ static void __msg_zerocopy_callback(struct ubuf_info *uarg)
 	}
 	spin_unlock_irqrestore(&q->lock, flags);
 
-	sk->sk_error_report(sk);
+	sk_error_report(sk);
 
 release:
 	consume_skb(skb);
@@ -4685,7 +4685,7 @@ int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb)
 
 	skb_queue_tail(&sk->sk_error_queue, skb);
 	if (!sock_flag(sk, SOCK_DEAD))
-		sk->sk_error_report(sk);
+		sk_error_report(sk);
 	return 0;
 }
 EXPORT_SYMBOL(sock_queue_err_skb);
@@ -4716,7 +4716,7 @@ struct sk_buff *sock_dequeue_err_skb(struct sock *sk)
 		sk->sk_err = 0;
 
 	if (skb_next)
-		sk->sk_error_report(sk);
+		sk_error_report(sk);
 
 	return skb;
 }
diff --git a/net/core/sock.c b/net/core/sock.c
index a2337b37eba6..c30f8f4cbb22 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -331,6 +331,12 @@ int __sk_backlog_rcv(struct sock *sk, struct sk_buff *skb)
 }
 EXPORT_SYMBOL(__sk_backlog_rcv);
 
+void sk_error_report(struct sock *sk)
+{
+	sk->sk_error_report(sk);
+}
+EXPORT_SYMBOL(sk_error_report);
+
 static int sock_get_timeout(long timeo, void *optval, bool old_timeval)
 {
 	struct __kernel_sock_timeval tv;
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index f81c1df761d3..0ea29270d7e5 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -329,7 +329,7 @@ static int dccp_v4_err(struct sk_buff *skb, u32 info)
 			__DCCP_INC_STATS(DCCP_MIB_ATTEMPTFAILS);
 			sk->sk_err = err;
 
-			sk->sk_error_report(sk);
+			sk_error_report(sk);
 
 			dccp_done(sk);
 		} else
@@ -356,7 +356,7 @@ static int dccp_v4_err(struct sk_buff *skb, u32 info)
 	inet = inet_sk(sk);
 	if (!sock_owned_by_user(sk) && inet->recverr) {
 		sk->sk_err = err;
-		sk->sk_error_report(sk);
+		sk_error_report(sk);
 	} else /* Only an error on timeout */
 		sk->sk_err_soft = err;
 out:
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 6f5304db5a67..fa663518fa0e 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -172,7 +172,7 @@ static int dccp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 			 * Wake people up to see the error
 			 * (see connect in sock.c)
 			 */
-			sk->sk_error_report(sk);
+			sk_error_report(sk);
 			dccp_done(sk);
 		} else
 			sk->sk_err_soft = err;
@@ -181,7 +181,7 @@ static int dccp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
 	if (!sock_owned_by_user(sk) && np->recverr) {
 		sk->sk_err = err;
-		sk->sk_error_report(sk);
+		sk_error_report(sk);
 	} else
 		sk->sk_err_soft = err;
 
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index 6d705d90c614..7eb0fb231940 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -302,7 +302,7 @@ int dccp_disconnect(struct sock *sk, int flags)
 
 	WARN_ON(inet->inet_num && !icsk->icsk_bind_hash);
 
-	sk->sk_error_report(sk);
+	sk_error_report(sk);
 	return 0;
 }
 
diff --git a/net/dccp/timer.c b/net/dccp/timer.c
index db768f223ef7..27a3b37acd2e 100644
--- a/net/dccp/timer.c
+++ b/net/dccp/timer.c
@@ -20,7 +20,7 @@ int  sysctl_dccp_retries2		__read_mostly = TCP_RETR2;
 static void dccp_write_err(struct sock *sk)
 {
 	sk->sk_err = sk->sk_err_soft ? : ETIMEDOUT;
-	sk->sk_error_report(sk);
+	sk_error_report(sk);
 
 	dccp_send_reset(sk, DCCP_RESET_CODE_ABORTED);
 	dccp_done(sk);
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 95a718397fd1..1e44a43acfe2 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -573,7 +573,7 @@ void ping_err(struct sk_buff *skb, int offset, u32 info)
 		}
 	}
 	sk->sk_err = err;
-	sk->sk_error_report(sk);
+	sk_error_report(sk);
 out:
 	sock_put(sk);
 }
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 50a73178d63a..bb446e60cf58 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -280,7 +280,7 @@ static void raw_err(struct sock *sk, struct sk_buff *skb, u32 info)
 
 	if (inet->recverr || harderr) {
 		sk->sk_err = err;
-		sk->sk_error_report(sk);
+		sk_error_report(sk);
 	}
 }
 
@@ -929,7 +929,7 @@ int raw_abort(struct sock *sk, int err)
 	lock_sock(sk);
 
 	sk->sk_err = err;
-	sk->sk_error_report(sk);
+	sk_error_report(sk);
 	__udp_disconnect(sk, 0);
 
 	release_sock(sk);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 0e3f0e0e5b51..a0a96eb826c4 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3059,7 +3059,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 		sk->sk_frag.offset = 0;
 	}
 
-	sk->sk_error_report(sk);
+	sk_error_report(sk);
 	return 0;
 }
 EXPORT_SYMBOL(tcp_disconnect);
@@ -4448,7 +4448,7 @@ int tcp_abort(struct sock *sk, int err)
 		sk->sk_err = err;
 		/* This barrier is coupled with smp_rmb() in tcp_poll() */
 		smp_wmb();
-		sk->sk_error_report(sk);
+		sk_error_report(sk);
 		if (tcp_need_reset(sk->sk_state))
 			tcp_send_active_reset(sk, GFP_ATOMIC);
 		tcp_done(sk);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 7d5e59f688de..e6ca5a1f3b59 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4270,7 +4270,7 @@ void tcp_reset(struct sock *sk, struct sk_buff *skb)
 	tcp_done(sk);
 
 	if (!sock_flag(sk, SOCK_DEAD))
-		sk->sk_error_report(sk);
+		sk_error_report(sk);
 }
 
 /*
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 6cb8e269f1ab..e66ad6bfe808 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -585,7 +585,7 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 		if (!sock_owned_by_user(sk)) {
 			sk->sk_err = err;
 
-			sk->sk_error_report(sk);
+			sk_error_report(sk);
 
 			tcp_done(sk);
 		} else {
@@ -613,7 +613,7 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 	inet = inet_sk(sk);
 	if (!sock_owned_by_user(sk) && inet->recverr) {
 		sk->sk_err = err;
-		sk->sk_error_report(sk);
+		sk_error_report(sk);
 	} else	{ /* Only an error on timeout */
 		sk->sk_err_soft = err;
 	}
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 56b9d648f054..20cf4a98c69d 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -68,7 +68,7 @@ u32 tcp_clamp_probe0_to_user_timeout(const struct sock *sk, u32 when)
 static void tcp_write_err(struct sock *sk)
 {
 	sk->sk_err = sk->sk_err_soft ? : ETIMEDOUT;
-	sk->sk_error_report(sk);
+	sk_error_report(sk);
 
 	tcp_write_queue_purge(sk);
 	tcp_done(sk);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 1307ad0d3b9e..f86ccbf7c135 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -776,7 +776,7 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
 		ip_icmp_error(sk, skb, err, uh->dest, info, (u8 *)(uh+1));
 
 	sk->sk_err = err;
-	sk->sk_error_report(sk);
+	sk_error_report(sk);
 out:
 	return 0;
 }
@@ -2867,7 +2867,7 @@ int udp_abort(struct sock *sk, int err)
 		goto out;
 
 	sk->sk_err = err;
-	sk->sk_error_report(sk);
+	sk_error_report(sk);
 	__udp_disconnect(sk, 0);
 
 out:
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index bf3646b57c68..60f1e4f5be5a 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -354,7 +354,7 @@ static void rawv6_err(struct sock *sk, struct sk_buff *skb,
 
 	if (np->recverr || harderr) {
 		sk->sk_err = err;
-		sk->sk_error_report(sk);
+		sk_error_report(sk);
 	}
 }
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 4d71464094b3..578ab6305c3f 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -467,7 +467,7 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
 		if (!sock_owned_by_user(sk)) {
 			sk->sk_err = err;
-			sk->sk_error_report(sk);		/* Wake people up to see the error (see connect in sock.c) */
+			sk_error_report(sk);		/* Wake people up to see the error (see connect in sock.c) */
 
 			tcp_done(sk);
 		} else
@@ -486,7 +486,7 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 
 	if (!sock_owned_by_user(sk) && np->recverr) {
 		sk->sk_err = err;
-		sk->sk_error_report(sk);
+		sk_error_report(sk);
 	} else
 		sk->sk_err_soft = err;
 
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 3fcd86f4dfdc..368972dbd919 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -610,7 +610,7 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	}
 
 	sk->sk_err = err;
-	sk->sk_error_report(sk);
+	sk_error_report(sk);
 out:
 	return 0;
 }
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 6201965bd822..11a715d76a4f 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -47,7 +47,7 @@ static inline struct kcm_tx_msg *kcm_tx_msg(struct sk_buff *skb)
 static void report_csk_error(struct sock *csk, int err)
 {
 	csk->sk_err = EPIPE;
-	csk->sk_error_report(csk);
+	sk_error_report(csk);
 }
 
 static void kcm_abort_tx_psock(struct kcm_psock *psock, int err,
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index d55f4ef736a5..706a26a1b0fe 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1240,7 +1240,7 @@ void __mptcp_error_report(struct sock *sk)
 
 		/* This barrier is coupled with smp_rmb() in mptcp_poll() */
 		smp_wmb();
-		sk->sk_error_report(sk);
+		sk_error_report(sk);
 		break;
 	}
 }
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 6133e412b948..d233ac4a91b6 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -351,7 +351,7 @@ static void netlink_overrun(struct sock *sk)
 		if (!test_and_set_bit(NETLINK_S_CONGESTED,
 				      &nlk_sk(sk)->state)) {
 			sk->sk_err = ENOBUFS;
-			sk->sk_error_report(sk);
+			sk_error_report(sk);
 		}
 	}
 	atomic_inc(&sk->sk_drops);
@@ -1576,7 +1576,7 @@ static int do_one_set_err(struct sock *sk, struct netlink_set_err_data *p)
 	}
 
 	sk->sk_err = p->code;
-	sk->sk_error_report(sk);
+	sk_error_report(sk);
 out:
 	return ret;
 }
@@ -2012,7 +2012,7 @@ static int netlink_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		ret = netlink_dump(sk);
 		if (ret) {
 			sk->sk_err = -ret;
-			sk->sk_error_report(sk);
+			sk_error_report(sk);
 		}
 	}
 
@@ -2439,7 +2439,7 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 	skb = nlmsg_new(payload + tlvlen, GFP_KERNEL);
 	if (!skb) {
 		NETLINK_CB(in_skb).sk->sk_err = ENOBUFS;
-		NETLINK_CB(in_skb).sk->sk_error_report(NETLINK_CB(in_skb).sk);
+		sk_error_report(NETLINK_CB(in_skb).sk);
 		return;
 	}
 
diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index 5f1d438a0a23..5e39640becdb 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -49,7 +49,7 @@ static void rawsock_report_error(struct sock *sk, int err)
 
 	sk->sk_shutdown = SHUTDOWN_MASK;
 	sk->sk_err = -err;
-	sk->sk_error_report(sk);
+	sk_error_report(sk);
 
 	rawsock_write_queue_purge(sk);
 }
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 77b0cdab3810..77476184741d 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3206,7 +3206,7 @@ static int packet_do_bind(struct sock *sk, const char *name, int ifindex,
 	} else {
 		sk->sk_err = ENETDOWN;
 		if (!sock_flag(sk, SOCK_DEAD))
-			sk->sk_error_report(sk);
+			sk_error_report(sk);
 	}
 
 out_unlock:
@@ -4103,7 +4103,7 @@ static int packet_notifier(struct notifier_block *this,
 					__unregister_prot_hook(sk, false);
 					sk->sk_err = ENETDOWN;
 					if (!sock_flag(sk, SOCK_DEAD))
-						sk->sk_error_report(sk);
+						sk_error_report(sk);
 				}
 				if (msg == NETDEV_UNREGISTER) {
 					packet_cached_dev_reset(po);
diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index f2efaa4225f9..1a8fd1cc0581 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -751,7 +751,7 @@ static void qrtr_reset_ports(void)
 	xa_for_each_start(&qrtr_ports, index, ipc, 1) {
 		sock_hold(&ipc->sk);
 		ipc->sk.sk_err = ENETRESET;
-		ipc->sk.sk_error_report(&ipc->sk);
+		sk.sk_error_report(&ipc->sk);
 		sock_put(&ipc->sk);
 	}
 	rcu_read_unlock();
diff --git a/net/sctp/input.c b/net/sctp/input.c
index fe6429cc012f..76dcc137f761 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -593,7 +593,7 @@ static void sctp_v4_err_handle(struct sctp_transport *t, struct sk_buff *skb,
 	}
 	if (!sock_owned_by_user(sk) && inet_sk(sk)->recverr) {
 		sk->sk_err = err;
-		sk->sk_error_report(sk);
+		sk_error_report(sk);
 	} else {  /* Only an error on timeout */
 		sk->sk_err_soft = err;
 	}
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 05f81a4d0ee7..d041bed86322 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -152,7 +152,7 @@ static void sctp_v6_err_handle(struct sctp_transport *t, struct sk_buff *skb,
 	icmpv6_err_convert(type, code, &err);
 	if (!sock_owned_by_user(sk) && np->recverr) {
 		sk->sk_err = err;
-		sk->sk_error_report(sk);
+		sk_error_report(sk);
 	} else {
 		sk->sk_err_soft = err;
 	}
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index e41fdac606d4..898389611ae8 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2218,7 +2218,7 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 						   optval, optlen);
 	if (smc->clcsock->sk->sk_err) {
 		sk->sk_err = smc->clcsock->sk->sk_err;
-		sk->sk_error_report(sk);
+		sk_error_report(sk);
 	}
 
 	if (optlen < sizeof(int))
diff --git a/net/strparser/strparser.c b/net/strparser/strparser.c
index b3815c1e8f2e..9c0343568d2a 100644
--- a/net/strparser/strparser.c
+++ b/net/strparser/strparser.c
@@ -58,7 +58,7 @@ static void strp_abort_strp(struct strparser *strp, int err)
 
 		/* Report an error on the lower socket */
 		sk->sk_err = -err;
-		sk->sk_error_report(sk);
+		sk_error_report(sk);
 	}
 }
 
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 58c2f318b0a8..23c92ad15c61 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -491,7 +491,7 @@ static void unix_dgram_disconnected(struct sock *sk, struct sock *other)
 		 */
 		if (!sock_flag(other, SOCK_DEAD) && unix_peer(other) == sk) {
 			other->sk_err = ECONNRESET;
-			other->sk_error_report(other);
+			sk_error_report(other);
 		}
 	}
 }
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 21ccf450e249..9f12da1ff406 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1281,7 +1281,7 @@ static void vsock_connect_timeout(struct work_struct *work)
 	    (sk->sk_shutdown != SHUTDOWN_MASK)) {
 		sk->sk_state = TCP_CLOSE;
 		sk->sk_err = ETIMEDOUT;
-		sk->sk_error_report(sk);
+		sk_error_report(sk);
 		vsock_transport_cancel_pkt(vsk);
 	}
 	release_sock(sk);
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index ed1664e7bd88..e0c2c992ad9c 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -360,7 +360,7 @@ static void virtio_vsock_reset_sock(struct sock *sk)
 	lock_sock(sk);
 	sk->sk_state = TCP_CLOSE;
 	sk->sk_err = ECONNRESET;
-	sk->sk_error_report(sk);
+	sk_error_report(sk);
 	release_sock(sk);
 }
 
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index f014ccfdd9c2..169ba8b72a63 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1007,7 +1007,7 @@ virtio_transport_recv_connecting(struct sock *sk,
 	virtio_transport_reset(vsk, pkt);
 	sk->sk_state = TCP_CLOSE;
 	sk->sk_err = skerr;
-	sk->sk_error_report(sk);
+	sk_error_report(sk);
 	return err;
 }
 
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index e617ed93f06b..7aef34e32bdf 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -831,7 +831,7 @@ static void vmci_transport_handle_detach(struct sock *sk)
 
 				sk->sk_state = TCP_CLOSE;
 				sk->sk_err = ECONNRESET;
-				sk->sk_error_report(sk);
+				sk_error_report(sk);
 				return;
 			}
 			sk->sk_state = TCP_CLOSE;
@@ -1365,7 +1365,7 @@ vmci_transport_recv_connecting_client(struct sock *sk,
 
 	sk->sk_state = TCP_CLOSE;
 	sk->sk_err = skerr;
-	sk->sk_error_report(sk);
+	sk_error_report(sk);
 	return err;
 }
 
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index cd62d4ba87a9..f01abc1c8b99 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -1313,7 +1313,7 @@ static int xsk_notifier(struct notifier_block *this,
 			if (xs->dev == dev) {
 				sk->sk_err = ENETDOWN;
 				if (!sock_flag(sk, SOCK_DEAD))
-					sk->sk_error_report(sk);
+					sk_error_report(sk);
 
 				xsk_unbind_dev(xs);
 
-- 
2.26.3

