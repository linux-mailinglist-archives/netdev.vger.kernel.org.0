Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50213604C7F
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 17:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbiJSP6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 11:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiJSP6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 11:58:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC7F168E4D;
        Wed, 19 Oct 2022 08:56:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25B516190F;
        Wed, 19 Oct 2022 15:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0582C433C1;
        Wed, 19 Oct 2022 15:55:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="nnI2xWqe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1666194953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7NutVEJCfXCWyKg+r7h8rNvlGvroRlL8ciWAkL9G584=;
        b=nnI2xWqe4l1VCnFb7GmCgDc2PLcu71mK/sfFLfyWlzq4TajnyAAdL82eokikw1VfjjyIJq
        DHqs9erb2oqSLxpe0v1gBG/TR9d4bnGVolyi4QhF8/Ffl7IJNkjRLd1EfTBG+RmDQo74xA
        J0S2hU7ak2sREdqzldXVhpFlic7Lnsc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 46f59497 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 19 Oct 2022 15:55:52 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH v3] wifi: rt2x00: use explicitly signed or unsigned types
Date:   Wed, 19 Oct 2022 09:55:41 -0600
Message-Id: <20221019155541.3410813-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9r61Njar8tGDT+utWdPiQ3KtxKJHQd0JQGSHsdXenaW6Q@mail.gmail.com>
References: <CAHmME9r61Njar8tGDT+utWdPiQ3KtxKJHQd0JQGSHsdXenaW6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some platforms, `char` is unsigned, but this driver, for the most
part, assumed it was signed. In other places, it uses `char` to mean an
unsigned number, but only in cases when the values are small. And in
still other places, `char` is used as a boolean. Put an end to this
confusion by declaring explicit types, depending on the context.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Kalle Valo <kvalo@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 .../net/wireless/ralink/rt2x00/rt2400pci.c    |  8 +--
 .../net/wireless/ralink/rt2x00/rt2400pci.h    |  2 +-
 .../net/wireless/ralink/rt2x00/rt2500pci.c    |  8 +--
 .../net/wireless/ralink/rt2x00/rt2500pci.h    |  2 +-
 .../net/wireless/ralink/rt2x00/rt2500usb.c    |  8 +--
 .../net/wireless/ralink/rt2x00/rt2500usb.h    |  2 +-
 .../net/wireless/ralink/rt2x00/rt2800lib.c    | 60 +++++++++----------
 .../net/wireless/ralink/rt2x00/rt2800lib.h    |  8 +--
 .../net/wireless/ralink/rt2x00/rt2x00usb.c    |  6 +-
 drivers/net/wireless/ralink/rt2x00/rt61pci.c  |  4 +-
 drivers/net/wireless/ralink/rt2x00/rt61pci.h  |  2 +-
 drivers/net/wireless/ralink/rt2x00/rt73usb.c  |  4 +-
 drivers/net/wireless/ralink/rt2x00/rt73usb.h  |  2 +-
 13 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
