Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201F3432B6C
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 03:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhJSBSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 21:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbhJSBSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 21:18:41 -0400
X-Greylist: delayed 946 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 18 Oct 2021 18:16:29 PDT
Received: from mxout017.mail.hostpoint.ch (mxout017.mail.hostpoint.ch [IPv6:2a00:d70:0:e::317])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89248C06161C;
        Mon, 18 Oct 2021 18:16:29 -0700 (PDT)
Received: from [10.0.2.44] (helo=asmtp014.mail.hostpoint.ch)
        by mxout017.mail.hostpoint.ch with esmtp (Exim 4.94.2 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1mcdUc-00081f-7G; Tue, 19 Oct 2021 03:00:38 +0200
Received: from dynamic-145-014-211-090.glattnet.ch ([145.14.211.90] helo=eleanor.glattnet.ch)
        by asmtp014.mail.hostpoint.ch with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1mcdUc-000Fvn-4s; Tue, 19 Oct 2021 03:00:38 +0200
X-Authenticated-Sender-Id: reto-schneider@reto-schneider.ch
From:   Reto Schneider <code@reto-schneider.ch>
To:     linux-wireless@vger.kernel.org, chris.chiu@canonical.com,
        Jes.Sorensen@gmail.com, pkshih@realtek.com
Cc:     code@reto-schneider.ch, Larry.Finger@lwfinger.net,
        Reto Schneider <reto.schneider@husqvarnagroup.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC PATCH] rtl8xxxu: rtl8188cus: Fix init of PHY registers
Date:   Tue, 19 Oct 2021 02:59:27 +0200
Message-Id: <20211019005927.4075251-1-code@reto-schneider.ch>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Reto Schneider <reto.schneider@husqvarnagroup.com>

Use dedicated PHY register initialization table for RTL8188CUS devices
(1T1R) as the values stored in the rtl8723a_phy_1t_init_table array
slightly differ from the ones in the vendor drivers (8192cu, rtl8192u):

Offset | Name (REG_...)         | rtl8xxxu/8723a | [rtl]8192cu | XOR
-------+------------------------+----------------+-------------+-----------
0x024  | AFE_XTAL_CTRL          | missing        | 0x0011800f  | unknown
0x028  | AFE_PLL_CTRL           | missing        | 0x00ffdb83  | unknown
0x804  | FPGA0_TX_INFO          | 0x00000003     | 0x00000001  | 0x00000002
0x810  | FPGA0_RF_TIMING1       | 0x10001331     | 0x10000330  | 0x00001001
0x860  | FPGA0_XA_RF_INT_OE     | 0x66f60110     | 0x66e60230  | 0x00100320
0x870  | FPGA0_XA[B]_RF_SW_CTRL | 0x07000760     | 0x07000700  | 0x00000060
0xa78  | unknown                | 0x00000900     | missing     | unknown
0xc34  | OFDM0_RX_DETECTOR_2    | 0x469652af     | 0x469652cf  | 0x00000060
0xc64  | OFDM0_XC_AGC_CORE2     | 0x7112848b     | 0x5116848b  | 0x20040000
0xd00  | OFDM1_LSTF             | 0x00080740     | 0x00000740  | 0x00080000

The meaning of those values are unknown to me, except maybe for
FPGA0_TX_INFO, which refers to (only) path A (8192cu) instead of A and B
(rtl8xxxu/8723a).

Sadly, my benchmarks have not show any changes regarding throughput or
number of retransmissions on my RTL8188CUS based device.

Does anyone know how to interpret those register/values and whether the
changes done are actually an improvement?

Signed-off-by: Reto Schneider <reto.schneider@husqvarnagroup.com>
---

 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 103 +++++++++++++++++-
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h |   2 +
 2 files changed, 104 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 0d374a294840..2130ad1da0e2 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -152,6 +152,104 @@ struct rtl8xxxu_reg8val rtl8xxxu_gen1_mac_init_table[] = {
 	{0x70a, 0x65}, {0x70b, 0x87}, {0xffff, 0xff},
 };
 
