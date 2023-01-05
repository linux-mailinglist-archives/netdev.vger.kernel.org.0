Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E641D65F365
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 19:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234920AbjAESFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 13:05:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234696AbjAESEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 13:04:54 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 89CCA5D431
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 10:04:19 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 305I3HyT4024865, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 305I3HyT4024865
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Fri, 6 Jan 2023 02:03:17 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Fri, 6 Jan 2023 02:04:14 +0800
Received: from localhost.localdomain (172.21.182.190) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Fri, 6 Jan 2023 02:04:13 +0800
From:   Chunhao Lin <hau@realtek.com>
To:     <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        Chunhao Lin <hau@realtek.com>
Subject: [PATCH net] r8169: fix rtl8168h wol fail
Date:   Fri, 6 Jan 2023 02:04:08 +0800
Message-ID: <20230105180408.2998-1-hau@realtek.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.182.190]
X-ClientProxiedBy: RTEXH36505.realtek.com.tw (172.21.6.25) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: trusted connection
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 01/05/2023 17:35:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIzLzEvNSCkVaTIIDAzOjA1OjAw?=
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtl8168h has an application that it will connect to rtl8211fs through mdi
interface. And rtl8211fs will connect to fiber through serdes interface.
In this application, rtl8168h revision id will be set to 0x2a.

Because rtl8211fs's firmware will set link capability to 100M and GIGA
when link is from off to on. So when system suspend and wol is enabled,
rtl8168h will speed down to 100M (because rtl8211fs advertise 100M and GIGA
to rtl8168h). If the link speed between rtl81211fs and fiber is GIGA.
The link speed between rtl8168h and fiber will mismatch. That will cause
wol fail.

In this patch, if rtl8168h is in this kind of application, driver will not
speed down phy when wol is enabled.

Signed-off-by: Chunhao Lin <hau@realtek.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 24592d972523..83d017369ae7 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1199,6 +1199,12 @@ static enum rtl_dash_type rtl_check_dash(struct rtl8169_private *tp)
 	}
 }
 
+static bool rtl_mdi_connect_to_phy(struct rtl8169_private *tp)
+{
+	return tp->mac_version == RTL_GIGA_MAC_VER_46 &&
+		tp->pci_dev->revision == 0x2a;
+}
+
 static void rtl_set_d3_pll_down(struct rtl8169_private *tp, bool enable)
 {
 	switch (tp->mac_version) {
@@ -2453,7 +2459,8 @@ static void rtl_prepare_power_down(struct rtl8169_private *tp)
 		rtl_ephy_write(tp, 0x19, 0xff64);
 
 	if (device_may_wakeup(tp_to_dev(tp))) {
-		phy_speed_down(tp->phydev, false);
+		if (!rtl_mdi_connect_to_phy(tp))
+			phy_speed_down(tp->phydev, false);
 		rtl_wol_enable_rx(tp);
 	}
 }
-- 
2.39.0

