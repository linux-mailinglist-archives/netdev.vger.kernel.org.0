Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26921C043D
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 13:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbfI0L17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 07:27:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbfI0L17 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 07:27:59 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9131A63704;
        Fri, 27 Sep 2019 11:27:58 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-249.ams2.redhat.com [10.36.117.249])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 254345D9C3;
        Fri, 27 Sep 2019 11:27:46 +0000 (UTC)
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
Subject: [RFC PATCH 05/13] vsock/virtio: add transport parameter to the virtio_transport_reset_no_sock()
Date:   Fri, 27 Sep 2019 13:26:55 +0200
Message-Id: <20190927112703.17745-6-sgarzare@redhat.com>
In-Reply-To: <20190927112703.17745-1-sgarzare@redhat.com>
References: <20190927112703.17745-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 27 Sep 2019 11:27:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are going to add 'struct vsock_sock *' parameter to
virtio_transport_get_ops().

In some cases, like in the virtio_transport_reset_no_sock(),
we don't have any socket assigned to the packet received,
so we can't use the virtio_transport_get_ops().

In order to allow virtio_transport_reset_no_sock() to use the
'.send_pkt' callback from the 'vhost_transport' or 'virtio_transport',
we add the 'struct virtio_transport *' to it and to its caller:
virtio_transport_recv_pkt().

We moved the 'vhost_transport' and 'virtio_transport' definition,
to pass their address to the virtio_transport_recv_pkt().

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vsock.c                   |  94 +++++++-------
 include/linux/virtio_vsock.h            |   3 +-
 net/vmw_vsock/virtio_transport.c        | 160 ++++++++++++------------
 net/vmw_vsock/virtio_transport_common.c |  12 +-
 4 files changed, 135 insertions(+), 134 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 9f57736fe15e..92ab3852c954 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -384,6 +384,52 @@ static bool vhost_vsock_more_replies(struct vhost_vsock *vsock)
 	return val < vq->num;
 }
 
