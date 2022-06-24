Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6B255946E
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 09:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiFXH5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 03:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiFXH5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 03:57:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B14369FA2
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 00:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656057422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=s2LZA/fXI+mD13WTemreZqL0kxh0eBajgvaYdX/0vbQ=;
        b=gMIXHNyeT5Y3T+b68PoCRGPpoe0R3VXJQRw7FzGY+/E6mCMtDNAORqbTggpVKsiH4IGs7a
        VlaTmvW4MxX3PwkMp0S9qvd0SFCvBfbe9FTX7YL0pMm6tRHsP++QP5ysRWIx5u+ZOGkMVW
        ivRJ50AcTpJBHO1IlwM5bmhCFkK55TQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-h5zqBCYzOlaL4wP60DC-0Q-1; Fri, 24 Jun 2022 03:57:00 -0400
X-MC-Unique: h5zqBCYzOlaL4wP60DC-0Q-1
Received: by mail-wr1-f69.google.com with SMTP id l9-20020adfa389000000b0021b8b489336so163485wrb.13
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 00:57:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s2LZA/fXI+mD13WTemreZqL0kxh0eBajgvaYdX/0vbQ=;
        b=znIMs/X1YDxKafkzq26i16MAOuE0cXiEcO7AKntZuk+ZrcHLT1bK2X+1qRYULWqx08
         m17opK88laUIlCooM9QKHVRjqWu56esMV9z7yPUTdxwGlUZhCH0zAydSzKkgTk7+zovJ
         VIZeQfso5osLUuPJlEIGOGsuUkRQ1xQ/BcZgRc2oPUD1BMKQ+VTsJaP79zhzvQSptUio
         uV93tX2pJVTHDD/1Lh2ea2/t4zCCycxyZPL0CA3fxvac1dZoMPTT5bTze4swaEPWd8KU
         ZkUKTVObYJRk0sWdphuW+GeB68uUsRpty+TiSK4Cqa0S2WGuy+9TOYtsEAFKQULubs9b
         /ENQ==
X-Gm-Message-State: AJIora9LbE7WZLfWDh6Y4gJmHKyCioLlUpuWpJDL7/EwdZaS8MJ3XnAF
        wLJa/6/WOVX8vuk5ybpwthQOp25J9LYek3xDrudQWL3CCQi24JrlHxxiMZZx2QQJhZy3V0QTpaG
        lgFY8WTIdueQdUJ3/
X-Received: by 2002:a05:600c:4ca7:b0:3a0:3905:d441 with SMTP id g39-20020a05600c4ca700b003a03905d441mr2235410wmp.159.1656057419296;
        Fri, 24 Jun 2022 00:56:59 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vNfHWb9u9vWiW5DWSFpAv1CdnziWuY0VO871vq8AjALqHLbv+K+Sigjdz+Mpcfn9SgjHzANA==
X-Received: by 2002:a05:600c:4ca7:b0:3a0:3905:d441 with SMTP id g39-20020a05600c4ca700b003a03905d441mr2235389wmp.159.1656057419075;
        Fri, 24 Jun 2022 00:56:59 -0700 (PDT)
Received: from step1.redhat.com (host-79-46-200-40.retail.telecomitalia.it. [79.46.200.40])
        by smtp.gmail.com with ESMTPSA id c2-20020a1c3502000000b0039c5328ad92sm5975322wma.41.2022.06.24.00.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 00:56:58 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH] vringh: iterate on iotlb_translate to handle large translations
Date:   Fri, 24 Jun 2022 09:56:56 +0200
Message-Id: <20220624075656.13997-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

iotlb_translate() can return -ENOBUFS if the bio_vec is not big enough
to contain all the ranges for translation.
This can happen for example if the VMM maps a large bounce buffer,
without using hugepages, that requires more than 16 ranges to translate
the addresses.

