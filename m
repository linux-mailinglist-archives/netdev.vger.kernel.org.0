Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296CB3EFC19
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240763AbhHRGSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238712AbhHRGP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:15:58 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F46C0363F9
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:14:18 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id n18so1158520pgm.12
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=axRxl6XNvdHdnVEeMiGlhBK2fx1eWMP1p1J87ZwKUtU=;
        b=JpKHmXU+6i0jG8irvmKVhzXirA7pH+W7nH7J14Qn327X+LOQf3pL7DowyuBtKsP5wC
         gHD1WyQqGKoFOHDbsbrtUlWANqYlMajHDOs5uRuKehjTdTUc/TyL5/NTurDtd+3UeEjx
         runJ9+RCI5UpKUek8ddHgjdTJKkDX36NxGr60=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=axRxl6XNvdHdnVEeMiGlhBK2fx1eWMP1p1J87ZwKUtU=;
        b=uP9yZo8LicSBERdYbfqKiBO10I6HTZRDgEYvmCrbzWEFZOAAlUKM4YQ7CbJJF1xZfB
         os0laUqwMCGYLq4j/3RwXdSBYFqWTUvcHPxSFvJrwYVZM2zOfBC9n7IY77QpV73c6Vzt
         KGEvAUZiEpDJJFBSfCtPS6zbp8+7KK1gsrW+oxBqqSDeaRZGEPwQSfXX1c6Akp6KlJ55
         g0Zh2Oi8BmxmWOcRRxCjnvc4xvkh63sX+vOaBQBfqbHWMzQBO/MODOqArWZ44odCbr0w
         GRj0HNPxVZPlVRKBgdhL0vXEVky9KiGqy5KwUfJSX+SIJ5OpYCtnAFvcaZiSAB5bCd98
         h3kw==
X-Gm-Message-State: AOAM533gfvQF4e5QQ/6z23i8hVEBeeiwvWUjqWW33wquXAPbgEYk78g5
        IpqU9XhAIUA56m9KVAWUhs3Pfg==
X-Google-Smtp-Source: ABdhPJxq4OGdaH6r9U7yhjNUxqwYDhkvChY0GjS3sW8r1FpsJJV1IJrOiRrj6WilyBToIyIfhh4sdw==
X-Received: by 2002:a65:4581:: with SMTP id o1mr7206734pgq.349.1629267257822;
        Tue, 17 Aug 2021 23:14:17 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k9sm4320391pfu.109.2021.08.17.23.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:14:15 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Feifei Xu <Feifei.Xu@amd.com>, Lijo Lazar <lijo.lazar@amd.com>,
        Likun Gao <Likun.Gao@amd.com>, Jiawei Gu <Jiawei.Gu@amd.com>,
        Evan Quan <evan.quan@amd.com>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 18/63] drm/amd/pm: Use struct_group() for memcpy() region
Date:   Tue, 17 Aug 2021 23:04:48 -0700
Message-Id: <20210818060533.3569517-19-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=9874; h=from:subject; bh=xkq/GgVQos4phY69YvlHwazwtJ7+oBoAW/iYv7WVAic=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMhiWVzzmhBur+1cBk2O2ZXVSjeLlgxz10CkbR5 AKO/11yJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjIQAKCRCJcvTf3G3AJht6EA CaYxNgC78NjMU3NXMgzorx6fRtH4BJwYIGJ74DB/m7swwaAHceyK1O/6lCQ7H812Aiiq4XK3QDmoUk qASs/4198qLTAEHhq7Q18FiMX2P3A7Q0631t7ABRcNNf+8sZXncmdOZPGYXpPAODBOCabM/f3/oDCx juRFOQ2unI6EojppuO7CJSyN6BitOl0EfAAVwzH5qdN0dbqjvmJWEk6DyGUh+uyHqAcClSWCqlrEC2 2OsaBqNYzf5j6vWeBx02EpyOWFqkO/XyPXBqw7kL7GIS2sxESQTqmhPrfGjlNI8aLc5oqP4Nz/mHlj izA+lyAMf9/CaxogHr7ad/WNivgAySk9xHsccW792p6SsKVbNUtuWM4hk2GkKJimH31lP9pcLQL2Ch j7xVH/dOlAV9Ftvi7+KvJI+v+DmQ/gRxe5YIRztukLnhmjPWcMqKsuKK44UwR65YeFh33G6UZWzhZj SwUBV/6zpAPgCZDoeJ5hTeN2HohgNJ0fijbEnaK+ifaUEslAh2R7Yxz9WjnXacxem2c2/Z6wGyyAdq 8GbFcwR+u8iKZLAOMc13DJT6zOgy8+ZXHxMay8F6GzxmI1F43Z0WF2KzMZDLs5tgRr/UrucI9TgIhX cizSF2eNXvheQca86HlnqqfZiLL7gsttRC6U5oD07PukPv3YeEniSDJPST0g==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

