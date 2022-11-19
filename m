Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC136311E1
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 00:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbiKSXMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 18:12:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235339AbiKSXLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 18:11:10 -0500
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61DB21A39D
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 15:11:02 -0800 (PST)
Date:   Sat, 19 Nov 2022 23:10:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail3; t=1668899460; x=1669158660;
        bh=qXAp3jTp36nfEd23id/Uz1+YLwDKQcbtNcZf8i0ukoE=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=OCVRh6lFR514A7UNG4ZC1uUXfW4M0cl1VhaJhCzABa22zisKoi3bUW5GatsAFOQU6
         kuQMssFZPsYXGEfQjqkIfSKczcPrE5i7um4nDh/SpLYIj0kJ7V/NFuvL01QSpwRsYF
         UcxP9tdGM2g8FYXpqrBaJmxwDbZdBgJJhOaeYwJIDJnvFedFS0cABGgDMcNLswFpxA
         ZfC+F6L9sJyEr9vTQ0mJ3e/UDZ8QCLbyFQRwrsEXtcI6cOjUZr9aXz56+30VyFKld5
         2Qja8UiVSq5Q4FbrP0Ge6YX7QdN178bhHaXxi6f3rjNBriOZ69FeymO94Z9L4wp/1F
         lcgH23xIbnYYQ==
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
Subject: [PATCH 18/18] net: cpsw: fix mixed module-builtin object
Message-ID: <20221119225650.1044591-19-alobakin@pm.me>
In-Reply-To: <20221119225650.1044591-1-alobakin@pm.me>
References: <20221119225650.1044591-1-alobakin@pm.me>
Feedback-ID: 22809121:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apart from cpdma, there are 4 object files shared in one way or
another by 5 modules:

> scripts/Makefile.build:252: ./drivers/net/ethernet/ti/Makefile:
> cpsw_ale.o is added to multiple modules: keystone_netcp
> keystone_netcp_ethss ti_cpsw ti_cpsw_new
> scripts/Makefile.build:252: ./drivers/net/ethernet/ti/Makefile:
> cpsw_ethtool.o is added to multiple modules: ti_cpsw ti_cpsw_new
> scripts/Makefile.build:252: ./drivers/net/ethernet/ti/Makefile:
> cpsw_priv.o is added to multiple modules: ti_cpsw ti_cpsw_new
> scripts/Makefile.build:252: ./drivers/net/ethernet/ti/Makefile:
> cpsw_sl.o is added to multiple modules: ti_cpsw ti_cpsw_new

All of those five are tristate, that means with some of the
corresponding Kconfig options set to `m` and some to `y`, the same
objects are linked to a module and also to vmlinux even though the
expected CFLAGS are different between builtins and modules.
This is the same situation as fixed by
commit 637a642f5ca5 ("zstd: Fixing mixed module-builtin objects").
There's also no need to duplicate the same code 4 x 5 =3D roughly 20
times.

Introduce the new module, ti_cpsw_core, to provide the common
functions used by all those modules.

