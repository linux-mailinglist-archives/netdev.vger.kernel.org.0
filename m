Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F6169593F
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 07:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbjBNGgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 01:36:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjBNGgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 01:36:32 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97725A27A;
        Mon, 13 Feb 2023 22:36:31 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id z1so16032986plg.6;
        Mon, 13 Feb 2023 22:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+UX8OV2gJDE8KCJEfKycMcF35075c7iSsmVUHRHLZAw=;
        b=erHJrXMkSNlo5naB7lviZr2DzmVOA64s0lreC4BQCGcU4QWmC8YNC/82siVx33aBea
         7jRT8AtH8aLGXifSN5iBgZ00F1H4dYpRmoXTCiqdEdGhK9m96XuIH3zziwXJBYOg7XUp
         ZrKMFESlaG0EPwl0rQejBWkjtTT3azLgO55pXLILzDjT0XjaXKF74jw7nA3O8qXDycQ1
         o0mxDsNrT+bzPtHgRzrjUWNEjJfXGWwRV3Vq5QqOuuX5JA8f6h71hUfm86fWv8gZiP6G
         YKCW4onOvaFKIxd23ksRkYhL02u0Qm+vCiRCxJyaRozA3mgdD1Qa02wiNbYoTHhxaqPZ
         i2Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+UX8OV2gJDE8KCJEfKycMcF35075c7iSsmVUHRHLZAw=;
        b=uyz+IhH1hajf/CnypsR9efUPM1fWi6RYJNd/rQujaKBJfiCNE1gj8bkge9ba+SlKCB
         NVnyueqQ/DRDczkV9MgTZOC3nosPGQUu6kzremXMC05bB8K4NmAvtW+F891802H1Ev5F
         6y1qm/fZwX5UDTePKYWx34hX+n1kebb48z9Ivcm+6FwVjT+596ZZvUGxNlLMpxTqiMRq
         gVjhVlpoIUIkrcZhHAB4kCwZiNIJ0lcSE6rC4T7d/2Y1blPjWTrH4iOrR9EA4ix0zt/a
         c+G8J5hnsMuRM44DBebX1ZdJVct6kPCKprT4OQlIfSLLezgBuD0tvUl+vIT7yFR/BDjy
         uH5g==
X-Gm-Message-State: AO0yUKX3qmM11eeCYUOoBzid0oRzrJHPRUPRKb/lIHOxGSimz/OkDFse
        yHzAIxxZo2FU8VMEBPnnkg==
X-Google-Smtp-Source: AK7set+dQX/tk5OaPBsXrdSWRG1mIvBWSJydUHu8XcSREWMO9l+8A3VCFJPgrdOS5QAtt56zWTRPXg==
X-Received: by 2002:a05:6a20:8413:b0:bc:8c5e:ed0d with SMTP id c19-20020a056a20841300b000bc8c5eed0dmr1465702pzd.40.1676356591084;
        Mon, 13 Feb 2023 22:36:31 -0800 (PST)
Received: from 8888.icu ([165.154.226.86])
        by smtp.googlemail.com with ESMTPSA id q2-20020a637502000000b004fb681ea0e1sm6087443pgc.84.2023.02.13.22.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 22:36:30 -0800 (PST)
From:   Lu jicong <jiconglu58@gmail.com>
To:     pkshih@realtek.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu jicong <jiconglu58@gmail.com>
Subject: [PATCH V2] wifi: rtlwifi: rtl8192ce: fix dealing empty EEPROM values
Date:   Tue, 14 Feb 2023 06:36:02 +0000
Message-Id: <20230214063602.2257263-1-jiconglu58@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On OpenWRT platform, RTL8192CE could be soldered on board, but not standard PCI
module. In this case, some EEPROM values aren't programmed and left 0xff.
Load default values when the EEPROM values are empty to avoid problems.

Signed-off-by: Lu jicong <jiconglu58@gmail.com>
---
v2: add more detailed commit message
---
 .../wireless/realtek/rtlwifi/rtl8192ce/hw.c   | 31 +++++++++++++------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
