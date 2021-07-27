Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF013D804F
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbhG0VBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234449AbhG0VA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:00:28 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469F1C0617A3
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:14 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so1189224pjd.0
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5dgtbc2dgc03WrB3zCW8xCKeemPdJxAysWeYGPrb2AU=;
        b=F8BhKjlELwZQZC/NHilmj8UHyJiciojqkD21zu2phAh9IjoM/fxQim890WscudGWkn
         ITiddmP/I7AMAah42EqEpj+RLkluZCVZ837vhUSZ98pD/iRc3avt5dWcp6Jyky58KYKr
         5cCh2GoKzu208b1IjBoT3Lt5g7EZOYb86oyL0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5dgtbc2dgc03WrB3zCW8xCKeemPdJxAysWeYGPrb2AU=;
        b=ZFbFnN6RoUmBg/02QAA/IG/uFOA8Xz0ETVnKHk6gAPCmqNCEOKunMFUq2ydbe3cdZt
         KlwW2h5ptrv36HtDrvpJoc96+QkFZpSmYafzNpvuEui1hOr+LPOZHsKm86dFwmAxJkU3
         EOfkYzD5NCY1LhRT7SAzUIxYDP7tSqSgGON5QGIF68jDJYT0BkkU1bC5xEzFm/ot0ctH
         PWIhyPId7MkKE4X4ehAZsbTZhZffELgJYHFbzNQziSKxdCwm5TSrMQDUlFPR5akC8uek
         CfCaTFvezb22lP/Zgb2A2mjqGylRrhOuGqRvYAycfW4czfsLTlAgtNBUZavDWE/uZKkr
         XV/Q==
X-Gm-Message-State: AOAM531xa3CHU2KGXuLtdj+/hoxbwcnc/MKjTY4qIZCEMcYwkZ24y0LW
        n8Da7a7W3nOrg80cBbs2eTpHIQ==
X-Google-Smtp-Source: ABdhPJzHaCRGy5F+C/0IwVa3T6DxyU5SU0Rk1IFN+C3HrONrQCAZIHyVl0Jwr71UKmZc4kOAdrOx9Q==
X-Received: by 2002:a17:90a:9511:: with SMTP id t17mr6099598pjo.194.1627419553892;
        Tue, 27 Jul 2021 13:59:13 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j185sm977660pfb.86.2021.07.27.13.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 13:59:09 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH 25/64] drm/mga/mga_ioc32: Use struct_group() for memcpy() region
Date:   Tue, 27 Jul 2021 13:58:16 -0700
Message-Id: <20210727205855.411487-26-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4623; h=from:subject; bh=k+K5bstPCbcyrh+sSnGNbOYkreiUUA/e+oUv7j7SsRI=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOF7lb8jaGmB5ldx4AxyJ1hPHdl4meiY4XD8VCT /iMBLayJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzhQAKCRCJcvTf3G3AJvoJD/ 92twoEjqLmo87BW6EPdn7+I36/Lfz4+EvdPI46UzDmOPeZZUdda/FVtlnjMfEf8Q7C65xjksxGuB11 ICT3mXYX/OI+OAHyDSDJYypVceEdn64IHFBqpq/oGwo5Yb3yImt3/puNdHix7T+reDMD9k3/10f1ea 64Pu/new1rtTnvCeLNrJVYFxo0r1FdR5tKQNjHTB90tHMLn2iIIKqbGXb20uLxtV+x7a+H7Us4Yvg3 jBkDEA9pd2OgCVOKGOgKUslD+d3uAxjiRTujQwyQFyuAcD0eO5bQmNCY2KVkY+N60I7KJX/+7VpO5f qXqg2QaavL2tumHBfYyNzwOsb6LN7zfwVX0ckRUzhnavSPV/D+qSZF3dIhW70wEeMyjzR0utNMhCoC xrhy6krEgk3kh6c5GIkeWWNBw1+HaHq84ZW7T0ZralGra2hddUdIcxJyigKD3DhXNPHoV1jCEMnjsR j27XJySoAwc8IRtRRcu1+lBrjuaYvhUsBhqRGiDppkxlrH8BYE9FWSEkYmo2/nR/nqvaO5kWIGopgr mtojfttWXR/DK1oruTB5GXelPdoUZCcw1LKaQBQtAAO+8wvNFMXwZCmCS87o/0cJrigkN+rbxsB6Fr kAar1dAvIQiU7igsE6A2DuLJrW43uIMso5wzoAuX6TFDDP3PcPS65gbtCqYg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

Use struct_group() in struct drm32_mga_init around members chipset, sgram,
maccess, fb_cpp, front_offset, front_pitch, back_offset, back_pitch,
depth_cpp, depth_offset, depth_pitch, texture_offset, and texture_size,
so they can be referenced together. This will allow memcpy() and sizeof()
to more easily reason about sizes, improve readability, and avoid future
warnings about writing beyond the end of chipset.

"pahole" shows no size nor member offset changes to struct drm32_mga_init.
"objdump -d" shows no meaningful object code changes (i.e. only source
line number induced differences and optimizations).