Fixes: 16f54164828b ("net: ethernet: ti: cpsw: drop CONFIG_TI_CPSW_ALE conf=
ig option")
Fixes: a8577e131266 ("net: ethernet: ti: netcp_ethss: fix build")
Fixes: ed3525eda4c4 ("net: ethernet: ti: introduce cpsw switchdev based dri=
ver part 1 - dual-emac")
Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth =
subsystem driver")
Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 drivers/net/ethernet/ti/Kconfig          | 11 ++++++--
 drivers/net/ethernet/ti/Makefile         | 12 ++++----
 drivers/net/ethernet/ti/am65-cpsw-nuss.c |  2 ++
 drivers/net/ethernet/ti/cpsw.c           |  1 +
 drivers/net/ethernet/ti/cpsw_ale.c       | 20 +++++++++++++
 drivers/net/ethernet/ti/cpsw_ethtool.c   | 24 ++++++++++++++++
 drivers/net/ethernet/ti/cpsw_new.c       |  1 +
 drivers/net/ethernet/ti/cpsw_priv.c      | 36 ++++++++++++++++++++++++
 drivers/net/ethernet/ti/cpsw_sl.c        |  8 ++++++
 drivers/net/ethernet/ti/netcp_core.c     |  2 ++
 drivers/net/ethernet/ti/netcp_ethss.c    |  2 ++
 11 files changed, 112 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kcon=
fig
index 2ac0adf0c07d..407943735dd9 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -51,11 +51,15 @@ config TI_CPSW_PHY_SEL
 =09  This driver supports configuring of the phy mode connected to
 =09  the CPSW. DEPRECATED: use PHY_TI_GMII_SEL.

+config TI_CPSW_CORE
+=09tristate
+=09select TI_DAVINCI_CPDMA
+
 config TI_CPSW
 =09tristate "TI CPSW Switch Support"
 =09depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST
 =09depends on TI_CPTS || !TI_CPTS
-=09select TI_DAVINCI_CPDMA
+=09select TI_CPSW_CORE
 =09select TI_DAVINCI_MDIO
 =09select MFD_SYSCON
 =09select PAGE_POOL
@@ -73,7 +77,7 @@ config TI_CPSW_SWITCHDEV
 =09depends on NET_SWITCHDEV
 =09depends on TI_CPTS || !TI_CPTS
 =09select PAGE_POOL
-=09select TI_DAVINCI_CPDMA
+=09select TI_CPSW_CORE
 =09select TI_DAVINCI_MDIO
 =09select MFD_SYSCON
 =09select REGMAP
@@ -100,6 +104,7 @@ config TI_K3_AM65_CPSW_NUSS
 =09tristate "TI K3 AM654x/J721E CPSW Ethernet driver"
 =09depends on ARCH_K3 && OF && TI_K3_UDMA_GLUE_LAYER
 =09select NET_DEVLINK
+=09select TI_CPSW_CORE
 =09select TI_DAVINCI_MDIO
 =09select PHYLINK
 =09imply PHY_TI_GMII_SEL
@@ -147,6 +152,7 @@ config TI_AM65_CPSW_TAS

 config TI_KEYSTONE_NETCP
 =09tristate "TI Keystone NETCP Core Support"
+=09select TI_CPSW_CORE
 =09select TI_DAVINCI_MDIO
 =09depends on OF
 =09depends on KEYSTONE_NAVIGATOR_DMA && KEYSTONE_NAVIGATOR_QMSS
@@ -160,6 +166,7 @@ config TI_KEYSTONE_NETCP
 config TI_KEYSTONE_NETCP_ETHSS
 =09depends on TI_KEYSTONE_NETCP
 =09tristate "TI Keystone NETCP Ethernet subsystem Support"
+=09select TI_CPSW_CORE
 =09help

 =09  To compile this driver as a module, choose M here: the module
diff --git a/drivers/net/ethernet/ti/Makefile b/drivers/net/ethernet/ti/Mak=
efile
index 28a741ed0ac8..5cda66c4b958 100644
--- a/drivers/net/ethernet/ti/Makefile
+++ b/drivers/net/ethernet/ti/Makefile
@@ -16,17 +16,19 @@ ti_davinci_emac-y :=3D davinci_emac.o
 obj-$(CONFIG_TI_DAVINCI_MDIO) +=3D davinci_mdio.o
 obj-$(CONFIG_TI_CPSW_PHY_SEL) +=3D cpsw-phy-sel.o
 obj-$(CONFIG_TI_CPTS) +=3D cpts.o
+obj-$(CONFIG_TI_CPSW_CORE) +=3D ti_cpsw_core.o
+ti_cpsw_core-objs :=3D cpsw_ale.o cpsw_ethtool.o cpsw_priv.o cpsw_sl.o
 obj-$(CONFIG_TI_CPSW) +=3D ti_cpsw.o
-ti_cpsw-y :=3D cpsw.o cpsw_ale.o cpsw_priv.o cpsw_sl.o cpsw_ethtool.o
+ti_cpsw-y :=3D cpsw.o
 obj-$(CONFIG_TI_CPSW_SWITCHDEV) +=3D ti_cpsw_new.o
-ti_cpsw_new-y :=3D cpsw_switchdev.o cpsw_new.o cpsw_ale.o cpsw_sl.o cpsw_p=
riv.o cpsw_ethtool.o
+ti_cpsw_new-y :=3D cpsw_switchdev.o cpsw_new.o

 obj-$(CONFIG_TI_KEYSTONE_NETCP) +=3D keystone_netcp.o
-keystone_netcp-y :=3D netcp_core.o cpsw_ale.o
+keystone_netcp-y :=3D netcp_core.o
 obj-$(CONFIG_TI_KEYSTONE_NETCP_ETHSS) +=3D keystone_netcp_ethss.o
-keystone_netcp_ethss-y :=3D netcp_ethss.o netcp_sgmii.o netcp_xgbepcsr.o c=
psw_ale.o
+keystone_netcp_ethss-y :=3D netcp_ethss.o netcp_sgmii.o netcp_xgbepcsr.o

 obj-$(CONFIG_TI_K3_AM65_CPSW_NUSS) +=3D ti-am65-cpsw-nuss.o
-ti-am65-cpsw-nuss-y :=3D am65-cpsw-nuss.o cpsw_sl.o am65-cpsw-ethtool.o cp=
sw_ale.o k3-cppi-desc-pool.o am65-cpsw-qos.o
+ti-am65-cpsw-nuss-y :=3D am65-cpsw-nuss.o am65-cpsw-ethtool.o k3-cppi-desc=
-pool.o am65-cpsw-qos.o
 ti-am65-cpsw-nuss-$(CONFIG_TI_K3_AM65_CPSW_SWITCHDEV) +=3D am65-cpsw-switc=
hdev.o
 obj-$(CONFIG_TI_K3_AM65_CPTS) +=3D am65-cpts.o
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/etherne=
t/ti/am65-cpsw-nuss.c
index c50b137f92d7..e58a9b1b6690 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2850,6 +2850,8 @@ static struct platform_driver am65_cpsw_nuss_driver =
=3D {

 module_platform_driver(am65_cpsw_nuss_driver);

+MODULE_IMPORT_NS(TI_CPSW_CORE);
+
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Grygorii Strashko <grygorii.strashko@ti.com>");
 MODULE_DESCRIPTION("TI AM65 CPSW Ethernet driver");
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.=
c
index b7ac61329b20..a21648dd26fe 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1796,6 +1796,7 @@ static struct platform_driver cpsw_driver =3D {

 module_platform_driver(cpsw_driver);

+MODULE_IMPORT_NS(TI_CPSW_CORE);
 MODULE_IMPORT_NS(TI_DAVINCI_CPDMA);

 MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/c=
psw_ale.c
index 231370e9a801..75ad7649b12e 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -452,6 +452,7 @@ int cpsw_ale_flush_multicast(struct cpsw_ale *ale, int =
port_mask, int vid)
 =09}
 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ale_flush_multicast, TI_CPSW_CORE);

 static inline void cpsw_ale_set_vlan_entry_type(u32 *ale_entry,
 =09=09=09=09=09=09int flags, u16 vid)
@@ -489,6 +490,7 @@ int cpsw_ale_add_ucast(struct cpsw_ale *ale, const u8 *=
addr, int port,
 =09cpsw_ale_write(ale, idx, ale_entry);
 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ale_add_ucast, TI_CPSW_CORE);

 int cpsw_ale_del_ucast(struct cpsw_ale *ale, const u8 *addr, int port,
 =09=09       int flags, u16 vid)
@@ -504,6 +506,7 @@ int cpsw_ale_del_ucast(struct cpsw_ale *ale, const u8 *=
addr, int port,
 =09cpsw_ale_write(ale, idx, ale_entry);
 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ale_del_ucast, TI_CPSW_CORE);

 int cpsw_ale_add_mcast(struct cpsw_ale *ale, const u8 *addr, int port_mask=
,
 =09=09       int flags, u16 vid, int mcast_state)
@@ -537,6 +540,7 @@ int cpsw_ale_add_mcast(struct cpsw_ale *ale, const u8 *=
addr, int port_mask,
 =09cpsw_ale_write(ale, idx, ale_entry);
 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ale_add_mcast, TI_CPSW_CORE);

 int cpsw_ale_del_mcast(struct cpsw_ale *ale, const u8 *addr, int port_mask=
,
 =09=09       int flags, u16 vid)
@@ -566,6 +570,7 @@ int cpsw_ale_del_mcast(struct cpsw_ale *ale, const u8 *=
addr, int port_mask,
 =09cpsw_ale_write(ale, idx, ale_entry);
 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ale_del_mcast, TI_CPSW_CORE);

 /* ALE NetCP NU switch specific vlan functions */
 static void cpsw_ale_set_vlan_mcast(struct cpsw_ale *ale, u32 *ale_entry,
@@ -635,6 +640,7 @@ int cpsw_ale_add_vlan(struct cpsw_ale *ale, u16 vid, in=
t port_mask, int untag,
 =09cpsw_ale_write(ale, idx, ale_entry);
 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ale_add_vlan, TI_CPSW_CORE);

 static void cpsw_ale_vlan_del_modify_int(struct cpsw_ale *ale,  u32 *ale_e=
ntry,
 =09=09=09=09=09 u16 vid, int port_mask)
@@ -692,6 +698,7 @@ int cpsw_ale_vlan_del_modify(struct cpsw_ale *ale, u16 =
vid, int port_mask)

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ale_vlan_del_modify, TI_CPSW_CORE);

 int cpsw_ale_del_vlan(struct cpsw_ale *ale, u16 vid, int port_mask)
 {
@@ -726,6 +733,7 @@ int cpsw_ale_del_vlan(struct cpsw_ale *ale, u16 vid, in=
t port_mask)

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ale_del_vlan, TI_CPSW_CORE);

 int cpsw_ale_vlan_add_modify(struct cpsw_ale *ale, u16 vid, int port_mask,
 =09=09=09     int untag_mask, int reg_mask, int unreg_mask)
@@ -765,6 +773,7 @@ int cpsw_ale_vlan_add_modify(struct cpsw_ale *ale, u16 =
vid, int port_mask,

 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ale_vlan_add_modify, TI_CPSW_CORE);

 void cpsw_ale_set_unreg_mcast(struct cpsw_ale *ale, int unreg_mcast_mask,
 =09=09=09      bool add)
@@ -792,6 +801,7 @@ void cpsw_ale_set_unreg_mcast(struct cpsw_ale *ale, int=
 unreg_mcast_mask,
 =09=09cpsw_ale_write(ale, idx, ale_entry);
 =09}
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ale_set_unreg_mcast, TI_CPSW_CORE);

 static void cpsw_ale_vlan_set_unreg_mcast(struct cpsw_ale *ale, u32 *ale_e=
ntry,
 =09=09=09=09=09  int allmulti)
@@ -857,6 +867,7 @@ void cpsw_ale_set_allmulti(struct cpsw_ale *ale, int al=
lmulti, int port)
 =09=09cpsw_ale_write(ale, idx, ale_entry);
 =09}
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ale_set_allmulti, TI_CPSW_CORE);

 struct ale_control_info {
 =09const char=09*name;
@@ -1114,6 +1125,7 @@ int cpsw_ale_control_set(struct cpsw_ale *ale, int po=
rt, int control,

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ale_control_set, TI_CPSW_CORE);

 int cpsw_ale_control_get(struct cpsw_ale *ale, int port, int control)
 {
@@ -1137,6 +1149,7 @@ int cpsw_ale_control_get(struct cpsw_ale *ale, int po=
rt, int control)
 =09tmp =3D readl_relaxed(ale->params.ale_regs + offset) >> shift;
 =09return tmp & BITMASK(info->bits);
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ale_control_get, TI_CPSW_CORE);

 int cpsw_ale_rx_ratelimit_mc(struct cpsw_ale *ale, int port, unsigned int =
ratelimit_pps)

@@ -1159,6 +1172,7 @@ int cpsw_ale_rx_ratelimit_mc(struct cpsw_ale *ale, in=
t port, unsigned int rateli
 =09=09port, val * ALE_RATE_LIMIT_MIN_PPS);
 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ale_rx_ratelimit_mc, TI_CPSW_CORE);

 int cpsw_ale_rx_ratelimit_bc(struct cpsw_ale *ale, int port, unsigned int =
ratelimit_pps)

