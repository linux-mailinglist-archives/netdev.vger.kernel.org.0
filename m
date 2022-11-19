Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D076311DE
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 00:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235403AbiKSXLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 18:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235277AbiKSXKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 18:10:53 -0500
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77941A388
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 15:10:51 -0800 (PST)
Date:   Sat, 19 Nov 2022 23:10:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail3; t=1668899445; x=1669158645;
        bh=lZ7Rs/ZnddACw1jvzs/PqLsltYLTGpkimYjbYKt//JU=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=MwkzEn1Z43pI6k3ysRRUAd78NdgilKCbiURPSU97ud6PlYDuD3r4wX6kynsud2BDV
         FTgz0dIEhO0vqk69Q9ajklQkuUJTQUtv5Kfke1xyFpEpF9rgACfyhr4daSrfsx3B1J
         NwVytXSux8c4DY7dTJbFnBZ/5qoUCO+b5JS9y9tdhpIdlnUzDdVB481RrUoLPXyFop
         7beDz4m4lmYWIDUYmcAC+eEZKejYBokFJWi6hPnMt+kecxCZ+rwCuKqGUI83jvEfX6
         Np0bActEFWr2aY6rHGeA31YLT/OZPm6Ym/XQ2GGyRphcbaJSkCAUykj1kUORpfvI1G
         tMIri4Tqm44TQ==
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
Subject: [PATCH 17/18] net: octeontx2: fix mixed module-builtin object
Message-ID: <20221119225650.1044591-18-alobakin@pm.me>
In-Reply-To: <20221119225650.1044591-1-alobakin@pm.me>
References: <20221119225650.1044591-1-alobakin@pm.me>
Feedback-ID: 22809121:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With CONFIG_OCTEONTX2_PF=3Dy and CONFIG_OCTEONTX2_VF=3Dm, several object
files  are linked to a module and also to vmlinux even though the
expected CFLAGS are different between builtins and modules.
This is the same situation as fixed by
commit 637a642f5ca5 ("zstd: Fixing mixed module-builtin objects").
There's also no need to duplicate relatively big piece of object
code into two modules.

Introduce the new module, rvu_niccommon, to provide the common
functions to both rvu_nicpf and rvu_nicvf. Also, otx2_ptp.o was not
shared, but built as a standalone module (it was fixed already a year
ago the same way this commit does due to link issues). As it's used
by both PF and VF modules in the same way, just link it into that new
common one.

Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mcam entr=
y count")
Fixes: 8e67558177f8 ("octeontx2-pf: PFC config support with DCBx")
Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 drivers/net/ethernet/marvell/octeontx2/Kconfig     |  5 +++++
 .../net/ethernet/marvell/octeontx2/nic/Makefile    | 14 +++++++-------
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  1 -
 .../ethernet/marvell/octeontx2/nic/otx2_dcbnl.c    |  8 +++++++-
 .../ethernet/marvell/octeontx2/nic/otx2_devlink.c  |  2 ++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  2 ++
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  |  2 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |  2 ++
 8 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/Kconfig b/drivers/net/e=
thernet/marvell/octeontx2/Kconfig
index 6b4f640163f7..eb03bdcaf606 100644
--- a/drivers/net/ethernet/marvell/octeontx2/Kconfig
+++ b/drivers/net/ethernet/marvell/octeontx2/Kconfig
@@ -28,8 +28,12 @@ config NDC_DIS_DYNAMIC_CACHING
 =09  , NPA stack pages etc in NDC. Also locks down NIX SQ/CQ/RQ/RSS and
 =09  NPA Aura/Pool contexts.

+config OCTEONTX2_NIC_COMMON
+=09tristate
+
 config OCTEONTX2_PF
 =09tristate "Marvell OcteonTX2 NIC Physical Function driver"
+=09select OCTEONTX2_NIC_COMMON
 =09select OCTEONTX2_MBOX
 =09select NET_DEVLINK
 =09depends on MACSEC || !MACSEC
