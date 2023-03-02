Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F146A8135
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 12:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjCBLgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 06:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjCBLf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 06:35:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED8514204
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 03:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677756907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wr7wXnFCQpY1zpniPAgMpMPx/fjhLmfIKoC/NtXm0MU=;
        b=gLhaycOvw6vqUoNnKCtcpAmh53qPL8wQe088vLH/ZTnmVoGzjNZ1ji2R1mwMiYrAsBLfQV
        M9edD4F+PEic2OCjUFPgviPO/bOWw72nutGiZrPYasQ6Pa+EFC5DQj4Pc2OOIVWl0ts2ZJ
        ff2H2eKgbsZ19KnDRzt3HuEmyoA1EUc=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-8-SPLzsInqNbyNjJfCYxI4CQ-1; Thu, 02 Mar 2023 06:35:06 -0500
X-MC-Unique: SPLzsInqNbyNjJfCYxI4CQ-1
Received: by mail-qk1-f200.google.com with SMTP id z23-20020a376517000000b00731b7a45b7fso9927922qkb.2
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 03:35:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677756905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wr7wXnFCQpY1zpniPAgMpMPx/fjhLmfIKoC/NtXm0MU=;
        b=mL8hAE3587MJUaE2SGC7zG4ZG64C+SU6YG2DNARPLvrtdxrEPurXYwJMjFmzUXvoQC
         pPwuwrJJVEOUAEtBorvJ2C/se0ketHAnWlNASrI2JxrmRQpvVRRp8PjwxFtxaUlYaCyP
         /boD9UiVrQdGXQIagCQLpQKn23FZ4jaa/VpnS18O23HFwjRnkTY4z0d3kNg06ps9rWwL
         mLzHxzBAfMoLXJnnab8kXuK2sSpkN/BPLfWwjPCjvv+mo1XhbnlUTBK47TAGzbkGhO9Y
         WofJ70Z2ZJrA2WUqzeXKXeVHFSscRUTfKF6ttxrAJeiKk6jSL6qARhQQVN3XowcUtWyG
         eULw==
X-Gm-Message-State: AO0yUKVjHOa9YBADhB9vt4nAEtHqEiAa5Ac9DFL58niEwxwFcCMDWP1j
        DkwjbcPRnnQcgaLd8xuZBKeYi+vzysyItgOjgy6lIklv2pyzZNk6nrbAFRsK8rE3t1G5/C9rnxG
        EEHxzRf3yh5B4Es8J
X-Received: by 2002:a05:6214:20c1:b0:56e:a556:f28f with SMTP id 1-20020a05621420c100b0056ea556f28fmr18887336qve.34.1677756905280;
        Thu, 02 Mar 2023 03:35:05 -0800 (PST)
X-Google-Smtp-Source: AK7set86Y3xWX8FFzNBNJULTR0DAk3t0Mhnai0hp6+YthKrk45BUDZ8jdC/DKPHKvqNQR5FHp9fcgw==
X-Received: by 2002:a05:6214:20c1:b0:56e:a556:f28f with SMTP id 1-20020a05621420c100b0056ea556f28fmr18887295qve.34.1677756904884;
        Thu, 02 Mar 2023 03:35:04 -0800 (PST)
Received: from step1.redhat.com (c-115-213.cust-q.wadsl.it. [212.43.115.213])
        by smtp.gmail.com with ESMTPSA id p12-20020a37420c000000b007426ec97253sm8383058qka.111.2023.03.02.03.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 03:35:04 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v2 4/8] vringh: support VA with iotlb
Date:   Thu,  2 Mar 2023 12:34:17 +0100
Message-Id: <20230302113421.174582-5-sgarzare@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230302113421.174582-1-sgarzare@redhat.com>
References: <20230302113421.174582-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vDPA supports the possibility to use user VA in the iotlb messages.
So, let's add support for user VA in vringh to use it in the vDPA
simulators.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---

Notes:
    v2:
    - replace kmap_atomic() with kmap_local_page() [see previous patch]
    - fix cast warnings when build with W=1 C=1

 include/linux/vringh.h            |   5 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c |   2 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c  |   4 +-
 drivers/vhost/vringh.c            | 247 ++++++++++++++++++++++++------
 4 files changed, 205 insertions(+), 53 deletions(-)

diff --git a/include/linux/vringh.h b/include/linux/vringh.h
index 1991a02c6431..d39b9f2dcba0 100644
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
 
