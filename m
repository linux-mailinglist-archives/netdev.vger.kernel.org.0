Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A577C0446
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 13:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbfI0L2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 07:28:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45770 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727542AbfI0L2R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 07:28:17 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A1C07306F4A9;
        Fri, 27 Sep 2019 11:28:16 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-249.ams2.redhat.com [10.36.117.249])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92A465D9C3;
        Fri, 27 Sep 2019 11:28:08 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-hyperv@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: [RFC PATCH 07/13] vsock: handle buffer_size sockopts in the core
Date:   Fri, 27 Sep 2019 13:26:57 +0200
Message-Id: <20190927112703.17745-8-sgarzare@redhat.com>
In-Reply-To: <20190927112703.17745-1-sgarzare@redhat.com>
References: <20190927112703.17745-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 27 Sep 2019 11:28:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtio_transport and vmci_transport handle the buffer_size
sockopts in a very similar way.

In order to support multiple transports, this patch moves this
handling in the core to allow the user to change the options
also if the socket is not yet assigned to any transport.

This patch also adds the '.notify_buffer_size' callback in the
'struct virtio_transport' in order to inform the transport,
when the buffer_size is changed by the user. It is also useful
to limit the 'buffer_size' requested (e.g. virtio transports).

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vsock.c                   |  7 +-
 include/linux/virtio_vsock.h            | 15 +----
 include/net/af_vsock.h                  | 14 ++--
 net/vmw_vsock/af_vsock.c                | 43 ++++++++++---
 net/vmw_vsock/hyperv_transport.c        | 36 -----------
 net/vmw_vsock/virtio_transport.c        |  8 +--
 net/vmw_vsock/virtio_transport_common.c | 78 ++++------------------
 net/vmw_vsock/vmci_transport.c          | 86 +++----------------------
 net/vmw_vsock/vmci_transport.h          |  3 -
 9 files changed, 64 insertions(+), 226 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 92ab3852c954..6d7e4f022748 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -418,13 +418,8 @@ static struct virtio_transport vhost_transport = {
 		.notify_send_pre_block    = virtio_transport_notify_send_pre_block,
 		.notify_send_pre_enqueue  = virtio_transport_notify_send_pre_enqueue,
 		.notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
+		.notify_buffer_size       = virtio_transport_notify_buffer_size,
 
-		.set_buffer_size          = virtio_transport_set_buffer_size,
-		.set_min_buffer_size      = virtio_transport_set_min_buffer_size,
-		.set_max_buffer_size      = virtio_transport_set_max_buffer_size,
-		.get_buffer_size          = virtio_transport_get_buffer_size,
-		.get_min_buffer_size      = virtio_transport_get_min_buffer_size,
-		.get_max_buffer_size      = virtio_transport_get_max_buffer_size,
 	},
 
 	.send_pkt = vhost_transport_send_pkt,
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 96d8132acbd7..ab02d119fe79 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -7,9 +7,6 @@
 #include <net/sock.h>
 #include <net/af_vsock.h>
 
-#define VIRTIO_VSOCK_DEFAULT_MIN_BUF_SIZE	128
-#define VIRTIO_VSOCK_DEFAULT_BUF_SIZE		(1024 * 256)
-#define VIRTIO_VSOCK_DEFAULT_MAX_BUF_SIZE	(1024 * 256)
 #define VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE	(1024 * 4)
 #define VIRTIO_VSOCK_MAX_BUF_SIZE		0xFFFFFFFFUL
 #define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE		(1024 * 64)