@@ -1181,6 +1195,7 @@ int cpsw_ale_rx_ratelimit_bc(struct cpsw_ale *ale, in=
t port, unsigned int rateli
 =09=09port, val * ALE_RATE_LIMIT_MIN_PPS);
 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ale_rx_ratelimit_bc, TI_CPSW_CORE);

 static void cpsw_ale_timer(struct timer_list *t)
 {
@@ -1270,6 +1285,7 @@ void cpsw_ale_start(struct cpsw_ale *ale)

 =09cpsw_ale_aging_start(ale);
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ale_start, TI_CPSW_CORE);

 void cpsw_ale_stop(struct cpsw_ale *ale)
 {
@@ -1277,6 +1293,7 @@ void cpsw_ale_stop(struct cpsw_ale *ale)
 =09cpsw_ale_control_set(ale, 0, ALE_CLEAR, 1);
 =09cpsw_ale_control_set(ale, 0, ALE_ENABLE, 0);
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ale_stop, TI_CPSW_CORE);

 static const struct cpsw_ale_dev_id cpsw_ale_id_match[] =3D {
 =09{
@@ -1441,6 +1458,7 @@ struct cpsw_ale *cpsw_ale_create(struct cpsw_ale_para=
ms *params)
 =09cpsw_ale_control_set(ale, 0, ALE_CLEAR, 1);
 =09return ale;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ale_create, TI_CPSW_CORE);

 void cpsw_ale_dump(struct cpsw_ale *ale, u32 *data)
 {
@@ -1451,8 +1469,10 @@ void cpsw_ale_dump(struct cpsw_ale *ale, u32 *data)
 =09=09data +=3D ALE_ENTRY_WORDS;
 =09}
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ale_dump, TI_CPSW_CORE);

 u32 cpsw_ale_get_num_entries(struct cpsw_ale *ale)
 {
 =09return ale ? ale->params.ale_entries : 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ale_get_num_entries, TI_CPSW_CORE);
diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/=
ti/cpsw_ethtool.c
index a557a477d039..78396f84e42d 100644
--- a/drivers/net/ethernet/ti/cpsw_ethtool.c
+++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
@@ -144,6 +144,7 @@ u32 cpsw_get_msglevel(struct net_device *ndev)

 =09return priv->msg_enable;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_get_msglevel, TI_CPSW_CORE);

 void cpsw_set_msglevel(struct net_device *ndev, u32 value)
 {
@@ -151,6 +152,7 @@ void cpsw_set_msglevel(struct net_device *ndev, u32 val=
ue)

 =09priv->msg_enable =3D value;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_set_msglevel, TI_CPSW_CORE);

 int cpsw_get_coalesce(struct net_device *ndev, struct ethtool_coalesce *co=
al,
 =09=09      struct kernel_ethtool_coalesce *kernel_coal,
@@ -161,6 +163,7 @@ int cpsw_get_coalesce(struct net_device *ndev, struct e=
thtool_coalesce *coal,
 =09coal->rx_coalesce_usecs =3D cpsw->coal_intvl;
 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_get_coalesce, TI_CPSW_CORE);

 int cpsw_set_coalesce(struct net_device *ndev, struct ethtool_coalesce *co=
al,
 =09=09      struct kernel_ethtool_coalesce *kernel_coal,
@@ -220,6 +223,7 @@ int cpsw_set_coalesce(struct net_device *ndev, struct e=
thtool_coalesce *coal,

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_set_coalesce, TI_CPSW_CORE);

 int cpsw_get_sset_count(struct net_device *ndev, int sset)
 {
@@ -234,6 +238,7 @@ int cpsw_get_sset_count(struct net_device *ndev, int ss=
et)
 =09=09return -EOPNOTSUPP;
 =09}
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_get_sset_count, TI_CPSW_CORE);

 static void cpsw_add_ch_strings(u8 **p, int ch_num, int rx_dir)
 {
@@ -271,6 +276,7 @@ void cpsw_get_strings(struct net_device *ndev, u32 stri=
ngset, u8 *data)
 =09=09break;
 =09}
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_get_strings, TI_CPSW_CORE);

 void cpsw_get_ethtool_stats(struct net_device *ndev,
 =09=09=09    struct ethtool_stats *stats, u64 *data)
@@ -303,6 +309,7 @@ void cpsw_get_ethtool_stats(struct net_device *ndev,
 =09=09}
 =09}
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_get_ethtool_stats, TI_CPSW_CORE);

 void cpsw_get_pauseparam(struct net_device *ndev,
 =09=09=09 struct ethtool_pauseparam *pause)
