Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD4C3B8ECB
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 10:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235051AbhGAI3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 04:29:46 -0400
Received: from us-smtp-delivery-115.mimecast.com ([216.205.24.115]:23395 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234709AbhGAI3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 04:29:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1625128035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YqsKebREs1bWxUx/3JBCNyWId9BNjoLH81cyavHOX2M=;
        b=J0p/sMGvWkkoiB+Pm2/MbsIQr3+Dpqk4g0gFgRarRsFBg4BsMfbPclKkN8mKc2MBqnL5y9
        GfZzwHMcNfqg309HPmhbItnYiiTd1vIClQxCocJKrDqWtoe2SXrJwyz0w5Ai/g2jITS1Vd
        hM6FoCC9h5RWsdx7M2HMVliNi9syfuA=
Received: from mail.maxlinear.com (174-47-1-83.static.ctl.one [174.47.1.83])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-NvJ05aL2PJ-wK8QrZOX6tw-4; Thu, 01 Jul 2021 04:27:13 -0400
X-MC-Unique: NvJ05aL2PJ-wK8QrZOX6tw-4
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.120) with Microsoft SMTP Server id 15.1.2242.4;
 Thu, 1 Jul 2021 01:27:05 -0700
From:   Xu Liang <lxu@maxlinear.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <vee.khee.wong@linux.intel.com>
CC:     <linux@armlinux.org.uk>, <hmehrtens@maxlinear.com>,
        <tmohren@maxlinear.com>, <mohammad.athari.ismail@intel.com>,
        Xu Liang <lxu@maxlinear.com>
Subject: [PATCH v5 2/2] net: phy: add Maxlinear GPY115/21x/24x driver
Date:   Thu, 1 Jul 2021 16:26:58 +0800
Message-ID: <20210701082658.21875-2-lxu@maxlinear.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210701082658.21875-1-lxu@maxlinear.com>
References: <20210701082658.21875-1-lxu@maxlinear.com>
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add driver to support the Maxlinear GPY115, GPY211, GPY212, GPY215,
GPY241, GPY245 PHYs. Separate from XWAY PHY driver because this series
has different register layout and new features not supported in XWAY PHY.

Signed-off-by: Xu Liang <lxu@maxlinear.com>
---
v2 changes:
 Fix format warning from checkpath and some comments.
 Use smaller PHY ID mask.
 Split FWV register mask.
 Call phy_trigger_machine if necessary when clear interrupt.
v3 changes:
 Replace unnecessary phy_modify_mmd_changed with phy_modify_mmd
 Move firmware version print to probe.
v4 changes:
 Separate PHY ID for new silicon.
 Use full Maxlinear name in Kconfig.
 Add and use C45 ID read API, and use genphy_c45_pma_read_abilities.
 Use my name instead of company as author.
v5 changes:
 Fix comment for link speed 2.5G.

 MAINTAINERS               |   6 +
 drivers/net/phy/Kconfig   |   6 +
 drivers/net/phy/Makefile  |   1 +
 drivers/net/phy/mxl-gpy.c | 671 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 684 insertions(+)
 create mode 100644 drivers/net/phy/mxl-gpy.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 19cb1ea49c24..fd02995d7fad 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11180,6 +11180,12 @@ W:=09https://linuxtv.org
 T:=09git git://linuxtv.org/media_tree.git
 F:=09drivers/media/radio/radio-maxiradio*
=20
+MAXLINEAR ETHERNET PHY DRIVER
+M:=09Xu Liang <lxu@maxlinear.com>
+L:=09netdev@vger.kernel.org
+S:=09Supported
+F:=09drivers/net/phy/mxl-gpy.c
+
 MCAN MMIO DEVICE DRIVER
 M:=09Chandrasekar Ramakrishnan <rcsekar@samsung.com>
 L:=09linux-can@vger.kernel.org
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 288bf405ebdb..7dba83822bc0 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -207,6 +207,12 @@ config MARVELL_88X2222_PHY
 =09  Support for the Marvell 88X2222 Dual-port Multi-speed Ethernet
 =09  Transceiver.
=20
+config MAXLINEAR_GPHY
+=09tristate "Maxlinear Ethernet PHYs"
+=09help
+=09  Support for the Maxlinear GPY115, GPY211, GPY212, GPY215,
+=09  GPY241, GPY245 PHYs.
+
 config MICREL_PHY
 =09tristate "Micrel PHYs"
 =09help
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index bcda7ed2455d..7aa3a5bd9bc2 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -70,6 +70,7 @@ obj-$(CONFIG_MICREL_PHY)=09+=3D micrel.o
 obj-$(CONFIG_MICROCHIP_PHY)=09+=3D microchip.o
 obj-$(CONFIG_MICROCHIP_T1_PHY)=09+=3D microchip_t1.o
 obj-$(CONFIG_MICROSEMI_PHY)=09+=3D mscc/
