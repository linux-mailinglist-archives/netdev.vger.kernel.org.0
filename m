Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 016EE6BD4B0
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 17:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjCPQIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 12:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCPQII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 12:08:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFB2B5B7E
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 09:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678982836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EyLPAkGkRuU4AvFXRV/RheBuiBo2mwGP5+unovg9FvE=;
        b=BYbsGy+rhd07wbR3egkc1dtIJ6AthMM+nt4MOF/B95iX8FZcS0oWRpdpefM8U0IcKW7Exq
        qslr6hYELTNjzlXDy46CfhhwWBgRXLCgUTDjeFxtXS4pLJr2N54LWRLa18djZWcAaFLY04
        3yCtUaAutDKcFXGuSE2pSF4nzng0b8w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-35-J2CDVNvTPOy5PZX7N0pSlA-1; Thu, 16 Mar 2023 12:07:14 -0400
X-MC-Unique: J2CDVNvTPOy5PZX7N0pSlA-1
Received: by mail-wm1-f71.google.com with SMTP id k41-20020a05600c1ca900b003ed383b1b62so848350wms.8
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 09:07:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678982833;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EyLPAkGkRuU4AvFXRV/RheBuiBo2mwGP5+unovg9FvE=;
        b=DV7TMYCP4zZSYPylauOJ5xeoSacIvpUb2sNTA66XVR9MRLLDLiIijkShGBGhPLFG9G
         mEkFriXm65nNf7M8PlbNyevFFNI1irQj9JDhcFNhrL/WU4TCgMy8QX7+SeOBMey1zx4g
         65f01Fae1exI9CYRHSg1AhCn43O8U1IowlEVqOxomrm2jL9cP4VVutfNuvaT3ZoU0ZeU
         j7DJTQTt+R6/4e3ibXqFL/OqKM/dM54Nx1z9ozN7QHEVELsCv7UCra5BV63PwccNjsni
         QYs5hWDGY7yaPIT2DYrA9G1siZ+WJdLTKbFq6VsgDxIJLjT77adjR8mK8wJfK1ZCJsUE
         PvNg==
X-Gm-Message-State: AO0yUKV0NF2lisOk720W2dt1mkmfHCe4nUiTxavBfjpfKXeAtOhl0dtb
        JSE7jLwrXx354aH4PDWMHtf5DHsFugrbcWTeWvH1RJVFm8cSsa8Mv88H2DLYyCxfPKhsl02DhaG
        eTRaI//IRFQoiRy7w
X-Received: by 2002:a5d:60c4:0:b0:2c7:1210:fe42 with SMTP id x4-20020a5d60c4000000b002c71210fe42mr5172778wrt.47.1678982833564;
        Thu, 16 Mar 2023 09:07:13 -0700 (PDT)
X-Google-Smtp-Source: AK7set9bJ4u1IrnPfVrEviJjJ+QY9sDg2eHRM4PLnhd6Cs6ce+Hy27Yl5EEb6zgTq6XuoUoJGRvJ7g==
X-Received: by 2002:a5d:60c4:0:b0:2c7:1210:fe42 with SMTP id x4-20020a5d60c4000000b002c71210fe42mr5172759wrt.47.1678982833252;
        Thu, 16 Mar 2023 09:07:13 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id w12-20020a5d608c000000b002cfefa50a8esm6241726wrt.98.2023.03.16.09.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 09:07:12 -0700 (PDT)
Date:   Thu, 16 Mar 2023 17:07:10 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 4/8] vringh: support VA with iotlb
Message-ID: <CAGxU2F7GZxMwLNsAebaPx61MoePYYmFS1q66An-EDhq4u+a9ng@mail.gmail.com>
References: <20230302113421.174582-1-sgarzare@redhat.com>
 <20230302113421.174582-5-sgarzare@redhat.com>
 <CAJaqyWdeEzKnYuX-c348vVg0PpUH4y-e1dSLhRvYem=MEDKE=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJaqyWdeEzKnYuX-c348vVg0PpUH4y-e1dSLhRvYem=MEDKE=Q@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 3, 2023 at 3:39 PM Eugenio Perez Martin <eperezma@redhat.com> wrote:
>
> On Thu, Mar 2, 2023 at 12:35 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> >
> > vDPA supports the possibility to use user VA in the iotlb messages.
> > So, let's add support for user VA in vringh to use it in the vDPA
> > simulators.
> >
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > ---
> >
> > Notes:
> >     v2:
> >     - replace kmap_atomic() with kmap_local_page() [see previous patch]
> >     - fix cast warnings when build with W=1 C=1
> >
> >  include/linux/vringh.h            |   5 +-
> >  drivers/vdpa/mlx5/net/mlx5_vnet.c |   2 +-
> >  drivers/vdpa/vdpa_sim/vdpa_sim.c  |   4 +-
> >  drivers/vhost/vringh.c            | 247 ++++++++++++++++++++++++------
> >  4 files changed, 205 insertions(+), 53 deletions(-)
> >

