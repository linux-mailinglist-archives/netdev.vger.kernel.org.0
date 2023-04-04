Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 548DA6D6299
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 15:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235195AbjDDNSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 09:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235130AbjDDNSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 09:18:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012F440F1
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 06:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680614243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5+j90d7rBkDEui3T++uyHXPVDxBlbuDpVes+xz42QoY=;
        b=e/LksIc7QaiNoadSThnLoi4EoEy7PAlRaPK0z91HtuoJ0IrN2XJF7idav9lLCwf1reGcMe
        nTy35vnBdxSA3q7efQnUqoHdQpWjri41g+SIEUvi+C+/r1OU54PTVySDlVzVGfF+bpXY4b
        twoPgzKyzYAZ8yzP9eryoFyJMvTgyoc=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-gKjBMxfCM4ySLYnWGjdHag-1; Tue, 04 Apr 2023 09:17:21 -0400
X-MC-Unique: gKjBMxfCM4ySLYnWGjdHag-1
Received: by mail-qt1-f198.google.com with SMTP id a19-20020a05622a02d300b003e4ecb5f613so16595554qtx.21
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 06:17:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680614241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5+j90d7rBkDEui3T++uyHXPVDxBlbuDpVes+xz42QoY=;
        b=VJg8UhQF6j44RGWoGMnoYo92x60cVYHOSX3ifj1irEYEt2ptodwJLyLSQloCstf+2g
         D7MUWqZkwlNK9CGDzcmL7s6KC7p7BZtXJ4blMh7tTdt9WwWqVDZG+byY1BIkfOoI6YWc
         zhNSlf/6oUmh5DWzBrznaBOE7V6c5uCr8pTI5J9a9MmZKafVVevYwZqYRQ/dYz3mW0Zg
         5chqgoqyy9j88Uw15L3sRLaJd9eDazhDYLa2vMjhucg+R7dInjQlFaYEYY4n1Mqu9OQG
         vvPO7tEirc1FOj2sYgqBA3gg3u8vyG26XjFZkSCNKdSDH9GhePv/EHfO0xGONk2GLbla
         fvvg==
X-Gm-Message-State: AAQBX9f+ZaqY7g9jXw29tGflJGNLdO7Q4ZPJhs8nw2O5Te87PqWk3lUO
        IOQfnG2ff/AfsSVlj1Y/2NmQURExjxQOvKO7bKyvPHy5HB15RVrbSEunKBc8EkLLvA19SVkfA74
        drQ/4AWeqcLX5Siea
X-Received: by 2002:ad4:5dc6:0:b0:56e:a7d9:b132 with SMTP id m6-20020ad45dc6000000b0056ea7d9b132mr3521436qvh.22.1680614241022;
        Tue, 04 Apr 2023 06:17:21 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y50TQwK55uGUUh/duRDHDJdzzdNUZvzPuM3jHZqeDjgERv+AB12fRT01et3420FVOVCvnT9A==
X-Received: by 2002:ad4:5dc6:0:b0:56e:a7d9:b132 with SMTP id m6-20020ad45dc6000000b0056ea7d9b132mr3521400qvh.22.1680614240717;
        Tue, 04 Apr 2023 06:17:20 -0700 (PDT)
Received: from step1.redhat.com (host-82-53-134-157.retail.telecomitalia.it. [82.53.134.157])
        by smtp.gmail.com with ESMTPSA id u7-20020a05621411a700b005dd8b9345ccsm3334226qvv.100.2023.04.04.06.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 06:17:19 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     stefanha@redhat.com,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        kvm@vger.kernel.org, eperezma@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v5 5/9] vringh: support VA with iotlb
Date:   Tue,  4 Apr 2023 15:17:16 +0200
Message-Id: <20230404131716.45855-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404131326.44403-1-sgarzare@redhat.com>
References: <20230404131326.44403-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,PP_MIME_FAKE_ASCII_TEXT,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vDPA supports the possibility to use user VA in the iotlb messages.
So, let's add support for user VA in vringh to use it in the vDPA
simulators.

Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---

