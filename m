Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E7C63F308
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 15:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbiLAOjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 09:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbiLAOj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 09:39:29 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 73F89A8FEC
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 06:39:27 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2B1Ecbz77007477, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2B1Ecbz77007477
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 1 Dec 2022 22:38:37 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Thu, 1 Dec 2022 22:39:23 +0800
Received: from localhost.localdomain (172.21.182.189) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 1 Dec 2022 22:39:22 +0800
From:   Chunhao Lin <hau@realtek.com>
To:     <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        Chunhao Lin <hau@realtek.com>
Subject: [PATCH net-next v5] r8169: add support for rtl8168h(revid 0x2a) + rtl8211fs fiber application
Date:   Thu, 1 Dec 2022 22:39:11 +0800
Message-ID: <20221201143911.4449-1-hau@realtek.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.182.189]
X-ClientProxiedBy: RTEXH36505.realtek.com.tw (172.21.6.25) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: trusted connection
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 12/01/2022 14:16:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEyLzEgpFWkyCAxMjo1NzowMA==?=
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtl8168h(revid 0x2a) + rtl8211fs is for utp to fiber application.
rtl8168h is connected to rtl8211fs utp interface. And fiber is connected
to rtl8211fs sfp interface. rtl8168h use its eeprm or gpo pins to control
rtl8211fs mdio bus.

In this patch, driver will register a phy device which uses bitbanged MDIO
framework to access rtl8211fs.

Becuse driver only needs to set rtl8211fs phy parameters, so after setting
rtl8211fs phy parameters, it will release  phy device.

Fiber does not support speed down, so driver will not speed down phy when
system suspend or shutdown.

Driver will set mdiobb_ops owner to NULL when call alloc_mdio_bitbang().
That avoid increase module's refcount to prevent rmmod cannot be done.
https://patchwork.kernel.org/project/linux-renesas-soc/patch/20200730100151.7490-1-ashiduka@fujitsu.com/

Signed-off-by: Chunhao Lin <hau@realtek.com>
---
v4 -> v5: register a phy device for rtl8211fs

 drivers/net/ethernet/realtek/Kconfig      |   1 +
 drivers/net/ethernet/realtek/r8169_main.c | 247 +++++++++++++++++++++-
 2 files changed, 247 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/Kconfig b/drivers/net/ethernet/realtek/Kconfig
index 93d9df55b361..20367114ac72 100644
--- a/drivers/net/ethernet/realtek/Kconfig
+++ b/drivers/net/ethernet/realtek/Kconfig
@@ -100,6 +100,7 @@ config R8169
 	depends on PCI
 	select FW_LOADER
 	select CRC32
+	select MDIO_BITBANG
 	select PHYLIB
 	select REALTEK_PHY
 	help
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 5bc1181f829b..cd6cd64a197f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -28,6 +28,7 @@
 #include <linux/bitfield.h>
 #include <linux/prefetch.h>
 #include <linux/ipv6.h>
+#include <linux/mdio-bitbang.h>
 #include <asm/unaligned.h>
 #include <net/ip6_checksum.h>
 
@@ -325,6 +326,15 @@ enum rtl8168_registers {
 #define EARLY_TALLY_EN			(1 << 16)
 };
 
+enum rtl_bb_registers {
+	MDIO_IN			= 0xdc04,
+	PINOE			= 0xdc06,
+	PIN_I_SEL_1		= 0xdc08,
+	PIN_I_SEL_2		= 0xdc0A,
+	PINPU			= 0xdc18,
+	GPOUTPIN_SEL	= 0xdc20,
+};
+
 enum rtl8125_registers {
 	IntrMask_8125		= 0x38,
 	IntrStatus_8125		= 0x3c,
@@ -573,6 +583,14 @@ struct rtl8169_tc_offsets {
 	__le16	rx_missed;
 };
 
+struct rtl_bb_mask {
+	const u16 pin;
+	const u16 mdio_oe;
+	const u16 mdio;
+	const u16 mdc;
+	const u16 rb_pos;
+};
+
 enum rtl_flag {
 	RTL_FLAG_TASK_ENABLED = 0,
 	RTL_FLAG_TASK_RESET_PENDING,
@@ -624,6 +642,12 @@ struct rtl8169_private {
 	struct rtl_fw *rtl_fw;
 
 	u32 ocp_base;
+
+	struct {
+		struct mii_bus *mii_bus;
+		struct phy_device *phydev;
+		struct bb_info *ctrl;
+	} bb;
 };
 
 typedef void (*rtl_generic_fct)(struct rtl8169_private *tp);
@@ -1199,6 +1223,217 @@ static enum rtl_dash_type rtl_check_dash(struct rtl8169_private *tp)
 	}
 }
 
