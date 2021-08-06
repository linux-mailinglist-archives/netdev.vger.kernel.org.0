Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D113E235A
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 08:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243382AbhHFGjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 02:39:24 -0400
Received: from out0.migadu.com ([94.23.1.103]:11406 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229625AbhHFGjU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 02:39:20 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1628231943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mfWSpEHL97cOOqGzjfbOjX7k9KIFgT3KANvCddVv9gI=;
        b=W8z+ASsTeY/l6TDNBA+sI0JfgLZVn+NY0ruS/wR/yY3TAnkb1pYK+Hbdp7q91V/+rMQlNy
        kJjamKUSHAxyrhbsDTsck4fRyA2iPqH/Ae4ogqdrPaWNvxq+Co9TIOXYF3pCXy4pyqjUWL
        zyzhJ/38GnOgf3zS+iXvpkAEQplRFnE=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] net: Remove redundant if statements
Date:   Fri,  6 Aug 2021 14:38:47 +0800
Message-Id: <20210806063847.21639-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The if statement already move into sock_{put , hold},
just remove it.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/ax25/ax25_in.c             |  3 +--
 net/bluetooth/mgmt.c           | 24 ++++++++----------------
 net/can/af_can.c               |  6 ++----
 net/core/skmsg.c               |  6 ++----
 net/ipv4/udp_diag.c            |  3 +--
 net/l2tp/l2tp_ppp.c            |  3 +--
 net/mptcp/subflow.c            |  8 ++------
 net/netfilter/nf_queue.c       |  8 ++------
 net/netlink/af_netlink.c       |  3 +--
 net/netrom/af_netrom.c         |  3 +--
 net/phonet/pep.c               |  4 +---
 net/phonet/socket.c            |  3 +--
 net/qrtr/mhi.c                 |  9 +++------
 net/unix/af_unix.c             | 18 ++++++------------
 net/unix/diag.c                |  3 +--
 net/vmw_vsock/af_vsock.c       |  8 ++------
 net/vmw_vsock/vmci_transport.c |  3 +--
 17 files changed, 36 insertions(+), 79 deletions(-)

diff --git a/net/ax25/ax25_in.c b/net/ax25/ax25_in.c
index cd6afe895db9..713f75e3bbdc 100644
--- a/net/ax25/ax25_in.c
+++ b/net/ax25/ax25_in.c
@@ -380,8 +380,7 @@ static int ax25_rcv(struct sk_buff *skb, struct net_device *dev,
 	    (ax25->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
 		kfree_skb(skb);
 		ax25_destroy_socket(ax25);
-		if (sk)
-			sock_put(sk);
+		sock_put(sk);
 		return 0;
 	}
 
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 3663f880df11..48c2299c8096 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -1896,8 +1896,7 @@ static void le_enable_complete(struct hci_dev *hdev, u8 status, u16 opcode)
 
 	new_settings(hdev, match.sk);
 
-	if (match.sk)
-		sock_put(match.sk);
+	sock_put(match.sk);
 
 	/* Make sure the controller has a good default for
 	 * advertising data. Restrict the update to when LE
@@ -5335,8 +5334,7 @@ static void set_advertising_complete(struct hci_dev *hdev, u8 status,
 
 	new_settings(hdev, match.sk);
 
-	if (match.sk)
-		sock_put(match.sk);
+	sock_put(match.sk);
 
 	/* Handle suspend notifier */
 	if (test_and_clear_bit(SUSPEND_PAUSE_ADVERTISING,
@@ -8569,8 +8567,7 @@ void mgmt_power_on(struct hci_dev *hdev, int err)
 
 	new_settings(hdev, match.sk);
 
-	if (match.sk)
-		sock_put(match.sk);
+	sock_put(match.sk);
 
 	hci_dev_unlock(hdev);
 }
@@ -8605,8 +8602,7 @@ void __mgmt_power_off(struct hci_dev *hdev)
 
 	new_settings(hdev, match.sk);
 
-	if (match.sk)
-		sock_put(match.sk);
+	sock_put(match.sk);
 }
 
 void mgmt_set_powered_failed(struct hci_dev *hdev, int err)
@@ -8887,8 +8883,7 @@ void mgmt_device_disconnected(struct hci_dev *hdev, bdaddr_t *bdaddr,
 
 	mgmt_event(MGMT_EV_DEVICE_DISCONNECTED, hdev, &ev, sizeof(ev), sk);
 
-	if (sk)
-		sock_put(sk);
+	sock_put(sk);
 
 	mgmt_pending_foreach(MGMT_OP_UNPAIR_DEVICE, hdev, unpair_device_rsp,
 			     hdev);
@@ -9114,8 +9109,7 @@ void mgmt_auth_enable_complete(struct hci_dev *hdev, u8 status)
 	if (changed)
 		new_settings(hdev, match.sk);
 
-	if (match.sk)
-		sock_put(match.sk);
+	sock_put(match.sk);
 }
 
 static void clear_eir(struct hci_request *req)
@@ -9169,8 +9163,7 @@ void mgmt_ssp_enable_complete(struct hci_dev *hdev, u8 enable, u8 status)
 	if (changed)
 		new_settings(hdev, match.sk);
 
-	if (match.sk)
-		sock_put(match.sk);
+	sock_put(match.sk);
 
 	hci_req_init(&req, hdev);
 
@@ -9211,8 +9204,7 @@ void mgmt_set_class_of_dev_complete(struct hci_dev *hdev, u8 *dev_class,
 		ext_info_changed(hdev, NULL);
 	}
 
-	if (match.sk)
-		sock_put(match.sk);
+	sock_put(match.sk);
 }
 
 void mgmt_set_local_name_complete(struct hci_dev *hdev, u8 *name, u8 status)