+static struct virtio_transport vhost_transport = {
+	.transport = {
+		.get_local_cid            = vhost_transport_get_local_cid,
+
+		.init                     = virtio_transport_do_socket_init,
+		.destruct                 = virtio_transport_destruct,
+		.release                  = virtio_transport_release,
+		.connect                  = virtio_transport_connect,
+		.shutdown                 = virtio_transport_shutdown,
+		.cancel_pkt               = vhost_transport_cancel_pkt,
+
+		.dgram_enqueue            = virtio_transport_dgram_enqueue,
+		.dgram_dequeue            = virtio_transport_dgram_dequeue,
+		.dgram_bind               = virtio_transport_dgram_bind,
+		.dgram_allow              = virtio_transport_dgram_allow,
+
+		.stream_enqueue           = virtio_transport_stream_enqueue,
+		.stream_dequeue           = virtio_transport_stream_dequeue,
+		.stream_has_data          = virtio_transport_stream_has_data,
+		.stream_has_space         = virtio_transport_stream_has_space,
+		.stream_rcvhiwat          = virtio_transport_stream_rcvhiwat,
+		.stream_is_active         = virtio_transport_stream_is_active,
+		.stream_allow             = virtio_transport_stream_allow,
+
+		.notify_poll_in           = virtio_transport_notify_poll_in,
+		.notify_poll_out          = virtio_transport_notify_poll_out,
+		.notify_recv_init         = virtio_transport_notify_recv_init,
+		.notify_recv_pre_block    = virtio_transport_notify_recv_pre_block,
+		.notify_recv_pre_dequeue  = virtio_transport_notify_recv_pre_dequeue,
+		.notify_recv_post_dequeue = virtio_transport_notify_recv_post_dequeue,
+		.notify_send_init         = virtio_transport_notify_send_init,
+		.notify_send_pre_block    = virtio_transport_notify_send_pre_block,
+		.notify_send_pre_enqueue  = virtio_transport_notify_send_pre_enqueue,
+		.notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
+
+		.set_buffer_size          = virtio_transport_set_buffer_size,
+		.set_min_buffer_size      = virtio_transport_set_min_buffer_size,
+		.set_max_buffer_size      = virtio_transport_set_max_buffer_size,
+		.get_buffer_size          = virtio_transport_get_buffer_size,
+		.get_min_buffer_size      = virtio_transport_get_min_buffer_size,
+		.get_max_buffer_size      = virtio_transport_get_max_buffer_size,
+	},
+
+	.send_pkt = vhost_transport_send_pkt,
+};
+
 static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 {
 	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
@@ -438,7 +484,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 
 		/* Only accept correctly addressed packets */
 		if (le64_to_cpu(pkt->hdr.src_cid) == vsock->guest_cid)
-			virtio_transport_recv_pkt(pkt);
+			virtio_transport_recv_pkt(&vhost_transport, pkt);
 		else
 			virtio_transport_free_pkt(pkt);
 
@@ -786,52 +832,6 @@ static struct miscdevice vhost_vsock_misc = {
 	.fops = &vhost_vsock_fops,
 };
 
-static struct virtio_transport vhost_transport = {
-	.transport = {
-		.get_local_cid            = vhost_transport_get_local_cid,
-
-		.init                     = virtio_transport_do_socket_init,
-		.destruct                 = virtio_transport_destruct,
-		.release                  = virtio_transport_release,
-		.connect                  = virtio_transport_connect,
-		.shutdown                 = virtio_transport_shutdown,
-		.cancel_pkt               = vhost_transport_cancel_pkt,
-
-		.dgram_enqueue            = virtio_transport_dgram_enqueue,
-		.dgram_dequeue            = virtio_transport_dgram_dequeue,
-		.dgram_bind               = virtio_transport_dgram_bind,
-		.dgram_allow              = virtio_transport_dgram_allow,
-
-		.stream_enqueue           = virtio_transport_stream_enqueue,
-		.stream_dequeue           = virtio_transport_stream_dequeue,
-		.stream_has_data          = virtio_transport_stream_has_data,
-		.stream_has_space         = virtio_transport_stream_has_space,
-		.stream_rcvhiwat          = virtio_transport_stream_rcvhiwat,
-		.stream_is_active         = virtio_transport_stream_is_active,
-		.stream_allow             = virtio_transport_stream_allow,
-
-		.notify_poll_in           = virtio_transport_notify_poll_in,
-		.notify_poll_out          = virtio_transport_notify_poll_out,
-		.notify_recv_init         = virtio_transport_notify_recv_init,
-		.notify_recv_pre_block    = virtio_transport_notify_recv_pre_block,
-		.notify_recv_pre_dequeue  = virtio_transport_notify_recv_pre_dequeue,
-		.notify_recv_post_dequeue = virtio_transport_notify_recv_post_dequeue,
-		.notify_send_init         = virtio_transport_notify_send_init,
-		.notify_send_pre_block    = virtio_transport_notify_send_pre_block,
-		.notify_send_pre_enqueue  = virtio_transport_notify_send_pre_enqueue,
-		.notify_send_post_enqueue = virtio_transport_notify_send_post_enqueue,
-
-		.set_buffer_size          = virtio_transport_set_buffer_size,
-		.set_min_buffer_size      = virtio_transport_set_min_buffer_size,
-		.set_max_buffer_size      = virtio_transport_set_max_buffer_size,
-		.get_buffer_size          = virtio_transport_get_buffer_size,
-		.get_min_buffer_size      = virtio_transport_get_min_buffer_size,
-		.get_max_buffer_size      = virtio_transport_get_max_buffer_size,
-	},
-
-	.send_pkt = vhost_transport_send_pkt,
-};
-
 static int __init vhost_vsock_init(void)
 {
 	int ret;
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 4c7781f4b29b..96d8132acbd7 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -151,7 +151,8 @@ virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
 
 void virtio_transport_destruct(struct vsock_sock *vsk);
 
-void virtio_transport_recv_pkt(struct virtio_vsock_pkt *pkt);
+void virtio_transport_recv_pkt(struct virtio_transport *t,
+			       struct virtio_vsock_pkt *pkt);
 void virtio_transport_free_pkt(struct virtio_vsock_pkt *pkt);
 void virtio_transport_inc_tx_pkt(struct virtio_vsock_sock *vvs, struct virtio_vsock_pkt *pkt);
 u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 wanted);
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 082a30936690..3756f0857946 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -86,33 +86,6 @@ static u32 virtio_transport_get_local_cid(void)
 	return ret;
 }
 
