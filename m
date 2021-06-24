Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC493B2EEE
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 14:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhFXMck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 08:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbhFXMc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 08:32:29 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37BEC061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 05:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=c8vL8HZX/zIZPP6WgQpljiTWkbKb1nnMUaed62zzHUA=; b=Ez7x7SmJShwnSTPgGFFS6Wj+EI
        vmI37361G8xYO1ae6YTdUBPWjn3aGuKc3tzidjN29CfGo1orKgSEqR36CGcemn8a0CiO2HtMmESZ2
        tsHNqki6tziqUo7tX9t5s3P7nrzVQwtPj2uCbDt4tk0bXLpGQDvzT2+t0F4b2ONj/FJ7okMk9xdvz
        s6zwA36S53mnvX8e7BJNWvUiHFdTtwMW9etzcPlkj1CXGeaqY7x5hpyNP+14StRdzFNpvWJnTwy3o
        GJCTT0Ewno6lJfgQPh/A9vX13vY3QDZVWgTDjhn3qxgJ+McbwsyDL54LzuoY3GL77WcJM7rRWSJWD
        Ros65bfw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lwOUZ-00BEEO-6D; Thu, 24 Jun 2021 12:30:06 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lwOUf-005Sf1-L6; Thu, 24 Jun 2021 13:30:05 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v3 3/5] vhost_net: remove virtio_net_hdr validation, let tun/tap do it themselves
Date:   Thu, 24 Jun 2021 13:30:03 +0100
Message-Id: <20210624123005.1301761-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210624123005.1301761-1-dwmw2@infradead.org>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210624123005.1301761-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

When the underlying socket isn't configured with a virtio_net_hdr, the
existing code in vhost_net_build_xdp() would attempt to validate
uninitialised data, by copying zero bytes (sock_hlen) into the local
copy of the header and then trying to validate that.

Fixing it is somewhat non-trivial because the tun device might put a
struct tun_pi *before* the virtio_net_hdr, which makes it hard to find.
So just stop messing with someone else's data in vhost_net_build_xdp(),
and let tap and tun validate it for themselves, as they do in the
non-XDP case anyway.

This means that the 'gso' member of struct tun_xdp_hdr can die, leaving
only 'int buflen'.

The socket header of sock_hlen is still copied separately from the
data payload because there may be a gap between them to ensure suitable
alignment of the latter.