[...]

>
> It seems to me iotlb_translate_va and iotlb_translate_pa are very
> similar, their only difference is that the argument is that iov is
> iovec instead of bio_vec. And how to fill it, obviously.
>
> It would be great to merge both functions, only differing with a
> conditional on vrh->use_va, or generics, or similar. Or, if following
> the style of the rest of vringh code, to provide a callback to fill
> iovec (although I like conditional more).
>
> However I cannot think of an easy way to perform that without long
> macros or type erasure.

Thank you for pushing me :-)
I finally managed to avoid code duplication (partial patch attached,
but not yet fully tested).

@Jason: with this refactoring I removed copy_to_va/copy_to_pa, so I
also avoided getu16_iotlb_va/pa.

I will send the full patch in v3, but I would like to get your opinion
first ;-)



diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 0ba3ef809e48..71dd67700e36 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1096,8 +1096,7 @@ EXPORT_SYMBOL(vringh_need_notify_kern);
 
 static int iotlb_translate(const struct vringh *vrh,
 			   u64 addr, u64 len, u64 *translated,
-			   struct bio_vec iov[],
-			   int iov_size, u32 perm)
+			   void *iov, int iov_size, bool iovec, u32 perm)
 {
 	struct vhost_iotlb_map *map;
 	struct vhost_iotlb *iotlb = vrh->iotlb;
@@ -1107,7 +1106,7 @@ static int iotlb_translate(const struct vringh *vrh,
 	spin_lock(vrh->iotlb_lock);
 
 	while (len > s) {
-		u64 size, pa, pfn;
+		u64 size;
 
 		if (unlikely(ret >= iov_size)) {
 			ret = -ENOBUFS;
@@ -1124,10 +1123,22 @@ static int iotlb_translate(const struct vringh *vrh,
 		}
 
 		size = map->size - addr + map->start;
-		pa = map->addr + addr - map->start;
-		pfn = pa >> PAGE_SHIFT;
-		bvec_set_page(&iov[ret], pfn_to_page(pfn), min(len - s, size),
-			      pa & (PAGE_SIZE - 1));
+		if (iovec) {
+			struct iovec *iovec = iov;
+
+			iovec[ret].iov_len = min(len - s, size);
+			iovec[ret].iov_base = (void __user *)(unsigned long)
+					      (map->addr + addr - map->start);
+		} else {
+			u64 pa = map->addr + addr - map->start;
+			u64 pfn = pa >> PAGE_SHIFT;
+			struct bio_vec *bvec = iov;
+
+			bvec_set_page(&bvec[ret], pfn_to_page(pfn),
+				      min(len - s, size),
+				      pa & (PAGE_SIZE - 1));
+		}
+
 		s += size;
 		addr += size;
 		++ret;
@@ -1141,26 +1152,38 @@ static int iotlb_translate(const struct vringh *vrh,
 	return ret;
 }
 
+#define IOTLB_IOV_SIZE 16
+
 static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
 				  void *src, size_t len)
 {
 	u64 total_translated = 0;
 
 	while (total_translated < len) {
-		struct bio_vec iov[16];
+		union {
+			struct iovec iovec[IOTLB_IOV_SIZE];
+			struct bio_vec bvec[IOTLB_IOV_SIZE];
+		} iov;
 		struct iov_iter iter;
 		u64 translated;
 		int ret;
 
 		ret = iotlb_translate(vrh, (u64)(uintptr_t)src,
 				      len - total_translated, &translated,
-				      iov, ARRAY_SIZE(iov), VHOST_MAP_RO);
+				      &iov, IOTLB_IOV_SIZE, vrh->use_va,
+				      VHOST_MAP_RO);
 		if (ret == -ENOBUFS)
-			ret = ARRAY_SIZE(iov);
+			ret = IOTLB_IOV_SIZE;
 		else if (ret < 0)
 			return ret;
 
-		iov_iter_bvec(&iter, ITER_SOURCE, iov, ret, translated);
+		if (vrh->use_va) {
+			iov_iter_init(&iter, ITER_SOURCE, iov.iovec, ret,
+				      translated);
+		} else {
+			iov_iter_bvec(&iter, ITER_SOURCE, iov.bvec, ret,
+				      translated);
+		}
 
 		ret = copy_from_iter(dst, translated, &iter);
 		if (ret < 0)
@@ -1180,20 +1203,30 @@ static inline int copy_to_iotlb(const struct vringh *vrh, void *dst,
 	u64 total_translated = 0;
 
 	while (total_translated < len) {
-		struct bio_vec iov[16];
+		union {
+			struct iovec iovec[IOTLB_IOV_SIZE];
+			struct bio_vec bvec[IOTLB_IOV_SIZE];
+		} iov;
 		struct iov_iter iter;
 		u64 translated;
 		int ret;
 
 		ret = iotlb_translate(vrh, (u64)(uintptr_t)dst,
 				      len - total_translated, &translated,
-				      iov, ARRAY_SIZE(iov), VHOST_MAP_WO);
+				      &iov, IOTLB_IOV_SIZE, vrh->use_va,
+				      VHOST_MAP_WO);
 		if (ret == -ENOBUFS)
-			ret = ARRAY_SIZE(iov);
+			ret = IOTLB_IOV_SIZE;
 		else if (ret < 0)
 			return ret;
 
-		iov_iter_bvec(&iter, ITER_DEST, iov, ret, translated);
+		if (vrh->use_va) {
+			iov_iter_init(&iter, ITER_DEST, iov.iovec, ret,
+				      translated);
+		} else {
+			iov_iter_bvec(&iter, ITER_DEST, iov.bvec, ret,
+				      translated);
+		}
 
 		ret = copy_to_iter(src, translated, &iter);
 		if (ret < 0)
@@ -1210,20 +1243,32 @@ static inline int copy_to_iotlb(const struct vringh *vrh, void *dst,
 static inline int getu16_iotlb(const struct vringh *vrh,
 			       u16 *val, const __virtio16 *p)
 {
-	struct bio_vec iov;
-	void *kaddr, *from;
+	union {
+		struct iovec iovec;
+		struct bio_vec bvec;
+	} iov;
+	__virtio16 tmp;
 	int ret;
 
 	/* Atomic read is needed for getu16 */
-	ret = iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p), NULL,
-			      &iov, 1, VHOST_MAP_RO);
+	ret = iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p),
+			      NULL, &iov, 1, vrh->use_va, VHOST_MAP_RO);
 	if (ret < 0)
 		return ret;
 
-	kaddr = kmap_local_page(iov.bv_page);
-	from = kaddr + iov.bv_offset;
-	*val = vringh16_to_cpu(vrh, READ_ONCE(*(__virtio16 *)from));
-	kunmap_local(kaddr);
+	if (vrh->use_va) {
+		ret = __get_user(tmp, (__virtio16 __user *)iov.iovec.iov_base);
+		if (ret)
+			return ret;
+	} else {
+		void *kaddr = kmap_local_page(iov.bvec.bv_page);
+		void *from = kaddr + iov.bvec.bv_offset;
+
+		tmp = READ_ONCE(*(__virtio16 *)from);
+		kunmap_local(kaddr);
+	}
+
+	*val = vringh16_to_cpu(vrh, tmp);
 
 	return 0;
 }
@@ -1231,20 +1276,32 @@ static inline int getu16_iotlb(const struct vringh *vrh,
 static inline int putu16_iotlb(const struct vringh *vrh,
 			       __virtio16 *p, u16 val)
 {
-	struct bio_vec iov;
-	void *kaddr, *to;
+	union {
+		struct iovec iovec;
+		struct bio_vec bvec;
+	} iov;
+	__virtio16 tmp;
 	int ret;
 
 	/* Atomic write is needed for putu16 */
-	ret = iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p), NULL,
-			      &iov, 1, VHOST_MAP_WO);
+	ret = iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p),
+			      NULL, &iov, 1, vrh->use_va, VHOST_MAP_RO);
 	if (ret < 0)
 		return ret;
 
-	kaddr = kmap_local_page(iov.bv_page);
-	to = kaddr + iov.bv_offset;
-	WRITE_ONCE(*(__virtio16 *)to, cpu_to_vringh16(vrh, val));
-	kunmap_local(kaddr);
+	tmp = cpu_to_vringh16(vrh, val);
+
+	if (vrh->use_va) {
+		ret = __put_user(tmp, (__virtio16 __user *)iov.iovec.iov_base);
+		if (ret)
+			return ret;
+	} else {
+		void *kaddr = kmap_local_page(iov.bvec.bv_page);
+		void *to = kaddr + iov.bvec.bv_offset;
+
+		WRITE_ONCE(*(__virtio16 *)to, tmp);
+		kunmap_local(kaddr);
+	}
 
 	return 0;
 }

