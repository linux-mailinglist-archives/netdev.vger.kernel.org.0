Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B30C146081
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 02:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729052AbgAWBm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 20:42:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729019AbgAWBmY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 20:42:24 -0500
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B64C42468F;
        Thu, 23 Jan 2020 01:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579743743;
        bh=uXRZM4XqvPYcecrqg/EeO6E9WDUaIl+D+LycyrxBzaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F4uOXQYD/6H7fghEZqo8JCUU9AKZ22E6v3wch9KceEDiSOFzNmfVxaRIgsfuPLp7j
         3+sJiVBbs+ylEldNHLrnaNayOFvc5oX+DlkuTsZlmr7WE+skL12/yjFKeHeq+kNP5+
         y77qKSIyvSouHWBffVjsJtMCJZT5+sfjrroZJQ7E=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        jbrouer@redhat.com, toke@redhat.com, mst@redhat.com,
        toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com
Subject: [PATCH bpf-next 07/12] vhost_net: user tap recvmsg api to access ptr ring
Date:   Wed, 22 Jan 2020 18:42:05 -0700
Message-Id: <20200123014210.38412-8-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200123014210.38412-1-dsahern@kernel.org>
References: <20200123014210.38412-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prashant Bhole <prashantbhole.linux@gmail.com>

Currently vhost_net directly accesses ptr ring of tap driver to
fetch Rx packet pointers. In order to avoid it this patch modifies
tap driver's recvmsg api to do additional task of fetching Rx packet
pointers.

A special struct tun_msg_ctl is already being passed via msg_control
for tun Rx XDP batching. This patch extends tun_msg_ctl usage to
send sub commands to recvmsg api. Now tun_recvmsg will handle commands
to consume and unconsume packet pointers from ptr ring.

