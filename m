Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336D51F0BD9
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 16:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgFGON0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 10:13:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33513 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726640AbgFGOLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 10:11:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591539093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iYrqJxiCF6JLs18Hde8abAzaxAcz1G1OwYlHg0/kUqs=;
        b=JT7aQfHenh1+cHBEeUl1RDoGsTN18q442V6AsU9INhtgI5u9gTtB13JfObo7MGI+/Ei1ki
        2WYhAk8EeK9T3L3UFVJuIsvUlBUhhnfFsOa8d/I34VJnOm5DpOlrkzzjsJjo7x71GMpoBz
        2bi6K8jPK8Cq+ZgfrBiKtUzKJ3IjJuk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-Ou_gx_SWPyabRlO-OCVTDg-1; Sun, 07 Jun 2020 10:11:31 -0400
X-MC-Unique: Ou_gx_SWPyabRlO-OCVTDg-1
Received: by mail-wm1-f69.google.com with SMTP id h6so3391320wmb.7
        for <netdev@vger.kernel.org>; Sun, 07 Jun 2020 07:11:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=iYrqJxiCF6JLs18Hde8abAzaxAcz1G1OwYlHg0/kUqs=;
        b=sSW5xSerpb19zSif01MOk3JVKewRrbgF26+y4Gp1hral3rz0kzjsa5Q3UbQpTNgV5O
         S/RebqSjPvJvNxoIcqbD3ADAMM5bK21nBVz/surbDSx1qAESnvhuEmaEnEXTpeQRoqCy
         xsy/HR7s7YLWN4r1gRjWOetkeCAEX2WsvdzVqZMhgjrAdE1SXk6j9ANeu+rRjo81R8rG
         HmP02Pla+84gSnFzD7hWNAc/OsKYETb3JDAcLsANspvCWGAc28+h+8+2MH8RULUa3SzZ
         g/eQhZdbC9F0QuWnhS+0pQXf0POxBJGEn1bF8ld5uS4KYeaG1cqD51QI50tQj9NEwpIv
         8htg==
X-Gm-Message-State: AOAM533cJVJ8CSNCSqCyq8lSwxwnzPHgmJ+tGs3Ti0UNJXqk1tSM58Ag
        nCr/X17GvybfI35ud2XuLWDrk5Gvo2gzuHPB7XmL5HiSjYcODINOljWtFBue9WM+Z4c/Bgkg4ii
        iB1X1o7hdu3IQwoTI
X-Received: by 2002:adf:eacc:: with SMTP id o12mr19623006wrn.139.1591539090642;
        Sun, 07 Jun 2020 07:11:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfd2gP3crUhrnMObq7YNTh1ror2xnNGnauOq/HrdRRvHGMKoTNmmtC928LfI9zGfAJy7zCWQ==
X-Received: by 2002:adf:eacc:: with SMTP id o12mr19622983wrn.139.1591539090400;
        Sun, 07 Jun 2020 07:11:30 -0700 (PDT)
Received: from redhat.com (bzq-82-81-31-23.red.bezeqint.net. [82.81.31.23])
        by smtp.gmail.com with ESMTPSA id c81sm20250743wmd.42.2020.06.07.07.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 07:11:29 -0700 (PDT)
Date:   Sun, 7 Jun 2020 10:11:28 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v5 03/13] vhost: batching fetches
Message-ID: <20200607141057.704085-4-mst@redhat.com>
References: <20200607141057.704085-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200607141057.704085-1-mst@redhat.com>
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With this patch applied, new and old code perform identically.

Lots of extra optimizations are now possible, e.g.
we can fetch multiple heads with copy_from/to_user now.
We can get rid of maintaining the log array.  Etc etc.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Link: https://lore.kernel.org/r/20200401183118.8334-4-eperezma@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/test.c  |  2 +-
 drivers/vhost/vhost.c | 47 ++++++++++++++++++++++++++++++++++++++-----
 drivers/vhost/vhost.h |  3 +++
 3 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 9a3a09005e03..02806d6f84ef 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -119,7 +119,7 @@ static int vhost_test_open(struct inode *inode, struct file *f)
 	dev = &n->dev;
 	vqs[VHOST_TEST_VQ] = &n->vqs[VHOST_TEST_VQ];
 	n->vqs[VHOST_TEST_VQ].handle_kick = handle_vq_kick;
-	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
+	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV + 64,
 		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT, NULL);
 
 	f->private_data = n;
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 33a72edb3ccd..3b0609801381 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -304,6 +304,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 {
 	vq->num = 1;
 	vq->ndescs = 0;
+	vq->first_desc = 0;
 	vq->desc = NULL;
 	vq->avail = NULL;
 	vq->used = NULL;
@@ -372,6 +373,11 @@ static int vhost_worker(void *data)
 	return 0;
 }
 
