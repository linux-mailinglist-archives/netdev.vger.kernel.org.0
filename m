Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F1E6C437E
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 07:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjCVGrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 02:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjCVGqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 02:46:52 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F40322118
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 23:46:02 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 32M6jh1I3027857, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 32M6jh1I3027857
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Wed, 22 Mar 2023 14:45:43 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Wed, 22 Mar 2023 14:45:58 +0800
Received: from Test06-PC.realtek.com.tw (172.22.228.55) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Wed, 22 Mar 2023 14:45:57 +0800
From:   ChunHao Lin <hau@realtek.com>
To:     <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        ChunHao Lin <hau@realtek.com>
Subject: [PATCH net] r8169: fix rtl8168h rx crc error
Date:   Wed, 22 Mar 2023 14:45:50 +0800
Message-ID: <20230322064550.2378-1-hau@realtek.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.22.228.55]
X-ClientProxiedBy: RTEXH36505.realtek.com.tw (172.21.6.25) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When link speed is 10 Mbps and temperature is under -20°C, rtl8168h may
have rx crc error. Disable phy 10 Mbps pll off to fix this issue.

Signed-off-by: ChunHao Lin <hau@realtek.com>
---
 drivers/net/ethernet/realtek/r8169_phy_config.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
index 930496cd34ed..b50f16786c24 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -826,6 +826,9 @@ static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp,
 	/* disable phy pfm mode */
 	phy_modify_paged(phydev, 0x0a44, 0x11, BIT(7), 0);
 
+	/* disable 10m pll off */
+	phy_modify_paged(phydev, 0x0a43, 0x10, BIT(0), 0);
+
 	rtl8168g_disable_aldps(phydev);
 	rtl8168g_config_eee_phy(phydev);
 }
-- 
2.37.2