diff --git a/net/can/af_can.c b/net/can/af_can.c
index cce2af10eb3e..7f6c6969e203 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -493,8 +493,7 @@ static void can_rx_delete_receiver(struct rcu_head *rp)
 	struct sock *sk = rcv->sk;
 
 	kmem_cache_free(rcv_cache, rcv);
-	if (sk)
-		sock_put(sk);
+	sock_put(sk);
 }
 
 /**
@@ -562,8 +561,7 @@ void can_rx_unregister(struct net *net, struct net_device *dev, canid_t can_id,
 
 	/* schedule the receiver item for deletion */
 	if (rcv) {
-		if (rcv->sk)
-			sock_hold(rcv->sk);
+		sock_hold(rcv->sk);
 		call_rcu(&rcv->rcu, can_rx_delete_receiver);
 	}
 }
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 2d6249b28928..187f3f91bbae 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -782,8 +782,7 @@ static void sk_psock_destroy(struct work_struct *work)
 	sk_psock_link_destroy(psock);
 	sk_psock_cork_free(psock);
 
-	if (psock->sk_redir)
-		sock_put(psock->sk_redir);
+	sock_put(psock->sk_redir);
 	sock_put(psock->sk);
 	kfree(psock);
 }
@@ -838,8 +837,7 @@ int sk_psock_msg_verdict(struct sock *sk, struct sk_psock *psock,
 	ret = sk_psock_map_verd(ret, msg->sk_redir);
 	psock->apply_bytes = msg->apply_bytes;
 	if (ret == __SK_REDIRECT) {
-		if (psock->sk_redir)
-			sock_put(psock->sk_redir);
+		sock_put(psock->sk_redir);
 		psock->sk_redir = msg->sk_redir;
 		if (!psock->sk_redir) {
 			ret = __SK_DROP;
diff --git a/net/ipv4/udp_diag.c b/net/ipv4/udp_diag.c
index 1ed8c4d78e5c..629e3f112b08 100644
--- a/net/ipv4/udp_diag.c
+++ b/net/ipv4/udp_diag.c
@@ -80,8 +80,7 @@ static int udp_dump_one(struct udp_table *tbl,
 	err = nlmsg_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid);
 
 out:
-	if (sk)
-		sock_put(sk);
+	sock_put(sk);
 out_nosk:
 	return err;
 }
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index bf35710127dd..e8f01f1708c8 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -141,8 +141,7 @@ static struct sock *pppol2tp_session_get_sock(struct l2tp_session *session)
 
 	rcu_read_lock();
 	sk = rcu_dereference(ps->sk);
-	if (sk)
-		sock_hold(sk);
+	sock_hold(sk);
 	rcu_read_unlock();
 
 	return sk;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 966f777d35ce..9fd6737d8a2f 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -41,9 +41,7 @@ static void subflow_req_destructor(struct request_sock *req)
 
 	pr_debug("subflow_req=%p", subflow_req);
 
-	if (subflow_req->msk)
-		sock_put((struct sock *)subflow_req->msk);
-
+	sock_put((struct sock *)subflow_req->msk);
 	mptcp_token_destroy_request(req);
 	tcp_request_sock_ops.destructor(req);
 }
@@ -601,9 +599,7 @@ static void subflow_drop_ctx(struct sock *ssk)
 		return;
 
 	subflow_ulp_fallback(ssk, ctx);
-	if (ctx->conn)
-		sock_put(ctx->conn);
-
+	sock_put(ctx->conn);
 	kfree_rcu(ctx, rcu);
 }
 
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 7f2f69b609d8..a7a199293186 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -53,9 +53,7 @@ static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 	/* Release those devices we held, or Alexey will kill me. */
 	dev_put(state->in);
 	dev_put(state->out);
