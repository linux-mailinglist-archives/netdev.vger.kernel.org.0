Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D52B8F091F
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 23:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387458AbfKEWMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 17:12:17 -0500
Received: from mail-yw1-f74.google.com ([209.85.161.74]:35611 "EHLO
        mail-yw1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387415AbfKEWMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 17:12:17 -0500
Received: by mail-yw1-f74.google.com with SMTP id g69so17583231ywb.2
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 14:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jhTVqolNLLwjm3T47MwJ7GosIGWKqH1awqsG6fVX47g=;
        b=UfleGaIEpQe3mP6r5e7sDyU6LlixK+qtB5BB2przYmel8xbAwPVVgtzYiRHZjE4ZY6
         Vxjc+1L/MsiOHoLFqwXiFNoVh+4jNMFDY1UZc0/hZO1LPN9mEBozu3nZkrCPiCL17imp
         twaBXf8vnHEYhhhVyVQHC9lQd7qIxcOu3QzdanrpabL6eWHWykP/zYJ1TCDOx9KQ+9d5
         /M7PkEcOX1L7oPLuRnUQ6xVxMrXw7S1ye29FF/gXSy1eswoWAZ5yXjPIAqQPNATJkgB1
         iaqSiD27tKuszVoJUplpL/EqtY4GuMY27i2rqivcQgiWG2HR48jApKNh4NqrEZZl24vi
         LZvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jhTVqolNLLwjm3T47MwJ7GosIGWKqH1awqsG6fVX47g=;
        b=hQCi4rCmRMTIziPpoLAkIoaGWB2+noBCH9ynAHNguOWD5TmfFg2ii1q0WQode33h48
         p1rTda12ciUEerHCEDl0GvWugvBDpVrqIZaoxHT1toxtWfx9q6dytqeMu+lkVC0n6Pre
         5vG+3z36eoHARQTZqBYulywA/RdesbFetdcnFTvaq83D2p+YVvnPIr2FuqukkOtX+oEq
         jTtA1yYQ5FxjpHrzIZJm45gul2B5G7v8oj8eHR0mhxbBTpp6g2RPbd9lhIzLT+Vs126v
         QkFINp+qbB6BxZ3TIgOzivAtD2uBKxvYCEMaP/uOndu9yFqsMcvGWZmXQ6JfnogxnbbO
         V/1Q==
X-Gm-Message-State: APjAAAXZlDnyJIaLBsJenZsAB5TIrI7s2+N1n7rWiRf667NTW29E8qfD
        yYBkc3yEcN9OtA1aGmUA29diRpeQ9qANeA==
X-Google-Smtp-Source: APXvYqwOinM+c8Y4jX1VBL0fh6D0TjjfQrHmg/a+/desZMbpAezCa9owvsYcVu+2zwwRXBXXDOjy+uBWxf8sHw==
X-Received: by 2002:a0d:cb90:: with SMTP id n138mr26922062ywd.245.1572991935994;
 Tue, 05 Nov 2019 14:12:15 -0800 (PST)
Date:   Tue,  5 Nov 2019 14:11:52 -0800
In-Reply-To: <20191105221154.232754-1-edumazet@google.com>
Message-Id: <20191105221154.232754-5-edumazet@google.com>
Mime-Version: 1.0
References: <20191105221154.232754-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH net-next 4/6] net: use helpers to change sk_ack_backlog
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Writers are holding a lock, but many readers do not.

Following patch will add appropriate barriers in
sk_acceptq_removed() and sk_acceptq_added().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/atm/signaling.c                     | 2 +-
 net/atm/svc.c                           | 2 +-
 net/ax25/af_ax25.c                      | 2 +-
 net/ax25/ax25_in.c                      | 2 +-
 net/bluetooth/af_bluetooth.c            | 4 ++--
 net/decnet/af_decnet.c                  | 2 +-
 net/decnet/dn_nsp_in.c                  | 2 +-
 net/llc/af_llc.c                        | 2 +-
 net/rose/af_rose.c                      | 4 ++--
 net/sctp/associola.c                    | 4 ++--
 net/sctp/endpointola.c                  | 2 +-
 net/vmw_vsock/af_vsock.c                | 4 ++--
 net/vmw_vsock/hyperv_transport.c        | 2 +-
 net/vmw_vsock/virtio_transport_common.c | 2 +-
 net/vmw_vsock/vmci_transport.c          | 2 +-
 net/x25/af_x25.c                        | 4 ++--
 16 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/net/atm/signaling.c b/net/atm/signaling.c