@@ -313,6 +320,7 @@ void cpsw_get_pauseparam(struct net_device *ndev,
 =09pause->rx_pause =3D priv->rx_pause ? true : false;
 =09pause->tx_pause =3D priv->tx_pause ? true : false;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_get_pauseparam, TI_CPSW_CORE);

 void cpsw_get_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 {
@@ -326,6 +334,7 @@ void cpsw_get_wol(struct net_device *ndev, struct ethto=
ol_wolinfo *wol)
 =09if (cpsw->slaves[slave_no].phy)
 =09=09phy_ethtool_get_wol(cpsw->slaves[slave_no].phy, wol);
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_get_wol, TI_CPSW_CORE);

 int cpsw_set_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 {
@@ -338,6 +347,7 @@ int cpsw_set_wol(struct net_device *ndev, struct ethtoo=
l_wolinfo *wol)
 =09else
 =09=09return -EOPNOTSUPP;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_set_wol, TI_CPSW_CORE);

 int cpsw_get_regs_len(struct net_device *ndev)
 {
@@ -346,6 +356,7 @@ int cpsw_get_regs_len(struct net_device *ndev)
 =09return cpsw_ale_get_num_entries(cpsw->ale) *
 =09       ALE_ENTRY_WORDS * sizeof(u32);
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_get_regs_len, TI_CPSW_CORE);

 void cpsw_get_regs(struct net_device *ndev, struct ethtool_regs *regs, voi=
d *p)
 {
@@ -357,6 +368,7 @@ void cpsw_get_regs(struct net_device *ndev, struct etht=
ool_regs *regs, void *p)

 =09cpsw_ale_dump(cpsw->ale, reg);
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_get_regs, TI_CPSW_CORE);

 int cpsw_ethtool_op_begin(struct net_device *ndev)
 {
@@ -370,6 +382,7 @@ int cpsw_ethtool_op_begin(struct net_device *ndev)

 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ethtool_op_begin, TI_CPSW_CORE);

 void cpsw_ethtool_op_complete(struct net_device *ndev)
 {
@@ -380,6 +393,7 @@ void cpsw_ethtool_op_complete(struct net_device *ndev)
 =09if (ret < 0)
 =09=09cpsw_err(priv, drv, "ethtool complete failed %d\n", ret);
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ethtool_op_complete, TI_CPSW_CORE);

 void cpsw_get_channels(struct net_device *ndev, struct ethtool_channels *c=
h)
 {
@@ -394,6 +408,7 @@ void cpsw_get_channels(struct net_device *ndev, struct =
ethtool_channels *ch)
 =09ch->tx_count =3D cpsw->tx_ch_num;
 =09ch->combined_count =3D 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_get_channels, TI_CPSW_CORE);

 int cpsw_get_link_ksettings(struct net_device *ndev,
 =09=09=09    struct ethtool_link_ksettings *ecmd)
@@ -408,6 +423,7 @@ int cpsw_get_link_ksettings(struct net_device *ndev,
 =09phy_ethtool_ksettings_get(cpsw->slaves[slave_no].phy, ecmd);
 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_get_link_ksettings, TI_CPSW_CORE);

 int cpsw_set_link_ksettings(struct net_device *ndev,
 =09=09=09    const struct ethtool_link_ksettings *ecmd)
