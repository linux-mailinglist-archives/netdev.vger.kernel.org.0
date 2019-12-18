Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B32012412D
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 09:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfLRIMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 03:12:47 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41954 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfLRIMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 03:12:47 -0500
Received: by mail-pg1-f193.google.com with SMTP id x8so849267pgk.8
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 00:12:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A7f6U1ZZOdGydoncjTbyDDEcwUd0l9U8++URLfkajK8=;
        b=aWMxtvcjEs0lfrvTfswnL+huzglc5pzVSVFSpBGtev296oeuFGt396va1J386IKYmV
         W9cpWNJu8KpeaCXxSA53uQGsYAaDBfqb4jWmsjLBiTeeg2O/792p/KVf7k1Xc1kY8VB0
         dFZ2gXChwkCqX0B3e9FMMaW5VyHngW+w/CvMEUlhXaltSrg/eqWV/Hz3goFmuKPCJiVF
         1Hv66/Z2KD7SkRXwirnhqnroMZKuBYS8MXzGkpwrvIXstyTFsnGlkq7Mi+tbym6KUZmG
         2aBvY8hPRAirMdUljC9LUAaU+BBDxL4NoZBuryIDr9EDDtBSboRuahBmM0ndN/GfnCXJ
         5dgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A7f6U1ZZOdGydoncjTbyDDEcwUd0l9U8++URLfkajK8=;
        b=sjWb4I6eUc1n3gOneMQGYrgedyWZ1wuq+RJ99TPYTgkCLZ7VOiLALkPy9ZSTngOkSa
         QPds6+BT1XojaqttUMc22pmNXcfc7GwNiq7OezX4A8vOcumstIulygZYnRPqUArCKHcd
         BO892AZouW3Yf4Y+5tL9Ny/17X1bostP6mvcPiZgL2qbrl5u+w5BBMjwBZXiBtYE9RBn
         GEXyDiGSxdWRuRkhTOf/13wxAas2A+cNwRo1phgJvbMPX4NmTK2ap8hvilKp6+YJ7EFn
         8WQYUosCmSLc5hIqnuTGeMfiyhW9khuszENuhwdY6YuRSm1t6GEUGbm3e4jNF4Ikpvl8
         kDzg==
X-Gm-Message-State: APjAAAXUBpq4VYnthzbGCXFDFHlMzoOU4ECCcKepVik1VTpoz0zbb8yn
        RKpIJdTJg5DVmWqkZhARXsI=
X-Google-Smtp-Source: APXvYqx+X89064sjkUDCyUxl2GocGLHPp53zONOHg494UzE49PTOhXtabXkE7QKzNkZrk4pFPQDzTw==
X-Received: by 2002:aa7:9474:: with SMTP id t20mr1583364pfq.241.1576656766465;
        Wed, 18 Dec 2019 00:12:46 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s1sm1799181pgv.87.2019.12.18.00.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 00:12:46 -0800 (PST)
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
Subject: [RFC net-next 09/14] tuntap: remove usage of ptr ring in vhost_net
Date:   Wed, 18 Dec 2019 17:10:45 +0900
Message-Id: <20191218081050.10170-10-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove usage of ptr ring of tuntap in vhost_net and remove the
functions exported from tuntap drivers to get ptr ring.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 drivers/net/tap.c      | 13 -------------
 drivers/net/tun.c      | 13 -------------
 drivers/vhost/net.c    | 31 ++++---------------------------
 include/linux/if_tap.h |  5 -----
 include/linux/if_tun.h |  5 -----
 5 files changed, 4 insertions(+), 63 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index a5ce44db11a3..fe816a99275d 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1288,19 +1288,6 @@ struct socket *tap_get_socket(struct file *file)
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
index 4f28f2387435..d078b4659897 100644
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
index 482548d00105..30b5c68193c9 100644
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
@@ -1187,7 +1187,7 @@ static void handle_rx(struct vhost_net *net)
 			goto out;
 		}
 		busyloop_intr = false;
-		if (nvq->rx_ring) {
+		if (!vhost_net_buf_is_empty(&nvq->rxq)) {
 			ctl.type = TUN_MSG_PKT;
 			ctl.ptr = vhost_net_buf_consume(&nvq->rxq);
 			msg.msg_control = &ctl;
@@ -1343,7 +1343,6 @@ static int vhost_net_open(struct inode *inode, struct file *f)
 		n->vqs[i].batched_xdp = 0;
 		n->vqs[i].vhost_hlen = 0;
 		n->vqs[i].sock_hlen = 0;
-		n->vqs[i].rx_ring = NULL;
 		vhost_net_buf_init(&n->vqs[i].rxq);
 	}
 	vhost_dev_init(dev, vqs, VHOST_NET_VQ_MAX,
@@ -1372,7 +1371,6 @@ static struct socket *vhost_net_stop_vq(struct vhost_net *n,
 	vhost_net_disable_vq(n, vq);
 	vhost_net_buf_unproduce(nvq);
 	vq->private_data = NULL;
-	nvq->rx_ring = NULL;
 	mutex_unlock(&vq->mutex);
 	return sock;
 }
@@ -1468,25 +1466,6 @@ static struct socket *get_raw_socket(int fd)
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
@@ -1570,8 +1549,6 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 		r = vhost_net_enable_vq(n, vq);
 		if (r)
 			goto err_used;
-		if (index == VHOST_NET_VQ_RX)
-			nvq->rx_ring = get_tap_ptr_ring(fd);
 
 		oldubufs = nvq->ubufs;
 		nvq->ubufs = ubufs;
diff --git a/include/linux/if_tap.h b/include/linux/if_tap.h
index 915a187cfabd..68fe366fb185 100644
--- a/include/linux/if_tap.h
+++ b/include/linux/if_tap.h
@@ -4,7 +4,6 @@
 
 #if IS_ENABLED(CONFIG_TAP)
 struct socket *tap_get_socket(struct file *);
-struct ptr_ring *tap_get_ptr_ring(struct file *file);
 #else
 #include <linux/err.h>
 #include <linux/errno.h>
@@ -14,10 +13,6 @@ static inline struct socket *tap_get_socket(struct file *f)
 {
 	return ERR_PTR(-EINVAL);
 }
-static inline struct ptr_ring *tap_get_ptr_ring(struct file *f)
-{
-	return ERR_PTR(-EINVAL);
-}
 #endif /* CONFIG_TAP */
 
 #include <net/sock.h>
diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
index bb94843e3829..f01a255e076d 100644
--- a/include/linux/if_tun.h
+++ b/include/linux/if_tun.h
@@ -44,7 +44,6 @@ struct tun_xdp_hdr {
 
 #if defined(CONFIG_TUN) || defined(CONFIG_TUN_MODULE)
 struct socket *tun_get_socket(struct file *);
-struct ptr_ring *tun_get_tx_ring(struct file *file);
 bool tun_is_xdp_frame(void *ptr);
 void *tun_xdp_to_ptr(void *ptr);
 void *tun_ptr_to_xdp(void *ptr);
@@ -58,10 +57,6 @@ static inline struct socket *tun_get_socket(struct file *f)
 {
 	return ERR_PTR(-EINVAL);
 }
-static inline struct ptr_ring *tun_get_tx_ring(struct file *f)
-{
-	return ERR_PTR(-EINVAL);
-}
 static inline bool tun_is_xdp_frame(void *ptr)
 {
 	return false;
-- 
2.21.0

