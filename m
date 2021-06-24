Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A1E3B2EF1
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 14:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhFXMdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 08:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbhFXMc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 08:32:29 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926FCC061766
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 05:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=zHJR80i/wZ1WVZoiPlde4xMcP5UTsoCKyhR98zMFLx8=; b=N49p3AhqENOsKT9vgspdxEA0rL
        ufs17K9AAOlJFhgubUbNYgTsPED1FGiSu7wammq62NSOV61Gq6dVtvIyphdlTis2IONsxYAYa3ims
        hT1yqE520yJHow48qL12GQXa2O8tdfFsm3t5GzyKy53qzHcysoUnWPDGmWRMRTW7tEtSsQyq63gpb
        0Y6wB/JNMmnugbT1D7moIz2YiqkPhfkI1pvgMVJ4/Ovq+p5jBijOZxmaRfjFXdjwXeMKSGpn12oeu
        8XfHkOCrShpr7ESXT7W56IygkC8o0ybA0xCvUMszLhyFddaSuxd5JzfauiKenAUwukRydvHmgs42N
        YBBxqdpw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lwOUZ-00BEEM-31; Thu, 24 Jun 2021 12:30:08 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lwOUf-005Seu-If; Thu, 24 Jun 2021 13:30:05 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v3 1/5] net: add header len parameter to tun_get_socket(), tap_get_socket()
Date:   Thu, 24 Jun 2021 13:30:01 +0100
Message-Id: <20210624123005.1301761-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

The vhost-net driver was making wild assumptions about the header length
of the underlying tun/tap socket. Then it was discarding packets if
the number of bytes it got from sock_recvmsg() didn't precisely match
its guess.

Fix it to get the correct information along with the socket itself.
As a side-effect, this means that tun_get_socket() won't work if the
tun file isn't actually connected to a device, since there's no 'tun'
yet in that case to get the information from.

On the receive side, where the tun device generates the virtio_net_hdr
but VIRITO_NET_F_MSG_RXBUF was negotiated and vhost-net needs to fill
in the 'num_buffers' field on top of the existing virtio_net_hdr, fix
that to use 'sock_hlen - 2' as the location, which means that it goes
in the right place regardless of whether the tun device is using an
additional tun_pi header or not. In this case, the user should have
configured the tun device with a vnet hdr size of 12, to make room.

