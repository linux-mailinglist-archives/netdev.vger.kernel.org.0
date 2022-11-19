Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D43C96311D6
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 00:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235301AbiKSXKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 18:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235377AbiKSXJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 18:09:58 -0500
Received: from mail-40134.protonmail.ch (mail-40134.protonmail.ch [185.70.40.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47528101FC;
        Sat, 19 Nov 2022 15:09:57 -0800 (PST)
Date:   Sat, 19 Nov 2022 23:09:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail3; t=1668899395; x=1669158595;
        bh=wNP0UQpU7yrDZr4V2xlMMmH7hWXhkAKdC5HFrg14b2U=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=TdhooLtYMTOiXSgX6a8vur7U8YSfc54R+aNkyLrZOxGhW9ZmtfU2kNxaQOmVntH5M
         RaFWicXh4WLlwJG9nmjBzB2F0cFaqn8BIIKyCUGv/leCqern8weFAm0prQk5TEMji/
         qpwLjthLgEeDPTus9GXPDGf+Mz2eE4Q32y5S6KxXvsSHmjn2i34UjgegVmBRo5B7mu
         V9IvBd9WD/RDTR7XV8B121h4KfQI/Zqlx1h6izDtKhhhgoO6NH6aEgbxDLUQt0kEOB
         7fuYsxpgTk8poLjQMJnSY0wit5xC1Lc+taQrCH6InXHhoJocSMB4GKTeMAbUZSAozo
         jTSk3B04DZlXg==
To:     linux-kbuild@vger.kernel.org
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Derek Chickles <dchickles@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Daniel Scally <djrscally@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/18] net: dpaa2: fix mixed module-builtin object
Message-ID: <20221119225650.1044591-16-alobakin@pm.me>
In-Reply-To: <20221119225650.1044591-1-alobakin@pm.me>
References: <20221119225650.1044591-1-alobakin@pm.me>
Feedback-ID: 22809121:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With CONFIG_FSL_DPAA2_ETH=3Dm and CONFIG_FSL_DPAA2_SWITCH=3Dy (or vice
versa), dpaa2-mac.o and dpmac.o are linked to a module and also to
vmlinux even though the expected CFLAGS are different between
builtins and modules.
This is the same situation as fixed by
commit 637a642f5ca5 ("zstd: Fixing mixed module-builtin objects").
There's also no need to duplicate relatively big piece of object
code into two modules.

Introduce the new module, fsl-dpaa2-mac, to provide the common
functions to both fsl-dpaa2-eth and fsl-dpaa2-switch.

Misc: constify and shrink @dpaa2_mac_ethtool_stats while at it.

Fixes: 84cba72956fd ("dpaa2-switch: integrate the MAC endpoint support")
Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 drivers/net/ethernet/freescale/dpaa2/Kconfig      |  6 ++++++
 drivers/net/ethernet/freescale/dpaa2/Makefile     |  6 ++++--
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  2 ++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 15 ++++++++++++++-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c   |  2 ++
 5 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/Kconfig b/drivers/net/eth=
ernet/freescale/dpaa2/Kconfig
index d029b69c3f18..54c388f25c43 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Kconfig
+++ b/drivers/net/ethernet/freescale/dpaa2/Kconfig
@@ -1,7 +1,12 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+config FSL_DPAA2_MAC
+=09tristate
+
 config FSL_DPAA2_ETH
 =09tristate "Freescale DPAA2 Ethernet"
 =09depends on FSL_MC_BUS && FSL_MC_DPIO
+=09select FSL_DPAA2_MAC
 =09select PHYLINK
 =09select PCS_LYNX
 =09select FSL_XGMAC_MDIO
@@ -34,6 +39,7 @@ config FSL_DPAA2_SWITCH
 =09tristate "Freescale DPAA2 Ethernet Switch"
 =09depends on BRIDGE || BRIDGE=3Dn
 =09depends on NET_SWITCHDEV
+=09select FSL_DPAA2_MAC
 =09help
 =09  Driver for Freescale DPAA2 Ethernet Switch. This driver manages
 =09  switch objects discovered on the Freeescale MC bus.
diff --git a/drivers/net/ethernet/freescale/dpaa2/Makefile b/drivers/net/et=
hernet/freescale/dpaa2/Makefile
index 3d9842af7f10..9dbe2273c9a1 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Makefile
+++ b/drivers/net/ethernet/freescale/dpaa2/Makefile
@@ -4,14 +4,16 @@
 #

 obj-$(CONFIG_FSL_DPAA2_ETH)=09=09+=3D fsl-dpaa2-eth.o
+obj-$(CONFIG_FSL_DPAA2_MAC)=09=09+=3D fsl-dpaa2-mac.o
 obj-$(CONFIG_FSL_DPAA2_PTP_CLOCK)=09+=3D fsl-dpaa2-ptp.o
 obj-$(CONFIG_FSL_DPAA2_SWITCH)=09=09+=3D fsl-dpaa2-switch.o

-fsl-dpaa2-eth-objs=09:=3D dpaa2-eth.o dpaa2-ethtool.o dpni.o dpaa2-mac.o d=
pmac.o dpaa2-eth-devlink.o
+fsl-dpaa2-eth-objs=09:=3D dpaa2-eth.o dpaa2-ethtool.o dpni.o dpaa2-eth-dev=
link.o
 fsl-dpaa2-eth-${CONFIG_FSL_DPAA2_ETH_DCB} +=3D dpaa2-eth-dcb.o
 fsl-dpaa2-eth-${CONFIG_DEBUG_FS} +=3D dpaa2-eth-debugfs.o
+fsl-dpaa2-mac-objs=09:=3D dpaa2-mac.o dpmac.o
 fsl-dpaa2-ptp-objs=09:=3D dpaa2-ptp.o dprtc.o
-fsl-dpaa2-switch-objs=09:=3D dpaa2-switch.o dpaa2-switch-ethtool.o dpsw.o =
dpaa2-switch-flower.o dpaa2-mac.o dpmac.o
+fsl-dpaa2-switch-objs=09:=3D dpaa2-switch.o dpaa2-switch-ethtool.o dpsw.o =
dpaa2-switch-flower.o

 # Needed by the tracing framework
 CFLAGS_dpaa2-eth.o :=3D -I$(src)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net=
/ethernet/freescale/dpaa2/dpaa2-eth.c
index 8d029addddad..876c3ed6e2c5 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -28,6 +28,8 @@
 #define CREATE_TRACE_POINTS
 #include "dpaa2-eth-trace.h"

+MODULE_IMPORT_NS(FSL_DPAA2_MAC);
+
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Freescale Semiconductor, Inc");
 MODULE_DESCRIPTION("Freescale DPAA2 Ethernet Driver");
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net=
/ethernet/freescale/dpaa2/dpaa2-mac.c
index 49ff85633783..dc2c7cde5435 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -339,12 +339,14 @@ void dpaa2_mac_start(struct dpaa2_mac *mac)
 =09if (mac->serdes_phy)
 =09=09phy_power_on(mac->serdes_phy);
 }
