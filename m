Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C813B23B1
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 00:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhFWWzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 18:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhFWWzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 18:55:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F9DC061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 15:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Mime-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EVXpPMjHVS7qY/e7qYbxEPK4DHS7dM3hXGcFn4OFYBw=; b=heBPm3a7i6OEVszGUHahgfu580
        iNoBxPrqHmryDSA24DgJIITW6ifi++X7a/o/6Z0SgWLFQTNzjqMz3G1957mOJqmacD638PvO5G6VL
        Ce24sRKhueXU4LedPdoLxn7KMepR0sP4h2CKrEqcCq/0D9RFQ1s+r2Pv+f0puxYGO5KRxNdUkfxfW
        0na032xDearWjtLoijLVVSqDd+oGv7L7kTNJDUbhQogB5hCBcnxaSdLDFB1xCunHfy7j8Pb7dQKLT
        9ysErVcwNx2hT/z80PwmSkZ7w4qgNZLjOtxrDdxfQ8ceagYZn/b+JBa56m0yCub/j19rstoQY4IDu
        eV3fDjMA==;
Received: from [2001:8b0:10b:1::3ae] (helo=u3832b3a9db3152.ant.amazon.com)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lwBjc-00C8u0-ID; Wed, 23 Jun 2021 22:52:41 +0000
Message-ID: <e61c84062230d3454c0a6539ed372b84449d9572.camel@infradead.org>
Subject: Re: [PATCH v2 1/4] net: tun: fix tun_xdp_one() for IFF_TUN mode
From:   David Woodhouse <dwmw2@infradead.org>
To:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org
Cc:     Eugenio =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Date:   Wed, 23 Jun 2021 23:52:38 +0100
In-Reply-To: <f2e6498d310454e9c884f3f8470477e0cc527b58.camel@infradead.org>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
         <20210622161533.1214662-1-dwmw2@infradead.org>
         <fedca272-a03e-4bac-4038-2bb1f6b4df84@redhat.com>
         <e8843f32aa14baff398584e5b3a00d20994836b6.camel@infradead.org>
         <f2e6498d310454e9c884f3f8470477e0cc527b58.camel@infradead.org>
Content-Type: multipart/signed; micalg="sha-256";
        protocol="application/x-pkcs7-signature";
        boundary="=-WO7HAbpMkFJhkll1GffJ"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-WO7HAbpMkFJhkll1GffJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-06-23 at 18:31 +0100, David Woodhouse wrote:
>=20
> Joy... that's wrong because when tun does both the PI and the vnet
> headers, the PI header comes *first*. When tun does only PI and vhost
> does the vnet headers, they come in the other order.
>=20
> Will fix (and adjust the test cases to cope).


I got this far, pushed to
https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/vhost-n=
et

All the test cases are now passing. I don't guarantee I haven't
actually broken qemu and IFF_TAP mode though, mind you :)

I'll need to refactor the intermediate commits a little so I won't
repost the series quite yet, but figured I should at least show what I
have for comments, as my day ends and yours begins.


As discussed, I expanded tun_get_socket()/tap_get_socket() to return
the actual header length instead of letting vhost make wild guesses.
Note that in doing so, I have made tun_get_socket() return -ENOTCONN if
the tun fd *isn't* actually attached (TUNSETIFF) to a real device yet.

I moved the sanity check back to tun/tap instead of doing it in
vhost_net_build_xdp(), because the latter has no clue about the tun PI
header and doesn't know *where* the virtio header is.


diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 8e3a28ba6b28..d1b1f1de374e 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1132,16 +1132,35 @@ static const struct file_operations tap_fops =3D {
 static int tap_get_user_xdp(struct tap_queue *q, struct xdp_buff *xdp)
 {
 	struct tun_xdp_hdr *hdr =3D xdp->data_hard_start;
-	struct virtio_net_hdr *gso =3D &hdr->gso;
+	struct virtio_net_hdr *gso =3D NULL;
 	int buflen =3D hdr->buflen;
 	int vnet_hdr_len =3D 0;
 	struct tap_dev *tap;
 	struct sk_buff *skb;
 	int err, depth;
=20
-	if (q->flags & IFF_VNET_HDR)
+	if (q->flags & IFF_VNET_HDR) {
 		vnet_hdr_len =3D READ_ONCE(q->vnet_hdr_sz);
+		if (xdp->data !=3D xdp->data_hard_start + sizeof(*hdr) + vnet_hdr_len) {
+			err =3D -EINVAL;
+			goto err;
+		}
+
+		gso =3D (void *)&hdr[1];
+
+		if ((gso->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
+		     tap16_to_cpu(q, gso->csum_start) +
+		     tap16_to_cpu(q, gso->csum_offset) + 2 >
+			     tap16_to_cpu(q, gso->hdr_len))
+			gso->hdr_len =3D cpu_to_tap16(q,
+				 tap16_to_cpu(q, gso->csum_start) +
+				 tap16_to_cpu(q, gso->csum_offset) + 2);
=20
+		if (tap16_to_cpu(q, gso->hdr_len) > xdp->data_end - xdp->data) {
+			err =3D -EINVAL;
+			goto err;
+		}
+	}
 	skb =3D build_skb(xdp->data_hard_start, buflen);
 	if (!skb) {
 		err =3D -ENOMEM;
@@ -1155,7 +1174,7 @@ static int tap_get_user_xdp(struct tap_queue *q, stru=
ct xdp_buff *xdp)
 	skb_reset_mac_header(skb);
 	skb->protocol =3D eth_hdr(skb)->h_proto;
=20
-	if (vnet_hdr_len) {
+	if (gso) {
 		err =3D virtio_net_hdr_to_skb(skb, gso, tap_is_little_endian(q));
 		if (err)
 			goto err_kfree;
@@ -1246,7 +1265,7 @@ static const struct proto_ops tap_socket_ops =3D {
  * attached to a device.  The returned object works like a packet socket, =
it
  * can be used for sock_sendmsg/sock_recvmsg.  The caller is responsible f=
or
  * holding a reference to the file for as long as the socket is in use. */
-struct socket *tap_get_socket(struct file *file)
+struct socket *tap_get_socket(struct file *file, size_t *hlen)
 {
 	struct tap_queue *q;
 	if (file->f_op !=3D &tap_fops)
@@ -1254,6 +1273,9 @@ struct socket *tap_get_socket(struct file *file)
 	q =3D file->private_data;
 	if (!q)
 		return ERR_PTR(-EBADFD);
+	if (hlen)
+		*hlen =3D (q->flags & IFF_VNET_HDR) ? q->vnet_hdr_sz : 0;
+
 	return &q->sock;
 }
 EXPORT_SYMBOL_GPL(tap_get_socket);
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 4cf38be26dc9..72f8a04f493b 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1641,6 +1641,40 @@ static struct sk_buff *tun_build_skb(struct tun_stru=
ct *tun,
 	return NULL;
 }
=20
+static int tun_skb_set_protocol(struct tun_struct *tun, struct sk_buff *sk=
b,
+				__be16 pi_proto)
+{
+	switch (tun->flags & TUN_TYPE_MASK) {
+	case IFF_TUN:
+		if (tun->flags & IFF_NO_PI) {
+			u8 ip_version =3D skb->len ? (skb->data[0] >> 4) : 0;
+
+			switch (ip_version) {
+			case 4:
+				pi_proto =3D htons(ETH_P_IP);
+				break;
+			case 6:
+				pi_proto =3D htons(ETH_P_IPV6);
+				break;
+			default:
+				return -EINVAL;
+			}
+		}
+
+		skb_reset_mac_header(skb);
+		skb->protocol =3D pi_proto;
+		skb->dev =3D tun->dev;
+		break;
+	case IFF_TAP:
+		if (/* frags && */!pskb_may_pull(skb, ETH_HLEN))
+			return -ENOMEM;
+
+		skb->protocol =3D eth_type_trans(skb, tun->dev);
+		break;
+	}
+	return 0;
+}
+
 /* Get packet from user space buffer */
 static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile=
,
 			    void *msg_control, struct iov_iter *from,
@@ -1784,37 +1818,9 @@ static ssize_t tun_get_user(struct tun_struct *tun, =
struct tun_file *tfile,
 		return -EINVAL;
 	}
=20
-	switch (tun->flags & TUN_TYPE_MASK) {
-	case IFF_TUN:
-		if (tun->flags & IFF_NO_PI) {
-			u8 ip_version =3D skb->len ? (skb->data[0] >> 4) : 0;
-
-			switch (ip_version) {
-			case 4:
-				pi.proto =3D htons(ETH_P_IP);
-				break;
-			case 6:
-				pi.proto =3D htons(ETH_P_IPV6);
-				break;
-			default:
-				atomic_long_inc(&tun->dev->rx_dropped);
-				kfree_skb(skb);
-				return -EINVAL;
-			}
-		}
-
-		skb_reset_mac_header(skb);
-		skb->protocol =3D pi.proto;
-		skb->dev =3D tun->dev;
-		break;
-	case IFF_TAP:
-		if (frags && !pskb_may_pull(skb, ETH_HLEN)) {
-			err =3D -ENOMEM;
-			goto drop;
-		}
-		skb->protocol =3D eth_type_trans(skb, tun->dev);
-		break;
-	}
+	err =3D tun_skb_set_protocol(tun, skb, pi.proto);
+	if (err)
+		goto drop;
=20
 	/* copy skb_ubuf_info for callback when skb has no error */
 	if (zerocopy) {
@@ -2331,18 +2337,48 @@ static int tun_xdp_one(struct tun_struct *tun,
 {
 	unsigned int datasize =3D xdp->data_end - xdp->data;
 	struct tun_xdp_hdr *hdr =3D xdp->data_hard_start;
-	struct virtio_net_hdr *gso =3D &hdr->gso;
+	void *tun_hdr =3D &hdr[1];
+	struct virtio_net_hdr *gso =3D NULL;
 	struct bpf_prog *xdp_prog;
 	struct sk_buff *skb =3D NULL;
+	__be16 proto =3D 0;
 	u32 rxhash =3D 0, act;
 	int buflen =3D hdr->buflen;
 	int err =3D 0;
 	bool skb_xdp =3D false;
 	struct page *page;
=20
+	if (!(tun->flags & IFF_NO_PI)) {
+		struct tun_pi *pi =3D tun_hdr;
+		tun_hdr +=3D sizeof(*pi);
+
+		if (tun_hdr > xdp->data) {
+			atomic_long_inc(&tun->rx_frame_errors);
+			return -EINVAL;
+		}
+		proto =3D pi->proto;
+	}
+
+	if (tun->flags & IFF_VNET_HDR) {
+		gso =3D tun_hdr;
+		tun_hdr +=3D sizeof(*gso);
+
+		if (tun_hdr > xdp->data) {
+			atomic_long_inc(&tun->rx_frame_errors);
+			return -EINVAL;
+		}
+
+		if ((gso->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
+		    tun16_to_cpu(tun, gso->csum_start) + tun16_to_cpu(tun, gso->csum_off=
set) + 2 > tun16_to_cpu(tun, gso->hdr_len))
+			gso->hdr_len =3D cpu_to_tun16(tun, tun16_to_cpu(tun, gso->csum_start) +=
 tun16_to_cpu(tun, gso->csum_offset) + 2);
+
+		if (tun16_to_cpu(tun, gso->hdr_len) > datasize)
+			return -EINVAL;
+	}
+
 	xdp_prog =3D rcu_dereference(tun->xdp_prog);
 	if (xdp_prog) {
-		if (gso->gso_type) {
+		if (gso && gso->gso_type) {
 			skb_xdp =3D true;
 			goto build;
 		}
@@ -2386,16 +2422,22 @@ static int tun_xdp_one(struct tun_struct *tun,
 	}
=20
 	skb_reserve(skb, xdp->data - xdp->data_hard_start);
-	skb_put(skb, xdp->data_end - xdp->data);
+	skb_put(skb, datasize);
=20
-	if (virtio_net_hdr_to_skb(skb, gso, tun_is_little_endian(tun))) {
+	if (gso && virtio_net_hdr_to_skb(skb, gso, tun_is_little_endian(tun))) {
 		atomic_long_inc(&tun->rx_frame_errors);
 		kfree_skb(skb);
 		err =3D -EINVAL;
 		goto out;
 	}
=20
-	skb->protocol =3D eth_type_trans(skb, tun->dev);
+	err =3D tun_skb_set_protocol(tun, skb, proto);
+	if (err) {
+		atomic_long_inc(&tun->dev->rx_dropped);
+		kfree_skb(skb);
+		goto out;
+	}
+
 	skb_reset_network_header(skb);
 	skb_probe_transport_header(skb);
 	skb_record_rx_queue(skb, tfile->queue_index);
@@ -3649,7 +3691,7 @@ static void tun_cleanup(void)
  * attached to a device.  The returned object works like a packet socket, =
it
  * can be used for sock_sendmsg/sock_recvmsg.  The caller is responsible f=
or
  * holding a reference to the file for as long as the socket is in use. */
-struct socket *tun_get_socket(struct file *file)
+struct socket *tun_get_socket(struct file *file, size_t *hlen)
 {
 	struct tun_file *tfile;
 	if (file->f_op !=3D &tun_fops)
@@ -3657,6 +3699,20 @@ struct socket *tun_get_socket(struct file *file)
 	tfile =3D file->private_data;
 	if (!tfile)
 		return ERR_PTR(-EBADFD);
+
+	if (hlen) {
+		struct tun_struct *tun =3D tun_get(tfile);
+		size_t len =3D 0;
+
+		if (!tun)
+			return ERR_PTR(-ENOTCONN);
+		if (tun->flags & IFF_VNET_HDR)
+			len +=3D READ_ONCE(tun->vnet_hdr_sz);
+		if (!(tun->flags & IFF_NO_PI))
+			len +=3D sizeof(struct tun_pi);
+		tun_put(tun);
+		*hlen =3D len;
+	}
 	return &tfile->socket;
 }
 EXPORT_SYMBOL_GPL(tun_get_socket);
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index df82b124170e..d9491c620a9c 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -690,7 +690,6 @@ static int vhost_net_build_xdp(struct vhost_net_virtque=
ue *nvq,
 					     dev);
 	struct socket *sock =3D vhost_vq_get_backend(vq);
 	struct page_frag *alloc_frag =3D &net->page_frag;
-	struct virtio_net_hdr *gso;
 	struct xdp_buff *xdp =3D &nvq->xdp[nvq->batched_xdp];
 	struct tun_xdp_hdr *hdr;
 	size_t len =3D iov_iter_count(from);
@@ -715,29 +714,18 @@ static int vhost_net_build_xdp(struct vhost_net_virtq=
ueue *nvq,
 		return -ENOMEM;
=20
 	buf =3D (char *)page_address(alloc_frag->page) + alloc_frag->offset;
-	copied =3D copy_page_from_iter(alloc_frag->page,
-				     alloc_frag->offset +
-				     offsetof(struct tun_xdp_hdr, gso),
-				     sock_hlen, from);
-	if (copied !=3D sock_hlen)
-		return -EFAULT;
-
 	hdr =3D buf;
-	gso =3D &hdr->gso;
-
-	if ((gso->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
-	    vhost16_to_cpu(vq, gso->csum_start) +
-	    vhost16_to_cpu(vq, gso->csum_offset) + 2 >
-	    vhost16_to_cpu(vq, gso->hdr_len)) {
-		gso->hdr_len =3D cpu_to_vhost16(vq,
-			       vhost16_to_cpu(vq, gso->csum_start) +
-			       vhost16_to_cpu(vq, gso->csum_offset) + 2);
-
-		if (vhost16_to_cpu(vq, gso->hdr_len) > len)
-			return -EINVAL;
+	if (sock_hlen) {
+		copied =3D copy_page_from_iter(alloc_frag->page,
+					     alloc_frag->offset +
+					     sizeof(struct tun_xdp_hdr),
+					     sock_hlen, from);
+		if (copied !=3D sock_hlen)
+			return -EFAULT;
+
+		len -=3D sock_hlen;
 	}
=20
-	len -=3D sock_hlen;
 	copied =3D copy_page_from_iter(alloc_frag->page,
 				     alloc_frag->offset + pad,
 				     len, from);
@@ -1420,7 +1408,7 @@ static int vhost_net_release(struct inode *inode, str=
uct file *f)
 	return 0;
 }
=20
-static struct socket *get_raw_socket(int fd)
+static struct socket *get_raw_socket(int fd, size_t *hlen)
 {
 	int r;
 	struct socket *sock =3D sockfd_lookup(fd, &r);
@@ -1438,6 +1426,7 @@ static struct socket *get_raw_socket(int fd)
 		r =3D -EPFNOSUPPORT;
 		goto err;
 	}
+	*hlen =3D 0;
 	return sock;
 err:
 	sockfd_put(sock);
@@ -1463,33 +1452,33 @@ static struct ptr_ring *get_tap_ptr_ring(int fd)
 	return ring;
 }
=20
-static struct socket *get_tap_socket(int fd)
+static struct socket *get_tap_socket(int fd, size_t *hlen)
 {
 	struct file *file =3D fget(fd);
 	struct socket *sock;
=20
 	if (!file)
 		return ERR_PTR(-EBADF);
-	sock =3D tun_get_socket(file);
+	sock =3D tun_get_socket(file, hlen);
 	if (!IS_ERR(sock))
 		return sock;
-	sock =3D tap_get_socket(file);
+	sock =3D tap_get_socket(file, hlen);
 	if (IS_ERR(sock))
 		fput(file);
 	return sock;
 }
=20
-static struct socket *get_socket(int fd)
+static struct socket *get_socket(int fd, size_t *hlen)
 {
 	struct socket *sock;
=20
 	/* special case to disable backend */
 	if (fd =3D=3D -1)
 		return NULL;
-	sock =3D get_raw_socket(fd);
+	sock =3D get_raw_socket(fd, hlen);
 	if (!IS_ERR(sock))
 		return sock;
-	sock =3D get_tap_socket(fd);
+	sock =3D get_tap_socket(fd, hlen);
 	if (!IS_ERR(sock))
 		return sock;
 	return ERR_PTR(-ENOTSOCK);
@@ -1521,7 +1510,7 @@ static long vhost_net_set_backend(struct vhost_net *n=
, unsigned index, int fd)
 		r =3D -EFAULT;
 		goto err_vq;
 	}
-	sock =3D get_socket(fd);
+	sock =3D get_socket(fd, &nvq->sock_hlen);
 	if (IS_ERR(sock)) {
 		r =3D PTR_ERR(sock);
 		goto err_vq;
@@ -1621,7 +1610,7 @@ static long vhost_net_reset_owner(struct vhost_net *n=
)
=20
 static int vhost_net_set_features(struct vhost_net *n, u64 features)
 {
-	size_t vhost_hlen, sock_hlen, hdr_len;
+	size_t vhost_hlen, hdr_len;
 	int i;
=20
 	hdr_len =3D (features & ((1ULL << VIRTIO_NET_F_MRG_RXBUF) |
@@ -1631,11 +1620,8 @@ static int vhost_net_set_features(struct vhost_net *=
n, u64 features)
 	if (features & (1 << VHOST_NET_F_VIRTIO_NET_HDR)) {
 		/* vhost provides vnet_hdr */
 		vhost_hlen =3D hdr_len;
-		sock_hlen =3D 0;
 	} else {
-		/* socket provides vnet_hdr */
 		vhost_hlen =3D 0;
-		sock_hlen =3D hdr_len;
 	}
 	mutex_lock(&n->dev.mutex);
 	if ((features & (1 << VHOST_F_LOG_ALL)) &&
@@ -1651,7 +1637,6 @@ static int vhost_net_set_features(struct vhost_net *n=
, u64 features)
 		mutex_lock(&n->vqs[i].vq.mutex);
 		n->vqs[i].vq.acked_features =3D features;
 		n->vqs[i].vhost_hlen =3D vhost_hlen;
-		n->vqs[i].sock_hlen =3D sock_hlen;
 		mutex_unlock(&n->vqs[i].vq.mutex);
 	}
 	mutex_unlock(&n->dev.mutex);
diff --git a/include/linux/if_tap.h b/include/linux/if_tap.h
index 915a187cfabd..b460ba98f34e 100644
--- a/include/linux/if_tap.h
+++ b/include/linux/if_tap.h
@@ -3,14 +3,14 @@
 #define _LINUX_IF_TAP_H_
=20
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
index 2a7660843444..8d78b6bbc228 100644
--- a/include/linux/if_tun.h
+++ b/include/linux/if_tun.h
@@ -21,11 +21,10 @@ struct tun_msg_ctl {
=20
 struct tun_xdp_hdr {
 	int buflen;
-	struct virtio_net_hdr gso;
 };
=20
 #if defined(CONFIG_TUN) || defined(CONFIG_TUN_MODULE)
-struct socket *tun_get_socket(struct file *);
+struct socket *tun_get_socket(struct file *, size_t *);
 struct ptr_ring *tun_get_tx_ring(struct file *file);
 static inline bool tun_is_xdp_frame(void *ptr)
 {
@@ -45,7 +44,7 @@ void tun_ptr_free(void *ptr);
 #include <linux/errno.h>
 struct file;
 struct socket;
-static inline struct socket *tun_get_socket(struct file *f)
+static inline struct socket *tun_get_socket(struct file *f, size_t *)
 {
 	return ERR_PTR(-EINVAL);
 }
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Mak=
efile
index 6c575cf34a71..300c03cfd0c7 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -71,6 +71,7 @@ TARGETS +=3D user
 TARGETS +=3D vDSO
 TARGETS +=3D vm
 TARGETS +=3D x86
+TARGETS +=3D vhost
 TARGETS +=3D zram
 #Please keep the TARGETS list alphabetically sorted
 # Run "make quicktest=3D1 run_tests" or
diff --git a/tools/testing/selftests/vhost/Makefile b/tools/testing/selftes=
ts/vhost/Makefile
new file mode 100644
index 000000000000..f5e565d80733
--- /dev/null
+++ b/tools/testing/selftests/vhost/Makefile
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0
+all:
+
+include ../lib.mk
+
+.PHONY: all clean
+
+BINARIES :=3D test_vhost_net
+
+test_vhost_net: test_vhost_net.c ../kselftest.h ../kselftest_harness.h
+	$(CC) $(CFLAGS) -g $< -o $@
+
+TEST_PROGS +=3D $(BINARIES)
+EXTRA_CLEAN :=3D $(BINARIES)
+
+all: $(BINARIES)
diff --git a/tools/testing/selftests/vhost/config b/tools/testing/selftests=
/vhost/config
new file mode 100644
index 000000000000..6391c1f32c34
--- /dev/null
+++ b/tools/testing/selftests/vhost/config
@@ -0,0 +1,2 @@
+CONFIG_VHOST_NET=3Dy
+CONFIG_TUN=3Dy
diff --git a/tools/testing/selftests/vhost/test_vhost_net.c b/tools/testing=
/selftests/vhost/test_vhost_net.c
new file mode 100644
index 000000000000..747f0e5e4f57
--- /dev/null
+++ b/tools/testing/selftests/vhost/test_vhost_net.c
@@ -0,0 +1,530 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+#include "../kselftest_harness.h"
+#include "../../../virtio/asm/barrier.h"
+
+#include <sys/eventfd.h>
+
+#include <sys/types.h>
+#include <sys/stat.h>
+
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/wait.h>
+#include <sys/ioctl.h>
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+
+#include <net/if.h>
+#include <sys/socket.h>
+
+#include <netinet/tcp.h>
+#include <netinet/ip.h>
+#include <netinet/ip_icmp.h>
+#include <netinet/ip6.h>
+#include <netinet/icmp6.h>
+
+#include <linux/if_tun.h>
+#include <linux/virtio_net.h>
+#include <linux/vhost.h>
+
+static unsigned char hexnybble(char hex)
+{
+	switch (hex) {
+	case '0'...'9':
+		return hex - '0';
+	case 'a'...'f':
+		return 10 + hex - 'a';
+	case 'A'...'F':
+		return 10 + hex - 'A';
+	default:
+		exit (KSFT_SKIP);
+	}
+}
+
+static unsigned char hexchar(char *hex)
+{
+	return (hexnybble(hex[0]) << 4) | hexnybble(hex[1]);
+}
+
+int open_tun(int vnet_hdr_sz, int pi, struct in6_addr *addr)
+{
+	int tun_fd =3D open("/dev/net/tun", O_RDWR);
+	if (tun_fd =3D=3D -1)
+		return -1;
+
+	struct ifreq ifr =3D { 0 };
+
+	ifr.ifr_flags =3D IFF_TUN;
+	if (!pi)
+		ifr.ifr_flags |=3D IFF_NO_PI;
+	if (vnet_hdr_sz)
+		ifr.ifr_flags |=3D IFF_VNET_HDR;
+
+	if (ioctl(tun_fd, TUNSETIFF, (void *)&ifr) < 0)
+		goto out_tun;
+
+	if (vnet_hdr_sz &&
+	    ioctl(tun_fd, TUNSETVNETHDRSZ, &vnet_hdr_sz) < 0)
+		goto out_tun;
+
+	int sockfd =3D socket(AF_INET6, SOCK_DGRAM, IPPROTO_IP);
+	if (sockfd =3D=3D -1)
+		goto out_tun;
+
+	if (ioctl(sockfd, SIOCGIFFLAGS, (void *)&ifr) < 0)
+		goto out_sock;
+
+	ifr.ifr_flags |=3D IFF_UP;
+	if (ioctl(sockfd, SIOCSIFFLAGS, (void *)&ifr) < 0)
+		goto out_sock;
+
+	close(sockfd);
+
+	FILE *inet6 =3D fopen("/proc/net/if_inet6", "r");
+	if (!inet6)
+		goto out_tun;
+
+	char buf[80];
+	while (fgets(buf, sizeof(buf), inet6)) {
+		size_t len =3D strlen(buf), namelen =3D strlen(ifr.ifr_name);
+		if (!strncmp(buf, "fe80", 4) &&
+		    buf[len - namelen - 2] =3D=3D ' ' &&
+		    !strncmp(buf + len - namelen - 1, ifr.ifr_name, namelen)) {
+			for (int i =3D 0; i < 16; i++) {
+				addr->s6_addr[i] =3D hexchar(buf + i*2);
+			}
+			fclose(inet6);
+			return tun_fd;
+		}
+	}
+	/* Not found */
+	fclose(inet6);
+ out_sock:
+	close(sockfd);
+ out_tun:
+	close(tun_fd);
+	return -1;
+}
+
+#define RING_SIZE 32
+#define RING_MASK(x) ((x) & (RING_SIZE-1))
+
+struct pkt_buf {
+	unsigned char data[2048];
+};
+
+struct test_vring {
+	struct vring_desc desc[RING_SIZE];
+	struct vring_avail avail;
+	__virtio16 avail_ring[RING_SIZE];
+	struct vring_used used;
+	struct vring_used_elem used_ring[RING_SIZE];
+	struct pkt_buf pkts[RING_SIZE];
+} rings[2];
+
+static int setup_vring(int vhost_fd, int tun_fd, int call_fd, int kick_fd,=
 int idx)
+{
+	struct test_vring *vring =3D &rings[idx];
+	int ret;
+
+	memset(vring, 0, sizeof(vring));
+
+	struct vhost_vring_state vs =3D { };
+	vs.index =3D idx;
+	vs.num =3D RING_SIZE;
+	if (ioctl(vhost_fd, VHOST_SET_VRING_NUM, &vs) < 0) {
+		perror("VHOST_SET_VRING_NUM");
+		return -1;
+	}
+
+	vs.num =3D 0;
+	if (ioctl(vhost_fd, VHOST_SET_VRING_BASE, &vs) < 0) {
+		perror("VHOST_SET_VRING_BASE");
+		return -1;
+	}
+
+	struct vhost_vring_addr va =3D { };
+	va.index =3D idx;
+	va.desc_user_addr =3D (uint64_t)vring->desc;
+	va.avail_user_addr =3D (uint64_t)&vring->avail;
+	va.used_user_addr  =3D (uint64_t)&vring->used;
+	if (ioctl(vhost_fd, VHOST_SET_VRING_ADDR, &va) < 0) {
+		perror("VHOST_SET_VRING_ADDR");
+		return -1;
+	}
+
+	struct vhost_vring_file vf =3D { };
+	vf.index =3D idx;
+	vf.fd =3D tun_fd;
+	if (ioctl(vhost_fd, VHOST_NET_SET_BACKEND, &vf) < 0) {
+		perror("VHOST_NET_SET_BACKEND");
+		return -1;
+	}
+
+	vf.fd =3D call_fd;
+	if (ioctl(vhost_fd, VHOST_SET_VRING_CALL, &vf) < 0) {
+		perror("VHOST_SET_VRING_CALL");
+		return -1;
+	}
+
+	vf.fd =3D kick_fd;
+	if (ioctl(vhost_fd, VHOST_SET_VRING_KICK, &vf) < 0) {
+		perror("VHOST_SET_VRING_KICK");
+		return -1;
+	}
+
+	return 0;
+}
+
+int setup_vhost(int vhost_fd, int tun_fd, int call_fd, int kick_fd, uint64=
_t want_features)
+{
+	int ret;
+
+	if (ioctl(vhost_fd, VHOST_SET_OWNER, NULL) < 0) {
+		perror("VHOST_SET_OWNER");
+		return -1;
+	}
+
+	uint64_t features;
+	if (ioctl(vhost_fd, VHOST_GET_FEATURES, &features) < 0) {
+		perror("VHOST_GET_FEATURES");
+		return -1;
+	}
+
+	if ((features & want_features) !=3D want_features)
+		return KSFT_SKIP;
+
+	if (ioctl(vhost_fd, VHOST_SET_FEATURES, &want_features) < 0) {
+		perror("VHOST_SET_FEATURES");
+		return -1;
+	}
+
+	struct vhost_memory *vmem =3D alloca(sizeof(*vmem) + sizeof(vmem->regions=
[0]));
+
+	memset(vmem, 0, sizeof(*vmem) + sizeof(vmem->regions[0]));
+	vmem->nregions =3D 1;
+	/*
+	 * I just want to map the *whole* of userspace address space. But
+	 * from userspace I don't know what that is. On x86_64 it would be:
+	 *
+	 * vmem->regions[0].guest_phys_addr =3D 4096;
+	 * vmem->regions[0].memory_size =3D 0x7fffffffe000;
+	 * vmem->regions[0].userspace_addr =3D 4096;
+	 *
+	 * For now, just ensure we put everything inside a single BSS region.
+	 */
+	vmem->regions[0].guest_phys_addr =3D (uint64_t)&rings;
+	vmem->regions[0].userspace_addr =3D (uint64_t)&rings;
+	vmem->regions[0].memory_size =3D sizeof(rings);
+
+	if (ioctl(vhost_fd, VHOST_SET_MEM_TABLE, vmem) < 0) {
+		perror("VHOST_SET_MEM_TABLE");
+		return -1;
+	}
+
+	if (setup_vring(vhost_fd, tun_fd, call_fd, kick_fd, 0))
+		return -1;
+
+	if (setup_vring(vhost_fd, tun_fd, call_fd, kick_fd, 1))
+		return -1;
+
+	return 0;
+}
+
+
+static char ping_payload[16] =3D "VHOST TEST PACKT";
+
+static inline uint32_t csum_partial(uint16_t *buf, int nwords)
+{
+	uint32_t sum =3D 0;
+	for(sum=3D0; nwords>0; nwords--)
+		sum +=3D ntohs(*buf++);
+	return sum;
+}
+
+static inline uint16_t csum_finish(uint32_t sum)
+{
+	sum =3D (sum >> 16) + (sum &0xffff);
+	sum +=3D (sum >> 16);
+	return htons((uint16_t)(~sum));
+}
+
+static int create_icmp_echo(unsigned char *data, struct in6_addr *dst,
+			    struct in6_addr *src, uint16_t id, uint16_t seq)
+{
+	const int icmplen =3D ICMP_MINLEN + sizeof(ping_payload);
+	const int plen =3D sizeof(struct ip6_hdr) + icmplen;
+	struct ip6_hdr *iph =3D (void *)data;
+	struct icmp6_hdr *icmph =3D (void *)(data + sizeof(*iph));
+
+	/* IPv6 Header */
+	iph->ip6_flow =3D htonl((6 << 28) + /* version 6 */
+			      (0 << 20) + /* traffic class */
+			      (0 << 0));  /* flow ID  */
+	iph->ip6_nxt =3D IPPROTO_ICMPV6;
+	iph->ip6_plen =3D htons(icmplen);
+	iph->ip6_hlim =3D 128;
+	iph->ip6_src =3D *src;
+	iph->ip6_dst =3D *dst;
+
+	/* ICMPv6 echo request */
+	icmph->icmp6_type =3D ICMP6_ECHO_REQUEST;
+	icmph->icmp6_code =3D 0;
+	icmph->icmp6_data16[0] =3D htons(id);	/* ID */
+	icmph->icmp6_data16[1] =3D htons(seq);	/* sequence */
+
+	/* Some arbitrary payload */
+	memcpy(&icmph[1], ping_payload, sizeof(ping_payload));
+
+	/*
+	 * IPv6 upper-layer checksums include a pseudo-header
+	 * for IPv6 which contains the source address, the
+	 * destination address, the upper-layer packet length
+	 * and next-header field. See RFC8200 =C2=A78.1. The
+	 * checksum is as follows:
+	 *
+	 *   checksum 32 bytes of real IPv6 header:
+	 *     src addr (16 bytes)
+	 *     dst addr (16 bytes)
+	 *   8 bytes more:
+	 *     length of ICMPv6 in bytes (be32)
+	 *     3 bytes of 0
+	 *     next header byte (IPPROTO_ICMPV6)
+	 *   Then the actual ICMPv6 bytes
+	 */
+	uint32_t sum =3D csum_partial((uint16_t *)&iph->ip6_src, 8);      /* 8 ui=
nt16_t */
+	sum +=3D csum_partial((uint16_t *)&iph->ip6_dst, 8);              /* 8 ui=
nt16_t */
+
+	/* The easiest way to checksum the following 8-byte
+	 * part of the pseudo-header without horridly violating
+	 * C type aliasing rules is *not* to build it in memory
+	 * at all. We know the length fits in 16 bits so the
+	 * partial checksum of 00 00 LL LL 00 00 00 NH ends up
+	 * being just LLLL + NH.
+	 */
+	sum +=3D IPPROTO_ICMPV6;
+	sum +=3D ICMP_MINLEN + sizeof(ping_payload);
+
+	sum +=3D csum_partial((uint16_t *)icmph, icmplen / 2);
+	icmph->icmp6_cksum =3D csum_finish(sum);
+	return plen;
+}
+
+
+static int check_icmp_response(unsigned char *data, uint32_t len,
+			       struct in6_addr *dst, struct in6_addr *src)
+{
+	struct ip6_hdr *iph =3D (void *)data;
+	return ( len >=3D 41 && (ntohl(iph->ip6_flow) >> 28)=3D=3D6 /* IPv6 heade=
r */
+		 && iph->ip6_nxt =3D=3D IPPROTO_ICMPV6 /* IPv6 next header field =3D ICM=
Pv6 */
+		 && !memcmp(&iph->ip6_src, src, 16) /* source =3D=3D magic address */
+		 && !memcmp(&iph->ip6_dst, dst, 16) /* source =3D=3D magic address */
+		 && len >=3D 40 + ICMP_MINLEN + sizeof(ping_payload) /* No short-packet =
segfaults */
+		 && data[40] =3D=3D ICMP6_ECHO_REPLY /* ICMPv6 reply */
+		 && !memcmp(&data[40 + ICMP_MINLEN], ping_payload, sizeof(ping_payload))=
 /* Same payload in response */
+		 );
+
+}
+
+#if __BYTE_ORDER__ =3D=3D __ORDER_LITTLE_ENDIAN__
+#define vio16(x) (x)
+#define vio32(x) (x)
+#define vio64(x) (x)
+#else
+#define vio16(x) __builtin_bswap16(x)
+#define vio32(x) __builtin_bswap32(x)
+#define vio64(x) __builtin_bswap64(x)
+#endif
+
+
+int test_vhost(int vnet_hdr_sz, int pi, int xdp, uint64_t features)
+{
+	int call_fd =3D eventfd(0, EFD_CLOEXEC|EFD_NONBLOCK);
+	int kick_fd =3D eventfd(0, EFD_CLOEXEC|EFD_NONBLOCK);
+	int vhost_fd =3D open("/dev/vhost-net", O_RDWR);
+	int tun_fd =3D -1;
+	int ret =3D KSFT_SKIP;
+
+	if (call_fd < 0 || kick_fd < 0 || vhost_fd < 0)
+		goto err;
+
+	memset(rings, 0, sizeof(rings));
+
+	/* Pick up the link-local address that the kernel
+	 * assigns to the tun device. */
+	struct in6_addr tun_addr;
+	tun_fd =3D open_tun(vnet_hdr_sz, pi, &tun_addr);
+	if (tun_fd < 0)
+		goto err;
+
+	int pi_offset =3D -1;
+	int data_offset =3D vnet_hdr_sz;
+
+	/* The tun device puts PI *first*, before the vnet hdr */
+	if (pi) {
+		pi_offset =3D 0;
+		data_offset +=3D sizeof(struct tun_pi);
+	};
+
+	/* If vhost is going a vnet hdr it comes before all else */
+	if (features & (1ULL << VHOST_NET_F_VIRTIO_NET_HDR)) {
+		int vhost_hdr_sz =3D (features & ((1ULL << VIRTIO_NET_F_MRG_RXBUF) |
+						(1ULL << VIRTIO_F_VERSION_1))) ?
+			sizeof(struct virtio_net_hdr_mrg_rxbuf) :
+			sizeof(struct virtio_net_hdr);
+
+		data_offset +=3D vhost_hdr_sz;
+		if (pi_offset !=3D -1)
+			pi_offset +=3D vhost_hdr_sz;
+	}
+
+	if (!xdp) {
+		int sndbuf =3D RING_SIZE * 2048;
+		if (ioctl(tun_fd, TUNSETSNDBUF, &sndbuf) < 0) {
+			perror("TUNSETSNDBUF");
+			ret =3D -1;
+			goto err;
+		}
+	}
+
+	ret =3D setup_vhost(vhost_fd, tun_fd, call_fd, kick_fd, features);
+	if (ret)
+		goto err;
+
+	/* A fake link-local address for the userspace end */
+	struct in6_addr local_addr =3D { 0 };
+	local_addr.s6_addr16[0] =3D htons(0xfe80);
+	local_addr.s6_addr16[7] =3D htons(1);
+
+
+	/* Set up RX and TX descriptors; the latter with ping packets ready to
+	 * send to the kernel, but don't actually send them yet. */
+	for (int i =3D 0; i < RING_SIZE; i++) {
+		struct pkt_buf *pkt =3D &rings[1].pkts[i];
+		if (pi_offset !=3D -1) {
+			struct tun_pi *pi =3D (void *)&pkt->data[pi_offset];
+			pi->proto =3D htons(ETH_P_IPV6);
+		}
+		int plen =3D create_icmp_echo(&pkt->data[data_offset], &tun_addr,
+					    &local_addr, 0x4747, i);
+
+		rings[1].desc[i].addr =3D vio64((uint64_t)pkt);
+		rings[1].desc[i].len =3D vio32(plen + data_offset);
+		rings[1].avail_ring[i] =3D vio16(i);
+
+		pkt =3D &rings[0].pkts[i];
+		rings[0].desc[i].addr =3D vio64((uint64_t)pkt);
+		rings[0].desc[i].len =3D vio32(sizeof(*pkt));
+		rings[0].desc[i].flags =3D vio16(VRING_DESC_F_WRITE);
+		rings[0].avail_ring[i] =3D vio16(i);
+	}
+	barrier();
+	rings[1].avail.idx =3D vio16(1);
+
+	uint16_t rx_seen_used =3D 0;
+	struct timeval tv =3D { 1, 0 };
+	while (1) {
+		fd_set rfds =3D { 0 };
+		FD_SET(call_fd, &rfds);
+
+		rings[0].avail.idx =3D vio16(rx_seen_used + RING_SIZE);
+		barrier();
+		eventfd_write(kick_fd, 1);
+
+		if (select(call_fd + 1, &rfds, NULL, NULL, &tv) <=3D 0) {
+			ret =3D -1;
+			goto err;
+		}
+
+		uint16_t rx_used_idx =3D vio16(rings[0].used.idx);
+		barrier();
+
+		while(rx_used_idx !=3D rx_seen_used) {
+			uint32_t desc =3D vio32(rings[0].used_ring[RING_MASK(rx_seen_used)].id)=
;
+			uint32_t len  =3D vio32(rings[0].used_ring[RING_MASK(rx_seen_used)].len=
);
+
+			if (desc >=3D RING_SIZE || len < data_offset)
+				return -1;
+
+			uint64_t addr =3D vio64(rings[0].desc[desc].addr);
+			if (!addr)
+				return -1;
+
+			if (len > data_offset &&
+			    (pi_offset =3D=3D -1 ||
+			     ((struct tun_pi *)(addr + pi_offset))->proto =3D=3D htons(ETH_P_IP=
V6)) &&
+			    check_icmp_response((void *)(addr + data_offset), len - data_offset=
,
+						&local_addr, &tun_addr)) {
+				ret =3D 0;
+				goto err;
+			}
+
+			/* Give the same buffer back */
+			rings[0].avail_ring[RING_MASK(rx_seen_used++)] =3D vio32(desc);
+		}
+		barrier();
+
+		uint64_t ev_val;
+		eventfd_read(call_fd, &ev_val);
+	}
+
+ err:
+	if (call_fd !=3D -1)
+		close(call_fd);
+	if (kick_fd !=3D -1)
+		close(kick_fd);
+	if (vhost_fd !=3D -1)
+		close(vhost_fd);
+	if (tun_fd !=3D -1)
+		close(tun_fd);
+
+	printf("TEST: (hdr %d, xdp %d, pi %d, features %llx) RESULT: %d\n",
+	       vnet_hdr_sz, xdp, pi, (unsigned long long)features, ret);
+	return ret;
+}
+
+/* For iterating over all permutations. */
+#define VHDR_LEN_BITS	3	/* Tun vhdr length selection */
+#define XDP_BIT		4	/* Don't TUNSETSNDBUF, so we use XDP */
+#define PI_BIT		8	/* Don't set IFF_NO_PI */
+#define VIRTIO_V1_BIT	16	/* Use VIRTIO_F_VERSION_1 feature */
+#define VHOST_HDR_BIT	32	/* Use VHOST_NET_F_VIRTIO_NET_HDR */
+
+unsigned int tun_vhdr_lens[] =3D { 0, 10, 12, 20 };
+
+int main(void)
+{
+	int result =3D KSFT_SKIP;
+	int i, ret;
+
+	for (i =3D 0; i < 64; i++) {
+		uint64_t features =3D 0;
+
+		if (i & VIRTIO_V1_BIT)
+			features |=3D (1ULL << VIRTIO_F_VERSION_1);
+#if __BYTE_ORDER__ =3D=3D __ORDER_BIG_ENDIAN__
+		else
+			continue; /* We'd need vio16 et al not to byteswap */
+#endif
+
+		if (i & VHOST_HDR_BIT) {
+			features |=3D (1ULL << VHOST_NET_F_VIRTIO_NET_HDR);
+
+			/* Even though the test actually passes at the time of
+			 * writing, don't bother to try asking tun *and* vhost
+			 * both to handle a virtio_net_hdr at the same time.
+			 * That's just silly.  */
+			if (i & VHDR_LEN_BITS)
+				continue;
+		}
+
+		ret =3D test_vhost(tun_vhdr_lens[i & VHDR_LEN_BITS],
+				 !!(i & PI_BIT), !!(i & XDP_BIT), features);
+		if (ret < result)
+			result =3D ret;
+	}
+
+	return result;
+}



--=-WO7HAbpMkFJhkll1GffJ
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCECow
ggUcMIIEBKADAgECAhEA4rtJSHkq7AnpxKUY8ZlYZjANBgkqhkiG9w0BAQsFADCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwHhcNMTkwMTAyMDAwMDAwWhcNMjIwMTAxMjM1
OTU5WjAkMSIwIAYJKoZIhvcNAQkBFhNkd213MkBpbmZyYWRlYWQub3JnMIIBIjANBgkqhkiG9w0B
AQEFAAOCAQ8AMIIBCgKCAQEAsv3wObLTCbUA7GJqKj9vHGf+Fa+tpkO+ZRVve9EpNsMsfXhvFpb8
RgL8vD+L133wK6csYoDU7zKiAo92FMUWaY1Hy6HqvVr9oevfTV3xhB5rQO1RHJoAfkvhy+wpjo7Q
cXuzkOpibq2YurVStHAiGqAOMGMXhcVGqPuGhcVcVzVUjsvEzAV9Po9K2rpZ52FE4rDkpDK1pBK+
uOAyOkgIg/cD8Kugav5tyapydeWMZRJQH1vMQ6OVT24CyAn2yXm2NgTQMS1mpzStP2ioPtTnszIQ
Ih7ASVzhV6csHb8Yrkx8mgllOyrt9Y2kWRRJFm/FPRNEurOeNV6lnYAXOymVJwIDAQABo4IB0zCC
Ac8wHwYDVR0jBBgwFoAUgq9sjPjF/pZhfOgfPStxSF7Ei8AwHQYDVR0OBBYEFLfuNf820LvaT4AK
xrGK3EKx1DE7MA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUF
BwMEBggrBgEFBQcDAjBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEDBTArMCkGCCsGAQUFBwIBFh1o
dHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3Js
LmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWls
Q0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKGSWh0dHA6Ly9jcnQuY29tb2RvY2Eu
Y29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcnQwJAYI
KwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTAeBgNVHREEFzAVgRNkd213MkBpbmZy
YWRlYWQub3JnMA0GCSqGSIb3DQEBCwUAA4IBAQALbSykFusvvVkSIWttcEeifOGGKs7Wx2f5f45b
nv2ghcxK5URjUvCnJhg+soxOMoQLG6+nbhzzb2rLTdRVGbvjZH0fOOzq0LShq0EXsqnJbbuwJhK+
PnBtqX5O23PMHutP1l88AtVN+Rb72oSvnD+dK6708JqqUx2MAFLMevrhJRXLjKb2Mm+/8XBpEw+B
7DisN4TMlLB/d55WnT9UPNHmQ+3KFL7QrTO8hYExkU849g58Dn3Nw3oCbMUgny81ocrLlB2Z5fFG
Qu1AdNiBA+kg/UxzyJZpFbKfCITd5yX49bOriL692aMVDyqUvh8fP+T99PqorH4cIJP6OxSTdxKM
MIIFHDCCBASgAwIBAgIRAOK7SUh5KuwJ6cSlGPGZWGYwDQYJKoZIhvcNAQELBQAwgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTE5MDEwMjAwMDAwMFoXDTIyMDEwMTIz
NTk1OVowJDEiMCAGCSqGSIb3DQEJARYTZHdtdzJAaW5mcmFkZWFkLm9yZzCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBALL98Dmy0wm1AOxiaio/bxxn/hWvraZDvmUVb3vRKTbDLH14bxaW
/EYC/Lw/i9d98CunLGKA1O8yogKPdhTFFmmNR8uh6r1a/aHr301d8YQea0DtURyaAH5L4cvsKY6O
0HF7s5DqYm6tmLq1UrRwIhqgDjBjF4XFRqj7hoXFXFc1VI7LxMwFfT6PStq6WedhROKw5KQytaQS
vrjgMjpICIP3A/CroGr+bcmqcnXljGUSUB9bzEOjlU9uAsgJ9sl5tjYE0DEtZqc0rT9oqD7U57My
ECIewElc4VenLB2/GK5MfJoJZTsq7fWNpFkUSRZvxT0TRLqznjVepZ2AFzsplScCAwEAAaOCAdMw
ggHPMB8GA1UdIwQYMBaAFIKvbIz4xf6WYXzoHz0rcUhexIvAMB0GA1UdDgQWBBS37jX/NtC72k+A
CsaxitxCsdQxOzAOBgNVHQ8BAf8EBAMCBaAwDAYDVR0TAQH/BAIwADAdBgNVHSUEFjAUBggrBgEF
BQcDBAYIKwYBBQUHAwIwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAwUwKzApBggrBgEFBQcCARYd
aHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwWgYDVR0fBFMwUTBPoE2gS4ZJaHR0cDovL2Ny
bC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFp
bENBLmNybDCBiwYIKwYBBQUHAQEEfzB9MFUGCCsGAQUFBzAChklodHRwOi8vY3J0LmNvbW9kb2Nh
LmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWlsQ0EuY3J0MCQG
CCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wHgYDVR0RBBcwFYETZHdtdzJAaW5m
cmFkZWFkLm9yZzANBgkqhkiG9w0BAQsFAAOCAQEAC20spBbrL71ZEiFrbXBHonzhhirO1sdn+X+O
W579oIXMSuVEY1LwpyYYPrKMTjKECxuvp24c829qy03UVRm742R9Hzjs6tC0oatBF7KpyW27sCYS
vj5wbal+TttzzB7rT9ZfPALVTfkW+9qEr5w/nSuu9PCaqlMdjABSzHr64SUVy4ym9jJvv/FwaRMP
gew4rDeEzJSwf3eeVp0/VDzR5kPtyhS+0K0zvIWBMZFPOPYOfA59zcN6AmzFIJ8vNaHKy5QdmeXx
RkLtQHTYgQPpIP1Mc8iWaRWynwiE3ecl+PWzq4i+vdmjFQ8qlL4fHz/k/fT6qKx+HCCT+jsUk3cS
jDCCBeYwggPOoAMCAQICEGqb4Tg7/ytrnwHV2binUlYwDQYJKoZIhvcNAQEMBQAwgYUxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSswKQYDVQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRp
b24gQXV0aG9yaXR5MB4XDTEzMDExMDAwMDAwMFoXDTI4MDEwOTIzNTk1OVowgZcxCzAJBgNVBAYT
AkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNV
BAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAvrOeV6wodnVAFsc4A5jTxhh2IVDzJXkLTLWg0X06WD6cpzEup/Y0dtmEatrQPTRI5Or1u6zf
+bGBSyD9aH95dDSmeny1nxdlYCeXIoymMv6pQHJGNcIDpFDIMypVpVSRsivlJTRENf+RKwrB6vcf
WlP8dSsE3Rfywq09N0ZfxcBa39V0wsGtkGWC+eQKiz4pBZYKjrc5NOpG9qrxpZxyb4o4yNNwTqza
aPpGRqXB7IMjtf7tTmU2jqPMLxFNe1VXj9XB1rHvbRikw8lBoNoSWY66nJN/VCJv5ym6Q0mdCbDK
CMPybTjoNCQuelc0IAaO4nLUXk0BOSxSxt8kCvsUtQIDAQABo4IBPDCCATgwHwYDVR0jBBgwFoAU
u69+Aj36pvE8hI6t7jiY7NkyMtQwHQYDVR0OBBYEFIKvbIz4xf6WYXzoHz0rcUhexIvAMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMBEGA1UdIAQKMAgwBgYEVR0gADBMBgNVHR8E
RTBDMEGgP6A9hjtodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDZXJ0aWZpY2F0aW9u
QXV0aG9yaXR5LmNybDBxBggrBgEFBQcBAQRlMGMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9jcnQuY29t
b2RvY2EuY29tL0NPTU9ET1JTQUFkZFRydXN0Q0EuY3J0MCQGCCsGAQUFBzABhhhodHRwOi8vb2Nz
cC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEMBQADggIBAHhcsoEoNE887l9Wzp+XVuyPomsX9vP2
SQgG1NgvNc3fQP7TcePo7EIMERoh42awGGsma65u/ITse2hKZHzT0CBxhuhb6txM1n/y78e/4ZOs
0j8CGpfb+SJA3GaBQ+394k+z3ZByWPQedXLL1OdK8aRINTsjk/H5Ns77zwbjOKkDamxlpZ4TKSDM
KVmU/PUWNMKSTvtlenlxBhh7ETrN543j/Q6qqgCWgWuMAXijnRglp9fyadqGOncjZjaaSOGTTFB+
E2pvOUtY+hPebuPtTbq7vODqzCM6ryEhNhzf+enm0zlpXK7q332nXttNtjv7VFNYG+I31gnMrwfH
M5tdhYF/8v5UY5g2xANPECTQdu9vWPoqNSGDt87b3gXb1AiGGaI06vzgkejL580ul+9hz9D0S0U4
jkhJiA7EuTecP/CFtR72uYRBcunwwH3fciPjviDDAI9SnC/2aPY8ydehzuZutLbZdRJ5PDEJM/1t
yZR2niOYihZ+FCbtf3D9mB12D4ln9icgc7CwaxpNSCPt8i/GqK2HsOgkL3VYnwtx7cJUmpvVdZ4o
gnzgXtgtdk3ShrtOS1iAN2ZBXFiRmjVzmehoMof06r1xub+85hFQzVxZx5/bRaTKTlL8YXLI8nAb
R9HWdFqzcOoB/hxfEyIQpx9/s81rgzdEZOofSlZHynoSMYIDyjCCA8YCAQEwga0wgZcxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAY
BgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQDEzRDT01PRE8gUlNBIENsaWVudCBBdXRo
ZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhEA4rtJSHkq7AnpxKUY8ZlYZjANBglghkgB
ZQMEAgEFAKCCAe0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjEw
NjIzMjI1MjM4WjAvBgkqhkiG9w0BCQQxIgQgxWB2hOPnYcSP5IAUAxwEKJyelImJGdYcqu+eQ6AI
JQowgb4GCSsGAQQBgjcQBDGBsDCBrTCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQx
PTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMIHABgsqhkiG9w0BCRACCzGBsKCBrTCBlzELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEQDiu0lIeSrsCenEpRjxmVhmMA0GCSqGSIb3
DQEBAQUABIIBABqitLEWnVx223ey6br1RShzCCv0oju4D+IhDnvdWf6pLNGaeIlrAxkBUru14x+Y
j2DrRs0r1HaInu2hYweWw58BLnEf6WEJ8TjSErFGYA1YpmFAPjJ/UjbvuD13ypm0c2Qh4peF7Bl0
Nv6iuBxTxXFuaAYJs62I/BtwXyuxOAT7I0GjqnzJXAOJ5b2wV/QWz6sLxCnVwK1hc2Tc2v+WcAT8
1D3EsmxyHyBNnSeYZeYJlgDutTwUvZuW3HawmqatRoQEewhg7k0zjKSUcTYFB1kkwEGVqCtIac+Q
5m59Q6SRDSkvdcsyqu6hNLFOtmo5hjJ/2hKeGd+aCB0iJy+g/JEAAAAAAAA=


--=-WO7HAbpMkFJhkll1GffJ--

