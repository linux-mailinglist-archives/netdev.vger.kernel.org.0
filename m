Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF4440EAD2
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 21:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbhIPTbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 15:31:47 -0400
Received: from lizzy.crudebyte.com ([91.194.90.13]:56525 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232324AbhIPTbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 15:31:47 -0400
X-Greylist: delayed 1673 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Sep 2021 15:31:46 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=nIctL8Cr0+i6axbSnzbk1KOppeRbmHlrFSxlt6imueg=; b=DUREi
        DnHVKyOJyI3Auzc1ueMeuwfjpVQ/DesfFAIffdmQnFi1cI2UUYYBvPmt86N/COdb4K65SLqS/TbFU
        4PoMuA42fX3hlVRt/vg+fNkkscqL7proufcQPMnqKvHmSGEZuR4nOui+m743yyfCVQ48iioLdOo/X
        ALsTZdG3iBtmz9mvxP296739J5ssN06T5cYlQ8MBWIzBaduU50bphr7tBR4AE8umdeC1kpBToDhX4
        e/w3f0bCnZziePzGjB0MfO2Ytot/1TZuSaH5FkgRWmyz6PTpeQ/ZuEsmnfn3ojjJ6FwER0SDe2vmK
        V4NdRyYjhxZ2OTeV0+r85DfBIE5hA==;
Message-Id: <a98a002b61d399078ef5ff3c3d66de67adc8854f.1631816768.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1631816768.git.linux_oss@crudebyte.com>
References: <cover.1631816768.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Thu, 16 Sep 2021 20:25:23 +0200
Subject: [PATCH 7/7] 9p/trans_virtio: resize sg lists to whatever is possible
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
the requested new sg lists size, or it did not resize at all.

The problem with this is if a user supplies a very large msize
value, resize would simply fail and the user would stick to
the default maximum msize supported by the virtio transport.

To resolve this potential issue, change vq_sg_resize() to resize
the passed sg list to whatever is possible on the machine.

Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
---
 net/9p/trans_virtio.c | 64 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 55 insertions(+), 9 deletions(-)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 1f9a0283d7b8..d81c0be475ba 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -200,23 +200,66 @@ static struct virtqueue_sg *vq_sg_alloc(unsigned int nsgl)
  * list blocks.
  * @_vq_sg: scatter/gather lists to be resized
  * @nsgl: new amount of scatter/gather list blocks
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
 	*_vq_sg = vq_sg;
-	return 0;
+	return ret;
 }
 
 /**
@@ -829,13 +872,16 @@ p9_virtio_create(struct p9_client *client, const char *devname, char *args)
 		if (nsgl > chan->vq_sg->nsgl) {
 			/*
 			 * if resize fails, no big deal, then just
-			 * continue with default msize instead
+			 * continue with whatever we got
 			 */
-			if (!vq_sg_resize(&chan->vq_sg, nsgl)) {
-				client->trans_maxsize =
-					PAGE_SIZE *
-					((nsgl * SG_USER_PAGES_PER_LIST) - 3);
-			}
+			vq_sg_resize(&chan->vq_sg, nsgl);
+			/*
+			 * actual allocation size might be less than
+			 * requested, so use vq_sg->nsgl instead of nsgl
+			 */
+			client->trans_maxsize =
+				PAGE_SIZE * ((chan->vq_sg->nsgl *
+				SG_USER_PAGES_PER_LIST) - 3);
 		}
 #endif /* !defined(CONFIG_ARCH_NO_SG_CHAIN) */
 	}
-- 
2.20.1

