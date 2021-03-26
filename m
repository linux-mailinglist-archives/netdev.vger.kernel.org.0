Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D5634AB17
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 16:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhCZPMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 11:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbhCZPLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 11:11:35 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44D1C0613B2
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 08:11:35 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id x16so5726986iob.1
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 08:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1SaFkQw5ra/MhjdSrVDbweSgeBOe0ryrQaUo5/px9lE=;
        b=MJuoFsFgZYfRvVWzz9Iy3qrBK7H8pgZYRP+F7uuzXSuD5TZW+1DJByKPEbyTrdB0S2
         3YJluQYAsLBa4gkJoXBhsliKYG5PT/9neEHWAU9y8UZK9EL/9RJX05azglE10EaOEZz6
         hf5JsGlj2Xi0NCbGgJTYrbIfjGEHklaiAPSD9O15aHSzjEF7qYxQklJoTmXOKc0FzGRh
         fznq1URTWvzfEoQNdAK6CW1DrqgwRkkVLafCZvnKIswcxRNNKt7Oq4Wl51GDMuBT3IMX
         K3/uv1DDK5LJ/+hngk05vSaBwmCb/mgbqaJuS5ecarFiBwYAXif4szUDc/vZ4FlKmX5N
         D99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1SaFkQw5ra/MhjdSrVDbweSgeBOe0ryrQaUo5/px9lE=;
        b=HLz7mwMjqfr27XgeA5aZaW2uTr86UMLz6iPiVJQydsIBVdu5idyqznowGWS7kbwjlq
         rkMy7JLP0EJtooKDF7B5zJITaxIm87SoVk707CgEoSD3YdQT/Tgac/Z4FhhQ6/tNT08o
         HS/Ko0rdwdipaZ5vg6VhsKbT4h3HCKTeMyq7vWxWiZaKZvuuXv/e1e11FLiOrFWOCs/w
         Hj322fWOCebsiiJsaW2b3EPWFG9sDx9GF9jr1Mp6AqgdqwSX4npZc1XPsKcb04b8Wb22
         PAOb91zsGDNlhl5IKJNS1XXBf3DjfFP4Ofu6aFJxzi4l6Gkkbq/5gGRmdjHpPicFczM9
         pcXg==
X-Gm-Message-State: AOAM530xGswNqrc+47EGFmXVcrIdMdpMl360iPxhGSOTQb6smKq4DGF/
        zonV5b0oRcOkUexhNwn4qeNkKg==
X-Google-Smtp-Source: ABdhPJx735jhR/AYhOEoOSmCGC09BB/EydGUnSFJcTCeedNBs1aaddjSCfThQYt4nLw065kPpYyp7g==
X-Received: by 2002:a02:c894:: with SMTP id m20mr12578246jao.80.1616771494926;
        Fri, 26 Mar 2021 08:11:34 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j17sm4537706iok.37.2021.03.26.08.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 08:11:34 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 09/12] net: ipa: combine source and destation resource types
Date:   Fri, 26 Mar 2021 10:11:19 -0500
Message-Id: <20210326151122.3121383-10-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210326151122.3121383-1-elder@linaro.org>
References: <20210326151122.3121383-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ipa_resource_src and ipa_resource_dst structures are identical
in form, so just replace them with a single structure.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-sc7180.c |  4 ++--
 drivers/net/ipa/ipa_data-sdm845.c |  4 ++--
 drivers/net/ipa/ipa_data.h        | 18 +++++-------------
 drivers/net/ipa/ipa_resource.c    |  8 ++++----
 4 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ipa/ipa_data-sc7180.c b/drivers/net/ipa/ipa_data-sc7180.c
index 24ff315175653..631b50fc8d534 100644
--- a/drivers/net/ipa/ipa_data-sc7180.c
+++ b/drivers/net/ipa/ipa_data-sc7180.c
@@ -163,7 +163,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 };
 
 /* Source resource configuration data for the SC7180 SoC */