Use struct_group() in structs:
	struct atom_smc_dpm_info_v4_5
	struct atom_smc_dpm_info_v4_6
	struct atom_smc_dpm_info_v4_7
	struct atom_smc_dpm_info_v4_10
	PPTable_t
so the grouped members can be referenced together. This will allow
memcpy() and sizeof() to more easily reason about sizes, improve
readability, and avoid future warnings about writing beyond the end of
the first member.

"pahole" shows no size nor member offset changes to any structs.
"objdump -d" shows no object code changes.

Cc: "Christian König" <christian.koenig@amd.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Hawking Zhang <Hawking.Zhang@amd.com>
Cc: Feifei Xu <Feifei.Xu@amd.com>
Cc: Lijo Lazar <lijo.lazar@amd.com>
Cc: Likun Gao <Likun.Gao@amd.com>
Cc: Jiawei Gu <Jiawei.Gu@amd.com>
Cc: Evan Quan <evan.quan@amd.com>
Cc: amd-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://lore.kernel.org/lkml/CADnq5_Npb8uYvd+R4UHgf-w8-cQj3JoODjviJR_Y9w9wqJ71mQ@mail.gmail.com
---
 drivers/gpu/drm/amd/include/atomfirmware.h           |  9 ++++++++-
 .../gpu/drm/amd/pm/inc/smu11_driver_if_arcturus.h    |  3 ++-
 drivers/gpu/drm/amd/pm/inc/smu11_driver_if_navi10.h  |  3 ++-
 .../gpu/drm/amd/pm/inc/smu13_driver_if_aldebaran.h   |  3 ++-
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c    |  6 +++---
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c      | 12 ++++++++----
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c   |  6 +++---
 7 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/include/atomfirmware.h b/drivers/gpu/drm/amd/include/atomfirmware.h
index 44955458fe38..7bf3edf15410 100644
--- a/drivers/gpu/drm/amd/include/atomfirmware.h
+++ b/drivers/gpu/drm/amd/include/atomfirmware.h
@@ -2081,6 +2081,7 @@ struct atom_smc_dpm_info_v4_5
 {
   struct   atom_common_table_header  table_header;
     // SECTION: BOARD PARAMETERS
+  struct_group(dpm_info,
     // I2C Control
   struct smudpm_i2c_controller_config_v2  I2cControllers[8];
 
@@ -2159,7 +2160,7 @@ struct atom_smc_dpm_info_v4_5
   uint32_t MvddRatio; // This is used for MVDD Vid workaround. It has 16 fractional bits (Q16.16)
   
   uint32_t     BoardReserved[9];
-
+  );
 };
 
 struct atom_smc_dpm_info_v4_6
@@ -2168,6 +2169,7 @@ struct atom_smc_dpm_info_v4_6
   // section: board parameters
   uint32_t     i2c_padding[3];   // old i2c control are moved to new area
 
