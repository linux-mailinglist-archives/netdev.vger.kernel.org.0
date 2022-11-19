Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120696311C1
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 00:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235174AbiKSXHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 18:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbiKSXHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 18:07:10 -0500
Received: from mail-40131.protonmail.ch (mail-40131.protonmail.ch [185.70.40.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DB91A226;
        Sat, 19 Nov 2022 15:07:08 -0800 (PST)
Date:   Sat, 19 Nov 2022 23:06:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail3; t=1668899225; x=1669158425;
        bh=LnKnOV/7tqamV85lyv9w7/9/rIynES3UvAepG2Xk9lc=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=ExvFYecKRj5uu0y27km2iciyyRSVRCIgGEp4QeveHcaeRXUy0cl08EL3gJQ/cxm40
         lCfZ7esl/EROsiVfEhvfdIVsKdw+uqraePAZHr/3xBkGq1HgB9DKaOFUgL22LnRy9g
         Vm7FmrEwLtYfopgIOEmy42YTUzUlP+D+SY7p7zg7U2csOT+8ypPAX+3XWTdDu9Csbd
         INNlwQXnbg5yRwF5k17zD0rLctCH4N1wkYZwexs7g7rRJR4fMvQpOEeU8kmvTDTNDj
         g4e/TVxQfR1GbQEP2gGOZm79ObQ3T4EDpcoj18suV9vNcXy32r8JNANhSdNWqRJk6k
         Ucm0Me0ITfc1Q==
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
Subject: [PATCH 08/18] net: enetc: fix mixed module-builtin object
Message-ID: <20221119225650.1044591-9-alobakin@pm.me>
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

With CONFIG_FSL_ENETC=3Dm and CONFIG_FSL_ENETC_VF=3Dy (or vice versa),
$(common-objs) are linked to a module and also to vmlinux even though
the expected CFLAGS are different between builtins and modules.

This is the same situation as fixed by commit 637a642f5ca5 ("zstd:
Fixing mixed module-builtin objects").

Introduce the new module, fsl-enetc-core, to provide the common
functions to fsl-enetc and fsl-enetc-vf.

[ alobakin: add exports to common functions ]

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 drivers/net/ethernet/freescale/enetc/Kconfig  |  5 +++++
 drivers/net/ethernet/freescale/enetc/Makefile |  7 ++++---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 21 +++++++++++++++++++
 .../net/ethernet/freescale/enetc/enetc_cbdr.c |  7 +++++++
 .../ethernet/freescale/enetc/enetc_ethtool.c  |  2 ++
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  2 ++
 .../net/ethernet/freescale/enetc/enetc_vf.c   |  2 ++
 7 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/eth=
ernet/freescale/enetc/Kconfig
index cdc0ff89388a..a8a38df34760 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -1,7 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0
+config FSL_ENETC_CORE
+=09tristate
+
 config FSL_ENETC
 =09tristate "ENETC PF driver"
 =09depends on PCI && PCI_MSI
+=09select FSL_ENETC_CORE
 =09select FSL_ENETC_IERB
 =09select FSL_ENETC_MDIO
 =09select PHYLINK
@@ -17,6 +21,7 @@ config FSL_ENETC
 config FSL_ENETC_VF
 =09tristate "ENETC VF driver"
 =09depends on PCI && PCI_MSI
+=09select FSL_ENETC_CORE
 =09select FSL_ENETC_MDIO
 =09select PHYLINK
 =09select DIMLIB
diff --git a/drivers/net/ethernet/freescale/enetc/Makefile b/drivers/net/et=
hernet/freescale/enetc/Makefile
index e0e8dfd13793..d67319e09bad 100644
--- a/drivers/net/ethernet/freescale/enetc/Makefile
+++ b/drivers/net/ethernet/freescale/enetc/Makefile
@@ -1,14 +1,15 @@
 # SPDX-License-Identifier: GPL-2.0

-common-objs :=3D enetc.o enetc_cbdr.o enetc_ethtool.o
+obj-$(CONFIG_FSL_ENETC_CORE) +=3D fsl-enetc-core.o
+fsl-enetc-core-y +=3D enetc.o enetc_cbdr.o enetc_ethtool.o

 obj-$(CONFIG_FSL_ENETC) +=3D fsl-enetc.o
-fsl-enetc-y :=3D enetc_pf.o $(common-objs)
+fsl-enetc-y :=3D enetc_pf.o
 fsl-enetc-$(CONFIG_PCI_IOV) +=3D enetc_msg.o
 fsl-enetc-$(CONFIG_FSL_ENETC_QOS) +=3D enetc_qos.o

 obj-$(CONFIG_FSL_ENETC_VF) +=3D fsl-enetc-vf.o
-fsl-enetc-vf-y :=3D enetc_vf.o $(common-objs)
+fsl-enetc-vf-y :=3D enetc_vf.o

 obj-$(CONFIG_FSL_ENETC_IERB) +=3D fsl-enetc-ierb.o
 fsl-enetc-ierb-y :=3D enetc_ierb.o
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/eth=
ernet/freescale/enetc/enetc.c
index f8c06c3f9464..f13bb6b1c026 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -651,6 +651,7 @@ netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_=
device *ndev)

 =09return enetc_start_xmit(skb, ndev);
 }
+EXPORT_SYMBOL_NS_GPL(enetc_xmit, FSL_ENETC_CORE);

 static irqreturn_t enetc_msix(int irq, void *data)
 {
@@ -1384,6 +1385,7 @@ int enetc_xdp_xmit(struct net_device *ndev, int num_f=
rames,

 =09return xdp_tx_frm_cnt;
 }
+EXPORT_SYMBOL_NS_GPL(enetc_xdp_xmit, FSL_ENETC_CORE);

 static void enetc_map_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
 =09=09=09=09     struct xdp_buff *xdp_buff, u16 size)
@@ -1735,6 +1737,7 @@ void enetc_get_si_caps(struct enetc_si *si)
 =09if (val & ENETC_SIPCAPR0_PSFP)
 =09=09si->hw_features |=3D ENETC_SI_F_PSFP;
 }