+static struct rtl8xxxu_reg32val rtl8188cu_phy_1t_init_table[] = {
+	{0x024, 0x0011800f}, {0x028, 0x00ffdb83},
+	{0x800, 0x80040000}, {0x804, 0x00000001},
+	{0x808, 0x0000fc00}, {0x80c, 0x0000000a},
+	{0x810, 0x10000330}, {0x814, 0x020c3d10},
+	{0x818, 0x02200385}, {0x81c, 0x00000000},
+	{0x820, 0x01000100}, {0x824, 0x00390004},
+	{0x828, 0x00000000}, {0x82c, 0x00000000},
+	{0x830, 0x00000000}, {0x834, 0x00000000},
+	{0x838, 0x00000000}, {0x83c, 0x00000000},
+	{0x840, 0x00010000}, {0x844, 0x00000000},
+	{0x848, 0x00000000}, {0x84c, 0x00000000},
+	{0x850, 0x00000000}, {0x854, 0x00000000},
+	{0x858, 0x569a569a}, {0x85c, 0x001b25a4},
+	{0x860, 0x66e60230}, {0x864, 0x061f0130},
+	{0x868, 0x00000000}, {0x86c, 0x32323200},
+	{0x870, 0x07000700}, {0x874, 0x22004000},
+	{0x878, 0x00000808}, {0x87c, 0x00000000},
+	{0x880, 0xc0083070}, {0x884, 0x000004d5},
+	{0x888, 0x00000000}, {0x88c, 0xccc000c0},
+	{0x890, 0x00000800}, {0x894, 0xfffffffe},
+	{0x898, 0x40302010}, {0x89c, 0x00706050},
+	{0x900, 0x00000000}, {0x904, 0x00000023},
+	{0x908, 0x00000000}, {0x90c, 0x81121111},
+	{0xa00, 0x00d047c8}, {0xa04, 0x80ff000c},
+	{0xa08, 0x8c838300}, {0xa0c, 0x2e68120f},
+	{0xa10, 0x9500bb78}, {0xa14, 0x11144028},
+	{0xa18, 0x00881117}, {0xa1c, 0x89140f00},
+	{0xa20, 0x1a1b0000}, {0xa24, 0x090e1317},
+	{0xa28, 0x00000204}, {0xa2c, 0x00d30000},
+	{0xa70, 0x101fbf00}, {0xa74, 0x00000007},
+	{0xc00, 0x48071d40}, {0xc04, 0x03a05611},
+	{0xc08, 0x000000e4}, {0xc0c, 0x6c6c6c6c},
+	{0xc10, 0x08800000}, {0xc14, 0x40000100},
+	{0xc18, 0x08800000}, {0xc1c, 0x40000100},
+	{0xc20, 0x00000000}, {0xc24, 0x00000000},
+	{0xc28, 0x00000000}, {0xc2c, 0x00000000},
+	{0xc30, 0x69e9ac44}, {0xc34, 0x469652cf},
+	{0xc38, 0x49795994}, {0xc3c, 0x0a97971c},
+	{0xc40, 0x1f7c403f}, {0xc44, 0x000100b7},
+	{0xc48, 0xec020107}, {0xc4c, 0x007f037f},
+	{0xc50, 0x69543420}, {0xc54, 0x43bc0094},
+	{0xc58, 0x69543420}, {0xc5c, 0x433c0094},
+	{0xc60, 0x00000000}, {0xc64, 0x5116848b},
+	{0xc68, 0x47c00bff}, {0xc6c, 0x00000036},
+	{0xc70, 0x2c7f000d}, {0xc74, 0x018610db},
+	{0xc78, 0x0000001f}, {0xc7c, 0x00b91612},
+	{0xc80, 0x40000100}, {0xc84, 0x20f60000},
+	{0xc88, 0x40000100}, {0xc8c, 0x20200000},
+	{0xc90, 0x00121820}, {0xc94, 0x00000000},
+	{0xc98, 0x00121820}, {0xc9c, 0x00007f7f},
+	{0xca0, 0x00000000}, {0xca4, 0x00000080},
+	{0xca8, 0x00000000}, {0xcac, 0x00000000},
+	{0xcb0, 0x00000000}, {0xcb4, 0x00000000},
+	{0xcb8, 0x00000000}, {0xcbc, 0x28000000},
+	{0xcc0, 0x00000000}, {0xcc4, 0x00000000},
+	{0xcc8, 0x00000000}, {0xccc, 0x00000000},
+	{0xcd0, 0x00000000}, {0xcd4, 0x00000000},
+	{0xcd8, 0x64b22427}, {0xcdc, 0x00766932},
+	{0xce0, 0x00222222}, {0xce4, 0x00000000},
+	{0xce8, 0x37644302}, {0xcec, 0x2f97d40c},
+	{0xd00, 0x00000740}, {0xd04, 0x00020401},
+	{0xd08, 0x0000907f}, {0xd0c, 0x20010201},
+	{0xd10, 0xa0633333}, {0xd14, 0x3333bc43},
+	{0xd18, 0x7a8f5b6b}, {0xd2c, 0xcc979975},
+	{0xd30, 0x00000000}, {0xd34, 0x80608000},
+	{0xd38, 0x00000000}, {0xd3c, 0x00027293},
+	{0xd40, 0x00000000}, {0xd44, 0x00000000},
+	{0xd48, 0x00000000}, {0xd4c, 0x00000000},
+	{0xd50, 0x6437140a}, {0xd54, 0x00000000},
+	{0xd58, 0x00000000}, {0xd5c, 0x30032064},
+	{0xd60, 0x4653de68}, {0xd64, 0x04518a3c},
+	{0xd68, 0x00002101}, {0xd6c, 0x2a201c16},
+	{0xd70, 0x1812362e}, {0xd74, 0x322c2220},
+	{0xd78, 0x000e3c24}, {0xe00, 0x2a2a2a2a},
+	{0xe04, 0x2a2a2a2a}, {0xe08, 0x03902a2a},
+	{0xe10, 0x2a2a2a2a}, {0xe14, 0x2a2a2a2a},
+	{0xe18, 0x2a2a2a2a}, {0xe1c, 0x2a2a2a2a},
+	{0xe28, 0x00000000}, {0xe30, 0x1000dc1f},
+	{0xe34, 0x10008c1f}, {0xe38, 0x02140102},
+	{0xe3c, 0x681604c2}, {0xe40, 0x01007c00},
+	{0xe44, 0x01004800}, {0xe48, 0xfb000000},
+	{0xe4c, 0x000028d1}, {0xe50, 0x1000dc1f},
+	{0xe54, 0x10008c1f}, {0xe58, 0x02140102},
+	{0xe5c, 0x28160d05}, {0xe60, 0x00000008},
+	{0xe68, 0x001b25a4}, {0xe6c, 0x631b25a0},
+	{0xe70, 0x631b25a0}, {0xe74, 0x081b25a0},
+	{0xe78, 0x081b25a0}, {0xe7c, 0x081b25a0},
+	{0xe80, 0x081b25a0}, {0xe84, 0x631b25a0},
+	{0xe88, 0x081b25a0}, {0xe8c, 0x631b25a0},
+	{0xed0, 0x631b25a0}, {0xed4, 0x631b25a0},
+	{0xed8, 0x631b25a0}, {0xedc, 0x001b25a0},
+	{0xee0, 0x001b25a0}, {0xeec, 0x6b1b25a0},
+	{0xf14, 0x00000003}, {0xf4c, 0x00000000},
+	{0xf00, 0x00000300},
+	{0xffff, 0xffffffff},
+};
+
 static struct rtl8xxxu_reg32val rtl8723a_phy_1t_init_table[] = {
 	{0x800, 0x80040000}, {0x804, 0x00000003},
 	{0x808, 0x0000fc00}, {0x80c, 0x0000000a},
@@ -2227,6 +2325,8 @@ void rtl8xxxu_gen1_init_phy_bb(struct rtl8xxxu_priv *priv)
 		rtl8xxxu_init_phy_regs(priv, rtl8188ru_phy_1t_highpa_table);
 	else if (priv->tx_paths == 2)
 		rtl8xxxu_init_phy_regs(priv, rtl8192cu_phy_2t_init_table);
+	else if (priv->rtl_chip == RTL8188C)
+		rtl8xxxu_init_phy_regs(priv, rtl8188cu_phy_1t_init_table);
 	else
 		rtl8xxxu_init_phy_regs(priv, rtl8723a_phy_1t_init_table);
 
@@ -3949,7 +4049,8 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		goto exit;
 
 	/* RFSW Control - clear bit 14 ?? */
-	if (priv->rtl_chip != RTL8723B && priv->rtl_chip != RTL8192E)
+	if (priv->rtl_chip != RTL8723B && priv->rtl_chip != RTL8192E &&
+	    priv->rtl_chip != RTL8188C)
 		rtl8xxxu_write32(priv, REG_FPGA0_TX_INFO, 0x00000003);
 
 	val32 = FPGA0_RF_TRSW | FPGA0_RF_TRSWB | FPGA0_RF_ANTSW |
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index a2a31f374a82..0556c05afdbd 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -966,6 +966,8 @@
 #define REG_OFDM0_XA_RX_IQ_IMBALANCE	0x0c14
 #define REG_OFDM0_XB_RX_IQ_IMBALANCE	0x0c1c
 
+#define REG_OFDM0_RX_DETECTOR_2		0x0c34
+
 #define REG_OFDM0_ENERGY_CCA_THRES	0x0c4c
 
 #define REG_OFDM0_RX_D_SYNC_PATH	0x0c40
-- 
2.30.2

