Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEB1414F23
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 19:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236923AbhIVRc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 13:32:29 -0400
Received: from lizzy.crudebyte.com ([91.194.90.13]:35917 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236904AbhIVRc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 13:32:27 -0400
X-Greylist: delayed 2688 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Sep 2021 13:32:26 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=c43qkPKZ3owcWwHt3qMx8G3o1c4XciboiEemqoGFbCI=; b=AjxBR
        7ffE8IiDCOe+kqeCNnk5ipXxz0AV5Z3vhf6McQquZPPh6WGSOheX434sCEng/3U2v/+PbpkCrshPp
        Nq/Zulm0XBWqWmJnSPdhnpdgHR86Ad01qFyxAZ3WWJuR3XVNtUelc0oTr12XM0OVFVpxshuRuK0OJ
        cm24hQDCf4X3MzU+w5a8BinPsMXmk3sN4IHzgetm8pmzB9dRod4SaCqZcC6GYveCXJyae/m8kt8hr
        NaPUu6GS3ancMGRTUquGh5az1UqroBiKoBOs8PnpKl+GcdryyIJec4seKyKyb+uD9JSF21QfarC7m
        BY07FPN91cAcG+BVRaZgRjD7tZDQg==;
Message-Id: <61d32571f72d56de68c317c5be998c9e641c8acf.1632327421.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1632327421.git.linux_oss@crudebyte.com>
References: <cover.1632327421.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Wed, 22 Sep 2021 18:00:26 +0200
Subject: [PATCH v3 3/7] 9p/trans_virtio: turn amount of sg lists into runtime
 info
To:     v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
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
index 1dbe2e921bb8..3347d35a5e6e 100644
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
2.20.1

