Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8376311C7
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 00:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbiKSXIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 18:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234794AbiKSXIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 18:08:02 -0500
Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FA01A201;
        Sat, 19 Nov 2022 15:08:01 -0800 (PST)
Date:   Sat, 19 Nov 2022 23:07:49 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail3; t=1668899279; x=1669158479;
        bh=Fcan82p+ax2WlxRBhBg1kgUsi97y6iC8yqz1mQgRMSY=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=MNkyYydhsrau86fX56V/ZK0IxXawrURgWy6h6DRdkKSpYLJwCK1YZL/9DAmJTM+lO
         IQXWEf2g+c4kQF71tJLMSO5LgZyl/xlqiATVfCsasAlVzcCh+dTLm41PCJPcGxdseh
         jWCi3MnVIb6v9R0v8CVq4fNwngDa7ooqiwKXCN5LPwN7Q3eTSgVd7ey+MJeljrvm0W
         vqjDmjmuQYhSKdl/mmOGDadnPOiPiYYJZE1XaBZMp6ARxL5Zmy4dWZV2CxUFra7ytO
         aK0P4FOhW7fvZDKpw040ciFjvH5WX2pSU66dGl6EiVD0d0TwC8eMqgz5qFDGi7g9TG
         rlEXU+EYqwu5w==
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
Subject: [PATCH 10/18] EDAC: i10nm, skx: fix mixed module-builtin object
Message-ID: <20221119225650.1044591-11-alobakin@pm.me>
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

With CONFIG_EDAC_SKX=3Dm and CONFIG_EDAC_I10NM=3Dy (or vice versa),
skx_common.o are linked to a module and also to vmlinux even though
the expected CFLAGS are different between builtins and modules:

> scripts/Makefile.build:252: ./drivers/edac/Makefile: skx_common.o
> is added to multiple modules: i10nm_edac skx_edac