Note that since this includes a UAPI header, struct_group() has been
explicitly redefined local to the header.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/gpu/drm/mga/mga_ioc32.c | 30 ++++++++++++++------------
 include/uapi/drm/mga_drm.h      | 37 ++++++++++++++++++++++++---------
 2 files changed, 44 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/mga/mga_ioc32.c b/drivers/gpu/drm/mga/mga_ioc32.c
index 4fd4de16cd32..fbd0329dbd4f 100644
--- a/drivers/gpu/drm/mga/mga_ioc32.c
+++ b/drivers/gpu/drm/mga/mga_ioc32.c
@@ -38,16 +38,21 @@
 typedef struct drm32_mga_init {
 	int func;
 	u32 sarea_priv_offset;
-	int chipset;
-	int sgram;
-	unsigned int maccess;
-	unsigned int fb_cpp;
-	unsigned int front_offset, front_pitch;
-	unsigned int back_offset, back_pitch;
-	unsigned int depth_cpp;
-	unsigned int depth_offset, depth_pitch;
-	unsigned int texture_offset[MGA_NR_TEX_HEAPS];
-	unsigned int texture_size[MGA_NR_TEX_HEAPS];
+	struct_group(always32bit,
+		int chipset;
+		int sgram;
+		unsigned int maccess;
+		unsigned int fb_cpp;
+		unsigned int front_offset;
+		unsigned int front_pitch;
+		unsigned int back_offset;
+		unsigned int back_pitch;
+		unsigned int depth_cpp;
+		unsigned int depth_offset;
+		unsigned int depth_pitch;
+		unsigned int texture_offset[MGA_NR_TEX_HEAPS];
+		unsigned int texture_size[MGA_NR_TEX_HEAPS];
+	);
 	u32 fb_offset;
 	u32 mmio_offset;
 	u32 status_offset;
@@ -67,9 +72,8 @@ static int compat_mga_init(struct file *file, unsigned int cmd,
 
 	init.func = init32.func;
 	init.sarea_priv_offset = init32.sarea_priv_offset;
-	memcpy(&init.chipset, &init32.chipset,
-		offsetof(drm_mga_init_t, fb_offset) -
-		offsetof(drm_mga_init_t, chipset));
+	memcpy(&init.always32bit, &init32.always32bit,
+	       sizeof(init32.always32bit));
 	init.fb_offset = init32.fb_offset;
 	init.mmio_offset = init32.mmio_offset;
 	init.status_offset = init32.status_offset;
diff --git a/include/uapi/drm/mga_drm.h b/include/uapi/drm/mga_drm.h
index 8c4337548ab5..61612e5ecab2 100644
--- a/include/uapi/drm/mga_drm.h
+++ b/include/uapi/drm/mga_drm.h
@@ -265,6 +265,16 @@ typedef struct _drm_mga_sarea {
 #define DRM_IOCTL_MGA_WAIT_FENCE    DRM_IOWR(DRM_COMMAND_BASE + DRM_MGA_WAIT_FENCE, __u32)
 #define DRM_IOCTL_MGA_DMA_BOOTSTRAP DRM_IOWR(DRM_COMMAND_BASE + DRM_MGA_DMA_BOOTSTRAP, drm_mga_dma_bootstrap_t)
 
+#define __struct_group(name, fields) \
+	union { \
+		struct { \
+			fields \
+		}; \
+		struct { \
+			fields \
+		} name; \
+	}
+
 typedef struct _drm_mga_warp_index {
 	int installed;
 	unsigned long phys_addr;
@@ -279,20 +289,25 @@ typedef struct drm_mga_init {
 
 	unsigned long sarea_priv_offset;
 
-	int chipset;
-	int sgram;
+	__struct_group(always32bit,
+		int chipset;
+		int sgram;
 
-	unsigned int maccess;
+		unsigned int maccess;
 
-	unsigned int fb_cpp;
-	unsigned int front_offset, front_pitch;
-	unsigned int back_offset, back_pitch;
+		unsigned int fb_cpp;
+		unsigned int front_offset;
+		unsigned int front_pitch;
+		unsigned int back_offset;
+		unsigned int back_pitch;
 
-	unsigned int depth_cpp;
-	unsigned int depth_offset, depth_pitch;
+		unsigned int depth_cpp;
+		unsigned int depth_offset;
+		unsigned int depth_pitch;
 
-	unsigned int texture_offset[MGA_NR_TEX_HEAPS];
-	unsigned int texture_size[MGA_NR_TEX_HEAPS];
+		unsigned int texture_offset[MGA_NR_TEX_HEAPS];
+		unsigned int texture_size[MGA_NR_TEX_HEAPS];
+	);
 
 	unsigned long fb_offset;
 	unsigned long mmio_offset;
@@ -302,6 +317,8 @@ typedef struct drm_mga_init {
 	unsigned long buffers_offset;
 } drm_mga_init_t;
 
+#undef __struct_group
+
 typedef struct drm_mga_dma_bootstrap {
 	/**
 	 * \name AGP texture region
-- 
2.30.2