+  struct_group(dpm_info,
   uint16_t     maxvoltagestepgfx; // in mv(q2) max voltage step that smu will request. multiple steps are taken if voltage change exceeds this value.
   uint16_t     maxvoltagestepsoc; // in mv(q2) max voltage step that smu will request. multiple steps are taken if voltage change exceeds this value.
 
@@ -2246,12 +2248,14 @@ struct atom_smc_dpm_info_v4_6
 
   // reserved
   uint32_t   boardreserved[10];
+  );
 };
 
 struct atom_smc_dpm_info_v4_7
 {
   struct   atom_common_table_header  table_header;
     // SECTION: BOARD PARAMETERS
+  struct_group(dpm_info,
     // I2C Control
   struct smudpm_i2c_controller_config_v2  I2cControllers[8];
 
@@ -2348,6 +2352,7 @@ struct atom_smc_dpm_info_v4_7
   uint8_t      Padding8_Psi2;
 
   uint32_t     BoardReserved[5];
+  );
 };
 
 struct smudpm_i2c_controller_config_v3
@@ -2478,6 +2483,7 @@ struct atom_smc_dpm_info_v4_10
   struct   atom_common_table_header  table_header;
 
   // SECTION: BOARD PARAMETERS
+  struct_group(dpm_info,
   // Telemetry Settings
   uint16_t GfxMaxCurrent; // in Amps
   uint8_t   GfxOffset;     // in Amps
@@ -2524,6 +2530,7 @@ struct atom_smc_dpm_info_v4_10
   uint16_t spare5;
 
   uint32_t reserved[16];
+  );
 };
 
 /* 
diff --git a/drivers/gpu/drm/amd/pm/inc/smu11_driver_if_arcturus.h b/drivers/gpu/drm/amd/pm/inc/smu11_driver_if_arcturus.h
index 43d43d6addc0..8093a98800c3 100644
--- a/drivers/gpu/drm/amd/pm/inc/smu11_driver_if_arcturus.h
+++ b/drivers/gpu/drm/amd/pm/inc/smu11_driver_if_arcturus.h
@@ -643,6 +643,7 @@ typedef struct {
   // SECTION: BOARD PARAMETERS
 
   // SVI2 Board Parameters
+  struct_group(v4_6,
   uint16_t     MaxVoltageStepGfx; // In mV(Q2) Max voltage step that SMU will request. Multiple steps are taken if voltage change exceeds this value.
   uint16_t     MaxVoltageStepSoc; // In mV(Q2) Max voltage step that SMU will request. Multiple steps are taken if voltage change exceeds this value.
 
@@ -728,10 +729,10 @@ typedef struct {
   uint32_t     BoardVoltageCoeffB;    // decode by /1000
 
   uint32_t     BoardReserved[7];
+  );
 
   // Padding for MMHUB - do not modify this
   uint32_t     MmHubPadding[8]; // SMU internal use
-
 } PPTable_t;
 
 typedef struct {
diff --git a/drivers/gpu/drm/amd/pm/inc/smu11_driver_if_navi10.h b/drivers/gpu/drm/amd/pm/inc/smu11_driver_if_navi10.h
index 04752ade1016..0b4e6e907e95 100644
--- a/drivers/gpu/drm/amd/pm/inc/smu11_driver_if_navi10.h
+++ b/drivers/gpu/drm/amd/pm/inc/smu11_driver_if_navi10.h
@@ -725,6 +725,7 @@ typedef struct {
   uint32_t     Reserved[8];
 
   // SECTION: BOARD PARAMETERS
+  struct_group(v4,
   // I2C Control
   I2cControllerConfig_t  I2cControllers[NUM_I2C_CONTROLLERS];     
 
@@ -809,10 +810,10 @@ typedef struct {
   uint8_t      Padding8_Loadline;
 
   uint32_t     BoardReserved[8];
+  );
 
   // Padding for MMHUB - do not modify this
   uint32_t     MmHubPadding[8]; // SMU internal use
-
 } PPTable_t;
 
 typedef struct {
diff --git a/drivers/gpu/drm/amd/pm/inc/smu13_driver_if_aldebaran.h b/drivers/gpu/drm/amd/pm/inc/smu13_driver_if_aldebaran.h
index a017983ff1fa..5056d3728da8 100644
--- a/drivers/gpu/drm/amd/pm/inc/smu13_driver_if_aldebaran.h
+++ b/drivers/gpu/drm/amd/pm/inc/smu13_driver_if_aldebaran.h
@@ -390,6 +390,7 @@ typedef struct {
   uint32_t spare3[14];
 
   // SECTION: BOARD PARAMETERS
+  struct_group(v4_10,
   // Telemetry Settings
   uint16_t GfxMaxCurrent; // in Amps
   int8_t   GfxOffset;     // in Amps
@@ -444,7 +445,7 @@ typedef struct {
 
   //reserved
   uint32_t reserved[14];
-
+  );
 } PPTable_t;
 
 typedef struct {
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
index 8ab58781ae13..341adf209240 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
@@ -463,11 +463,11 @@ static int arcturus_append_powerplay_table(struct smu_context *smu)
 			smc_dpm_table->table_header.format_revision,
 			smc_dpm_table->table_header.content_revision);
 
+	BUILD_BUG_ON(sizeof(smc_pptable->v4_6) != sizeof(smc_dpm_table->dpm_info));
 	if ((smc_dpm_table->table_header.format_revision == 4) &&
 	    (smc_dpm_table->table_header.content_revision == 6))
-		memcpy(&smc_pptable->MaxVoltageStepGfx,
-		       &smc_dpm_table->maxvoltagestepgfx,
-		       sizeof(*smc_dpm_table) - offsetof(struct atom_smc_dpm_info_v4_6, maxvoltagestepgfx));
+		memcpy(&smc_pptable->v4_6, &smc_dpm_table->dpm_info,
+		       sizeof(smc_dpm_table->dpm_info));
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
index 2e5d3669652b..e8b6e25a7815 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
@@ -431,16 +431,20 @@ static int navi10_append_powerplay_table(struct smu_context *smu)
 
 	switch (smc_dpm_table->table_header.content_revision) {
 	case 5: /* nv10 and nv14 */
