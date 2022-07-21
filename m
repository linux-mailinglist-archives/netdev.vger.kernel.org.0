Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2A257CE09
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 16:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiGUOqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 10:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiGUOp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 10:45:59 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3896066AFE;
        Thu, 21 Jul 2022 07:45:58 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 26LEjpEY3009042, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 26LEjpEY3009042
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 21 Jul 2022 22:45:51 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 21 Jul 2022 22:45:56 +0800
Received: from localhost.localdomain (172.21.182.184) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 21 Jul 2022 22:45:55 +0800
From:   Chunhao Lin <hau@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Chunhao Lin <hau@realtek.com>
Subject: [PATCH net-next] r8169: add support for rtl8168h(revid 0x2a) + rtl8211fs fiber application
Date:   Thu, 21 Jul 2022 22:45:50 +0800
Message-ID: <20220721144550.4405-1-hau@realtek.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.182.184]
X-ClientProxiedBy: RTEXH36504.realtek.com.tw (172.21.6.27) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: trusted connection
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/21/2022 14:30:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzcvMjEgpFWkyCAwMToxMzowMA==?=
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

rtl8168h(revid 0x2a) + rtl8211fs is for fiber related application.
rtl8168h will control rtl8211fs via its eeprom or gpo pins.
Fiber module will be connected to rtl8211fs. The link speed between
rtl8168h and rtl8211fs is decied by fiber module.

Signed-off-by: Chunhao Lin <hau@realtek.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 315 +++++++++++++++++++++-
 1 file changed, 313 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 1b7fdb4f056b..aa817e2f919a 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -344,6 +344,15 @@ enum rtl8125_registers {
 	EEE_TXIDLE_TIMER_8125	= 0x6048,
 };
 
+enum rtl8168_sfp_registers {
+	MDIO_IN			= 0xdc04,
+	PINOE			= 0xdc06,
+	PIN_I_SEL_1		= 0xdc08,
+	PIN_I_SEL_2		= 0xdc0A,
+	PINPU			= 0xdc18,
+	GPOUTPIN_SEL	= 0xdc20,
+};
+
 #define RX_VLAN_INNER_8125	BIT(22)
 #define RX_VLAN_OUTER_8125	BIT(23)
 #define RX_VLAN_8125		(RX_VLAN_INNER_8125 | RX_VLAN_OUTER_8125)
@@ -584,6 +593,30 @@ struct rtl8169_tc_offsets {
 	__le16	rx_missed;
 };
 
+struct rtl_sfp_if_info {
+	u16 mdio_oe_i;
+	u16 mdio_oe_o;
+	u16 mdio_pu;
+	u16 mdio_pd;
+	u16 mdc_pu;
+	u16 mdc_pd;
+};
+
+struct rtl_sfp_if_mask {
+	const u16 pin_mask;
+	const u16 mdio_oe_mask;
+	const u16 mdio_mask;
+	const u16 mdc_mask;
+	const u16 phy_addr;
+	const u16 rb_pos;
+};
+
+struct rtl_sfp_if_mask rtl_sfp_if_eeprom_mask = {
+	0x0050, 0x0040, 0x000f, 0x0f00, 0, 6};
+
+struct rtl_sfp_if_mask rtl_sfp_if_gpo_mask = {
+	0x0210, 0x0200, 0xf000, 0x0f00, 1, 9};
+
 enum rtl_flag {
 	RTL_FLAG_TASK_ENABLED = 0,
 	RTL_FLAG_TASK_RESET_PENDING,
@@ -596,6 +629,12 @@ enum rtl_dash_type {
 	RTL_DASH_EP,
 };
 
+enum rtl_sfp_if_type {
+	RTL_SFP_IF_NONE,
+	RTL_SFP_IF_EEPROM,
+	RTL_SFP_IF_GPIO,
+};
+
 struct rtl8169_private {
 	void __iomem *mmio_addr;	/* memory map physical address */
 	struct pci_dev *pci_dev;
@@ -635,6 +674,8 @@ struct rtl8169_private {
 	struct rtl_fw *rtl_fw;
 
 	u32 ocp_base;
+
+	enum rtl_sfp_if_type sfp_if_type;
 };
 
 typedef void (*rtl_generic_fct)(struct rtl8169_private *tp);
@@ -914,8 +955,12 @@ static void r8168g_mdio_write(struct rtl8169_private *tp, int reg, int value)
 	if (tp->ocp_base != OCP_STD_PHY_BASE)
 		reg -= 0x10;
 
-	if (tp->ocp_base == OCP_STD_PHY_BASE && reg == MII_BMCR)
+	if (tp->ocp_base == OCP_STD_PHY_BASE && reg == MII_BMCR) {
+		if (tp->sfp_if_type != RTL_SFP_IF_NONE && value & BMCR_PDOWN)
+			return;
+
 		rtl8168g_phy_suspend_quirk(tp, value);
+	}
 
 	r8168_phy_ocp_write(tp, tp->ocp_base + reg * 2, value);
 }
@@ -1214,6 +1259,266 @@ static enum rtl_dash_type rtl_check_dash(struct rtl8169_private *tp)
 	}
 }
 
