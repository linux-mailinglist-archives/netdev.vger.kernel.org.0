Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49398DE2B1
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 05:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbfJUDlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 23:41:36 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:58989 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbfJUDlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 23:41:35 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x9L3fWOS014791, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x9L3fWOS014791
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Oct 2019 11:41:32 +0800
Received: from fc30.localdomain (172.21.177.156) by RTITCAS11.realtek.com.tw
 (172.21.6.12) with Microsoft SMTP Server id 14.3.468.0; Mon, 21 Oct 2019
 11:41:30 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <pmalani@chromium.org>, <grundler@chromium.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 3/4] r8152: move r8153_patch_request forward
Date:   Mon, 21 Oct 2019 11:41:12 +0800
Message-ID: <1394712342-15778-333-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-330-Taiwan-albertk@realtek.com>
References: <1394712342-15778-330-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.156]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move r8153_patch_request() forward for later patch.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 54 ++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 090ddd5fb973..ab57c672c4ca 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3397,6 +3397,33 @@ static void rtl_clear_bp(struct r8152 *tp, u16 type)
 	ocp_write_word(tp, type, PLA_BP_BA, 0);
 }
 
+static int r8153_patch_request(struct r8152 *tp, bool request)
+{
+	u16 data;
+	int i;
+
+	data = ocp_reg_read(tp, OCP_PHY_PATCH_CMD);
+	if (request)
+		data |= PATCH_REQUEST;
+	else
+		data &= ~PATCH_REQUEST;
+	ocp_reg_write(tp, OCP_PHY_PATCH_CMD, data);
+
+	for (i = 0; request && i < 5000; i++) {
+		usleep_range(1000, 2000);
+		if (ocp_reg_read(tp, OCP_PHY_PATCH_STAT) & PATCH_READY)
+			break;
+	}
+
+	if (request && !(ocp_reg_read(tp, OCP_PHY_PATCH_STAT) & PATCH_READY)) {
+		netif_err(tp, drv, tp->netdev, "patch request fail\n");
+		r8153_patch_request(tp, false);
+		return -ETIME;
+	} else {
+		return 0;
+	}
+}
+
 static bool rtl8152_is_fw_mac_ok(struct r8152 *tp, struct fw_mac *mac)
 {
 	u16 fw_reg, bp_ba_addr, bp_en_addr, bp_start, fw_offset;
@@ -4056,33 +4083,6 @@ static void r8152b_enter_oob(struct r8152 *tp)
 	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RCR, ocp_data);
 }
 
-static int r8153_patch_request(struct r8152 *tp, bool request)
-{
-	u16 data;
-	int i;
-
-	data = ocp_reg_read(tp, OCP_PHY_PATCH_CMD);
-	if (request)
-		data |= PATCH_REQUEST;
-	else
-		data &= ~PATCH_REQUEST;
-	ocp_reg_write(tp, OCP_PHY_PATCH_CMD, data);
-
-	for (i = 0; request && i < 5000; i++) {
-		usleep_range(1000, 2000);
-		if (ocp_reg_read(tp, OCP_PHY_PATCH_STAT) & PATCH_READY)
-			break;
-	}
-
-	if (request && !(ocp_reg_read(tp, OCP_PHY_PATCH_STAT) & PATCH_READY)) {
-		netif_err(tp, drv, tp->netdev, "patch request fail\n");
-		r8153_patch_request(tp, false);
-		return -ETIME;
-	} else {
-		return 0;
-	}
-}
-
 static int r8153_pre_firmware_1(struct r8152 *tp)
 {
 	int i;
-- 
2.21.0

