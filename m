Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B663EFC29
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240838AbhHRGTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238444AbhHRGPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:15:55 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD29C0363F2
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:14:17 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id e19so1121683pla.10
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0MMWsXNyPTiNeiAP5gS1SC+QG9nXJlmhwzZVB05s6vU=;
        b=lFnsOWBb7INVqCBC7qdAJtdwm7/YI/zQgCoP3x3m0bM+t5LwRECJJtnUsDrlQxjrhX
         QHqsidPkWI4X7e2ihavui/Ywcxlnw/aFhClReU+sv9f1EOAIRk2xMvoRioWP+UFLSFBK
         RCfXzgJGwfpUuLe9H9dmyKkDNrcpU89QSc2mo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0MMWsXNyPTiNeiAP5gS1SC+QG9nXJlmhwzZVB05s6vU=;
        b=NN+a/c3CgTfWLH0NSUa/cKh7rsApcp0gNUDhSiDqSEImCJ+kzFqIDh0jaOw9DJi1OJ
         6oTnri/wXXTM7q//FyrEYxkx7KpbFQa9TuMaB5xPl1AupzXBeKO7IYfikAxqPE2+VeAW
         dBcLn5jOaINcRkeuk4So+tHDPhEad7n1JVtoOCKWmM2jpi4X78AQoLaxuGnbXvht2qsF
         dxMy8kcJPhYDdPihJHAh35BdTgjM+3NdnsbW1RLHfgBVHn3FCZuREaa2/GtAzdYTH7vB
         A6Fms/YCv05xFmXBsyEaXNNUl9SWDoGWqoSk5IUhFiniKe1CQPHqeCDQFIAJfiW3+JEb
         dqiA==
X-Gm-Message-State: AOAM530xzvKFV4sc8cXmZVHe5ysPDa1rQ32rzKB6mlhH9TxJkkNG6mze
        2cRk0blgZYVaD47mTIPMnacpPg==
X-Google-Smtp-Source: ABdhPJzuLn/Q432TdsC9Yx7ftRK4PSNzWyeMnAwx3i8tWLw6BmbXc/OzOJqqzYHaCmof15Jus1chGA==
X-Received: by 2002:a17:90a:f3d2:: with SMTP id ha18mr7684231pjb.232.1629267256892;
        Tue, 17 Aug 2021 23:14:16 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y64sm5430806pgy.32.2021.08.17.23.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:14:15 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>, David Airlie <airlied@linux.ie>,
        Lee Jones <lee.jones@linaro.org>,
        dri-devel@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 20/63] drm/mga/mga_ioc32: Use struct_group() for memcpy() region
Date:   Tue, 17 Aug 2021 23:04:50 -0700
Message-Id: <20210818060533.3569517-21-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4026; h=from:subject; bh=qstupb1mRvuiCQ1RTR6k6oV2NxQS+tS8y2enFqRpd68=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMiDAfxk4XGgNDwyOny5QMoIdZacepKSLc24F9z Lo7XG+GJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjIgAKCRCJcvTf3G3AJh6oD/ 9Ovp0Ql0AYVAVX1IIx8UFncQNMHylWbLYYu/pPeuq//n2vP3YxPODUvUsOhKeGvOP827UQo0zYW5iy tgiG1WBc8ebgh5QPmWb88QrAINPUhtbBp+Ot3NMw60te7sqbHEXsxkZV30DmTsosmCxyISKjyVvCWu k9+q0dosQewqL6/+1hWYp1uFW9SNaxLwoQPTdmTeeACtkvBcffo8L6czjWkLiNyOMCTdoqoQssvvRu zHaZ9swQIAAFRlHyaIwcnYCD8acVZhrpgLkn3SFlhEWx/CsFsuWCNm8ykKqoemb7waZs2mfagTLdNd j9c/hMpmgkGT5eBVZm8ZZc0VIpiQDZFHDrAdet4mxrXfRctgoALoLZZXdvZ6hovyaCJEmAL4dpEmzB SfbVedU11Uqk4gqtVGAPiExd0oEsgw9aH5Yi6f5Kq0NHSdjbUKSXAMoY/rdvqf/QkxZBOmr8Wsmgyh uaHkoAimq3GMz0bp3wb+4kSgsFxg4xCu45/FPrJc/fxu4K2kRpOUDG1wDjMc1G1trTeP21//dqz/DY dcmxUTtVuVe2fPww119RF2WXn3/GxtNi5RK7uTtxCgWr96J2MocjYw5//xWdXRfEEWLjXFK52hcX2N rEw10lDXzkEK6IQwMathNTugVFdbD4ID3UeC/FzYInnBnFPluTRksv4HTSmA==
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

Note that since this is a UAPI header, __struct_group() is used
directly.

Cc: David Airlie <airlied@linux.ie>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Daniel Vetter <daniel@ffwll.ch>
Link: https://lore.kernel.org/lkml/YQKa76A6XuFqgM03@phenom.ffwll.local
---
 drivers/gpu/drm/mga/mga_ioc32.c | 27 ++++++++++++++-------------
 include/uapi/drm/mga_drm.h      | 22 ++++++++++++----------
 2 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/mga/mga_ioc32.c b/drivers/gpu/drm/mga/mga_ioc32.c
index 4fd4de16cd32..894472921c30 100644
--- a/drivers/gpu/drm/mga/mga_ioc32.c
+++ b/drivers/gpu/drm/mga/mga_ioc32.c
@@ -38,16 +38,18 @@
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
+		unsigned int front_offset, front_pitch;
+		unsigned int back_offset, back_pitch;
+		unsigned int depth_cpp;
+		unsigned int depth_offset, depth_pitch;
+		unsigned int texture_offset[MGA_NR_TEX_HEAPS];
+		unsigned int texture_size[MGA_NR_TEX_HEAPS];
+	);
 	u32 fb_offset;
 	u32 mmio_offset;
 	u32 status_offset;
@@ -67,9 +69,8 @@ static int compat_mga_init(struct file *file, unsigned int cmd,
 
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
index 8c4337548ab5..2978a435dff9 100644
--- a/include/uapi/drm/mga_drm.h
+++ b/include/uapi/drm/mga_drm.h
@@ -279,20 +279,22 @@ typedef struct drm_mga_init {
 
 	unsigned long sarea_priv_offset;
 
-	int chipset;
-	int sgram;
+	__struct_group(/* no tye */, always32bit, /* no attrs */,
+		int chipset;
+		int sgram;
 
-	unsigned int maccess;
+		unsigned int maccess;
 
-	unsigned int fb_cpp;
-	unsigned int front_offset, front_pitch;
-	unsigned int back_offset, back_pitch;
+		unsigned int fb_cpp;
+		unsigned int front_offset, front_pitch;
+		unsigned int back_offset, back_pitch;
 
-	unsigned int depth_cpp;
-	unsigned int depth_offset, depth_pitch;
+		unsigned int depth_cpp;
+		unsigned int depth_offset, depth_pitch;
 
-	unsigned int texture_offset[MGA_NR_TEX_HEAPS];
-	unsigned int texture_size[MGA_NR_TEX_HEAPS];
+		unsigned int texture_offset[MGA_NR_TEX_HEAPS];
+		unsigned int texture_size[MGA_NR_TEX_HEAPS];
+	);
 
 	unsigned long fb_offset;
 	unsigned long mmio_offset;
-- 
2.30.2

