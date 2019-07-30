Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90F9D7ACA5
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 17:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732477AbfG3Pnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 11:43:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47262 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725209AbfG3Pns (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 11:43:48 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0884C811DC;
        Tue, 30 Jul 2019 15:43:48 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-116-91.ams2.redhat.com [10.36.116.91])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F1A08605AD;
        Tue, 30 Jul 2019 15:43:45 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH net-next v5 1/5] vsock/virtio: limit the memory used per-socket
Date:   Tue, 30 Jul 2019 17:43:30 +0200
Message-Id: <20190730154334.237789-2-sgarzare@redhat.com>
In-Reply-To: <20190730154334.237789-1-sgarzare@redhat.com>
References: <20190730154334.237789-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 30 Jul 2019 15:43:48 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since virtio-vsock was introduced, the buffers filled by the host
and pushed to the guest using the vring, are directly queued in
a per-socket list. These buffers are preallocated by the guest
with a fixed size (4 KB).

The maximum amount of memory used by each socket should be
controlled by the credit mechanism.
The default credit available per-socket is 256 KB, but if we use
only 1 byte per packet, the guest can queue up to 262144 of 4 KB
buffers, using up to 1 GB of memory per-socket. In addition, the
guest will continue to fill the vring with new 4 KB free buffers
to avoid starvation of other sockets.

This patch mitigates this issue copying the payload of small
packets (< 128 bytes) into the buffer of last packet queued, in
order to avoid wasting memory.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vsock.c                   |  2 +
 include/linux/virtio_vsock.h            |  1 +
 net/vmw_vsock/virtio_transport.c        |  1 +
 net/vmw_vsock/virtio_transport_common.c | 60 +++++++++++++++++++++----
 4 files changed, 55 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 6a50e1d0529c..6c8390a2af52 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -329,6 +329,8 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
 		return NULL;
 	}
 
+	pkt->buf_len = pkt->len;
+
 	nbytes = copy_from_iter(pkt->buf, pkt->len, &iov_iter);
 	if (nbytes != pkt->len) {
 		vq_err(vq, "Expected %u byte payload, got %zu bytes\n",
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index e223e2632edd..7d973903f52e 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -52,6 +52,7 @@ struct virtio_vsock_pkt {
 	/* socket refcnt not held, only use for cancellation */
 	struct vsock_sock *vsk;
 	void *buf;
+	u32 buf_len;
 	u32 len;
 	u32 off;
 	bool reply;
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 0815d1357861..082a30936690 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -307,6 +307,7 @@ static void virtio_vsock_rx_fill(struct virtio_vsock *vsock)
 			break;
 		}
 
+		pkt->buf_len = buf_len;
 		pkt->len = buf_len;
 
 		sg_init_one(&hdr, &pkt->hdr, sizeof(pkt->hdr));
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 6f1a8aff65c5..095221f94786 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -26,6 +26,9 @@
 /* How long to wait for graceful shutdown of a connection */
 #define VSOCK_CLOSE_TIMEOUT (8 * HZ)
 
+/* Threshold for detecting small packets to copy */
+#define GOOD_COPY_LEN  128
+
 static const struct virtio_transport *virtio_transport_get_ops(void)
 {
 	const struct vsock_transport *t = vsock_core_get_transport();
@@ -64,6 +67,9 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
 		pkt->buf = kmalloc(len, GFP_KERNEL);
 		if (!pkt->buf)
 			goto out_pkt;
+
+		pkt->buf_len = len;
+
 		err = memcpy_from_msg(pkt->buf, info->msg, len);
 		if (err)
 			goto out;
@@ -841,24 +847,60 @@ virtio_transport_recv_connecting(struct sock *sk,
 	return err;
 }
 
+static void
+virtio_transport_recv_enqueue(struct vsock_sock *vsk,
+			      struct virtio_vsock_pkt *pkt)
+{
+	struct virtio_vsock_sock *vvs = vsk->trans;
+	bool free_pkt = false;
+
+	pkt->len = le32_to_cpu(pkt->hdr.len);
+	pkt->off = 0;
+
+	spin_lock_bh(&vvs->rx_lock);
+
+	virtio_transport_inc_rx_pkt(vvs, pkt);
+
+	/* Try to copy small packets into the buffer of last packet queued,
+	 * to avoid wasting memory queueing the entire buffer with a small
+	 * payload.
+	 */
+	if (pkt->len <= GOOD_COPY_LEN && !list_empty(&vvs->rx_queue)) {
+		struct virtio_vsock_pkt *last_pkt;
+
+		last_pkt = list_last_entry(&vvs->rx_queue,
+					   struct virtio_vsock_pkt, list);
+
+		/* If there is space in the last packet queued, we copy the
+		 * new packet in its buffer.
+		 */
+		if (pkt->len <= last_pkt->buf_len - last_pkt->len) {
+			memcpy(last_pkt->buf + last_pkt->len, pkt->buf,
+			       pkt->len);
+			last_pkt->len += pkt->len;
+			free_pkt = true;
+			goto out;
+		}
+	}
+
+	list_add_tail(&pkt->list, &vvs->rx_queue);
+
+out:
+	spin_unlock_bh(&vvs->rx_lock);
+	if (free_pkt)
+		virtio_transport_free_pkt(pkt);
+}
+
 static int
 virtio_transport_recv_connected(struct sock *sk,
 				struct virtio_vsock_pkt *pkt)
 {
 	struct vsock_sock *vsk = vsock_sk(sk);
-	struct virtio_vsock_sock *vvs = vsk->trans;
 	int err = 0;
 
 	switch (le16_to_cpu(pkt->hdr.op)) {
 	case VIRTIO_VSOCK_OP_RW:
-		pkt->len = le32_to_cpu(pkt->hdr.len);
-		pkt->off = 0;
-
-		spin_lock_bh(&vvs->rx_lock);
-		virtio_transport_inc_rx_pkt(vvs, pkt);
-		list_add_tail(&pkt->list, &vvs->rx_queue);
-		spin_unlock_bh(&vvs->rx_lock);
-
+		virtio_transport_recv_enqueue(vsk, pkt);
 		sk->sk_data_ready(sk);
 		return err;
 	case VIRTIO_VSOCK_OP_CREDIT_UPDATE:
-- 
2.20.1