@@ -279,7 +282,7 @@ void vringh_set_iotlb(struct vringh *vrh, struct vhost_iotlb *iotlb,
 		      spinlock_t *iotlb_lock);
 
 int vringh_init_iotlb(struct vringh *vrh, u64 features,
-		      unsigned int num, bool weak_barriers,
+		      unsigned int num, bool weak_barriers, bool use_va,
 		      struct vring_desc *desc,
 		      struct vring_avail *avail,
 		      struct vring_used *used);
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 3a0e721aef05..babc8dd171a6 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2537,7 +2537,7 @@ static int setup_cvq_vring(struct mlx5_vdpa_dev *mvdev)
 
 	if (mvdev->actual_features & BIT_ULL(VIRTIO_NET_F_CTRL_VQ))
 		err = vringh_init_iotlb(&cvq->vring, mvdev->actual_features,
-					MLX5_CVQ_MAX_ENT, false,
+					MLX5_CVQ_MAX_ENT, false, false,
 					(struct vring_desc *)(uintptr_t)cvq->desc_addr,
 					(struct vring_avail *)(uintptr_t)cvq->driver_addr,
 					(struct vring_used *)(uintptr_t)cvq->device_addr);
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 6a0a65814626..481eb156658b 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -60,7 +60,7 @@ static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int idx)
 	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
 	uint16_t last_avail_idx = vq->vring.last_avail_idx;
 
-	vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, true,
+	vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, true, false,
 			  (struct vring_desc *)(uintptr_t)vq->desc_addr,
 			  (struct vring_avail *)
 			  (uintptr_t)vq->driver_addr,
@@ -81,7 +81,7 @@ static void vdpasim_vq_reset(struct vdpasim *vdpasim,
 	vq->cb = NULL;
 	vq->private = NULL;
 	vringh_init_iotlb(&vq->vring, vdpasim->dev_attr.supported_features,
-			  VDPASIM_QUEUE_MAX, false, NULL, NULL, NULL);
+			  VDPASIM_QUEUE_MAX, false, false, NULL, NULL, NULL);
 
 	vq->vring.notify = NULL;
 }
diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 0ba3ef809e48..61c79cea44ca 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1094,15 +1094,99 @@ EXPORT_SYMBOL(vringh_need_notify_kern);
 
 #if IS_REACHABLE(CONFIG_VHOST_IOTLB)
 