index 6c11cdf4dd4ce4737dd38bcceccc43dfd272c338..fbd0c5e7b299993bd3a4ae4a6c5f543cb30c5091 100644
--- a/net/atm/signaling.c
+++ b/net/atm/signaling.c
@@ -109,7 +109,7 @@ static int sigd_send(struct atm_vcc *vcc, struct sk_buff *skb)
 			dev_kfree_skb(skb);
 			goto as_indicate_complete;
 		}
-		sk->sk_ack_backlog++;
+		sk_acceptq_added(sk);
 		skb_queue_tail(&sk->sk_receive_queue, skb);
 		pr_debug("waking sk_sleep(sk) 0x%p\n", sk_sleep(sk));
 		sk->sk_state_change(sk);
diff --git a/net/atm/svc.c b/net/atm/svc.c
index 908cbb8654f532548b20f166492a2e02de6324d6..ba144d035e3d41e8ba8115b9b4aa54762fca0d01 100644
--- a/net/atm/svc.c
+++ b/net/atm/svc.c
@@ -381,7 +381,7 @@ static int svc_accept(struct socket *sock, struct socket *newsock, int flags,
 				    msg->pvc.sap_addr.vpi,
 				    msg->pvc.sap_addr.vci);
 		dev_kfree_skb(skb);
-		sk->sk_ack_backlog--;
+		sk_acceptq_removed(sk);
 		if (error) {
 			sigd_enq2(NULL, as_reject, old_vcc, NULL, NULL,
 				  &old_vcc->qos, error);
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index bb222b882b6776481a17c9a4cc9ed6d97150c986..324306d6fde02cb67e13073986bde1c4ed7eae5f 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1384,7 +1384,7 @@ static int ax25_accept(struct socket *sock, struct socket *newsock, int flags,
 
 	/* Now attach up the new socket */
 	kfree_skb(skb);
-	sk->sk_ack_backlog--;
+	sk_acceptq_removed(sk);
 	newsock->state = SS_CONNECTED;
 
 out:
diff --git a/net/ax25/ax25_in.c b/net/ax25/ax25_in.c
index dcdbaeeb2358a45d18ca0987ae5969b8f9a76cad..cd6afe895db9910fb7f8f1abad9016307c660850 100644
--- a/net/ax25/ax25_in.c
+++ b/net/ax25/ax25_in.c
@@ -356,7 +356,7 @@ static int ax25_rcv(struct sk_buff *skb, struct net_device *dev,
 
 		make->sk_state = TCP_ESTABLISHED;
 
-		sk->sk_ack_backlog++;
+		sk_acceptq_added(sk);
 		bh_unlock_sock(sk);
 	} else {
 		if (!mine)
diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index 5f508c50649d0abc317ed83cc0768f6b7a64de96..3fd124927d4d176864004aecdd206407a1f6b836 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -173,7 +173,7 @@ void bt_accept_enqueue(struct sock *parent, struct sock *sk, bool bh)
 	else
 		release_sock(sk);
 
-	parent->sk_ack_backlog++;
+	sk_acceptq_added(parent);
 }
 EXPORT_SYMBOL(bt_accept_enqueue);
 
@@ -185,7 +185,7 @@ void bt_accept_unlink(struct sock *sk)
 	BT_DBG("sk %p state %d", sk, sk->sk_state);
 
 	list_del_init(&bt_sk(sk)->accept_q);
-	bt_sk(sk)->parent->sk_ack_backlog--;
+	sk_acceptq_removed(bt_sk(sk)->parent);
 	bt_sk(sk)->parent = NULL;
 	sock_put(sk);
 }
diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index 3349ea81f9016fb785ec888fadf86faa4d859ed7..e19a92a62e142611f78d942ba22d2b1908430660 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -1091,7 +1091,7 @@ static int dn_accept(struct socket *sock, struct socket *newsock, int flags,
 	}
 
 	cb = DN_SKB_CB(skb);
-	sk->sk_ack_backlog--;
+	sk_acceptq_removed(sk);
 	newsk = dn_alloc_sock(sock_net(sk), newsock, sk->sk_allocation, kern);
 	if (newsk == NULL) {
 		release_sock(sk);
diff --git a/net/decnet/dn_nsp_in.c b/net/decnet/dn_nsp_in.c
index e4161e0c86aa1190bdba483f857922ef12ce0bb6..c68503a180259467505bd1346995ea1bc00df755 100644
--- a/net/decnet/dn_nsp_in.c
+++ b/net/decnet/dn_nsp_in.c
@@ -328,7 +328,7 @@ static void dn_nsp_conn_init(struct sock *sk, struct sk_buff *skb)
 		return;
 	}
 
-	sk->sk_ack_backlog++;
+	sk_acceptq_added(sk);
 	skb_queue_tail(&sk->sk_receive_queue, skb);
 	sk->sk_state_change(sk);
 }
diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index c74f44dfaa22a5020880ea218c6607ace8fd5e22..50d2c9749db36da84f0e84c254771ee5e6c9cef9 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -705,7 +705,7 @@ static int llc_ui_accept(struct socket *sock, struct socket *newsock, int flags,
 
 	/* put original socket back into a clean listen state. */
 	sk->sk_state = TCP_LISTEN;
-	sk->sk_ack_backlog--;
+	sk_acceptq_removed(sk);
 	dprintk("%s: ok success on %02X, client on %02X\n", __func__,
 		llc_sk(sk)->addr.sllc_sap, newllc->daddr.lsap);
 frees:
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 6a0df7c8a939e4976aa2815127885e127dd864fc..46b8ff24020d7bb6788e985686bef12b4fbc83d0 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -906,7 +906,7 @@ static int rose_accept(struct socket *sock, struct socket *newsock, int flags,
 	/* Now attach up the new socket */
 	skb->sk = NULL;
 	kfree_skb(skb);
-	sk->sk_ack_backlog--;
+	sk_acceptq_removed(sk);
 
 out_release:
 	release_sock(sk);
@@ -1011,7 +1011,7 @@ int rose_rx_call_request(struct sk_buff *skb, struct net_device *dev, struct ros
 	make_rose->va        = 0;
 	make_rose->vr        = 0;
 	make_rose->vl        = 0;
-	sk->sk_ack_backlog++;
+	sk_acceptq_added(sk);
 
 	rose_insert_socket(make);
 
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 1ba893b85dad79786ec3fd55c2870072c6c4efa9..1b9809ad772528b3596efc9ae96780dbc70f7cc2 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -324,7 +324,7 @@ void sctp_association_free(struct sctp_association *asoc)
 		 * socket.
 		 */
 		if (sctp_style(sk, TCP) && sctp_sstate(sk, LISTENING))
-			sk->sk_ack_backlog--;
+			sk_acceptq_removed(sk);
 	}
 
 	/* Mark as dead, so other users can know this structure is
@@ -1073,7 +1073,7 @@ void sctp_assoc_migrate(struct sctp_association *assoc, struct sock *newsk)
 
 	/* Decrement the backlog value for a TCP-style socket. */
 	if (sctp_style(oldsk, TCP))
-		oldsk->sk_ack_backlog--;
+		sk_acceptq_removed(oldsk);
 
 	/* Release references to the old endpoint and the sock.  */
 	sctp_endpoint_put(assoc->ep);
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index ea53049d1db663e63def7f5e7e22e788c7456d22..9d05b2e7bce24cad0633efd54ca7223b0426de9a 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -164,7 +164,7 @@ void sctp_endpoint_add_asoc(struct sctp_endpoint *ep,
 
 	/* Increment the backlog value for a TCP-style listening socket. */
 	if (sctp_style(sk, TCP) && sctp_sstate(sk, LISTENING))
-		sk->sk_ack_backlog++;
+		sk_acceptq_added(sk);
 }
 
 /* Free the endpoint structure.  Delay cleanup until
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 582a3e4dfce295fa67100468335bc8dbf8dc1095..e4da879161b74366dfccfec296f3f68a3626f35c 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -439,7 +439,7 @@ static void vsock_pending_work(struct work_struct *work)
 	if (vsock_is_pending(sk)) {
 		vsock_remove_pending(listener, sk);
 
-		listener->sk_ack_backlog--;
+		sk_acceptq_removed(listener);
 	} else if (!vsk->rejected) {
 		/* We are not on the pending list and accept() did not reject
 		 * us, so we must have been accepted by our user process.  We
@@ -1301,7 +1301,7 @@ static int vsock_accept(struct socket *sock, struct socket *newsock, int flags,
 		err = -listener->sk_err;
 
 	if (connected) {
-		listener->sk_ack_backlog--;
+		sk_acceptq_removed(listener);
 
 		lock_sock_nested(connected, SINGLE_DEPTH_NESTING);
 		vconnected = vsock_sk(connected);
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index bef8772116ec82dc43df0120b3eb6987d111b858..7fa09c5e4625ca801ef3812d8c8cc836f38b08e9 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -428,7 +428,7 @@ static void hvs_open_connection(struct vmbus_channel *chan)
 
 	if (conn_from_host) {
 		new->sk_state = TCP_ESTABLISHED;
-		sk->sk_ack_backlog++;
+		sk_acceptq_added(sk);
 
 		hvs_addr_init(&vnew->local_addr, if_type);
 		hvs_remote_addr_init(&vnew->remote_addr, &vnew->local_addr);
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index d02c9b41a768e6a9a968e1b685a8ed2f390212e6..193f959e51efee2fb9ae8d8ed0a7c8d3f894a58d 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1066,7 +1066,7 @@ virtio_transport_recv_listen(struct sock *sk, struct virtio_vsock_pkt *pkt)
 		return -ENOMEM;
 	}
 
-	sk->sk_ack_backlog++;
+	sk_acceptq_added(sk);
 
 	lock_sock_nested(child, SINGLE_DEPTH_NESTING);
 
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index 8c9c4ed90fa707b93208742a808253b81f67f489..6ba98a1efe2e08de7a99e92f3ee6a9a39e3f9086 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -1098,7 +1098,7 @@ static int vmci_transport_recv_listen(struct sock *sk,
 	}
 
 	vsock_add_pending(sk, pending);
-	sk->sk_ack_backlog++;
+	sk_acceptq_added(sk);
 
 	pending->sk_state = TCP_SYN_SENT;
 	vmci_trans(vpending)->produce_size =
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 6aee9f5e8e7155461eac93074ba975bac3af08c7..c34f7d0776046f2c15b668b66f020be8008ea731 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -891,7 +891,7 @@ static int x25_accept(struct socket *sock, struct socket *newsock, int flags,
 	/* Now attach up the new socket */
 	skb->sk = NULL;
 	kfree_skb(skb);
-	sk->sk_ack_backlog--;
+	sk_acceptq_removed(sk);
 	newsock->state = SS_CONNECTED;
 	rc = 0;
 out2:
@@ -1062,7 +1062,7 @@ int x25_rx_call_request(struct sk_buff *skb, struct x25_neigh *nb,
 	skb_copy_from_linear_data(skb, makex25->calluserdata.cuddata, skb->len);
 	makex25->calluserdata.cudlength = skb->len;
 
-	sk->sk_ack_backlog++;
+	sk_acceptq_added(sk);
 
 	x25_insert_socket(make);
 
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

