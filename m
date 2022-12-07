Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2501F645297
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 04:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiLGDkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 22:40:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLGDkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 22:40:05 -0500
Received: from pv50p00im-ztdg10011301.me.com (pv50p00im-ztdg10011301.me.com [17.58.6.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD2D3F069
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 19:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zzy040330.moe;
        s=sig1; t=1670384404;
        bh=y/PTeFvKI3R/45mNjjheKJznUTmIdrgmyPjaU+XzKIE=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=BGiF7x7FALu7Qn+JouzYs95iQVrXXNyDD19Rn+uA7Fpwq8y6SZCOaAmTLFgMTb2Ed
         OCBLr17ZMLWSx/yw+H7V4dSXA88hfsTPZTxYUn4mR/3KXHHSFaJ41zI+FDJ0ORpm9v
         uU+soFbD3GRZdT2/LKILJAHyfj6fQ93L0f+MUt4Ozhqzv7FjyPoyUtft0mM8zFmLVa
         5JG9BnDr6j8cK7x5gTb14tSEi/h514VNDju+nyanzUH/xvvRv8kAXt9qz4nYpdpFHa
         MKWMWlnkoKQsUThZM0G+l24J2W5FRMApqfdGcFVcBIKYIAXDiQh2hW/yPiwWpPYoXG
         QQW5xCBlOl8DQ==
Received: from localhost.localdomain (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10011301.me.com (Postfix) with ESMTPSA id EA74F18086D;
        Wed,  7 Dec 2022 03:39:58 +0000 (UTC)
From:   Jun ASAKA <JunASAKA@zzy040330.moe>
To:     Jes.Sorensen@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jun ASAKA <JunASAKA@zzy040330.moe>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH v5] wifi: rtl8xxxu: fixing IQK failures for rtl8192eu
Date:   Wed,  7 Dec 2022 11:39:26 +0800
Message-Id: <20221207033926.11777-1-JunASAKA@zzy040330.moe>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: iPizQ7t_-HRIIv_Iw63YMFsCvxBN7OH1
X-Proofpoint-ORIG-GUID: iPizQ7t_-HRIIv_Iw63YMFsCvxBN7OH1
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.517,18.0.572,17.11.64.514.0000000_definitions?=
 =?UTF-8?Q?=3D2022-06-21=5F01:2022-06-21=5F01,2020-02-14=5F11,2022-02-23?=
 =?UTF-8?Q?=5F01_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 mlxlogscore=887 clxscore=1030 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2212070025
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
the ones in the updated official driver as shown below.
1. https://github.com/Mange/rtl8192eu-linux-driver
2. vendor driver version: 5.6.4

Tested-by: Jun ASAKA <JunASAKA@zzy040330.moe>
Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
---
v5:
 - no modification.
v4:
 - fixed some mistakes.
v3:
 - add detailed info about the newer version this patch used.
 - no functional update.
---
---
 .../realtek/rtl8xxxu/rtl8xxxu_8192e.c         | 73 +++++++++++++------
 1 file changed, 51 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
index b06508d0cdf8..55da714ea24b 100644
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
@@ -891,9 +907,12 @@ static int rtl8192eu_iqk_path_b(struct rtl8xxxu_priv *priv)
 
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
 
 	/* Path B IQK setting */
@@ -902,11 +921,11 @@ static int rtl8192eu_iqk_path_b(struct rtl8xxxu_priv *priv)
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
@@ -942,11 +961,16 @@ static int rtl8192eu_rx_iqk_path_b(struct rtl8xxxu_priv *priv)
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
@@ -961,8 +985,8 @@ static int rtl8192eu_rx_iqk_path_b(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_B, 0x18008c1c);
 	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_B, 0x38008c1c);
 
-	rtl8xxxu_write32(priv, REG_TX_IQK_PI_B, 0x82160c1f);
-	rtl8xxxu_write32(priv, REG_RX_IQK_PI_B, 0x68160c1f);
+	rtl8xxxu_write32(priv, REG_TX_IQK_PI_B, 0x8216031f);
+	rtl8xxxu_write32(priv, REG_RX_IQK_PI_B, 0x6816031f);
 
 	/* LO calibration setting */
 	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x0046a911);
@@ -1002,11 +1026,16 @@ static int rtl8192eu_rx_iqk_path_b(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_WE_LUT, 0x800a0);
 	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_RCK_OS, 0x30000);
 	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G1, 0x0000f);
-	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G2, 0xf7ffa);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_TXPA_G2, 0xf7ff2);
+
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_WE_LUT, 0x800a0);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_RCK_OS, 0x30000);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G1, 0x0000f);
+	rtl8xxxu_write_rfreg(priv, RF_A, RF6052_REG_TXPA_G2, 0xf7ff2);
 
 	/* PA/PAD control by 0x56, and set = 0x0 */
 	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_DF, 0x00980);
-	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_56, 0x51000);
+	rtl8xxxu_write_rfreg(priv, RF_B, RF6052_REG_UNKNOWN_56, 0x510e0);
 
 	/* Enter IQK mode */
 	rtl8xxxu_write32(priv, REG_FPGA0_IQK, 0x80800000);
@@ -1020,8 +1049,8 @@ static int rtl8192eu_rx_iqk_path_b(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write32(priv, REG_TX_IQK_TONE_B, 0x38008c1c);
 	rtl8xxxu_write32(priv, REG_RX_IQK_TONE_B, 0x18008c1c);
 
-	rtl8xxxu_write32(priv, REG_TX_IQK_PI_A, 0x82160c1f);
-	rtl8xxxu_write32(priv, REG_RX_IQK_PI_A, 0x28160c1f);
+	rtl8xxxu_write32(priv, REG_TX_IQK_PI_A, 0x821608ff);
+	rtl8xxxu_write32(priv, REG_RX_IQK_PI_A, 0x281608ff);
 
 	/* LO calibration setting */
 	rtl8xxxu_write32(priv, REG_IQK_AGC_RSP, 0x0046a891);
-- 
2.31.1

