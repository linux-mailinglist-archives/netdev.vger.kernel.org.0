Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43FF399BAA
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 09:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhFCHgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 03:36:53 -0400
Received: from us-smtp-delivery-115.mimecast.com ([216.205.24.115]:38698 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229707AbhFCHgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 03:36:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1622705707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=nqnw4cRvTgCcXUuFr1aIwq1YWegUL5K00qtMgraz/ZU=;
        b=jwPg6sIP38UQZkg6y/Ij4OQDHkDp98tG1YfxkqRrVuUOx+fGeijtpdxcRBUPDwI7a3CJ53
        WQwGv4qZVczv1jRFXhmGOL0AvRWMFJurwcDswRawJOViUOoeL71HMd8KxeAS1kHrZsFmOc
        D/VUlUDFEDYYiXNYym6yosN3VeLM0Yg=
Received: from mail.maxlinear.com (174-47-1-83.static.ctl.one [174.47.1.83])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-Rh1pFnGKNxuraVMs_OtXHA-1; Thu, 03 Jun 2021 03:35:05 -0400
X-MC-Unique: Rh1pFnGKNxuraVMs_OtXHA-1
Received: from sgsxdev002.isng.phoenix.local (10.226.81.112) by
 mail.maxlinear.com (10.23.38.120) with Microsoft SMTP Server id 15.1.2242.4;
 Thu, 3 Jun 2021 00:35:00 -0700
From:   Xu Liang <lxu@maxlinear.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <vee.khee.wong@linux.intel.com>
CC:     <linux@armlinux.org.uk>, <hmehrtens@maxlinear.com>,
        <tmohren@maxlinear.com>, Xu Liang <lxu@maxlinear.com>
Subject: [PATCH v2] net: phy: add Maxlinear GPY115/21x/24x driver
Date:   Thu, 3 Jun 2021 15:34:38 +0800
Message-ID: <20210603073438.33967-1-lxu@maxlinear.com>
X-Mailer: git-send-email 2.17.1
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
GPY241, GPY245 PHYs.

Signed-off-by: Xu Liang <lxu@maxlinear.com>
---
v2 changes:
 Fix format warning from checkpath and some comments.
 Use smaller PHY ID mask.
 Split FWV register mask.
 Call phy_trigger_machine if necessary when clear interrupt.

 MAINTAINERS               |   6 +
 drivers/net/phy/Kconfig   |   6 +
 drivers/net/phy/Makefile  |   1 +
 drivers/net/phy/mxl-gpy.c | 545 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 558 insertions(+)
 create mode 100644 drivers/net/phy/mxl-gpy.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 673cadd5107a..9346e6357960 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11167,6 +11167,12 @@ W:=09https://linuxtv.org
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
index 288bf405ebdb..d02098774d80 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -207,6 +207,12 @@ config MARVELL_88X2222_PHY
 =09  Support for the Marvell 88X2222 Dual-port Multi-speed Ethernet
 =09  Transceiver.
=20
+config MXL_GPHY
+=09tristate "Maxlinear PHYs"
+=09help
+=09  Support for the Maxlinear GPY115, GPY211, GPY212, GPY215,
+=09  GPY241, GPY245 PHYs.
+
 config MICREL_PHY
 =09tristate "Micrel PHYs"
 =09help
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index bcda7ed2455d..70efab3659ee 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -70,6 +70,7 @@ obj-$(CONFIG_MICREL_PHY)=09+=3D micrel.o
 obj-$(CONFIG_MICROCHIP_PHY)=09+=3D microchip.o
 obj-$(CONFIG_MICROCHIP_T1_PHY)=09+=3D microchip_t1.o
 obj-$(CONFIG_MICROSEMI_PHY)=09+=3D mscc/
+obj-$(CONFIG_MXL_GPHY)          +=3D mxl-gpy.o
 obj-$(CONFIG_NATIONAL_PHY)=09+=3D national.o
 obj-$(CONFIG_NXP_C45_TJA11XX_PHY)=09+=3D nxp-c45-tja11xx.o
 obj-$(CONFIG_NXP_TJA11XX_PHY)=09+=3D nxp-tja11xx.o
diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
new file mode 100644
index 000000000000..350ad3c610f7
--- /dev/null
+++ b/drivers/net/phy/mxl-gpy.c
@@ -0,0 +1,545 @@
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
+#define PHY_ID_GPY=09=090x67C9DC00
+#define PHY_ID_MASK=09=09GENMASK(31, 4)
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
+/* ANEG dev */
+#define ANEG_MGBT_AN_CTRL=090x20
+#define ANEG_MGBT_AN_STAT=090x21
+#define CTRL_AB_2G5BT_BIT=09BIT(7)
+#define CTRL_AB_FR_2G5BT=09BIT(5)
+#define STAT_AB_2G5BT_BIT=09BIT(5)
+#define STAT_AB_FR_2G5BT=09BIT(3)
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
+static int gpy_read_abilities(struct phy_device *phydev)
+{
+=09int ret;
+
+=09ret =3D genphy_read_abilities(phydev);
+=09if (ret < 0)
+=09=09return ret;
+
+=09/* Detect 2.5G/5G support. */
+=09ret =3D phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_STAT2);
+=09if (ret < 0)
+=09=09return ret;
+=09if (!(ret & MDIO_PMA_STAT2_EXTABLE))
+=09=09return 0;
+
+=09ret =3D phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_EXTABLE);
+=09if (ret < 0)
+=09=09return ret;
+=09if (!(ret & MDIO_PMA_EXTABLE_NBT))
+=09=09return 0;
+
+=09ret =3D phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_NG_EXTABLE);
+=09if (ret < 0)
+=09=09return ret;
+
+=09linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
+=09=09=09 phydev->supported,
+=09=09=09 ret & MDIO_PMA_NG_EXTABLE_2_5GBT);
+
+=09linkmode_mod_bit(ETHTOOL_LINK_MODE_5000baseT_Full_BIT,
+=09=09=09 phydev->supported,
+=09=09=09 ret & MDIO_PMA_NG_EXTABLE_5GBT);
+
+=09return 0;
+}
+
+static int gpy_config_init(struct phy_device *phydev)
+{
+=09int ret, fw_ver;
+
+=09/* Show GPY PHY FW version in dmesg */
+=09fw_ver =3D phy_read(phydev, PHY_FWV);
+=09if (fw_ver < 0)
+=09=09return fw_ver;
+
+=09phydev_info(phydev, "Firmware Version: 0x%04X (%s)\n", fw_ver,
+=09=09    (fw_ver & PHY_FWV_REL_MASK) ? "release" : "test");
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
+=09phy_modify_mmd_changed(phydev, MDIO_MMD_VEND1,
+=09=09=09       VSPEC1_SGMII_CTRL,
+=09=09=09       VSPEC1_SGMII_CTRL_ANEN, 0);
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
+=09=09return phydev->duplex !=3D DUPLEX_FULL
+=09=09=09? genphy_setup_forced(phydev)
+=09=09=09: genphy_c45_pma_setup_forced(phydev);
+=09}
+
+=09ret =3D genphy_c45_an_config_aneg(phydev);
+=09if (ret < 0)
+=09=09return ret;
+=09if (ret)
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
+=09/* No need to trigger re-ANEG if SGMII link speed is 2.5G
+=09 * or SGMII ANEG is disabled.
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
+=09return phy_modify_mmd_changed(phydev, MDIO_MMD_VEND1, VSPEC1_SGMII_CTRL=
,
+=09=09=09=09      VSPEC1_SGMII_CTRL_ANRS,
+=09=09=09=09      VSPEC1_SGMII_CTRL_ANRS);
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
+=09=09ret =3D phy_modify_mmd_changed(phydev, MDIO_MMD_VEND1,
+=09=09=09=09=09     VSPEC1_SGMII_CTRL,
+=09=09=09=09=09     VSPEC1_SGMII_CTRL_ANEN, 0);
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
+=09=09ret =3D phy_modify_mmd_changed(phydev, MDIO_MMD_VEND1,
+=09=09=09=09=09     VSPEC1_SGMII_CTRL,
+=09=09=09=09=09     VSPEC1_SGMII_ANEN_ANRS,
+=09=09=09=09=09     VSPEC1_SGMII_ANEN_ANRS);
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
+=09ret =3D genphy_loopback(phydev, enable);
+=09if (!ret) {
+=09=09/* It takes some time for PHY device to switch
+=09=09 * into/out-of loopback mode.
+=09=09 */
+=09=09usleep_range(100, 200);
+=09}
+
+=09return ret;
+}
+
+static struct phy_driver gpy_drivers[] =3D {
+=09{
+=09=09.phy_id=09=09=3D PHY_ID_GPY,
+=09=09.phy_id_mask=09=3D PHY_ID_MASK,
+=09=09.name=09=09=3D "Maxlinear Ethernet GPY",
+=09=09.get_features=09=3D gpy_read_abilities,
+=09=09.config_init=09=3D gpy_config_init,
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
+=09{PHY_ID_GPY, PHY_ID_MASK},
+=09{ }
+};
+MODULE_DEVICE_TABLE(mdio, gpy_tbl);
+
+MODULE_DESCRIPTION("Maxlinear Ethernet GPY Driver");
+MODULE_AUTHOR("Maxlinear Corporation");
+MODULE_LICENSE("GPL");
--=20
2.17.1