@@ -44,5 +48,6 @@ config OCTEONTX2_PF
 config OCTEONTX2_VF
 =09tristate "Marvell OcteonTX2 NIC Virtual Function driver"
 =09depends on OCTEONTX2_PF
+=09select OCTEONTX2_NIC_COMMON
 =09help
 =09  This driver supports Marvell's OcteonTX2 NIC virtual function.
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile b/drivers/=
net/ethernet/marvell/octeontx2/nic/Makefile
index 73fdb8798614..040c841645bd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
@@ -3,16 +3,16 @@
 # Makefile for Marvell's RVU Ethernet device drivers
 #

-obj-$(CONFIG_OCTEONTX2_PF) +=3D rvu_nicpf.o otx2_ptp.o
-obj-$(CONFIG_OCTEONTX2_VF) +=3D rvu_nicvf.o otx2_ptp.o
+obj-$(CONFIG_OCTEONTX2_NIC_COMMON) +=3D rvu_niccommon.o
+obj-$(CONFIG_OCTEONTX2_PF) +=3D rvu_nicpf.o
+obj-$(CONFIG_OCTEONTX2_VF) +=3D rvu_nicvf.o

+rvu_niccommon-y :=3D otx2_devlink.o otx2_ptp.o
 rvu_nicpf-y :=3D otx2_pf.o otx2_common.o otx2_txrx.o otx2_ethtool.o \
-               otx2_flows.o otx2_tc.o cn10k.o otx2_dmac_flt.o \
-               otx2_devlink.o
-rvu_nicvf-y :=3D otx2_vf.o otx2_devlink.o
+               otx2_flows.o otx2_tc.o cn10k.o otx2_dmac_flt.o
+rvu_nicvf-y :=3D otx2_vf.o

-rvu_nicpf-$(CONFIG_DCB) +=3D otx2_dcbnl.o
-rvu_nicvf-$(CONFIG_DCB) +=3D otx2_dcbnl.o
+rvu_niccommon-$(CONFIG_DCB) +=3D otx2_dcbnl.o
 rvu_nicpf-$(CONFIG_MACSEC) +=3D cn10k_macsec.o

 ccflags-y +=3D -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/dri=
vers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 282db6fe3b08..06307000cfd1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -1018,7 +1018,6 @@ int otx2_dcbnl_set_ops(struct net_device *dev);
 /* PFC support */
 int otx2_pfc_txschq_config(struct otx2_nic *pfvf);
 int otx2_pfc_txschq_alloc(struct otx2_nic *pfvf);
