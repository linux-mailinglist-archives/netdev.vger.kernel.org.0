Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 442C763D7D2
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 15:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiK3OLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 09:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiK3OL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 09:11:27 -0500
Received: from pv50p00im-ztdg10021201.me.com (pv50p00im-ztdg10021201.me.com [17.58.6.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F3781D84
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 06:09:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zzy040330.moe;
        s=sig1; t=1669817352;
        bh=fCzooQMJwRO5ac8K1KpkBuVy8Jp59r3M74rKZ9Q3SGo=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=FmE/l14c2fanQQ8FfomWX8MlvycUHd3QxuWnk9PKK2KAQTz5Hd4Bihi8HFCojukub
         exPT4KHVB7Epnd3eAThf49Mzi+cWTjkAKcgF+u41WCWofHV7PBFNnsp9RIvCh7wmli
         o5T+7X+vvYnVSenJZECHxYiTUUZL2djSWkA/XTE4le/hRuBDsF60CZ+68ufFRASvby
         wU/SdBgA+tvD2eT6uHeIhhmeuVGIsqbP62OpgfZ33QH4c8i/9GvCezDVB/z9EqhE5w
         eXW4hy5VcKvwsTIibLhmlXXg+snUQXacD79S4lM6a8l3BxAlvfsroSbw6yu81Z10DD
         qxycwqwy8gTtA==
Received: from vanilla.. (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10021201.me.com (Postfix) with ESMTPSA id 913366806AE;
        Wed, 30 Nov 2022 14:09:08 +0000 (UTC)
From:   JunASAKA <JunASAKA@zzy040330.moe>
To:     Jes.Sorensen@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        JunASAKA <JunASAKA@zzy040330.moe>
Subject: [PATCH] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
Date:   Wed, 30 Nov 2022 22:08:49 +0800
Message-Id: <20221130140849.153705-1-JunASAKA@zzy040330.moe>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: qShzc4VapBIvO-AL8wVh_HTz1KxSF-gz
X-Proofpoint-GUID: qShzc4VapBIvO-AL8wVh_HTz1KxSF-gz
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.138,18.0.572,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2020-02-14=5F11:2020-02-14=5F02,2020-02-14=5F11,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 clxscore=1030
 bulkscore=0 mlxlogscore=721 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2211300099
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixing "Path A RX IQK failed" and "Path B RX IQK failed"
issues for rtl8192eu chips by replacing the arguments with
the ones in the updated official driver.

Signed-off-by: JunASAKA <JunASAKA@zzy040330.moe>
---
 .../realtek/rtl8xxxu/rtl8xxxu_8192e.c         | 76 +++++++++++++------
 1 file changed, 54 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
index b06508d0cd..82346500f2 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
@@ -734,6 +734,12 @@ static int rtl8192eu_iqk_path_a(struct rtl8xxxu_priv *priv)
 	 */
 	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
 	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_DF, 0x00180);
+
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_WE_LUT, 0x800a0);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_RCK_OS, 0x20000);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G1, 0x0000f);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G2, 0x07f77);
+
 	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
 
 	/* Path A IQK setting */
@@ -779,11 +785,16 @@ static int rtl8192eu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_WE_LUT, 0x800a0);
 	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_RCK_OS, 0x30000);
 	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G1, 0x0000f);
-	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G2, 0xf117b);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G2, 0xf1173);
+
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_WE_LUT, 0x800a0);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_RCK_OS, 0x30000);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G1, 0x0000f);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G2, 0xf1173);
 
 	/* PA/PAD control by 0x56, and set = 0x0 */
 	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_DF, 0x00980);
-	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_56, 0x51000);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_56, 0x511e0);
 
 	/* Enter IQK mode */
 	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
@@ -798,14 +809,14 @@ static int rtl8192eu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_B, 0x38008c1c);
 	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_B, 0x38008c1c);
 
-	rtl8xxxu_write32(priv, REG_TX_IQK_PI_A, 0x82160c1f);
-	rtl8xxxu_write32(priv, REG_RX_IQK_PI_A, 0x68160c1f);
+	rtl8xxxu_write32(priv, REG_TX_IQK_PI_A, 0x8216031f);
+	rtl8xxxu_write32(priv, REG_RX_IQK_PI_A, 0x6816031f);
 
 	/* LO calibration setting */
 	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x0046a911);
 
 	/* One shot, path A LOK & IQK */
-	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xfa000000);
+	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xf9000000);
 	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xf8000000);
 
 	mdelay(10);
@@ -836,11 +847,16 @@ static int rtl8192eu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_WE_LUT, 0x800a0);
 	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_RCK_OS, 0x30000);
 	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G1, 0x0000f);
-	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G2, 0xf7ffa);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G2, 0xf7ff2);
+
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_WE_LUT, 0x800a0);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_RCK_OS, 0x30000);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G1, 0x0000f);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G2, 0xf7ff2);
 
 	/* PA/PAD control by 0x56, and set = 0x0 */
 	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_DF, 0x00980);
