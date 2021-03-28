Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6BB534BDAA
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 19:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbhC1Rbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 13:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbhC1RbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 13:31:20 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFC5C061762
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 10:31:20 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id j26so10435418iog.13
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 10:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RJlB7tgkYTkIGLXxRrL2DthLYTanDKiXH10wP/0FvSQ=;
        b=jBf2ve822qHmgJnO41QSGrnUaUkhYfYLT/qtY2pz9TTpipRZq8+eSPAwhsItQSVwF6
         5yK7S14tnT7gDi7PmSUorUuojJEjyq4aBip570/0GcSxyPG5/EnGhq4GFPX2no3Sewjv
         IbomohZ0vB8HBK3GPoGNRe3ULQA10enmLJCDvQWiAvk4hy/B1olNvJwGWhXEsnC9bgAa
         bp6OuEGlq0ngmD8oTmGem9Bkfh5DyJ5RQ65nH79inTJWJrhSxUAYt2JsjuusOFI0saQ8
         iVLHercNUmhlnBlvmuFF2dZvV2QewzbKXmKuSEh7m9Ts3+BsDFVuaHrQG5jeKSEn80cp
         6vVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RJlB7tgkYTkIGLXxRrL2DthLYTanDKiXH10wP/0FvSQ=;
        b=ncEWIHVku/Dnx1OjOn5G5X/aHTpH3eO/RcQlGtajIlXe9+zQA5MGAR9Gk8sUCZoz58
         vvlNmuQKgZJ1zJl4HPfUbzKJ/F3J3Ty0Z+XaTaZ1ME7nOssgTEXqe1QfYGutQTQx8fGA
         xJvUn8lmDNSieiCvMOJxNaV8GJUUMyMYwkmEFvW3AlT9cGkc+sEvfEBdNxuUa4wC5DWf
         Ft77OAjq4R9RtpaplV47XxckfWM9+09aOZ2hR3kX8s6Qu6AG5qixGWncPWKX5ZxOu7da
         MHuL3e8cTroV4CzOMdzx7wLyQ1RX069b7GZF9UCXZAibRh5VbfokmMXWCbmqrLcg084v
         5DeA==
X-Gm-Message-State: AOAM533qC4OhRKgxOKXG6HUwZs9C/+CcbnX6lVrg9ZOp5teb03mtB0nG
        /ntkR2fHhGN+eBPmp2lQSc3QrA==
X-Google-Smtp-Source: ABdhPJy5eQnb97Admw6umrlnryb+qTYqgbEdc/bLX6uIIkyrayvwa5xKVxT+n0s1aZ91E1SIs2xgbQ==
X-Received: by 2002:a02:6654:: with SMTP id l20mr20617712jaf.55.1616952679947;
        Sun, 28 Mar 2021 10:31:19 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id d22sm8014422iof.48.2021.03.28.10.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 10:31:19 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/7] net: ipa: use version based configuration for SC7180
Date:   Sun, 28 Mar 2021 12:31:09 -0500
Message-Id: <20210328173111.3399063-6-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210328173111.3399063-1-elder@linaro.org>
References: <20210328173111.3399063-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the SC7180 configuration data file so that its name is
derived from its IPA version.

Update a few other references to the code that talk about the SC7180
rather than just IPA v4.2.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/Makefile                      |  2 +-
 .../{ipa_data-sc7180.c => ipa_data-v4.2.c}    | 24 ++++++++++---------
 drivers/net/ipa/ipa_data.h                    |  2 +-
 drivers/net/ipa/ipa_main.c                    |  2 +-
 4 files changed, 16 insertions(+), 14 deletions(-)
 rename drivers/net/ipa/{ipa_data-sc7180.c => ipa_data-v4.2.c} (90%)

diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
index a4a42fc7b840e..6abd1db9fe330 100644
--- a/drivers/net/ipa/Makefile
+++ b/drivers/net/ipa/Makefile
@@ -9,4 +9,4 @@ ipa-y			:=	ipa_main.o ipa_clock.o ipa_reg.o ipa_mem.o \
 				ipa_endpoint.o ipa_cmd.o ipa_modem.o \
 				ipa_resource.o ipa_qmi.o ipa_qmi_msg.o
 
-ipa-y			+=	ipa_data-v3.5.1.o ipa_data-sc7180.o
+ipa-y			+=	ipa_data-v3.5.1.o ipa_data-v4.2.o
diff --git a/drivers/net/ipa/ipa_data-sc7180.c b/drivers/net/ipa/ipa_data-v4.2.c
similarity index 90%
rename from drivers/net/ipa/ipa_data-sc7180.c
rename to drivers/net/ipa/ipa_data-v4.2.c
index 810c673be56ee..8744f19c64011 100644
--- a/drivers/net/ipa/ipa_data-sc7180.c
+++ b/drivers/net/ipa/ipa_data-v4.2.c
@@ -9,7 +9,7 @@
 #include "ipa_endpoint.h"
 #include "ipa_mem.h"
 