Notes:
    v5:
    - s/userpace/userspace/ in the vringh_init_iotlb_va doc [Simon]
    v4:
    - used uintptr_t for `io_addr` [Eugenio]
    - added `io_addr` and `io_len` variables in iotlb_translate
    - avoided overflow doing `map->addr - map->start + addr` [Jason]
    - removed `is_iovec` field from struct iotlb_vec [Jason]
    - added vringh_init_iotlb_va() [Jason]
    v3:
    - refactored avoiding code duplication [Eugenio]
    v2:
    - replace kmap_atomic() with kmap_local_page() [see previous patch]
    - fix cast warnings when build with W=1 C=1

 include/linux/vringh.h |   9 +++
 drivers/vhost/vringh.c | 171 +++++++++++++++++++++++++++++++++--------
 2 files changed, 148 insertions(+), 32 deletions(-)

diff --git a/include/linux/vringh.h b/include/linux/vringh.h
index 1991a02c6431..b4edfadf5479 100644
--- a/include/linux/vringh.h
+++ b/include/linux/vringh.h
@@ -32,6 +32,9 @@ struct vringh {
 	/* Can we get away with weak barriers? */
 	bool weak_barriers;
 
+	/* Use user's VA */
+	bool use_va;
+
 	/* Last available index we saw (ie. where we're up to). */
 	u16 last_avail_idx;
 
@@ -284,6 +287,12 @@ int vringh_init_iotlb(struct vringh *vrh, u64 features,
 		      struct vring_avail *avail,
 		      struct vring_used *used);
 
+int vringh_init_iotlb_va(struct vringh *vrh, u64 features,
+			 unsigned int num, bool weak_barriers,
+			 struct vring_desc *desc,
+			 struct vring_avail *avail,
+			 struct vring_used *used);
+
 int vringh_getdesc_iotlb(struct vringh *vrh,
 			 struct vringh_kiov *riov,
 			 struct vringh_kiov *wiov,
diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 4aee230f7622..ab95160dcdd9 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1094,10 +1094,17 @@ EXPORT_SYMBOL(vringh_need_notify_kern);
 
 #if IS_REACHABLE(CONFIG_VHOST_IOTLB)
 
+struct iotlb_vec {
+	union {
+		struct iovec *iovec;
+		struct bio_vec *bvec;
+	} iov;
+	size_t count;
+};
+
 static int iotlb_translate(const struct vringh *vrh,
 			   u64 addr, u64 len, u64 *translated,
-			   struct bio_vec iov[],
-			   int iov_size, u32 perm)
+			   struct iotlb_vec *ivec, u32 perm)
 {
 	struct vhost_iotlb_map *map;
 	struct vhost_iotlb *iotlb = vrh->iotlb;
@@ -1107,9 +1114,11 @@ static int iotlb_translate(const struct vringh *vrh,
 	spin_lock(vrh->iotlb_lock);
 
 	while (len > s) {
-		u64 size, pa, pfn;
+		uintptr_t io_addr;
+		size_t io_len;
+		u64 size;
 
-		if (unlikely(ret >= iov_size)) {
+		if (unlikely(ret >= ivec->count)) {
 			ret = -ENOBUFS;
 			break;
 		}
@@ -1124,10 +1133,22 @@ static int iotlb_translate(const struct vringh *vrh,
 		}
 
 		size = map->size - addr + map->start;
-		pa = map->addr + addr - map->start;
-		pfn = pa >> PAGE_SHIFT;
-		bvec_set_page(&iov[ret], pfn_to_page(pfn), min(len - s, size),
-			      pa & (PAGE_SIZE - 1));
+		io_len = min(len - s, size);
+		io_addr = map->addr - map->start + addr;
+
+		if (vrh->use_va) {
+			struct iovec *iovec = ivec->iov.iovec;
+
+			iovec[ret].iov_len = io_len;
+			iovec[ret].iov_base = (void __user *)io_addr;
+		} else {
+			u64 pfn = io_addr >> PAGE_SHIFT;
+			struct bio_vec *bvec = ivec->iov.bvec;
+
+			bvec_set_page(&bvec[ret], pfn_to_page(pfn), io_len,
+				      io_addr & (PAGE_SIZE - 1));
+		}
+
 		s += size;
 		addr += size;
 		++ret;
@@ -1146,23 +1167,36 @@ static int iotlb_translate(const struct vringh *vrh,
 static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
 				  void *src, size_t len)
 {
+	struct iotlb_vec ivec;
+	union {
+		struct iovec iovec[IOTLB_IOV_STRIDE];
+		struct bio_vec bvec[IOTLB_IOV_STRIDE];
+	} iov;
 	u64 total_translated = 0;
 
+	ivec.iov.iovec = iov.iovec;
+	ivec.count = IOTLB_IOV_STRIDE;
+
 	while (total_translated < len) {
-		struct bio_vec iov[IOTLB_IOV_STRIDE];
 		struct iov_iter iter;
 		u64 translated;
 		int ret;
 
 		ret = iotlb_translate(vrh, (u64)(uintptr_t)src,
 				      len - total_translated, &translated,
-				      iov, ARRAY_SIZE(iov), VHOST_MAP_RO);
+				      &ivec, VHOST_MAP_RO);
 		if (ret == -ENOBUFS)
-			ret = ARRAY_SIZE(iov);
+			ret = IOTLB_IOV_STRIDE;
 		else if (ret < 0)
 			return ret;
 
-		iov_iter_bvec(&iter, ITER_SOURCE, iov, ret, translated);
+		if (vrh->use_va) {
+			iov_iter_init(&iter, ITER_SOURCE, ivec.iov.iovec, ret,
+				      translated);
+		} else {
+			iov_iter_bvec(&iter, ITER_SOURCE, ivec.iov.bvec, ret,
+				      translated);
+		}
 
 		ret = copy_from_iter(dst, translated, &iter);
 		if (ret < 0)
@@ -1179,23 +1213,36 @@ static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
 static inline int copy_to_iotlb(const struct vringh *vrh, void *dst,
 				void *src, size_t len)
 {
+	struct iotlb_vec ivec;
+	union {
+		struct iovec iovec[IOTLB_IOV_STRIDE];
+		struct bio_vec bvec[IOTLB_IOV_STRIDE];
+	} iov;
 	u64 total_translated = 0;
 
+	ivec.iov.iovec = iov.iovec;
+	ivec.count = IOTLB_IOV_STRIDE;
+
 	while (total_translated < len) {
-		struct bio_vec iov[IOTLB_IOV_STRIDE];
 		struct iov_iter iter;
 		u64 translated;
 		int ret;
 
 		ret = iotlb_translate(vrh, (u64)(uintptr_t)dst,
 				      len - total_translated, &translated,
-				      iov, ARRAY_SIZE(iov), VHOST_MAP_WO);
+				      &ivec, VHOST_MAP_WO);
 		if (ret == -ENOBUFS)
-			ret = ARRAY_SIZE(iov);
+			ret = IOTLB_IOV_STRIDE;
 		else if (ret < 0)
 			return ret;
 
-		iov_iter_bvec(&iter, ITER_DEST, iov, ret, translated);
+		if (vrh->use_va) {
+			iov_iter_init(&iter, ITER_DEST, ivec.iov.iovec, ret,
+				      translated);
+		} else {
+			iov_iter_bvec(&iter, ITER_DEST, ivec.iov.bvec, ret,
+				      translated);
+		}
 
 		ret = copy_to_iter(src, translated, &iter);
 		if (ret < 0)
@@ -1212,20 +1259,36 @@ static inline int copy_to_iotlb(const struct vringh *vrh, void *dst,
 static inline int getu16_iotlb(const struct vringh *vrh,
 			       u16 *val, const __virtio16 *p)
 {
-	struct bio_vec iov;
-	void *kaddr, *from;
+	struct iotlb_vec ivec;
+	union {
+		struct iovec iovec[1];
+		struct bio_vec bvec[1];
+	} iov;
+	__virtio16 tmp;
 	int ret;
 
+	ivec.iov.iovec = iov.iovec;
+	ivec.count = 1;
+
 	/* Atomic read is needed for getu16 */
-	ret = iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p), NULL,
-			      &iov, 1, VHOST_MAP_RO);
+	ret = iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p),
+			      NULL, &ivec, VHOST_MAP_RO);
 	if (ret < 0)
 		return ret;
 
-	kaddr = kmap_local_page(iov.bv_page);
-	from = kaddr + iov.bv_offset;
-	*val = vringh16_to_cpu(vrh, READ_ONCE(*(__virtio16 *)from));
-	kunmap_local(kaddr);
+	if (vrh->use_va) {
+		ret = __get_user(tmp, (__virtio16 __user *)ivec.iov.iovec[0].iov_base);
+		if (ret)
+			return ret;
+	} else {
+		void *kaddr = kmap_local_page(ivec.iov.bvec[0].bv_page);
+		void *from = kaddr + ivec.iov.bvec[0].bv_offset;
+
+		tmp = READ_ONCE(*(__virtio16 *)from);
+		kunmap_local(kaddr);
+	}
+
+	*val = vringh16_to_cpu(vrh, tmp);
 
 	return 0;
 }
@@ -1233,20 +1296,36 @@ static inline int getu16_iotlb(const struct vringh *vrh,
 static inline int putu16_iotlb(const struct vringh *vrh,
 			       __virtio16 *p, u16 val)
 {
-	struct bio_vec iov;
-	void *kaddr, *to;
+	struct iotlb_vec ivec;
+	union {
+		struct iovec iovec;
+		struct bio_vec bvec;
+	} iov;
+	__virtio16 tmp;
 	int ret;
 
+	ivec.iov.iovec = &iov.iovec;
+	ivec.count = 1;
+
 	/* Atomic write is needed for putu16 */
-	ret = iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p), NULL,
-			      &iov, 1, VHOST_MAP_WO);
+	ret = iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p),
+			      NULL, &ivec, VHOST_MAP_RO);
 	if (ret < 0)
 		return ret;
 
-	kaddr = kmap_local_page(iov.bv_page);
-	to = kaddr + iov.bv_offset;
-	WRITE_ONCE(*(__virtio16 *)to, cpu_to_vringh16(vrh, val));
-	kunmap_local(kaddr);
+	tmp = cpu_to_vringh16(vrh, val);
+
+	if (vrh->use_va) {
+		ret = __put_user(tmp, (__virtio16 __user *)ivec.iov.iovec[0].iov_base);
+		if (ret)
+			return ret;
+	} else {
+		void *kaddr = kmap_local_page(ivec.iov.bvec[0].bv_page);
+		void *to = kaddr + ivec.iov.bvec[0].bv_offset;
+
+		WRITE_ONCE(*(__virtio16 *)to, tmp);
+		kunmap_local(kaddr);
+	}
 
 	return 0;
 }
@@ -1320,11 +1399,39 @@ int vringh_init_iotlb(struct vringh *vrh, u64 features,
 		      struct vring_avail *avail,
 		      struct vring_used *used)
 {
+	vrh->use_va = false;
+
 	return vringh_init_kern(vrh, features, num, weak_barriers,
 				desc, avail, used);
 }
 EXPORT_SYMBOL(vringh_init_iotlb);
 
+/**
+ * vringh_init_iotlb_va - initialize a vringh for a ring with IOTLB containing
+ *                        user VA.
+ * @vrh: the vringh to initialize.
+ * @features: the feature bits for this ring.
+ * @num: the number of elements.
+ * @weak_barriers: true if we only need memory barriers, not I/O.
+ * @desc: the userspace descriptor pointer.
+ * @avail: the userspace avail pointer.
+ * @used: the userspace used pointer.
+ *
+ * Returns an error if num is invalid.
+ */
+int vringh_init_iotlb_va(struct vringh *vrh, u64 features,
+			 unsigned int num, bool weak_barriers,
+			 struct vring_desc *desc,
+			 struct vring_avail *avail,
+			 struct vring_used *used)
+{
+	vrh->use_va = true;
+
+	return vringh_init_kern(vrh, features, num, weak_barriers,
+				desc, avail, used);
+}
+EXPORT_SYMBOL(vringh_init_iotlb_va);
+
 /**
  * vringh_set_iotlb - initialize a vringh for a ring with IOTLB.
  * @vrh: the vring
-- 
2.39.2

