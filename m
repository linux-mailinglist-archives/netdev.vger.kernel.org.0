Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C592034BDA7
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 19:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhC1Rb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 13:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbhC1RbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 13:31:19 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB46C061756
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 10:31:19 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id j16so803378ilq.13
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 10:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NOQpwsJ3pCq24y+KN9P/Mdmm3B4GeGc1qXPHwPLD8JQ=;
        b=RWkMcaeDlV57qIcQ0TbjQiYF5zK/vr9TeVdnqaORejk97yoinFtH1YGo3yQaxFmDDQ
         vLJqoapwy3NUW0/FaTHwaD7QRqaFykALnxKXA3/bS/XD7LYdV3PYX0WKHDzQ3UJANjr+
         +maz0t3o9sjnTfQ9yTixuFDbc2WqokQl3RWfl9cM1CBQAPAAyG0Ked2RuR7sdb1BdN0r
         thztXMiMxirWszqS1KNgx7kj2w7QL2cgHR19gHZHcQhcAkLc3354EAvaF17myiBHgocL
         TE3XX91s+5JkTSO10WmV/dX4cwhR+OhXe36QDmS2tYWYuMD1dJRBbSY4bZxcsyzY+EJi
         DwJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NOQpwsJ3pCq24y+KN9P/Mdmm3B4GeGc1qXPHwPLD8JQ=;
        b=TTIW3kg/769eBR7io0satVg7LKSUt4mb9uj38u6SmGV+qdI90q/TzzcdFZUqTmUcFZ
         lnlPgfN6uWcveCNwgSJ9w8k1sjte4Eun0Sa/IauK51aFGI0l0Jmh2JlN64SlyFptv3DQ
         WEZw4vYzp5TPg2f+K3QiJ6kr2w3u89mErlov+4nyjavQVDeKiud3G5NHxaQZnYOcve7U
         ccGhFLbQQYvGDFqBFboM4RZCWeRVF4u99EdvIlIu7jOUsNPT7qejhtCLpdrEbHQubwu5
         q7u5OzBG1SfNBtpERTqhVcVmGwfFYcN9hNhdViJppbl28m6Pk9mwfAEfw5Vyc+YhMhM5
         7eQw==
X-Gm-Message-State: AOAM530xfOOc8l/FhBTmsaPbGuJLqRgpaCC7dPiEUechJITzXRwtyu/I
        HUILFnvmneaHgPexvjlEOvzN3Q==
X-Google-Smtp-Source: ABdhPJzqc/7rng0+m+0n8ziQZePJN9qvEYfxeK+kxeXvHbxW5nBKe61JuyubEM3Xw+F7mxG3vM6bRQ==
X-Received: by 2002:a92:ddd0:: with SMTP id d16mr18097996ilr.52.1616952679093;
        Sun, 28 Mar 2021 10:31:19 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id d22sm8014422iof.48.2021.03.28.10.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 10:31:18 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/7] net: ipa: switch to version based configuration
Date:   Sun, 28 Mar 2021 12:31:08 -0500
Message-Id: <20210328173111.3399063-5-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210328173111.3399063-1-elder@linaro.org>
References: <20210328173111.3399063-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the SDM845 configuration data file so that its name is
derived from its IPA version.  I am not aware of any special IPA
behavior or handling that would be based on a specific SoC (as
opposed to a specific version of the IPA it contains).

Update a few other references to the code that talk about the SDM845
rather than just IPA v3.5.1.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/Kconfig                       |  3 +--
 drivers/net/ipa/Makefile                      |  2 +-
 .../{ipa_data-sdm845.c => ipa_data-v3.5.1.c}  | 22 ++++++++++---------
 drivers/net/ipa/ipa_data.h                    |  2 +-
 drivers/net/ipa/ipa_main.c                    |  2 +-
 5 files changed, 16 insertions(+), 15 deletions(-)
 rename drivers/net/ipa/{ipa_data-sdm845.c => ipa_data-v3.5.1.c} (92%)

