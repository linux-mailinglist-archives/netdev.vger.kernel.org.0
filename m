Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702285720C0
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbiGLQZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234316AbiGLQZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:25:51 -0400
X-Greylist: delayed 1805 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 12 Jul 2022 09:25:45 PDT
Received: from lizzy.crudebyte.com (lizzy.crudebyte.com [91.194.90.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13876CB469;
        Tue, 12 Jul 2022 09:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=WkWVLOzQWUJG7V+0cVVMnUDBPNnlBLlSNA5Xuhzm6pA=; b=aD16h
        5gXIacLM+1mKsQucP0kvMs1Fpx/v64jPPsvNzeW35TGuWfoYzMytlBfHhPvf1oSvRoOZYe7qUsak/
        I5koC434XT/m9d7E1GifFFjL7pDTkR+SVID+/2TwUktPRkkVPOjVv9mTjKx2M27cY10xKMKXBdEz6
        9AOmdn8Q4W62X7I5kimxR867tOz/Djt7vwLmwvvzIYlZjuQPmOz90o+Zb+AzTkhMcltdtGewF0bMn
        P8Xvfzi9DywTt7BEd5oitWJBS9Ct0G48T2z6HqNO6qTCzttKIpUBojl2l1dASWXsqH9lyuFavuQUY
        pZdvZnsMOn5Szx/T9Vhfa/K3K0m0Q==;
Message-Id: <7c0f01dec9b91f9d9f034f02d2c04e70c456aa68.1657636554.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1657636554.git.linux_oss@crudebyte.com>
References: <cover.1657636554.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Tue, 12 Jul 2022 16:31:21 +0200
Subject: [PATCH v5 05/11] 9p/trans_virtio: support larger msize values
To:     v9fs-developer@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Nikolay Kichukov <nikolay@oldum.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The virtio transport supports by default a 9p 'msize' of up to
approximately 500 kB. This patch adds support for larger 'msize'
values by resizing the amount of scatter/gather lists if required.

Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
---

I am not sure if it is safe the way SG lists are resized here. I "think"
Dominique said before there should be no concurrency here, but probably
deserves a revisit.

 net/9p/trans_virtio.c | 61 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index f63cd1b08bca..51c48741ff20 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -203,6 +203,31 @@ static struct virtqueue_sg *vq_sg_alloc(unsigned int nsgl)
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
@@ -774,6 +799,10 @@ p9_virtio_create(struct p9_client *client, const char *devname, char *args)
 	struct virtio_chan *chan;
 	int ret = -ENOENT;
 	int found = 0;
+#if !defined(CONFIG_ARCH_NO_SG_CHAIN)
+	size_t npages;
+	size_t nsgl;
+#endif
 
 	if (devname == NULL)
 		return -EINVAL;
@@ -796,6 +825,38 @@ p9_virtio_create(struct p9_client *client, const char *devname, char *args)
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
+		if (npages > chan->p9_max_pages) {
+			npages = chan->p9_max_pages;
+			pr_info("limiting 'msize' as it would exceed the max. "
+				"of %lu pages allowed on this system\n",
+				chan->p9_max_pages);
+		}
+		nsgl = DIV_ROUND_UP(npages, SG_USER_PAGES_PER_LIST);
+		if (nsgl > chan->vq_sg->nsgl) {
+			/*
+			 * if resize fails, no big deal, then just
+			 * continue with default msize instead
+			 */
+			if (!vq_sg_resize(&chan->vq_sg, nsgl)) {
+				client->trans_maxsize =
+					PAGE_SIZE *
+					((nsgl * SG_USER_PAGES_PER_LIST) - 3);
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

