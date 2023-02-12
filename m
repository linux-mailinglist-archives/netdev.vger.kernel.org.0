Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E43569371D
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 13:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjBLMGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 07:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjBLMG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 07:06:29 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F17D507;
        Sun, 12 Feb 2023 04:06:28 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id e1so1670490pgg.9;
        Sun, 12 Feb 2023 04:06:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GafBbC7xeBZYLkuCtxwzqRhX+ahl7uotAeuWQgz/Iyk=;
        b=W/zy4pbR63C5lj4DtuHbGwVnqVLAj+or9aX3CO8ZX9NM4FaIE5GYNRNx0ek9SCsqdk
         hNpkfxYmzdMh1v7oWqq4p1dOAXEpjG14qVQYxlZ1Lns54HTQ2qNoBh/absgFzoCsM8z4
         v2hIgauJf3J2n6MdVl9aWrhyUtAa4pQsvtdA4SqY774FRgIjmrO108oHYMJ1LUaTCsmS
         yp0NyPLgbgw4FNh88FjpIop546lTqgKvDlC8ODQqnt6n5QNGUkMg2fiLyUbHCK63Qx5o
         aklB53/tVB60S9O60AxeKTC6ebjRDGF1GFbVzOdj/eaKGhAN6FCCbufI2bzIZsBDtotJ
         z+0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GafBbC7xeBZYLkuCtxwzqRhX+ahl7uotAeuWQgz/Iyk=;
        b=WsKTTlDGaAmwpWVEu73jeST+cFiz1RK7X68i50qLsESYI6IZf5ZQPyLxe03H0TaGjh
         fcGG2ztjJ/xFXJ5PgpDPkNQeLLsZWEJAgAX4s1COHCULHw6+VLIVtqAJ09EDur7u6Yiz
         PVFJ3PLDxZdqDyN0Jjc5GSbQSGbkdC+LD732JyzXBfezXfvmaW+UXaNsZvdDkMgQoVHa
         85X//yE9iNqBkc8okki9xXN+dYqEPQgGdO92Y6Nfw/LfTn0lT3Qyc5NVq+05FeXvSKMa
         EvisyEHerqCuzZ3OQsPKlalPWoA/+LABjxRpAxEA5l1K+Ya9u/EbhAcf7Mo4u50o/IdG
         tIRQ==
X-Gm-Message-State: AO0yUKWmbxrON6QsaZUcUylS0T0/CCBcrxzfEoUAw5GrfqnPXz79bvCI
        81tF8GJkUO5OqIoR9fjo2T5zi34CQB8xy5WZYA==
X-Google-Smtp-Source: AK7set+9HuS/e97Bbvv4c4HzU8bSy9yO9fjyF8+Zwv1TMBD2X80T0fjGKu924gcvva+kL5G450GWFw==
X-Received: by 2002:a62:84d3:0:b0:5a8:aa9c:8524 with SMTP id k202-20020a6284d3000000b005a8aa9c8524mr2476291pfd.10.1676203588036;
        Sun, 12 Feb 2023 04:06:28 -0800 (PST)
Received: from 8888.icu ([165.154.226.86])
        by smtp.googlemail.com with ESMTPSA id 19-20020aa79213000000b00576259507c0sm6101786pfo.100.2023.02.12.04.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 04:06:27 -0800 (PST)
From:   Lu jicong <jiconglu58@gmail.com>
To:     pkshih@realtek.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     quic_srirrama@quicinc.com, jiconglu58@gmail.com,
        johannes.berg@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192ce: fix dealing empty eeprom values
Date:   Sun, 12 Feb 2023 12:06:10 +0000
Message-Id: <20230212120610.2026291-1-jiconglu58@gmail.com>
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

In some cases, eeprom is empty or partly empty.
Load default values when the eeprom values are empty to avoid problems.

Signed-off-by: Lu jicong <jiconglu58@gmail.com>
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