diff --git a/drivers/net/ipa/Kconfig b/drivers/net/ipa/Kconfig
index 90a90262e0d07..8f99cfa14680a 100644
--- a/drivers/net/ipa/Kconfig
+++ b/drivers/net/ipa/Kconfig
@@ -12,8 +12,7 @@ config QCOM_IPA
 	  that is capable of generic hardware handling of IP packets,
 	  including routing, filtering, and NAT.  Currently the IPA
 	  driver supports only basic transport of network traffic
-	  between the AP and modem, on the Qualcomm SDM845 and SC7180
-	  SoCs.
+	  between the AP and modem.
 
 	  Note that if selected, the selection type must match that
 	  of QCOM_Q6V5_COMMON (Y or M).
diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
index 14a7d8429baa2..a4a42fc7b840e 100644
--- a/drivers/net/ipa/Makefile
+++ b/drivers/net/ipa/Makefile
@@ -9,4 +9,4 @@ ipa-y			:=	ipa_main.o ipa_clock.o ipa_reg.o ipa_mem.o \
 				ipa_endpoint.o ipa_cmd.o ipa_modem.o \
 				ipa_resource.o ipa_qmi.o ipa_qmi_msg.o
 
-ipa-y			+=	ipa_data-sdm845.o ipa_data-sc7180.o
+ipa-y			+=	ipa_data-v3.5.1.o ipa_data-sc7180.o
diff --git a/drivers/net/ipa/ipa_data-sdm845.c b/drivers/net/ipa/ipa_data-v3.5.1.c
similarity index 92%
rename from drivers/net/ipa/ipa_data-sdm845.c
rename to drivers/net/ipa/ipa_data-v3.5.1.c
index ed0bfe0634d98..57703e95a3f9c 100644
--- a/drivers/net/ipa/ipa_data-sdm845.c
+++ b/drivers/net/ipa/ipa_data-v3.5.1.c
@@ -11,7 +11,7 @@
 #include "ipa_endpoint.h"
 #include "ipa_mem.h"
 