-static void virtio_transport_loopback_work(struct work_struct *work)
-{
-	struct virtio_vsock *vsock =
-		container_of(work, struct virtio_vsock, loopback_work);
-	LIST_HEAD(pkts);
-
-	spin_lock_bh(&vsock->loopback_list_lock);
-	list_splice_init(&vsock->loopback_list, &pkts);
-	spin_unlock_bh(&vsock->loopback_list_lock);
-
-	mutex_lock(&vsock->rx_lock);
-
-	if (!vsock->rx_run)
-		goto out;
-
-	while (!list_empty(&pkts)) {
-		struct virtio_vsock_pkt *pkt;
-
-		pkt = list_first_entry(&pkts, struct virtio_vsock_pkt, list);
-		list_del_init(&pkt->list);
-
-		virtio_transport_recv_pkt(pkt);
-	}
-out:
-	mutex_unlock(&vsock->rx_lock);
-}
-
 static int virtio_transport_send_pkt_loopback(struct virtio_vsock *vsock,
 					      struct virtio_vsock_pkt *pkt)
 {
@@ -370,59 +343,6 @@ static bool virtio_transport_more_replies(struct virtio_vsock *vsock)
 	return val < virtqueue_get_vring_size(vq);
 }
 
-static void virtio_transport_rx_work(struct work_struct *work)
-{
-	struct virtio_vsock *vsock =
-		container_of(work, struct virtio_vsock, rx_work);
-	struct virtqueue *vq;
-
-	vq = vsock->vqs[VSOCK_VQ_RX];
-
-	mutex_lock(&vsock->rx_lock);
-
-	if (!vsock->rx_run)
-		goto out;
-
-	do {
-		virtqueue_disable_cb(vq);
-		for (;;) {
-			struct virtio_vsock_pkt *pkt;
-			unsigned int len;
-
-			if (!virtio_transport_more_replies(vsock)) {
-				/* Stop rx until the device processes already
-				 * pending replies.  Leave rx virtqueue
-				 * callbacks disabled.
-				 */
-				goto out;
-			}
-
-			pkt = virtqueue_get_buf(vq, &len);
-			if (!pkt) {
-				break;
-			}
-
-			vsock->rx_buf_nr--;
-
-			/* Drop short/long packets */
-			if (unlikely(len < sizeof(pkt->hdr) ||
-				     len > sizeof(pkt->hdr) + pkt->len)) {
-				virtio_transport_free_pkt(pkt);
-				continue;
-			}
-
-			pkt->len = len - sizeof(pkt->hdr);
-			virtio_transport_deliver_tap_pkt(pkt);
-			virtio_transport_recv_pkt(pkt);
-		}
-	} while (!virtqueue_enable_cb(vq));
-
-out:
-	if (vsock->rx_buf_nr < vsock->rx_buf_max_nr / 2)
-		virtio_vsock_rx_fill(vsock);
-	mutex_unlock(&vsock->rx_lock);
-}
-
 /* event_lock must be held */
 static int virtio_vsock_event_fill_one(struct virtio_vsock *vsock,
 				       struct virtio_vsock_event *event)
@@ -586,6 +506,86 @@ static struct virtio_transport virtio_transport = {
 	.send_pkt = virtio_transport_send_pkt,
 };
 