+struct bb_info {
+	struct rtl8169_private *tp;
+	struct mdiobb_ctrl ctrl;
+	struct rtl_bb_mask mask;
+	u16 pinoe;
+	u16 pin_i_sel_1;
+	u16 pin_i_sel_2;
+};
+
+/* Data I/O pin control */
+static void rtl_bb_mdio_dir(struct mdiobb_ctrl *ctrl, int output)
+{
+	struct bb_info *bitbang = container_of(ctrl, struct bb_info, ctrl);
+	struct rtl8169_private *tp = bitbang->tp;
+	const u16 mask = bitbang->mask.mdio_oe;
+	const u16 reg = PINOE;
+	u16 value;
+
+	value = bitbang->pinoe;
+	if (output)
+		value |= mask;
+	else
+		value &= ~mask;
+	r8168_mac_ocp_write(tp, reg, value);
+}
+
+/* Set bit data*/
+static void rtl_bb_set_mdio(struct mdiobb_ctrl *ctrl, int set)
+{
+	struct bb_info *bitbang = container_of(ctrl, struct bb_info, ctrl);
+	struct rtl8169_private *tp = bitbang->tp;
+	const u16 mask = bitbang->mask.mdio;
+	const u16 reg = PIN_I_SEL_2;
+	u16 value;
+
+	value = bitbang->pin_i_sel_2;
+	if (set)
+		value |= mask;
+	else
+		value &= ~mask;
+	r8168_mac_ocp_write(tp, reg, value);
+}
+
+/* Get bit data*/
+static int rtl_bb_get_mdio(struct mdiobb_ctrl *ctrl)
+{
+	struct bb_info *bitbang = container_of(ctrl, struct bb_info, ctrl);
+	struct rtl8169_private *tp = bitbang->tp;
+	const u16 reg = MDIO_IN;
+
+	return (r8168_mac_ocp_read(tp, reg) & BIT(bitbang->mask.rb_pos)) != 0;
+}
+
+/* MDC pin control */
+static void rtl_bb_mdc_ctrl(struct mdiobb_ctrl *ctrl, int set)
+{
+	struct bb_info *bitbang = container_of(ctrl, struct bb_info, ctrl);
+	struct rtl8169_private *tp = bitbang->tp;
+	const u16 mask = bitbang->mask.mdc;
+	const u16 mdc_reg = PIN_I_SEL_1;
+	u16 value;
+
+	value = bitbang->pin_i_sel_1;
+	if (set)
+		value |= mask;
+	else
+		value &= ~mask;
+	r8168_mac_ocp_write(tp, mdc_reg, value);
+}
+
+/* mdio bus control struct */
+static const struct mdiobb_ops bb_ops = {
+	.owner = NULL, /* set to NULL for not increase refcount */
+	.set_mdc = rtl_bb_mdc_ctrl,
+	.set_mdio_dir = rtl_bb_mdio_dir,
+	.set_mdio_data = rtl_bb_set_mdio,
+	.get_mdio_data = rtl_bb_get_mdio,
+};
+
+static void rtl_bb_init(struct bb_info *bitbang, struct rtl_bb_mask *mask)
+{
+	struct rtl8169_private *tp = bitbang->tp;
+
+	r8168_mac_ocp_modify(tp, PINPU, mask->pin, 0);
+	r8168_mac_ocp_modify(tp, PINOE, 0, mask->pin);
+	bitbang->pinoe = r8168_mac_ocp_read(tp, PINOE);
+	bitbang->pin_i_sel_1 = r8168_mac_ocp_read(tp, PIN_I_SEL_1);
+	bitbang->pin_i_sel_2 = r8168_mac_ocp_read(tp, PIN_I_SEL_2);
+	memcpy(&bitbang->mask, mask, sizeof(struct rtl_bb_mask));
+}
+
+/* Bitbang MDIO bus init function */
+static int rtl_bb_mdio_bus_init(struct rtl8169_private *tp,
+				  struct rtl_bb_mask *mask)
+{
+	struct pci_dev *pdev = tp->pci_dev;
+	struct bb_info *bitbang;
+	struct mii_bus *new_bus;
+	int rc = 0;
+
+	/* create bit control struct for PHY */
+	bitbang = kzalloc(sizeof(struct bb_info), GFP_KERNEL);
+	if (!bitbang) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	/* bitbang init */
+	bitbang->tp = tp;
+	bitbang->ctrl.ops = &bb_ops;
+
+	/* Bitbang MII controller setting */
+	new_bus = alloc_mdio_bitbang(&bitbang->ctrl);
+	if (!new_bus) {
+		rc = -ENOMEM;
+		goto err_bb_init_0;
+	}
+
+	new_bus->name = "r8169_bb_mii_bus";
+	new_bus->parent = &pdev->dev;
+	snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-bb-%x-%x",
+		 pci_domain_nr(pdev->bus), pci_dev_id(pdev));
+
+	rtl_bb_init(bitbang, mask);
+
+	rc = mdiobus_register(new_bus);
+	if (rc)
+		goto err_bb_init_1;
+
+	tp->bb.phydev = mdiobus_get_phy(new_bus, 0);
+	if (!tp->bb.phydev) {
+		rc = -ENODEV;
+		goto err_bb_init_2;
+	} else if (!tp->bb.phydev->drv) {
+		/* Most chip versions fail with the genphy driver.
+		 * Therefore ensure that the dedicated PHY driver is loaded.
+		 */
+		rc =  -EUNATCH;
+		goto err_bb_init_2;
+	}
+
+	tp->bb.mii_bus = new_bus;
+	tp->bb.ctrl = bitbang;
+out:
+	return rc;
+
+err_bb_init_2:
+	mdiobus_unregister(new_bus);
+err_bb_init_1:
+	free_mdio_bitbang(new_bus);
+err_bb_init_0:
+	kfree(bitbang);
+	goto out;
+}
+
+static void rtl_bb_mdio_bus_release(struct rtl8169_private *tp)
+{
+	/* Unregister mdio bus */
+	mdiobus_unregister(tp->bb.mii_bus);
+
+	/* free bitbang info */
+	free_mdio_bitbang(tp->bb.mii_bus);
+
+	/* free bit control struct */
+	kfree(tp->bb.ctrl);
+}
+
+static int __rtl_check_bb_mdio_bus(struct rtl8169_private *tp)
+{
+	static struct rtl_bb_mask pin_mask_eeprom = {
+		0x0050, 0x0040, 0x000f, 0x0f00, 6};
+	static struct rtl_bb_mask pin_mask_gpo = {
+		0x0210, 0x0200, 0xf000, 0x0f00, 9};
+
+	if (!rtl_bb_mdio_bus_init(tp, &pin_mask_eeprom) ||
+		!rtl_bb_mdio_bus_init(tp, &pin_mask_gpo))
+		return 0;
+
+	return -1;
+}
+
+static bool rtl_supports_bb_mdio_bus(struct rtl8169_private *tp)
+{
+	return tp->mac_version == RTL_GIGA_MAC_VER_46 &&
+		   tp->pci_dev->revision == 0x2a;
+}
+
+static int rtl_check_bb_mdio_bus(struct rtl8169_private *tp)
+{
+	if (rtl_supports_bb_mdio_bus(tp))
+		return __rtl_check_bb_mdio_bus(tp);
+	return -1;
+}
+
+static void rtl8169_init_bb_phy(struct rtl8169_private *tp)
+{
+	struct phy_device *phydev = tp->bb.phydev;
+
+	/* disable ctap */
+	phy_modify_paged(phydev, 0x0a43, 0x19, BIT(6), 0);
+
+	/* change Rx threshold */
+	phy_modify_paged(phydev, 0x0dcc, 0x14, 0, BIT(2) | BIT(3) | BIT(4));
+
+	/* switch pin34 to PMEB pin */
+	phy_modify_paged(phydev, 0x0d40, 0x16, 0, BIT(5));
+
+	/* enable pass_linkctl_en */
+	phy_modify_paged(phydev, 0x0a4b, 0x11, 0, BIT(4));
+}
+
 static void rtl_set_d3_pll_down(struct rtl8169_private *tp, bool enable)
 {
 	switch (tp->mac_version) {
@@ -2171,6 +2406,14 @@ static void rtl8169_init_phy(struct rtl8169_private *tp)
 	    tp->pci_dev->subsystem_device == 0xe000)
 		phy_write_paged(tp->phydev, 0x0001, 0x10, 0xf01b);
 
+	if (!rtl_check_bb_mdio_bus(tp)) {
+		rtl8169_init_bb_phy(tp);
+		/* disable ctap */
+		phy_modify_paged(tp->phydev, 0x0a43, 0x11, BIT(6), 0);
+
+		rtl_bb_mdio_bus_release(tp);
+	}
+
 	/* We may have called phy_speed_down before */
 	phy_speed_up(tp->phydev);
 
@@ -2227,7 +2470,9 @@ static void rtl_prepare_power_down(struct rtl8169_private *tp)
 		rtl_ephy_write(tp, 0x19, 0xff64);
 
 	if (device_may_wakeup(tp_to_dev(tp))) {
-		phy_speed_down(tp->phydev, false);
+		/* Fiber not support speed down */
+		if (!tp->bb.mii_bus)
+			phy_speed_down(tp->phydev, false);
 		rtl_wol_enable_rx(tp);
 	}
 }
-- 
2.25.1