-/** enum ipa_resource_type - IPA resource types */
+/** enum ipa_resource_type - IPA resource types for an SoC having IPA v4.2 */
 enum ipa_resource_type {
 	/* Source resource types; first must have value 0 */
 	IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS		= 0,
@@ -23,7 +23,7 @@ enum ipa_resource_type {
 	IPA_RESOURCE_TYPE_DST_DPS_DMARS,
 };
 
-/* Resource groups used for the SC7180 SoC */
+/* Resource groups used for an SoC having IPA v4.2 */
 enum ipa_rsrc_group_id {
 	/* Source resource group identifiers */
 	IPA_RSRC_GROUP_SRC_UL_DL	= 0,
@@ -34,7 +34,7 @@ enum ipa_rsrc_group_id {
 	IPA_RSRC_GROUP_DST_COUNT,	/* Last; not a destination group */
 };
 
-/* QSB configuration for the SC7180 SoC. */
+/* QSB configuration data for an SoC having IPA v4.2 */
 static const struct ipa_qsb_data ipa_qsb_data[] = {
 	[IPA_QSB_MASTER_DDR] = {
 		.max_writes	= 8,
@@ -43,7 +43,7 @@ static const struct ipa_qsb_data ipa_qsb_data[] = {
 	},
 };
 
-/* Endpoint configuration for the SC7180 SoC. */
+/* Endpoint configuration data for an SoC having IPA v4.2 */
 static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 	[IPA_ENDPOINT_AP_COMMAND_TX] = {
 		.ee_id		= GSI_EE_AP,
@@ -164,7 +164,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 	},
 };
 
-/* Source resource configuration data for the SC7180 SoC */
+/* Source resource configuration data for an SoC having IPA v4.2 */
 static const struct ipa_resource ipa_resource_src[] = {
 	[IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS] = {
 		.limits[IPA_RSRC_GROUP_SRC_UL_DL] = {
@@ -193,7 +193,7 @@ static const struct ipa_resource ipa_resource_src[] = {
 	},
 };
 
-/* Destination resource configuration data for the SC7180 SoC */
+/* Destination resource configuration data for an SoC having IPA v4.2 */
 static const struct ipa_resource ipa_resource_dst[] = {
 	[IPA_RESOURCE_TYPE_DST_DATA_SECTORS] = {
 		.limits[IPA_RSRC_GROUP_DST_UL_DL_DPL] = {
@@ -207,7 +207,7 @@ static const struct ipa_resource ipa_resource_dst[] = {
 	},
 };
 
-/* Resource configuration for the SC7180 SoC. */
+/* Resource configuration data for an SoC having IPA v4.2 */
 static const struct ipa_resource_data ipa_resource_data = {
 	.rsrc_group_src_count	= IPA_RSRC_GROUP_SRC_COUNT,
 	.rsrc_group_dst_count	= IPA_RSRC_GROUP_DST_COUNT,
@@ -217,7 +217,7 @@ static const struct ipa_resource_data ipa_resource_data = {
 	.resource_dst		= ipa_resource_dst,
 };
 
-/* IPA-resident memory region configuration for the SC7180 SoC. */
+/* IPA-resident memory region data for an SoC having IPA v4.2 */
 static const struct ipa_mem ipa_mem_local_data[] = {
 	[IPA_MEM_UC_SHARED] = {
 		.offset		= 0x0000,
@@ -311,6 +311,7 @@ static const struct ipa_mem ipa_mem_local_data[] = {
 	},
 };
 
+/* Memory configuration data for an SoC having IPA v4.2 */
 static const struct ipa_mem_data ipa_mem_data = {
 	.local_count	= ARRAY_SIZE(ipa_mem_local_data),
 	.local		= ipa_mem_local_data,
@@ -320,7 +321,7 @@ static const struct ipa_mem_data ipa_mem_data = {
 	.smem_size	= 0x00002000,
 };
 
-/* Interconnect bandwidths are in 1000 byte/second units */
+/* Interconnect rates are in 1000 byte/second units */
 static const struct ipa_interconnect_data ipa_interconnect_data[] = {
 	{
 		.name			= "memory",
@@ -340,14 +341,15 @@ static const struct ipa_interconnect_data ipa_interconnect_data[] = {
 	},
 };
 
+/* Clock and interconnect configuration data for an SoC having IPA v4.2 */
 static const struct ipa_clock_data ipa_clock_data = {
 	.core_clock_rate	= 100 * 1000 * 1000,	/* Hz */
 	.interconnect_count	= ARRAY_SIZE(ipa_interconnect_data),
 	.interconnect_data	= ipa_interconnect_data,
 };
 
-/* Configuration data for the SC7180 SoC. */
-const struct ipa_data ipa_data_sc7180 = {
+/* Configuration data for an SoC having IPA v4.2 */
+const struct ipa_data ipa_data_v4_2 = {
 	.version	= IPA_VERSION_4_2,
 	/* backward_compat value is 0 */
 	.qsb_count	= ARRAY_SIZE(ipa_qsb_data),
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index 17cdc376e95f3..e97342e80d537 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -301,6 +301,6 @@ struct ipa_data {
 };
 
 extern const struct ipa_data ipa_data_v3_5_1;
-extern const struct ipa_data ipa_data_sc7180;
+extern const struct ipa_data ipa_data_v4_2;
 
 #endif /* _IPA_DATA_H_ */
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 37e85a5ab75cf..a970d10e650ef 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -582,7 +582,7 @@ static const struct of_device_id ipa_match[] = {
 	},
 	{
 		.compatible	= "qcom,sc7180-ipa",
-		.data		= &ipa_data_sc7180,
+		.data		= &ipa_data_v4_2,
 	},
 	{ },
 };
-- 
2.27.0