-		memcpy(smc_pptable->I2cControllers, smc_dpm_table->I2cControllers,
-			sizeof(*smc_dpm_table) - sizeof(smc_dpm_table->table_header));
+		BUILD_BUG_ON(sizeof(smc_pptable->v4) !=
+			     sizeof(smc_dpm_table->dpm_info));
+		memcpy(&smc_pptable->v4, &smc_dpm_table->dpm_info,
+		       sizeof(smc_dpm_table->dpm_info));
 		break;
 	case 7: /* nv12 */
 		ret = amdgpu_atombios_get_data_table(adev, index, NULL, NULL, NULL,
 					      (uint8_t **)&smc_dpm_table_v4_7);
 		if (ret)
 			return ret;
-		memcpy(smc_pptable->I2cControllers, smc_dpm_table_v4_7->I2cControllers,
-			sizeof(*smc_dpm_table_v4_7) - sizeof(smc_dpm_table_v4_7->table_header));
+		BUILD_BUG_ON(sizeof(smc_pptable->v4) !=
+			     sizeof(smc_dpm_table_v4_7->dpm_info));
+		memcpy(&smc_pptable->v4, &smc_dpm_table_v4_7->dpm_info,
+		       sizeof(smc_dpm_table_v4_7->dpm_info));
 		break;
 	default:
 		dev_err(smu->adev->dev, "smc_dpm_info with unsupported content revision %d!\n",
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
index c8eefacfdd37..492ba37bc514 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -407,11 +407,11 @@ static int aldebaran_append_powerplay_table(struct smu_context *smu)
 			smc_dpm_table->table_header.format_revision,
 			smc_dpm_table->table_header.content_revision);
 
+	BUILD_BUG_ON(sizeof(smc_pptable->v4_10) != sizeof(smc_dpm_table->dpm_info));
 	if ((smc_dpm_table->table_header.format_revision == 4) &&
 	    (smc_dpm_table->table_header.content_revision == 10))
-		memcpy(&smc_pptable->GfxMaxCurrent,
-		       &smc_dpm_table->GfxMaxCurrent,
-		       sizeof(*smc_dpm_table) - offsetof(struct atom_smc_dpm_info_v4_10, GfxMaxCurrent));
+		memcpy(&smc_pptable->v4_10, &smc_dpm_table->dpm_info,
+		       sizeof(smc_dpm_table->dpm_info));
 	return 0;
 }
 
-- 
2.30.2

