Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4261D29BAD0
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 17:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1807685AbgJ0QNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 12:13:01 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:39336 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1807539AbgJ0QLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 12:11:34 -0400
Received: by mail-io1-f65.google.com with SMTP id p7so2124068ioo.6
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 09:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g6/eP7D32wbHjS9Fit8dMh9D/knRBX6K/4fHv4DsjHc=;
        b=NXfEOyhDYjcFg2+/bF+542ObdLRkPff1gBSkFjKhpWX5yUOVORwjWYaSKu2Wp2otr9
         xiQOs+I3ELTenvH135as/KXJMQRJl7ZCFbjrHW3yIgDIiEH+yrj2WwayNaAMOULzgXlR
         O5bzLtARdM1FOWOX35rq0Yb4SfV6OX+Zz8v2cuy4YLh2z027Soatjkl9jVDDrOFc5gEI
         SXckIg5rMi2Y+RQNqoLjbd6r9wx42puvVrGtK1xIaIGJZ1Ox8mah0s0UWS4s4Y0Gwj4d
         4OFtEQIeU1WqP3CbQeC1TUG+xJexq6VNUijrtteh/HQyvI9bJ5sB2t3aRTvltQRui/mb
         ro/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g6/eP7D32wbHjS9Fit8dMh9D/knRBX6K/4fHv4DsjHc=;
        b=XipuTFzNlm4aEUyJrooV+ANZ6xyV2A+A+PyWmE6VljxK2YPjXZ0t0o/U2LcJkcxh45
         8Gt9apnV0szLs2mwtcknTWAxFRX0EIaE31l7jV2VNWoAEDuZCP7fRoRMnNgsmPccgU9K
         WoWSZZjaL2AAYQ7gHIgz8iH9sLpjtWVlnw8hCb0A27p6U9GL9hcBV6KusqrVV6m//fEk
         qwUxyN0WB9GOjW5cE9I9ua/C4ZiVd1tSuR37C+Zqu5cnuyy7YQp4S8RYOa3BVgvUu0TD
         sneZQqqLE9mlzeoGnmB1HsRoy5HvWOQZu8cl9Phq/DTHqznrqflXQ8lqEmr+YPk2SpDB
         2JHw==
X-Gm-Message-State: AOAM531fd1Vgai2oFdTU5Uw9CB+XXp2MdA5KcTy8zslmefxB846vY3ff
        C3ubKFoIQiATwLC6KOG0rezJrA==
X-Google-Smtp-Source: ABdhPJzsQDh367NRf7cEEwSjcP9VnGvB7M6hHoeGcl7sbcfCgIGATNd57MYkf3kKPoLT40KO8Absww==
X-Received: by 2002:a02:77c4:: with SMTP id g187mr752136jac.65.1603815092830;
        Tue, 27 Oct 2020 09:11:32 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w15sm1082264iom.6.2020.10.27.09.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 09:11:32 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 4/5] net: ipa: distinguish between resource group types
Date:   Tue, 27 Oct 2020 11:11:19 -0500
Message-Id: <20201027161120.5575-5-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201027161120.5575-1-elder@linaro.org>
References: <20201027161120.5575-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The number of resource groups supported by the hardware can be
different for source and destination resources.  Determine the
number supported for each using separate functions.  Make the
functions inline end move their definitions into "ipa_reg.h",
because they determine whether certain register definitions are
valid.  Pass just the IPA hardware version as argument.

Change IPA_RESOURCE_GROUP_COUNT to be two separate constants, one
for source and the other for destination resource groups.  Rename
those to end with "_MAX" rather than "_COUNT", to reflect their
true purpose.

Fixes: 1ed7d0c0fdbac ("soc: qcom: ipa: configuration data")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data.h | 10 +++++-----
 drivers/net/ipa/ipa_main.c | 34 ++++++++++------------------------
 drivers/net/ipa/ipa_reg.h  | 37 +++++++++++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index d084a83069db2..0225d81d85028 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -45,10 +45,10 @@
  * the IPA endpoint.
  */
 
-/* The maximum value returned by ipa_resource_group_count() */
-#define IPA_RESOURCE_GROUP_COUNT	4
+/* The maximum value returned by ipa_resource_group_{src,dst}_count() */
+#define IPA_RESOURCE_GROUP_SRC_MAX	4
+#define IPA_RESOURCE_GROUP_DST_MAX	4
 
