Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4113140EAD8
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 21:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbhIPTcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 15:32:09 -0400
Received: from lizzy.crudebyte.com ([91.194.90.13]:43941 "EHLO
        lizzy.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232803AbhIPTcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 15:32:03 -0400
X-Greylist: delayed 1649 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Sep 2021 15:32:03 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=lizzy; h=Cc:To:Subject:Date:From:References:In-Reply-To:
        Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
        Content-Description; bh=TXDvTjl8s9XWBla6TKW7Otq0soo3twuHwJi7HEGU8Sk=; b=SFDPZ
        QU375PVlK9KG1T8AmoNIEkV7YyIOBZpuRgXjkCTi37UBGFcSb6GEbvz5TO57a1kLCtG6d2lSK+qEE
        vcj7f1pDItzEo0+bTw2WGHuk0YQ390tkr0uAsQoUBiJwXteautFU4HrzpKw016Ove00GhRZEru3r3
        sTwsQPM9hDr9xpGaIqIXl1VMbEf+Nu64/I0PE4LrKV96XeIeH4ACvUovoKhWTka8U9q36NYsUn4vZ
        VWtYW7UFdwPYqyFV+7lIhZnbBVuDl62G7YsIxaTLzP09NVeNchOE5WU/8quXRzjt/xj+VPg8YnBtO
        FFLruiAy60QpT7RNqEO+UXWghWzVQ==;
Message-Id: <810050b76b9b04f045e3d21b0082358ea3f21391.1631816768.git.linux_oss@crudebyte.com>
In-Reply-To: <cover.1631816768.git.linux_oss@crudebyte.com>
References: <cover.1631816768.git.linux_oss@crudebyte.com>
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
Date:   Thu, 16 Sep 2021 20:25:16 +0200
Subject: [PATCH 6/7] 9p/trans_virtio: support larger msize values
To:     v9fs-developer@lists.sourceforge.net
Cc:     netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The virtio transport supports by default a 9p 'msize' of up to
approximately 500 kB. This patches adds support for larger 'msize'
values by resizing the amount of scatter/gather lists if required.

Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
---
 net/9p/trans_virtio.c | 52 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 1a45e0df2336..1f9a0283d7b8 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -195,6 +195,30 @@ static struct virtqueue_sg *vq_sg_alloc(unsigned int nsgl)
 	return vq_sg;
 }
 
+/**
+ * Resize passed virtqueue scatter/gather lists to the passed amount of
+ * list blocks.
+ * @_vq_sg: scatter/gather lists to be resized
+ * @nsgl: new amount of scatter/gather list blocks
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
+	*_vq_sg = vq_sg;
+	return 0;
+}
+
 /**
  * p9_virtio_close - reclaim resources of a channel
  * @client: client instance
@@ -766,6 +790,10 @@ p9_virtio_create(struct p9_client *client, const char *devname, char *args)
 	struct virtio_chan *chan;
 	int ret = -ENOENT;
 	int found = 0;
+#if !defined(CONFIG_ARCH_NO_SG_CHAIN)
+	size_t npages;
+	size_t nsgl;
+#endif
 
 	if (devname == NULL)
 		return -EINVAL;
@@ -788,6 +816,30 @@ p9_virtio_create(struct p9_client *client, const char *devname, char *args)
 		return ret;
 	}
 
+	/*
+	 * if user supplied an 'msize' option that's larger than what this
+	 * transport supports by default, then try to allocate more sg lists
+	 */
+	if (client->msize > client->trans_maxsize) {
+#if !defined(CONFIG_ARCH_NO_SG_CHAIN)
+		npages = DIV_ROUND_UP(client->msize, PAGE_SIZE);
+		if (npages > chan->p9_max_pages)
+			npages = chan->p9_max_pages;
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
+#endif /* !defined(CONFIG_ARCH_NO_SG_CHAIN) */
+	}
+
 	client->trans = (void *)chan;
 	client->status = Connected;
 	chan->client = client;
-- 
2.20.1