+EXPORT_SYMBOL_NS_GPL(dpaa2_mac_start, FSL_DPAA2_MAC);

 void dpaa2_mac_stop(struct dpaa2_mac *mac)
 {
 =09if (mac->serdes_phy)
 =09=09phy_power_off(mac->serdes_phy);
 }
+EXPORT_SYMBOL_NS_GPL(dpaa2_mac_stop, FSL_DPAA2_MAC);

 int dpaa2_mac_connect(struct dpaa2_mac *mac)
 {
@@ -435,6 +437,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)

 =09return err;
 }
+EXPORT_SYMBOL_NS_GPL(dpaa2_mac_connect, FSL_DPAA2_MAC);

 void dpaa2_mac_disconnect(struct dpaa2_mac *mac)
 {
@@ -447,6 +450,7 @@ void dpaa2_mac_disconnect(struct dpaa2_mac *mac)
 =09of_phy_put(mac->serdes_phy);
 =09mac->serdes_phy =3D NULL;
 }
+EXPORT_SYMBOL_NS_GPL(dpaa2_mac_disconnect, FSL_DPAA2_MAC);

 int dpaa2_mac_open(struct dpaa2_mac *mac)
 {
@@ -495,6 +499,7 @@ int dpaa2_mac_open(struct dpaa2_mac *mac)
 =09dpmac_close(mac->mc_io, 0, dpmac_dev->mc_handle);
 =09return err;
 }
+EXPORT_SYMBOL_NS_GPL(dpaa2_mac_open, FSL_DPAA2_MAC);

 void dpaa2_mac_close(struct dpaa2_mac *mac)
 {
@@ -504,8 +509,9 @@ void dpaa2_mac_close(struct dpaa2_mac *mac)
 =09if (mac->fw_node)
 =09=09fwnode_handle_put(mac->fw_node);
 }
+EXPORT_SYMBOL_NS_GPL(dpaa2_mac_close, FSL_DPAA2_MAC);

-static char dpaa2_mac_ethtool_stats[][ETH_GSTRING_LEN] =3D {
+static const char * const dpaa2_mac_ethtool_stats[] =3D {
 =09[DPMAC_CNT_ING_ALL_FRAME]=09=09=3D "[mac] rx all frames",
 =09[DPMAC_CNT_ING_GOOD_FRAME]=09=09=3D "[mac] rx frames ok",
 =09[DPMAC_CNT_ING_ERR_FRAME]=09=09=3D "[mac] rx frame errors",
@@ -542,6 +548,7 @@ int dpaa2_mac_get_sset_count(void)
 {
 =09return DPAA2_MAC_NUM_STATS;
 }
+EXPORT_SYMBOL_NS_GPL(dpaa2_mac_get_sset_count, FSL_DPAA2_MAC);

 void dpaa2_mac_get_strings(u8 *data)
 {
@@ -553,6 +560,7 @@ void dpaa2_mac_get_strings(u8 *data)
 =09=09p +=3D ETH_GSTRING_LEN;
 =09}
 }
+EXPORT_SYMBOL_NS_GPL(dpaa2_mac_get_strings, FSL_DPAA2_MAC);

 void dpaa2_mac_get_ethtool_stats(struct dpaa2_mac *mac, u64 *data)
 {
@@ -572,3 +580,8 @@ void dpaa2_mac_get_ethtool_stats(struct dpaa2_mac *mac,=
 u64 *data)
 =09=09*(data + i) =3D value;
 =09}
 }
+EXPORT_SYMBOL_NS_GPL(dpaa2_mac_get_ethtool_stats, FSL_DPAA2_MAC);
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_AUTHOR("Freescale Semiconductor, Inc");
+MODULE_DESCRIPTION("Freescale DPAA2 MAC Driver");
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/=
net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 2b5909fa93cf..fccbaf75b512 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -3534,5 +3534,7 @@ static void __exit dpaa2_switch_driver_exit(void)
 module_init(dpaa2_switch_driver_init);
 module_exit(dpaa2_switch_driver_exit);

+MODULE_IMPORT_NS(FSL_DPAA2_MAC);
+
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("DPAA2 Ethernet Switch Driver");
--
2.38.1


