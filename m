Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBE5E12412C
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 09:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfLRIMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 03:12:44 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39047 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfLRIMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 03:12:44 -0500
Received: by mail-pg1-f195.google.com with SMTP id b137so853070pga.6
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 00:12:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P5buwcQrtbCzvi0pXIQ7MKzm5zbqFFBqPPudzz+fJaA=;
        b=sqlIDWtU+yj0oRVPhhSRijGaIgjFCQDMC6JmE8j7OCCunnH6YFVJbjwV3ZapIqAkdG
         QKQ4EpYfwEYs7Xjgcsfml777xxd0My4UQ661dNvAXkXkPTgGvs+hBv5l5XNGxXLk3Dz1
         bB7K5susSdRC74dwgB9+4FAXV+f+YLyxoz6nCjzmB/klBse/vy65F7ASynZoJOCHLyGU
         c/+hhS6BINzcUpGlrkRFndHKs3R2acsjN0mD3TWEQnuDxo60+xul7eFn3ext09Qc+a7A
         xSxw7lbsAwdRwdu5L217j0QFApUl6yKz0/5G4GdM9UQOz6rNltE/CjidhTaW3ABIqmEx
         7v0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P5buwcQrtbCzvi0pXIQ7MKzm5zbqFFBqPPudzz+fJaA=;
        b=kHixxiD58hY6z7qMA55TiyqhCi0Nm6IO028xbO4k5fv+3UXVGOFnQ2Tfzaio9d5onw
         2KO722e+hz7UnbNX8CKAmiMigqDXd1F+DZ+xztdsNNECkA795rsQEOKG55vYij3Ze3rB
         bdUkWD2UYIOM7oonB2J/11dwrYOZwfJ2htfyaR02sU/GMx2ZDkTiY8IKRchODCThHI/y
         XApFYfWdW8tghqYt3ObNSlIqNdCHwJwEKMHpAY1JPrZWdKMOvNuZbz/9g997UN5s9zSt
         AmqX9W2igOnDVqiMPSJFsITAF8kncK8ruH85ZtA9IMURWvsUVsb2VwKfQnnOAjLJD6fT
         +3lQ==
X-Gm-Message-State: APjAAAXietuVql8CPRuiYOGGmpje2NIjjOsXRFW4m7G3I2M8RXtj02ru
        7n3jNcyIMGnMBvW3pARp24Q=
X-Google-Smtp-Source: APXvYqwT2SSubu+etpLi/70Gv0QyJykqRg5rSzXu5mBVo3haBW191vnqRjwkh3fvOrAW6W6ALxhvrg==
X-Received: by 2002:a62:b402:: with SMTP id h2mr1625281pfn.55.1576656762882;
        Wed, 18 Dec 2019 00:12:42 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s1sm1799181pgv.87.2019.12.18.00.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 00:12:42 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org
Subject: [RFC net-next 08/14] vhost_net: user tap recvmsg api to access ptr ring
Date:   Wed, 18 Dec 2019 17:10:44 +0900
Message-Id: <20191218081050.10170-9-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
index 1e436d9ec4e1..4f28f2387435 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2577,7 +2577,8 @@ static int tun_recvmsg(struct socket *sock, struct msghdr *m, size_t total_len,
 {
 	struct tun_file *tfile = container_of(sock, struct tun_file, socket);
 	struct tun_struct *tun = tun_get(tfile);
-	void *ptr = m->msg_control;
+	struct tun_msg_ctl *ctl = m->msg_control;
+	void *ptr = NULL;
 	int ret;
 
 	if (!tun) {
@@ -2585,6 +2586,27 @@ static int tun_recvmsg(struct socket *sock, struct msghdr *m, size_t total_len,
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
index 5bda8cf457b6..bb94843e3829 100644
--- a/include/linux/if_tun.h
+++ b/include/linux/if_tun.h
@@ -11,8 +11,26 @@
 
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
2.21.0