@@ -421,6 +437,7 @@ int cpsw_set_link_ksettings(struct net_device *ndev,

 =09return phy_ethtool_ksettings_set(cpsw->slaves[slave_no].phy, ecmd);
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_set_link_ksettings, TI_CPSW_CORE);

 int cpsw_get_eee(struct net_device *ndev, struct ethtool_eee *edata)
 {
@@ -433,6 +450,7 @@ int cpsw_get_eee(struct net_device *ndev, struct ethtoo=
l_eee *edata)
 =09else
 =09=09return -EOPNOTSUPP;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_get_eee, TI_CPSW_CORE);

 int cpsw_set_eee(struct net_device *ndev, struct ethtool_eee *edata)
 {
@@ -445,6 +463,7 @@ int cpsw_set_eee(struct net_device *ndev, struct ethtoo=
l_eee *edata)
 =09else
 =09=09return -EOPNOTSUPP;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_set_eee, TI_CPSW_CORE);

 int cpsw_nway_reset(struct net_device *ndev)
 {
@@ -457,6 +476,7 @@ int cpsw_nway_reset(struct net_device *ndev)
 =09else
 =09=09return -EOPNOTSUPP;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_nway_reset, TI_CPSW_CORE);

 static void cpsw_suspend_data_pass(struct net_device *ndev)
 {
@@ -654,6 +674,7 @@ int cpsw_set_channels_common(struct net_device *ndev,
 =09cpsw_fail(cpsw);
 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_set_channels_common, TI_CPSW_CORE);

 void cpsw_get_ringparam(struct net_device *ndev,
 =09=09=09struct ethtool_ringparam *ering,
@@ -669,6 +690,7 @@ void cpsw_get_ringparam(struct net_device *ndev,
 =09ering->rx_max_pending =3D cpsw->descs_pool_size - CPSW_MAX_QUEUES;
 =09ering->rx_pending =3D cpdma_get_num_rx_descs(cpsw->dma);
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_get_ringparam, TI_CPSW_CORE);

 int cpsw_set_ringparam(struct net_device *ndev,
 =09=09       struct ethtool_ringparam *ering,
@@ -715,6 +737,7 @@ int cpsw_set_ringparam(struct net_device *ndev,
 =09cpsw_fail(cpsw);
 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_set_ringparam, TI_CPSW_CORE);

 #if IS_ENABLED(CONFIG_TI_CPTS)
 int cpsw_get_ts_info(struct net_device *ndev, struct ethtool_ts_info *info=
)
@@ -750,3 +773,4 @@ int cpsw_get_ts_info(struct net_device *ndev, struct et=
htool_ts_info *info)
 =09return 0;
 }
 #endif
+EXPORT_SYMBOL_NS_GPL(cpsw_get_ts_info, TI_CPSW_CORE);
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/c=
psw_new.c
index 9ed398c04c04..d56b6c995252 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -2116,6 +2116,7 @@ static struct platform_driver cpsw_driver =3D {

 module_platform_driver(cpsw_driver);

+MODULE_IMPORT_NS(TI_CPSW_CORE);
 MODULE_IMPORT_NS(TI_DAVINCI_CPDMA);

 MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/=
cpsw_priv.c
index 758295c898ac..fb2c7785a71e 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -31,6 +31,7 @@
 #define CPTS_N_ETX_TS 4

 int (*cpsw_slave_index)(struct cpsw_common *cpsw, struct cpsw_priv *priv);
+EXPORT_SYMBOL_NS_GPL(cpsw_slave_index, TI_CPSW_CORE);

 void cpsw_intr_enable(struct cpsw_common *cpsw)
 {
@@ -39,6 +40,7 @@ void cpsw_intr_enable(struct cpsw_common *cpsw)

 =09cpdma_ctlr_int_ctrl(cpsw->dma, true);
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_intr_enable, TI_CPSW_CORE);

 void cpsw_intr_disable(struct cpsw_common *cpsw)
 {
@@ -47,6 +49,7 @@ void cpsw_intr_disable(struct cpsw_common *cpsw)

 =09cpdma_ctlr_int_ctrl(cpsw->dma, false);
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_intr_disable, TI_CPSW_CORE);

 void cpsw_tx_handler(void *token, int len, int status)
 {
@@ -81,6 +84,7 @@ void cpsw_tx_handler(void *token, int len, int status)
 =09ndev->stats.tx_packets++;
 =09ndev->stats.tx_bytes +=3D len;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_tx_handler, TI_CPSW_CORE);

 irqreturn_t cpsw_tx_interrupt(int irq, void *dev_id)
 {
@@ -97,6 +101,7 @@ irqreturn_t cpsw_tx_interrupt(int irq, void *dev_id)
 =09napi_schedule(&cpsw->napi_tx);
 =09return IRQ_HANDLED;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_tx_interrupt, TI_CPSW_CORE);

 irqreturn_t cpsw_rx_interrupt(int irq, void *dev_id)
 {
@@ -113,6 +118,7 @@ irqreturn_t cpsw_rx_interrupt(int irq, void *dev_id)
 =09napi_schedule(&cpsw->napi_rx);
 =09return IRQ_HANDLED;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_rx_interrupt, TI_CPSW_CORE);

 irqreturn_t cpsw_misc_interrupt(int irq, void *dev_id)
 {
@@ -125,6 +131,7 @@ irqreturn_t cpsw_misc_interrupt(int irq, void *dev_id)

 =09return IRQ_HANDLED;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_misc_interrupt, TI_CPSW_CORE);

 int cpsw_tx_mq_poll(struct napi_struct *napi_tx, int budget)
 {
@@ -157,6 +164,7 @@ int cpsw_tx_mq_poll(struct napi_struct *napi_tx, int bu=
dget)

 =09return num_tx;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_tx_mq_poll, TI_CPSW_CORE);

 int cpsw_tx_poll(struct napi_struct *napi_tx, int budget)
 {
@@ -175,6 +183,7 @@ int cpsw_tx_poll(struct napi_struct *napi_tx, int budge=
t)

 =09return num_tx;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_tx_poll, TI_CPSW_CORE);

 int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
 {
@@ -207,6 +216,7 @@ int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int bu=
dget)

 =09return num_rx;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_rx_mq_poll, TI_CPSW_CORE);

 int cpsw_rx_poll(struct napi_struct *napi_rx, int budget)
 {
@@ -225,6 +235,7 @@ int cpsw_rx_poll(struct napi_struct *napi_rx, int budge=
t)

 =09return num_rx;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_rx_poll, TI_CPSW_CORE);

 void cpsw_rx_vlan_encap(struct sk_buff *skb)
 {
@@ -267,12 +278,14 @@ void cpsw_rx_vlan_encap(struct sk_buff *skb)
 =09=09skb_pull(skb, VLAN_HLEN);
 =09}
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_rx_vlan_encap, TI_CPSW_CORE);

 void cpsw_set_slave_mac(struct cpsw_slave *slave, struct cpsw_priv *priv)
 {
 =09slave_write(slave, mac_hi(priv->mac_addr), SA_HI);
 =09slave_write(slave, mac_lo(priv->mac_addr), SA_LO);
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_set_slave_mac, TI_CPSW_CORE);

 void soft_reset(const char *module, void __iomem *reg)
 {
@@ -285,6 +298,7 @@ void soft_reset(const char *module, void __iomem *reg)

 =09WARN(readl_relaxed(reg) & 1, "failed to soft-reset %s\n", module);
 }
+EXPORT_SYMBOL_NS_GPL(soft_reset, TI_CPSW_CORE);

 void cpsw_ndo_tx_timeout(struct net_device *ndev, unsigned int txqueue)
 {
@@ -304,6 +318,7 @@ void cpsw_ndo_tx_timeout(struct net_device *ndev, unsig=
ned int txqueue)
 =09netif_trans_update(ndev);
 =09netif_tx_wake_all_queues(ndev);
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ndo_tx_timeout, TI_CPSW_CORE);

 static int cpsw_get_common_speed(struct cpsw_common *cpsw)
 {
@@ -342,6 +357,7 @@ int cpsw_need_resplit(struct cpsw_common *cpsw)

 =09return 1;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_need_resplit, TI_CPSW_CORE);

 void cpsw_split_res(struct cpsw_common *cpsw)
 {
@@ -427,6 +443,7 @@ void cpsw_split_res(struct cpsw_common *cpsw)
 =09if (budget)
 =09=09cpsw->rxv[0].budget +=3D budget;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_split_res, TI_CPSW_CORE);

 int cpsw_init_common(struct cpsw_common *cpsw, void __iomem *ss_regs,
 =09=09     int ale_ageout, phys_addr_t desc_mem_phys,
@@ -547,6 +564,7 @@ int cpsw_init_common(struct cpsw_common *cpsw, void __i=
omem *ss_regs,

 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_init_common, TI_CPSW_CORE);

 #if IS_ENABLED(CONFIG_TI_CPTS)

@@ -728,6 +746,7 @@ int cpsw_ndo_ioctl(struct net_device *dev, struct ifreq=
 *req, int cmd)

 =09return -EOPNOTSUPP;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ndo_ioctl, TI_CPSW_CORE);

 int cpsw_ndo_set_tx_maxrate(struct net_device *ndev, int queue, u32 rate)
 {
@@ -777,6 +796,7 @@ int cpsw_ndo_set_tx_maxrate(struct net_device *ndev, in=
t queue, u32 rate)
 =09cpsw_split_res(cpsw);
 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ndo_set_tx_maxrate, TI_CPSW_CORE);

 static int cpsw_tc_to_fifo(int tc, int num_tc)
 {
@@ -801,6 +821,7 @@ bool cpsw_shp_is_off(struct cpsw_priv *priv)

 =09return !val;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_shp_is_off, TI_CPSW_CORE);

 static void cpsw_fifo_shp_on(struct cpsw_priv *priv, int fifo, int on)
 {
@@ -1062,6 +1083,7 @@ int cpsw_ndo_setup_tc(struct net_device *ndev, enum t=
c_setup_type type,
 =09=09return -EOPNOTSUPP;
 =09}
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ndo_setup_tc, TI_CPSW_CORE);

 void cpsw_cbs_resume(struct cpsw_slave *slave, struct cpsw_priv *priv)
 {
@@ -1075,6 +1097,7 @@ void cpsw_cbs_resume(struct cpsw_slave *slave, struct=
 cpsw_priv *priv)
 =09=09cpsw_set_fifo_rlimit(priv, fifo, bw);
 =09}
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_cbs_resume, TI_CPSW_CORE);

 void cpsw_mqprio_resume(struct cpsw_slave *slave, struct cpsw_priv *priv)
 {
@@ -1097,6 +1120,7 @@ void cpsw_mqprio_resume(struct cpsw_slave *slave, str=
uct cpsw_priv *priv)

 =09slave_write(slave, tx_prio_map, tx_prio_rg);
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_mqprio_resume, TI_CPSW_CORE);

 int cpsw_fill_rx_channels(struct cpsw_priv *priv)
 {
@@ -1142,6 +1166,7 @@ int cpsw_fill_rx_channels(struct cpsw_priv *priv)

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_fill_rx_channels, TI_CPSW_CORE);

 static struct page_pool *cpsw_create_page_pool(struct cpsw_common *cpsw,
 =09=09=09=09=09       int size)
