Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18D18109BCA
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbfKZKJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:09:02 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40630 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbfKZKJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:09:02 -0500
Received: by mail-pl1-f195.google.com with SMTP id f9so7935047plr.7;
        Tue, 26 Nov 2019 02:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JOqfaTjB9hR4SvgWUY3wyefTnNCZb7GyoEbULC6AJJo=;
        b=QkhGdXqAqq10xMSu+2CnyH8h3k9xRLREYvQrc7Kl+Q0+83MDkF+tuhBxvnRiUIrU5H
         eLqXuIZUtQQQafXXx5KJYDzw+cbyREKs1xo+xDhrhWrKOz2Hfe+KnD5BCeK8L6z7FoGB
         H8uL0SKa0QBz+PC6YnjRyHOBKKwWwEqH1f4T41+MgFl+QMvSklHCyhIdh8muKtDnfRAe
         wnppauQ8mL6ut7U+3hHZwdGgDP61KM8PE2qspO4rG1wmunzRjivSxjNu6ss3SQdisLdS
         3CD2OlXrfUF8AsknNCn14UV/RDnRG4uS2zPqKLV30IbvCAr64AsnlplUmR+oN2N7ka5Y
         wSMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JOqfaTjB9hR4SvgWUY3wyefTnNCZb7GyoEbULC6AJJo=;
        b=kofofmyTNIoeFUm1qFrzSFX30jhzjAn8Twl3anLeGsOzJRiv2ApRnN8ifyoCvfasek
         9QH9nQKAl3m07gBQmb2U3hFANqx5enkP1ahMXYumUX0if764y7IDlTAMHI4mnuki/LgM
         qkbTEexAKTCDCzYby0EPsblIWs24HdethA6nzUeBbfweBvOUCmhGBoWu5yG0CtDz/gdO
         sDbkr1nhoNAQtzJCy6UxRMp1Oj62SZWBaKCYVmZLqS3BA16RH06jFN+5VSIHqWp7rmDL
         cy7iioPhx+a9hftsvT2GbqIPH2GeiNGxh8G/aIm5Pvsx4Quvr81i0gG0k3Cqu61ekDhg
         lh0w==
X-Gm-Message-State: APjAAAUc0Txte9Hoooxilso/urRvCY2d4vbI0tOzYDxa5RuRKG7EtSUR
        yxBO3LmZkystT8YNbv7cNBk=
X-Google-Smtp-Source: APXvYqwPyv6+pc3DP4PZm1a3x96MwS0Kc6f03xdB6l2+mtJteT+8mFJPIbbpCn/sngodhdsZCCyQtA==
X-Received: by 2002:a17:90b:f0c:: with SMTP id br12mr5745156pjb.67.1574762941343;
        Tue, 26 Nov 2019 02:09:01 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s24sm11848485pfh.108.2019.11.26.02.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 02:09:00 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [RFC net-next 05/18] vhost_net: user tap recvmsg api to access ptr ring
Date:   Tue, 26 Nov 2019 19:07:31 +0900
Message-Id: <20191126100744.5083-6-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
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

This will be useful in implementation of virtio-net XDP offload
feature, where packets will be XDP processed before they are passed
to vhost_net.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 drivers/net/tap.c      | 22 ++++++++++++++++++-
 drivers/net/tun.c      | 24 ++++++++++++++++++++-
 drivers/vhost/net.c    | 48 +++++++++++++++++++++++++++++++-----------
 include/linux/if_tun.h | 18 ++++++++++++++++
 4 files changed, 98 insertions(+), 14 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 4df7bf00af66..8635cdfd7aa4 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1234,8 +1234,28 @@ static int tap_recvmsg(struct socket *sock, struct msghdr *m,
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
index 1a2dd53caade..0f91b374a558 100644
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
2.20.1

