Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D734929E257
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgJ2CNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgJ1VgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:36:16 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10CD6C0613D1
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 14:36:15 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id y17so985134ilg.4
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 14:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GEvV133sdw+/JHpE5Z4NaSRzUo1ZNlL2BYj4NJ4KAYg=;
        b=vsrb8aD6MytJrPIR4dKD9Opp9KGvaJaCpqMdjricTyUwFMp43bIN9quPIfhwHPH1l9
         mzdAvWrjHTKoAvwsv5ovc+l8AAni9pXtGWdNt5CLdmwdkVqIxNTClQMKx2NaQmsTddVH
         2N5bEQ+QRtD2Todg+W4GLbRtn+1iHxfZQpqXKl9LkwL2aUuLVAkTW3fEA9nbMwICl79O
         yyXbnIvda5ffbgRHvfe/oZmS0Udfb7IMNB6BA1g+W+Hok2X8TNAhbvzgKfjsDO2BW/UE
         ihC1NhVYBHX5jG1h6i0iaLvvKNhheIuTbGJzfWzSQFmS6Of7E7lPuDHwcWwA+t7DxzxD
         q7aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GEvV133sdw+/JHpE5Z4NaSRzUo1ZNlL2BYj4NJ4KAYg=;
        b=pDA/to3utfXIx7Evp0OG7rgBWJhSiGfIbV+WprYSyWKWVwR7Y65MlgVWSMtt2QP8u/
         4ZzihbPrJYKKWGmgItR7Y4aiHn+eb2tkf2ds6sKbl1Q36O4yJLuNmvqUob82cUImtHYb
         DovEJsPd4sL/JW14bkgUy7tzO4F36Jy7GXRNO8tzw9KKy4eBVWJ8ixYWvfh5jWCuTv/J
         avztpGT+m33xr7RSKhijPoleyGEbNwV6/dqWqm477d8TqgLUli/PijdFwLMW9lbfQIXP
         tSP/dV/MkhviegdgFhWYHZwR9x0etCPlp2HYR6F27nJdtswefBRS0tQcrlQur0vsylzz
         Kf0A==
X-Gm-Message-State: AOAM530VoLRXQ03mt00hzZQpuv2Im4KLhiXaZKVmvi3I0xjkTzskSnPg
        h1FL98iadQ64oOHrTFKGTQw7HaD1MXCn8E1r
X-Google-Smtp-Source: ABdhPJxLIJ182k/ZeRT3Qfm2O5HJF91/ZZ9oupuWiG4o/dR/leD6g8v1SEJfZv8GmBI3B0Kn2LJLWA==
X-Received: by 2002:a92:9911:: with SMTP id p17mr534546ili.165.1603914119235;
        Wed, 28 Oct 2020 12:41:59 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id m66sm359828ill.69.2020.10.28.12.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 12:41:58 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        willemdebruijn.kernel@gmail.com, sujitka@chromium.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net 4/5] net: ipa: distinguish between resource group types
Date:   Wed, 28 Oct 2020 14:41:47 -0500
Message-Id: <20201028194148.6659-5-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201028194148.6659-1-elder@linaro.org>
References: <20201028194148.6659-1-elder@linaro.org>
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

IPA_RESOURCE_GROUP_COUNT represents the maximum number of resource
groups the driver supports for any hardware version.  Change that
symbol to be two separate constants, one for source and the other
for destination resource groups.  Rename them to end with "_MAX"
rather than "_COUNT", to reflect their true purpose.

Fixes: 1ed7d0c0fdbac ("soc: qcom: ipa: configuration data")
Tested-by: Sujit Kautkar <sujitka@chromium.org>
Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: Updated description to better explain the meaning of "_MAX".

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

