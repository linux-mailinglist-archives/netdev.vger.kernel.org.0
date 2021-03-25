Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E754034946C
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 15:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhCYOp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 10:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbhCYOoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 10:44:46 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C15FC06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 07:44:45 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id t6so2296357ilp.11
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 07:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RUUFRjG8RmEi6/zH6O0S1vqwpDh4QQOM0apRN15YvZ4=;
        b=Il58kVfk/QRMvhR6gBmL0uZtQN70C3sgOvkZVAUjCE+bt3xa9hdsdy9aqmR/KoJ+k4
         IXGtCzYe7oHVjaVUiOwLI26Vzlpd+79WCFeTH19XaQzZVWOhVrW+4g4iRfyQTj7T3XTU
         ogRPHfReVzWN1HFavCBUeTnQFLqQxkSJJ0R90GFVe2J40mG/xp1U5wAKMWEz+sg1IVVe
         kULXoNDXdNgtYZN0v8aNCiBaNyt4PI6+IRIlW5ApgOtK6uQVuvN13l84d8//XK+Xi9iU
         5bbePCDmODoj6S3XpUkwYzu3pgjmp3dgbObiPV4K7jqRasErJXU7dKWcnmvE9txMbmAh
         jJ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RUUFRjG8RmEi6/zH6O0S1vqwpDh4QQOM0apRN15YvZ4=;
        b=S4KPO+42k2TNDbSX7e9PinzJboil3H+AsraVMhjS1aUiZ8aR6V8BBy6kbWPoN+VBg8
         LJBtwYm1cD5Tajo/GRTig06qrt1tc1idgVoJ1Mt70EnGcbJNbL5YbPRWKVti9Pe5VkI8
         SoDFPMuN72lagjfY8/1hR7zHJwkCnYpKmSkTUrjb3UIpSSbu2ZBF5SSfZMUcwlhbVAW8
         e8mTIysOIqHbzzgStefoJq4noFida7YaBz87xcPgeOP16j1qHbxT8S25+cobMp2a0RKy
         6FnHsd799xTa9FEFBL7+vm32ShP03ET7x1shHdpbGP66syK0yoSTT0i4iLRNWa+MX9g7
         wYrA==
X-Gm-Message-State: AOAM53050m4ljf94e1YAxdGr8hXzgTLt0Tf3tymTUe3i7dkGOzIEnSo2
        5gRXM0mAvopOSd6lF6JNT3UWDQ==
X-Google-Smtp-Source: ABdhPJwpoUcTspVLyys3cJB2EbD2ZdGG2DbYKCZdvMVJrKb2Bqto7/HW3LAOUWSqo3OVFTz44HeevQ==
X-Received: by 2002:a92:dc42:: with SMTP id x2mr4993814ilq.115.1616683484887;
        Thu, 25 Mar 2021 07:44:44 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id x20sm2879196ilc.88.2021.03.25.07.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 07:44:44 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/6] net: ipa: GSI register cleanup
Date:   Thu, 25 Mar 2021 09:44:35 -0500
Message-Id: <20210325144437.2707892-5-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210325144437.2707892-1-elder@linaro.org>
References: <20210325144437.2707892-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main purpose of this is to extend these GSI register definitions
to support additional IPA versions.

