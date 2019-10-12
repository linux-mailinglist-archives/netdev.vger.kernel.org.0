Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30318D4BF6
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 03:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbfJLByo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 21:54:44 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35817 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728799AbfJLByn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 21:54:43 -0400
Received: by mail-pl1-f195.google.com with SMTP id c3so5271487plo.2;
        Fri, 11 Oct 2019 18:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aemc2m7M6ERZ7jrXLh5L9TwhoO5qe1NcLVg2O2xGzms=;
        b=c0Q56pUQNuHfYFlH1dxjzdT7SxiwdTHGLptUhAbocoGdwoDpGT9gLO12lJxV32jJWQ
         n3lhgOG6SYo4cZ13HvHpXNJy+KbvYTYm4VcS6Gfbs8xN+GPDHYWMLgxnBVQZaOCMAsxb
         oa7nsWvN//+pGWAc2rnOdaQC1mGHeoJyx2PPDG34H1BcYfr7hzlzfm/eNXRapUFFBtOm
         ZYnW0pkO2mTZMUaaCWgZ/L0f4qZYQlL4ZrUqsR7rst5BXtN+tOY4PeslsAXJPGTwF8PP
         4XQ+PDJHHus/hCB9+vcVJP46uipbQlmcxCXPxxNbrlImzFoZjzwOJ7o4ll9MI41ZyOmc
         49Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aemc2m7M6ERZ7jrXLh5L9TwhoO5qe1NcLVg2O2xGzms=;
        b=WLjDibv63avtI3xpHfyyuqSGROVHLBE4YfE7KixbxgrCPrtUD+Dy2rjJUjgRnE5bhg
         vUkbFmuthprpiK3CEfZx7ojygN0RfiGnQgbUGV2+92UP1A9rLJUbJkdI964m2Juo3avn
         pJzyl5RLCWOOH3wsmc6NxoK7M8HH3Z9zvoYzhhEzbJS8Cxm2PHspVWayuWZkYmysS+g6
         7i9M0dP8Yh4EvMmWivSjSWioPhZFayuKFvdgZ+1FUNq8x2Y8BQCimEWaTs3hQw+4VRfs
         D7sNQj64A/hFfewQei8cd67luJ7GXDhsEPk6CT7Niar2ad0QbKpa1dw80rqAnrO1QO7m
         BfmQ==
X-Gm-Message-State: APjAAAVcYiH1R++cikkKoLjeJATHMzEYqTqvy52IB2Q+qknwIgxSv7tS
        8X+1e6dna0Wx7u4nwzfuuz8=
X-Google-Smtp-Source: APXvYqx8Mkqd/4+atQ6tFJLNh/jn99EK79gsh6NgLlpBUrnjSQj3sQ7NN5aw89F/6l4LFb/uf+Wk/g==
X-Received: by 2002:a17:902:9349:: with SMTP id g9mr17036858plp.75.1570845282286;
        Fri, 11 Oct 2019 18:54:42 -0700 (PDT)
Received: from localhost.localdomain (KD124211219252.ppp-bb.dion.ne.jp. [124.211.219.252])
        by smtp.gmail.com with ESMTPSA id e127sm10992187pfe.37.2019.10.11.18.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 18:54:41 -0700 (PDT)
From:   prashantbhole.linux@gmail.com
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        David Ahern <dsahern@gmail.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 3/3] tuntap: remove usage of ptr ring in vhost_net
Date:   Sat, 12 Oct 2019 10:53:57 +0900
Message-Id: <20191012015357.1775-4-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191012015357.1775-1-prashantbhole.linux@gmail.com>
References: <20191012015357.1775-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prashant Bhole <prashantbhole.linux@gmail.com>

Remove usage of ptr ring of tuntap in vhost_net and remove the
functions exported from tuntap drivers to get ptr ring.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 drivers/net/tap.c   | 13 -------------
 drivers/net/tun.c   | 13 -------------
 drivers/vhost/net.c | 31 ++++---------------------------
 3 files changed, 4 insertions(+), 53 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 3d0bf382dbbc..27ffd2210375 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1298,19 +1298,6 @@ struct socket *tap_get_socket(struct file *file)
 }
 EXPORT_SYMBOL_GPL(tap_get_socket);
 
