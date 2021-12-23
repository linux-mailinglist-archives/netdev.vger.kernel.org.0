Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF3747E0DB
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 10:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347475AbhLWJ2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 04:28:39 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:54650 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347461AbhLWJ2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 04:28:38 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1BN9SUJJ0024154, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1BN9SUJJ0024154
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Dec 2021 17:28:30 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 23 Dec 2021 17:28:30 +0800
Received: from fc34.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Thu, 23 Dec
 2021 17:28:29 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net 2/2] r8152: sync ocp base
Date:   Thu, 23 Dec 2021 17:27:02 +0800
Message-ID: <20211223092702.23841-388-nic_swsd@realtek.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211223092702.23841-386-nic_swsd@realtek.com>
References: <20211223092702.23841-386-nic_swsd@realtek.com>
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
X-KSE-Antiphishing-Bases: 12/23/2021 09:07:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzEyLzIzIKRXpMggMDc6MTU6MDA=?=
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some chances that the actual base of hardware is different
from the value recorded by driver, so we have to reset the variable
of ocp_base to sync it.

Set ocp_base to -1. Then, it would be updated and the new base would be
set to the hardware next time.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index a817dfd5c9eb..3085e8118d7f 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -32,7 +32,7 @@
 #define NETNEXT_VERSION		"12"
 
 /* Information for net */
-#define NET_VERSION		"11"
+#define NET_VERSION		"12"
 
 #define DRIVER_VERSION		"v1." NETNEXT_VERSION "." NET_VERSION
 #define DRIVER_AUTHOR "Realtek linux nic maintainers <nic_swsd@realtek.com>"
@@ -4016,6 +4016,11 @@ static void rtl_clear_bp(struct r8152 *tp, u16 type)
 	ocp_write_word(tp, type, PLA_BP_BA, 0);
 }
 
+static inline void rtl_reset_ocp_base(struct r8152 *tp)
+{
+	tp->ocp_base = -1;
+}
+
 static int rtl_phy_patch_request(struct r8152 *tp, bool request, bool wait)
 {
 	u16 data, check;
@@ -4087,8 +4092,6 @@ static int rtl_post_ram_code(struct r8152 *tp, u16 key_addr, bool wait)
 
 	rtl_phy_patch_request(tp, false, wait);
 
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_OCP_GPHY_BASE, tp->ocp_base);
-
 	return 0;
 }
 
@@ -4800,6 +4803,8 @@ static void rtl_ram_code_speed_up(struct r8152 *tp, struct fw_phy_speed_up *phy,
 	u32 len;
 	u8 *data;
 
+	rtl_reset_ocp_base(tp);
+
 	if (sram_read(tp, SRAM_GPHY_FW_VER) >= __le16_to_cpu(phy->version)) {
 		dev_dbg(&tp->intf->dev, "PHY firmware has been the newest\n");
 		return;
@@ -4845,7 +4850,8 @@ static void rtl_ram_code_speed_up(struct r8152 *tp, struct fw_phy_speed_up *phy,
 		}
 	}
 
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_OCP_GPHY_BASE, tp->ocp_base);
+	rtl_reset_ocp_base(tp);
+
 	rtl_phy_patch_request(tp, false, wait);
 
 	if (sram_read(tp, SRAM_GPHY_FW_VER) == __le16_to_cpu(phy->version))
@@ -4861,6 +4867,8 @@ static int rtl8152_fw_phy_ver(struct r8152 *tp, struct fw_phy_ver *phy_ver)
 	ver_addr = __le16_to_cpu(phy_ver->ver.addr);
 	ver = __le16_to_cpu(phy_ver->ver.data);
 
+	rtl_reset_ocp_base(tp);
+
 	if (sram_read(tp, ver_addr) >= ver) {
 		dev_dbg(&tp->intf->dev, "PHY firmware has been the newest\n");
 		return 0;
@@ -4877,6 +4885,8 @@ static void rtl8152_fw_phy_fixup(struct r8152 *tp, struct fw_phy_fixup *fix)
 {
 	u16 addr, data;
 
+	rtl_reset_ocp_base(tp);
+
 	addr = __le16_to_cpu(fix->setting.addr);
 	data = ocp_reg_read(tp, addr);
 
@@ -4908,6 +4918,8 @@ static void rtl8152_fw_phy_union_apply(struct r8152 *tp, struct fw_phy_union *ph
 	u32 length;
 	int i, num;
 
+	rtl_reset_ocp_base(tp);
+
 	num = phy->pre_num;
 	for (i = 0; i < num; i++)
 		sram_write(tp, __le16_to_cpu(phy->pre_set[i].addr),
@@ -4938,6 +4950,8 @@ static void rtl8152_fw_phy_nc_apply(struct r8152 *tp, struct fw_phy_nc *phy)
 	u32 length, i, num;
 	__le16 *data;
 
+	rtl_reset_ocp_base(tp);
+
 	mode_reg = __le16_to_cpu(phy->mode_reg);
 	sram_write(tp, mode_reg, __le16_to_cpu(phy->mode_pre));
 	sram_write(tp, __le16_to_cpu(phy->ba_reg),
@@ -5107,6 +5121,7 @@ static void rtl8152_apply_firmware(struct r8152 *tp, bool power_cut)
 	if (rtl_fw->post_fw)
 		rtl_fw->post_fw(tp);
 
+	rtl_reset_ocp_base(tp);
 	strscpy(rtl_fw->version, fw_hdr->version, RTL_VER_SIZE);
 	dev_info(&tp->intf->dev, "load %s successfully\n", rtl_fw->version);
 }
@@ -8484,6 +8499,8 @@ static int rtl8152_resume(struct usb_interface *intf)
 
 	mutex_lock(&tp->control);
 
+	rtl_reset_ocp_base(tp);
+
 	if (test_bit(SELECTIVE_SUSPEND, &tp->flags))
 		ret = rtl8152_runtime_resume(tp);
 	else
@@ -8499,6 +8516,7 @@ static int rtl8152_reset_resume(struct usb_interface *intf)
 	struct r8152 *tp = usb_get_intfdata(intf);
 
 	clear_bit(SELECTIVE_SUSPEND, &tp->flags);
+	rtl_reset_ocp_base(tp);
 	tp->rtl_ops.init(tp);
 	queue_delayed_work(system_long_wq, &tp->hw_phy_work, 0);
 	set_ethernet_addr(tp, true);
-- 
2.31.1

