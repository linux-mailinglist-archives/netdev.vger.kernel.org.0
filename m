Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2FD576AE1
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 01:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiGOXze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 19:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiGOXzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 19:55:33 -0400
X-Greylist: delayed 1774 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 15 Jul 2022 16:55:32 PDT
Received: from lizzy.crudebyte.com (lizzy.crudebyte.com [91.194.90.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4E9904DA
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 16:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=03PxLEg7NiaMvhSBPzBFP/XCwo9SFsyuKqJNcoKWY/4=; b=FNoOh
        ADE4Hg8xvSWs3nC3arwY3n/D4KpC24+zbudVWzCQzQ9Jt44t0D4LfPFv3WNSlveHgFc6/KI89jp4e
        LC0pEv1M5mVVRvKv+N7xBo9IjLpOl+pyG+ci+ZFb00tI3deorUKHOt6ymu9Zazq4QzWQsBXP3PhGF
        2FTl5gNBAbd+9kOPgN6LEW+UHH9eTFypF8WmTbSoX4MxMbEAU7uZO4++cR3Fb04edNhHoWl3J/WaW
        qzP1rvKlrtZ2sASOR7SA6QFTOU6CcyuZMfLSKmYNzTLM2CprP6GhQJR9/AXSBVavTNCZgOZ7RWKrJ
        xLhnwIfB3xkgI3w00xTLP83GSiuGw==;
Message-Id: <ebca00c2659755411269303881aad5da8590eefe.1657920926.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1657920926.git.linux_oss@crudebyte.com>
References: <cover.1657920926.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Fri, 15 Jul 2022 23:32:22 +0200
Subject: [PATCH v6 05/11] 9p/trans_virtio: support larger msize values
To:     v9fs-developer@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The virtio transport supports by default a 9p 'msize' of up to
approximately 500 kB. This patch adds support for larger 'msize'
values by resizing the amount of scatter/gather lists if required.

To be more precise, for the moment this patch increases the 'msize'
limit for the virtio transport to slightly below 4 MB, virtio
transport actually supports much more (tested successfully with an
experimental QEMU version and some dirty 9p Linux client hacks up
to msize=128MB), but client still uses linear buffers, which in
turn are limited to KMALLOC_MAX_SIZE (4M).

Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
---

I am not sure if it is safe the way SG lists are resized here. I "think"
Dominique said before there should be no concurrency here, but probably
deserves a revisit.

 net/9p/trans_virtio.c | 79 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 5ac533f83322..921caa022570 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -36,6 +36,16 @@
 #include <linux/virtio_9p.h>
 #include "trans_common.h"
 
+/*
+ * Maximum amount of virtio descriptors allowed per virtio round-trip
+ * message.
+ *
+ * This effectively limits msize to (slightly below) 4M, virtio transport
+ * actually supports much more, but client still uses linear buffers, which
+ * in turn are limited to KMALLOC_MAX_SIZE (4M).
+ */
+#define VIRTIO_MAX_DESCRIPTORS 1024
+
 /**
  * struct virtqueue_sg - (chained) scatter gather lists for virtqueue data
  * transmission
@@ -203,6 +213,31 @@ static struct virtqueue_sg *vq_sg_alloc(unsigned int nsgl)
 	return vq_sg;
 }
 
+/**
+ * vq_sg_resize - resize passed virtqueue scatter/gather lists to the passed
+ * amount of lists
+ * @_vq_sg: scatter/gather lists to be resized
+ * @nsgl: new amount of scatter/gather lists
+ */
+static int vq_sg_resize(struct virtqueue_sg **_vq_sg, unsigned int nsgl)
+{
+	struct virtqueue_sg *vq_sg;
+
+	BUG_ON(!_vq_sg || !nsgl);
+	vq_sg = *_vq_sg;
+	if (vq_sg->nsgl == nsgl)
+		return 0;
+
+	/* lazy resize implementation for now */
+	vq_sg = vq_sg_alloc(nsgl);
+	if (!vq_sg)
+		return -ENOMEM;
+
+	kfree(*_vq_sg);
+	*_vq_sg = vq_sg;
+	return 0;
+}
+
 /**
  * p9_virtio_close - reclaim resources of a channel
  * @client: client instance
@@ -774,6 +809,10 @@ p9_virtio_create(struct p9_client *client, const char *devname, char *args)
 	struct virtio_chan *chan;
 	int ret = -ENOENT;
 	int found = 0;
+#if !defined(CONFIG_ARCH_NO_SG_CHAIN)
+	size_t npages;
+	size_t nsgl;
+#endif
 
 	if (devname == NULL)
 		return -EINVAL;
@@ -796,6 +835,46 @@ p9_virtio_create(struct p9_client *client, const char *devname, char *args)
 		return ret;
 	}
 
+	/*
+	 * if user supplied an 'msize' option that's larger than what this
+	 * transport supports by default, then try to allocate more sg lists
+	 */
+	if (client->msize > client->trans_maxsize) {
+#ifdef CONFIG_ARCH_NO_SG_CHAIN
+		pr_info("limiting 'msize' to %d because architecture does not "
+			"support chained scatter gather lists\n",
+			client->trans_maxsize);
+#else
+		npages = DIV_ROUND_UP(client->msize, PAGE_SIZE);
+		if (npages > VIRTIO_MAX_DESCRIPTORS)
+			npages = VIRTIO_MAX_DESCRIPTORS;
+		if (npages > chan->p9_max_pages) {
+			npages = chan->p9_max_pages;
+			pr_info("limiting 'msize' as it would exceed the max. "
+				"of %lu pages allowed on this system\n",
+				chan->p9_max_pages);
+		}
+		nsgl = DIV_ROUND_UP(npages, SG_USER_PAGES_PER_LIST);
+		if (nsgl > chan->vq_sg->nsgl) {
+			/*
+			 * if resize fails, no big deal, then just continue with
+			 * whatever we got
+			 */
+			if (!vq_sg_resize(&chan->vq_sg, nsgl)) {
+				/*
+				 * decrement 2 pages as both 9p request and 9p reply have
+				 * to fit into the virtio round-trip message
+				 */
+				client->trans_maxsize =
+					PAGE_SIZE *
+					clamp_t(int,
+						(nsgl * SG_USER_PAGES_PER_LIST) - 2,
+						0, VIRTIO_MAX_DESCRIPTORS - 2);
+			}
+		}
+#endif /* CONFIG_ARCH_NO_SG_CHAIN */
+	}
+
 	client->trans = (void *)chan;
 	client->status = Connected;
 	chan->client = client;
-- 
2.30.2