+obj-$(CONFIG_MAXLINEAR_GPHY)=09+=3D mxl-gpy.o
 obj-$(CONFIG_NATIONAL_PHY)=09+=3D national.o
 obj-$(CONFIG_NXP_C45_TJA11XX_PHY)=09+=3D nxp-c45-tja11xx.o
 obj-$(CONFIG_NXP_TJA11XX_PHY)=09+=3D nxp-tja11xx.o
diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
new file mode 100644
index 000000000000..789b9ac9369f
--- /dev/null
+++ b/drivers/net/phy/mxl-gpy.c
@@ -0,0 +1,671 @@
+// SPDX-License-Identifier: GPL-2.0+
+/* Copyright (C) 2021 Maxlinear Corporation
+ * Copyright (C) 2020 Intel Corporation
+ *
+ * Drivers for Maxlinear Ethernet GPY
+ *
+ */
+
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/bitfield.h>
+#include <linux/phy.h>
+#include <linux/netdevice.h>
+
+/* PHY ID */
+#define PHY_ID_GPYx15B_MASK=090xFFFFFFFC
+#define PHY_ID_GPY21xB_MASK=090xFFFFFFF9
+#define PHY_ID_GPY2xx=09=090x67C9DC00
+#define PHY_ID_GPY115B=09=090x67C9DF00
+#define PHY_ID_GPY115C=09=090x67C9DF10
+#define PHY_ID_GPY211B=09=090x67C9DE08
+#define PHY_ID_GPY211C=09=090x67C9DE10
+#define PHY_ID_GPY212B=09=090x67C9DE09
+#define PHY_ID_GPY212C=09=090x67C9DE20
+#define PHY_ID_GPY215B=09=090x67C9DF04
+#define PHY_ID_GPY215C=09=090x67C9DF20
+
+#define PHY_MIISTAT=09=090x18=09/* MII state */
+#define PHY_IMASK=09=090x19=09/* interrupt mask */
+#define PHY_ISTAT=09=090x1A=09/* interrupt status */
+#define PHY_FWV=09=09=090x1E=09/* firmware version */
+
+#define PHY_MIISTAT_SPD_MASK=09GENMASK(2, 0)
+#define PHY_MIISTAT_DPX=09=09BIT(3)
+#define PHY_MIISTAT_LS=09=09BIT(10)
+
+#define PHY_MIISTAT_SPD_10=090
+#define PHY_MIISTAT_SPD_100=091
+#define PHY_MIISTAT_SPD_1000=092
+#define PHY_MIISTAT_SPD_2500=094
+
+#define PHY_IMASK_WOL=09=09BIT(15)=09/* Wake-on-LAN */
+#define PHY_IMASK_ANC=09=09BIT(10)=09/* Auto-Neg complete */
+#define PHY_IMASK_ADSC=09=09BIT(5)=09/* Link auto-downspeed detect */
+#define PHY_IMASK_DXMC=09=09BIT(2)=09/* Duplex mode change */
+#define PHY_IMASK_LSPC=09=09BIT(1)=09/* Link speed change */
+#define PHY_IMASK_LSTC=09=09BIT(0)=09/* Link state change */
+#define PHY_IMASK_MASK=09=09(PHY_IMASK_LSTC | \
+=09=09=09=09 PHY_IMASK_LSPC | \
+=09=09=09=09 PHY_IMASK_DXMC | \
+=09=09=09=09 PHY_IMASK_ADSC | \
+=09=09=09=09 PHY_IMASK_ANC)
+
+#define PHY_FWV_REL_MASK=09BIT(15)
+#define PHY_FWV_TYPE_MASK=09GENMASK(11, 8)
+#define PHY_FWV_MINOR_MASK=09GENMASK(7, 0)
+
+/* SGMII */
+#define VSPEC1_SGMII_CTRL=090x08
+#define VSPEC1_SGMII_CTRL_ANEN=09BIT(12)=09=09/* Aneg enable */
+#define VSPEC1_SGMII_CTRL_ANRS=09BIT(9)=09=09/* Restart Aneg */
+#define VSPEC1_SGMII_ANEN_ANRS=09(VSPEC1_SGMII_CTRL_ANEN | \
+=09=09=09=09 VSPEC1_SGMII_CTRL_ANRS)
+
+/* WoL */
+#define VPSPEC2_WOL_CTL=09=090x0E06
+#define VPSPEC2_WOL_AD01=090x0E08
+#define VPSPEC2_WOL_AD23=090x0E09
+#define VPSPEC2_WOL_AD45=090x0E0A
+#define WOL_EN=09=09=09BIT(0)
+
+static const struct {
+=09int type;
+=09int minor;
+} ver_need_sgmii_reaneg[] =3D {
+=09{7, 0x6D},
+=09{8, 0x6D},
+=09{9, 0x73},
+};
+
+static int gpy_config_init(struct phy_device *phydev)
+{
+=09int ret;
+
+=09/* Mask all interrupts */
+=09ret =3D phy_write(phydev, PHY_IMASK, 0);
+=09if (ret)
+=09=09return ret;
+
+=09/* Clear all pending interrupts */
+=09ret =3D phy_read(phydev, PHY_ISTAT);
+=09return ret < 0 ? ret : 0;
+}
+
+static int gpy_probe(struct phy_device *phydev)
+{
+=09int ret;
+
+=09if (!phydev->is_c45) {
+=09=09ret =3D phy_get_c45_ids(phydev);
+=09=09if (ret < 0)
+=09=09=09return ret;
+=09}
+
+=09/* Show GPY PHY FW version in dmesg */
+=09ret =3D phy_read(phydev, PHY_FWV);
+=09if (ret < 0)
+=09=09return ret;
+
+=09phydev_info(phydev, "Firmware Version: 0x%04X (%s)\n", ret,
+=09=09    (ret & PHY_FWV_REL_MASK) ? "release" : "test");
+
+=09return 0;
+}
+
+static bool gpy_sgmii_need_reaneg(struct phy_device *phydev)
+{
+=09int fw_ver, fw_type, fw_minor;
+=09size_t i;
+
+=09fw_ver =3D phy_read(phydev, PHY_FWV);
+=09if (fw_ver < 0)
+=09=09return true;
+
+=09fw_type =3D FIELD_GET(PHY_FWV_TYPE_MASK, fw_ver);
+=09fw_minor =3D FIELD_GET(PHY_FWV_MINOR_MASK, fw_ver);
+
+=09for (i =3D 0; i < ARRAY_SIZE(ver_need_sgmii_reaneg); i++) {
+=09=09if (fw_type !=3D ver_need_sgmii_reaneg[i].type)
+=09=09=09continue;
+=09=09if (fw_minor < ver_need_sgmii_reaneg[i].minor)
+=09=09=09return true;
+=09=09break;
+=09}
+
+=09return false;
+}
+
+static bool gpy_2500basex_chk(struct phy_device *phydev)
+{
+=09int ret;
+
+=09ret =3D phy_read(phydev, PHY_MIISTAT);
+=09if (ret < 0) {
+=09=09phydev_err(phydev, "Error: MDIO register access failed: %d\n",
+=09=09=09   ret);
+=09=09return false;
+=09}
+
+=09if (!(ret & PHY_MIISTAT_LS) ||
+=09    FIELD_GET(PHY_MIISTAT_SPD_MASK, ret) !=3D PHY_MIISTAT_SPD_2500)
+=09=09return false;
+
+=09phydev->speed =3D SPEED_2500;
+=09phydev->interface =3D PHY_INTERFACE_MODE_2500BASEX;
+=09phy_modify_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_SGMII_CTRL,
+=09=09       VSPEC1_SGMII_CTRL_ANEN, 0);
+=09return true;
+}
+
+static bool gpy_sgmii_aneg_en(struct phy_device *phydev)
+{
+=09int ret;
+
+=09ret =3D phy_read_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_SGMII_CTRL);
+=09if (ret < 0) {
+=09=09phydev_err(phydev, "Error: MMD register access failed: %d\n",
+=09=09=09   ret);
+=09=09return true;
+=09}
+
+=09return (ret & VSPEC1_SGMII_CTRL_ANEN) ? true : false;
+}
+
+static int gpy_config_aneg(struct phy_device *phydev)
+{
+=09bool changed =3D false;
+=09u32 adv;
+=09int ret;
+
+=09if (phydev->autoneg =3D=3D AUTONEG_DISABLE) {
+=09=09/* Configure half duplex with genphy_setup_forced,
+=09=09 * because genphy_c45_pma_setup_forced does not support.
+=09=09 */
+=09=09return phydev->duplex !=3D DUPLEX_FULL
+=09=09=09? genphy_setup_forced(phydev)
+=09=09=09: genphy_c45_pma_setup_forced(phydev);
+=09}
+
+=09ret =3D genphy_c45_an_config_aneg(phydev);
+=09if (ret < 0)
+=09=09return ret;
+=09if (ret > 0)
+=09=09changed =3D true;
+
+=09adv =3D linkmode_adv_to_mii_ctrl1000_t(phydev->advertising);
+=09ret =3D phy_modify_changed(phydev, MII_CTRL1000,
+=09=09=09=09 ADVERTISE_1000FULL | ADVERTISE_1000HALF,
+=09=09=09=09 adv);
+=09if (ret < 0)
+=09=09return ret;
+=09if (ret > 0)
+=09=09changed =3D true;
+
+=09ret =3D genphy_c45_check_and_restart_aneg(phydev, changed);
+=09if (ret < 0)
+=09=09return ret;
+
+=09if (phydev->interface =3D=3D PHY_INTERFACE_MODE_USXGMII ||
+=09    phydev->interface =3D=3D PHY_INTERFACE_MODE_INTERNAL)
+=09=09return 0;
+
+=09/* No need to trigger re-ANEG if link speed is 2.5G or SGMII ANEG is
+=09 * disabled.
+=09 */
+=09if (!gpy_sgmii_need_reaneg(phydev) || gpy_2500basex_chk(phydev) ||
+=09    !gpy_sgmii_aneg_en(phydev))
+=09=09return 0;
+
+=09/* There is a design constraint in GPY2xx device where SGMII AN is
+=09 * only triggered when there is change of speed. If, PHY link
+=09 * partner`s speed is still same even after PHY TPI is down and up
+=09 * again, SGMII AN is not triggered and hence no new in-band message
+=09 * from GPY to MAC side SGMII.
+=09 * This could cause an issue during power up, when PHY is up prior to
+=09 * MAC. At this condition, once MAC side SGMII is up, MAC side SGMII
+=09 * wouldn`t receive new in-band message from GPY with correct link
+=09 * status, speed and duplex info.
+=09 *
+=09 * 1) If PHY is already up and TPI link status is still down (such as
+=09 *    hard reboot), TPI link status is polled for 4 seconds before
+=09 *    retriggerring SGMII AN.
+=09 * 2) If PHY is already up and TPI link status is also up (such as soft
+=09 *    reboot), polling of TPI link status is not needed and SGMII AN is
+=09 *    immediately retriggered.
+=09 * 3) Other conditions such as PHY is down, speed change etc, skip
+=09 *    retriggering SGMII AN. Note: in case of speed change, GPY FW will
+=09 *    initiate SGMII AN.
+=09 */
+
+=09if (phydev->state !=3D PHY_UP)
+=09=09return 0;
+
+=09ret =3D phy_read_poll_timeout(phydev, MII_BMSR, ret, ret & BMSR_LSTATUS=
,
+=09=09=09=09    20000, 4000000, false);
+=09if (ret =3D=3D -ETIMEDOUT)
+=09=09return 0;
+=09else if (ret < 0)
+=09=09return ret;
+
+=09/* Trigger SGMII AN. */
+=09return phy_modify_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_SGMII_CTRL,
+=09=09=09      VSPEC1_SGMII_CTRL_ANRS, VSPEC1_SGMII_CTRL_ANRS);
+}
+
+static void gpy_update_interface(struct phy_device *phydev)
+{
+=09int ret;
+
+=09/* Interface mode is fixed for USXGMII and integrated PHY */
+=09if (phydev->interface =3D=3D PHY_INTERFACE_MODE_USXGMII ||
+=09    phydev->interface =3D=3D PHY_INTERFACE_MODE_INTERNAL)
+=09=09return;
+
+=09/* Automatically switch SERDES interface between SGMII and 2500-BaseX
+=09 * according to speed. Disable ANEG in 2500-BaseX mode.
+=09 */
+=09switch (phydev->speed) {
+=09case SPEED_2500:
+=09=09phydev->interface =3D PHY_INTERFACE_MODE_2500BASEX;
+=09=09ret =3D phy_modify_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_SGMII_CTRL,
+=09=09=09=09     VSPEC1_SGMII_CTRL_ANEN, 0);
+=09=09if (ret < 0)
+=09=09=09phydev_err(phydev,
+=09=09=09=09   "Error: Disable of SGMII ANEG failed: %d\n",
+=09=09=09=09   ret);
+=09=09break;
+=09case SPEED_1000:
+=09case SPEED_100:
+=09case SPEED_10:
+=09=09phydev->interface =3D PHY_INTERFACE_MODE_SGMII;
+=09=09if (gpy_sgmii_aneg_en(phydev))
+=09=09=09break;
+=09=09/* Enable and restart SGMII ANEG for 10/100/1000Mbps link speed
+=09=09 * if ANEG is disabled (in 2500-BaseX mode).
+=09=09 */
+=09=09ret =3D phy_modify_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_SGMII_CTRL,
+=09=09=09=09     VSPEC1_SGMII_ANEN_ANRS,
+=09=09=09=09     VSPEC1_SGMII_ANEN_ANRS);
+=09=09if (ret < 0)
+=09=09=09phydev_err(phydev,
+=09=09=09=09   "Error: Enable of SGMII ANEG failed: %d\n",
+=09=09=09=09   ret);
+=09=09break;
+=09}
+}
+
+static int gpy_read_status(struct phy_device *phydev)
+{
+=09int ret;
+
+=09ret =3D genphy_update_link(phydev);
+=09if (ret)
+=09=09return ret;
+
+=09phydev->speed =3D SPEED_UNKNOWN;
+=09phydev->duplex =3D DUPLEX_UNKNOWN;
+=09phydev->pause =3D 0;
+=09phydev->asym_pause =3D 0;
+
+=09if (phydev->autoneg =3D=3D AUTONEG_ENABLE && phydev->autoneg_complete) =
{
+=09=09ret =3D genphy_c45_read_lpa(phydev);
+=09=09if (ret < 0)
+=09=09=09return ret;
+
+=09=09/* Read the link partner's 1G advertisement */
+=09=09ret =3D phy_read(phydev, MII_STAT1000);
+=09=09if (ret < 0)
+=09=09=09return ret;
+=09=09mii_stat1000_mod_linkmode_lpa_t(phydev->lp_advertising, ret);
+=09} else if (phydev->autoneg =3D=3D AUTONEG_DISABLE) {
+=09=09linkmode_zero(phydev->lp_advertising);
+=09}
+
+=09ret =3D phy_read(phydev, PHY_MIISTAT);
+=09if (ret < 0)
+=09=09return ret;
+
+=09phydev->link =3D (ret & PHY_MIISTAT_LS) ? 1 : 0;
+=09phydev->duplex =3D (ret & PHY_MIISTAT_DPX) ? DUPLEX_FULL : DUPLEX_HALF;
+=09switch (FIELD_GET(PHY_MIISTAT_SPD_MASK, ret)) {
+=09case PHY_MIISTAT_SPD_10:
+=09=09phydev->speed =3D SPEED_10;
+=09=09break;
+=09case PHY_MIISTAT_SPD_100:
+=09=09phydev->speed =3D SPEED_100;
+=09=09break;
+=09case PHY_MIISTAT_SPD_1000:
+=09=09phydev->speed =3D SPEED_1000;
+=09=09break;
+=09case PHY_MIISTAT_SPD_2500:
+=09=09phydev->speed =3D SPEED_2500;
+=09=09break;
+=09}
+
+=09if (phydev->link)
+=09=09gpy_update_interface(phydev);
+
+=09return 0;
+}
+
+static int gpy_config_intr(struct phy_device *phydev)
+{
+=09u16 mask =3D 0;
+
+=09if (phydev->interrupts =3D=3D PHY_INTERRUPT_ENABLED)
+=09=09mask =3D PHY_IMASK_MASK;
+
+=09return phy_write(phydev, PHY_IMASK, mask);
+}
+
+static irqreturn_t gpy_handle_interrupt(struct phy_device *phydev)
+{
+=09int reg;
+
+=09reg =3D phy_read(phydev, PHY_ISTAT);
+=09if (reg < 0) {
+=09=09phy_error(phydev);
+=09=09return IRQ_NONE;
+=09}
+
+=09if (!(reg & PHY_IMASK_MASK))
+=09=09return IRQ_NONE;
+
+=09phy_trigger_machine(phydev);
+
+=09return IRQ_HANDLED;
+}
+
+static int gpy_set_wol(struct phy_device *phydev,
+=09=09       struct ethtool_wolinfo *wol)
+{
+=09struct net_device *attach_dev =3D phydev->attached_dev;
+=09int ret;
+
+=09if (wol->wolopts & WAKE_MAGIC) {
+=09=09/* MAC address - Byte0:Byte1:Byte2:Byte3:Byte4:Byte5
+=09=09 * VPSPEC2_WOL_AD45 =3D Byte0:Byte1
+=09=09 * VPSPEC2_WOL_AD23 =3D Byte2:Byte3
+=09=09 * VPSPEC2_WOL_AD01 =3D Byte4:Byte5
+=09=09 */
+=09=09ret =3D phy_set_bits_mmd(phydev, MDIO_MMD_VEND2,
+=09=09=09=09       VPSPEC2_WOL_AD45,
+=09=09=09=09       ((attach_dev->dev_addr[0] << 8) |
+=09=09=09=09       attach_dev->dev_addr[1]));
+=09=09if (ret < 0)
+=09=09=09return ret;
+
+=09=09ret =3D phy_set_bits_mmd(phydev, MDIO_MMD_VEND2,
+=09=09=09=09       VPSPEC2_WOL_AD23,
+=09=09=09=09       ((attach_dev->dev_addr[2] << 8) |
+=09=09=09=09       attach_dev->dev_addr[3]));
+=09=09if (ret < 0)
+=09=09=09return ret;
+
+=09=09ret =3D phy_set_bits_mmd(phydev, MDIO_MMD_VEND2,
+=09=09=09=09       VPSPEC2_WOL_AD01,
+=09=09=09=09       ((attach_dev->dev_addr[4] << 8) |
+=09=09=09=09       attach_dev->dev_addr[5]));
+=09=09if (ret < 0)
+=09=09=09return ret;
+
+=09=09/* Enable the WOL interrupt */
+=09=09ret =3D phy_write(phydev, PHY_IMASK, PHY_IMASK_WOL);
+=09=09if (ret < 0)
+=09=09=09return ret;
+
+=09=09/* Enable magic packet matching */
+=09=09ret =3D phy_set_bits_mmd(phydev, MDIO_MMD_VEND2,
+=09=09=09=09       VPSPEC2_WOL_CTL,
+=09=09=09=09       WOL_EN);
+=09=09if (ret < 0)
+=09=09=09return ret;
+
+=09=09/* Clear the interrupt status register.
+=09=09 * Only WoL is enabled so clear all.
+=09=09 */
+=09=09ret =3D phy_read(phydev, PHY_ISTAT);
+=09=09if (ret < 0)
+=09=09=09return ret;
+=09} else {
+=09=09/* Disable magic packet matching */
+=09=09ret =3D phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2,
+=09=09=09=09=09 VPSPEC2_WOL_CTL,
+=09=09=09=09=09 WOL_EN);
+=09=09if (ret < 0)
+=09=09=09return ret;
+=09}
+
+=09if (wol->wolopts & WAKE_PHY) {
+=09=09/* Enable the link state change interrupt */
+=09=09ret =3D phy_set_bits(phydev, PHY_IMASK, PHY_IMASK_LSTC);
+=09=09if (ret < 0)
+=09=09=09return ret;
+
+=09=09/* Clear the interrupt status register */
+=09=09ret =3D phy_read(phydev, PHY_ISTAT);
+=09=09if (ret < 0)
+=09=09=09return ret;
+
+=09=09if (ret & (PHY_IMASK_MASK & ~PHY_IMASK_LSTC))
+=09=09=09phy_trigger_machine(phydev);
+
+=09=09return 0;
+=09}
+
+=09/* Disable the link state change interrupt */
+=09return phy_clear_bits(phydev, PHY_IMASK, PHY_IMASK_LSTC);
+}
+
+static void gpy_get_wol(struct phy_device *phydev,
+=09=09=09struct ethtool_wolinfo *wol)
+{
+=09int ret;
+
+=09wol->supported =3D WAKE_MAGIC | WAKE_PHY;
+=09wol->wolopts =3D 0;
+
+=09ret =3D phy_read_mmd(phydev, MDIO_MMD_VEND2, VPSPEC2_WOL_CTL);
+=09if (ret & WOL_EN)
+=09=09wol->wolopts |=3D WAKE_MAGIC;
+
+=09ret =3D phy_read(phydev, PHY_IMASK);
+=09if (ret & PHY_IMASK_LSTC)
+=09=09wol->wolopts |=3D WAKE_PHY;
+}
+
+static int gpy_loopback(struct phy_device *phydev, bool enable)
+{
+=09int ret;
+
+=09ret =3D phy_modify(phydev, MII_BMCR, BMCR_LOOPBACK,
+=09=09=09 enable ? BMCR_LOOPBACK : 0);
+=09if (!ret) {
+=09=09/* It takes some time for PHY device to switch
+=09=09 * into/out-of loopback mode.
+=09=09 */
+=09=09msleep(100);
+=09}
+
+=09return ret;
+}
+
+static struct phy_driver gpy_drivers[] =3D {
+=09{
+=09=09PHY_ID_MATCH_MODEL(PHY_ID_GPY2xx),
+=09=09.name=09=09=3D "Maxlinear Ethernet GPY2xx",
+=09=09.get_features=09=3D genphy_c45_pma_read_abilities,
+=09=09.config_init=09=3D gpy_config_init,
+=09=09.probe=09=09=3D gpy_probe,
+=09=09.suspend=09=3D genphy_suspend,
+=09=09.resume=09=09=3D genphy_resume,
+=09=09.config_aneg=09=3D gpy_config_aneg,
+=09=09.aneg_done=09=3D genphy_c45_aneg_done,
+=09=09.read_status=09=3D gpy_read_status,
+=09=09.config_intr=09=3D gpy_config_intr,
+=09=09.handle_interrupt =3D gpy_handle_interrupt,
+=09=09.set_wol=09=3D gpy_set_wol,
+=09=09.get_wol=09=3D gpy_get_wol,
+=09=09.set_loopback=09=3D gpy_loopback,
+=09},
+=09{
+=09=09.phy_id=09=09=3D PHY_ID_GPY115B,
+=09=09.phy_id_mask=09=3D PHY_ID_GPYx15B_MASK,
+=09=09.name=09=09=3D "Maxlinear Ethernet GPY115B",
+=09=09.get_features=09=3D genphy_c45_pma_read_abilities,
+=09=09.config_init=09=3D gpy_config_init,
+=09=09.probe=09=09=3D gpy_probe,
+=09=09.suspend=09=3D genphy_suspend,
+=09=09.resume=09=09=3D genphy_resume,
+=09=09.config_aneg=09=3D gpy_config_aneg,
+=09=09.aneg_done=09=3D genphy_c45_aneg_done,
+=09=09.read_status=09=3D gpy_read_status,
+=09=09.config_intr=09=3D gpy_config_intr,
+=09=09.handle_interrupt =3D gpy_handle_interrupt,
+=09=09.set_wol=09=3D gpy_set_wol,
+=09=09.get_wol=09=3D gpy_get_wol,
+=09=09.set_loopback=09=3D gpy_loopback,
+=09},
+=09{
+=09=09PHY_ID_MATCH_MODEL(PHY_ID_GPY115C),
+=09=09.name=09=09=3D "Maxlinear Ethernet GPY115C",
+=09=09.get_features=09=3D genphy_c45_pma_read_abilities,
+=09=09.config_init=09=3D gpy_config_init,
+=09=09.probe=09=09=3D gpy_probe,
+=09=09.suspend=09=3D genphy_suspend,
+=09=09.resume=09=09=3D genphy_resume,
+=09=09.config_aneg=09=3D gpy_config_aneg,
+=09=09.aneg_done=09=3D genphy_c45_aneg_done,
+=09=09.read_status=09=3D gpy_read_status,
+=09=09.config_intr=09=3D gpy_config_intr,
+=09=09.handle_interrupt =3D gpy_handle_interrupt,
+=09=09.set_wol=09=3D gpy_set_wol,
+=09=09.get_wol=09=3D gpy_get_wol,
+=09=09.set_loopback=09=3D gpy_loopback,
+=09},
+=09{
+=09=09.phy_id=09=09=3D PHY_ID_GPY211B,
+=09=09.phy_id_mask=09=3D PHY_ID_GPY21xB_MASK,
+=09=09.name=09=09=3D "Maxlinear Ethernet GPY211B",
+=09=09.get_features=09=3D genphy_c45_pma_read_abilities,
+=09=09.config_init=09=3D gpy_config_init,
+=09=09.probe=09=09=3D gpy_probe,
+=09=09.suspend=09=3D genphy_suspend,
+=09=09.resume=09=09=3D genphy_resume,
+=09=09.config_aneg=09=3D gpy_config_aneg,
+=09=09.aneg_done=09=3D genphy_c45_aneg_done,
+=09=09.read_status=09=3D gpy_read_status,
+=09=09.config_intr=09=3D gpy_config_intr,
+=09=09.handle_interrupt =3D gpy_handle_interrupt,
+=09=09.set_wol=09=3D gpy_set_wol,
+=09=09.get_wol=09=3D gpy_get_wol,
+=09=09.set_loopback=09=3D gpy_loopback,
+=09},
+=09{
+=09=09PHY_ID_MATCH_MODEL(PHY_ID_GPY211C),
+=09=09.name=09=09=3D "Maxlinear Ethernet GPY211C",
+=09=09.get_features=09=3D genphy_c45_pma_read_abilities,
+=09=09.config_init=09=3D gpy_config_init,
+=09=09.probe=09=09=3D gpy_probe,
+=09=09.suspend=09=3D genphy_suspend,
+=09=09.resume=09=09=3D genphy_resume,
+=09=09.config_aneg=09=3D gpy_config_aneg,
+=09=09.aneg_done=09=3D genphy_c45_aneg_done,
+=09=09.read_status=09=3D gpy_read_status,
+=09=09.config_intr=09=3D gpy_config_intr,
+=09=09.handle_interrupt =3D gpy_handle_interrupt,
+=09=09.set_wol=09=3D gpy_set_wol,
+=09=09.get_wol=09=3D gpy_get_wol,
+=09=09.set_loopback=09=3D gpy_loopback,
+=09},
+=09{
+=09=09.phy_id=09=09=3D PHY_ID_GPY212B,
+=09=09.phy_id_mask=09=3D PHY_ID_GPY21xB_MASK,
+=09=09.name=09=09=3D "Maxlinear Ethernet GPY212B",
+=09=09.get_features=09=3D genphy_c45_pma_read_abilities,
+=09=09.config_init=09=3D gpy_config_init,
+=09=09.probe=09=09=3D gpy_probe,
+=09=09.suspend=09=3D genphy_suspend,
+=09=09.resume=09=09=3D genphy_resume,
+=09=09.config_aneg=09=3D gpy_config_aneg,
+=09=09.aneg_done=09=3D genphy_c45_aneg_done,
+=09=09.read_status=09=3D gpy_read_status,
+=09=09.config_intr=09=3D gpy_config_intr,
+=09=09.handle_interrupt =3D gpy_handle_interrupt,
+=09=09.set_wol=09=3D gpy_set_wol,
+=09=09.get_wol=09=3D gpy_get_wol,
+=09=09.set_loopback=09=3D gpy_loopback,
+=09},
+=09{
+=09=09PHY_ID_MATCH_MODEL(PHY_ID_GPY212C),
+=09=09.name=09=09=3D "Maxlinear Ethernet GPY212C",
+=09=09.get_features=09=3D genphy_c45_pma_read_abilities,
+=09=09.config_init=09=3D gpy_config_init,
+=09=09.probe=09=09=3D gpy_probe,
+=09=09.suspend=09=3D genphy_suspend,
+=09=09.resume=09=09=3D genphy_resume,
+=09=09.config_aneg=09=3D gpy_config_aneg,
+=09=09.aneg_done=09=3D genphy_c45_aneg_done,
+=09=09.read_status=09=3D gpy_read_status,
+=09=09.config_intr=09=3D gpy_config_intr,
+=09=09.handle_interrupt =3D gpy_handle_interrupt,
+=09=09.set_wol=09=3D gpy_set_wol,
+=09=09.get_wol=09=3D gpy_get_wol,
+=09=09.set_loopback=09=3D gpy_loopback,
+=09},
+=09{
+=09=09.phy_id=09=09=3D PHY_ID_GPY215B,
+=09=09.phy_id_mask=09=3D PHY_ID_GPYx15B_MASK,
+=09=09.name=09=09=3D "Maxlinear Ethernet GPY215B",
+=09=09.get_features=09=3D genphy_c45_pma_read_abilities,
+=09=09.config_init=09=3D gpy_config_init,
+=09=09.probe=09=09=3D gpy_probe,
+=09=09.suspend=09=3D genphy_suspend,
+=09=09.resume=09=09=3D genphy_resume,
+=09=09.config_aneg=09=3D gpy_config_aneg,
+=09=09.aneg_done=09=3D genphy_c45_aneg_done,
+=09=09.read_status=09=3D gpy_read_status,
+=09=09.config_intr=09=3D gpy_config_intr,
+=09=09.handle_interrupt =3D gpy_handle_interrupt,
+=09=09.set_wol=09=3D gpy_set_wol,
+=09=09.get_wol=09=3D gpy_get_wol,
+=09=09.set_loopback=09=3D gpy_loopback,
+=09},
+=09{
+=09=09PHY_ID_MATCH_MODEL(PHY_ID_GPY215C),
+=09=09.name=09=09=3D "Maxlinear Ethernet GPY215C",
+=09=09.get_features=09=3D genphy_c45_pma_read_abilities,
+=09=09.config_init=09=3D gpy_config_init,
+=09=09.probe=09=09=3D gpy_probe,
+=09=09.suspend=09=3D genphy_suspend,
+=09=09.resume=09=09=3D genphy_resume,
+=09=09.config_aneg=09=3D gpy_config_aneg,
+=09=09.aneg_done=09=3D genphy_c45_aneg_done,
+=09=09.read_status=09=3D gpy_read_status,
+=09=09.config_intr=09=3D gpy_config_intr,
+=09=09.handle_interrupt =3D gpy_handle_interrupt,
+=09=09.set_wol=09=3D gpy_set_wol,
+=09=09.get_wol=09=3D gpy_get_wol,
+=09=09.set_loopback=09=3D gpy_loopback,
+=09},
+};
+module_phy_driver(gpy_drivers);
+
+static struct mdio_device_id __maybe_unused gpy_tbl[] =3D {
+=09{PHY_ID_MATCH_MODEL(PHY_ID_GPY2xx)},
+=09{PHY_ID_GPY115B, PHY_ID_GPYx15B_MASK},
+=09{PHY_ID_MATCH_MODEL(PHY_ID_GPY115C)},
+=09{PHY_ID_GPY211B, PHY_ID_GPY21xB_MASK},
+=09{PHY_ID_MATCH_MODEL(PHY_ID_GPY211C)},
+=09{PHY_ID_GPY212B, PHY_ID_GPY21xB_MASK},
+=09{PHY_ID_MATCH_MODEL(PHY_ID_GPY212C)},
+=09{PHY_ID_GPY215B, PHY_ID_GPYx15B_MASK},
+=09{PHY_ID_MATCH_MODEL(PHY_ID_GPY215C)},
+=09{ }
+};
+MODULE_DEVICE_TABLE(mdio, gpy_tbl);
+
+MODULE_DESCRIPTION("Maxlinear Ethernet GPY Driver");
+MODULE_AUTHOR("Xu Liang");
+MODULE_LICENSE("GPL");
--=20
2.17.1

