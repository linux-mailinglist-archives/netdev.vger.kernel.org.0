Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D63481D33
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 15:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239897AbhL3OmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 09:42:09 -0500
Received: from lizzy.crudebyte.com ([91.194.90.13]:49973 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235784AbhL3OmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 09:42:08 -0500
X-Greylist: delayed 4297 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Dec 2021 09:42:08 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=g86nOUNEYXZotGDC9WzvAD9cmWA0gMSDz40Z/V7NIeQ=; b=cyFmA
        ZSG8jfjWiJT4BgZ7NDCQ8iyahkY4liwY5jiM4zs6cWAi18Z2o8OsXf8cNvS9NAXGfi2YjJPXBNry9
        ZDGitV0cF32+RDSy48mRW/+kMSVFm2YjYSAy2OTkxqnvk6NrWBaowWs2eZyr//o2BPS+q+NyTUPGY
        044YZE9utscRJPI72YIiEbx+xdD6OMVHm61gZjrjpYvc2o6M8k1LjvqqDI7J++u5S2MFuS0oEuDKC
        hUs2ZoYrZnZmPIqMYgV5aLNp/exBYjSsd/v/S3e4AsN97iymBgtd/l7tCLN5KxKc9hnTaRk0POFgM
        NRozal/ZkiKrB7QXQTVWUtKCbVDXw==;
Message-Id: <7ec67285cf793e0bfe5aee7ccd37580cf9addb17.1640870037.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1640870037.git.linux_oss@crudebyte.com>
References: <cover.1640870037.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Thu, 30 Dec 2021 14:23:18 +0100
Subject: [PATCH v4 03/12] 9p/trans_virtio: turn amount of sg lists into
 runtime info
To:     v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>,
        Nikolay Kichukov <nikolay@oldum.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The size of scatter/gather lists used by the virtio transport is
currently hard coded. Refactor this to using a runtime variable.

Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
---
 net/9p/trans_virtio.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 7f0c992c0f68..d063c69b85b7 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -36,7 +36,7 @@
 #include <linux/virtio_9p.h>
 #include "trans_common.h"
 
-#define VIRTQUEUE_NUM	128
+#define VIRTQUEUE_DEFAULT_NUM	128
 
 /* a single mutex to manage channel initialization and attachment */
 static DEFINE_MUTEX(virtio_9p_lock);
@@ -54,6 +54,7 @@ static atomic_t vp_pinned = ATOMIC_INIT(0);
  * @vc_wq: wait queue for waiting for thing to be added to ring buf
  * @p9_max_pages: maximum number of pinned pages
  * @sg: scatter gather list which is used to pack a request (protected?)
+ * @sg_n: amount of elements in sg array
  * @chan_list: linked list of channels
  *
  * We keep all per-channel information in a structure.
@@ -78,6 +79,7 @@ struct virtio_chan {
 	unsigned long p9_max_pages;
 	/* Scatterlist: can be too big for stack. */
 	struct scatterlist *sg;
+	size_t sg_n;
 	/**
 	 * @tag: name to identify a mount null terminated
 	 */
@@ -270,12 +272,12 @@ p9_virtio_request(struct p9_client *client, struct p9_req_t *req)
 	out_sgs = in_sgs = 0;
 	/* Handle out VirtIO ring buffers */
 	out = pack_sg_list(chan->sg, 0,
-			   VIRTQUEUE_NUM, req->tc.sdata, req->tc.size);
+			   chan->sg_n, req->tc.sdata, req->tc.size);
 	if (out)
 		sgs[out_sgs++] = chan->sg;
 
 	in = pack_sg_list(chan->sg, out,
-			  VIRTQUEUE_NUM, req->rc.sdata, req->rc.capacity);
+			  chan->sg_n, req->rc.sdata, req->rc.capacity);
 	if (in)
 		sgs[out_sgs + in_sgs++] = chan->sg + out;
 
@@ -447,14 +449,14 @@ p9_virtio_zc_request(struct p9_client *client, struct p9_req_t *req,
 
 	/* out data */
 	out = pack_sg_list(chan->sg, 0,
-			   VIRTQUEUE_NUM, req->tc.sdata, req->tc.size);
+			   chan->sg_n, req->tc.sdata, req->tc.size);
 
 	if (out)
 		sgs[out_sgs++] = chan->sg;
 
 	if (out_pages) {
 		sgs[out_sgs++] = chan->sg + out;
-		out += pack_sg_list_p(chan->sg, out, VIRTQUEUE_NUM,
+		out += pack_sg_list_p(chan->sg, out, chan->sg_n,
 				      out_pages, out_nr_pages, offs, outlen);
 	}
 
@@ -466,13 +468,13 @@ p9_virtio_zc_request(struct p9_client *client, struct p9_req_t *req,
 	 * allocated memory and payload onto the user buffer.
 	 */
 	in = pack_sg_list(chan->sg, out,
-			  VIRTQUEUE_NUM, req->rc.sdata, in_hdr_len);
+			  chan->sg_n, req->rc.sdata, in_hdr_len);
 	if (in)
 		sgs[out_sgs + in_sgs++] = chan->sg + out;
 
 	if (in_pages) {
 		sgs[out_sgs + in_sgs++] = chan->sg + out + in;
-		in += pack_sg_list_p(chan->sg, out + in, VIRTQUEUE_NUM,
+		in += pack_sg_list_p(chan->sg, out + in, chan->sg_n,
 				     in_pages, in_nr_pages, offs, inlen);
 	}
 
@@ -574,13 +576,14 @@ static int p9_virtio_probe(struct virtio_device *vdev)
 		goto fail;
 	}
 
-	chan->sg = kmalloc_array(VIRTQUEUE_NUM,
+	chan->sg = kmalloc_array(VIRTQUEUE_DEFAULT_NUM,
 				 sizeof(struct scatterlist), GFP_KERNEL);
 	if (!chan->sg) {
 		pr_err("Failed to allocate virtio 9P channel\n");
 		err = -ENOMEM;
 		goto out_free_chan_shallow;
 	}
+	chan->sg_n = VIRTQUEUE_DEFAULT_NUM;
 
 	chan->vdev = vdev;
 
@@ -593,7 +596,7 @@ static int p9_virtio_probe(struct virtio_device *vdev)
 	chan->vq->vdev->priv = chan;
 	spin_lock_init(&chan->lock);
 
-	sg_init_table(chan->sg, VIRTQUEUE_NUM);
+	sg_init_table(chan->sg, chan->sg_n);
 
 	chan->inuse = false;
 	if (virtio_has_feature(vdev, VIRTIO_9P_MOUNT_TAG)) {
@@ -777,7 +780,7 @@ static struct p9_trans_module p9_virtio_trans = {
 	 * that are not at page boundary, that can result in an extra
 	 * page in zero copy.
 	 */
-	.maxsize = PAGE_SIZE * (VIRTQUEUE_NUM - 3),
+	.maxsize = PAGE_SIZE * (VIRTQUEUE_DEFAULT_NUM - 3),
 	.def = 1,
 	.owner = THIS_MODULE,
 };
-- 
2.30.2