index b9c62640d2cb..8ddf0017af4c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
@@ -1428,7 +1428,9 @@ static void _rtl92ce_read_txpower_info_from_hwpg(struct ieee80211_hw *hw,
 
 	for (rf_path = 0; rf_path < 2; rf_path++) {
 		for (i = 0; i < 3; i++) {
-			if (!autoload_fail) {
+			if (!autoload_fail &&
+			    hwinfo[EEPROM_TXPOWERCCK + rf_path * 3 + i] != 0xff &&
+			    hwinfo[EEPROM_TXPOWERHT40_1S + rf_path * 3 + i] != 0xff) {
 				rtlefuse->
 				    eeprom_chnlarea_txpwr_cck[rf_path][i] =
 				    hwinfo[EEPROM_TXPOWERCCK + rf_path * 3 + i];
@@ -1448,7 +1450,8 @@ static void _rtl92ce_read_txpower_info_from_hwpg(struct ieee80211_hw *hw,
 	}
 
 	for (i = 0; i < 3; i++) {
-		if (!autoload_fail)
+		if (!autoload_fail &&
+		    hwinfo[EEPROM_TXPOWERHT40_2SDIFF + i] != 0xff)
 			tempval = hwinfo[EEPROM_TXPOWERHT40_2SDIFF + i];
 		else
 			tempval = EEPROM_DEFAULT_HT40_2SDIFF;
@@ -1518,7 +1521,9 @@ static void _rtl92ce_read_txpower_info_from_hwpg(struct ieee80211_hw *hw,
 	}
 
 	for (i = 0; i < 3; i++) {
-		if (!autoload_fail) {
+		if (!autoload_fail &&
+		    hwinfo[EEPROM_TXPWR_GROUP + i] != 0xff &&
+		    hwinfo[EEPROM_TXPWR_GROUP + 3 + i] != 0xff) {
 			rtlefuse->eeprom_pwrlimit_ht40[i] =
 			    hwinfo[EEPROM_TXPWR_GROUP + i];
 			rtlefuse->eeprom_pwrlimit_ht20[i] =
@@ -1563,7 +1568,8 @@ static void _rtl92ce_read_txpower_info_from_hwpg(struct ieee80211_hw *hw,
 	for (i = 0; i < 14; i++) {
 		index = rtl92c_get_chnl_group((u8)i);
 
-		if (!autoload_fail)
+		if (!autoload_fail &&
+		    hwinfo[EEPROM_TXPOWERHT20DIFF + index] != 0xff)
 			tempval = hwinfo[EEPROM_TXPOWERHT20DIFF + index];
 		else
 			tempval = EEPROM_DEFAULT_HT20_DIFF;
@@ -1580,7 +1586,8 @@ static void _rtl92ce_read_txpower_info_from_hwpg(struct ieee80211_hw *hw,
 
 		index = rtl92c_get_chnl_group((u8)i);
 
-		if (!autoload_fail)
+		if (!autoload_fail &&
+		    hwinfo[EEPROM_TXPOWER_OFDMDIFF + index] != 0xff)
 			tempval = hwinfo[EEPROM_TXPOWER_OFDMDIFF + index];
 		else
 			tempval = EEPROM_DEFAULT_LEGACYHTTXPOWERDIFF;
@@ -1610,14 +1617,16 @@ static void _rtl92ce_read_txpower_info_from_hwpg(struct ieee80211_hw *hw,
 			"RF-B Legacy to HT40 Diff[%d] = 0x%x\n",
 			i, rtlefuse->txpwr_legacyhtdiff[RF90_PATH_B][i]);
 
-	if (!autoload_fail)
+	if (!autoload_fail && hwinfo[RF_OPTION1] != 0xff)
 		rtlefuse->eeprom_regulatory = (hwinfo[RF_OPTION1] & 0x7);
 	else
 		rtlefuse->eeprom_regulatory = 0;
 	RTPRINT(rtlpriv, FINIT, INIT_TXPOWER,
 		"eeprom_regulatory = 0x%x\n", rtlefuse->eeprom_regulatory);
 
-	if (!autoload_fail) {
+	if (!autoload_fail &&
+	    hwinfo[EEPROM_TSSI_A] != 0xff &&
+	    hwinfo[EEPROM_TSSI_B] != 0xff) {
 		rtlefuse->eeprom_tssi[RF90_PATH_A] = hwinfo[EEPROM_TSSI_A];
 		rtlefuse->eeprom_tssi[RF90_PATH_B] = hwinfo[EEPROM_TSSI_B];
 	} else {
@@ -1628,7 +1637,7 @@ static void _rtl92ce_read_txpower_info_from_hwpg(struct ieee80211_hw *hw,
 		rtlefuse->eeprom_tssi[RF90_PATH_A],
 		rtlefuse->eeprom_tssi[RF90_PATH_B]);
 
-	if (!autoload_fail)
+	if (!autoload_fail && hwinfo[EEPROM_THERMAL_METER] != 0xff)
 		tempval = hwinfo[EEPROM_THERMAL_METER];
 	else
 		tempval = EEPROM_DEFAULT_THERMALMETER;
-- 
2.30.2