+static void rtl_sfp_shift_bit_in(struct rtl8169_private *tp,
+				  struct rtl_sfp_if_info *sfp_if_info, u32 val, int count)
+{
+	int i;
+	const u16 mdc_reg = PIN_I_SEL_1;
+	const u16 mdio_reg = PIN_I_SEL_2;
+
+	for (i = (count - 1); i >= 0; i--) {
+		r8168_mac_ocp_write(tp, mdc_reg, sfp_if_info->mdc_pd);
+		if (val & BIT(i))
+			r8168_mac_ocp_write(tp, mdio_reg, sfp_if_info->mdio_pu);
+		else
+			r8168_mac_ocp_write(tp, mdio_reg, sfp_if_info->mdio_pd);
+		r8168_mac_ocp_write(tp, mdc_reg, sfp_if_info->mdc_pu);
+	}
+}
+
+static u16 rtl_sfp_shift_bit_out(struct rtl8169_private *tp,
+				  struct rtl_sfp_if_info *sfp_if_info, u16 rb_pos)
+{
+	int i;
+	u16 data = 0;
+	const u16 mdc_reg = PIN_I_SEL_1;
+	const u16 mdio_in_reg = MDIO_IN;
+
+	for (i = 15; i >= 0; i--) {
+		r8168_mac_ocp_write(tp, mdc_reg, sfp_if_info->mdc_pu);
+		r8168_mac_ocp_write(tp, mdc_reg, sfp_if_info->mdc_pd);
+		data += r8168_mac_ocp_read(tp, mdio_in_reg) & BIT(rb_pos) ? BIT(i) : 0;
+	}
+
+	return data;
+}
+
+static void rtl_select_sfp_if(struct rtl8169_private *tp,
+				  struct rtl_sfp_if_mask *sfp_if_mask,
+				  struct rtl_sfp_if_info *sfp_if_info)
+{
+	u16 pinoe_value, pin_i_sel_1_value, pin_i_sel_2_value;
+
+	r8168_mac_ocp_modify(tp, PINPU, sfp_if_mask->pin_mask, 0);
+	r8168_mac_ocp_modify(tp, PINOE, 0, sfp_if_mask->pin_mask);
+
+	pinoe_value = r8168_mac_ocp_read(tp, PINOE);
+	pin_i_sel_1_value = r8168_mac_ocp_read(tp, PIN_I_SEL_1);
+	pin_i_sel_2_value = r8168_mac_ocp_read(tp, PIN_I_SEL_2);
+
+	sfp_if_info->mdio_oe_i = pinoe_value & ~sfp_if_mask->mdio_oe_mask;
+	sfp_if_info->mdio_oe_o = pinoe_value | sfp_if_mask->mdio_oe_mask;
+	sfp_if_info->mdio_pd = pin_i_sel_2_value & ~sfp_if_mask->mdio_mask;
+	sfp_if_info->mdio_pu = pin_i_sel_2_value | sfp_if_mask->mdio_mask;
+	sfp_if_info->mdc_pd = pin_i_sel_1_value & ~sfp_if_mask->mdc_mask;
+	sfp_if_info->mdc_pu = pin_i_sel_1_value | sfp_if_mask->mdc_mask;
+}
+
+#define RT_SFP_ST (1)
+#define RT_SFP_OP_W (1)
+#define RT_SFP_OP_R (2)
+#define RT_SFP_TA_W (2)
+#define RT_SFP_TA_R (0)
+
+static void rtl_sfp_if_write(struct rtl8169_private *tp,
+				  struct rtl_sfp_if_mask *sfp_if_mask, u8 reg, u16 val)
+{
+	struct rtl_sfp_if_info sfp_if_info = {0};
+	const u16 mdc_reg = PIN_I_SEL_1;
+	const u16 mdio_reg = PIN_I_SEL_2;
+
+	rtl_select_sfp_if(tp, sfp_if_mask, &sfp_if_info);
+
+	/* change to output mode */
+	r8168_mac_ocp_write(tp, PINOE, sfp_if_info.mdio_oe_o);
+
+	/* init sfp interface */
+	r8168_mac_ocp_write(tp, mdc_reg, sfp_if_info.mdc_pd);
+	r8168_mac_ocp_write(tp, mdio_reg, sfp_if_info.mdio_pu);
+
+	/* preamble 32bit of 1 */
+	rtl_sfp_shift_bit_in(tp, &sfp_if_info, 0xffffffff, 32);
+
+	/* opcode write */
+	rtl_sfp_shift_bit_in(tp, &sfp_if_info, RT_SFP_ST, 2);
+	rtl_sfp_shift_bit_in(tp, &sfp_if_info, RT_SFP_OP_W, 2);
+
+	/* phy address */
+	rtl_sfp_shift_bit_in(tp, &sfp_if_info, sfp_if_mask->phy_addr, 5);
+
+	/* phy reg */
+	rtl_sfp_shift_bit_in(tp, &sfp_if_info, reg, 5);
+
+	/* turn-around(TA) */
+	rtl_sfp_shift_bit_in(tp, &sfp_if_info, RT_SFP_TA_W, 2);
+
+	/* write phy data */
+	rtl_sfp_shift_bit_in(tp, &sfp_if_info, val, 16);
+}
+
+static u16 rtl_sfp_if_read(struct rtl8169_private *tp,
+				  struct rtl_sfp_if_mask *sfp_if_mask, u8 reg)
+{
+	struct rtl_sfp_if_info sfp_if_info = {0};
+	const u16 mdc_reg = PIN_I_SEL_1;
+	const u16 mdio_reg = PIN_I_SEL_2;
+
+	rtl_select_sfp_if(tp, sfp_if_mask, &sfp_if_info);
+
+	/* change to output mode */
+	r8168_mac_ocp_write(tp, PINOE, sfp_if_info.mdio_oe_o);
+
+	/* init sfp interface */
+	r8168_mac_ocp_write(tp, mdc_reg, sfp_if_info.mdc_pd);
+	r8168_mac_ocp_write(tp, mdio_reg, sfp_if_info.mdio_pd);
+
+	/* preamble 32bit of 1 */
+	rtl_sfp_shift_bit_in(tp, &sfp_if_info, 0xffffffff, 32);
+
+	/* opcode read */
+	rtl_sfp_shift_bit_in(tp, &sfp_if_info, RT_SFP_ST, 2);
+	rtl_sfp_shift_bit_in(tp, &sfp_if_info, RT_SFP_OP_R, 2);
+
+	/* phy address */
+	rtl_sfp_shift_bit_in(tp, &sfp_if_info, sfp_if_mask->phy_addr, 5);
+
+	/* phy reg */
+	rtl_sfp_shift_bit_in(tp, &sfp_if_info, reg, 5);
+
+	/* turn-around(TA) */
+	r8168_mac_ocp_write(tp, mdc_reg, sfp_if_info.mdc_pd);
+	r8168_mac_ocp_write(tp, mdc_reg, sfp_if_info.mdc_pu);
+	rtl_sfp_shift_bit_in(tp, &sfp_if_info, 0, 1);
+
+	/* change to input mode */
+	r8168_mac_ocp_write(tp, PINOE, sfp_if_info.mdio_oe_i);
+
+	/* read phy data */
+	return rtl_sfp_shift_bit_out(tp, &sfp_if_info, sfp_if_mask->rb_pos);
+}
+
+static void rtl_sfp_eeprom_write(struct rtl8169_private *tp, u8 reg,
+				  u16 val)
+{
+	rtl_sfp_if_write(tp, &rtl_sfp_if_eeprom_mask, reg, val);
+}
+
+static u16 rtl_sfp_eeprom_read(struct rtl8169_private *tp, u8 reg)
+{
+	return rtl_sfp_if_read(tp, &rtl_sfp_if_eeprom_mask, reg);
+}
+
+static void rtl_sfp_gpo_write(struct rtl8169_private *tp, u8 reg,
+				  u16 val)
+{
+	rtl_sfp_if_write(tp, &rtl_sfp_if_gpo_mask, reg, val);
+}
+
+static u16 rtl_sfp_gpo_read(struct rtl8169_private *tp, u8 reg)
+{
+	return rtl_sfp_if_read(tp, &rtl_sfp_if_gpo_mask, reg);
+}
+
+static void rtl_sfp_mdio_write(struct rtl8169_private *tp,
+				  u8 reg,
+				  u16 val)
+{
+	switch (tp->sfp_if_type) {
+	case RTL_SFP_IF_EEPROM:
+		return rtl_sfp_eeprom_write(tp, reg, val);
+	case RTL_SFP_IF_GPIO:
+		return rtl_sfp_gpo_write(tp, reg, val);
+	default:
+		return;
+	}
+}
+
+static u16 rtl_sfp_mdio_read(struct rtl8169_private *tp,
+				  u8 reg)
+{
+	switch (tp->sfp_if_type) {
+	case RTL_SFP_IF_EEPROM:
+		return rtl_sfp_eeprom_read(tp, reg);
+	case RTL_SFP_IF_GPIO:
+		return rtl_sfp_gpo_read(tp, reg);
+	default:
+		return 0xffff;
+	}
+}
+
+static void rtl_sfp_mdio_modify(struct rtl8169_private *tp, u32 reg, u16 mask,
+				 u16 set)
+{
+	u16 data = rtl_sfp_mdio_read(tp, reg);
+
+	rtl_sfp_mdio_write(tp, reg, (data & ~mask) | set);
+}
+
+#define RTL8211FS_PHY_ID_1 0x001c
+#define RTL8211FS_PHY_ID_2 0xc916
+
+static enum rtl_sfp_if_type rtl8168h_check_sfp(struct rtl8169_private *tp)
+{
+	int i;
+	int const checkcnt = 4;
+
+	rtl_sfp_eeprom_write(tp, 0x1f, 0x0000);
+	for (i = 0; i < checkcnt; i++) {
+		if (rtl_sfp_eeprom_read(tp, 0x02) != RTL8211FS_PHY_ID_1 ||
+			rtl_sfp_eeprom_read(tp, 0x03) != RTL8211FS_PHY_ID_2)
+			break;
+	}
+
+	if (i == checkcnt)
+		return RTL_SFP_IF_EEPROM;
+
+	rtl_sfp_gpo_write(tp, 0x1f, 0x0000);
+	for (i = 0; i < checkcnt; i++) {
+		if (rtl_sfp_gpo_read(tp, 0x02) != RTL8211FS_PHY_ID_1 ||
+			rtl_sfp_gpo_read(tp, 0x03) != RTL8211FS_PHY_ID_2)
+			break;
+	}
+
+	if (i == checkcnt)
+		return RTL_SFP_IF_GPIO;
+
+	return RTL_SFP_IF_NONE;
+}
+
+static enum rtl_sfp_if_type rtl_check_sfp(struct rtl8169_private *tp)
+{
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_45:
+	case RTL_GIGA_MAC_VER_46:
+		if (tp->pci_dev->revision == 0x2a)
+			return rtl8168h_check_sfp(tp);
+		else
+			return RTL_SFP_IF_NONE;
+	default:
+		return RTL_SFP_IF_NONE;
+	}
+}
+
+static void rtl_hw_sfp_phy_config(struct rtl8169_private *tp)
+{
+	/* disable ctap */
+	rtl_sfp_mdio_write(tp, 0x1f, 0x0a43);
+	rtl_sfp_mdio_modify(tp, 0x19, BIT(6), 0);
+
+	/* change Rx threshold */
+	rtl_sfp_mdio_write(tp, 0x1f, 0x0dcc);
+	rtl_sfp_mdio_modify(tp, 0x14, 0, BIT(2) | BIT(3) | BIT(4));
+
+	/* switch pin34 to PMEB pin */
+	rtl_sfp_mdio_write(tp, 0x1f, 0x0d40);
+	rtl_sfp_mdio_modify(tp, 0x16, 0, BIT(5));
+
+	rtl_sfp_mdio_write(tp, 0x1f, 0x0000);
+
+	/* disable ctap */
+	phy_modify_paged(tp->phydev, 0x0a43, 0x11, BIT(6), 0);
+}
+
 static void rtl_set_d3_pll_down(struct rtl8169_private *tp, bool enable)
 {
 	switch (tp->mac_version) {
@@ -2195,6 +2500,9 @@ static void rtl8169_init_phy(struct rtl8169_private *tp)
 	    tp->pci_dev->subsystem_device == 0xe000)
 		phy_write_paged(tp->phydev, 0x0001, 0x10, 0xf01b);
 
+	if (tp->sfp_if_type != RTL_SFP_IF_NONE)
+		rtl_hw_sfp_phy_config(tp);
+
 	/* We may have called phy_speed_down before */
 	phy_speed_up(tp->phydev);
 
@@ -2251,7 +2559,8 @@ static void rtl_prepare_power_down(struct rtl8169_private *tp)
 		rtl_ephy_write(tp, 0x19, 0xff64);
 
 	if (device_may_wakeup(tp_to_dev(tp))) {
-		phy_speed_down(tp->phydev, false);
+		if (tp->sfp_if_type == RTL_SFP_IF_NONE)
+			phy_speed_down(tp->phydev, false);
 		rtl_wol_enable_rx(tp);
 	}
 }
@@ -5386,6 +5695,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	tp->dash_type = rtl_check_dash(tp);
 
+	tp->sfp_if_type = rtl_check_sfp(tp);
+
 	tp->cp_cmd = RTL_R16(tp, CPlusCmd) & CPCMD_MASK;
 
 	if (sizeof(dma_addr_t) > 4 && tp->mac_version >= RTL_GIGA_MAC_VER_18 &&
-- 
2.25.1