Fixes: 8dd014adfea6f ("vhost-net: mergeable buffers support")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 drivers/net/tap.c      |  5 ++++-
 drivers/net/tun.c      | 16 +++++++++++++++-
 drivers/vhost/net.c    | 31 +++++++++++++++----------------
 include/linux/if_tap.h |  4 ++--
 include/linux/if_tun.h |  4 ++--
 5 files changed, 38 insertions(+), 22 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 8e3a28ba6b28..2170a0d3d34c 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1246,7 +1246,7 @@ static const struct proto_ops tap_socket_ops = {
  * attached to a device.  The returned object works like a packet socket, it
  * can be used for sock_sendmsg/sock_recvmsg.  The caller is responsible for
  * holding a reference to the file for as long as the socket is in use. */
-struct socket *tap_get_socket(struct file *file)
+struct socket *tap_get_socket(struct file *file, size_t *hlen)
 {
 	struct tap_queue *q;
 	if (file->f_op != &tap_fops)
@@ -1254,6 +1254,9 @@ struct socket *tap_get_socket(struct file *file)
 	q = file->private_data;
 	if (!q)
 		return ERR_PTR(-EBADFD);
+	if (hlen)
+		*hlen = (q->flags & IFF_VNET_HDR) ? q->vnet_hdr_sz : 0;
+
 	return &q->sock;
 }
 EXPORT_SYMBOL_GPL(tap_get_socket);
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 4cf38be26dc9..67b406fa0881 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3649,7 +3649,7 @@ static void tun_cleanup(void)
  * attached to a device.  The returned object works like a packet socket, it
  * can be used for sock_sendmsg/sock_recvmsg.  The caller is responsible for
  * holding a reference to the file for as long as the socket is in use. */
-struct socket *tun_get_socket(struct file *file)
+struct socket *tun_get_socket(struct file *file, size_t *hlen)
 {
 	struct tun_file *tfile;
 	if (file->f_op != &tun_fops)
@@ -3657,6 +3657,20 @@ struct socket *tun_get_socket(struct file *file)
 	tfile = file->private_data;
 	if (!tfile)
 		return ERR_PTR(-EBADFD);
+
+	if (hlen) {
+		struct tun_struct *tun = tun_get(tfile);
+		size_t len = 0;
+
+		if (!tun)
+			return ERR_PTR(-ENOTCONN);
+		if (tun->flags & IFF_VNET_HDR)
+			len += READ_ONCE(tun->vnet_hdr_sz);
+		if (!(tun->flags & IFF_NO_PI))
+			len += sizeof(struct tun_pi);
+		tun_put(tun);
+		*hlen = len;
+	}
 	return &tfile->socket;
 }
 EXPORT_SYMBOL_GPL(tun_get_socket);
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index df82b124170e..b92a7144ed90 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1143,7 +1143,8 @@ static void handle_rx(struct vhost_net *net)
 
 	vq_log = unlikely(vhost_has_feature(vq, VHOST_F_LOG_ALL)) ?
 		vq->log : NULL;
-	mergeable = vhost_has_feature(vq, VIRTIO_NET_F_MRG_RXBUF);
+	mergeable = vhost_has_feature(vq, VIRTIO_NET_F_MRG_RXBUF) &&
+		(vhost_hlen || sock_hlen >= sizeof(num_buffers));
 
 	do {
 		sock_len = vhost_net_rx_peek_head_len(net, sock->sk,
@@ -1213,9 +1214,10 @@ static void handle_rx(struct vhost_net *net)
 			}
 		} else {
 			/* Header came from socket; we'll need to patch
-			 * ->num_buffers over if VIRTIO_NET_F_MRG_RXBUF
+			 * ->num_buffers over the last two bytes if
+			 * VIRTIO_NET_F_MRG_RXBUF is enabled.
 			 */
-			iov_iter_advance(&fixup, sizeof(hdr));
+			iov_iter_advance(&fixup, sock_hlen - 2);
 		}
 		/* TODO: Should check and handle checksum. */
 
@@ -1420,7 +1422,7 @@ static int vhost_net_release(struct inode *inode, struct file *f)
 	return 0;
 }
 
-static struct socket *get_raw_socket(int fd)
+static struct socket *get_raw_socket(int fd, size_t *hlen)
 {
 	int r;
 	struct socket *sock = sockfd_lookup(fd, &r);
@@ -1438,6 +1440,7 @@ static struct socket *get_raw_socket(int fd)
 		r = -EPFNOSUPPORT;
 		goto err;
 	}
+	*hlen = 0;
 	return sock;
 err:
 	sockfd_put(sock);
@@ -1463,33 +1466,33 @@ static struct ptr_ring *get_tap_ptr_ring(int fd)
 	return ring;
 }
 
-static struct socket *get_tap_socket(int fd)
+static struct socket *get_tap_socket(int fd, size_t *hlen)
 {
 	struct file *file = fget(fd);
 	struct socket *sock;
 
 	if (!file)
 		return ERR_PTR(-EBADF);
-	sock = tun_get_socket(file);
+	sock = tun_get_socket(file, hlen);
 	if (!IS_ERR(sock))
 		return sock;
-	sock = tap_get_socket(file);
+	sock = tap_get_socket(file, hlen);
 	if (IS_ERR(sock))
 		fput(file);
 	return sock;
 }
 
