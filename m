Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DD134AB10
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 16:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhCZPMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 11:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbhCZPLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 11:11:33 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF09C0613B2
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 08:11:32 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id v26so5705294iox.11
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 08:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ExZayPUZjQrCngYFQGmavK/VEKOrkf3H2hg2gfVHU8I=;
        b=thZ5Gbkwu/6nG4hxZ+T9fwrACubOo1AcaLFubMrJ62tZBOEGewgiZfSaeqbgA4l7Lo
         sIKIuqNPX/R4wXDRK7NN1TGuj+6JY5nDmtlkPwBZ1mFFA3zhIYPKAkKYR/nSVhpI3ao7
         /J4cArRcDEEnczJs1jLy/RHpto9ZxwwGC7BsBKKIbDiqUTepiy8yS/M2eURRpjkCSXzS
         p2LVBsdjdBbaLAw4KERKYP17OXzMJH1LS+pQ+4EO0+1WuaW4eKp5dvJMgHbQIXXzfTIs
         9TkSeRsRwzmWrbLQzXpY9FqJNhGfbXxWRZNoCXIuuv2N4vJOm+xCX90VobciAfA9HXDY
         aV/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ExZayPUZjQrCngYFQGmavK/VEKOrkf3H2hg2gfVHU8I=;
        b=hsddhaDV9jy+f9PLUzc8IcBEEVterfMLmWAIesP2GbXhxanfhP8A15JGc9kv/l/nbt
         wqolRyjDYVtGhtmFGTHmKs5qilcV1erhCxhROSr+2IilJ6I9NJrR2yWdKmXVroN8ATgk
         oqQnZaPqFs4wiA918g1gY5PaPRjakKwBHXvYg7EWwgBoAYZ0+l+bTN83QlcDIUQCAAz+
         M9mbn30I/uD8opOvMSjOi1T0ezE0bxJ1iVuUYNGvQ+D9rkULXf3ct0ELpD5UfnMgOLjB
         xCmNaF3KDMN/cKiKk2RIkAsDmz2pTP2vwJMpGkanVtVSllQy39P+L+QBPoHt4/Vj7lPy
         yr3A==
X-Gm-Message-State: AOAM532s/WHsDmxNUY8m/lCNO0iSpKptyn9NglzaiMKl8QJIVdZW2FQT
        p7f4I4ugIa/SX1PdoVuajyoezw==
X-Google-Smtp-Source: ABdhPJy+bFsgRAyofNt2+qFyKkRWXwVCeIE83Yh2pPZ7ZDbet4moXLN/xK9oLbCMXujb6evGXv1Vcw==
X-Received: by 2002:a02:c6ae:: with SMTP id o14mr12413055jan.33.1616771492191;
        Fri, 26 Mar 2021 08:11:32 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j17sm4537706iok.37.2021.03.26.08.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 08:11:31 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 06/12] net: ipa: index resource limits with type
Date:   Fri, 26 Mar 2021 10:11:16 -0500
Message-Id: <20210326151122.3121383-7-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210326151122.3121383-1-elder@linaro.org>
References: <20210326151122.3121383-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the type field from the ipa_resource_src and ipa_resource_dst
structures, and instead use that value as the index into the arrays
of source and destination resources.

Change ipa_resource_config_src() and ipa_resource_config_dst() so
the resource type is passed in as an argument.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-sc7180.c | 21 +++++++--------------
 drivers/net/ipa/ipa_data-sdm845.c | 21 +++++++--------------
 drivers/net/ipa/ipa_data.h        |  4 ----
 drivers/net/ipa/ipa_resource.c    | 20 ++++++++++----------
 4 files changed, 24 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ipa/ipa_data-sc7180.c b/drivers/net/ipa/ipa_data-sc7180.c