@@ -25,11 +22,6 @@ enum {
 struct virtio_vsock_sock {
 	struct vsock_sock *vsk;
 
-	/* Protected by lock_sock(sk_vsock(trans->vsk)) */
-	u32 buf_size;
-	u32 buf_size_min;
-	u32 buf_size_max;
-
 	spinlock_t tx_lock;
 	spinlock_t rx_lock;
 
@@ -93,12 +85,6 @@ s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
 
 int virtio_transport_do_socket_init(struct vsock_sock *vsk,
 				 struct vsock_sock *psk);
-u64 virtio_transport_get_buffer_size(struct vsock_sock *vsk);
-u64 virtio_transport_get_min_buffer_size(struct vsock_sock *vsk);
-u64 virtio_transport_get_max_buffer_size(struct vsock_sock *vsk);
-void virtio_transport_set_buffer_size(struct vsock_sock *vsk, u64 val);
-void virtio_transport_set_min_buffer_size(struct vsock_sock *vsk, u64 val);
-void virtio_transport_set_max_buffer_size(struct vsock_sock *vs, u64 val);
 int
 virtio_transport_notify_poll_in(struct vsock_sock *vsk,
 				size_t target,
@@ -125,6 +111,7 @@ int virtio_transport_notify_send_pre_enqueue(struct vsock_sock *vsk,
 	struct vsock_transport_send_notify_data *data);
 int virtio_transport_notify_send_post_enqueue(struct vsock_sock *vsk,
 	ssize_t written, struct vsock_transport_send_notify_data *data);
+int virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val);
 
 u64 virtio_transport_stream_rcvhiwat(struct vsock_sock *vsk);
 bool virtio_transport_stream_is_active(struct vsock_sock *vsk);
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 2ca67d048de4..86f8f463e01a 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -65,6 +65,11 @@ struct vsock_sock {
 	bool sent_request;
 	bool ignore_connecting_rst;
 
+	/* Protected by lock_sock(sk) */
+	u64 buffer_size;
+	u64 buffer_min_size;
+	u64 buffer_max_size;
+
 	/* Private to transport. */
 	void *trans;
 };
@@ -140,18 +145,11 @@ struct vsock_transport {
 		struct vsock_transport_send_notify_data *);
 	int (*notify_send_post_enqueue)(struct vsock_sock *, ssize_t,
 		struct vsock_transport_send_notify_data *);
+	int (*notify_buffer_size)(struct vsock_sock *, u64 *);
 
 	/* Shutdown. */
 	int (*shutdown)(struct vsock_sock *, int);
 
-	/* Buffer sizes. */
-	void (*set_buffer_size)(struct vsock_sock *, u64);
-	void (*set_min_buffer_size)(struct vsock_sock *, u64);
-	void (*set_max_buffer_size)(struct vsock_sock *, u64);
-	u64 (*get_buffer_size)(struct vsock_sock *);
-	u64 (*get_min_buffer_size)(struct vsock_sock *);
-	u64 (*get_max_buffer_size)(struct vsock_sock *);
-
 	/* Addressing. */
 	u32 (*get_local_cid)(void);
 };
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index f7540a3ac64e..dee69d7ee148 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -126,6 +126,10 @@ static struct proto vsock_proto = {
  */
 #define VSOCK_DEFAULT_CONNECT_TIMEOUT (2 * HZ)
 
+#define VSOCK_DEFAULT_BUFFER_SIZE     (1024 * 256)
+#define VSOCK_DEFAULT_BUFFER_MAX_SIZE (1024 * 256)
+#define VSOCK_DEFAULT_BUFFER_MIN_SIZE 128
+
 static const struct vsock_transport *transport_single;
 static DEFINE_MUTEX(vsock_register_mutex);
 
@@ -613,10 +617,16 @@ struct sock *__vsock_create(struct net *net,
 		vsk->trusted = psk->trusted;
 		vsk->owner = get_cred(psk->owner);
 		vsk->connect_timeout = psk->connect_timeout;
+		vsk->buffer_size = psk->buffer_size;
+		vsk->buffer_min_size = psk->buffer_min_size;
+		vsk->buffer_max_size = psk->buffer_max_size;
 	} else {
 		vsk->trusted = capable(CAP_NET_ADMIN);
 		vsk->owner = get_current_cred();
 		vsk->connect_timeout = VSOCK_DEFAULT_CONNECT_TIMEOUT;
+		vsk->buffer_size = VSOCK_DEFAULT_BUFFER_SIZE;
+		vsk->buffer_min_size = VSOCK_DEFAULT_BUFFER_MIN_SIZE;
+		vsk->buffer_max_size = VSOCK_DEFAULT_BUFFER_MAX_SIZE;
 	}
 
 	if (vsk->transport->init(vsk, psk) < 0) {
@@ -1360,6 +1370,23 @@ static int vsock_listen(struct socket *sock, int backlog)
 	return err;
 }
 
+static void vsock_update_buffer_size(struct vsock_sock *vsk,
+				     const struct vsock_transport *transport,
+				     u64 val)
+{
+	if (val > vsk->buffer_max_size)
+		val = vsk->buffer_max_size;
+
+	if (val < vsk->buffer_min_size)
+		val = vsk->buffer_min_size;
+
+	if (val != vsk->buffer_size &&
+	    transport && transport->notify_buffer_size)
+		transport->notify_buffer_size(vsk, &val);
+
+	vsk->buffer_size = val;
+}
+
 static int vsock_stream_setsockopt(struct socket *sock,
 				   int level,
 				   int optname,
@@ -1397,17 +1424,19 @@ static int vsock_stream_setsockopt(struct socket *sock,
 	switch (optname) {
 	case SO_VM_SOCKETS_BUFFER_SIZE:
 		COPY_IN(val);
-		transport->set_buffer_size(vsk, val);
+		vsock_update_buffer_size(vsk, transport, val);
 		break;
 
 	case SO_VM_SOCKETS_BUFFER_MAX_SIZE:
 		COPY_IN(val);
-		transport->set_max_buffer_size(vsk, val);
+		vsk->buffer_max_size = val;
+		vsock_update_buffer_size(vsk, transport, vsk->buffer_size);
 		break;
 
 	case SO_VM_SOCKETS_BUFFER_MIN_SIZE:
 		COPY_IN(val);
-		transport->set_min_buffer_size(vsk, val);
+		vsk->buffer_min_size = val;
+		vsock_update_buffer_size(vsk, transport, vsk->buffer_size);
 		break;
 
 	case SO_VM_SOCKETS_CONNECT_TIMEOUT: {
@@ -1448,7 +1477,6 @@ static int vsock_stream_getsockopt(struct socket *sock,
 	int len;
 	struct sock *sk;
 	struct vsock_sock *vsk;
-	const struct vsock_transport *transport;
 	u64 val;
 
 	if (level != AF_VSOCK)
@@ -1472,21 +1500,20 @@ static int vsock_stream_getsockopt(struct socket *sock,
 	err = 0;
 	sk = sock->sk;
 	vsk = vsock_sk(sk);
-	transport = vsk->transport;
 
 	switch (optname) {
 	case SO_VM_SOCKETS_BUFFER_SIZE:
-		val = transport->get_buffer_size(vsk);
+		val = vsk->buffer_size;
 		COPY_OUT(val);
 		break;
 
 	case SO_VM_SOCKETS_BUFFER_MAX_SIZE:
-		val = transport->get_max_buffer_size(vsk);
+		val = vsk->buffer_max_size;
 		COPY_OUT(val);
 		break;
 
 	case SO_VM_SOCKETS_BUFFER_MIN_SIZE:
-		val = transport->get_min_buffer_size(vsk);
+		val = vsk->buffer_min_size;
 		COPY_OUT(val);
 		break;
 
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 261521d286d6..4f47af2054dd 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -843,36 +843,6 @@ int hvs_notify_send_post_enqueue(struct vsock_sock *vsk, ssize_t written,
 	return 0;
 }
 
-static void hvs_set_buffer_size(struct vsock_sock *vsk, u64 val)
-{
-	/* Ignored. */
-}
-
-static void hvs_set_min_buffer_size(struct vsock_sock *vsk, u64 val)
-{
-	/* Ignored. */
-}
-
-static void hvs_set_max_buffer_size(struct vsock_sock *vsk, u64 val)
-{
-	/* Ignored. */
-}
-
-static u64 hvs_get_buffer_size(struct vsock_sock *vsk)
-{
-	return -ENOPROTOOPT;
-}
-
-static u64 hvs_get_min_buffer_size(struct vsock_sock *vsk)
-{
-	return -ENOPROTOOPT;
-}
-
-static u64 hvs_get_max_buffer_size(struct vsock_sock *vsk)
-{
-	return -ENOPROTOOPT;
-}
-
 static struct vsock_transport hvs_transport = {
 	.get_local_cid            = hvs_get_local_cid,
 
@@ -906,12 +876,6 @@ static struct vsock_transport hvs_transport = {
 	.notify_send_pre_enqueue  = hvs_notify_send_pre_enqueue,
 	.notify_send_post_enqueue = hvs_notify_send_post_enqueue,
 
-	.set_buffer_size          = hvs_set_buffer_size,
-	.set_min_buffer_size      = hvs_set_min_buffer_size,
-	.set_max_buffer_size      = hvs_set_max_buffer_size,
-	.get_buffer_size          = hvs_get_buffer_size,
-	.get_min_buffer_size      = hvs_get_min_buffer_size,
-	.get_max_buffer_size      = hvs_get_max_buffer_size,
 };
 
 static int hvs_probe(struct hv_device *hdev,
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 3756f0857946..fb1fc7760e8c 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -494,13 +494,7 @@ static struct virtio_transport virtio_transport = {
 		.notify_send_pre_block    = virtio_transport_notify_send_pre_block,
 		.notify_send_pre_enqueue  = virtio_transport_notify_send_pre_enqueue,
 		.notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
-
-		.set_buffer_size          = virtio_transport_set_buffer_size,
-		.set_min_buffer_size      = virtio_transport_set_min_buffer_size,
-		.set_max_buffer_size      = virtio_transport_set_max_buffer_size,
-		.get_buffer_size          = virtio_transport_get_buffer_size,
-		.get_min_buffer_size      = virtio_transport_get_min_buffer_size,
-		.get_max_buffer_size      = virtio_transport_get_max_buffer_size,
+		.notify_buffer_size       = virtio_transport_notify_buffer_size,
 	},
 
 	.send_pkt = virtio_transport_send_pkt,
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index fc046c071178..bac9e7430a2e 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -403,17 +403,13 @@ int virtio_transport_do_socket_init(struct vsock_sock *vsk,
 	if (psk) {
 		struct virtio_vsock_sock *ptrans = psk->trans;
 
-		vvs->buf_size	= ptrans->buf_size;
-		vvs->buf_size_min = ptrans->buf_size_min;
-		vvs->buf_size_max = ptrans->buf_size_max;
 		vvs->peer_buf_alloc = ptrans->peer_buf_alloc;
-	} else {
-		vvs->buf_size = VIRTIO_VSOCK_DEFAULT_BUF_SIZE;
-		vvs->buf_size_min = VIRTIO_VSOCK_DEFAULT_MIN_BUF_SIZE;
-		vvs->buf_size_max = VIRTIO_VSOCK_DEFAULT_MAX_BUF_SIZE;
 	}
 
-	vvs->buf_alloc = vvs->buf_size;
+	if (vsk->buffer_size > VIRTIO_VSOCK_MAX_BUF_SIZE)
+		vsk->buffer_size = VIRTIO_VSOCK_MAX_BUF_SIZE;
+
+	vvs->buf_alloc = vsk->buffer_size;
 
 	spin_lock_init(&vvs->rx_lock);
 	spin_lock_init(&vvs->tx_lock);
@@ -423,68 +419,18 @@ int virtio_transport_do_socket_init(struct vsock_sock *vsk,
 }
 EXPORT_SYMBOL_GPL(virtio_transport_do_socket_init);
 
-u64 virtio_transport_get_buffer_size(struct vsock_sock *vsk)
-{
-	struct virtio_vsock_sock *vvs = vsk->trans;
-
-	return vvs->buf_size;
-}
-EXPORT_SYMBOL_GPL(virtio_transport_get_buffer_size);
-
-u64 virtio_transport_get_min_buffer_size(struct vsock_sock *vsk)
-{
-	struct virtio_vsock_sock *vvs = vsk->trans;
-
-	return vvs->buf_size_min;
-}
-EXPORT_SYMBOL_GPL(virtio_transport_get_min_buffer_size);
-
-u64 virtio_transport_get_max_buffer_size(struct vsock_sock *vsk)
-{
-	struct virtio_vsock_sock *vvs = vsk->trans;
-
-	return vvs->buf_size_max;
-}
-EXPORT_SYMBOL_GPL(virtio_transport_get_max_buffer_size);
-
-void virtio_transport_set_buffer_size(struct vsock_sock *vsk, u64 val)
-{
-	struct virtio_vsock_sock *vvs = vsk->trans;
-
-	if (val > VIRTIO_VSOCK_MAX_BUF_SIZE)
-		val = VIRTIO_VSOCK_MAX_BUF_SIZE;
-	if (val < vvs->buf_size_min)
-		vvs->buf_size_min = val;
-	if (val > vvs->buf_size_max)
-		vvs->buf_size_max = val;
-	vvs->buf_size = val;
-	vvs->buf_alloc = val;
-}
-EXPORT_SYMBOL_GPL(virtio_transport_set_buffer_size);
-
-void virtio_transport_set_min_buffer_size(struct vsock_sock *vsk, u64 val)
+int virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val)
 {
 	struct virtio_vsock_sock *vvs = vsk->trans;
 
-	if (val > VIRTIO_VSOCK_MAX_BUF_SIZE)
-		val = VIRTIO_VSOCK_MAX_BUF_SIZE;
-	if (val > vvs->buf_size)
-		vvs->buf_size = val;
-	vvs->buf_size_min = val;
-}
-EXPORT_SYMBOL_GPL(virtio_transport_set_min_buffer_size);
+	if (*val > VIRTIO_VSOCK_MAX_BUF_SIZE)
+		*val = VIRTIO_VSOCK_MAX_BUF_SIZE;
 
-void virtio_transport_set_max_buffer_size(struct vsock_sock *vsk, u64 val)
-{
-	struct virtio_vsock_sock *vvs = vsk->trans;
+	vvs->buf_alloc = *val;
 
-	if (val > VIRTIO_VSOCK_MAX_BUF_SIZE)
-		val = VIRTIO_VSOCK_MAX_BUF_SIZE;
-	if (val < vvs->buf_size)
-		vvs->buf_size = val;
-	vvs->buf_size_max = val;
+	return 0;
 }
-EXPORT_SYMBOL_GPL(virtio_transport_set_max_buffer_size);
+EXPORT_SYMBOL_GPL(virtio_transport_notify_buffer_size);
 
 int
 virtio_transport_notify_poll_in(struct vsock_sock *vsk,
@@ -576,9 +522,7 @@ EXPORT_SYMBOL_GPL(virtio_transport_notify_send_post_enqueue);
 
 u64 virtio_transport_stream_rcvhiwat(struct vsock_sock *vsk)
 {
-	struct virtio_vsock_sock *vvs = vsk->trans;
-
-	return vvs->buf_size;
+	return vsk->buffer_size;
 }
 EXPORT_SYMBOL_GPL(virtio_transport_stream_rcvhiwat);
 
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index f8e3131ac480..8290d37b6587 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -74,10 +74,6 @@ static u32 vmci_transport_qp_resumed_sub_id = VMCI_INVALID_ID;
 
 static int PROTOCOL_OVERRIDE = -1;
 
-#define VMCI_TRANSPORT_DEFAULT_QP_SIZE_MIN   128
-#define VMCI_TRANSPORT_DEFAULT_QP_SIZE       262144
-#define VMCI_TRANSPORT_DEFAULT_QP_SIZE_MAX   262144
-
 /* Helper function to convert from a VMCI error code to a VSock error code. */
 
 static s32 vmci_transport_error_to_vsock_error(s32 vmci_error)
@@ -1025,11 +1021,11 @@ static int vmci_transport_recv_listen(struct sock *sk,
 	/* If the proposed size fits within our min/max, accept it. Otherwise
 	 * propose our own size.
 	 */
-	if (pkt->u.size >= vmci_trans(vpending)->queue_pair_min_size &&
-	    pkt->u.size <= vmci_trans(vpending)->queue_pair_max_size) {
+	if (pkt->u.size >= vpending->buffer_min_size &&
+	    pkt->u.size <= vpending->buffer_max_size) {
 		qp_size = pkt->u.size;
 	} else {
-		qp_size = vmci_trans(vpending)->queue_pair_size;
+		qp_size = vpending->buffer_size;
 	}
 
 	/* Figure out if we are using old or new requests based on the
@@ -1098,7 +1094,7 @@ static int vmci_transport_recv_listen(struct sock *sk,
 	pending->sk_state = TCP_SYN_SENT;
 	vmci_trans(vpending)->produce_size =
 		vmci_trans(vpending)->consume_size = qp_size;
-	vmci_trans(vpending)->queue_pair_size = qp_size;
+	vpending->buffer_size = qp_size;
 
 	vmci_trans(vpending)->notify_ops->process_request(pending);
 
@@ -1392,8 +1388,8 @@ static int vmci_transport_recv_connecting_client_negotiate(
 	vsk->ignore_connecting_rst = false;
 
 	/* Verify that we're OK with the proposed queue pair size */
-	if (pkt->u.size < vmci_trans(vsk)->queue_pair_min_size ||
-	    pkt->u.size > vmci_trans(vsk)->queue_pair_max_size) {
+	if (pkt->u.size < vsk->buffer_min_size ||
+	    pkt->u.size > vsk->buffer_max_size) {
 		err = -EINVAL;
 		goto destroy;
 	}
@@ -1498,8 +1494,7 @@ vmci_transport_recv_connecting_client_invalid(struct sock *sk,
 		vsk->sent_request = false;
 		vsk->ignore_connecting_rst = true;
 
-		err = vmci_transport_send_conn_request(
-			sk, vmci_trans(vsk)->queue_pair_size);
+		err = vmci_transport_send_conn_request(sk, vsk->buffer_size);
 		if (err < 0)
 			err = vmci_transport_error_to_vsock_error(err);
 		else
@@ -1583,21 +1578,6 @@ static int vmci_transport_socket_init(struct vsock_sock *vsk,
 	INIT_LIST_HEAD(&vmci_trans(vsk)->elem);
 	vmci_trans(vsk)->sk = &vsk->sk;
 	spin_lock_init(&vmci_trans(vsk)->lock);
-	if (psk) {
-		vmci_trans(vsk)->queue_pair_size =
-			vmci_trans(psk)->queue_pair_size;
-		vmci_trans(vsk)->queue_pair_min_size =
-			vmci_trans(psk)->queue_pair_min_size;
-		vmci_trans(vsk)->queue_pair_max_size =
-			vmci_trans(psk)->queue_pair_max_size;
-	} else {
-		vmci_trans(vsk)->queue_pair_size =
-			VMCI_TRANSPORT_DEFAULT_QP_SIZE;
-		vmci_trans(vsk)->queue_pair_min_size =
-			 VMCI_TRANSPORT_DEFAULT_QP_SIZE_MIN;
-		vmci_trans(vsk)->queue_pair_max_size =
-			VMCI_TRANSPORT_DEFAULT_QP_SIZE_MAX;
-	}
 
 	return 0;
 }
@@ -1813,8 +1793,7 @@ static int vmci_transport_connect(struct vsock_sock *vsk)
 
 	if (vmci_transport_old_proto_override(&old_pkt_proto) &&
 		old_pkt_proto) {
-		err = vmci_transport_send_conn_request(
-			sk, vmci_trans(vsk)->queue_pair_size);
+		err = vmci_transport_send_conn_request(sk, vsk->buffer_size);
 		if (err < 0) {
 			sk->sk_state = TCP_CLOSE;
 			return err;
@@ -1822,8 +1801,7 @@ static int vmci_transport_connect(struct vsock_sock *vsk)
 	} else {
 		int supported_proto_versions =
 			vmci_transport_new_proto_supported_versions();
-		err = vmci_transport_send_conn_request2(
-				sk, vmci_trans(vsk)->queue_pair_size,
+		err = vmci_transport_send_conn_request2(sk, vsk->buffer_size,
 				supported_proto_versions);
 		if (err < 0) {
 			sk->sk_state = TCP_CLOSE;
@@ -1876,46 +1854,6 @@ static bool vmci_transport_stream_is_active(struct vsock_sock *vsk)
 	return !vmci_handle_is_invalid(vmci_trans(vsk)->qp_handle);
 }
 
-static u64 vmci_transport_get_buffer_size(struct vsock_sock *vsk)
-{
-	return vmci_trans(vsk)->queue_pair_size;
-}
-
-static u64 vmci_transport_get_min_buffer_size(struct vsock_sock *vsk)
-{
-	return vmci_trans(vsk)->queue_pair_min_size;
-}
-
-static u64 vmci_transport_get_max_buffer_size(struct vsock_sock *vsk)
-{
-	return vmci_trans(vsk)->queue_pair_max_size;
-}
-
-static void vmci_transport_set_buffer_size(struct vsock_sock *vsk, u64 val)
-{
-	if (val < vmci_trans(vsk)->queue_pair_min_size)
-		vmci_trans(vsk)->queue_pair_min_size = val;
-	if (val > vmci_trans(vsk)->queue_pair_max_size)
-		vmci_trans(vsk)->queue_pair_max_size = val;
-	vmci_trans(vsk)->queue_pair_size = val;
-}
-
-static void vmci_transport_set_min_buffer_size(struct vsock_sock *vsk,
-					       u64 val)
-{
-	if (val > vmci_trans(vsk)->queue_pair_size)
-		vmci_trans(vsk)->queue_pair_size = val;
-	vmci_trans(vsk)->queue_pair_min_size = val;
-}
-
-static void vmci_transport_set_max_buffer_size(struct vsock_sock *vsk,
-					       u64 val)
-{
-	if (val < vmci_trans(vsk)->queue_pair_size)
-		vmci_trans(vsk)->queue_pair_size = val;
-	vmci_trans(vsk)->queue_pair_max_size = val;
-}
-
 static int vmci_transport_notify_poll_in(
 	struct vsock_sock *vsk,
 	size_t target,
@@ -2098,12 +2036,6 @@ static const struct vsock_transport vmci_transport = {
 	.notify_send_pre_enqueue = vmci_transport_notify_send_pre_enqueue,
 	.notify_send_post_enqueue = vmci_transport_notify_send_post_enqueue,
 	.shutdown = vmci_transport_shutdown,
-	.set_buffer_size = vmci_transport_set_buffer_size,
-	.set_min_buffer_size = vmci_transport_set_min_buffer_size,
-	.set_max_buffer_size = vmci_transport_set_max_buffer_size,
-	.get_buffer_size = vmci_transport_get_buffer_size,
-	.get_min_buffer_size = vmci_transport_get_min_buffer_size,
-	.get_max_buffer_size = vmci_transport_get_max_buffer_size,
 	.get_local_cid = vmci_transport_get_local_cid,
 };
 
diff --git a/net/vmw_vsock/vmci_transport.h b/net/vmw_vsock/vmci_transport.h
index 1ca1e8640b31..b7b072194282 100644
--- a/net/vmw_vsock/vmci_transport.h
+++ b/net/vmw_vsock/vmci_transport.h
@@ -108,9 +108,6 @@ struct vmci_transport {
 	struct vmci_qp *qpair;
 	u64 produce_size;
 	u64 consume_size;
-	u64 queue_pair_size;
-	u64 queue_pair_min_size;
-	u64 queue_pair_max_size;
 	u32 detach_sub_id;
 	union vmci_transport_notify notify;
 	const struct vmci_transport_notify_ops *notify_ops;
-- 
2.21.0

