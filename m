Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA9C342129
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 16:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhCSPrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 11:47:12 -0400
Received: from mail-40134.protonmail.ch ([185.70.40.134]:56921 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbhCSPqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 11:46:40 -0400
Date:   Fri, 19 Mar 2021 15:46:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1616168798; bh=CE2JTG3g9f3Lov0MyYvQKYDl57x0SW1lEeVns2U4Wk4=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=JEOy+chxn8OC7fndP2ik3JUcSHBflRoK7nbE4hsasc6RQCMwGojtP4V0JPAjbW/55
         1jyVKwVV0k9qyE6SHuTbpRwzl7ynj3JOdiTE/sqe3vrZaazJ1HFcFFcXgoeJ5mHxyx
         RLaySOEgq6wEyhnUb1gOUdu566Iswrm3H2scatTqO0AiwynhDAOO6EUL+qpVy9iFmi
         Hwh0QO4TJm5+xwQ5O7l7RC5wobzMgQzswKpx7c6ifZZ1xAjVJwyzxjRpU8pKaiInD5
         V3jwpJuG3YKnuUAbL5UP84N2lFLDvgZ3qnK/RhYV5tBY2bm/1p65d4iSQQTqNQrBMG
         geYpnoEqN/05A==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next] dsa: simplify Kconfig symbols and dependencies
Message-ID: <20210319154617.187222-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Remove CONFIG_HAVE_NET_DSA.

CONFIG_HAVE_NET_DSA is a legacy leftover from the times when drivers
should have selected CONFIG_NET_DSA manually.
Currently, all drivers has explicit 'depends on NET_DSA', so this is
no more needed.

2. CONFIG_HAVE_NET_DSA dependencies became CONFIG_NET_DSA's ones.

 - dropped !S390 dependency which was introduced to be sure NET_DSA
   can select CONFIG_PHYLIB. DSA migrated to Phylink almost 3 years
   ago and the PHY library itself doesn't depend on !S390 since
   commit 870a2b5e4fcd ("phylib: remove !S390 dependeny from Kconfig");
 - INET dependency is kept to be sure we can select NET_SWITCHDEV;
 - NETDEVICES dependency is kept to be sure we can select PHYLINK.

3. DSA drivers menu now depends on NET_DSA.

Instead on 'depends on NET_DSA' on every single driver, the entire
menu now depends on it. This eliminates a lot of duplicated lines
from Kconfig with no loss (when CONFIG_NET_DSA=3Dm, drivers also can
be only m or n).
This also has a nice side effect that there's no more empty menu on
configurations without DSA.

4. Kbuild will now descend into 'drivers/net/dsa' only when
   CONFIG_NET_DSA is y or m.

This is safe since no objects inside this folder can be built without
DSA core, as well as when CONFIG_NET_DSA=3Dm, no objects can be
built-in.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 drivers/net/Makefile    |  2 +-
 drivers/net/dsa/Kconfig | 17 ++++-------------
 net/dsa/Kconfig         | 10 +++-------
 3 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index f4990ff32fa4..040e20b81317 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -45,7 +45,7 @@ obj-$(CONFIG_ARCNET) +=3D arcnet/
 obj-$(CONFIG_DEV_APPLETALK) +=3D appletalk/
 obj-$(CONFIG_CAIF) +=3D caif/
 obj-$(CONFIG_CAN) +=3D can/
-obj-y +=3D dsa/
+obj-$(CONFIG_NET_DSA) +=3D dsa/
 obj-$(CONFIG_ETHERNET) +=3D ethernet/
 obj-$(CONFIG_FDDI) +=3D fddi/
 obj-$(CONFIG_HIPPI) +=3D hippi/
diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 3af373e90806..a5f1aa911fe2 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -1,12 +1,12 @@
 # SPDX-License-Identifier: GPL-2.0-only
 menu "Distributed Switch Architecture drivers"
-=09depends on HAVE_NET_DSA
+=09depends on NET_DSA

 source "drivers/net/dsa/b53/Kconfig"

 config NET_DSA_BCM_SF2
 =09tristate "Broadcom Starfighter 2 Ethernet switch support"
-=09depends on HAS_IOMEM && NET_DSA
+=09depends on HAS_IOMEM
 =09select NET_DSA_TAG_BRCM
 =09select FIXED_PHY
 =09select BCM7XXX_PHY
@@ -18,7 +18,6 @@ config NET_DSA_BCM_SF2

 config NET_DSA_LOOP
 =09tristate "DSA mock-up Ethernet switch chip support"
-=09depends on NET_DSA
 =09select FIXED_PHY
 =09help
 =09  This enables support for a fake mock-up switch chip which