index e9b741832a1d7..eba14d7bc8ac3 100644
--- a/drivers/net/ipa/ipa_data-sc7180.c
+++ b/drivers/net/ipa/ipa_data-sc7180.c
@@ -150,36 +150,31 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 
 /* Source resource configuration data for the SC7180 SoC */
 static const struct ipa_resource_src ipa_resource_src[] = {
-	{
-		.type = IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS,
+	[IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS] = {
 		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
 			.min = 3,
 			.max = 63,
 		},
 	},
-	{
-		.type = IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_LISTS,
+	[IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_LISTS] = {
 		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
 			.min = 3,
 			.max = 3,
 		},
 	},
-	{
-		.type = IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_BUFF,
+	[IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_BUFF] = {
 		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
 			.min = 10,
 			.max = 10,
 		},
 	},
-	{
-		.type = IPA_RESOURCE_TYPE_SRC_HPS_DMARS,
+	[IPA_RESOURCE_TYPE_SRC_HPS_DMARS] = {
 		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
 			.min = 1,
 			.max = 1,
 		},
 	},
-	{
-		.type = IPA_RESOURCE_TYPE_SRC_ACK_ENTRIES,
+	[IPA_RESOURCE_TYPE_SRC_ACK_ENTRIES] = {
 		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
 			.min = 5,
 			.max = 5,
@@ -189,15 +184,13 @@ static const struct ipa_resource_src ipa_resource_src[] = {
 
 /* Destination resource configuration data for the SC7180 SoC */
 static const struct ipa_resource_dst ipa_resource_dst[] = {
-	{
-		.type = IPA_RESOURCE_TYPE_DST_DATA_SECTORS,
+	[IPA_RESOURCE_TYPE_DST_DATA_SECTORS] = {
 		.limits[IPA_RSRC_GROUP_DST_UL_DL_DPL] = {
 			.min = 3,
 			.max = 3,
 		},
 	},
-	{
-		.type = IPA_RESOURCE_TYPE_DST_DPS_DMARS,
+	[IPA_RESOURCE_TYPE_DST_DPS_DMARS] = {
 		.limits[IPA_RSRC_GROUP_DST_UL_DL_DPL] = {
 			.min = 1,
 			.max = 63,
diff --git a/drivers/net/ipa/ipa_data-sdm845.c b/drivers/net/ipa/ipa_data-sdm845.c
index 3bc5fcfdf960c..4a4b3bd8a17c0 100644
--- a/drivers/net/ipa/ipa_data-sdm845.c
+++ b/drivers/net/ipa/ipa_data-sdm845.c
@@ -168,8 +168,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 
 /* Source resource configuration data for the SDM845 SoC */
 static const struct ipa_resource_src ipa_resource_src[] = {
-	{
-		.type = IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS,
+	[IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS] = {
 		.limits[IPA_RSRC_GROUP_SRC_LWA_DL] = {
 			.min = 1,
 			.max = 255,
@@ -183,8 +182,7 @@ static const struct ipa_resource_src ipa_resource_src[] = {
 			.max = 63,
 		},
 	},
-	{
-		.type = IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_LISTS,
+	[IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_LISTS] = {
 		.limits[IPA_RSRC_GROUP_SRC_LWA_DL] = {
 			.min = 10,
 			.max = 10,
@@ -198,8 +196,7 @@ static const struct ipa_resource_src ipa_resource_src[] = {
 			.max = 8,
 		},
 	},
-	{
-		.type = IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_BUFF,
+	[IPA_RESOURCE_TYPE_SRC_DESCRIPTOR_BUFF] = {
 		.limits[IPA_RSRC_GROUP_SRC_LWA_DL] = {
 			.min = 12,
 			.max = 12,
@@ -213,8 +210,7 @@ static const struct ipa_resource_src ipa_resource_src[] = {
 			.max = 8,
 		},
 	},
-	{
-		.type = IPA_RESOURCE_TYPE_SRC_HPS_DMARS,
+	[IPA_RESOURCE_TYPE_SRC_HPS_DMARS] = {
 		.limits[IPA_RSRC_GROUP_SRC_LWA_DL] = {
 			.min = 0,
 			.max = 63,
@@ -232,8 +228,7 @@ static const struct ipa_resource_src ipa_resource_src[] = {
 			.max = 63,
 		},
 	},
-	{
-		.type = IPA_RESOURCE_TYPE_SRC_ACK_ENTRIES,
+	[IPA_RESOURCE_TYPE_SRC_ACK_ENTRIES] = {
 		.limits[IPA_RSRC_GROUP_SRC_LWA_DL] = {
 			.min = 14,
 			.max = 14,
@@ -251,8 +246,7 @@ static const struct ipa_resource_src ipa_resource_src[] = {
 
 /* Destination resource configuration data for the SDM845 SoC */
 static const struct ipa_resource_dst ipa_resource_dst[] = {
-	{
-		.type = IPA_RESOURCE_TYPE_DST_DATA_SECTORS,
+	[IPA_RESOURCE_TYPE_DST_DATA_SECTORS] = {
 		.limits[IPA_RSRC_GROUP_DST_LWA_DL] = {
 			.min = 4,
 			.max = 4,
@@ -266,8 +260,7 @@ static const struct ipa_resource_dst ipa_resource_dst[] = {
 			.max = 3,
 		}
 	},
-	{
-		.type = IPA_RESOURCE_TYPE_DST_DPS_DMARS,
+	[IPA_RESOURCE_TYPE_DST_DPS_DMARS] = {
 		.limits[IPA_RSRC_GROUP_DST_LWA_DL] = {
 			.min = 2,
 			.max = 63,
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index ccd7fd0b801aa..44b93f93ee608 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -220,21 +220,17 @@ struct ipa_resource_limits {
 
 /**
  * struct ipa_resource_src - source endpoint group resource usage
- * @type:	source group resource type
  * @limits:	array of limits to use for each resource group
  */
 struct ipa_resource_src {
-	enum ipa_resource_type type;	/* IPA_RESOURCE_TYPE_SRC_* */
 	struct ipa_resource_limits limits[IPA_RESOURCE_GROUP_SRC_MAX];
 };
 
 /**
  * struct ipa_resource_dst - destination endpoint group resource usage
- * @type:	destination group resource type
  * @limits:	array of limits to use for each resource group
  */
 struct ipa_resource_dst {
-	enum ipa_resource_type type;	/* IPA_RESOURCE_TYPE_DST_* */
 	struct ipa_resource_limits limits[IPA_RESOURCE_GROUP_DST_MAX];
 };
 
diff --git a/drivers/net/ipa/ipa_resource.c b/drivers/net/ipa/ipa_resource.c
index edd9d1e5cbb62..506bcccaef64f 100644
--- a/drivers/net/ipa/ipa_resource.c
+++ b/drivers/net/ipa/ipa_resource.c
@@ -128,54 +128,54 @@ ipa_resource_config_common(struct ipa *ipa, u32 offset,
 	iowrite32(val, ipa->reg_virt + offset);
 }
 
-static void ipa_resource_config_src(struct ipa *ipa,
+static void ipa_resource_config_src(struct ipa *ipa, u32 resource_type,
 				    const struct ipa_resource_src *resource)
 {
 	u32 group_count = ipa_resource_group_src_count(ipa->version);
 	const struct ipa_resource_limits *ylimits;
 	u32 offset;
 
-	offset = IPA_REG_SRC_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(resource->type);
+	offset = IPA_REG_SRC_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(resource_type);
 	ylimits = group_count == 1 ? NULL : &resource->limits[1];
 	ipa_resource_config_common(ipa, offset, &resource->limits[0], ylimits);
 
 	if (group_count < 3)
 		return;
 
-	offset = IPA_REG_SRC_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(resource->type);
+	offset = IPA_REG_SRC_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(resource_type);
 	ylimits = group_count == 3 ? NULL : &resource->limits[3];
 	ipa_resource_config_common(ipa, offset, &resource->limits[2], ylimits);
 
 	if (group_count < 5)
 		return;
 
-	offset = IPA_REG_SRC_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(resource->type);
+	offset = IPA_REG_SRC_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(resource_type);
 	ylimits = group_count == 5 ? NULL : &resource->limits[5];
 	ipa_resource_config_common(ipa, offset, &resource->limits[4], ylimits);
 }
 
-static void ipa_resource_config_dst(struct ipa *ipa,
+static void ipa_resource_config_dst(struct ipa *ipa, u32 resource_type,
 				    const struct ipa_resource_dst *resource)
 {
 	u32 group_count = ipa_resource_group_dst_count(ipa->version);
 	const struct ipa_resource_limits *ylimits;
 	u32 offset;
 
-	offset = IPA_REG_DST_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(resource->type);
+	offset = IPA_REG_DST_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(resource_type);
 	ylimits = group_count == 1 ? NULL : &resource->limits[1];
 	ipa_resource_config_common(ipa, offset, &resource->limits[0], ylimits);
 
 	if (group_count < 3)
 		return;
 
-	offset = IPA_REG_DST_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(resource->type);
+	offset = IPA_REG_DST_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(resource_type);
 	ylimits = group_count == 3 ? NULL : &resource->limits[3];
 	ipa_resource_config_common(ipa, offset, &resource->limits[2], ylimits);
 
 	if (group_count < 5)
 		return;
 
-	offset = IPA_REG_DST_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(resource->type);
+	offset = IPA_REG_DST_RSRC_GRP_45_RSRC_TYPE_N_OFFSET(resource_type);
 	ylimits = group_count == 5 ? NULL : &resource->limits[5];
 	ipa_resource_config_common(ipa, offset, &resource->limits[4], ylimits);
 }
@@ -189,10 +189,10 @@ int ipa_resource_config(struct ipa *ipa, const struct ipa_resource_data *data)
 		return -EINVAL;
 
 	for (i = 0; i < data->resource_src_count; i++)
-		ipa_resource_config_src(ipa, &data->resource_src[i]);
+		ipa_resource_config_src(ipa, i, &data->resource_src[i]);
 
 	for (i = 0; i < data->resource_dst_count; i++)
-		ipa_resource_config_dst(ipa, &data->resource_dst[i]);
+		ipa_resource_config_dst(ipa, i, &data->resource_dst[i]);
 
 	return 0;
 }
-- 
2.27.0