-struct ptr_ring *tap_get_ptr_ring(struct file *file)
-{
-	struct tap_queue *q;
-
-	if (file->f_op != &tap_fops)
-		return ERR_PTR(-EINVAL);
-	q = file->private_data;
-	if (!q)
-		return ERR_PTR(-EBADFD);
-	return &q->ring;
-}
-EXPORT_SYMBOL_GPL(tap_get_ptr_ring);
-
 int tap_queue_resize(struct tap_dev *tap)
 {
 	struct net_device *dev = tap->dev;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 7d4886f53389..75893921411b 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3750,19 +3750,6 @@ struct socket *tun_get_socket(struct file *file)
 }
 EXPORT_SYMBOL_GPL(tun_get_socket);
 
-struct ptr_ring *tun_get_tx_ring(struct file *file)
-{
-	struct tun_file *tfile;
-
-	if (file->f_op != &tun_fops)
-		return ERR_PTR(-EINVAL);
-	tfile = file->private_data;
-	if (!tfile)
-		return ERR_PTR(-EBADFD);
-	return &tfile->tx_ring;
-}
-EXPORT_SYMBOL_GPL(tun_get_tx_ring);
-
 module_init(tun_init);
 module_exit(tun_cleanup);
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 5e5c1063606c..0d302efadf44 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -122,7 +122,6 @@ struct vhost_net_virtqueue {
 	/* Reference counting for outstanding ubufs.
 	 * Protected by vq mutex. Writers must also take device mutex. */
 	struct vhost_net_ubuf_ref *ubufs;
-	struct ptr_ring *rx_ring;
 	struct vhost_net_buf rxq;
 	/* Batched XDP buffs */
 	struct xdp_buff *xdp;
@@ -997,8 +996,9 @@ static int peek_head_len(struct vhost_net_virtqueue *rvq, struct sock *sk)
 	int len = 0;
 	unsigned long flags;
 
-	if (rvq->rx_ring)
-		return vhost_net_buf_peek(rvq);
+	len = vhost_net_buf_peek(rvq);
+	if (len)
+		return len;
 
 	spin_lock_irqsave(&sk->sk_receive_queue.lock, flags);
 	head = skb_peek(&sk->sk_receive_queue);
@@ -1189,7 +1189,7 @@ static void handle_rx(struct vhost_net *net)
 			goto out;
 		}
 		busyloop_intr = false;
-		if (nvq->rx_ring) {
+		if (!vhost_net_buf_is_empty(&nvq->rxq)) {
 			ctl.cmd = TUN_CMD_PACKET;
 			ctl.ptr = vhost_net_buf_consume(&nvq->rxq);
 			msg.msg_control = &ctl;
@@ -1345,7 +1345,6 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 		n->vqs[i].batched_xdp = 0;
 		n->vqs[i].vhost_hlen = 0;
 		n->vqs[i].sock_hlen = 0;
-		n->vqs[i].rx_ring = NULL;
 		vhost_net_buf_init(&n->vqs[i].rxq);
 	}
 	vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
@@ -1374,7 +1373,6 @@ static struct socket *vhost_net_stop_vq(struct vhost_net *n,
 	vhost_net_disable_vq(n, vq);
 	vq->private_data = NULL;
 	vhost_net_buf_unproduce(nvq);
-	nvq->rx_ring = NULL;
 	mutex_unlock(&vq->mutex);
 	return sock;
 }
@@ -1470,25 +1468,6 @@ static struct socket *get_raw_socket(int fd)
 	return ERR_PTR(r);
 }
 
-static struct ptr_ring *get_tap_ptr_ring(int fd)
-{
-	struct ptr_ring *ring;
-	struct file *file = fget(fd);
-
-	if (!file)
-		return NULL;
-	ring = tun_get_tx_ring(file);
-	if (!IS_ERR(ring))
-		goto out;
-	ring = tap_get_ptr_ring(file);
-	if (!IS_ERR(ring))
-		goto out;
-	ring = NULL;
-out:
-	fput(file);
-	return ring;
-}
-
 static struct socket *get_tap_socket(int fd)
 {
 	struct file *file = fget(fd);
@@ -1572,8 +1551,6 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 		r = vhost_net_enable_vq(n, vq);
 		if (r)
 			goto err_used;
-		if (index == VHOST_NET_VQ_RX)
-			nvq->rx_ring = get_tap_ptr_ring(fd);
 
 		oldubufs = nvq->ubufs;
 		nvq->ubufs = ubufs;
-- 
2.21.0

