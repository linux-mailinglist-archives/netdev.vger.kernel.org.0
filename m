Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6843B6311D3
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 00:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbiKSXJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 18:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235310AbiKSXJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 18:09:35 -0500
Received: from mail-40131.protonmail.ch (mail-40131.protonmail.ch [185.70.40.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F541A23F
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 15:09:34 -0800 (PST)
Date:   Sat, 19 Nov 2022 23:09:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail3; t=1668899373; x=1669158573;
        bh=MAgRAh4SDfMEPc3zacP7lfPCdvWAEe3d5ZwVSRUvOuA=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=iZy0jG6AkPETIeHEmKHqgjE6t1Q+kVlflbMPgugjFGCbpEBsYs6e7T8XI0dLJ6kJV
         xS89AcZITBR2RDXUo0/sxT1ekJ8nna+ZChqg5QgMQPF88+VHZ+NrhXK1ZJP0vU+QwR
         8oWyoEYw3BZJe/K3GNY6Tlpa2mMheAfUboSTYGtaAKuXvEGmLg0ZHLOemddovtvEF0
         VA9KZ9tkSxzGlSwjWBAQNFTfhpNuywVhJvvqwObruB/CRB1M+FqXZ5kSGW67syu/cO
         7dH5364Wb2/svC+oBdNlfh7UkQWEZd6pceCI3Mit/GSOfuk0oPlEBzNRbS29S4wEOn
         8y8zXZokmhmaw==
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
Subject: [PATCH 14/18] dsa: ocelot: fix mixed module-builtin object
Message-ID: <20221119225650.1044591-15-alobakin@pm.me>
In-Reply-To: <20221119225650.1044591-1-alobakin@pm.me>
References: <20221119225650.1044591-1-alobakin@pm.me>
Feedback-ID: 22809121:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With CONFIG_NET_DSA_MSCC_FELIX=3Dm and CONFIG_NET_DSA_MSCC_SEVILLE=3Dy
(or vice versa), felix.o are linked to a module and also to vmlinux
even though the expected CFLAGS are different between builtins and
modules.
This is the same situation as fixed by
commit 637a642f5ca5 ("zstd: Fixing mixed module-builtin objects").
There's also no need to duplicate relatively big piece of object
code into two modules.

Introduce the new module, mscc_core, to provide the common functions
to both mscc_felix and mscc_seville.

Fixes: d60bc62de4ae ("net: dsa: seville: build as separate module")
Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 drivers/net/dsa/ocelot/Kconfig           | 18 ++++++++++--------
 drivers/net/dsa/ocelot/Makefile          | 12 +++++-------
 drivers/net/dsa/ocelot/felix.c           |  6 ++++++
 drivers/net/dsa/ocelot/felix_vsc9959.c   |  2 ++
 drivers/net/dsa/ocelot/seville_vsc9953.c |  2 ++
 5 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfi=
g
index 08db9cf76818..59845274e374 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -1,4 +1,12 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+config NET_DSA_MSCC_CORE
+=09tristate
+=09select MSCC_OCELOT_SWITCH_LIB
+=09select NET_DSA_TAG_OCELOT_8021Q
+=09select NET_DSA_TAG_OCELOT
+=09select PCS_LYNX
+
 config NET_DSA_MSCC_FELIX
 =09tristate "Ocelot / Felix Ethernet switch support"
 =09depends on NET_DSA && PCI
@@ -7,11 +15,8 @@ config NET_DSA_MSCC_FELIX
 =09depends on HAS_IOMEM
 =09depends on PTP_1588_CLOCK_OPTIONAL
 =09depends on NET_SCH_TAPRIO || NET_SCH_TAPRIO=3Dn
-=09select MSCC_OCELOT_SWITCH_LIB
-=09select NET_DSA_TAG_OCELOT_8021Q
-=09select NET_DSA_TAG_OCELOT
+=09select NET_DSA_MSCC_CORE
 =09select FSL_ENETC_MDIO
-=09select PCS_LYNX
 =09help
 =09  This driver supports the VSC9959 (Felix) switch, which is embedded as
 =09  a PCIe function of the NXP LS1028A ENETC RCiEP.
@@ -22,11 +27,8 @@ config NET_DSA_MSCC_SEVILLE
 =09depends on NET_VENDOR_MICROSEMI
 =09depends on HAS_IOMEM
 =09depends on PTP_1588_CLOCK_OPTIONAL
+=09select NET_DSA_MSCC_CORE
 =09select MDIO_MSCC_MIIM
-=09select MSCC_OCELOT_SWITCH_LIB
-=09select NET_DSA_TAG_OCELOT_8021Q
-=09select NET_DSA_TAG_OCELOT
-=09select PCS_LYNX
 =09help
 =09  This driver supports the VSC9953 (Seville) switch, which is embedded
 =09  as a platform device on the NXP T1040 SoC.
diff --git a/drivers/net/dsa/ocelot/Makefile b/drivers/net/dsa/ocelot/Makef=
ile
index f6dd131e7491..f8c74b59b996 100644
--- a/drivers/net/dsa/ocelot/Makefile
+++ b/drivers/net/dsa/ocelot/Makefile
@@ -1,11 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+obj-$(CONFIG_NET_DSA_MSCC_CORE) +=3D mscc_core.o
 obj-$(CONFIG_NET_DSA_MSCC_FELIX) +=3D mscc_felix.o
 obj-$(CONFIG_NET_DSA_MSCC_SEVILLE) +=3D mscc_seville.o

-mscc_felix-objs :=3D \
-=09felix.o \
-=09felix_vsc9959.o
-
-mscc_seville-objs :=3D \
-=09felix.o \
-=09seville_vsc9953.o
+mscc_core-objs :=3D felix.o
+mscc_felix-objs :=3D felix_vsc9959.o
+mscc_seville-objs :=3D seville_vsc9953.o
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.=
c
index dd3a18cc89dd..f9d0a24ebc3a 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -2112,6 +2112,7 @@ const struct dsa_switch_ops felix_switch_ops =3D {
 =09.port_set_host_flood=09=09=3D felix_port_set_host_flood,
 =09.port_change_master=09=09=3D felix_port_change_master,
 };
+EXPORT_SYMBOL_NS_GPL(felix_switch_ops, NET_DSA_MSCC_CORE);

 struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port)
 {
@@ -2123,6 +2124,7 @@ struct net_device *felix_port_to_netdev(struct ocelot=
 *ocelot, int port)

 =09return dsa_to_port(ds, port)->slave;
 }
+EXPORT_SYMBOL_NS_GPL(felix_port_to_netdev, NET_DSA_MSCC_CORE);

 int felix_netdev_to_port(struct net_device *dev)
 {
@@ -2134,3 +2136,7 @@ int felix_netdev_to_port(struct net_device *dev)

 =09return dp->index;
 }
+EXPORT_SYMBOL_NS_GPL(felix_netdev_to_port, NET_DSA_MSCC_CORE);
+
+MODULE_DESCRIPTION("MSCC Switch driver core");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelo=
t/felix_vsc9959.c
index 26a35ae322d1..52c8bff79fa3 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2736,5 +2736,7 @@ static struct pci_driver felix_vsc9959_pci_driver =3D=
 {
 };
 module_pci_driver(felix_vsc9959_pci_driver);

+MODULE_IMPORT_NS(NET_DSA_MSCC_CORE);
+
 MODULE_DESCRIPTION("Felix Switch driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/oce=
lot/seville_vsc9953.c
index 7af33b2c685d..e9c63c642489 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1115,5 +1115,7 @@ static struct platform_driver seville_vsc9953_driver =
=3D {
 };
 module_platform_driver(seville_vsc9953_driver);

+MODULE_IMPORT_NS(NET_DSA_MSCC_CORE);
+
 MODULE_DESCRIPTION("Seville Switch driver");
 MODULE_LICENSE("GPL v2");
--
2.38.1