-/** enum ipa_resource_type - IPA resource types */
+/** enum ipa_resource_type - IPA resource types for an SoC having IPA v3.5.1 */
 enum ipa_resource_type {
 	/* Source resource types; first must have value 0 */
 	IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS		= 0,
@@ -25,7 +25,7 @@ enum ipa_resource_type {
 	IPA_RESOURCE_TYPE_DST_DPS_DMARS,
 };
 
-/* Resource groups used for the SDM845 SoC */
+/* Resource groups used for an SoC having IPA v3.5.1 */
 enum ipa_rsrc_group_id {
 	/* Source resource group identifiers */
 	IPA_RSRC_GROUP_SRC_LWA_DL	= 0,
@@ -41,7 +41,7 @@ enum ipa_rsrc_group_id {
 	IPA_RSRC_GROUP_DST_COUNT,	/* Last; not a destination group */
 };
 
-/* QSB configuration for the SDM845 SoC. */
+/* QSB configuration data for an SoC having IPA v3.5.1 */
 static const struct ipa_qsb_data ipa_qsb_data[] = {
 	[IPA_QSB_MASTER_DDR] = {
 		.max_writes	= 8,
@@ -53,7 +53,7 @@ static const struct ipa_qsb_data ipa_qsb_data[] = {
 	},
 };
 
-/* Endpoint configuration for the SDM845 SoC. */
+/* Endpoint datdata for an SoC having IPA v3.5.1 */
 static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 	[IPA_ENDPOINT_AP_COMMAND_TX] = {
 		.ee_id		= GSI_EE_AP,
@@ -170,7 +170,7 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 	},
 };
 
-/* Source resource configuration data for the SDM845 SoC */
+/* Source resource configuration data for an SoC having IPA v3.5.1 */
 static const struct ipa_resource ipa_resource_src[] = {
 	[IPA_RESOURCE_TYPE_SRC_PKT_CONTEXTS] = {
 		.limits[IPA_RSRC_GROUP_SRC_LWA_DL] = {
@@ -232,7 +232,7 @@ static const struct ipa_resource ipa_resource_src[] = {
 	},
 };
 
-/* Destination resource configuration data for the SDM845 SoC */
+/* Destination resource configuration data for an SoC having IPA v3.5.1 */
 static const struct ipa_resource ipa_resource_dst[] = {
 	[IPA_RESOURCE_TYPE_DST_DATA_SECTORS] = {
 		.limits[IPA_RSRC_GROUP_DST_LWA_DL] = {
@@ -258,7 +258,7 @@ static const struct ipa_resource ipa_resource_dst[] = {
 	},
 };
 
-/* Resource configuration for the SDM845 SoC. */
+/* Resource configuration data for an SoC having IPA v3.5.1 */
 static const struct ipa_resource_data ipa_resource_data = {
 	.rsrc_group_src_count	= IPA_RSRC_GROUP_SRC_COUNT,
 	.rsrc_group_dst_count	= IPA_RSRC_GROUP_DST_COUNT,
@@ -268,7 +268,7 @@ static const struct ipa_resource_data ipa_resource_data = {
 	.resource_dst		= ipa_resource_dst,
 };
 
-/* IPA-resident memory region configuration for the SDM845 SoC. */
+/* IPA-resident memory region data for an SoC having IPA v3.5.1 */
 static const struct ipa_mem ipa_mem_local_data[] = {
 	[IPA_MEM_UC_SHARED] = {
 		.offset		= 0x0000,
@@ -347,6 +347,7 @@ static const struct ipa_mem ipa_mem_local_data[] = {
 	},
 };
 
+/* Memory configuration data for an SoC having IPA v3.5.1 */
 static const struct ipa_mem_data ipa_mem_data = {
 	.local_count	= ARRAY_SIZE(ipa_mem_local_data),
 	.local		= ipa_mem_local_data,
@@ -376,14 +377,15 @@ static const struct ipa_interconnect_data ipa_interconnect_data[] = {
 	},
 };
 
+/* Clock and interconnect configuration data for an SoC having IPA v3.5.1 */
 static const struct ipa_clock_data ipa_clock_data = {
 	.core_clock_rate	= 75 * 1000 * 1000,	/* Hz */
 	.interconnect_count	= ARRAY_SIZE(ipa_interconnect_data),
 	.interconnect_data	= ipa_interconnect_data,
 };
 
-/* Configuration data for the SDM845 SoC. */
-const struct ipa_data ipa_data_sdm845 = {
+/* Configuration data for an SoC having IPA v3.5.1 */
+const struct ipa_data ipa_data_v3_5_1 = {
 	.version	= IPA_VERSION_3_5_1,
 	.backward_compat = BCR_CMDQ_L_LACK_ONE_ENTRY_FMASK |
 			   BCR_TX_NOT_USING_BRESP_FMASK |
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index 843d818f78e18..17cdc376e95f3 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -300,7 +300,7 @@ struct ipa_data {
 	const struct ipa_clock_data *clock_data;
 };
 
-extern const struct ipa_data ipa_data_sdm845;
+extern const struct ipa_data ipa_data_v3_5_1;
 extern const struct ipa_data ipa_data_sc7180;
 
 #endif /* _IPA_DATA_H_ */
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index afb8eb5618f73..37e85a5ab75cf 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -578,7 +578,7 @@ static int ipa_firmware_load(struct device *dev)
 static const struct of_device_id ipa_match[] = {
 	{
 		.compatible	= "qcom,sdm845-ipa",
-		.data		= &ipa_data_sdm845,
+		.data		= &ipa_data_v3_5_1,
 	},
 	{
 		.compatible	= "qcom,sc7180-ipa",
-- 
2.27.0

