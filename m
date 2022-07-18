Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDDC577D62
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 10:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbiGRIW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 04:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiGRIW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 04:22:26 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 392D31900B;
        Mon, 18 Jul 2022 01:22:23 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 26I8M06K0013318, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 26I8M06K0013318
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Mon, 18 Jul 2022 16:22:00 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 18 Jul 2022 16:22:04 +0800
Received: from fc34.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.27; Mon, 18 Jul
 2022 16:22:04 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net] r8152: fix a WOL issue
Date:   Mon, 18 Jul 2022 16:21:20 +0800
Message-ID: <20220718082120.10957-391-nic_swsd@realtek.com>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXH36504.realtek.com.tw (172.21.6.27) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: trusted connection
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/18/2022 08:06:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzcvMTggpFekyCAwNjowMzowMA==?=
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes that the platform is waked by an unexpected packet. The
size and range of FIFO is different when the device enters S3 state,
so it is necessary to correct some settings when suspending.

Regardless of jumbo frame, set RMS to 1522 and MTPS to MTPS_DEFAULT.
Besides, enable MCU_BORW_EN to update the method of calculating the
pointer of data. Then, the hardware could get the correct data.

Fixes: 195aae321c82 ("r8152: support new chips")
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index b082819509e1..0f6efaabaa32 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -32,7 +32,7 @@
 #define NETNEXT_VERSION		"12"
 
 /* Information for net */
-#define NET_VERSION		"12"
+#define NET_VERSION		"13"
 
 #define DRIVER_VERSION		"v1." NETNEXT_VERSION "." NET_VERSION
 #define DRIVER_AUTHOR "Realtek linux nic maintainers <nic_swsd@realtek.com>"
@@ -5917,7 +5917,8 @@ static void r8153_enter_oob(struct r8152 *tp)
 
 	wait_oob_link_list_ready(tp);
 
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, mtu_to_size(tp->netdev->mtu));
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, 1522);
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_MTPS, MTPS_DEFAULT);
 
 	switch (tp->version) {
 	case RTL_VER_03:
@@ -5953,6 +5954,10 @@ static void r8153_enter_oob(struct r8152 *tp)
 	ocp_data |= NOW_IS_OOB | DIS_MCU_CLROOB;
 	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
 
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
+	ocp_data |= MCU_BORW_EN;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
+
 	rxdy_gated_en(tp, false);
 
 	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_RCR);
@@ -6555,6 +6560,9 @@ static void rtl8156_down(struct r8152 *tp)
 	rtl_disable(tp);
 	rtl_reset_bmu(tp);
 
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, 1522);
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_MTPS, MTPS_DEFAULT);
+
 	/* Clear teredo wake event. bit[15:8] is the teredo wakeup
 	 * type. Set it to zero. bits[7:0] are the W1C bits about
 	 * the events. Set them to all 1 to clear them.
@@ -6565,6 +6573,10 @@ static void rtl8156_down(struct r8152 *tp)
 	ocp_data |= NOW_IS_OOB;
 	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
 
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
+	ocp_data |= MCU_BORW_EN;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
+
 	rtl_rx_vlan_en(tp, true);
 	rxdy_gated_en(tp, false);
 
-- 
2.34.3