-static int iotlb_translate(const struct vringh *vrh,
-			   u64 addr, u64 len, u64 *translated,
-			   struct bio_vec iov[],
-			   int iov_size, u32 perm)
+static int iotlb_translate_va(const struct vringh *vrh,
+			      u64 addr, u64 len, u64 *translated,
+			      struct iovec iov[],
+			      int iov_size, u32 perm)
 {
 	struct vhost_iotlb_map *map;
 	struct vhost_iotlb *iotlb = vrh->iotlb;
+	u64 s = 0, last = addr + len - 1;
 	int ret = 0;
+
+	spin_lock(vrh->iotlb_lock);
+
+	while (len > s) {
+		u64 size;
+
+		if (unlikely(ret >= iov_size)) {
+			ret = -ENOBUFS;
+			break;
+		}
+
+		map = vhost_iotlb_itree_first(iotlb, addr, last);
+		if (!map || map->start > addr) {
+			ret = -EINVAL;
+			break;
+		} else if (!(map->perm & perm)) {
+			ret = -EPERM;
+			break;
+		}
+
+		size = map->size - addr + map->start;
+		iov[ret].iov_len = min(len - s, size);
+		iov[ret].iov_base = (void __user *)(unsigned long)
+				    (map->addr + addr - map->start);
+		s += size;
+		addr += size;
+		++ret;
+	}
+
+	spin_unlock(vrh->iotlb_lock);
+
+	if (translated)
+		*translated = min(len, s);
+
+	return ret;
+}
+
+static inline int copy_from_va(const struct vringh *vrh, void *dst, void *src,
+			       u64 len, u64 *translated)
+{
+	struct iovec iov[16];
+	struct iov_iter iter;
+	int ret;
+
+	ret = iotlb_translate_va(vrh, (u64)(uintptr_t)src, len, translated, iov,
+				 ARRAY_SIZE(iov), VHOST_MAP_RO);
+	if (ret == -ENOBUFS)
+		ret = ARRAY_SIZE(iov);
+	else if (ret < 0)
+		return ret;
+
+	iov_iter_init(&iter, ITER_SOURCE, iov, ret, *translated);
+
+	return copy_from_iter(dst, *translated, &iter);
+}
+
+static inline int copy_to_va(const struct vringh *vrh, void *dst, void *src,
+			     u64 len, u64 *translated)
+{
+	struct iovec iov[16];
+	struct iov_iter iter;
+	int ret;
+
+	ret = iotlb_translate_va(vrh, (u64)(uintptr_t)dst, len, translated, iov,
+				 ARRAY_SIZE(iov), VHOST_MAP_WO);
+	if (ret == -ENOBUFS)
+		ret = ARRAY_SIZE(iov);
+	else if (ret < 0)
+		return ret;
+
+	iov_iter_init(&iter, ITER_DEST, iov, ret, *translated);
+
+	return copy_to_iter(src, *translated, &iter);
+}
+
+static int iotlb_translate_pa(const struct vringh *vrh,
+			      u64 addr, u64 len, u64 *translated,
+			      struct bio_vec iov[],
+			      int iov_size, u32 perm)
+{
+	struct vhost_iotlb_map *map;
+	struct vhost_iotlb *iotlb = vrh->iotlb;
 	u64 s = 0, last = addr + len - 1;
+	int ret = 0;
 
 	spin_lock(vrh->iotlb_lock);
 
@@ -1141,28 +1225,61 @@ static int iotlb_translate(const struct vringh *vrh,
 	return ret;
 }
 
+static inline int copy_from_pa(const struct vringh *vrh, void *dst, void *src,
+			       u64 len, u64 *translated)
+{
+	struct bio_vec iov[16];
+	struct iov_iter iter;
+	int ret;
+
+	ret = iotlb_translate_pa(vrh, (u64)(uintptr_t)src, len, translated, iov,
+				 ARRAY_SIZE(iov), VHOST_MAP_RO);
+	if (ret == -ENOBUFS)
+		ret = ARRAY_SIZE(iov);
+	else if (ret < 0)
+		return ret;
+
+	iov_iter_bvec(&iter, ITER_SOURCE, iov, ret, *translated);
+
+	return copy_from_iter(dst, *translated, &iter);
+}
+
+static inline int copy_to_pa(const struct vringh *vrh, void *dst, void *src,
+			     u64 len, u64 *translated)
+{
+	struct bio_vec iov[16];
+	struct iov_iter iter;
+	int ret;
+
+	ret = iotlb_translate_pa(vrh, (u64)(uintptr_t)dst, len, translated, iov,
+				 ARRAY_SIZE(iov), VHOST_MAP_WO);
+	if (ret == -ENOBUFS)
+		ret = ARRAY_SIZE(iov);
+	else if (ret < 0)
+		return ret;
+
+	iov_iter_bvec(&iter, ITER_DEST, iov, ret, *translated);
+
+	return copy_to_iter(src, *translated, &iter);
+}
+
 static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
 				  void *src, size_t len)
 {
 	u64 total_translated = 0;
 
 	while (total_translated < len) {
-		struct bio_vec iov[16];
-		struct iov_iter iter;
 		u64 translated;
 		int ret;
 
-		ret = iotlb_translate(vrh, (u64)(uintptr_t)src,
-				      len - total_translated, &translated,
-				      iov, ARRAY_SIZE(iov), VHOST_MAP_RO);
-		if (ret == -ENOBUFS)
-			ret = ARRAY_SIZE(iov);
-		else if (ret < 0)
-			return ret;
-
-		iov_iter_bvec(&iter, ITER_SOURCE, iov, ret, translated);
+		if (vrh->use_va) {
+			ret = copy_from_va(vrh, dst, src,
+					   len - total_translated, &translated);
+		} else {
+			ret = copy_from_pa(vrh, dst, src,
+					   len - total_translated, &translated);
+		}
 
-		ret = copy_from_iter(dst, translated, &iter);
 		if (ret < 0)
 			return ret;
 
@@ -1180,22 +1297,17 @@ static inline int copy_to_iotlb(const struct vringh *vrh, void *dst,
 	u64 total_translated = 0;
 
 	while (total_translated < len) {
-		struct bio_vec iov[16];
-		struct iov_iter iter;
 		u64 translated;
 		int ret;
 
-		ret = iotlb_translate(vrh, (u64)(uintptr_t)dst,
-				      len - total_translated, &translated,
-				      iov, ARRAY_SIZE(iov), VHOST_MAP_WO);
-		if (ret == -ENOBUFS)
-			ret = ARRAY_SIZE(iov);
-		else if (ret < 0)
-			return ret;
-
-		iov_iter_bvec(&iter, ITER_DEST, iov, ret, translated);
+		if (vrh->use_va) {
+			ret = copy_to_va(vrh, dst, src,
+					 len - total_translated, &translated);
+		} else {
+			ret = copy_to_pa(vrh, dst, src,
+					 len - total_translated, &translated);
+		}
 
-		ret = copy_to_iter(src, translated, &iter);
 		if (ret < 0)
 			return ret;
 
@@ -1210,20 +1322,37 @@ static inline int copy_to_iotlb(const struct vringh *vrh, void *dst,
 static inline int getu16_iotlb(const struct vringh *vrh,
 			       u16 *val, const __virtio16 *p)
 {
-	struct bio_vec iov;
-	void *kaddr, *from;
 	int ret;
 
 	/* Atomic read is needed for getu16 */
-	ret = iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p), NULL,
-			      &iov, 1, VHOST_MAP_RO);
-	if (ret < 0)
-		return ret;
+	if (vrh->use_va) {
+		struct iovec iov;
+		__virtio16 tmp;
+
+		ret = iotlb_translate_va(vrh, (u64)(uintptr_t)p, sizeof(*p),
+					 NULL, &iov, 1, VHOST_MAP_RO);
+		if (ret < 0)
+			return ret;
 
-	kaddr = kmap_local_page(iov.bv_page);
-	from = kaddr + iov.bv_offset;
-	*val = vringh16_to_cpu(vrh, READ_ONCE(*(__virtio16 *)from));
-	kunmap_local(kaddr);
+		ret = __get_user(tmp, (__virtio16 __user *)iov.iov_base);
+		if (ret)
+			return ret;
+
+		*val = vringh16_to_cpu(vrh, tmp);
+	} else {
+		struct bio_vec iov;
+		void *kaddr, *from;
+
+		ret = iotlb_translate_pa(vrh, (u64)(uintptr_t)p, sizeof(*p),
+					 NULL, &iov, 1, VHOST_MAP_RO);
+		if (ret < 0)
+			return ret;
+
+		kaddr = kmap_local_page(iov.bv_page);
+		from = kaddr + iov.bv_offset;
+		*val = vringh16_to_cpu(vrh, READ_ONCE(*(__virtio16 *)from));
+		kunmap_local(kaddr);
+	}
 
 	return 0;
 }
@@ -1231,20 +1360,37 @@ static inline int getu16_iotlb(const struct vringh *vrh,
 static inline int putu16_iotlb(const struct vringh *vrh,
 			       __virtio16 *p, u16 val)
 {
-	struct bio_vec iov;
-	void *kaddr, *to;
 	int ret;
 
 	/* Atomic write is needed for putu16 */
-	ret = iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p), NULL,
-			      &iov, 1, VHOST_MAP_WO);
-	if (ret < 0)
-		return ret;
+	if (vrh->use_va) {
+		struct iovec iov;
+		__virtio16 tmp;
 
-	kaddr = kmap_local_page(iov.bv_page);
-	to = kaddr + iov.bv_offset;
-	WRITE_ONCE(*(__virtio16 *)to, cpu_to_vringh16(vrh, val));
-	kunmap_local(kaddr);
+		ret = iotlb_translate_va(vrh, (u64)(uintptr_t)p, sizeof(*p),
+					 NULL, &iov, 1, VHOST_MAP_RO);
+		if (ret < 0)
+			return ret;
+
+		tmp = cpu_to_vringh16(vrh, val);
+
+		ret = __put_user(tmp, (__virtio16 __user *)iov.iov_base);
+		if (ret)
+			return ret;
+	} else {
+		struct bio_vec iov;
+		void *kaddr, *to;
+
+		ret = iotlb_translate_pa(vrh, (u64)(uintptr_t)p, sizeof(*p), NULL,
+					 &iov, 1, VHOST_MAP_WO);
+		if (ret < 0)
+			return ret;
+
+		kaddr = kmap_local_page(iov.bv_page);
+		to = kaddr + iov.bv_offset;
+		WRITE_ONCE(*(__virtio16 *)to, cpu_to_vringh16(vrh, val));
+		kunmap_local(kaddr);
+	}
 
 	return 0;
 }
@@ -1306,6 +1452,7 @@ static inline int putused_iotlb(const struct vringh *vrh,
  * @features: the feature bits for this ring.
  * @num: the number of elements.
  * @weak_barriers: true if we only need memory barriers, not I/O.
+ * @use_va: true if IOTLB contains user VA
  * @desc: the userpace descriptor pointer.
  * @avail: the userpace avail pointer.
  * @used: the userpace used pointer.
@@ -1313,11 +1460,13 @@ static inline int putused_iotlb(const struct vringh *vrh,
  * Returns an error if num is invalid.
  */
 int vringh_init_iotlb(struct vringh *vrh, u64 features,
-		      unsigned int num, bool weak_barriers,
+		      unsigned int num, bool weak_barriers, bool use_va,
 		      struct vring_desc *desc,
 		      struct vring_avail *avail,
 		      struct vring_used *used)
 {
+	vrh->use_va = use_va;
+
 	return vringh_init_kern(vrh, features, num, weak_barriers,
 				desc, avail, used);
 }
-- 
2.39.2

