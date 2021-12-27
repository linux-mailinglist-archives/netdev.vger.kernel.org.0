Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90FEF4803C7
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 20:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232521AbhL0TFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 14:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbhL0TE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 14:04:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED70C06175D;
        Mon, 27 Dec 2021 11:04:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CF286116B;
        Mon, 27 Dec 2021 19:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B341C36AEA;
        Mon, 27 Dec 2021 19:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640631891;
        bh=+7H5eZJCDe3NH+ffhdwEMy19zYd1lc/X5xD3j3uQGCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JdM87Eukcyd0ngIb18qAwUWbBkRNzfZ2kwUQOSKg44CN03o8xr2ruDl2jXdRPOrWg
         vCp4L3O95lnpKDwbCHC420K6qt5ffQyNJjf2QP87mDIPecasblEbPbpt9TDbWirfkY
         ymQFT/KsyF3LHAawMh6ce0twLGsk9HPW1eVBcOF2CrcUwnNu1+yuQtIRzGDE2eGLX4
         qQZHR0gUQIEU6HV6aeCNt5P5pal7CcD7Ag7SArbkkqwsned323AgZYBRYOrCS2lP7p
         lCJYdDy831l39Fmnc5O6QLC8XAPcbbIjVSE+h7KszNGan6ePf1AnpoI89Nodn2XaPT
         54/xAkg0LO3rQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hayes Wang <hayeswang@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        tiwai@suse.de, linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 26/26] r8152: sync ocp base
Date:   Mon, 27 Dec 2021 14:03:27 -0500
Message-Id: <20211227190327.1042326-26-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190327.1042326-1-sashal@kernel.org>
References: <20211227190327.1042326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>

[ Upstream commit b24edca309535c2d9af86aab95d64065f6ef1d26 ]

There are some chances that the actual base of hardware is different
from the value recorded by driver, so we have to reset the variable
of ocp_base to sync it.

Set ocp_base to -1. Then, it would be updated and the new base would be
set to the hardware next time.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index d3da350777a4d..6c4c9b7324fcc 100644
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
@@ -8467,6 +8482,8 @@ static int rtl8152_resume(struct usb_interface *intf)
 
 	mutex_lock(&tp->control);
 
+	rtl_reset_ocp_base(tp);
+
 	if (test_bit(SELECTIVE_SUSPEND, &tp->flags))
 		ret = rtl8152_runtime_resume(tp);
 	else
@@ -8482,6 +8499,7 @@ static int rtl8152_reset_resume(struct usb_interface *intf)
 	struct r8152 *tp = usb_get_intfdata(intf);
 
 	clear_bit(SELECTIVE_SUSPEND, &tp->flags);
+	rtl_reset_ocp_base(tp);
 	tp->rtl_ops.init(tp);
 	queue_delayed_work(system_long_wq, &tp->hw_phy_work, 0);
 	set_ethernet_addr(tp, true);
-- 
2.34.1