This patch makes some minor updates to "gsi_reg.h":
  - Define a DB_IN_BYTES field in the channel QOS register
  - Add some comments clarifying when certain fields are valid
  - Add the definition of GSI_CH_DB_STOP channel command
  - Add a couple of blank lines
  - Move one comment and indent another
  - Delete two unused register definitions at the end.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi_reg.h | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 1622d8cf8dea4..6b53adbc667af 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -114,6 +114,9 @@ enum gsi_channel_type {
 /* The next two fields are present for IPA v4.5 and above */
 #define PREFETCH_MODE_FMASK		GENMASK(13, 10)
 #define EMPTY_LVL_THRSHOLD_FMASK	GENMASK(23, 16)
+/* The next field is present for IPA v4.9 and above */
+#define DB_IN_BYTES			GENMASK(24, 24)
+
 /** enum gsi_prefetch_mode - PREFETCH_MODE field in CH_C_QOS */
 enum gsi_prefetch_mode {
 	GSI_USE_PREFETCH_BUFS			= 0x0,
@@ -146,13 +149,13 @@ enum gsi_prefetch_mode {
 		GSI_EE_N_EV_CH_E_CNTXT_0_OFFSET((ev), GSI_EE_AP)
 #define GSI_EE_N_EV_CH_E_CNTXT_0_OFFSET(ev, ee) \
 		(0x0001d000 + 0x4000 * (ee) + 0x80 * (ev))
+/* enum gsi_channel_type defines EV_CHTYPE field values in EV_CH_E_CNTXT_0 */
 #define EV_CHTYPE_FMASK			GENMASK(3, 0)
 #define EV_EE_FMASK			GENMASK(7, 4)
 #define EV_EVCHID_FMASK			GENMASK(15, 8)
 #define EV_INTYPE_FMASK			GENMASK(16, 16)
 #define EV_CHSTATE_FMASK		GENMASK(23, 20)
 #define EV_ELEMENT_SIZE_FMASK		GENMASK(31, 24)
-/* enum gsi_channel_type defines EV_CHTYPE field values in EV_CH_E_CNTXT_0 */
 
 #define GSI_EV_CH_E_CNTXT_1_OFFSET(ev) \
 		GSI_EE_N_EV_CH_E_CNTXT_1_OFFSET((ev), GSI_EE_AP)
@@ -248,6 +251,7 @@ enum gsi_ch_cmd_opcode {
 	GSI_CH_STOP				= 0x2,
 	GSI_CH_RESET				= 0x9,
 	GSI_CH_DE_ALLOC				= 0xa,
+	GSI_CH_DB_STOP				= 0xb,
 };
 
 #define GSI_EV_CH_CMD_OFFSET \
@@ -278,6 +282,7 @@ enum gsi_generic_cmd_opcode {
 	GSI_GENERIC_ALLOCATE_CHANNEL		= 0x2,
 };
 
+/* The next register is present for IPA v3.5.1 and above */
 #define GSI_GSI_HW_PARAM_2_OFFSET \
 			GSI_EE_N_GSI_HW_PARAM_2_OFFSET(GSI_EE_AP)
 #define GSI_EE_N_GSI_HW_PARAM_2_OFFSET(ee) \
@@ -300,7 +305,7 @@ enum gsi_generic_cmd_opcode {
 enum gsi_iram_size {
 	IRAM_SIZE_ONE_KB			= 0x0,
 	IRAM_SIZE_TWO_KB			= 0x1,
-/* The next two values are available for IPA v4.0 and above */
+	/* The next two values are available for IPA v4.0 and above */
 	IRAM_SIZE_TWO_N_HALF_KB			= 0x2,
 	IRAM_SIZE_THREE_KB			= 0x3,
 	/* The next two values are available for IPA v4.5 and above */
@@ -424,6 +429,8 @@ enum gsi_general_id {
 			GSI_EE_N_ERROR_LOG_OFFSET(GSI_EE_AP)
 #define GSI_EE_N_ERROR_LOG_OFFSET(ee) \
 			(0x0001f200 + 0x4000 * (ee))
+
+/* Fields below are present for IPA v3.5.1 and above */
 #define ERR_ARG3_FMASK			GENMASK(3, 0)
 #define ERR_ARG2_FMASK			GENMASK(7, 4)
 #define ERR_ARG1_FMASK			GENMASK(11, 8)
@@ -474,7 +481,4 @@ enum gsi_generic_ee_result {
 	GENERIC_EE_NO_RESOURCES			= 0x7,
 };
 
-#define USB_MAX_PACKET_FMASK		GENMASK(15, 15)	/* 0: HS; 1: SS */
-#define MHI_BASE_CHANNEL_FMASK		GENMASK(31, 24)
-
 #endif	/* _GSI_REG_H_ */
-- 
2.27.0