-int otx2_pfc_txschq_update(struct otx2_nic *pfvf);
 int otx2_pfc_txschq_stop(struct otx2_nic *pfvf);
 #endif

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c b/driv=
ers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c
index ccaf97bb1ce0..8e862785325d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c
@@ -54,6 +54,7 @@ int otx2_pfc_txschq_config(struct otx2_nic *pfvf)

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(otx2_pfc_txschq_config, OCTEONTX2_NIC_COMMON);

 static int otx2_pfc_txschq_alloc_one(struct otx2_nic *pfvf, u8 prio)
 {
@@ -122,6 +123,7 @@ int otx2_pfc_txschq_alloc(struct otx2_nic *pfvf)

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(otx2_pfc_txschq_alloc, OCTEONTX2_NIC_COMMON);

 static int otx2_pfc_txschq_stop_one(struct otx2_nic *pfvf, u8 prio)
 {
@@ -201,7 +203,7 @@ static int otx2_pfc_update_sq_smq_mapping(struct otx2_n=
ic *pfvf, int prio)
 =09return 0;
 }

-int otx2_pfc_txschq_update(struct otx2_nic *pfvf)
+static int otx2_pfc_txschq_update(struct otx2_nic *pfvf)
 {
 =09bool if_up =3D netif_running(pfvf->netdev);
 =09u8 pfc_en =3D pfvf->pfc_en, pfc_bit_set;
@@ -289,6 +291,7 @@ int otx2_pfc_txschq_stop(struct otx2_nic *pfvf)

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(otx2_pfc_txschq_stop, OCTEONTX2_NIC_COMMON);

 int otx2_config_priority_flow_ctrl(struct otx2_nic *pfvf)
 {
@@ -328,6 +331,7 @@ int otx2_config_priority_flow_ctrl(struct otx2_nic *pfv=
f)
 =09mutex_unlock(&pfvf->mbox.lock);
 =09return err;
 }
+EXPORT_SYMBOL_NS_GPL(otx2_config_priority_flow_ctrl, OCTEONTX2_NIC_COMMON)=
;

 void otx2_update_bpid_in_rqctx(struct otx2_nic *pfvf, int vlan_prio, int q=
idx,
 =09=09=09       bool pfc_enable)
@@ -392,6 +396,7 @@ void otx2_update_bpid_in_rqctx(struct otx2_nic *pfvf, i=
nt vlan_prio, int qidx,
 =09=09=09 "Updating BPIDs in CQ and Aura contexts of RQ%d failed with err =
%d\n",
 =09=09=09 qidx, err);
 }
+EXPORT_SYMBOL_NS_GPL(otx2_update_bpid_in_rqctx, OCTEONTX2_NIC_COMMON);

 static int otx2_dcbnl_ieee_getpfc(struct net_device *dev, struct ieee_pfc =
*pfc)
 {
@@ -468,3 +473,4 @@ int otx2_dcbnl_set_ops(struct net_device *dev)

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(otx2_dcbnl_set_ops, OCTEONTX2_NIC_COMMON);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c b/dr=
ivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
index 777a27047c8e..73cbedb861f3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.c
@@ -128,6 +128,7 @@ int otx2_register_dl(struct otx2_nic *pfvf)
 =09devlink_free(dl);
 =09return err;
 }
+EXPORT_SYMBOL_NS_GPL(otx2_register_dl, OCTEONTX2_NIC_COMMON);

 void otx2_unregister_dl(struct otx2_nic *pfvf)
 {
@@ -139,3 +140,4 @@ void otx2_unregister_dl(struct otx2_nic *pfvf)
 =09=09=09=09  ARRAY_SIZE(otx2_dl_params));
 =09devlink_free(dl);
 }
+EXPORT_SYMBOL_NS_GPL(otx2_unregister_dl, OCTEONTX2_NIC_COMMON);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers=
/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 303930499a4c..11e3ccee61c1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -34,6 +34,8 @@ static const struct pci_device_id otx2_pf_id_table[] =3D =
{
 =09{ 0, }  /* end of table */
 };

+MODULE_IMPORT_NS(OCTEONTX2_NIC_COMMON);
+
 MODULE_AUTHOR("Sunil Goutham <sgoutham@marvell.com>");
 MODULE_DESCRIPTION(DRV_STRING);
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c b/driver=
s/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
index 896b2f9bac34..ef48f50d3771 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
@@ -394,5 +394,5 @@ int otx2_ptp_tstamp2time(struct otx2_nic *pfvf, u64 tst=
amp, u64 *tsns)
 EXPORT_SYMBOL_GPL(otx2_ptp_tstamp2time);

 MODULE_AUTHOR("Sunil Goutham <sgoutham@marvell.com>");
-MODULE_DESCRIPTION("Marvell RVU NIC PTP Driver");
+MODULE_DESCRIPTION("Marvell RVU NIC Common Module");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers=
/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 86653bb8e403..59ec45e16637 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -24,6 +24,8 @@ static const struct pci_device_id otx2_vf_id_table[] =3D =
{
 =09{ }
 };

+MODULE_IMPORT_NS(OCTEONTX2_NIC_COMMON);
+
 MODULE_AUTHOR("Sunil Goutham <sgoutham@marvell.com>");
 MODULE_DESCRIPTION(DRV_STRING);
 MODULE_LICENSE("GPL v2");
--
2.38.1


