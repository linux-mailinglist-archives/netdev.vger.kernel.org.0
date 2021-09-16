Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B9D40EADC
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 21:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232968AbhIPTcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 15:32:22 -0400
Received: from lizzy.crudebyte.com ([91.194.90.13]:37447 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232443AbhIPTcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 15:32:18 -0400
X-Greylist: delayed 1674 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Sep 2021 15:32:17 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=EE1PQoTr65gLqF9Zd//gRGufG4271sl/4im8BHyowOk=; b=GHk1Y
        x+xk4wzuG4nQHjAPhZ4zg7EcLQ9pHYJiwXcpGw6ZdGmS8z/WeHeuJMlodrtBC5iUZSuc8te5fKTNA
        3dZbr7Kp2JOY0YOccrMCjc979GUlC73tZfWis0vKTExGqsZu8zzm48xpSLnkRfBblaR7ggIbk+WvF
        dZQlAm+A0Qp8uAFODK3iM9ReSfzU+1uXWpR87JXCBPKfEhltI85JmZCRn4GSWCKTHEOiFiOd9JGeb
        po43FW0AR2MO6fMtjeTWkpPfMsdwwR0jgmDCEewo/YkM0kEoJzxILCHhEUw/iVkH/ng8/MsTWuNIG
        DY7+Q8Ol+EggEw/q3p86/XGv/65DA==;
Message-Id: <d64689b15f8bd70ccb76163fabf1dcdb85bf96b1.1631816768.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1631816768.git.linux_oss@crudebyte.com>
References: <cover.1631816768.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Thu, 16 Sep 2021 20:25:02 +0200
Subject: [PATCH 4/7] 9p/trans_virtio: introduce struct virtqueue_sg
To:     v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The amount of elements in a scatter/gather list is limited to
approximately 128 elements. To allow going beyond that limit
with subsequent patches, pave the way by turning the one-
dimensional sg list array into a two-dimensional array, i.e:

  sg[128]

becomes

  sgl[nsgl][SG_MAX_SINGLE_ALLOC]

As the value of 'nsgl' is exactly (still) 1 in this commit
and the compile-time (compiler and architecture dependent)
value of 'SG_MAX_SINGLE_ALLOC' equals approximately the
previous hard coded 128 elements, this commit is therefore
more of a preparotory refactoring then actual behaviour
change.

A custom struct virtqueue_sg is defined instead of using
shared API struct sg_table, because the latter would not
allow to resize the table after allocation. sg_append_table
API OTOH would not fit either, because it requires a list
of pages beforehand upon allocation. And both APIs only
support all-or-nothing allocation.

Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
---
 net/9p/trans_virtio.c | 185 +++++++++++++++++++++++++++++++-----------
 1 file changed, 139 insertions(+), 46 deletions(-)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 3347d35a5e6e..1a45e0df2336 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -36,7 +36,30 @@
 #include <linux/virtio_9p.h>
 #include "trans_common.h"
 
-#define VIRTQUEUE_DEFAULT_NUM	128
+/**
+ * (chained) scatter gather lists for virtqueue data transmission
+ */
+struct virtqueue_sg {
+	/** amount of elements in array field @sgl */
+	unsigned int nsgl;
+	/** two-dimensional array, i.e. sgl[nsgl][SG_MAX_SINGLE_ALLOC] */
+	struct scatterlist *sgl[];
+};
+
+/*
+ * Default value for field nsgl in struct virtqueue_sg, which defines the
+ * initial virtio data transmission capacity when this virtio transport is
+ * probed.
+ */
+#define VIRTQUEUE_SG_NSGL_DEFAULT 1
+
+/* maximum value for field nsgl in struct virtqueue_sg */
+#define VIRTQUEUE_SG_NSGL_MAX						\
+	((PAGE_SIZE - sizeof(struct virtqueue_sg)) /			\
+	sizeof(struct scatterlist *))					\
+
+/* last entry per sg list is used for chaining (pointer to next list) */
+#define SG_USER_PAGES_PER_LIST	(SG_MAX_SINGLE_ALLOC - 1)
 
 /* a single mutex to manage channel initialization and attachment */
 static DEFINE_MUTEX(virtio_9p_lock);
@@ -53,8 +76,7 @@ static atomic_t vp_pinned = ATOMIC_INIT(0);
  * @ring_bufs_avail: flag to indicate there is some available in the ring buf
  * @vc_wq: wait queue for waiting for thing to be added to ring buf
  * @p9_max_pages: maximum number of pinned pages
- * @sg: scatter gather list which is used to pack a request (protected?)
- * @sg_n: amount of elements in sg array
+ * @vq_sg: table of scatter gather lists, which are used to pack a request
  * @chan_list: linked list of channels
  *
  * We keep all per-channel information in a structure.
@@ -77,9 +99,7 @@ struct virtio_chan {
 	 * will be placing it in each channel.
 	 */
 	unsigned long p9_max_pages;
-	/* Scatterlist: can be too big for stack. */
-	struct scatterlist *sg;
-	size_t sg_n;
+	struct virtqueue_sg *vq_sg;
 	/**
 	 * @tag: name to identify a mount null terminated
 	 */
@@ -96,6 +116,85 @@ static unsigned int rest_of_page(void *data)
 	return PAGE_SIZE - offset_in_page(data);
 }
 
+/**
+ * Returns user page for given page index.
+ * @vq_sg: scatter gather lists used by this transport
+ * @page: user page index across all scatter gather lists
+ */
+static struct scatterlist *vq_sg_page(struct virtqueue_sg *vq_sg, size_t page)
+{
+	unsigned int node = page / SG_USER_PAGES_PER_LIST;
+	unsigned int leaf = page % SG_USER_PAGES_PER_LIST;
+	BUG_ON(node >= VIRTQUEUE_SG_NSGL_MAX);
+	return &vq_sg->sgl[node][leaf];
+}
+
+/**
+ * Returns total number of individual user pages in passed scatter gather
+ * lists.
+ */
+static size_t vq_sg_npages(struct virtqueue_sg *vq_sg)
+{
+	return vq_sg->nsgl * SG_USER_PAGES_PER_LIST;
+}
+
+/**
+ * free all memory previously allocated for @vq_sg
+ */
+static void vq_sg_free(struct virtqueue_sg *vq_sg)
+{
+	unsigned int i;
+
+	for (i = 0; i < vq_sg->nsgl; ++i) {
+		kfree(vq_sg->sgl[i]);
+	}
+	kfree(vq_sg);
+}
+
+/**
+ * Allocates and returns @nsgl scatter gather lists, if @nsgl is larger than
+ * one then chained lists are used (if supported by architecture).
+ */
+static struct virtqueue_sg *vq_sg_alloc(unsigned int nsgl)
+{
+	struct virtqueue_sg *vq_sg;
+	unsigned int i;
+
+	BUG_ON(!nsgl || nsgl > VIRTQUEUE_SG_NSGL_MAX);
+#ifdef CONFIG_ARCH_NO_SG_CHAIN
+	if (WARN_ON_ONCE(nsgl > 1))
+		return NULL;
+#endif
+
+	vq_sg = kzalloc(sizeof(struct virtqueue_sg) +
+			nsgl * sizeof(struct scatterlist *),
+			GFP_KERNEL);
+
+	if (!vq_sg)
+		return NULL;
+
+	vq_sg->nsgl = nsgl;
+
+	for (i = 0; i < nsgl; ++i) {
+		vq_sg->sgl[i] = kmalloc_array(
+			SG_MAX_SINGLE_ALLOC, sizeof(struct scatterlist),
+			GFP_KERNEL
+		);
+		if (!vq_sg->sgl[i]) {
+			vq_sg_free(vq_sg);
+			return NULL;
+		}
+		sg_init_table(vq_sg->sgl[i], SG_MAX_SINGLE_ALLOC);
+		if (i) {
+			/* chain the lists */
+			sg_chain(vq_sg->sgl[i - 1], SG_MAX_SINGLE_ALLOC,
+				 vq_sg->sgl[i]);
+		}
+	}
+	sg_mark_end(&vq_sg->sgl[nsgl - 1][SG_MAX_SINGLE_ALLOC - 1]);
+	return vq_sg;
+}
+
 /**
  * p9_virtio_close - reclaim resources of a channel
  * @client: client instance
@@ -158,9 +257,8 @@ static void req_done(struct virtqueue *vq)
 
 /**
  * pack_sg_list - pack a scatter gather list from a linear buffer
- * @sg: scatter/gather list to pack into
+ * @vq_sg: scatter/gather lists to pack into
  * @start: which segment of the sg_list to start at
- * @limit: maximum segment to pack data to
  * @data: data to pack into scatter/gather list
  * @count: amount of data to pack into the scatter/gather list
  *
@@ -170,11 +268,12 @@ static void req_done(struct virtqueue *vq)
  *
  */
 
-static int pack_sg_list(struct scatterlist *sg, int start,
-			int limit, char *data, int count)
+static int pack_sg_list(struct virtqueue_sg *vq_sg, int start,
+			char *data, int count)
 {
 	int s;
 	int index = start;
+	size_t limit = vq_sg_npages(vq_sg);
 
 	while (count) {
 		s = rest_of_page(data);
@@ -182,13 +281,13 @@ static int pack_sg_list(struct scatterlist *sg, int start,
 			s = count;
 		BUG_ON(index >= limit);
 		/* Make sure we don't terminate early. */
-		sg_unmark_end(&sg[index]);
-		sg_set_buf(&sg[index++], data, s);
+		sg_unmark_end(vq_sg_page(vq_sg, index));
+		sg_set_buf(vq_sg_page(vq_sg, index++), data, s);
 		count -= s;
 		data += s;
 	}
 	if (index-start)
-		sg_mark_end(&sg[index - 1]);
+		sg_mark_end(vq_sg_page(vq_sg, index - 1));
 	return index-start;
 }
 
@@ -208,21 +307,21 @@ static int p9_virtio_cancelled(struct p9_client *client, struct p9_req_t *req)
 /**
  * pack_sg_list_p - Just like pack_sg_list. Instead of taking a buffer,
  * this takes a list of pages.
- * @sg: scatter/gather list to pack into
+ * @vq_sg: scatter/gather lists to pack into
  * @start: which segment of the sg_list to start at
- * @limit: maximum number of pages in sg list.
  * @pdata: a list of pages to add into sg.
  * @nr_pages: number of pages to pack into the scatter/gather list
  * @offs: amount of data in the beginning of first page _not_ to pack
  * @count: amount of data to pack into the scatter/gather list
  */
 static int
-pack_sg_list_p(struct scatterlist *sg, int start, int limit,
+pack_sg_list_p(struct virtqueue_sg *vq_sg, int start,
 	       struct page **pdata, int nr_pages, size_t offs, int count)
 {
 	int i = 0, s;
 	int data_off = offs;
 	int index = start;
+	size_t limit = vq_sg_npages(vq_sg);
 
 	BUG_ON(nr_pages > (limit - start));
 	/*
@@ -235,15 +334,16 @@ pack_sg_list_p(struct scatterlist *sg, int start, int limit,
 			s = count;
 		BUG_ON(index >= limit);
 		/* Make sure we don't terminate early. */
-		sg_unmark_end(&sg[index]);
-		sg_set_page(&sg[index++], pdata[i++], s, data_off);
+		sg_unmark_end(vq_sg_page(vq_sg, index));
+		sg_set_page(vq_sg_page(vq_sg, index++), pdata[i++], s,
+			    data_off);
 		data_off = 0;
 		count -= s;
 		nr_pages--;
 	}
 
 	if (index-start)
-		sg_mark_end(&sg[index - 1]);
+		sg_mark_end(vq_sg_page(vq_sg, index - 1));
 	return index - start;
 }
 
@@ -271,15 +371,13 @@ p9_virtio_request(struct p9_client *client, struct p9_req_t *req)
 
 	out_sgs = in_sgs = 0;
 	/* Handle out VirtIO ring buffers */
-	out = pack_sg_list(chan->sg, 0,
-			   chan->sg_n, req->tc.sdata, req->tc.size);
+	out = pack_sg_list(chan->vq_sg, 0, req->tc.sdata, req->tc.size);
 	if (out)
-		sgs[out_sgs++] = chan->sg;
+		sgs[out_sgs++] = vq_sg_page(chan->vq_sg, 0);
 
-	in = pack_sg_list(chan->sg, out,
-			  chan->sg_n, req->rc.sdata, req->rc.capacity);
+	in = pack_sg_list(chan->vq_sg, out, req->rc.sdata, req->rc.capacity);
 	if (in)
-		sgs[out_sgs + in_sgs++] = chan->sg + out;
+		sgs[out_sgs + in_sgs++] = vq_sg_page(chan->vq_sg, out);
 
 	err = virtqueue_add_sgs(chan->vq, sgs, out_sgs, in_sgs, req,
 				GFP_ATOMIC);
@@ -448,16 +546,15 @@ p9_virtio_zc_request(struct p9_client *client, struct p9_req_t *req,
 	out_sgs = in_sgs = 0;
 
 	/* out data */
-	out = pack_sg_list(chan->sg, 0,
-			   chan->sg_n, req->tc.sdata, req->tc.size);
+	out = pack_sg_list(chan->vq_sg, 0, req->tc.sdata, req->tc.size);
 
 	if (out)
-		sgs[out_sgs++] = chan->sg;
+		sgs[out_sgs++] = vq_sg_page(chan->vq_sg, 0);
 
 	if (out_pages) {
-		sgs[out_sgs++] = chan->sg + out;
-		out += pack_sg_list_p(chan->sg, out, chan->sg_n,
-				      out_pages, out_nr_pages, offs, outlen);
+		sgs[out_sgs++] = vq_sg_page(chan->vq_sg, out);
+		out += pack_sg_list_p(chan->vq_sg, out, out_pages,
+				      out_nr_pages, offs, outlen);
 	}
 
 	/*
@@ -467,15 +564,14 @@ p9_virtio_zc_request(struct p9_client *client, struct p9_req_t *req,
 	 * Arrange in such a way that server places header in the
 	 * allocated memory and payload onto the user buffer.
 	 */
-	in = pack_sg_list(chan->sg, out,
-			  chan->sg_n, req->rc.sdata, in_hdr_len);
+	in = pack_sg_list(chan->vq_sg, out, req->rc.sdata, in_hdr_len);
 	if (in)
-		sgs[out_sgs + in_sgs++] = chan->sg + out;
+		sgs[out_sgs + in_sgs++] = vq_sg_page(chan->vq_sg, out);
 
 	if (in_pages) {
-		sgs[out_sgs + in_sgs++] = chan->sg + out + in;
-		in += pack_sg_list_p(chan->sg, out + in, chan->sg_n,
-				     in_pages, in_nr_pages, offs, inlen);
+		sgs[out_sgs + in_sgs++] = vq_sg_page(chan->vq_sg, out + in);
+		in += pack_sg_list_p(chan->vq_sg, out + in, in_pages,
+				     in_nr_pages, offs, inlen);
 	}
 
 	BUG_ON(out_sgs + in_sgs > ARRAY_SIZE(sgs));
@@ -576,14 +672,12 @@ static int p9_virtio_probe(struct virtio_device *vdev)
 		goto fail;
 	}
 
-	chan->sg = kmalloc_array(VIRTQUEUE_DEFAULT_NUM,
-				 sizeof(struct scatterlist), GFP_KERNEL);
-	if (!chan->sg) {
+	chan->vq_sg = vq_sg_alloc(VIRTQUEUE_SG_NSGL_DEFAULT);
+	if (!chan->vq_sg) {
 		pr_err("Failed to allocate virtio 9P channel\n");
 		err = -ENOMEM;
 		goto out_free_chan_shallow;
 	}
-	chan->sg_n = VIRTQUEUE_DEFAULT_NUM;
 
 	chan->vdev = vdev;
 
@@ -596,8 +690,6 @@ static int p9_virtio_probe(struct virtio_device *vdev)
 	chan->vq->vdev->priv = chan;
 	spin_lock_init(&chan->lock);
 
-	sg_init_table(chan->sg, chan->sg_n);
-
 	chan->inuse = false;
 	if (virtio_has_feature(vdev, VIRTIO_9P_MOUNT_TAG)) {
 		virtio_cread(vdev, struct virtio_9p_config, tag_len, &tag_len);
@@ -646,7 +738,7 @@ static int p9_virtio_probe(struct virtio_device *vdev)
 out_free_vq:
 	vdev->config->del_vqs(vdev);
 out_free_chan:
-	kfree(chan->sg);
+	vq_sg_free(chan->vq_sg);
 out_free_chan_shallow:
 	kfree(chan);
 fail:
@@ -741,7 +833,7 @@ static void p9_virtio_remove(struct virtio_device *vdev)
 	kobject_uevent(&(vdev->dev.kobj), KOBJ_CHANGE);
 	kfree(chan->tag);
 	kfree(chan->vc_wq);
-	kfree(chan->sg);
+	vq_sg_free(chan->vq_sg);
 	kfree(chan);
 
 }
@@ -780,7 +872,8 @@ static struct p9_trans_module p9_virtio_trans = {
 	 * that are not at page boundary, that can result in an extra
 	 * page in zero copy.
 	 */
-	.maxsize = PAGE_SIZE * (VIRTQUEUE_DEFAULT_NUM - 3),
+	.maxsize = PAGE_SIZE *
+		((VIRTQUEUE_SG_NSGL_DEFAULT * SG_USER_PAGES_PER_LIST) - 3),
 	.def = 1,
 	.owner = THIS_MODULE,
 };
-- 
2.20.1