@@ -1227,6 +1252,7 @@ void cpsw_destroy_xdp_rxqs(struct cpsw_common *cpsw)
 =09=09cpsw->page_pool[ch] =3D NULL;
 =09}
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_destroy_xdp_rxqs, TI_CPSW_CORE);

 int cpsw_create_xdp_rxqs(struct cpsw_common *cpsw)
 {
@@ -1259,6 +1285,7 @@ int cpsw_create_xdp_rxqs(struct cpsw_common *cpsw)

 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_create_xdp_rxqs, TI_CPSW_CORE);

 static int cpsw_xdp_prog_setup(struct cpsw_priv *priv, struct netdev_bpf *=
bpf)
 {
@@ -1286,6 +1313,7 @@ int cpsw_ndo_bpf(struct net_device *ndev, struct netd=
ev_bpf *bpf)
 =09=09return -EINVAL;
 =09}
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_ndo_bpf, TI_CPSW_CORE);

 int cpsw_xdp_tx_frame(struct cpsw_priv *priv, struct xdp_frame *xdpf,
 =09=09      struct page *page, int port)
@@ -1319,6 +1347,7 @@ int cpsw_xdp_tx_frame(struct cpsw_priv *priv, struct =
xdp_frame *xdpf,

 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_xdp_tx_frame, TI_CPSW_CORE);

 int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
 =09=09 struct page *page, int port, int *len)