To handle this case, let's extend iotlb_translate() to also return the
number of bytes successfully translated.
In copy_from_iotlb()/copy_to_iotlb() loops by calling iotlb_translate()
several times until we complete the translation.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vringh.c | 78 ++++++++++++++++++++++++++++++------------
 1 file changed, 56 insertions(+), 22 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index eab55accf381..11f59dd06a74 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1095,7 +1095,8 @@ EXPORT_SYMBOL(vringh_need_notify_kern);
 #if IS_REACHABLE(CONFIG_VHOST_IOTLB)
 
 static int iotlb_translate(const struct vringh *vrh,
-			   u64 addr, u64 len, struct bio_vec iov[],
+			   u64 addr, u64 len, u64 *translated,
+			   struct bio_vec iov[],
 			   int iov_size, u32 perm)
 {
 	struct vhost_iotlb_map *map;
@@ -1136,43 +1137,76 @@ static int iotlb_translate(const struct vringh *vrh,
 
 	spin_unlock(vrh->iotlb_lock);
 
+	if (translated)
+		*translated = min(len, s);
+
 	return ret;
 }
 
 static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
 				  void *src, size_t len)
 {
-	struct iov_iter iter;
-	struct bio_vec iov[16];
-	int ret;
+	u64 total_translated = 0;
 
-	ret = iotlb_translate(vrh, (u64)(uintptr_t)src,
-			      len, iov, 16, VHOST_MAP_RO);
-	if (ret < 0)
-		return ret;
+	while (total_translated < len) {
+		struct bio_vec iov[16];
+		struct iov_iter iter;
+		u64 translated;
+		int ret;
 
-	iov_iter_bvec(&iter, READ, iov, ret, len);
+		ret = iotlb_translate(vrh, (u64)(uintptr_t)src,
+				      len - total_translated, &translated,
+				      iov, ARRAY_SIZE(iov), VHOST_MAP_RO);
+		if (ret == -ENOBUFS)
+			ret = ARRAY_SIZE(iov);
+		else if (ret < 0)
+			return ret;
 
-	ret = copy_from_iter(dst, len, &iter);
+		iov_iter_bvec(&iter, READ, iov, ret, translated);
 
-	return ret;
+		ret = copy_from_iter(dst, translated, &iter);
+		if (ret < 0)
+			return ret;
+
+		src += translated;
+		dst += translated;
+		total_translated += translated;
+	}
+
+	return total_translated;
 }
 
 static inline int copy_to_iotlb(const struct vringh *vrh, void *dst,
 				void *src, size_t len)
 {
-	struct iov_iter iter;
-	struct bio_vec iov[16];
-	int ret;
+	u64 total_translated = 0;
 
-	ret = iotlb_translate(vrh, (u64)(uintptr_t)dst,
-			      len, iov, 16, VHOST_MAP_WO);
-	if (ret < 0)
-		return ret;
+	while (total_translated < len) {
+		struct bio_vec iov[16];
+		struct iov_iter iter;
+		u64 translated;
+		int ret;
+
+		ret = iotlb_translate(vrh, (u64)(uintptr_t)dst,
+				      len - total_translated, &translated,
+				      iov, ARRAY_SIZE(iov), VHOST_MAP_WO);
+		if (ret == -ENOBUFS)
+			ret = ARRAY_SIZE(iov);
+		else if (ret < 0)
+			return ret;
 
-	iov_iter_bvec(&iter, WRITE, iov, ret, len);
+		iov_iter_bvec(&iter, WRITE, iov, ret, translated);
+
+		ret = copy_to_iter(src, translated, &iter);
+		if (ret < 0)
+			return ret;
+
+		src += translated;
+		dst += translated;
+		total_translated += translated;
+	}
 
-	return copy_to_iter(src, len, &iter);
+	return total_translated;
 }
 
 static inline int getu16_iotlb(const struct vringh *vrh,
@@ -1183,7 +1217,7 @@ static inline int getu16_iotlb(const struct vringh *vrh,
 	int ret;
 
 	/* Atomic read is needed for getu16 */
-	ret = iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p),
+	ret = iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p), NULL,
 			      &iov, 1, VHOST_MAP_RO);
 	if (ret < 0)
 		return ret;
@@ -1204,7 +1238,7 @@ static inline int putu16_iotlb(const struct vringh *vrh,
 	int ret;
 
 	/* Atomic write is needed for putu16 */
-	ret = iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p),
+	ret = iotlb_translate(vrh, (u64)(uintptr_t)p, sizeof(*p), NULL,
 			      &iov, 1, VHOST_MAP_WO);
 	if (ret < 0)
 		return ret;
-- 
2.36.1