+static void virtio_transport_loopback_work(struct work_struct *work)
+{
+	struct virtio_vsock *vsock =
+		container_of(work, struct virtio_vsock, loopback_work);
+	LIST_HEAD(pkts);
+
+	spin_lock_bh(&vsock->loopback_list_lock);
+	list_splice_init(&vsock->loopback_list, &pkts);
+	spin_unlock_bh(&vsock->loopback_list_lock);
+
+	mutex_lock(&vsock->rx_lock);
+
+	if (!vsock->rx_run)
+		goto out;
+
+	while (!list_empty(&pkts)) {
+		struct virtio_vsock_pkt *pkt;
+
+		pkt = list_first_entry(&pkts, struct virtio_vsock_pkt, list);
+		list_del_init(&pkt->list);
+
+		virtio_transport_recv_pkt(&virtio_transport, pkt);
+	}
+out:
+	mutex_unlock(&vsock->rx_lock);
+}
+
+static void virtio_transport_rx_work(struct work_struct *work)
+{
+	struct virtio_vsock *vsock =
+		container_of(work, struct virtio_vsock, rx_work);
+	struct virtqueue *vq;
+
+	vq = vsock->vqs[VSOCK_VQ_RX];
+
+	mutex_lock(&vsock->rx_lock);
+
+	if (!vsock->rx_run)
+		goto out;
+
+	do {
+		virtqueue_disable_cb(vq);
+		for (;;) {
+			struct virtio_vsock_pkt *pkt;
+			unsigned int len;
+
+			if (!virtio_transport_more_replies(vsock)) {
+				/* Stop rx until the device processes already
+				 * pending replies.  Leave rx virtqueue
+				 * callbacks disabled.
+				 */
+				goto out;
+			}
+
+			pkt = virtqueue_get_buf(vq, &len);
+			if (!pkt) {
+				break;
+			}
+
+			vsock->rx_buf_nr--;
+
+			/* Drop short/long packets */
+			if (unlikely(len < sizeof(pkt->hdr) ||
+				     len > sizeof(pkt->hdr) + pkt->len)) {
+				virtio_transport_free_pkt(pkt);
+				continue;
+			}
+
+			pkt->len = len - sizeof(pkt->hdr);
+			virtio_transport_deliver_tap_pkt(pkt);
+			virtio_transport_recv_pkt(&virtio_transport, pkt);
+		}
+	} while (!virtqueue_enable_cb(vq));
+
+out:
+	if (vsock->rx_buf_nr < vsock->rx_buf_max_nr / 2)
+		virtio_vsock_rx_fill(vsock);
+	mutex_unlock(&vsock->rx_lock);
+}
+
 static int virtio_vsock_probe(struct virtio_device *vdev)
 {
 	vq_callback_t *callbacks[] = {
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index ed1ad5289164..382536b69029 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -689,9 +689,9 @@ static int virtio_transport_reset(struct vsock_sock *vsk,
 /* Normally packets are associated with a socket.  There may be no socket if an
  * attempt was made to connect to a socket that does not exist.
  */
-static int virtio_transport_reset_no_sock(struct virtio_vsock_pkt *pkt)
+static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
+					  struct virtio_vsock_pkt *pkt)
 {
-	const struct virtio_transport *t;
 	struct virtio_vsock_pkt *reply;
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_RST,
@@ -711,7 +711,6 @@ static int virtio_transport_reset_no_sock(struct virtio_vsock_pkt *pkt)
 	if (!reply)
 		return -ENOMEM;
 
-	t = virtio_transport_get_ops();
 	if (!t) {
 		virtio_transport_free_pkt(reply);
 		return -ENOTCONN;
@@ -1047,7 +1046,8 @@ static bool virtio_transport_space_update(struct sock *sk,
 /* We are under the virtio-vsock's vsock->rx_lock or vhost-vsock's vq->mutex
  * lock.
  */
-void virtio_transport_recv_pkt(struct virtio_vsock_pkt *pkt)
+void virtio_transport_recv_pkt(struct virtio_transport *t,
+			       struct virtio_vsock_pkt *pkt)
 {
 	struct sockaddr_vm src, dst;
 	struct vsock_sock *vsk;
@@ -1069,7 +1069,7 @@ void virtio_transport_recv_pkt(struct virtio_vsock_pkt *pkt)
 					le32_to_cpu(pkt->hdr.fwd_cnt));
 
 	if (le16_to_cpu(pkt->hdr.type) != VIRTIO_VSOCK_TYPE_STREAM) {
-		(void)virtio_transport_reset_no_sock(pkt);
+		(void)virtio_transport_reset_no_sock(t, pkt);
 		goto free_pkt;
 	}
 
@@ -1080,7 +1080,7 @@ void virtio_transport_recv_pkt(struct virtio_vsock_pkt *pkt)
 	if (!sk) {
 		sk = vsock_find_bound_socket(&dst);
 		if (!sk) {
-			(void)virtio_transport_reset_no_sock(pkt);
+			(void)virtio_transport_reset_no_sock(t, pkt);
 			goto free_pkt;
 		}
 	}
-- 
2.21.0

