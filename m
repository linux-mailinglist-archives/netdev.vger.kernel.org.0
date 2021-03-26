Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B069234AB1D
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 16:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhCZPMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 11:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbhCZPLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 11:11:30 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11784C0613AA
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 08:11:30 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id b10so5726140iot.4
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 08:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o3Amz4sRXqrDeeMEBKQe2cGc+ePyC2Wm+fZmxeTt5jY=;
        b=kdfXL7dPCD+/9w8rraTmM/vobvbdbr33L08nwKp5QHre+h0stt4UQKj7mZndLNn6hI
         Ac31b4ILq+6qBnBmrWNDxtsHWL3QJmntwuZYVkRWsC3cRaLre8WhC+W9YTCSqrrjUdp+
         btEaRf4gMro7ljk58/xyVtdgTKh4aVqay4DuWxmNDSeLQLv0ZvrMSftyWqLACr05roPX
         NYQdF8y79SyRy5cy1IDmxjiscFZSAKnB4kwLj9FsBNyNXKHzi7swODHE5E0USMdrIkWk
         6f1py4TOjKE4yi8aj43wB9hyHTpWZz3Z3NEelZmbOSBANSvqIBjyXClUhbVnzvCvEpP7
         Jlcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o3Amz4sRXqrDeeMEBKQe2cGc+ePyC2Wm+fZmxeTt5jY=;
        b=cF8Vz7GtDSkNr1GX2UFT6H3alHnc1QimWuXW4o/jHjRn5+mMgkRFwWO0Es1SelD5r9
         1EDbI2qeUwcZfRDT8CFlc4QDvUC0q+IyrAEBaAx4yEvoK7pNa83RuYM5xqQdEZ5iHYOT
         NfPLf0vuh5MuNvUw0GqQx0/nnQ1+y0CV0zM1Va08zuKkN8TQq4inYoHPUgBZ22Lry3Zr
         /+Bb6PYUphsxSd/hNV63D9G4RohLqBwj89Imxs9CNTCgjSbEK6sWBYKdk3LR6RoVrwvA
         oqyH9X8jtwX/P+d1KntM4DjD7g5rlsFIgggcVS4vK6A8rvAfkUtIUTONYKc1rbkptCsp
         mrYA==
X-Gm-Message-State: AOAM5311IeR3wiM9C4QKrMV2ItTU9gMKTZ1kPewg3VBtdquKf7ZZlMz1
        4ZqOkO2AdGEgkChL+NSIydWdiA==
X-Google-Smtp-Source: ABdhPJy7u4O/1EoD5Y0VlGDsPplpz3pjMNUMpGLxrM8BCKZ1wVG+sbhWVevpTNYUgjVWxUXVK5Kivw==
X-Received: by 2002:a02:2412:: with SMTP id f18mr12534463jaa.142.1616771489534;
        Fri, 26 Mar 2021 08:11:29 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j17sm4537706iok.37.2021.03.26.08.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 08:11:29 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 03/12] net: ipa: identify resource groups
Date:   Fri, 26 Mar 2021 10:11:13 -0500
Message-Id: <20210326151122.3121383-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210326151122.3121383-1-elder@linaro.org>
References: <20210326151122.3121383-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define a new ipa_resource_group_id enumerated type, whose members
have numeric values that match the resource group number used when
programming the hardware.  Each platform supports a different number
of source and destination resource groups, so define the type
separately for each platform in its configuration data file.

Use these new symbolic values when specifying the resource group an
endpoint is associated with.  And use them to index the limits
arrays for source and destination resources, making it clearer how
these values are used.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-sc7180.c | 38 ++++++++++++---------
 drivers/net/ipa/ipa_data-sdm845.c | 56 +++++++++++++++++++------------
 2 files changed, 57 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ipa/ipa_data-sc7180.c b/drivers/net/ipa/ipa_data-sc7180.c
index 621ad15c9e67d..e9b741832a1d7 100644
--- a/drivers/net/ipa/ipa_data-sc7180.c
+++ b/drivers/net/ipa/ipa_data-sc7180.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
-/* Copyright (C) 2019-2020 Linaro Ltd. */
+/* Copyright (C) 2019-2021 Linaro Ltd. */
 
 #include <linux/log2.h>
 
@@ -9,6 +9,15 @@
 #include "ipa_endpoint.h"
 #include "ipa_mem.h"
 
