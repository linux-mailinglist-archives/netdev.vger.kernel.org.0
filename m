Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0DF4BC3EC
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 01:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240602AbiBSAyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 19:54:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240586AbiBSAx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 19:53:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A14CA2790A4
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 16:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645232017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=WM5OzNcGdWEyk24mjUtD4gIgYAk78EXJWAr4Hqf+1I4=;
        b=LXgVIKJRoknc6FknDtFns5Sg6O8vfqIJt3chFsSfPn4UEvGdDpMFXjxewvld/4kRSryjUP
        Sx+TDh8FDp+Hn3XqWYEHKg6SVji4ZfKqRxJ7LAMOZ5dZPo1gpr+DN+r5lbRCcsgi/ttKAe
        Z+oZAs7ScZUFNoID6/T2w/7WYdYxtHg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-KKq__IXGMgKb-GYMZNuMew-1; Fri, 18 Feb 2022 19:53:34 -0500
X-MC-Unique: KKq__IXGMgKb-GYMZNuMew-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E8F41091DA0;
        Sat, 19 Feb 2022 00:53:31 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (ovpn-12-39.pek2.redhat.com [10.72.12.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C7E362D57;
        Sat, 19 Feb 2022 00:53:12 +0000 (UTC)
From:   Baoquan He <bhe@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, akpm@linux-foundation.org, hch@lst.de,
        cl@linux.com, 42.hyeyoo@gmail.com, penberg@kernel.org,
        rientjes@google.com, iamjoonsoo.kim@lge.com, vbabka@suse.cz,
        David.Laight@ACULAB.COM, david@redhat.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, linux-s390@vger.kernel.org, michael@walle.cc,
        linux-i2c@vger.kernel.org, wsa@kernel.org
Subject: [PATCH 04/22] drm/sti: Don't use GFP_DMA when calling dma_alloc_wc()
Date:   Sat, 19 Feb 2022 08:52:03 +0800
Message-Id: <20220219005221.634-5-bhe@redhat.com>
In-Reply-To: <20220219005221.634-1-bhe@redhat.com>
References: <20220219005221.634-1-bhe@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dma_alloc_wc() allocates dma buffer with device's addressing
limitation in mind. It's redundent to specify GFP_DMA when calling
dma_alloc_wc().

[ 42.hyeyoo@gmail.com: Update changelog ]

Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
---
 drivers/gpu/drm/sti/sti_cursor.c | 4 ++--
 drivers/gpu/drm/sti/sti_hqvdp.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/sti/sti_cursor.c b/drivers/gpu/drm/sti/sti_cursor.c
index 1d6051b4f6fe..d1123dc09d25 100644
--- a/drivers/gpu/drm/sti/sti_cursor.c
+++ b/drivers/gpu/drm/sti/sti_cursor.c
@@ -235,7 +235,7 @@ static int sti_cursor_atomic_check(struct drm_plane *drm_plane,
 		cursor->pixmap.base = dma_alloc_wc(cursor->dev,
 						   cursor->pixmap.size,
 						   &cursor->pixmap.paddr,
-						   GFP_KERNEL | GFP_DMA);
+						   GFP_KERNEL);
 		if (!cursor->pixmap.base) {
 			DRM_ERROR("Failed to allocate memory for pixmap\n");
 			return -EINVAL;
@@ -375,7 +375,7 @@ struct drm_plane *sti_cursor_create(struct drm_device *drm_dev,
 	/* Allocate clut buffer */
 	size = 0x100 * sizeof(unsigned short);
 	cursor->clut = dma_alloc_wc(dev, size, &cursor->clut_paddr,
-				    GFP_KERNEL | GFP_DMA);
+				    GFP_KERNEL);
 
 	if (!cursor->clut) {
 		DRM_ERROR("Failed to allocate memory for cursor clut\n");
diff --git a/drivers/gpu/drm/sti/sti_hqvdp.c b/drivers/gpu/drm/sti/sti_hqvdp.c
index 3c61ba8b43e0..324e9dc238e4 100644
--- a/drivers/gpu/drm/sti/sti_hqvdp.c
+++ b/drivers/gpu/drm/sti/sti_hqvdp.c
@@ -857,7 +857,7 @@ static void sti_hqvdp_init(struct sti_hqvdp *hqvdp)
 	size = NB_VDP_CMD * sizeof(struct sti_hqvdp_cmd);
 	hqvdp->hqvdp_cmd = dma_alloc_wc(hqvdp->dev, size,
 					&dma_addr,
-					GFP_KERNEL | GFP_DMA);
+					GFP_KERNEL);
 	if (!hqvdp->hqvdp_cmd) {
 		DRM_ERROR("Failed to allocate memory for VDP cmd\n");
 		return;
-- 
2.17.2