@@ -28,7 +27,7 @@ source "drivers/net/dsa/hirschmann/Kconfig"

 config NET_DSA_LANTIQ_GSWIP
 =09tristate "Lantiq / Intel GSWIP"
-=09depends on HAS_IOMEM && NET_DSA
+=09depends on HAS_IOMEM
 =09select NET_DSA_TAG_GSWIP
 =09help
 =09  This enables support for the Lantiq / Intel GSWIP 2.1 found in
@@ -36,7 +35,6 @@ config NET_DSA_LANTIQ_GSWIP

 config NET_DSA_MT7530
 =09tristate "MediaTek MT753x and MT7621 Ethernet switch support"
-=09depends on NET_DSA
 =09select NET_DSA_TAG_MTK
 =09help
 =09  This enables support for the MediaTek MT7530, MT7531, and MT7621
@@ -44,7 +42,6 @@ config NET_DSA_MT7530

 config NET_DSA_MV88E6060
 =09tristate "Marvell 88E6060 ethernet switch chip support"
-=09depends on NET_DSA
 =09select NET_DSA_TAG_TRAILER
 =09help
 =09  This enables support for the Marvell 88E6060 ethernet switch
@@ -64,7 +61,6 @@ source "drivers/net/dsa/xrs700x/Kconfig"

 config NET_DSA_QCA8K
 =09tristate "Qualcomm Atheros QCA8K Ethernet switch family support"
-=09depends on NET_DSA
 =09select NET_DSA_TAG_QCA
 =09select REGMAP
 =09help
@@ -73,7 +69,6 @@ config NET_DSA_QCA8K

 config NET_DSA_REALTEK_SMI
 =09tristate "Realtek SMI Ethernet switch family support"
-=09depends on NET_DSA
 =09select NET_DSA_TAG_RTL4_A
 =09select FIXED_PHY
 =09select IRQ_DOMAIN
@@ -93,7 +88,7 @@ config NET_DSA_SMSC_LAN9303

 config NET_DSA_SMSC_LAN9303_I2C
 =09tristate "SMSC/Microchip LAN9303 3-ports 10/100 ethernet switch in I2C =
managed mode"
-=09depends on NET_DSA && I2C
+=09depends on I2C
 =09select NET_DSA_SMSC_LAN9303
 =09select REGMAP_I2C
 =09help
@@ -102,7 +97,6 @@ config NET_DSA_SMSC_LAN9303_I2C

 config NET_DSA_SMSC_LAN9303_MDIO
 =09tristate "SMSC/Microchip LAN9303 3-ports 10/100 ethernet switch in MDIO=
 managed mode"
-=09depends on NET_DSA
 =09select NET_DSA_SMSC_LAN9303
 =09help
 =09  Enable access functions if the SMSC/Microchip LAN9303 is configured
@@ -110,7 +104,6 @@ config NET_DSA_SMSC_LAN9303_MDIO

 config NET_DSA_VITESSE_VSC73XX
 =09tristate
-=09depends on NET_DSA
 =09select FIXED_PHY
 =09select VITESSE_PHY
 =09select GPIOLIB
@@ -120,7 +113,6 @@ config NET_DSA_VITESSE_VSC73XX

 config NET_DSA_VITESSE_VSC73XX_SPI
 =09tristate "Vitesse VSC7385/7388/7395/7398 SPI mode support"
-=09depends on NET_DSA
 =09depends on SPI
 =09select NET_DSA_VITESSE_VSC73XX
 =09help
@@ -129,7 +121,6 @@ config NET_DSA_VITESSE_VSC73XX_SPI

 config NET_DSA_VITESSE_VSC73XX_PLATFORM
 =09tristate "Vitesse VSC7385/7388/7395/7398 Platform mode support"
-=09depends on NET_DSA
 =09depends on HAS_IOMEM
 =09select NET_DSA_VITESSE_VSC73XX
 =09help
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index aaf8a452fd5b..8746b07668ae 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -1,15 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
-config HAVE_NET_DSA
-=09def_bool y
-=09depends on INET && NETDEVICES && !S390
-
-# Drivers must select NET_DSA and the appropriate tagging format

 menuconfig NET_DSA
 =09tristate "Distributed Switch Architecture"
-=09depends on HAVE_NET_DSA
 =09depends on BRIDGE || BRIDGE=3Dn
 =09depends on HSR || HSR=3Dn
+=09depends on INET && NETDEVICES
 =09select GRO_CELLS
 =09select NET_SWITCHDEV
 =09select PHYLINK
@@ -20,7 +15,8 @@ menuconfig NET_DSA

 if NET_DSA

-# tagging formats
+# Drivers must select the appropriate tagging format(s)
+
 config NET_DSA_TAG_8021Q
 =09tristate
 =09select VLAN_8021Q
--
2.31.0


