Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFAD96311C4
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 00:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235103AbiKSXHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 18:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235131AbiKSXHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 18:07:30 -0500
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F61C1A20F;
        Sat, 19 Nov 2022 15:07:29 -0800 (PST)
Date:   Sat, 19 Nov 2022 23:07:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail3; t=1668899247; x=1669158447;
        bh=z5EwErPNabx0KbW3NJbE+dQBJOp75EzBGrGloRwIuN0=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=nnoaEEKY5ft1oKGOfAZPj+LAEtg0D88SpRKM9wyLs+0hxhqbcdiGAJ7IelxQcG0/o
         WRoEXlQhmkqUKRIBTgjPvhSmZ26sZ28WmJRqLSmeR54HM93eIyAYzOvHVMt/tmvhUE
         Na6l/4wOhJcaYbFeUAqQefkYnqnrsxMCSkfx/8QVumIrmb733uScTHej9O/4XZIppO
         WpQNIxKne2gLnN0jKjRV0x8abu58slF+jRXfyFeBgbYNpngLaR+8gcpYCnU5BmJ5Pa
         HmZqd26dqKxgGmnxvRF/4Khd53dRj3SriuvET/oDK8OO/uUSLb+vvyE3Ph1RdFvZrH
         6TDBq0AsAfPxQ==
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
Subject: [PATCH 09/18] net: emac, cpsw: fix mixed module-builtin object (davinci_cpdma)
Message-ID: <20221119225650.1044591-10-alobakin@pm.me>
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

From: Masahiro Yamada <masahiroy@kernel.org>

CONFIG_TI_DAVINCI_EMAC, CONFIG_TI_CPSW and CONFIG_TI_CPSW_SWITCHDEV
are all tristate. This means that davinci_cpdma.o can be linked to
a module and also to vmlinux even though the expected CFLAGS are
different between builtins and modules.