-static const struct ipa_resource_src ipa_resource_src[] = {
+static const struct ipa_resource ipa_resource_src[] = {
 	[IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS] = {
 		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
 			.min = 3,	.max = 63,
@@ -192,7 +192,7 @@ static const struct ipa_resource_src ipa_resource_src[] = {
 };
 
 /* Destination resource configuration data for the SC7180 SoC */
-static const struct ipa_resource_dst ipa_resource_dst[] = {
+static const struct ipa_resource ipa_resource_dst[] = {
 	[IPA_RESOURCE_TYPE_DST_DATA_SECTORS] = {
 		.limits[IPA_RSRC_GROUP_DST_UL_DL_DPL] = {
 			.min = 3,	.max = 3,
diff --git a/drivers/net/ipa/ipa_data-sdm845.c b/drivers/net/ipa/ipa_data-sdm845.c
index 357e8ba43a364..3c9675ce556ce 100644
--- a/drivers/net/ipa/ipa_data-sdm845.c
+++ b/drivers/net/ipa/ipa_data-sdm845.c
@@ -181,7 +181,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 };
 
 /* Source resource configuration data for the SDM845 SoC */
-static const struct ipa_resource_src ipa_resource_src[] = {
+static const struct ipa_resource ipa_resource_src[] = {
 	[IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS] = {
 		.limits[IPA_RSRC_GROUP_SRC_LWA_DL] = {
 			.min = 1,	.max = 255,
@@ -243,7 +243,7 @@ static const struct ipa_resource_src ipa_resource_src[] = {
 };
 
 /* Destination resource configuration data for the SDM845 SoC */
-static const struct ipa_resource_dst ipa_resource_dst[] = {
+static const struct ipa_resource ipa_resource_dst[] = {
 	[IPA_RESOURCE_TYPE_DST_DATA_SECTORS] = {
 		.limits[IPA_RSRC_GROUP_DST_LWA_DL] = {
 			.min = 4,	.max = 4,
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index d6d14818a3968..9060586eb7cba 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -204,18 +204,10 @@ struct ipa_resource_limits {
 };
 
 /**
- * struct ipa_resource_src - source endpoint group resource usage
- * @limits:	array of source resource limits, indexed by group
+ * struct ipa_resource - resource group source or destination resource usage
+ * @limits:	array of resource limits, indexed by group
  */
-struct ipa_resource_src {
-	struct ipa_resource_limits limits[IPA_RESOURCE_GROUP_MAX];
-};
-
-/**
- * struct ipa_resource_dst - destination endpoint group resource usage
- * @limits:	array of destination resource limits, indexed by group
- */
-struct ipa_resource_dst {
+struct ipa_resource {
 	struct ipa_resource_limits limits[IPA_RESOURCE_GROUP_MAX];
 };
 
@@ -233,9 +225,9 @@ struct ipa_resource_dst {
  */
 struct ipa_resource_data {
 	u32 resource_src_count;
-	const struct ipa_resource_src *resource_src;
+	const struct ipa_resource *resource_src;
 	u32 resource_dst_count;
-	const struct ipa_resource_dst *resource_dst;
+	const struct ipa_resource *resource_dst;
 };
 
 /**
diff --git a/drivers/net/ipa/ipa_resource.c b/drivers/net/ipa/ipa_resource.c
index 38b95b6a5193d..c7edacfa7d19d 100644
--- a/drivers/net/ipa/ipa_resource.c
+++ b/drivers/net/ipa/ipa_resource.c
@@ -87,7 +87,7 @@ static bool ipa_resource_limits_valid(struct ipa *ipa,
 	 * for a resource group not supported by hardware.
 	 */
 	for (i = 0; i < data->resource_src_count; i++) {
-		const struct ipa_resource_src *resource;
+		const struct ipa_resource *resource;
 
 		resource = &data->resource_src[i];
 		for (j = group_count; j < IPA_RESOURCE_GROUP_MAX; j++)
@@ -100,7 +100,7 @@ static bool ipa_resource_limits_valid(struct ipa *ipa,
 		return false;
 
 	for (i = 0; i < data->resource_dst_count; i++) {
-		const struct ipa_resource_dst *resource;
+		const struct ipa_resource *resource;
 
 		resource = &data->resource_dst[i];
 		for (j = group_count; j < IPA_RESOURCE_GROUP_MAX; j++)
@@ -129,7 +129,7 @@ ipa_resource_config_common(struct ipa *ipa, u32 offset,
 }
 
 static void ipa_resource_config_src(struct ipa *ipa, u32 resource_type,
-				    const struct ipa_resource_src *resource)
+				    const struct ipa_resource *resource)
 {
 	u32 group_count = ipa_resource_group_src_count(ipa->version);
 	const struct ipa_resource_limits *ylimits;
@@ -155,7 +155,7 @@ static void ipa_resource_config_src(struct ipa *ipa, u32 resource_type,
 }
 
 static void ipa_resource_config_dst(struct ipa *ipa, u32 resource_type,
-				    const struct ipa_resource_dst *resource)
+				    const struct ipa_resource *resource)
 {
 	u32 group_count = ipa_resource_group_dst_count(ipa->version);
 	const struct ipa_resource_limits *ylimits;
-- 
2.27.0