-static struct socket *get_socket(int fd)
+static struct socket *get_socket(int fd, size_t *hlen)
 {
 	struct socket *sock;
 
 	/* special case to disable backend */
 	if (fd == -1)
 		return NULL;
-	sock = get_raw_socket(fd);
+	sock = get_raw_socket(fd, hlen);
 	if (!IS_ERR(sock))
 		return sock;
-	sock = get_tap_socket(fd);
+	sock = get_tap_socket(fd, hlen);
 	if (!IS_ERR(sock))
 		return sock;
 	return ERR_PTR(-ENOTSOCK);
@@ -1521,7 +1524,7 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 		r = -EFAULT;
 		goto err_vq;
 	}
-	sock = get_socket(fd);
+	sock = get_socket(fd, &nvq->sock_hlen);
 	if (IS_ERR(sock)) {
 		r = PTR_ERR(sock);
 		goto err_vq;
@@ -1621,7 +1624,7 @@ static long vhost_net_reset_owner(struct vhost_net *n)
 
 static int vhost_net_set_features(struct vhost_net *n, u64 features)
 {
-	size_t vhost_hlen, sock_hlen, hdr_len;
+	size_t vhost_hlen, hdr_len;
 	int i;
 
 	hdr_len = (features & ((1ULL << VIRTIO_NET_F_MRG_RXBUF) |
@@ -1631,11 +1634,8 @@ static int vhost_net_set_features(struct vhost_net *n, u64 features)
 	if (features & (1 << VHOST_NET_F_VIRTIO_NET_HDR)) {
 		/* vhost provides vnet_hdr */
 		vhost_hlen = hdr_len;
-		sock_hlen = 0;
 	} else {
-		/* socket provides vnet_hdr */
 		vhost_hlen = 0;
-		sock_hlen = hdr_len;
 	}
 	mutex_lock(&n->dev.mutex);
 	if ((features & (1 << VHOST_F_LOG_ALL)) &&
@@ -1651,7 +1651,6 @@ static int vhost_net_set_features(struct vhost_net *n, u64 features)
 		mutex_lock(&n->vqs[i].vq.mutex);
 		n->vqs[i].vq.acked_features = features;
 		n->vqs[i].vhost_hlen = vhost_hlen;
-		n->vqs[i].sock_hlen = sock_hlen;
 		mutex_unlock(&n->vqs[i].vq.mutex);
 	}
 	mutex_unlock(&n->dev.mutex);
diff --git a/include/linux/if_tap.h b/include/linux/if_tap.h
index 915a187cfabd..b460ba98f34e 100644
--- a/include/linux/if_tap.h
+++ b/include/linux/if_tap.h
@@ -3,14 +3,14 @@
 #define _LINUX_IF_TAP_H_
 
 #if IS_ENABLED(CONFIG_TAP)
-struct socket *tap_get_socket(struct file *);
+struct socket *tap_get_socket(struct file *, size_t *);
 struct ptr_ring *tap_get_ptr_ring(struct file *file);
 #else
 #include <linux/err.h>
 #include <linux/errno.h>
 struct file;
 struct socket;
-static inline struct socket *tap_get_socket(struct file *f)
+static inline struct socket *tap_get_socket(struct file *f, size_t *)
 {
 	return ERR_PTR(-EINVAL);
 }
diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
index 2a7660843444..8a7debd3f663 100644
--- a/include/linux/if_tun.h
+++ b/include/linux/if_tun.h
@@ -25,7 +25,7 @@ struct tun_xdp_hdr {
 };
 
 #if defined(CONFIG_TUN) || defined(CONFIG_TUN_MODULE)
-struct socket *tun_get_socket(struct file *);
+struct socket *tun_get_socket(struct file *, size_t *);
 struct ptr_ring *tun_get_tx_ring(struct file *file);
 static inline bool tun_is_xdp_frame(void *ptr)
 {
@@ -45,7 +45,7 @@ void tun_ptr_free(void *ptr);
 #include <linux/errno.h>
 struct file;
 struct socket;
-static inline struct socket *tun_get_socket(struct file *f)
+static inline struct socket *tun_get_socket(struct file *f, size_t *)
 {
 	return ERR_PTR(-EINVAL);
 }
-- 
2.31.1