-	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_56, 0x51000);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_UNKNOWN_56, 0x510e0);
 
 	/* Enter IQK mode */
 	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
@@ -854,14 +870,14 @@ static int rtl8192eu_rx_iqk_path_a(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_B, 0x38008c1c);
 	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_B, 0x38008c1c);
 
-	rtl8xxxu_write32(priv, REG_TX_IQK_PI_A, 0x82160c1f);
-	rtl8xxxu_write32(priv, REG_RX_IQK_PI_A, 0x28160c1f);
+	rtl8xxxu_write32(priv, REG_TX_IQK_PI_A, 0x821608ff);
+	rtl8xxxu_write32(priv, REG_RX_IQK_PI_A, 0x281608ff);
 
 	/* LO calibration setting */
 	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x0046a891);
 
 	/* One shot, path A LOK & IQK */
-	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xfa000000);
+	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xf9000000);
 	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xf8000000);
 
 	mdelay(10);
@@ -891,22 +907,28 @@ static int rtl8192eu_iqk_path_b(struct rtl8xxxu_priv *priv)
 
 	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
 	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_DF, 0x00180);
-	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
 
-	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_WE_LUT, 0x800a0);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_RCK_OS, 0x20000);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G1, 0x0000f);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G2, 0x07f77);
+
 	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
 
+	// rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x00000000);
+	// rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
+
 	/* Path B IQK setting */
 	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_A, 0x38008c1c);
 	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_A, 0x38008c1c);
 	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_B, 0x18008c1c);
 	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_B, 0x38008c1c);
 
-	rtl8xxxu_write32(priv, REG_TX_IQK_PI_B, 0x821403e2);
+	rtl8xxxu_write32(priv, REG_TX_IQK_PI_B, 0x82140303);
 	rtl8xxxu_write32(priv, REG_RX_IQK_PI_B, 0x68160000);
 
 	/* LO calibration setting */
-	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x00492911);
+	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x00462911);
 
 	/* One shot, path A LOK & IQK */
 	rtl8xxxu_write32(priv, REG_IQK_AGC_PTS, 0xfa000000);
@@ -942,11 +964,16 @@ static int rtl8192eu_rx_iqk_path_b(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_WE_LUT, 0x800a0);
 	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_RCK_OS, 0x30000);
 	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G1, 0x0000f);
-	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G2, 0xf117b);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G2, 0xf1173);
+
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_WE_LUT, 0x800a0);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_RCK_OS, 0x30000);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G1, 0x0000f);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G2, 0xf1173);
 
 	/* PA/PAD control by 0x56, and set = 0x0 */
 	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_DF, 0x00980);
-	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_56, 0x51000);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_56, 0x511e0);
 
 	/* Enter IQK mode */
 	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
@@ -961,8 +988,8 @@ static int rtl8192eu_rx_iqk_path_b(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_B, 0x18008c1c);
 	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_B, 0x38008c1c);
 
-	rtl8xxxu_write32(priv, REG_TX_IQK_PI_B, 0x82160c1f);
-	rtl8xxxu_write32(priv, REG_RX_IQK_PI_B, 0x68160c1f);
+	rtl8xxxu_write32(priv, REG_TX_IQK_PI_B, 0x8216031f);
+	rtl8xxxu_write32(priv, REG_RX_IQK_PI_B, 0x6816031f);
 
 	/* LO calibration setting */
 	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x0046a911);
@@ -1002,11 +1029,16 @@ static int rtl8192eu_rx_iqk_path_b(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_WE_LUT, 0x800a0);
 	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_RCK_OS, 0x30000);
 	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G1, 0x0000f);
-	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G2, 0xf7ffa);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G2, 0xf7ff2);
+
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_WE_LUT, 0x800a0);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_RCK_OS, 0x30000);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G1, 0x0000f);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G2, 0xf7ff2);
 
 	/* PA/PAD control by 0x56, and set = 0x0 */
 	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_DF, 0x00980);
-	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_56, 0x51000);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_56, 0x510e0);
 
 	/* Enter IQK mode */
 	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
@@ -1020,8 +1052,8 @@ static int rtl8192eu_rx_iqk_path_b(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_B, 0x38008c1c);
 	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_B, 0x18008c1c);
 
-	rtl8xxxu_write32(priv, REG_TX_IQK_PI_A, 0x82160c1f);
-	rtl8xxxu_write32(priv, REG_RX_IQK_PI_A, 0x28160c1f);
+	rtl8xxxu_write32(priv, REG_TX_IQK_PI_A, 0x821608ff);
+	rtl8xxxu_write32(priv, REG_RX_IQK_PI_A, 0x281608ff);
 
 	/* LO calibration setting */
 	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x0046a891);
-- 
2.38.1

