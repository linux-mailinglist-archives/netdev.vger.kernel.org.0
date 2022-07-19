Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64B057A1D6
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239278AbiGSOib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239282AbiGSOiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:38:07 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C425D286E6
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 07:33:09 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id a18-20020a05600c349200b003a30de68697so1110301wmq.0
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 07:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1htt3sRateXvcU1ylDQghkW6+6TpG01zPBq1kp3I6v0=;
        b=LbQVY51kfE/SQ+CwYhf5/FWArpIQGjFICcvHyEzP/D4t6PXWjgwWVmocCbIVaCyjVm
         3m7qpwFbq+y+2AFoYWRpvbEmT8lEaKnCIET1ssOTxArw2FShO5DZg47fsHhQJf4GKU9Q
         PBMqgp+2ZiRQ991wbnW/qZOQQbgV1rDW0Zhfs5lfNolOCrjSkQon+xxrIYSMsvgMUph2
         ctpfECPfZcDEdnUFIStieFgvP5iM8Gt1T8x9qRBpUvCmdTdCswLNPUjxQbfeQ7AlGl8k
         BdTpLxBssM8VNxq7fL9Z5QRY2ObIuMXP1qUtMe5qLncwfyBam4Q9C5Frm2xjRXDxDlpV
         sdcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1htt3sRateXvcU1ylDQghkW6+6TpG01zPBq1kp3I6v0=;
        b=dKWI4hB6l7bYEEh5gK021y/lwFg1c2nfY2Ynr/yOf/WZN+sF1G1fo6IWnXiH8qZQ+y
         DmXU3Rrsi59yaGLbDcFn+JfSM6mcW0pXwbjLnifTJrnEajXPes055HxWN41xNg1KQq7I
         AmXy6PaNZrLUmmCkv4D2uUyWeXFBQW7O+VnC7ZezF/ClPhkT/nIw1zMIlqKNq+BfEdkO
         WN6lBHvTABP4VnAUROZdBoOHTLVEqsAijeh4MNt27OgKoDSxFC42L5uHJNE77xJTZaf6
         3DRxQ1j35tGojGJq/GWft3EFE8AmJjmSYQvP1o5YrmEhLkqIxmUi8O04S/7fLJw0dCFf
         lAzg==
X-Gm-Message-State: AJIora/TEnJc2FQkNtfXIkjdVONEYAvUXRsEJBk5GeBzw2+ZPulyL93C
        T2L+3kjYS4stWy5ikzT2pIEwig==
X-Google-Smtp-Source: AGRyM1sGVVyYwP5J3x0H+bHJQlWuwNacg749YsuCWsctAoB9pitduyg7nMpRZOq2QijHmwliJ/Ch4Q==
X-Received: by 2002:a05:600c:3844:b0:3a3:d71:c4ce with SMTP id s4-20020a05600c384400b003a30d71c4cemr19751175wmr.23.1658241188171;
        Tue, 19 Jul 2022 07:33:08 -0700 (PDT)
