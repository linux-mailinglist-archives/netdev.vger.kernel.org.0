Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5168C109BCD
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbfKZKJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:09:06 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:38759 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbfKZKJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:09:06 -0500
Received: by mail-pj1-f66.google.com with SMTP id f7so8070953pjw.5;
        Tue, 26 Nov 2019 02:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+QD4/vKzpUKJ7oAMMcWF4SBVUkQv/vIBx+F+3VPKSIM=;
        b=Dad2fXqh5PjlpIH3rO+thxIGofHNhYZUm+ZLETyge4e7luum6aCm1A3AI5ThMS310E
         R4Xj/8Eh+TByGj7pfweNNFqDHyqQKsaKv7ujNrigl64aOA5ORPDVuVwF8DBwlLQA/xsN
         2ICt4DG1Q+3waVVvDBsMLEigv3rmbn1vXvQDRuRdH7w2/jXjlYjlC09XERU2kaL7p9Db
         MEY1/8o4irNqzMaJuU5BozHQ9JT/4oEIQ6655AN0p1nRUuGHXJHKBb/VYgmPs+Bzrcx6
         VcfSImSIuac8mJWcGQMOg8yxKY4j1WneWZfogz3EYkU6dkoWEiuYjotAtqoP44jBGAOe
         Utcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+QD4/vKzpUKJ7oAMMcWF4SBVUkQv/vIBx+F+3VPKSIM=;
        b=ZYWwTqdKvklO7C6i+rApGBDs0vjl+G+6XH+Oz8/4J3NgyoutaBkJ3Eqk//ui4f5+69
         kTBy4nM/O80jGL4Z3rCUu/MIi7ZASLgm/V93jIFltixH/1OHFRlq19AfACtp0rDIgvN8
         JekU3EuaHZt+KnCJDjxTiMM4kwLkkCkq7nP2QFIKZXUDbNzNt4FOi85ggkgFcnjn6xvA
         peEQiaicajBEBmu3VvKOxrTzCQqHgNvPTDLq2pRAYeODTaj84KIhx8OF+Sesq8kpCUbk
         5GlxuxwctQeOrvFhrEmwihTDvAOvOkapwlvCrXN0JXCMaYTZpnN4V4bHUOj+1pv8NqTd
         J2fg==
X-Gm-Message-State: APjAAAUdbYb9uUvsZkYbLsnJBBrRBGnYxZDoyNB9LivMNokW86DYVtLA
        1SuHXbYCNz5OuqgaLKFhkgo=
X-Google-Smtp-Source: APXvYqxxHoIpfqZB5NCqWS+mIJcFEPH5D91ww1dQwvhntGuceZdTfPynWee8zZHRxK2/XD+OeSmwNA==
X-Received: by 2002:a17:902:9891:: with SMTP id s17mr33484924plp.101.1574762945278;
        Tue, 26 Nov 2019 02:09:05 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s24sm11848485pfh.108.2019.11.26.02.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 02:09:04 -0800 (PST)
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
Subject: [RFC net-next 06/18] tuntap: remove usage of ptr ring in vhost_net
Date:   Tue, 26 Nov 2019 19:07:32 +0900
Message-Id: <20191126100744.5083-7-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
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
index 8635cdfd7aa4..6426501b8d0e 100644
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
index 0f91b374a558..2e069d1ef946 100644
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
2.20.1

