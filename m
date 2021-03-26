Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D4C34AB1E
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 16:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbhCZPM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 11:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbhCZPLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 11:11:39 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5566C0613B1
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 08:11:38 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id u2so5323711ilk.1
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 08:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gUmB/zFwJkKaeTOJTTMdrrWCynBS5WfLyS187adEfr4=;
        b=pB8heAQG7+9AYNZHFCpRstpwd+JeNtO1kWEiyYFgeMBLrHoSgMLIWACKH4cKO5kq4N
         g6nwhd+KYqA3rTT4K4YtGn+sCgOavBu0+GnNHmH7hsalwgAtNF5xskV9N4Dx4yzJ2VAI
         hisNmi6B42FWUGrD3soHhEM8Fjlg8YgmHyc2ZjcGAY41+cSux6yW6FvTCRkvq09MA/Mx
         qLpZhekgyurUjlmXJKBc3DNy6SZln1MzPMN8/zi6bx3bXCzK3QtACoJnX69aJLBohFUr
         V5Us5baRzHj7ZOX14OFBehOP4yOVvaUBaFF7aIFQMlfSDovzDrO7OR4EUCqAH1hIgBVV
         iOmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gUmB/zFwJkKaeTOJTTMdrrWCynBS5WfLyS187adEfr4=;
        b=mgXlYagvlTeA2GWNeLejOuwi0POVoUBXXmCmU/11CTk0FprGD/b56tWsOgzvk4YQoH
         Uh3/vXTbe+Xcd+8MmOV/eeR+EE9yAUIYqjUCnqDM0aLDUIRVxEIw+JfuxUwDFsks7cFj
         01Afq5XkHRAjTSjc5U3EsYbDCbfLNZxyb+ecoaR03i9YvtzJn7JTd5obpDtj00fie8wk
         6K6PIcj7pfUXKPxMSAER7+mba5DGrhe4H5Bqf+za8gu5qb4c+ZuRftDwo4NqACViTYx6
         49oZwiinizKnGjiC+Jh2v4rwiUhw2ixOaPtNMFMtwLPJGpMzgghv+T0u9JDbzpQcUmZ6
         dpKw==
X-Gm-Message-State: AOAM532M7HIDBJB9ijaLe868jg6wamAovSVLRKX3p44f+Y+7x1JqCnIb
        hff+bC0sVUIdj1MZmdIwRIOjcRJSK/c/rNyf
X-Google-Smtp-Source: ABdhPJy3BvFT3DNH0CKZV8hlPiJMidCwnyStGw35JfsIQRI8WWHZjmAkHiPzwPpKcu8ObH4Mj/F3Kw==
X-Received: by 2002:a05:6e02:532:: with SMTP id h18mr4902523ils.267.1616771496768;
        Fri, 26 Mar 2021 08:11:36 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j17sm4537706iok.37.2021.03.26.08.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 08:11:36 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 11/12] net: ipa: record number of groups in data
Date:   Fri, 26 Mar 2021 10:11:21 -0500
Message-Id: <20210326151122.3121383-12-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210326151122.3121383-1-elder@linaro.org>
References: <20210326151122.3121383-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The arrays of source and destination resource limits defined in
configuration data are of a fixed size--which is the maximum number
of resource groups supported for any platform.  Most platforms will
use fewer than that many groups.

Add new members to the ipa_rsrc_group_id enumerated type to define
the number of source and destination resource groups are defined for
the platform.  (This type is defined for each platform in its data
file.)

Add a new field to the resource configuration data that indicates
how many of the source and destination resource groups are actually
used for the platform, and initialize it with the count value.  This
allows us to determine the number of groups defined for the platform
without exposing the ipa_rsrc_group_id enumerated type.