Received: from sagittarius-a.chello.ie (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id d15-20020adffbcf000000b0020fff0ea0a3sm13634378wrs.116.2022.07.19.07.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 07:33:07 -0700 (PDT)
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     kvalo@kernel.org, loic.poulain@linaro.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        bryan.odonoghue@linaro.org
Subject: [PATCH v2 3/4] wcn36xx: Move capability bitmap to string translation function to firmware.c
Date:   Tue, 19 Jul 2022 15:33:01 +0100
Message-Id: <20220719143302.2071223-4-bryan.odonoghue@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220719143302.2071223-1-bryan.odonoghue@linaro.org>
References: <20220719143302.2071223-1-bryan.odonoghue@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move wcn36xx_get_cap_name() function in main.c into firmware.c as
wcn36xx_firmware_get_cap_name().

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/firmware.c | 75 +++++++++++++++++++
 drivers/net/wireless/ath/wcn36xx/firmware.h |  2 +
 drivers/net/wireless/ath/wcn36xx/main.c     | 81 +--------------------
 3 files changed, 81 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/firmware.c b/drivers/net/wireless/ath/wcn36xx/firmware.c
index 03b93d2bdcf9..4b7f439e4db5 100644
--- a/drivers/net/wireless/ath/wcn36xx/firmware.c
+++ b/drivers/net/wireless/ath/wcn36xx/firmware.c
@@ -3,6 +3,81 @@
 #include "wcn36xx.h"
 #include "firmware.h"
 
+#define DEFINE(s)[s] = #s
+
+static const char * const wcn36xx_firmware_caps_names[] = {
+	DEFINE(MCC),
+	DEFINE(P2P),
+	DEFINE(DOT11AC),
+	DEFINE(SLM_SESSIONIZATION),
+	DEFINE(DOT11AC_OPMODE),
+	DEFINE(SAP32STA),
+	DEFINE(TDLS),
+	DEFINE(P2P_GO_NOA_DECOUPLE_INIT_SCAN),
+	DEFINE(WLANACTIVE_OFFLOAD),
+	DEFINE(BEACON_OFFLOAD),
+	DEFINE(SCAN_OFFLOAD),
+	DEFINE(ROAM_OFFLOAD),
+	DEFINE(BCN_MISS_OFFLOAD),
+	DEFINE(STA_POWERSAVE),
+	DEFINE(STA_ADVANCED_PWRSAVE),
+	DEFINE(AP_UAPSD),
+	DEFINE(AP_DFS),
+	DEFINE(BLOCKACK),
+	DEFINE(PHY_ERR),
+	DEFINE(BCN_FILTER),
+	DEFINE(RTT),
+	DEFINE(RATECTRL),
+	DEFINE(WOW),
+	DEFINE(WLAN_ROAM_SCAN_OFFLOAD),
+	DEFINE(SPECULATIVE_PS_POLL),
+	DEFINE(SCAN_SCH),
+	DEFINE(IBSS_HEARTBEAT_OFFLOAD),
+	DEFINE(WLAN_SCAN_OFFLOAD),
+	DEFINE(WLAN_PERIODIC_TX_PTRN),
+	DEFINE(ADVANCE_TDLS),
+	DEFINE(BATCH_SCAN),
+	DEFINE(FW_IN_TX_PATH),
+	DEFINE(EXTENDED_NSOFFLOAD_SLOT),
+	DEFINE(CH_SWITCH_V1),
+	DEFINE(HT40_OBSS_SCAN),
+	DEFINE(UPDATE_CHANNEL_LIST),
+	DEFINE(WLAN_MCADDR_FLT),
+	DEFINE(WLAN_CH144),
+	DEFINE(NAN),
+	DEFINE(TDLS_SCAN_COEXISTENCE),
+	DEFINE(LINK_LAYER_STATS_MEAS),
+	DEFINE(MU_MIMO),
+	DEFINE(EXTENDED_SCAN),
+	DEFINE(DYNAMIC_WMM_PS),
+	DEFINE(MAC_SPOOFED_SCAN),
+	DEFINE(BMU_ERROR_GENERIC_RECOVERY),
+	DEFINE(DISA),
+	DEFINE(FW_STATS),
+	DEFINE(WPS_PRBRSP_TMPL),
+	DEFINE(BCN_IE_FLT_DELTA),
+	DEFINE(TDLS_OFF_CHANNEL),
+	DEFINE(RTT3),
+	DEFINE(MGMT_FRAME_LOGGING),
+	DEFINE(ENHANCED_TXBD_COMPLETION),
+	DEFINE(LOGGING_ENHANCEMENT),
+	DEFINE(EXT_SCAN_ENHANCED),
+	DEFINE(MEMORY_DUMP_SUPPORTED),
+	DEFINE(PER_PKT_STATS_SUPPORTED),
+	DEFINE(EXT_LL_STAT),
+	DEFINE(WIFI_CONFIG),
+	DEFINE(ANTENNA_DIVERSITY_SELECTION),
+};
+
+#undef DEFINE
+
+const char *wcn36xx_firmware_get_cap_name(enum wcn36xx_firmware_feat_caps x)
+{
+	if (x >= ARRAY_SIZE(wcn36xx_firmware_caps_names))
+		return "UNKNOWN";
+	return wcn36xx_firmware_caps_names[x];
+}
+
 void wcn36xx_firmware_set_feat_caps(u32 *bitmap,
 				    enum wcn36xx_firmware_feat_caps cap)
 {
diff --git a/drivers/net/wireless/ath/wcn36xx/firmware.h b/drivers/net/wireless/ath/wcn36xx/firmware.h
index 552c0e9325e1..f991cf959f82 100644
--- a/drivers/net/wireless/ath/wcn36xx/firmware.h
+++ b/drivers/net/wireless/ath/wcn36xx/firmware.h
@@ -78,5 +78,7 @@ int wcn36xx_firmware_get_feat_caps(u32 *bitmap,
 void wcn36xx_firmware_clear_feat_caps(u32 *bitmap,
 				      enum wcn36xx_firmware_feat_caps cap);
 
+const char *wcn36xx_firmware_get_cap_name(enum wcn36xx_firmware_feat_caps x);
+
 #endif /* _FIRMWARE_H_ */
 
diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index af62911a4659..fec85e89a02f 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -193,88 +193,15 @@ static inline u8 get_sta_index(struct ieee80211_vif *vif,
 	       sta_priv->sta_index;
 }
 
-#define DEFINE(s) [s] = #s
-
-static const char * const wcn36xx_caps_names[] = {
-	DEFINE(MCC),
-	DEFINE(P2P),
-	DEFINE(DOT11AC),
-	DEFINE(SLM_SESSIONIZATION),
-	DEFINE(DOT11AC_OPMODE),
-	DEFINE(SAP32STA),
-	DEFINE(TDLS),
-	DEFINE(P2P_GO_NOA_DECOUPLE_INIT_SCAN),
-	DEFINE(WLANACTIVE_OFFLOAD),
-	DEFINE(BEACON_OFFLOAD),
-	DEFINE(SCAN_OFFLOAD),
-	DEFINE(ROAM_OFFLOAD),
-	DEFINE(BCN_MISS_OFFLOAD),
-	DEFINE(STA_POWERSAVE),
-	DEFINE(STA_ADVANCED_PWRSAVE),
-	DEFINE(AP_UAPSD),
-	DEFINE(AP_DFS),
-	DEFINE(BLOCKACK),
-	DEFINE(PHY_ERR),
-	DEFINE(BCN_FILTER),
-	DEFINE(RTT),
-	DEFINE(RATECTRL),
-	DEFINE(WOW),
-	DEFINE(WLAN_ROAM_SCAN_OFFLOAD),
-	DEFINE(SPECULATIVE_PS_POLL),
-	DEFINE(SCAN_SCH),
-	DEFINE(IBSS_HEARTBEAT_OFFLOAD),
-	DEFINE(WLAN_SCAN_OFFLOAD),
-	DEFINE(WLAN_PERIODIC_TX_PTRN),
-	DEFINE(ADVANCE_TDLS),
-	DEFINE(BATCH_SCAN),
-	DEFINE(FW_IN_TX_PATH),
-	DEFINE(EXTENDED_NSOFFLOAD_SLOT),
-	DEFINE(CH_SWITCH_V1),
-	DEFINE(HT40_OBSS_SCAN),
-	DEFINE(UPDATE_CHANNEL_LIST),
-	DEFINE(WLAN_MCADDR_FLT),
-	DEFINE(WLAN_CH144),
-	DEFINE(NAN),
-	DEFINE(TDLS_SCAN_COEXISTENCE),
-	DEFINE(LINK_LAYER_STATS_MEAS),
-	DEFINE(MU_MIMO),
-	DEFINE(EXTENDED_SCAN),
-	DEFINE(DYNAMIC_WMM_PS),
-	DEFINE(MAC_SPOOFED_SCAN),
-	DEFINE(BMU_ERROR_GENERIC_RECOVERY),
-	DEFINE(DISA),
-	DEFINE(FW_STATS),
-	DEFINE(WPS_PRBRSP_TMPL),
-	DEFINE(BCN_IE_FLT_DELTA),
-	DEFINE(TDLS_OFF_CHANNEL),
-	DEFINE(RTT3),
-	DEFINE(MGMT_FRAME_LOGGING),
-	DEFINE(ENHANCED_TXBD_COMPLETION),
-	DEFINE(LOGGING_ENHANCEMENT),
-	DEFINE(EXT_SCAN_ENHANCED),
-	DEFINE(MEMORY_DUMP_SUPPORTED),
-	DEFINE(PER_PKT_STATS_SUPPORTED),
-	DEFINE(EXT_LL_STAT),
-	DEFINE(WIFI_CONFIG),
-	DEFINE(ANTENNA_DIVERSITY_SELECTION),
-};
-
-#undef DEFINE
-
-static const char *wcn36xx_get_cap_name(enum wcn36xx_firmware_feat_caps x)
-{
-	if (x >= ARRAY_SIZE(wcn36xx_caps_names))
-		return "UNKNOWN";
-	return wcn36xx_caps_names[x];
-}
-
 static void wcn36xx_feat_caps_info(struct wcn36xx *wcn)
 {
 	int i;
 
 	for (i = 0; i < MAX_FEATURE_SUPPORTED; i++) {
-		if (wcn36xx_firmware_get_feat_caps(wcn->fw_feat_caps, i))
-			wcn36xx_dbg(WCN36XX_DBG_MAC, "FW Cap %s\n", wcn36xx_get_cap_name(i));
+		if (wcn36xx_firmware_get_feat_caps(wcn->fw_feat_caps, i)) {
+			wcn36xx_dbg(WCN36XX_DBG_MAC, "FW Cap %s\n",
+				    wcn36xx_firmware_get_cap_name(i));
+		}
 	}
 }
 
-- 
2.36.1