Fixes: 0a0be13b8fe2 ("vhost_net: batch submitting XDP buffers to underlayer sockets")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 drivers/net/tap.c      | 25 ++++++++++++++++++++++---
 drivers/net/tun.c      | 21 ++++++++++++++++++---
 drivers/vhost/net.c    | 30 +++++++++---------------------
 include/linux/if_tun.h |  1 -
 4 files changed, 49 insertions(+), 28 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 2170a0d3d34c..d1b1f1de374e 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1132,16 +1132,35 @@ static const struct file_operations tap_fops = {
 static int tap_get_user_xdp(struct tap_queue *q, struct xdp_buff *xdp)
 {
 	struct tun_xdp_hdr *hdr = xdp->data_hard_start;
-	struct virtio_net_hdr *gso = &hdr->gso;
+	struct virtio_net_hdr *gso = NULL;
 	int buflen = hdr->buflen;
 	int vnet_hdr_len = 0;
 	struct tap_dev *tap;
 	struct sk_buff *skb;
 	int err, depth;
 
-	if (q->flags & IFF_VNET_HDR)
+	if (q->flags & IFF_VNET_HDR) {
 		vnet_hdr_len = READ_ONCE(q->vnet_hdr_sz);
+		if (xdp->data != xdp->data_hard_start + sizeof(*hdr) + vnet_hdr_len) {
+			err = -EINVAL;
+			goto err;
+		}
+
+		gso = (void *)&hdr[1];
 
+		if ((gso->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
+		     tap16_to_cpu(q, gso->csum_start) +
+		     tap16_to_cpu(q, gso->csum_offset) + 2 >
+			     tap16_to_cpu(q, gso->hdr_len))
+			gso->hdr_len = cpu_to_tap16(q,
+				 tap16_to_cpu(q, gso->csum_start) +
+				 tap16_to_cpu(q, gso->csum_offset) + 2);
+
+		if (tap16_to_cpu(q, gso->hdr_len) > xdp->data_end - xdp->data) {
+			err = -EINVAL;
+			goto err;
+		}
+	}
 	skb = build_skb(xdp->data_hard_start, buflen);
 	if (!skb) {
 		err = -ENOMEM;
@@ -1155,7 +1174,7 @@ static int tap_get_user_xdp(struct tap_queue *q, struct xdp_buff *xdp)
 	skb_reset_mac_header(skb);
 	skb->protocol = eth_hdr(skb)->h_proto;
 
-	if (vnet_hdr_len) {
+	if (gso) {
 		err = virtio_net_hdr_to_skb(skb, gso, tap_is_little_endian(q));
 		if (err)
 			goto err_kfree;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 9acd448e6dfc..1b553f79adb0 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2331,6 +2331,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 {
 	unsigned int datasize = xdp->data_end - xdp->data;
 	struct tun_xdp_hdr *hdr = xdp->data_hard_start;
+	void *tun_hdr = &hdr[1];
 	struct virtio_net_hdr *gso = NULL;
 	struct bpf_prog *xdp_prog;
 	struct sk_buff *skb = NULL;
@@ -2340,8 +2341,22 @@ static int tun_xdp_one(struct tun_struct *tun,
 	bool skb_xdp = false;
 	struct page *page;
 
-	if (tun->flags & IFF_VNET_HDR)
-		gso = &hdr->gso;
+	if (tun->flags & IFF_VNET_HDR) {
+		gso = tun_hdr;
+		tun_hdr += sizeof(*gso);
+
+		if (tun_hdr > xdp->data) {
+			atomic_long_inc(&tun->rx_frame_errors);
+			return -EINVAL;
+		}
+
+		if ((gso->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
+		    tun16_to_cpu(tun, gso->csum_start) + tun16_to_cpu(tun, gso->csum_offset) + 2 > tun16_to_cpu(tun, gso->hdr_len))
+			gso->hdr_len = cpu_to_tun16(tun, tun16_to_cpu(tun, gso->csum_start) + tun16_to_cpu(tun, gso->csum_offset) + 2);
+
+		if (tun16_to_cpu(tun, gso->hdr_len) > datasize)
+			return -EINVAL;
+	}
 
 	xdp_prog = rcu_dereference(tun->xdp_prog);
 	if (xdp_prog) {
@@ -2389,7 +2404,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 	}
 
 	skb_reserve(skb, xdp->data - xdp->data_hard_start);
-	skb_put(skb, xdp->data_end - xdp->data);
+	skb_put(skb, datasize);
 
 	if (gso && virtio_net_hdr_to_skb(skb, gso, tun_is_little_endian(tun))) {
 		atomic_long_inc(&tun->rx_frame_errors);
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index b92a7144ed90..7cae18151c60 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -690,7 +690,6 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
 					     dev);
 	struct socket *sock = vhost_vq_get_backend(vq);
 	struct page_frag *alloc_frag = &net->page_frag;
-	struct virtio_net_hdr *gso;
 	struct xdp_buff *xdp = &nvq->xdp[nvq->batched_xdp];
 	struct tun_xdp_hdr *hdr;
 	size_t len = iov_iter_count(from);
@@ -715,29 +714,18 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
 		return -ENOMEM;
 
 	buf = (char *)page_address(alloc_frag->page) + alloc_frag->offset;
-	copied = copy_page_from_iter(alloc_frag->page,
-				     alloc_frag->offset +
-				     offsetof(struct tun_xdp_hdr, gso),
-				     sock_hlen, from);
-	if (copied != sock_hlen)
-		return -EFAULT;
-
 	hdr = buf;
-	gso = &hdr->gso;
-
-	if ((gso->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
-	    vhost16_to_cpu(vq, gso->csum_start) +
-	    vhost16_to_cpu(vq, gso->csum_offset) + 2 >
-	    vhost16_to_cpu(vq, gso->hdr_len)) {
-		gso->hdr_len = cpu_to_vhost16(vq,
-			       vhost16_to_cpu(vq, gso->csum_start) +
-			       vhost16_to_cpu(vq, gso->csum_offset) + 2);
-
-		if (vhost16_to_cpu(vq, gso->hdr_len) > len)
-			return -EINVAL;
+	if (sock_hlen) {
+		copied = copy_page_from_iter(alloc_frag->page,
+					     alloc_frag->offset +
+					     sizeof(struct tun_xdp_hdr),
+					     sock_hlen, from);
+		if (copied != sock_hlen)
+			return -EFAULT;
+
+		len -= sock_hlen;
 	}
 
-	len -= sock_hlen;
 	copied = copy_page_from_iter(alloc_frag->page,
 				     alloc_frag->offset + pad,
 				     len, from);
diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
index 8a7debd3f663..8d78b6bbc228 100644
--- a/include/linux/if_tun.h
+++ b/include/linux/if_tun.h
@@ -21,7 +21,6 @@ struct tun_msg_ctl {
 
 struct tun_xdp_hdr {
 	int buflen;
-	struct virtio_net_hdr gso;
 };
 
 #if defined(CONFIG_TUN) || defined(CONFIG_TUN_MODULE)
-- 
2.31.1

