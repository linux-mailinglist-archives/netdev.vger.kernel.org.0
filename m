Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37193414F19
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 19:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236880AbhIVRb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 13:31:58 -0400
Received: from lizzy.crudebyte.com ([91.194.90.13]:47947 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236837AbhIVRb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 13:31:57 -0400
X-Greylist: delayed 2675 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Sep 2021 13:31:56 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=uAkW4TzWUK16Ru7P7NVmzaRv5wNfHu4c5UQ/NgBgNCA=; b=FqXMK
        8A3sVyxb17CYv7bIfljrujhdCLCGIyXrCG/VlclgMOBUx/ENyoXTilIDxsW1I42SCqACmqocetTIO
        0zULow7k+Eofe8gPQujhXZhfKMHrj3KerfJP4uAPFCUJt/jra5A8LczIuUWKlBVfpiM+pR4aN7CIY
        Lq5VmDxmGHIOGXntY0+u/jraYaTygoiNG2k1XGenRF3pcBUQm7bsMPJ8FXanDjNE3NnJ86FJFdXtS
        Zr4X+S9udp45Rh6gHtRr4FzjrTQA9VY1RCaAhkgrxCUiZwQvKHz1vpzLBW/qsi+rd6KK6SvUPQxex
        k25rxt6iODgZrsOPofOZJ2n3ED/Xw==;
Message-Id: <3a0d9c26581f237976c5903e332d49c9727b3fa7.1632327421.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1632327421.git.linux_oss@crudebyte.com>
References: <cover.1632327421.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Wed, 22 Sep 2021 18:00:35 +0200
Subject: [PATCH v3 7/7] 9p/trans_virtio: resize sg lists to whatever is
 possible
To:     v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now vq_sg_resize() used a lazy implementation following
the all-or-nothing princible. So it either resized exactly to
the requested new amount of sg lists, or it did not resize at
all.

The problem with this is if a user supplies a very large msize
value, resize would simply fail and the user would stick to
the default maximum msize supported by the virtio transport.

To resolve this potential issue, change vq_sg_resize() to resize
the passed sg list to whatever is possible on the machine.

Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
---
 net/9p/trans_virtio.c | 68 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 60 insertions(+), 8 deletions(-)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 147ebf647a95..4c61b4857bea 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -208,24 +208,67 @@ static struct virtqueue_sg *vq_sg_alloc(unsigned int nsgl)
  * amount of lists
  * @_vq_sg: scatter/gather lists to be resized
  * @nsgl: new amount of scatter/gather lists
+ *
+ * Old scatter/gather lists are retained. Only growing the size is supported.
+ * If the requested amount cannot be satisfied, then lists are increased to
+ * whatever is possible.
  */
 static int vq_sg_resize(struct virtqueue_sg **_vq_sg, unsigned int nsgl)
 {
 	struct virtqueue_sg *vq_sg;
+	unsigned int i;
+	size_t sz;
+	int ret = 0;
 
 	BUG_ON(!_vq_sg || !nsgl);
 	vq_sg = *_vq_sg;
+	if (nsgl > VIRTQUEUE_SG_NSGL_MAX)
+		nsgl = VIRTQUEUE_SG_NSGL_MAX;
 	if (vq_sg->nsgl == nsgl)
 		return 0;
+	if (vq_sg->nsgl > nsgl)
+		return -ENOTSUPP;
+
+	vq_sg = kzalloc(sizeof(struct virtqueue_sg) +
+			nsgl * sizeof(struct scatterlist *),
+			GFP_KERNEL);
 
-	/* lazy resize implementation for now */
-	vq_sg = vq_sg_alloc(nsgl);
 	if (!vq_sg)
 		return -ENOMEM;
 
+	/* copy over old scatter gather lists */
+	sz = sizeof(struct virtqueue_sg) +
+		(*_vq_sg)->nsgl * sizeof(struct scatterlist *);
+	memcpy(vq_sg, *_vq_sg, sz);
+
+	vq_sg->nsgl = nsgl;
+
+	for (i = (*_vq_sg)->nsgl; i < nsgl; ++i) {
+		vq_sg->sgl[i] = kmalloc_array(
+			SG_MAX_SINGLE_ALLOC, sizeof(struct scatterlist),
+			GFP_KERNEL
+		);
+		/*
+		 * handle failed allocation as soft error, we take whatever
+		 * we get
+		 */
+		if (!vq_sg->sgl[i]) {
+			ret = -ENOMEM;
+			vq_sg->nsgl = nsgl = i;
+			break;
+		}
+		sg_init_table(vq_sg->sgl[i], SG_MAX_SINGLE_ALLOC);
+		if (i) {
+			/* chain the lists */
+			sg_chain(vq_sg->sgl[i - 1], SG_MAX_SINGLE_ALLOC,
+				 vq_sg->sgl[i]);
+		}
+	}
+	sg_mark_end(&vq_sg->sgl[nsgl - 1][SG_MAX_SINGLE_ALLOC - 1]);
+
 	kfree(*_vq_sg);
 	*_vq_sg = vq_sg;
-	return 0;
+	return ret;
 }
 
 /**
@@ -846,12 +889,21 @@ p9_virtio_create(struct p9_client *client, const char *devname, char *args)
 		if (nsgl > chan->vq_sg->nsgl) {
 			/*
 			 * if resize fails, no big deal, then just
-			 * continue with default msize instead
+			 * continue with whatever we got
+			 */
+			vq_sg_resize(&chan->vq_sg, nsgl);
+			/*
+			 * actual allocation size might be less than
+			 * requested, so use vq_sg->nsgl instead of nsgl
 			 */
-			if (!vq_sg_resize(&chan->vq_sg, nsgl)) {
-				client->trans_maxsize =
-					PAGE_SIZE *
-					((nsgl * SG_USER_PAGES_PER_LIST) - 3);
+			client->trans_maxsize =
+				PAGE_SIZE * ((chan->vq_sg->nsgl *
+				SG_USER_PAGES_PER_LIST) - 3);
+			if (nsgl > chan->vq_sg->nsgl) {
+				pr_info("limiting 'msize' to %d as only %d "
+					"of %zu SG lists could be allocated",
+					client->trans_maxsize,
+					chan->vq_sg->nsgl, nsgl);
 			}
 		}
 #endif /* CONFIG_ARCH_NO_SG_CHAIN */
-- 
2.20.1