-/** enum ipa_resource_type_src - source resource types */
 /**
  * struct gsi_channel_data - GSI channel configuration data
  * @tre_count:		number of TREs in the channel ring
@@ -208,7 +208,7 @@ struct ipa_resource_limits {
  */
 struct ipa_resource_src {
 	enum ipa_resource_type_src type;
-	struct ipa_resource_limits limits[IPA_RESOURCE_GROUP_COUNT];
+	struct ipa_resource_limits limits[IPA_RESOURCE_GROUP_SRC_MAX];
 };
 
 /**
@@ -218,7 +218,7 @@ struct ipa_resource_src {
  */
 struct ipa_resource_dst {
 	enum ipa_resource_type_dst type;
-	struct ipa_resource_limits limits[IPA_RESOURCE_GROUP_COUNT];
+	struct ipa_resource_limits limits[IPA_RESOURCE_GROUP_DST_MAX];
 };
 
 /**
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index cd4d993b0bbb2..74b1e15ebd6b2 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -363,52 +363,38 @@ static void ipa_hardware_deconfig(struct ipa *ipa)
 
 #ifdef IPA_VALIDATION
 
-/* # IPA resources used based on version (see IPA_RESOURCE_GROUP_COUNT) */
-static int ipa_resource_group_count(struct ipa *ipa)
-{
-	switch (ipa->version) {
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
-	default:
-		return 0;
-	}
-}
-
 static bool ipa_resource_limits_valid(struct ipa *ipa,
 				      const struct ipa_resource_data *data)
 {
-	u32 group_count = ipa_resource_group_count(ipa);
+	u32 group_count;
 	u32 i;
 	u32 j;
 
+	group_count = ipa_resource_group_src_count(ipa->version);
 	if (!group_count)
 		return false;
 
-	/* Return an error if a non-zero resource group limit is specified
-	 * for a resource not supported by hardware.
+	/* Return an error if a non-zero resource limit is specified
+	 * for a resource group not supported by hardware.
 	 */
 	for (i = 0; i < data->resource_src_count; i++) {
 		const struct ipa_resource_src *resource;
 
 		resource = &data->resource_src[i];
-		for (j = group_count; j < IPA_RESOURCE_GROUP_COUNT; j++)
+		for (j = group_count; j < IPA_RESOURCE_GROUP_SRC_MAX; j++)
 			if (resource->limits[j].min || resource->limits[j].max)
 				return false;
 	}
 
+	group_count = ipa_resource_group_dst_count(ipa->version);
+	if (!group_count)
+		return false;
+
 	for (i = 0; i < data->resource_dst_count; i++) {
 		const struct ipa_resource_dst *resource;
 
 		resource = &data->resource_dst[i];
-		for (j = group_count; j < IPA_RESOURCE_GROUP_COUNT; j++)
+		for (j = group_count; j < IPA_RESOURCE_GROUP_DST_MAX; j++)
 			if (resource->limits[j].min || resource->limits[j].max)
 				return false;
 	}
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index 7dcfa07180f9f..8eaf5f2096270 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -244,6 +244,43 @@ static inline u32 ipa_reg_idle_indication_cfg_offset(enum ipa_version version)
 #define ENTER_IDLE_DEBOUNCE_THRESH_FMASK	GENMASK(15, 0)
 #define CONST_NON_IDLE_ENABLE_FMASK		GENMASK(16, 16)
 
+/* # IPA source resource groups available based on version */
+static inline u32 ipa_resource_group_src_count(enum ipa_version version)
+{
+	switch (version) {
+	case IPA_VERSION_3_5_1:
+	case IPA_VERSION_4_0:
+	case IPA_VERSION_4_1:
+		return 4;
+
+	case IPA_VERSION_4_2:
+		return 1;
+
+	default:
+		return 0;
+	}
+}
+
+/* # IPA destination resource groups available based on version */
+static inline u32 ipa_resource_group_dst_count(enum ipa_version version)
+{
+	switch (version) {
+	case IPA_VERSION_3_5_1:
+		return 3;
+
+	case IPA_VERSION_4_0:
+	case IPA_VERSION_4_1:
+		return 4;
+
+	case IPA_VERSION_4_2:
+		return 1;
+
+	default:
+		return 0;
+	}
+}
+
+/* Not all of the following are valid (depends on the count, above) */
 #define IPA_REG_SRC_RSRC_GRP_01_RSRC_TYPE_N_OFFSET(rt) \
 					(0x00000400 + 0x0020 * (rt))
 #define IPA_REG_SRC_RSRC_GRP_23_RSRC_TYPE_N_OFFSET(rt) \
-- 
2.20.1

