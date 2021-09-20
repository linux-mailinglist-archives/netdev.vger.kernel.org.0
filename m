Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEEEC4122BD
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 20:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347195AbhITSRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 14:17:06 -0400
Received: from lizzy.crudebyte.com ([91.194.90.13]:44745 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376713AbhITSOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 14:14:20 -0400
X-Greylist: delayed 3422 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Sep 2021 14:12:11 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=ePbeAywu/lY42TIL8si/nKq6WPM1V/jO+mL9Ww5/new=; b=MbwlD
        X4dDCdWuky707UY47kJQkOgqtqEUYEQnJmwp7/03ZtMNBzCeUEg59cBGkT+q+TKRTNNqH6Y+KsjFY
        ZKNm9h1o7JSKQQu9HpTXSGocK3sro9fFp9HsR9LoAPvU72ixDkjG2Xgf+cu4ZEdjx5nwkeNN0pwt5
        2iZC9wm3jcOJ8E3Pdrx+3LR3B8RsLFYRfYBQBx7yQTNePujiPP7QAMzXpzlNWnUqD+H9risWMky3v
        Q97bnyBjEF29zs3gkP1isdrfbLxZg8eYqQaa9OuAqRMxeEkAAl1QTeA341kpgPJYy79NKERrz9aZD
        nkOgMWmMIZmq008e7NXQjvf7L6tBw==;
Message-Id: <0a2c16b9acf580a679f38354b5d60a68c5fb6c99.1632156835.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1632156835.git.linux_oss@crudebyte.com>
References: <cover.1632156835.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Mon, 20 Sep 2021 18:44:20 +0200
Subject: [PATCH v2 7/7] 9p/trans_virtio: resize sg lists to whatever is
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
 net/9p/trans_virtio.c | 65 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 55 insertions(+), 10 deletions(-)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 4cb75f45aa15..b9bab7ed2768 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -205,24 +205,66 @@ static struct virtqueue_sg *vq_sg_alloc(unsigned int nsgl)
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
 
-	kfree(*_vq_sg);
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
@@ -839,13 +881,16 @@ p9_virtio_create(struct p9_client *client, const char *devname, char *args)
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
 #endif /* CONFIG_ARCH_NO_SG_CHAIN */
 	}
-- 
2.20.1