This is the same situation as fixed by commit 637a642f5ca5 ("zstd:
Fixing mixed module-builtin objects").

Introduce the new module, ti_davinci_cpdma, to provide the common
functions to these three modules.

[ alobakin: add exports ]

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 drivers/net/ethernet/ti/Kconfig         |  6 +++++
 drivers/net/ethernet/ti/Makefile        |  8 +++---
 drivers/net/ethernet/ti/cpsw.c          |  2 ++
 drivers/net/ethernet/ti/cpsw_new.c      |  2 ++
 drivers/net/ethernet/ti/davinci_cpdma.c | 33 +++++++++++++++++++++++++
 drivers/net/ethernet/ti/davinci_emac.c  |  2 ++
 6 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kcon=
fig
index fce06663e1e1..2ac0adf0c07d 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -17,9 +17,13 @@ config NET_VENDOR_TI

 if NET_VENDOR_TI

+config TI_DAVINCI_CPDMA
+=09tristate
+
 config TI_DAVINCI_EMAC
 =09tristate "TI DaVinci EMAC Support"
 =09depends on ARM && ( ARCH_DAVINCI || ARCH_OMAP3 ) || COMPILE_TEST
+=09select TI_DAVINCI_CPDMA
 =09select TI_DAVINCI_MDIO
 =09select PHYLIB
 =09select GENERIC_ALLOCATOR
@@ -51,6 +55,7 @@ config TI_CPSW
 =09tristate "TI CPSW Switch Support"
 =09depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST
 =09depends on TI_CPTS || !TI_CPTS
+=09select TI_DAVINCI_CPDMA
 =09select TI_DAVINCI_MDIO
 =09select MFD_SYSCON
 =09select PAGE_POOL
@@ -68,6 +73,7 @@ config TI_CPSW_SWITCHDEV
 =09depends on NET_SWITCHDEV
 =09depends on TI_CPTS || !TI_CPTS
 =09select PAGE_POOL
+=09select TI_DAVINCI_CPDMA
 =09select TI_DAVINCI_MDIO
 =09select MFD_SYSCON
 =09select REGMAP
diff --git a/drivers/net/ethernet/ti/Makefile b/drivers/net/ethernet/ti/Mak=
efile
index 75f761efbea7..28a741ed0ac8 100644
--- a/drivers/net/ethernet/ti/Makefile
+++ b/drivers/net/ethernet/ti/Makefile
@@ -9,15 +9,17 @@ obj-$(CONFIG_TI_CPSW_SWITCHDEV) +=3D cpsw-common.o

 obj-$(CONFIG_TLAN) +=3D tlan.o
 obj-$(CONFIG_CPMAC) +=3D cpmac.o
+obj-$(CONFIG_TI_DAVINCI_CPDMA) +=3D ti_davinci_cpdma.o
+ti_davinci_cpdma-y :=3D davinci_cpdma.o
 obj-$(CONFIG_TI_DAVINCI_EMAC) +=3D ti_davinci_emac.o
-ti_davinci_emac-y :=3D davinci_emac.o davinci_cpdma.o
+ti_davinci_emac-y :=3D davinci_emac.o
 obj-$(CONFIG_TI_DAVINCI_MDIO) +=3D davinci_mdio.o
 obj-$(CONFIG_TI_CPSW_PHY_SEL) +=3D cpsw-phy-sel.o
 obj-$(CONFIG_TI_CPTS) +=3D cpts.o
 obj-$(CONFIG_TI_CPSW) +=3D ti_cpsw.o
-ti_cpsw-y :=3D cpsw.o davinci_cpdma.o cpsw_ale.o cpsw_priv.o cpsw_sl.o cps=
w_ethtool.o
+ti_cpsw-y :=3D cpsw.o cpsw_ale.o cpsw_priv.o cpsw_sl.o cpsw_ethtool.o
 obj-$(CONFIG_TI_CPSW_SWITCHDEV) +=3D ti_cpsw_new.o
-ti_cpsw_new-y :=3D cpsw_switchdev.o cpsw_new.o davinci_cpdma.o cpsw_ale.o =
cpsw_sl.o cpsw_priv.o cpsw_ethtool.o
+ti_cpsw_new-y :=3D cpsw_switchdev.o cpsw_new.o cpsw_ale.o cpsw_sl.o cpsw_p=
riv.o cpsw_ethtool.o

 obj-$(CONFIG_TI_KEYSTONE_NETCP) +=3D keystone_netcp.o
 keystone_netcp-y :=3D netcp_core.o cpsw_ale.o
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.=
c
index 13c9c2d6b79b..b7ac61329b20 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1796,6 +1796,8 @@ static struct platform_driver cpsw_driver =3D {

 module_platform_driver(cpsw_driver);

+MODULE_IMPORT_NS(TI_DAVINCI_CPDMA);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Cyril Chemparathy <cyril@ti.com>");
 MODULE_AUTHOR("Mugunthan V N <mugunthanvnm@ti.com>");
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/c=
psw_new.c
index 83596ec0c7cb..9ed398c04c04 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -2116,5 +2116,7 @@ static struct platform_driver cpsw_driver =3D {

 module_platform_driver(cpsw_driver);

+MODULE_IMPORT_NS(TI_DAVINCI_CPDMA);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("TI CPSW switchdev Ethernet driver");
diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet=
/ti/davinci_cpdma.c
index d2eab5cd1e0c..32ba94626cda 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -531,6 +531,7 @@ struct cpdma_ctlr *cpdma_ctlr_create(struct cpdma_param=
s *params)
 =09=09ctlr->num_chan =3D CPDMA_MAX_CHANNELS;
 =09return ctlr;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_ctlr_create, TI_DAVINCI_CPDMA);

 int cpdma_ctlr_start(struct cpdma_ctlr *ctlr)
 {
@@ -591,6 +592,7 @@ int cpdma_ctlr_start(struct cpdma_ctlr *ctlr)
 =09spin_unlock_irqrestore(&ctlr->lock, flags);
 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_ctlr_start, TI_DAVINCI_CPDMA);

 int cpdma_ctlr_stop(struct cpdma_ctlr *ctlr)
 {
@@ -623,6 +625,7 @@ int cpdma_ctlr_stop(struct cpdma_ctlr *ctlr)
 =09spin_unlock_irqrestore(&ctlr->lock, flags);
 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_ctlr_stop, TI_DAVINCI_CPDMA);

 int cpdma_ctlr_destroy(struct cpdma_ctlr *ctlr)
 {
@@ -640,6 +643,7 @@ int cpdma_ctlr_destroy(struct cpdma_ctlr *ctlr)
 =09cpdma_desc_pool_destroy(ctlr);
 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_ctlr_destroy, TI_DAVINCI_CPDMA);

 int cpdma_ctlr_int_ctrl(struct cpdma_ctlr *ctlr, bool enable)
 {
@@ -660,21 +664,25 @@ int cpdma_ctlr_int_ctrl(struct cpdma_ctlr *ctlr, bool=
 enable)
 =09spin_unlock_irqrestore(&ctlr->lock, flags);
 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_ctlr_int_ctrl, TI_DAVINCI_CPDMA);

 void cpdma_ctlr_eoi(struct cpdma_ctlr *ctlr, u32 value)
 {
 =09dma_reg_write(ctlr, CPDMA_MACEOIVECTOR, value);
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_ctlr_eoi, TI_DAVINCI_CPDMA);

 u32 cpdma_ctrl_rxchs_state(struct cpdma_ctlr *ctlr)
 {
 =09return dma_reg_read(ctlr, CPDMA_RXINTSTATMASKED);
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_ctrl_rxchs_state, TI_DAVINCI_CPDMA);

 u32 cpdma_ctrl_txchs_state(struct cpdma_ctlr *ctlr)
 {
 =09return dma_reg_read(ctlr, CPDMA_TXINTSTATMASKED);
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_ctrl_txchs_state, TI_DAVINCI_CPDMA);

 static void cpdma_chan_set_descs(struct cpdma_ctlr *ctlr,
 =09=09=09=09 int rx, int desc_num,
@@ -802,6 +810,7 @@ int cpdma_chan_set_weight(struct cpdma_chan *ch, int we=
ight)
 =09spin_unlock_irqrestore(&ctlr->lock, flags);
 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_chan_set_weight, TI_DAVINCI_CPDMA);

 /* cpdma_chan_get_min_rate - get minimum allowed rate for channel
  * Should be called before cpdma_chan_set_rate.
@@ -816,6 +825,7 @@ u32 cpdma_chan_get_min_rate(struct cpdma_ctlr *ctlr)

 =09return DIV_ROUND_UP(divident, divisor);
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_chan_get_min_rate, TI_DAVINCI_CPDMA);

 /* cpdma_chan_set_rate - limits bandwidth for transmit channel.
  * The bandwidth * limited channels have to be in order beginning from low=
est.
@@ -860,6 +870,7 @@ int cpdma_chan_set_rate(struct cpdma_chan *ch, u32 rate=
)
 =09spin_unlock_irqrestore(&ctlr->lock, flags);
 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_chan_set_rate, TI_DAVINCI_CPDMA);

 u32 cpdma_chan_get_rate(struct cpdma_chan *ch)
 {
@@ -872,6 +883,7 @@ u32 cpdma_chan_get_rate(struct cpdma_chan *ch)

 =09return rate;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_chan_get_rate, TI_DAVINCI_CPDMA);

 struct cpdma_chan *cpdma_chan_create(struct cpdma_ctlr *ctlr, int chan_num=
,
 =09=09=09=09     cpdma_handler_fn handler, int rx_type)
@@ -931,6 +943,7 @@ struct cpdma_chan *cpdma_chan_create(struct cpdma_ctlr =
*ctlr, int chan_num,
 =09spin_unlock_irqrestore(&ctlr->lock, flags);
 =09return chan;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_chan_create, TI_DAVINCI_CPDMA);

 int cpdma_chan_get_rx_buf_num(struct cpdma_chan *chan)
 {
@@ -943,6 +956,7 @@ int cpdma_chan_get_rx_buf_num(struct cpdma_chan *chan)

 =09return desc_num;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_chan_get_rx_buf_num, TI_DAVINCI_CPDMA);

 int cpdma_chan_destroy(struct cpdma_chan *chan)
 {
@@ -964,6 +978,7 @@ int cpdma_chan_destroy(struct cpdma_chan *chan)
 =09spin_unlock_irqrestore(&ctlr->lock, flags);
 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_chan_destroy, TI_DAVINCI_CPDMA);

 int cpdma_chan_get_stats(struct cpdma_chan *chan,
 =09=09=09 struct cpdma_chan_stats *stats)
@@ -976,6 +991,7 @@ int cpdma_chan_get_stats(struct cpdma_chan *chan,
 =09spin_unlock_irqrestore(&chan->lock, flags);
 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_chan_get_stats, TI_DAVINCI_CPDMA);

 static void __cpdma_chan_submit(struct cpdma_chan *chan,
 =09=09=09=09struct cpdma_desc __iomem *desc)
@@ -1100,6 +1116,7 @@ int cpdma_chan_idle_submit(struct cpdma_chan *chan, v=
oid *token, void *data,
 =09spin_unlock_irqrestore(&chan->lock, flags);
 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_chan_idle_submit, TI_DAVINCI_CPDMA);

 int cpdma_chan_idle_submit_mapped(struct cpdma_chan *chan, void *token,
 =09=09=09=09  dma_addr_t data, int len, int directed)
@@ -1125,6 +1142,7 @@ int cpdma_chan_idle_submit_mapped(struct cpdma_chan *=
chan, void *token,
 =09spin_unlock_irqrestore(&chan->lock, flags);
 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_chan_idle_submit_mapped, TI_DAVINCI_CPDMA);

 int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data,
 =09=09      int len, int directed)
@@ -1150,6 +1168,7 @@ int cpdma_chan_submit(struct cpdma_chan *chan, void *=
token, void *data,
 =09spin_unlock_irqrestore(&chan->lock, flags);
 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_chan_submit, TI_DAVINCI_CPDMA);

 int cpdma_chan_submit_mapped(struct cpdma_chan *chan, void *token,
 =09=09=09     dma_addr_t data, int len, int directed)
@@ -1175,6 +1194,7 @@ int cpdma_chan_submit_mapped(struct cpdma_chan *chan,=
 void *token,
 =09spin_unlock_irqrestore(&chan->lock, flags);
 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_chan_submit_mapped, TI_DAVINCI_CPDMA);

 bool cpdma_check_free_tx_desc(struct cpdma_chan *chan)
 {
@@ -1189,6 +1209,7 @@ bool cpdma_check_free_tx_desc(struct cpdma_chan *chan=
)
 =09spin_unlock_irqrestore(&chan->lock, flags);
 =09return free_tx_desc;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_check_free_tx_desc, TI_DAVINCI_CPDMA);

 static void __cpdma_chan_free(struct cpdma_chan *chan,
 =09=09=09      struct cpdma_desc __iomem *desc,
@@ -1289,6 +1310,7 @@ int cpdma_chan_process(struct cpdma_chan *chan, int q=
uota)
 =09}
 =09return used;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_chan_process, TI_DAVINCI_CPDMA);

 int cpdma_chan_start(struct cpdma_chan *chan)
 {
@@ -1308,6 +1330,7 @@ int cpdma_chan_start(struct cpdma_chan *chan)

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_chan_start, TI_DAVINCI_CPDMA);

 int cpdma_chan_stop(struct cpdma_chan *chan)
 {
@@ -1370,6 +1393,7 @@ int cpdma_chan_stop(struct cpdma_chan *chan)
 =09spin_unlock_irqrestore(&chan->lock, flags);
 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_chan_stop, TI_DAVINCI_CPDMA);

 int cpdma_chan_int_ctrl(struct cpdma_chan *chan, bool enable)
 {
@@ -1387,6 +1411,7 @@ int cpdma_chan_int_ctrl(struct cpdma_chan *chan, bool=
 enable)

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_chan_int_ctrl, TI_DAVINCI_CPDMA);

 int cpdma_control_get(struct cpdma_ctlr *ctlr, int control)
 {
@@ -1399,6 +1424,7 @@ int cpdma_control_get(struct cpdma_ctlr *ctlr, int co=
ntrol)

 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_control_get, TI_DAVINCI_CPDMA);

 int cpdma_control_set(struct cpdma_ctlr *ctlr, int control, int value)
 {
@@ -1411,16 +1437,19 @@ int cpdma_control_set(struct cpdma_ctlr *ctlr, int =
control, int value)

 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_control_set, TI_DAVINCI_CPDMA);

 int cpdma_get_num_rx_descs(struct cpdma_ctlr *ctlr)
 {
 =09return ctlr->num_rx_desc;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_get_num_rx_descs, TI_DAVINCI_CPDMA);

 int cpdma_get_num_tx_descs(struct cpdma_ctlr *ctlr)
 {
 =09return ctlr->num_tx_desc;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_get_num_tx_descs, TI_DAVINCI_CPDMA);

 int cpdma_set_num_rx_descs(struct cpdma_ctlr *ctlr, int num_rx_desc)
 {
@@ -1442,3 +1471,7 @@ int cpdma_set_num_rx_descs(struct cpdma_ctlr *ctlr, i=
nt num_rx_desc)

 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(cpdma_set_num_rx_descs, TI_DAVINCI_CPDMA);
+
+MODULE_DESCRIPTION("TI CPDMA driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/=
ti/davinci_emac.c
index 2eb9d5a32588..897def12e6ec 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -2103,6 +2103,8 @@ static void __exit davinci_emac_exit(void)
 }
 module_exit(davinci_emac_exit);

+MODULE_IMPORT_NS(TI_DAVINCI_CPDMA);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("DaVinci EMAC Maintainer: Anant Gole <anantgole@ti.com>");
 MODULE_AUTHOR("DaVinci EMAC Maintainer: Chaithrika U S <chaithrika@ti.com>=
");
--
2.38.1


