Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28343B0A16
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 18:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhFVQRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 12:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhFVQRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 12:17:52 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D08C061574
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 09:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=i+iKYtl26TpN7Y7yLSMPClkveH4h2WunnuTzfof6WvA=; b=pQbQagAlhWnpzAWwBFHv1tV7H4
        laSlRA9176obTHs38xR8OI40PX0qLIWrfSXLsjr84IyDh4I6yX86WqZZpLMAmMgEOEh7gudnSr4hh
        wTS4OfGTLlNDV39ba4NZ0jB+jUXV162ZsYTZAwAZTUNh4bGHHwJ40hMEb39SLz+ZBB8yjVuPuzD57
        UwiliOkvVuGdCKaFqI/iytW8FEItEk7rXBZ4XgAnv/pr3J4//KMDRkCc8jnPm3L3MSFATx3dq9pnq
        8sl6fRjRMY7sCEZaTMwYRGjbEyy1W4KX3fOs42TFU6Lx/tRrodsFvu3gWwRNInEH2LxyqTeVBS70P
        gvsQy+dw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lvj3f-00Ae50-99; Tue, 22 Jun 2021 16:15:34 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lvj3l-00560F-Ob; Tue, 22 Jun 2021 17:15:33 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
Subject: [PATCH v2 3/4] vhost_net: validate virtio_net_hdr only if it exists
Date:   Tue, 22 Jun 2021 17:15:32 +0100
Message-Id: <20210622161533.1214662-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622161533.1214662-1-dwmw2@infradead.org>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210622161533.1214662-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

When the underlying socket doesn't handle the virtio_net_hdr, the
existing code in vhost_net_build_xdp() would attempt to validate stack
noise, by copying zero bytes into the local copy of the header and then
validating that. Skip the whole pointless pointer arithmetic and partial
copy (of zero bytes) in this case.

Fixes: 0a0be13b8fe2 ("vhost_net: batch submitting XDP buffers to underlayer sockets")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 drivers/vhost/net.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index df82b124170e..1e3652eb53af 100644
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
@@ -715,29 +714,31 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
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
+		struct virtio_net_hdr *gso = &hdr->gso;
+
+		copied = copy_page_from_iter(alloc_frag->page,
+					     alloc_frag->offset +
+					     offsetof(struct tun_xdp_hdr, gso),
+					     sock_hlen, from);
+		if (copied != sock_hlen)
+			return -EFAULT;
+
+		if ((gso->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
+		    vhost16_to_cpu(vq, gso->csum_start) +
+		    vhost16_to_cpu(vq, gso->csum_offset) + 2 >
+		    vhost16_to_cpu(vq, gso->hdr_len)) {
+			gso->hdr_len = cpu_to_vhost16(vq,
+						      vhost16_to_cpu(vq, gso->csum_start) +
+						      vhost16_to_cpu(vq, gso->csum_offset) + 2);
+
+			if (vhost16_to_cpu(vq, gso->hdr_len) > len)
+				return -EINVAL;
+		}
+		len -= sock_hlen;
 	}
 
-	len -= sock_hlen;
 	copied = copy_page_from_iter(alloc_frag->page,
 				     alloc_frag->offset + pad,
 				     len, from);
-- 
2.31.1

