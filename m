Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA6F6DE2B0
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 05:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfJUDle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 23:41:34 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:58986 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbfJUDld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 23:41:33 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x9L3fUoi014787, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x9L3fUoi014787
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Oct 2019 11:41:30 +0800
Received: from fc30.localdomain (172.21.177.156) by RTITCAS11.realtek.com.tw
 (172.21.6.12) with Microsoft SMTP Server id 14.3.468.0; Mon, 21 Oct 2019
 11:41:28 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <pmalani@chromium.org>, <grundler@chromium.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 2/4] r8152: add checking fw_offset field of struct fw_mac
Date:   Mon, 21 Oct 2019 11:41:11 +0800
Message-ID: <1394712342-15778-332-Taiwan-albertk@realtek.com>
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

Make sure @fw_offset field of struct fw_mac is more than the size
of struct fw_mac.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 55a7674a0c06..090ddd5fb973 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3399,7 +3399,7 @@ static void rtl_clear_bp(struct r8152 *tp, u16 type)
 
 static bool rtl8152_is_fw_mac_ok(struct r8152 *tp, struct fw_mac *mac)
 {
-	u16 fw_reg, bp_ba_addr, bp_en_addr, bp_start;
+	u16 fw_reg, bp_ba_addr, bp_en_addr, bp_start, fw_offset;
 	bool rc = false;
 	u32 length, type;
 	int i, max_bp;
@@ -3461,13 +3461,19 @@ static bool rtl8152_is_fw_mac_ok(struct r8152 *tp, struct fw_mac *mac)
 		goto out;
 	}
 
+	fw_offset = __le16_to_cpu(mac->fw_offset);
+	if (fw_offset < sizeof(*mac)) {
+		dev_err(&tp->intf->dev, "fw_offset too small\n");
+		goto out;
+	}
+
 	length = __le32_to_cpu(mac->blk_hdr.length);
-	if (length < __le16_to_cpu(mac->fw_offset)) {
+	if (length < fw_offset) {
 		dev_err(&tp->intf->dev, "invalid fw_offset\n");
 		goto out;
 	}
 
-	length -= __le16_to_cpu(mac->fw_offset);
+	length -= fw_offset;
 	if (length < 4 || (length & 3)) {
 		dev_err(&tp->intf->dev, "invalid block length\n");
 		goto out;
-- 
2.21.0