+static int vhost_vq_num_batch_descs(struct vhost_virtqueue *vq)
+{
+	return vq->max_descs - UIO_MAXIOV;
+}
+
 static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
 {
 	kfree(vq->descs);
@@ -394,6 +400,9 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
 	for (i = 0; i < dev->nvqs; ++i) {
 		vq = dev->vqs[i];
 		vq->max_descs = dev->iov_limit;
+		if (vhost_vq_num_batch_descs(vq) < 0) {
+			return -EINVAL;
+		}
 		vq->descs = kmalloc_array(vq->max_descs,
 					  sizeof(*vq->descs),
 					  GFP_KERNEL);
@@ -1610,6 +1619,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 		vq->last_avail_idx = s.num;
 		/* Forget the cached index value. */
 		vq->avail_idx = vq->last_avail_idx;
+		vq->ndescs = vq->first_desc = 0;
 		break;
 	case VHOST_GET_VRING_BASE:
 		s.index = idx;
@@ -2179,7 +2189,7 @@ static int fetch_indirect_descs(struct vhost_virtqueue *vq,
 	return 0;
 }
 
-static int fetch_descs(struct vhost_virtqueue *vq)
+static int fetch_buf(struct vhost_virtqueue *vq)
 {
 	unsigned int i, head, found = 0;
 	struct vhost_desc *last;
@@ -2192,7 +2202,11 @@ static int fetch_descs(struct vhost_virtqueue *vq)
 	/* Check it isn't doing very strange things with descriptor numbers. */
 	last_avail_idx = vq->last_avail_idx;
 
-	if (vq->avail_idx == vq->last_avail_idx) {
+	if (unlikely(vq->avail_idx == vq->last_avail_idx)) {
+		/* If we already have work to do, don't bother re-checking. */
+		if (likely(vq->ndescs))
+			return vq->num;
+
 		if (unlikely(vhost_get_avail_idx(vq, &avail_idx))) {
 			vq_err(vq, "Failed to access avail idx at %p\n",
 				&vq->avail->idx);
@@ -2283,6 +2297,24 @@ static int fetch_descs(struct vhost_virtqueue *vq)
 	return 0;
 }
 
+static int fetch_descs(struct vhost_virtqueue *vq)
+{
+	int ret = 0;
+
+	if (unlikely(vq->first_desc >= vq->ndescs)) {
+		vq->first_desc = 0;
+		vq->ndescs = 0;
+	}
+
+	if (vq->ndescs)
+		return 0;
+
+	while (!ret && vq->ndescs <= vhost_vq_num_batch_descs(vq))
+		ret = fetch_buf(vq);
+
+	return vq->ndescs ? 0 : ret;
+}
+
 /* This looks in the virtqueue and for the first available buffer, and converts
  * it to an iovec for convenient access.  Since descriptors consist of some
  * number of output then some number of input descriptors, it's actually two
@@ -2308,7 +2340,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 	if (unlikely(log))
 		*log_num = 0;
 
-	for (i = 0; i < vq->ndescs; ++i) {
+	for (i = vq->first_desc; i < vq->ndescs; ++i) {
 		unsigned iov_count = *in_num + *out_num;
 		struct vhost_desc *desc = &vq->descs[i];
 		int access;
@@ -2354,14 +2386,19 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 		}
 
 		ret = desc->id;
+
+		if (!(desc->flags & VRING_DESC_F_NEXT))
+			break;
 	}
 
-	vq->ndescs = 0;
+	vq->first_desc = i + 1;
 
 	return ret;
 
 err:
-	vhost_discard_vq_desc(vq, 1);
+	for (i = vq->first_desc; i < vq->ndescs; ++i)
+		if (!(vq->descs[i].flags & VRING_DESC_F_NEXT))
+			vhost_discard_vq_desc(vq, 1);
 	vq->ndescs = 0;
 
 	return ret;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 8a7b4191bc48..fed36af5c444 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -81,6 +81,7 @@ struct vhost_virtqueue {
 
 	struct vhost_desc *descs;
 	int ndescs;
+	int first_desc;
 	int max_descs;
 
 	struct file *kick;
@@ -257,6 +258,8 @@ static inline void vhost_vq_set_backend(struct vhost_virtqueue *vq,
 					void *private_data)
 {
 	vq->private_data = private_data;
+	vq->ndescs = 0;
+	vq->first_desc = 0;
 }
 
 /**
-- 
MST