This is the same situation as fixed by commit 637a642f5ca5 ("zstd:
Fixing mixed module-builtin objects").

Introduce the new module, skx_edac_common, to provide the common
functions to skx_edac and i10nm_edac. skx_adxl_{get,put}() loose
their __init/__exit annotations in order to become exportable.

Fixes: d4dc89d069aa ("EDAC, i10nm: Add a driver for Intel 10nm server proce=
ssors")
Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 drivers/edac/Kconfig      | 11 +++++++----
 drivers/edac/Makefile     |  7 +++++--
 drivers/edac/i10nm_base.c |  2 ++
 drivers/edac/skx_base.c   |  2 ++
 drivers/edac/skx_common.c | 21 +++++++++++++++++++--
 drivers/edac/skx_common.h |  4 ++--
 6 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 456602d373b7..c3d96d2a814b 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -236,12 +236,16 @@ config EDAC_SBRIDGE
 =09  Support for error detection and correction the Intel
 =09  Sandy Bridge, Ivy Bridge and Haswell Integrated Memory Controllers.

+config EDAC_SKX_COMMON
+=09tristate
+=09select ACPI_ADXL
+=09select DMI
+
 config EDAC_SKX
 =09tristate "Intel Skylake server Integrated MC"
 =09depends on PCI && X86_64 && X86_MCE_INTEL && PCI_MMCONFIG && ACPI
 =09depends on ACPI_NFIT || !ACPI_NFIT # if ACPI_NFIT=3Dm, EDAC_SKX can't b=
e y
-=09select DMI
-=09select ACPI_ADXL
+=09select EDAC_SKX_COMMON
 =09help
 =09  Support for error detection and correction the Intel
 =09  Skylake server Integrated Memory Controllers. If your
@@ -252,8 +256,7 @@ config EDAC_I10NM
 =09tristate "Intel 10nm server Integrated MC"
 =09depends on PCI && X86_64 && X86_MCE_INTEL && PCI_MMCONFIG && ACPI
 =09depends on ACPI_NFIT || !ACPI_NFIT # if ACPI_NFIT=3Dm, EDAC_I10NM can't=
 be y
-=09select DMI
-=09select ACPI_ADXL
+=09select EDAC_SKX_COMMON
 =09help
 =09  Support for error detection and correction the Intel
 =09  10nm server Integrated Memory Controllers. If your
diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index 2d1641a27a28..36e6e07d4048 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -54,10 +54,13 @@ obj-$(CONFIG_EDAC_MPC85XX)=09=09+=3D mpc85xx_edac_mod.o
 layerscape_edac_mod-y=09=09=09:=3D fsl_ddr_edac.o layerscape_edac.o
 obj-$(CONFIG_EDAC_LAYERSCAPE)=09=09+=3D layerscape_edac_mod.o

-skx_edac-y=09=09=09=09:=3D skx_common.o skx_base.o
+skx_edac_common-y=09=09=09:=3D skx_common.o
+obj-$(CONFIG_EDAC_SKX_COMMON)=09=09+=3D skx_edac_common.o
+
+skx_edac-y=09=09=09=09:=3D skx_base.o
 obj-$(CONFIG_EDAC_SKX)=09=09=09+=3D skx_edac.o

-i10nm_edac-y=09=09=09=09:=3D skx_common.o i10nm_base.o
+i10nm_edac-y=09=09=09=09:=3D i10nm_base.o
 obj-$(CONFIG_EDAC_I10NM)=09=09+=3D i10nm_edac.o

 obj-$(CONFIG_EDAC_CELL)=09=09=09+=3D cell_edac.o
diff --git a/drivers/edac/i10nm_base.c b/drivers/edac/i10nm_base.c
index a22ea053f8e1..949f665fd94c 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -900,5 +900,7 @@ MODULE_PARM_DESC(decoding_via_mca, "decoding_via_mca: 0=
=3Doff(default), 1=3Denable")
 module_param(retry_rd_err_log, int, 0444);
 MODULE_PARM_DESC(retry_rd_err_log, "retry_rd_err_log: 0=3Doff(default), 1=
=3Dbios(Linux doesn't reset any control bits, but just reports values.), 2=
=3Dlinux(Linux tries to take control and resets mode bits, clear valid/UC b=
its after reading.)");

+MODULE_IMPORT_NS(EDAC_SKX_COMMON);
+
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("MC Driver for Intel 10nm server processors");
diff --git a/drivers/edac/skx_base.c b/drivers/edac/skx_base.c
index 7e2762f62eec..1656cd4cd0ed 100644
--- a/drivers/edac/skx_base.c
+++ b/drivers/edac/skx_base.c
@@ -751,6 +751,8 @@ module_exit(skx_exit);
 module_param(edac_op_state, int, 0444);
 MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=3DPoll,1=3D=
NMI");

+MODULE_IMPORT_NS(EDAC_SKX_COMMON);
+
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Tony Luck");
 MODULE_DESCRIPTION("MC Driver for Intel Skylake server processors");
diff --git a/drivers/edac/skx_common.c b/drivers/edac/skx_common.c
index f0f8e98f6efb..15a3fb1224ae 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -48,7 +48,7 @@ static u64 skx_tolm, skx_tohm;
 static LIST_HEAD(dev_edac_list);
 static bool skx_mem_cfg_2lm;

-int __init skx_adxl_get(void)
+int skx_adxl_get(void)
 {
 =09const char * const *names;
 =09int i, j;
@@ -110,12 +110,14 @@ int __init skx_adxl_get(void)

 =09return -ENODEV;
 }
+EXPORT_SYMBOL_NS_GPL(skx_adxl_get, EDAC_SKX_COMMON);

-void __exit skx_adxl_put(void)
+void skx_adxl_put(void)
 {
 =09kfree(adxl_values);
 =09kfree(adxl_msg);
 }
+EXPORT_SYMBOL_NS_GPL(skx_adxl_put, EDAC_SKX_COMMON);

 static bool skx_adxl_decode(struct decoded_addr *res, bool error_in_1st_le=
vel_mem)
 {
@@ -187,12 +189,14 @@ void skx_set_mem_cfg(bool mem_cfg_2lm)
 {
 =09skx_mem_cfg_2lm =3D mem_cfg_2lm;
 }
+EXPORT_SYMBOL_NS_GPL(skx_set_mem_cfg, EDAC_SKX_COMMON);

 void skx_set_decode(skx_decode_f decode, skx_show_retry_log_f show_retry_l=
og)
 {
 =09driver_decode =3D decode;
 =09skx_show_retry_rd_err_log =3D show_retry_log;
 }
+EXPORT_SYMBOL_NS_GPL(skx_set_decode, EDAC_SKX_COMMON);

 int skx_get_src_id(struct skx_dev *d, int off, u8 *id)
 {
@@ -206,6 +210,7 @@ int skx_get_src_id(struct skx_dev *d, int off, u8 *id)
 =09*id =3D GET_BITFIELD(reg, 12, 14);
 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(skx_get_src_id, EDAC_SKX_COMMON);

 int skx_get_node_id(struct skx_dev *d, u8 *id)
 {
@@ -219,6 +224,7 @@ int skx_get_node_id(struct skx_dev *d, u8 *id)
 =09*id =3D GET_BITFIELD(reg, 0, 2);
 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(skx_get_node_id, EDAC_SKX_COMMON);

 static int get_width(u32 mtr)
 {
@@ -284,6 +290,7 @@ int skx_get_all_bus_mappings(struct res_config *cfg, st=
ruct list_head **list)
 =09=09*list =3D &dev_edac_list;
 =09return ndev;
 }
+EXPORT_SYMBOL_NS_GPL(skx_get_all_bus_mappings, EDAC_SKX_COMMON);

 int skx_get_hi_lo(unsigned int did, int off[], u64 *tolm, u64 *tohm)
 {
@@ -323,6 +330,7 @@ int skx_get_hi_lo(unsigned int did, int off[], u64 *tol=
m, u64 *tohm)
 =09pci_dev_put(pdev);
 =09return -ENODEV;
 }
+EXPORT_SYMBOL_NS_GPL(skx_get_hi_lo, EDAC_SKX_COMMON);

 static int skx_get_dimm_attr(u32 reg, int lobit, int hibit, int add,
 =09=09=09     int minval, int maxval, const char *name)
@@ -394,6 +402,7 @@ int skx_get_dimm_info(u32 mtr, u32 mcmtr, u32 amap, str=
uct dimm_info *dimm,

 =09return 1;
 }
+EXPORT_SYMBOL_NS_GPL(skx_get_dimm_info, EDAC_SKX_COMMON);

 int skx_get_nvdimm_info(struct dimm_info *dimm, struct skx_imc *imc,
 =09=09=09int chan, int dimmno, const char *mod_str)
@@ -442,6 +451,7 @@ int skx_get_nvdimm_info(struct dimm_info *dimm, struct =
skx_imc *imc,

 =09return (size =3D=3D 0 || size =3D=3D ~0ull) ? 0 : 1;
 }
+EXPORT_SYMBOL_NS_GPL(skx_get_nvdimm_info, EDAC_SKX_COMMON);

 int skx_register_mci(struct skx_imc *imc, struct pci_dev *pdev,
 =09=09     const char *ctl_name, const char *mod_str,
@@ -512,6 +522,7 @@ int skx_register_mci(struct skx_imc *imc, struct pci_de=
v *pdev,
 =09imc->mci =3D NULL;
 =09return rc;
 }
+EXPORT_SYMBOL_NS_GPL(skx_register_mci, EDAC_SKX_COMMON);

 static void skx_unregister_mci(struct skx_imc *imc)
 {
@@ -694,6 +705,7 @@ int skx_mce_check_error(struct notifier_block *nb, unsi=
gned long val,
 =09mce->kflags |=3D MCE_HANDLED_EDAC;
 =09return NOTIFY_DONE;
 }
+EXPORT_SYMBOL_NS_GPL(skx_mce_check_error, EDAC_SKX_COMMON);

 void skx_remove(void)
 {
@@ -731,3 +743,8 @@ void skx_remove(void)
 =09=09kfree(d);
 =09}
 }
+EXPORT_SYMBOL_NS_GPL(skx_remove, EDAC_SKX_COMMON);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Tony Luck");
+MODULE_DESCRIPTION("MC Common Library for Intel server processors");
diff --git a/drivers/edac/skx_common.h b/drivers/edac/skx_common.h
index 0cbadd3d2cd3..c0c174c101d2 100644
--- a/drivers/edac/skx_common.h
+++ b/drivers/edac/skx_common.h
@@ -178,8 +178,8 @@ typedef int (*get_dimm_config_f)(struct mem_ctl_info *m=
ci,
 typedef bool (*skx_decode_f)(struct decoded_addr *res);
 typedef void (*skx_show_retry_log_f)(struct decoded_addr *res, char *msg, =
int len, bool scrub_err);

-int __init skx_adxl_get(void);
-void __exit skx_adxl_put(void);
+int skx_adxl_get(void);
+void skx_adxl_put(void);
 void skx_set_decode(skx_decode_f decode, skx_show_retry_log_f show_retry_l=
og);
 void skx_set_mem_cfg(bool mem_cfg_2lm);

--
2.38.1