@@ -1381,6 +1410,7 @@ int cpsw_run_xdp(struct cpsw_priv *priv, int ch, stru=
ct xdp_buff *xdp,
 =09page_pool_recycle_direct(cpsw->page_pool[ch], page);
 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_run_xdp, TI_CPSW_CORE);

 static int cpsw_qos_clsflower_add_policer(struct cpsw_priv *priv,
 =09=09=09=09=09  struct netlink_ext_ack *extack,
@@ -1580,3 +1610,9 @@ void cpsw_qos_clsflower_resume(struct cpsw_priv *priv=
)
 =09=09cpsw_ale_rx_ratelimit_mc(priv->cpsw->ale, port_id,
 =09=09=09=09=09 priv->ale_mc_ratelimit.rate_packet_ps);
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_qos_clsflower_resume, TI_CPSW_CORE);
+
+MODULE_IMPORT_NS(TI_DAVINCI_CPDMA);
+
+MODULE_DESCRIPTION("TI CPSW Core Module");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/ti/cpsw_sl.c b/drivers/net/ethernet/ti/cp=
sw_sl.c
index 0c7531cb0f39..893e29d72213 100644
--- a/drivers/net/ethernet/ti/cpsw_sl.c
+++ b/drivers/net/ethernet/ti/cpsw_sl.c
@@ -200,6 +200,7 @@ u32 cpsw_sl_reg_read(struct cpsw_sl *sl, enum cpsw_sl_r=
egs reg)
 =09dev_dbg(sl->dev, "cpsw_sl: reg: %04X r 0x%08X\n", sl->regs[reg], val);
 =09return val;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_sl_reg_read, TI_CPSW_CORE);

 void cpsw_sl_reg_write(struct cpsw_sl *sl, enum cpsw_sl_regs reg, u32 val)
 {
@@ -212,6 +213,7 @@ void cpsw_sl_reg_write(struct cpsw_sl *sl, enum cpsw_sl=
_regs reg, u32 val)
 =09dev_dbg(sl->dev, "cpsw_sl: reg: %04X w 0x%08X\n", sl->regs[reg], val);
 =09writel(val, sl->sl_base + sl->regs[reg]);
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_sl_reg_write, TI_CPSW_CORE);

 static const struct cpsw_sl_dev_id *cpsw_sl_match_id(
 =09=09const struct cpsw_sl_dev_id *id,
@@ -252,6 +254,7 @@ struct cpsw_sl *cpsw_sl_get(const char *device_id, stru=
ct device *dev,

 =09return sl;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_sl_get, TI_CPSW_CORE);

 void cpsw_sl_reset(struct cpsw_sl *sl, unsigned long tmo)
 {
@@ -270,6 +273,7 @@ void cpsw_sl_reset(struct cpsw_sl *sl, unsigned long tm=
o)
 =09if (cpsw_sl_reg_read(sl, CPSW_SL_SOFT_RESET) & CPSW_SL_SOFT_RESET_BIT)
 =09=09dev_err(sl->dev, "cpsw_sl failed to soft-reset.\n");
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_sl_reset, TI_CPSW_CORE);

 u32 cpsw_sl_ctl_set(struct cpsw_sl *sl, u32 ctl_funcs)
 {
@@ -287,6 +291,7 @@ u32 cpsw_sl_ctl_set(struct cpsw_sl *sl, u32 ctl_funcs)

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_sl_ctl_set, TI_CPSW_CORE);

 u32 cpsw_sl_ctl_clr(struct cpsw_sl *sl, u32 ctl_funcs)
 {
@@ -304,11 +309,13 @@ u32 cpsw_sl_ctl_clr(struct cpsw_sl *sl, u32 ctl_funcs=
)

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_sl_ctl_clr, TI_CPSW_CORE);

 void cpsw_sl_ctl_reset(struct cpsw_sl *sl)
 {
 =09cpsw_sl_reg_write(sl, CPSW_SL_MACCONTROL, 0);
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_sl_ctl_reset, TI_CPSW_CORE);

 int cpsw_sl_wait_for_idle(struct cpsw_sl *sl, unsigned long tmo)
 {
@@ -326,3 +333,4 @@ int cpsw_sl_wait_for_idle(struct cpsw_sl *sl, unsigned =
long tmo)

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpsw_sl_wait_for_idle, TI_CPSW_CORE);
diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti=
/netcp_core.c
index aba70bef4894..7fe79626aa19 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -2275,6 +2275,8 @@ static struct platform_driver netcp_driver =3D {
 };
 module_platform_driver(netcp_driver);

+MODULE_IMPORT_NS(TI_CPSW_CORE);
+
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("TI NETCP driver for Keystone SOCs");
 MODULE_AUTHOR("Sandeep Nair <sandeep_n@ti.com");
diff --git a/drivers/net/ethernet/ti/netcp_ethss.c b/drivers/net/ethernet/t=
i/netcp_ethss.c
index 751fb0bc65c5..2bb3a5ab1df2 100644
--- a/drivers/net/ethernet/ti/netcp_ethss.c
+++ b/drivers/net/ethernet/ti/netcp_ethss.c
@@ -3873,6 +3873,8 @@ static void __exit keystone_gbe_exit(void)
 }
 module_exit(keystone_gbe_exit);

+MODULE_IMPORT_NS(TI_CPSW_CORE);
+
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("TI NETCP ETHSS driver for Keystone SOCs");
 MODULE_AUTHOR("Sandeep Nair <sandeep_n@ti.com");
--
2.38.1