This will be useful in implementation of tx path XDP in tun driver,
where XDP program will process the packet before it is passed to
vhost_net.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 drivers/net/tap.c      | 22 ++++++++++++++++++-
 drivers/net/tun.c      | 24 ++++++++++++++++++++-
 drivers/vhost/net.c    | 48 +++++++++++++++++++++++++++++++-----------
 include/linux/if_tun.h | 18 ++++++++++++++++
 4 files changed, 98 insertions(+), 14 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index a0a5dc18109a..a5ce44db11a3 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1224,8 +1224,28 @@ static int tap_recvmsg(struct socket *sock, struct msghdr *m,
 		       size_t total_len, int flags)
 {
 	struct tap_queue *q = container_of(sock, struct tap_queue, sock);
-	struct sk_buff *skb = m->msg_control;
+	struct tun_msg_ctl *ctl = m->msg_control;
+	struct sk_buff *skb = NULL;
 	int ret;
+
+	if (ctl) {
+		switch (ctl->type) {
+		case TUN_MSG_PKT:
+			skb = ctl->ptr;
+			break;
+		case TUN_MSG_CONSUME_PKTS:
+			return ptr_ring_consume_batched(&q->ring,
+							ctl->ptr,
+							ctl->num);
+		case TUN_MSG_UNCONSUME_PKTS:
+			ptr_ring_unconsume(&q->ring, ctl->ptr, ctl->num,
+					   tun_ptr_free);
+			return 0;
+		default:
+			return -EINVAL;
+		}
+	}
+
 	if (flags & ~(MSG_DONTWAIT|MSG_TRUNC)) {
 		kfree_skb(skb);
 		return -EINVAL;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 6f12c32df346..197bde748c09 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2544,7 +2544,8 @@ static int tun_recvmsg(struct socket *sock, struct msghdr *m, size_t total_len,
 {
 	struct tun_file *tfile = container_of(sock, struct tun_file, socket);
 	struct tun_struct *tun = tun_get(tfile);
-	void *ptr = m->msg_control;
+	struct tun_msg_ctl *ctl = m->msg_control;
+	void *ptr = NULL;
 	int ret;
 
 	if (!tun) {
@@ -2552,6 +2553,27 @@ static int tun_recvmsg(struct socket *sock, struct msghdr *m, size_t total_len,
 		goto out_free;
 	}
 
+	if (ctl) {
+		switch (ctl->type) {
+		case TUN_MSG_PKT:
+			ptr = ctl->ptr;
+			break;
+		case TUN_MSG_CONSUME_PKTS:
+			ret = ptr_ring_consume_batched(&tfile->tx_ring,
+						       ctl->ptr,
+						       ctl->num);
+			goto out;
+		case TUN_MSG_UNCONSUME_PKTS:
+			ptr_ring_unconsume(&tfile->tx_ring, ctl->ptr,
+					   ctl->num, tun_ptr_free);
+			ret = 0;
+			goto out;
+		default:
+			ret = -EINVAL;
+			goto out_put_tun;
+		}
+	}
+
 	if (flags & ~(MSG_DONTWAIT|MSG_TRUNC|MSG_ERRQUEUE)) {
 		ret = -EINVAL;
 		goto out_put_tun;
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index e158159671fa..482548d00105 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -175,24 +175,44 @@ static void *vhost_net_buf_consume(struct vhost_net_buf *rxq)
 
 static int vhost_net_buf_produce(struct vhost_net_virtqueue *nvq)
 {
+	struct vhost_virtqueue *vq = &nvq->vq;
+	struct socket *sock = vq->private_data;
 	struct vhost_net_buf *rxq = &nvq->rxq;
+	struct tun_msg_ctl ctl = {
+		.type = TUN_MSG_CONSUME_PKTS,
+		.ptr = (void *) rxq->queue,
+		.num = VHOST_NET_BATCH,
+	};
+	struct msghdr msg = {
+		.msg_control = &ctl,
+	};
 
 	rxq->head = 0;
-	rxq->tail = ptr_ring_consume_batched(nvq->rx_ring, rxq->queue,
-					      VHOST_NET_BATCH);
+	rxq->tail = sock->ops->recvmsg(sock, &msg, 0, 0);
+	if (WARN_ON_ONCE(rxq->tail < 0))
+		rxq->tail = 0;
+
 	return rxq->tail;
 }
 
 static void vhost_net_buf_unproduce(struct vhost_net_virtqueue *nvq)
 {
+	struct vhost_virtqueue *vq = &nvq->vq;
+	struct socket *sock = vq->private_data;
 	struct vhost_net_buf *rxq = &nvq->rxq;
+	struct tun_msg_ctl ctl = {
+		.type = TUN_MSG_UNCONSUME_PKTS,
+		.ptr = (void *) (rxq->queue + rxq->head),
+		.num = vhost_net_buf_get_size(rxq),
+	};
+	struct msghdr msg = {
+		.msg_control = &ctl,
+	};
 
-	if (nvq->rx_ring && !vhost_net_buf_is_empty(rxq)) {
-		ptr_ring_unconsume(nvq->rx_ring, rxq->queue + rxq->head,
-				   vhost_net_buf_get_size(rxq),
-				   tun_ptr_free);
-		rxq->head = rxq->tail = 0;
-	}
+	if (!vhost_net_buf_is_empty(rxq))
+		sock->ops->recvmsg(sock, &msg, 0, 0);
+
+	rxq->head = rxq->tail = 0;
 }
 
 static int vhost_net_buf_peek_len(void *ptr)
@@ -1109,6 +1129,7 @@ static void handle_rx(struct vhost_net *net)
 		.flags = 0,
 		.gso_type = VIRTIO_NET_HDR_GSO_NONE
 	};
+	struct tun_msg_ctl ctl;
 	size_t total_len = 0;
 	int err, mergeable;
 	s16 headcount;
@@ -1166,8 +1187,11 @@ static void handle_rx(struct vhost_net *net)
 			goto out;
 		}
 		busyloop_intr = false;
-		if (nvq->rx_ring)
-			msg.msg_control = vhost_net_buf_consume(&nvq->rxq);
+		if (nvq->rx_ring) {
+			ctl.type = TUN_MSG_PKT;
+			ctl.ptr = vhost_net_buf_consume(&nvq->rxq);
+			msg.msg_control = &ctl;
+		}
 		/* On overrun, truncate and discard */
 		if (unlikely(headcount > UIO_MAXIOV)) {
 			iov_iter_init(&msg.msg_iter, READ, vq->iov, 1, 1);
@@ -1346,8 +1370,8 @@ static struct socket *vhost_net_stop_vq(struct vhost_net *n,
 	mutex_lock(&vq->mutex);
 	sock = vq->private_data;
 	vhost_net_disable_vq(n, vq);
-	vq->private_data = NULL;
 	vhost_net_buf_unproduce(nvq);
+	vq->private_data = NULL;
 	nvq->rx_ring = NULL;
 	mutex_unlock(&vq->mutex);
 	return sock;
@@ -1538,8 +1562,8 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 		}
 
 		vhost_net_disable_vq(n, vq);
-		vq->private_data = sock;
 		vhost_net_buf_unproduce(nvq);
+		vq->private_data = sock;
 		r = vhost_vq_init_access(vq);
 		if (r)
 			goto err_used;
diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
index 49ca20063a35..9184e3f177b8 100644
--- a/include/linux/if_tun.h
+++ b/include/linux/if_tun.h
@@ -12,8 +12,26 @@
 
 #define TUN_XDP_FLAG 0x1UL
 
+/*
+ * tun_msg_ctl types
+ */
+
 #define TUN_MSG_UBUF 1
 #define TUN_MSG_PTR  2
+/*
+ * Used for passing a packet pointer from vhost to tun
+ */
+#define TUN_MSG_PKT  3
+/*
+ * Used for passing an array of pointer from vhost to tun.
+ * tun consumes packets from ptr ring and stores in pointer array.
+ */
+#define TUN_MSG_CONSUME_PKTS    4
+/*
+ * Used for passing an array of pointer from vhost to tun.
+ * tun consumes get pointer from array and puts back into ptr ring.
+ */
+#define TUN_MSG_UNCONSUME_PKTS  5
 struct tun_msg_ctl {
 	unsigned short type;
 	unsigned short num;
-- 
2.21.1 (Apple Git-122.3)