index 273c5eac3362..ddfc16de1b26 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
@@ -1023,9 +1023,9 @@ static int rt2400pci_set_state(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg, reg2;
 	unsigned int i;
-	char put_to_sleep;
-	char bbp_state;
-	char rf_state;
+	bool put_to_sleep;
+	u8 bbp_state;
+	u8 rf_state;
 
 	put_to_sleep = (state != STATE_AWAKE);
 
@@ -1561,7 +1561,7 @@ static int rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
 	struct channel_info *info;
-	char *tx_power;
+	u8 *tx_power;
 	unsigned int i;
 
 	/*
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2400pci.h b/drivers/net/wireless/ralink/rt2x00/rt2400pci.h
index b8187b6de143..979d5fd8babf 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2400pci.h
@@ -939,7 +939,7 @@
 #define DEFAULT_TXPOWER	39
 
 #define __CLAMP_TX(__txpower) \
-	clamp_t(char, (__txpower), MIN_TXPOWER, MAX_TXPOWER)
+	clamp_t(u8, (__txpower), MIN_TXPOWER, MAX_TXPOWER)
 
 #define TXPOWER_FROM_DEV(__txpower) \
 	((__CLAMP_TX(__txpower) - MAX_TXPOWER) + MIN_TXPOWER)
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
index 8faa0a80e73a..cd6371e25062 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
@@ -1176,9 +1176,9 @@ static int rt2500pci_set_state(struct rt2x00_dev *rt2x00dev,
 {
 	u32 reg, reg2;
 	unsigned int i;
-	char put_to_sleep;
-	char bbp_state;
-	char rf_state;
+	bool put_to_sleep;
+	u8 bbp_state;
+	u8 rf_state;
 
 	put_to_sleep = (state != STATE_AWAKE);
 
@@ -1856,7 +1856,7 @@ static int rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
 	struct channel_info *info;
-	char *tx_power;
+	u8 *tx_power;
 	unsigned int i;
 
 	/*
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500pci.h b/drivers/net/wireless/ralink/rt2x00/rt2500pci.h
index 7e64aee2a172..ba362675c52c 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500pci.h
@@ -1219,6 +1219,6 @@
 	(((u8)(__txpower)) > MAX_TXPOWER) ? DEFAULT_TXPOWER : (__txpower)
 
 #define TXPOWER_TO_DEV(__txpower) \
-	clamp_t(char, __txpower, MIN_TXPOWER, MAX_TXPOWER)
+	clamp_t(u8, __txpower, MIN_TXPOWER, MAX_TXPOWER)
 
 #endif /* RT2500PCI_H */
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
index bb5ed6630645..4f3b0e6c6256 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
@@ -984,9 +984,9 @@ static int rt2500usb_set_state(struct rt2x00_dev *rt2x00dev,
 	u16 reg;
 	u16 reg2;
 	unsigned int i;
-	char put_to_sleep;
-	char bbp_state;
-	char rf_state;
+	bool put_to_sleep;
+	u8 bbp_state;
+	u8 rf_state;
 
 	put_to_sleep = (state != STATE_AWAKE);
 
@@ -1663,7 +1663,7 @@ static int rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
 	struct channel_info *info;
-	char *tx_power;
+	u8 *tx_power;
 	unsigned int i;
 
 	/*
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500usb.h b/drivers/net/wireless/ralink/rt2x00/rt2500usb.h
index 0c070288a140..746f0e950b76 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500usb.h
@@ -839,6 +839,6 @@
 	(((u8)(__txpower)) > MAX_TXPOWER) ? DEFAULT_TXPOWER : (__txpower)
 
 #define TXPOWER_TO_DEV(__txpower) \
-	clamp_t(char, __txpower, MIN_TXPOWER, MAX_TXPOWER)
+	clamp_t(u8, __txpower, MIN_TXPOWER, MAX_TXPOWER)
 
 #endif /* RT2500USB_H */
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index cbbb1a4849cf..12b700c7b9c3 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -3372,10 +3372,10 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 	if (rt2x00_has_cap_bt_coexist(rt2x00dev)) {
 		if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F)) {
 			/* r55/r59 value array of channel 1~14 */
-			static const char r55_bt_rev[] = {0x83, 0x83,
+			static const u8 r55_bt_rev[] = {0x83, 0x83,
 				0x83, 0x73, 0x73, 0x63, 0x53, 0x53,
 				0x53, 0x43, 0x43, 0x43, 0x43, 0x43};
-			static const char r59_bt_rev[] = {0x0e, 0x0e,
+			static const u8 r59_bt_rev[] = {0x0e, 0x0e,
 				0x0e, 0x0e, 0x0e, 0x0b, 0x0a, 0x09,
 				0x07, 0x07, 0x07, 0x07, 0x07, 0x07};
 
@@ -3384,7 +3384,7 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 			rt2800_rfcsr_write(rt2x00dev, 59,
 					   r59_bt_rev[idx]);
 		} else {
-			static const char r59_bt[] = {0x8b, 0x8b, 0x8b,
+			static const u8 r59_bt[] = {0x8b, 0x8b, 0x8b,
 				0x8b, 0x8b, 0x8b, 0x8b, 0x8a, 0x89,
 				0x88, 0x88, 0x86, 0x85, 0x84};
 
@@ -3392,10 +3392,10 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 		}
 	} else {
 		if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F)) {
-			static const char r55_nonbt_rev[] = {0x23, 0x23,
+			static const u8 r55_nonbt_rev[] = {0x23, 0x23,
 				0x23, 0x23, 0x13, 0x13, 0x03, 0x03,
 				0x03, 0x03, 0x03, 0x03, 0x03, 0x03};
-			static const char r59_nonbt_rev[] = {0x07, 0x07,
+			static const u8 r59_nonbt_rev[] = {0x07, 0x07,
 				0x07, 0x07, 0x07, 0x07, 0x07, 0x07,
 				0x07, 0x07, 0x06, 0x05, 0x04, 0x04};
 
@@ -3406,14 +3406,14 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 		} else if (rt2x00_rt(rt2x00dev, RT5390) ||
 			   rt2x00_rt(rt2x00dev, RT5392) ||
 			   rt2x00_rt(rt2x00dev, RT6352)) {
-			static const char r59_non_bt[] = {0x8f, 0x8f,
+			static const u8 r59_non_bt[] = {0x8f, 0x8f,
 				0x8f, 0x8f, 0x8f, 0x8f, 0x8f, 0x8d,
 				0x8a, 0x88, 0x88, 0x87, 0x87, 0x86};
 
 			rt2800_rfcsr_write(rt2x00dev, 59,
 					   r59_non_bt[idx]);
 		} else if (rt2x00_rt(rt2x00dev, RT5350)) {
-			static const char r59_non_bt[] = {0x0b, 0x0b,
+			static const u8 r59_non_bt[] = {0x0b, 0x0b,
 				0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0a,
 				0x0a, 0x09, 0x08, 0x07, 0x07, 0x06};
 
@@ -4035,23 +4035,23 @@ static void rt2800_iq_calibrate(struct rt2x00_dev *rt2x00dev, int channel)
 	rt2800_bbp_write(rt2x00dev, 159, cal != 0xff ? cal : 0);
 }
 
-static char rt2800_txpower_to_dev(struct rt2x00_dev *rt2x00dev,
+static s8 rt2800_txpower_to_dev(struct rt2x00_dev *rt2x00dev,
 				  unsigned int channel,
-				  char txpower)
+				  s8 txpower)
 {
 	if (rt2x00_rt(rt2x00dev, RT3593) ||
 	    rt2x00_rt(rt2x00dev, RT3883))
 		txpower = rt2x00_get_field8(txpower, EEPROM_TXPOWER_ALC);
 
 	if (channel <= 14)
-		return clamp_t(char, txpower, MIN_G_TXPOWER, MAX_G_TXPOWER);
+		return clamp_t(s8, txpower, MIN_G_TXPOWER, MAX_G_TXPOWER);
 
 	if (rt2x00_rt(rt2x00dev, RT3593) ||
 	    rt2x00_rt(rt2x00dev, RT3883))
-		return clamp_t(char, txpower, MIN_A_TXPOWER_3593,
+		return clamp_t(s8, txpower, MIN_A_TXPOWER_3593,
 			       MAX_A_TXPOWER_3593);
 	else
-		return clamp_t(char, txpower, MIN_A_TXPOWER, MAX_A_TXPOWER);
+		return clamp_t(s8, txpower, MIN_A_TXPOWER, MAX_A_TXPOWER);
 }
 
 static void rt3883_bbp_adjust(struct rt2x00_dev *rt2x00dev,
@@ -8530,7 +8530,7 @@ static void rt2800_r_calibration(struct rt2x00_dev *rt2x00dev)
 	u8 bytevalue = 0;
 	int rcalcode;
 	u8 r_cal_code = 0;
-	char d1 = 0, d2 = 0;
+	s8 d1 = 0, d2 = 0;
 	u8 rfvalue;
 	u32 MAC_RF_BYPASS0, MAC_RF_CONTROL0, MAC_PWR_PIN_CFG;
 	u32 maccfg;
@@ -8591,7 +8591,7 @@ static void rt2800_r_calibration(struct rt2x00_dev *rt2x00dev)
 	if (bytevalue > 128)
 		d1 = bytevalue - 256;
 	else
-		d1 = (char)bytevalue;
+		d1 = (s8)bytevalue;
 	rt2800_bbp_write(rt2x00dev, 22, 0x0);
 	rt2800_rfcsr_write_bank(rt2x00dev, 0, 35, 0x01);
 
@@ -8601,7 +8601,7 @@ static void rt2800_r_calibration(struct rt2x00_dev *rt2x00dev)
 	if (bytevalue > 128)
 		d2 = bytevalue - 256;
 	else
-		d2 = (char)bytevalue;
+		d2 = (s8)bytevalue;
 	rt2800_bbp_write(rt2x00dev, 22, 0x0);
 
 	rcalcode = rt2800_calcrcalibrationcode(rt2x00dev, d1, d2);
@@ -8703,7 +8703,7 @@ static void rt2800_rxdcoc_calibration(struct rt2x00_dev *rt2x00dev)
 static u32 rt2800_do_sqrt_accumulation(u32 si)
 {
 	u32 root, root_pre, bit;
-	char i;
+	s8 i;
 
 	bit = 1 << 15;
 	root = 0;
@@ -9330,11 +9330,11 @@ static void rt2800_loft_search(struct rt2x00_dev *rt2x00dev, u8 ch_idx,
 			       u8 alc_idx, u8 dc_result[][RF_ALC_NUM][2])
 {
 	u32 p0 = 0, p1 = 0, pf = 0;
-	char idx0 = 0, idx1 = 0;
+	s8 idx0 = 0, idx1 = 0;
 	u8 idxf[] = {0x00, 0x00};
 	u8 ibit = 0x20;
 	u8 iorq;
-	char bidx;
+	s8 bidx;
 
 	rt2800_bbp_write(rt2x00dev, 158, 0xb0);
 	rt2800_bbp_write(rt2x00dev, 159, 0x80);
@@ -9384,17 +9384,17 @@ static void rt2800_loft_search(struct rt2x00_dev *rt2x00dev, u8 ch_idx,
 static void rt2800_iq_search(struct rt2x00_dev *rt2x00dev, u8 ch_idx, u8 *ges, u8 *pes)
 {
 	u32 p0 = 0, p1 = 0, pf = 0;
-	char perr = 0, gerr = 0, iq_err = 0;
-	char pef = 0, gef = 0;
-	char psta, pend;
-	char gsta, gend;
+	s8 perr = 0, gerr = 0, iq_err = 0;
+	s8 pef = 0, gef = 0;
+	s8 psta, pend;
+	s8 gsta, gend;
 
 	u8 ibit = 0x20;
 	u8 first_search = 0x00, touch_neg_max = 0x00;
-	char idx0 = 0, idx1 = 0;
+	s8 idx0 = 0, idx1 = 0;
 	u8 gop;
 	u8 bbp = 0;
-	char bidx;
+	s8 bidx;
 
 	for (bidx = 5; bidx >= 1; bidx--) {
 		for (gop = 0; gop < 2; gop++) {
@@ -10043,11 +10043,11 @@ static int rt2800_rf_lp_config(struct rt2x00_dev *rt2x00dev, bool btxcal)
 	return 0;
 }
 
-static char rt2800_lp_tx_filter_bw_cal(struct rt2x00_dev *rt2x00dev)
+static s8 rt2800_lp_tx_filter_bw_cal(struct rt2x00_dev *rt2x00dev)
 {
 	unsigned int cnt;
 	u8 bbp_val;
-	char cal_val;
+	s8 cal_val;
 
 	rt2800_bbp_dcoc_write(rt2x00dev, 0, 0x82);
 
@@ -10079,7 +10079,7 @@ static void rt2800_bw_filter_calibration(struct rt2x00_dev *rt2x00dev,
 	u8 rx_filter_target_20m = 0x27, rx_filter_target_40m = 0x31;
 	int loop = 0, is_ht40, cnt;
 	u8 bbp_val, rf_val;
-	char cal_r32_init, cal_r32_val, cal_diff;
+	s8 cal_r32_init, cal_r32_val, cal_diff;
 	u8 saverfb5r00, saverfb5r01, saverfb5r03, saverfb5r04, saverfb5r05;
 	u8 saverfb5r06, saverfb5r07;
 	u8 saverfb5r08, saverfb5r17, saverfb5r18, saverfb5r19, saverfb5r20;
@@ -11550,9 +11550,9 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
 	struct channel_info *info;
-	char *default_power1;
-	char *default_power2;
-	char *default_power3;
+	s8 *default_power1;
+	s8 *default_power2;
+	s8 *default_power3;
 	unsigned int i, tx_chains, rx_chains;
 	u32 reg;
 
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
index 3cbef77b4bd3..194de676df8f 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
@@ -32,10 +32,10 @@ struct rf_reg_pair {
 struct rt2800_drv_data {
 	u8 calibration_bw20;
 	u8 calibration_bw40;
-	char rx_calibration_bw20;
-	char rx_calibration_bw40;
-	char tx_calibration_bw20;
-	char tx_calibration_bw40;
+	s8 rx_calibration_bw20;
+	s8 rx_calibration_bw40;
+	s8 tx_calibration_bw20;
+	s8 tx_calibration_bw40;
 	u8 bbp25;
 	u8 bbp26;
 	u8 txmixer_gain_24g;
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
index 0827bc860bf8..8fd22c69855f 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -117,12 +117,12 @@ int rt2x00usb_vendor_request_buff(struct rt2x00_dev *rt2x00dev,
 				  const u16 buffer_length)
 {
 	int status = 0;
-	unsigned char *tb;
+	u8 *tb;
 	u16 off, len, bsize;
 
 	mutex_lock(&rt2x00dev->csr_mutex);
 
-	tb  = (char *)buffer;
+	tb  = (u8 *)buffer;
 	off = offset;
 	len = buffer_length;
 	while (len && !status) {
@@ -215,7 +215,7 @@ void rt2x00usb_register_read_async(struct rt2x00_dev *rt2x00dev,
 	rd->cr.wLength = cpu_to_le16(sizeof(u32));
 
 	usb_fill_control_urb(urb, usb_dev, usb_rcvctrlpipe(usb_dev, 0),
-			     (unsigned char *)(&rd->cr), &rd->reg, sizeof(rd->reg),
+			     (u8 *)(&rd->cr), &rd->reg, sizeof(rd->reg),
 			     rt2x00usb_register_read_async_cb, rd);
 	usb_anchor_urb(urb, rt2x00dev->anchor);
 	if (usb_submit_urb(urb, GFP_ATOMIC) < 0) {
diff --git a/drivers/net/wireless/ralink/rt2x00/rt61pci.c b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
index d92f9eb07dc9..81db7f57c7e4 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
@@ -1709,7 +1709,7 @@ static int rt61pci_set_state(struct rt2x00_dev *rt2x00dev, enum dev_state state)
 {
 	u32 reg, reg2;
 	unsigned int i;
-	char put_to_sleep;
+	bool put_to_sleep;
 
 	put_to_sleep = (state != STATE_AWAKE);
 
@@ -2656,7 +2656,7 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
 	struct channel_info *info;
-	char *tx_power;
+	u8 *tx_power;
 	unsigned int i;
 
 	/*
diff --git a/drivers/net/wireless/ralink/rt2x00/rt61pci.h b/drivers/net/wireless/ralink/rt2x00/rt61pci.h
index 5f208ad509bd..d72d0ffd1127 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.h
@@ -1484,6 +1484,6 @@ struct hw_pairwise_ta_entry {
 	(((u8)(__txpower)) > MAX_TXPOWER) ? DEFAULT_TXPOWER : (__txpower)
 
 #define TXPOWER_TO_DEV(__txpower) \
-	clamp_t(char, __txpower, MIN_TXPOWER, MAX_TXPOWER)
+	clamp_t(u8, __txpower, MIN_TXPOWER, MAX_TXPOWER)
 
 #endif /* RT61PCI_H */
diff --git a/drivers/net/wireless/ralink/rt2x00/rt73usb.c b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
index e3269fd7c59e..861035444374 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
@@ -1378,7 +1378,7 @@ static int rt73usb_set_state(struct rt2x00_dev *rt2x00dev, enum dev_state state)
 {
 	u32 reg, reg2;
 	unsigned int i;
-	char put_to_sleep;
+	bool put_to_sleep;
 
 	put_to_sleep = (state != STATE_AWAKE);
 
@@ -2090,7 +2090,7 @@ static int rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 {
 	struct hw_mode_spec *spec = &rt2x00dev->spec;
 	struct channel_info *info;
-	char *tx_power;
+	u8 *tx_power;
 	unsigned int i;
 
 	/*
diff --git a/drivers/net/wireless/ralink/rt2x00/rt73usb.h b/drivers/net/wireless/ralink/rt2x00/rt73usb.h
index 1b56d285c34b..bb0a68516c08 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt73usb.h
@@ -1063,6 +1063,6 @@ struct hw_pairwise_ta_entry {
 	(((u8)(__txpower)) > MAX_TXPOWER) ? DEFAULT_TXPOWER : (__txpower)
 
 #define TXPOWER_TO_DEV(__txpower) \
-	clamp_t(char, __txpower, MIN_TXPOWER, MAX_TXPOWER)
+	clamp_t(u8, __txpower, MIN_TXPOWER, MAX_TXPOWER)
 
 #endif /* RT73USB_H */
-- 
2.38.1