+/* Resource groups used for the SC7180 SoC */
+enum ipa_rsrc_group_id {
+	/* Source resource group identifiers */
+	IPA_RSRC_GROUP_SRC_UL_DL	= 0,
+
+	/* Destination resource group identifiers */
+	IPA_RSRC_GROUP_DST_UL_DL_DPL	= 0,
+};
+
 /* QSB configuration for the SC7180 SoC. */
 static const struct ipa_qsb_data ipa_qsb_data[] = {
 	[IPA_QSB_MASTER_DDR] = {
@@ -32,7 +41,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		},
 		.endpoint = {
 			.config = {
-				.resource_group	= 0,
+				.resource_group	= IPA_RSRC_GROUP_SRC_UL_DL,
 				.dma_mode	= true,
 				.dma_endpoint	= IPA_ENDPOINT_AP_LAN_RX,
 				.tx = {
@@ -53,7 +62,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		},
 		.endpoint = {
 			.config = {
-				.resource_group	= 0,
+				.resource_group	= IPA_RSRC_GROUP_DST_UL_DL_DPL,
 				.aggregation	= true,
 				.status_enable	= true,
 				.rx = {
@@ -75,7 +84,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		.endpoint = {
 			.filter_support	= true,
 			.config = {
-				.resource_group	= 0,
+				.resource_group	= IPA_RSRC_GROUP_SRC_UL_DL,
 				.checksum	= true,
 				.qmap		= true,
 				.status_enable	= true,
@@ -100,7 +109,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		},
 		.endpoint = {
 			.config = {
-				.resource_group	= 0,
+				.resource_group	= IPA_RSRC_GROUP_DST_UL_DL_DPL,
 				.checksum	= true,
 				.qmap		= true,
 				.aggregation	= true,
@@ -139,58 +148,57 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 	},
 };
 
-/* For the SC7180, resource groups are allocated this way:
- *   group 0:	UL_DL
- */
+/* Source resource configuration data for the SC7180 SoC */
 static const struct ipa_resource_src ipa_resource_src[] = {
 	{
 		.type = IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS,
-		.limits[0] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
 			.min = 3,
 			.max = 63,
 		},
 	},
 	{
 		.type = IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_LISTS,
-		.limits[0] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
 			.min = 3,
 			.max = 3,
 		},
 	},
 	{
 		.type = IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_BUFF,
-		.limits[0] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
 			.min = 10,
 			.max = 10,
 		},
 	},
 	{
 		.type = IPA_RESOURCE_TYPE_SRC_HPS_DMARS,
-		.limits[0] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
 			.min = 1,
 			.max = 1,
 		},
 	},
 	{
 		.type = IPA_RESOURCE_TYPE_SRC_ACK_ENTRIES,
-		.limits[0] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
 			.min = 5,
 			.max = 5,
 		},
 	},
 };
 
+/* Destination resource configuration data for the SC7180 SoC */
 static const struct ipa_resource_dst ipa_resource_dst[] = {
 	{
 		.type = IPA_RESOURCE_TYPE_DST_DATA_SECTORS,
-		.limits[0] = {
+		.limits[IPA_RSRC_GROUP_DST_UL_DL_DPL] = {
 			.min = 3,
 			.max = 3,
 		},
 	},
 	{
 		.type = IPA_RESOURCE_TYPE_DST_DPS_DMARS,
-		.limits[0] = {
+		.limits[IPA_RSRC_GROUP_DST_UL_DL_DPL] = {
 			.min = 1,
 			.max = 63,
 		},
diff --git a/drivers/net/ipa/ipa_data-sdm845.c b/drivers/net/ipa/ipa_data-sdm845.c
index 6b5173f474444..b6ea6295e7598 100644
--- a/drivers/net/ipa/ipa_data-sdm845.c
+++ b/drivers/net/ipa/ipa_data-sdm845.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2020 Linaro Ltd.
+ * Copyright (C) 2019-2021 Linaro Ltd.
  */
 
 #include <linux/log2.h>
@@ -11,6 +11,20 @@
 #include "ipa_endpoint.h"
 #include "ipa_mem.h"
 
+/* Resource groups used for the SDM845 SoC */
+enum ipa_rsrc_group_id {
+	/* Source resource group identifiers */
+	IPA_RSRC_GROUP_SRC_LWA_DL	= 0,
+	IPA_RSRC_GROUP_SRC_UL_DL,
+	IPA_RSRC_GROUP_SRC_MHI_DMA,
+	IPA_RSRC_GROUP_SRC_UC_RX_Q,
+
+	/* Destination resource group identifiers */
+	IPA_RSRC_GROUP_DST_LWA_DL	= 0,
+	IPA_RSRC_GROUP_DST_UL_DL_DPL,
+	IPA_RSRC_GROUP_DST_UNUSED_2,
+};
+
 /* QSB configuration for the SDM845 SoC. */
 static const struct ipa_qsb_data ipa_qsb_data[] = {
 	[IPA_QSB_MASTER_DDR] = {
@@ -37,7 +51,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		},
 		.endpoint = {
 			.config = {
-				.resource_group	= 1,
+				.resource_group	= IPA_RSRC_GROUP_SRC_UL_DL,
 				.dma_mode	= true,
 				.dma_endpoint	= IPA_ENDPOINT_AP_LAN_RX,
 				.tx = {
@@ -58,7 +72,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		},
 		.endpoint = {
 			.config = {
-				.resource_group	= 1,
+				.resource_group	= IPA_RSRC_GROUP_DST_UL_DL_DPL,
 				.aggregation	= true,
 				.status_enable	= true,
 				.rx = {
@@ -80,7 +94,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		.endpoint = {
 			.filter_support	= true,
 			.config = {
-				.resource_group	= 1,
+				.resource_group	= IPA_RSRC_GROUP_SRC_UL_DL,
 				.checksum	= true,
 				.qmap		= true,
 				.status_enable	= true,
@@ -104,7 +118,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		},
 		.endpoint = {
 			.config = {
-				.resource_group	= 1,
+				.resource_group	= IPA_RSRC_GROUP_DST_UL_DL_DPL,
 				.checksum	= true,
 				.qmap		= true,
 				.aggregation	= true,
@@ -152,72 +166,70 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 	},
 };
 
-/* For the SDM845, resource groups are allocated this way:
- *   group 0:	LWA_DL
- *   group 1:	UL_DL
- */
+/* Source resource configuration data for the SDM845 SoC */
 static const struct ipa_resource_src ipa_resource_src[] = {
 	{
 		.type = IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS,
-		.limits[0] = {
+		.limits[IPA_RSRC_GROUP_SRC_LWA_DL] = {
 			.min = 1,
 			.max = 255,
 		},
-		.limits[1] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
 			.min = 1,
 			.max = 255,
 		},
 	},
 	{
 		.type = IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_LISTS,
-		.limits[0] = {
+		.limits[IPA_RSRC_GROUP_SRC_LWA_DL] = {
 			.min = 10,
 			.max = 10,
 		},
-		.limits[1] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
 			.min = 10,
 			.max = 10,
 		},
 	},
 	{
 		.type = IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_BUFF,
-		.limits[0] = {
+		.limits[IPA_RSRC_GROUP_SRC_LWA_DL] = {
 			.min = 12,
 			.max = 12,
 		},
-		.limits[1] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
 			.min = 14,
 			.max = 14,
 		},
 	},
 	{
 		.type = IPA_RESOURCE_TYPE_SRC_HPS_DMARS,
-		.limits[0] = {
+		.limits[IPA_RSRC_GROUP_SRC_LWA_DL] = {
 			.min = 0,
 			.max = 63,
 		},
-		.limits[1] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
 			.min = 0,
 			.max = 63,
 		},
 	},
 	{
 		.type = IPA_RESOURCE_TYPE_SRC_ACK_ENTRIES,
-		.limits[0] = {
+		.limits[IPA_RSRC_GROUP_SRC_LWA_DL] = {
 			.min = 14,
 			.max = 14,
 		},
-		.limits[1] = {
+		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
 			.min = 20,
 			.max = 20,
 		},
 	},
 };
 
+/* Destination resource configuration data for the SDM845 SoC */
 static const struct ipa_resource_dst ipa_resource_dst[] = {
 	{
 		.type = IPA_RESOURCE_TYPE_DST_DATA_SECTORS,
-		.limits[0] = {
+		.limits[IPA_RSRC_GROUP_DST_LWA_DL] = {
 			.min = 4,
 			.max = 4,
 		},
@@ -228,11 +240,11 @@ static const struct ipa_resource_dst ipa_resource_dst[] = {
 	},
 	{
 		.type = IPA_RESOURCE_TYPE_DST_DPS_DMARS,
-		.limits[0] = {
+		.limits[IPA_RSRC_GROUP_DST_LWA_DL] = {
 			.min = 2,
 			.max = 63,
 		},
-		.limits[1] = {
+		.limits[IPA_RSRC_GROUP_DST_UL_DL_DPL] = {
 			.min = 1,
 			.max = 63,
 		},
-- 
2.27.0