-	if (state->sk)
-		sock_put(state->sk);
-
+	sock_put(state->sk);
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	dev_put(entry->physin);
 	dev_put(entry->physout);
@@ -93,9 +91,7 @@ void nf_queue_entry_get_refs(struct nf_queue_entry *entry)
 
 	dev_hold(state->in);
 	dev_hold(state->out);
-	if (state->sk)
-		sock_hold(state->sk);
-
+	sock_hold(state->sk);
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	dev_hold(entry->physin);
 	dev_hold(entry->physout);
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 24b7cf447bc5..1aad9528416b 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -532,8 +532,7 @@ static struct sock *netlink_lookup(struct net *net, int protocol, u32 portid)
 
 	rcu_read_lock();
 	sk = __netlink_lookup(table, portid, net);
-	if (sk)
-		sock_hold(sk);
+	sock_hold(sk);
 	rcu_read_unlock();
 
 	return sk;
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 6d16e1ab1a8a..dde89b6c2432 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -958,8 +958,7 @@ int nr_rx_frame(struct sk_buff *skb, struct net_device *dev)
 	if (sk == NULL || sk_acceptq_is_full(sk) ||
 	    (make = nr_make_new(sk)) == NULL) {
 		nr_transmit_refusal(skb, 0);
-		if (sk)
-			sock_put(sk);
+		sock_put(sk);
 		return 0;
 	}
 
diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index a1525916885a..2c7ddf6dbb76 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -1314,9 +1314,7 @@ static void pep_sock_unhash(struct sock *sk)
 	if (hlist_empty(&pn->hlist))
 		pn_sock_unhash(&pn->pn_sk.sk);
 	release_sock(sk);
-
-	if (skparent)
-		sock_put(skparent);
+	sock_put(skparent);
 }
 
 static struct proto pep_proto = {
diff --git a/net/phonet/socket.c b/net/phonet/socket.c
index 71e2caf6ab85..0e7de755c1aa 100644
--- a/net/phonet/socket.c
+++ b/net/phonet/socket.c
@@ -620,8 +620,7 @@ struct sock *pn_find_sock_by_res(struct net *net, u8 res)
 
 	rcu_read_lock();
 	sk = rcu_dereference(pnres.sk[res]);
-	if (sk)
-		sock_hold(sk);
+	sock_hold(sk);
 	rcu_read_unlock();
 	return sk;
 }
diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
index 1dc955ca57d3..7980d18409af 100644
--- a/net/qrtr/mhi.c
+++ b/net/qrtr/mhi.c
@@ -40,8 +40,7 @@ static void qcom_mhi_qrtr_ul_callback(struct mhi_device *mhi_dev,
 {
 	struct sk_buff *skb = mhi_res->buf_addr;
 
-	if (skb->sk)
-		sock_put(skb->sk);
+	sock_put(skb->sk);
 	consume_skb(skb);
 }
 
@@ -55,8 +54,7 @@ static int qcom_mhi_qrtr_send(struct qrtr_endpoint *ep, struct sk_buff *skb)
 	if (rc)
 		goto free_skb;
 
-	if (skb->sk)
-		sock_hold(skb->sk);
+	sock_hold(skb->sk);
 
 	rc = skb_linearize(skb);
 	if (rc)
@@ -70,8 +68,7 @@ static int qcom_mhi_qrtr_send(struct qrtr_endpoint *ep, struct sk_buff *skb)
 	return rc;
 
 free_skb:
-	if (skb->sk)
-		sock_put(skb->sk);
+	sock_put(skb->sk);
 	kfree_skb(skb);
 
 	return rc;
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index ec02e70a549b..f02787e98114 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -206,8 +206,7 @@ struct sock *unix_peer_get(struct sock *s)
 
 	unix_state_lock(s);
 	peer = unix_peer(s);
-	if (peer)
-		sock_hold(peer);
+	sock_hold(peer);
 	unix_state_unlock(s);
 	return peer;
 }
@@ -311,8 +310,7 @@ static inline struct sock *unix_find_socket_byname(struct net *net,
 
 	spin_lock(&unix_table_lock);
 	s = __unix_find_socket_byname(net, sunname, len, hash);
-	if (s)
-		sock_hold(s);
+	sock_hold(s);
 	spin_unlock(&unix_table_lock);
 	return s;
 }
@@ -1439,8 +1437,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	kfree_skb(skb);
 	if (newsk)
 		unix_release_sock(newsk, 0);
-	if (other)
-		sock_put(other);
+	sock_put(other);
 	return err;
 }
 
@@ -1884,8 +1881,7 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 out_free:
 	kfree_skb(skb);
 out:
-	if (other)
-		sock_put(other);
+	sock_put(other);
 	scm_destroy(&scm);
 	return err;
 }
@@ -2765,8 +2761,7 @@ static int unix_shutdown(struct socket *sock, int mode)
 	unix_state_lock(sk);
 	sk->sk_shutdown |= mode;
 	other = unix_peer(sk);
-	if (other)
-		sock_hold(other);
+	sock_hold(other);
 	unix_state_unlock(sk);
 	sk->sk_state_change(sk);
 
@@ -2788,8 +2783,7 @@ static int unix_shutdown(struct socket *sock, int mode)
 		else if (peer_mode & RCV_SHUTDOWN)
 			sk_wake_async(other, SOCK_WAKE_WAITD, POLL_IN);
 	}
-	if (other)
-		sock_put(other);
+	sock_put(other);
 
 	return 0;
 }
diff --git a/net/unix/diag.c b/net/unix/diag.c
index 7e7d7f45685a..e6a03d806b4a 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -298,8 +298,7 @@ static int unix_diag_get_exact(struct sk_buff *in_skb,
 	err = nlmsg_unicast(net->diag_nlsk, rep, NETLINK_CB(in_skb).portid);
 
 out:
-	if (sk)
-		sock_put(sk);
+	sock_put(sk);
 out_nosk:
 	return err;
 }
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 3e02cc3b24f8..eccdbdb43808 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -301,9 +301,7 @@ struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr)
 
 	spin_lock_bh(&vsock_table_lock);
 	sk = __vsock_find_bound_socket(addr);
-	if (sk)
-		sock_hold(sk);
-
+	sock_hold(sk);
 	spin_unlock_bh(&vsock_table_lock);
 
 	return sk;
@@ -317,9 +315,7 @@ struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
 
 	spin_lock_bh(&vsock_table_lock);
 	sk = __vsock_find_connected_socket(src, dst);
-	if (sk)
-		sock_hold(sk);
-
+	sock_hold(sk);
 	spin_unlock_bh(&vsock_table_lock);
 
 	return sk;
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index 7aef34e32bdf..944d5302a222 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -792,8 +792,7 @@ static int vmci_transport_recv_stream_cb(void *data, struct vmci_datagram *dg)
 	}
 
 out:
-	if (sk)
-		sock_put(sk);
+	sock_put(sk);
 
 	return err;
 }
-- 
2.32.0