As a result, we no longer need ipa_resource_group_src_count()
and ipa_resource_group_dst_count(), because each platform now
defines its supported number of resource groups.  So get rid of
those two functions.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-sc7180.c |  4 +++
 drivers/net/ipa/ipa_data-sdm845.c |  4 +++
 drivers/net/ipa/ipa_data.h        |  4 +++
 drivers/net/ipa/ipa_resource.c    | 50 +++----------------------------
 4 files changed, 16 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ipa/ipa_data-sc7180.c b/drivers/net/ipa/ipa_data-sc7180.c
index 631b50fc8d534..c9b6a6aaadacc 100644
--- a/drivers/net/ipa/ipa_data-sc7180.c
+++ b/drivers/net/ipa/ipa_data-sc7180.c
@@ -27,9 +27,11 @@ enum ipa_resource_type {
 enum ipa_rsrc_group_id {
 	/* Source resource group identifiers */
 	IPA_RSRC_GROUP_SRC_UL_DL	= 0,
+	IPA_RSRC_GROUP_SRC_COUNT,	/* Last in set; not a source group */
 
 	/* Destination resource group identifiers */
 	IPA_RSRC_GROUP_DST_UL_DL_DPL	= 0,
+	IPA_RSRC_GROUP_DST_COUNT,	/* Last; not a destination group */
 };
 
 /* QSB configuration for the SC7180 SoC. */
@@ -207,6 +209,8 @@ static const struct ipa_resource ipa_resource_dst[] = {
 
 /* Resource configuration for the SC7180 SoC. */
 static const struct ipa_resource_data ipa_resource_data = {
+	.rsrc_group_src_count	= IPA_RSRC_GROUP_SRC_COUNT,
+	.rsrc_group_dst_count	= IPA_RSRC_GROUP_DST_COUNT,
 	.resource_src_count	= ARRAY_SIZE(ipa_resource_src),
 	.resource_src		= ipa_resource_src,
 	.resource_dst_count	= ARRAY_SIZE(ipa_resource_dst),
diff --git a/drivers/net/ipa/ipa_data-sdm845.c b/drivers/net/ipa/ipa_data-sdm845.c
index 3c9675ce556ce..e14e3fb1d9700 100644
--- a/drivers/net/ipa/ipa_data-sdm845.c
+++ b/drivers/net/ipa/ipa_data-sdm845.c
@@ -32,11 +32,13 @@ enum ipa_rsrc_group_id {
 	IPA_RSRC_GROUP_SRC_UL_DL,
 	IPA_RSRC_GROUP_SRC_MHI_DMA,
 	IPA_RSRC_GROUP_SRC_UC_RX_Q,
+	IPA_RSRC_GROUP_SRC_COUNT,	/* Last in set; not a source group */
 
 	/* Destination resource group identifiers */
 	IPA_RSRC_GROUP_DST_LWA_DL	= 0,
 	IPA_RSRC_GROUP_DST_UL_DL_DPL,
 	IPA_RSRC_GROUP_DST_UNUSED_2,
+	IPA_RSRC_GROUP_DST_COUNT,	/* Last; not a destination group */
 };
 
 /* QSB configuration for the SDM845 SoC. */
@@ -270,6 +272,8 @@ static const struct ipa_resource ipa_resource_dst[] = {
 
 /* Resource configuration for the SDM845 SoC. */
 static const struct ipa_resource_data ipa_resource_data = {
+	.rsrc_group_src_count	= IPA_RSRC_GROUP_SRC_COUNT,
+	.rsrc_group_dst_count	= IPA_RSRC_GROUP_DST_COUNT,
 	.resource_src_count	= ARRAY_SIZE(ipa_resource_src),
 	.resource_src		= ipa_resource_src,
 	.resource_dst_count	= ARRAY_SIZE(ipa_resource_dst),
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index 9060586eb7cba..c5d763a3782fd 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -213,6 +213,8 @@ struct ipa_resource {
 
 /**
  * struct ipa_resource_data - IPA resource configuration data
+ * @rsrc_group_src_count: number of source resource groups supported
+ * @rsrc_group_dst_count: number of destination resource groups supported
  * @resource_src_count:	number of entries in the resource_src array
  * @resource_src:	source endpoint group resources
  * @resource_dst_count:	number of entries in the resource_dst array
@@ -224,6 +226,8 @@ struct ipa_resource {
  * programming it at initialization time, so we specify it here.
  */
 struct ipa_resource_data {
+	u32 rsrc_group_src_count;
+	u32 rsrc_group_dst_count;
 	u32 resource_src_count;
 	const struct ipa_resource *resource_src;
 	u32 resource_dst_count;
diff --git a/drivers/net/ipa/ipa_resource.c b/drivers/net/ipa/ipa_resource.c
index 3db4dd3bda9cc..578ff070d4055 100644
--- a/drivers/net/ipa/ipa_resource.c
+++ b/drivers/net/ipa/ipa_resource.c
@@ -26,48 +26,6 @@
  * total resources of each type is assigned for use by each group.
  */
 
-/* # IPA source resource groups available based on version */
-static u32 ipa_resource_group_src_count(enum ipa_version version)
-{
-	switch (version) {
-	case IPA_VERSION_3_5_1:
-	case IPA_VERSION_4_0:
-	case IPA_VERSION_4_1:
-		return 4;
-
-	case IPA_VERSION_4_2:
-		return 1;
-
-	case IPA_VERSION_4_5:
-		return 5;
-
-	default:
-		return 0;
-	}
-}
-
-/* # IPA destination resource groups available based on version */
-static u32 ipa_resource_group_dst_count(enum ipa_version version)
-{
-	switch (version) {
-	case IPA_VERSION_3_5_1:
-		return 3;
-
-	case IPA_VERSION_4_0:
-	case IPA_VERSION_4_1:
-		return 4;
-
-	case IPA_VERSION_4_2:
-		return 1;
-
-	case IPA_VERSION_4_5:
-		return 5;
-
-	default:
-		return 0;
-	}
-}
-
 static bool ipa_resource_limits_valid(struct ipa *ipa,
 				      const struct ipa_resource_data *data)
 {
@@ -79,7 +37,7 @@ static bool ipa_resource_limits_valid(struct ipa *ipa,
 	/* We program at most 6 source or destination resource group limits */
 	BUILD_BUG_ON(IPA_RESOURCE_GROUP_MAX > 6);
 
-	group_count = ipa_resource_group_src_count(ipa->version);
+	group_count = data->rsrc_group_src_count;
 	if (!group_count || group_count > IPA_RESOURCE_GROUP_MAX)
 		return false;
 
@@ -95,7 +53,7 @@ static bool ipa_resource_limits_valid(struct ipa *ipa,
 				return false;
 	}
 
-	group_count = ipa_resource_group_dst_count(ipa->version);
+	group_count = data->rsrc_group_src_count;
 	if (!group_count || group_count > IPA_RESOURCE_GROUP_MAX)
 		return false;
 
@@ -131,7 +89,7 @@ ipa_resource_config_common(struct ipa *ipa, u32 offset,
 static void ipa_resource_config_src(struct ipa *ipa, u32 resource_type,
 				    const struct ipa_resource_data *data)
 {
-	u32 group_count = ipa_resource_group_src_count(ipa->version);
+	u32 group_count = data->rsrc_group_src_count;
 	const struct ipa_resource_limits *ylimits;
 	const struct ipa_resource *resource;
 	u32 offset;
@@ -160,7 +118,7 @@ static void ipa_resource_config_src(struct ipa *ipa, u32 resource_type,
 static void ipa_resource_config_dst(struct ipa *ipa, u32 resource_type,
 				    const struct ipa_resource_data *data)
 {
-	u32 group_count = ipa_resource_group_dst_count(ipa->version);
+	u32 group_count = data->rsrc_group_dst_count;
 	const struct ipa_resource_limits *ylimits;
 	const struct ipa_resource *resource;
 	u32 offset;
-- 
2.27.0