+EXPORT_SYMBOL_NS_GPL(enetc_get_si_caps, FSL_ENETC_CORE);

 static int enetc_dma_alloc_bdr(struct enetc_bdr *r, size_t bd_size)
 {
@@ -1999,6 +2002,7 @@ int enetc_configure_si(struct enetc_ndev_priv *priv)

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(enetc_configure_si, FSL_ENETC_CORE);

 void enetc_init_si_rings_params(struct enetc_ndev_priv *priv)
 {
@@ -2018,6 +2022,7 @@ void enetc_init_si_rings_params(struct enetc_ndev_pri=
v *priv)
 =09priv->ic_mode =3D ENETC_IC_RX_ADAPTIVE | ENETC_IC_TX_MANUAL;
 =09priv->tx_ictt =3D ENETC_TXIC_TIMETHR;
 }
+EXPORT_SYMBOL_NS_GPL(enetc_init_si_rings_params, FSL_ENETC_CORE);

 int enetc_alloc_si_resources(struct enetc_ndev_priv *priv)
 {
@@ -2030,11 +2035,13 @@ int enetc_alloc_si_resources(struct enetc_ndev_priv=
 *priv)

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(enetc_alloc_si_resources, FSL_ENETC_CORE);

 void enetc_free_si_resources(struct enetc_ndev_priv *priv)
 {
 =09kfree(priv->cls_rules);
 }
+EXPORT_SYMBOL_NS_GPL(enetc_free_si_resources, FSL_ENETC_CORE);

 static void enetc_setup_txbdr(struct enetc_hw *hw, struct enetc_bdr *tx_ri=
ng)
 {
@@ -2398,6 +2405,7 @@ int enetc_open(struct net_device *ndev)

 =09return err;
 }
+EXPORT_SYMBOL_NS_GPL(enetc_open, FSL_ENETC_CORE);

 void enetc_stop(struct net_device *ndev)
 {
@@ -2439,6 +2447,7 @@ int enetc_close(struct net_device *ndev)

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(enetc_close, FSL_ENETC_CORE);

 int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 {
@@ -2494,6 +2503,7 @@ int enetc_setup_tc_mqprio(struct net_device *ndev, vo=
id *type_data)

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(enetc_setup_tc_mqprio, FSL_ENETC_CORE);

 static int enetc_setup_xdp_prog(struct net_device *dev, struct bpf_prog *p=
rog,
 =09=09=09=09struct netlink_ext_ack *extack)
@@ -2542,6 +2552,7 @@ int enetc_setup_bpf(struct net_device *dev, struct ne=
tdev_bpf *xdp)

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(enetc_setup_bpf, FSL_ENETC_CORE);

 struct net_device_stats *enetc_get_stats(struct net_device *ndev)
 {
@@ -2573,6 +2584,7 @@ struct net_device_stats *enetc_get_stats(struct net_d=
evice *ndev)

 =09return stats;
 }
+EXPORT_SYMBOL_NS_GPL(enetc_get_stats, FSL_ENETC_CORE);

 static int enetc_set_rss(struct net_device *ndev, int en)
 {
@@ -2625,6 +2637,7 @@ void enetc_set_features(struct net_device *ndev, netd=
ev_features_t features)
 =09=09enetc_enable_txvlan(ndev,
 =09=09=09=09    !!(features & NETIF_F_HW_VLAN_CTAG_TX));
 }
+EXPORT_SYMBOL_NS_GPL(enetc_set_features, FSL_ENETC_CORE);

 #ifdef CONFIG_FSL_ENETC_PTP_CLOCK
 static int enetc_hwtstamp_set(struct net_device *ndev, struct ifreq *ifr)
@@ -2708,6 +2721,7 @@ int enetc_ioctl(struct net_device *ndev, struct ifreq=
 *rq, int cmd)

 =09return phylink_mii_ioctl(priv->phylink, rq, cmd);
 }
+EXPORT_SYMBOL_NS_GPL(enetc_ioctl, FSL_ENETC_CORE);

 int enetc_alloc_msix(struct enetc_ndev_priv *priv)
 {
@@ -2809,6 +2823,7 @@ int enetc_alloc_msix(struct enetc_ndev_priv *priv)

 =09return err;
 }
+EXPORT_SYMBOL_NS_GPL(enetc_alloc_msix, FSL_ENETC_CORE);

 void enetc_free_msix(struct enetc_ndev_priv *priv)
 {
@@ -2838,6 +2853,7 @@ void enetc_free_msix(struct enetc_ndev_priv *priv)
 =09/* disable all MSIX for this device */
 =09pci_free_irq_vectors(priv->si->pdev);
 }
+EXPORT_SYMBOL_NS_GPL(enetc_free_msix, FSL_ENETC_CORE);

 static void enetc_kfree_si(struct enetc_si *si)
 {
@@ -2927,6 +2943,7 @@ int enetc_pci_probe(struct pci_dev *pdev, const char =
*name, int sizeof_priv)

 =09return err;
 }
+EXPORT_SYMBOL_NS_GPL(enetc_pci_probe, FSL_ENETC_CORE);

 void enetc_pci_remove(struct pci_dev *pdev)
 {
@@ -2938,3 +2955,7 @@ void enetc_pci_remove(struct pci_dev *pdev)
 =09pci_release_mem_regions(pdev);
 =09pci_disable_device(pdev);
 }
+EXPORT_SYMBOL_NS_GPL(enetc_pci_remove, FSL_ENETC_CORE);
+
+MODULE_DESCRIPTION("ENETC Core");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c b/drivers/ne=
t/ethernet/freescale/enetc/enetc_cbdr.c
index af68dc46a795..acb48ceef760 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_cbdr.c
@@ -44,6 +44,7 @@ int enetc_setup_cbdr(struct device *dev, struct enetc_hw =
*hw, int bd_count,

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(enetc_setup_cbdr, FSL_ENETC_CORE);

 void enetc_teardown_cbdr(struct enetc_cbdr *cbdr)
 {
@@ -57,6 +58,7 @@ void enetc_teardown_cbdr(struct enetc_cbdr *cbdr)
 =09cbdr->bd_base =3D NULL;
 =09cbdr->dma_dev =3D NULL;
 }
+EXPORT_SYMBOL_NS_GPL(enetc_teardown_cbdr, FSL_ENETC_CORE);

 static void enetc_clean_cbdr(struct enetc_cbdr *ring)
 {
@@ -127,6 +129,7 @@ int enetc_send_cmd(struct enetc_si *si, struct enetc_cb=
d *cbd)

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(enetc_send_cmd, FSL_ENETC_CORE);

 int enetc_clear_mac_flt_entry(struct enetc_si *si, int index)
 {
@@ -140,6 +143,7 @@ int enetc_clear_mac_flt_entry(struct enetc_si *si, int =
index)

 =09return enetc_send_cmd(si, &cbd);
 }
+EXPORT_SYMBOL_NS_GPL(enetc_clear_mac_flt_entry, FSL_ENETC_CORE);

 int enetc_set_mac_flt_entry(struct enetc_si *si, int index,
 =09=09=09    char *mac_addr, int si_map)
@@ -165,6 +169,7 @@ int enetc_set_mac_flt_entry(struct enetc_si *si, int in=
dex,

 =09return enetc_send_cmd(si, &cbd);
 }
+EXPORT_SYMBOL_NS_GPL(enetc_set_mac_flt_entry, FSL_ENETC_CORE);

 /* Set entry in RFS table */
 int enetc_set_fs_entry(struct enetc_si *si, struct enetc_cmd_rfse *rfse,
@@ -197,6 +202,7 @@ int enetc_set_fs_entry(struct enetc_si *si, struct enet=
c_cmd_rfse *rfse,

 =09return err;
 }
+EXPORT_SYMBOL_NS_GPL(enetc_set_fs_entry, FSL_ENETC_CORE);

 static int enetc_cmd_rss_table(struct enetc_si *si, u32 *table, int count,
 =09=09=09       bool read)
@@ -248,3 +254,4 @@ int enetc_set_rss_table(struct enetc_si *si, const u32 =
*table, int count)
 {
 =09return enetc_cmd_rss_table(si, (u32 *)table, count, false);
 }
+EXPORT_SYMBOL_NS_GPL(enetc_set_rss_table, FSL_ENETC_CORE);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers=
/net/ethernet/freescale/enetc/enetc_ethtool.c
index c8369e3752b0..e3d3a34fc96b 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -651,6 +651,7 @@ void enetc_set_rss_key(struct enetc_hw *hw, const u8 *b=
ytes)
 =09for (i =3D 0; i < ENETC_RSSHASH_KEY_SIZE / 4; i++)
 =09=09enetc_port_wr(hw, ENETC_PRSSK(i), ((u32 *)bytes)[i]);
 }
+EXPORT_SYMBOL_NS_GPL(enetc_set_rss_key, FSL_ENETC_CORE);

 static int enetc_set_rxfh(struct net_device *ndev, const u32 *indir,
 =09=09=09  const u8 *key, const u8 hfunc)
@@ -926,3 +927,4 @@ void enetc_set_ethtool_ops(struct net_device *ndev)
 =09else
 =09=09ndev->ethtool_ops =3D &enetc_vf_ethtool_ops;
 }
+EXPORT_SYMBOL_NS_GPL(enetc_set_ethtool_ops, FSL_ENETC_CORE);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/=
ethernet/freescale/enetc/enetc_pf.c
index bdf94335ee99..b767b6a28e8b 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1410,5 +1410,7 @@ static struct pci_driver enetc_pf_driver =3D {
 };
 module_pci_driver(enetc_pf_driver);

+MODULE_IMPORT_NS(FSL_ENETC_CORE);
+
 MODULE_DESCRIPTION(ENETC_DRV_NAME_STR);
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/=
ethernet/freescale/enetc/enetc_vf.c
index dfcaac302e24..ab53799618c7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -259,5 +259,7 @@ static struct pci_driver enetc_vf_driver =3D {
 };
 module_pci_driver(enetc_vf_driver);

+MODULE_IMPORT_NS(FSL_ENETC_CORE);
+
 MODULE_DESCRIPTION(ENETC_DRV_NAME_STR);
 MODULE_LICENSE("Dual BSD/GPL");
--
2.38.1


