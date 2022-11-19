Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2646311D0
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 00:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbiKSXJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 18:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235369AbiKSXJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 18:09:11 -0500
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8575A1A387;
        Sat, 19 Nov 2022 15:09:07 -0800 (PST)
Date:   Sat, 19 Nov 2022 23:09:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail3; t=1668899345; x=1669158545;
        bh=9qGKLVCjbHAnH91XpqmRTavbfWbbwNUr7AChPSqtfkk=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=WCecC2ln5RP+48I8SIV0O0Fq3LMH3WSUI03jOJLR+06GIB7qPmWjWYfLY26fBM/CW
         Gk0cN2crtbQiGm180ZtSKFFNEsOUuyhsIKee05mLt2p63kIkNJEjxYWcZ6LLy3fFO5
         AOuH2sEbAYhqfjRzPMzyxOeBQwqXtWKmNRJF13iXV1/2d8norveB12DLtdbi0WIrft
         6Gw1Bb3OXdgE7CIUrrK6AARwh3IcRQ6fbPFMLnWqhpjRvEMUe5YyzRFngc8gmLsPN+
         RC+gHksfZXJCNyBRPXj7Hu3QC1o4n+j+KbjlOPepCKVERJ6uxcpdiep1BW8i3R10zP
         WwiZ4OYmWxhkQ==
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
Subject: [PATCH 13/18] crypto: octeontx2: fix objects shared between several modules
Message-ID: <20221119225650.1044591-14-alobakin@pm.me>
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

cn10k_cpt.o, otx2_cptlf.o and otx2_cpt_mbox_common.o are linked
into both rvu_cptpf and rvu_cptvf modules:

> scripts/Makefile.build:252: ./drivers/crypto/marvell/octeontx2/Makefile:
> cn10k_cpt.o is added to multiple modules: rvu_cptpf rvu_cptvf
> scripts/Makefile.build:252: ./drivers/crypto/marvell/octeontx2/Makefile:
> otx2_cptlf.o is added to multiple modules: rvu_cptpf rvu_cptvf
> scripts/Makefile.build:252: ./drivers/crypto/marvell/octeontx2/Makefile:
> otx2_cpt_mbox_common.o is added to multiple modules: rvu_cptpf rvu_cptvf

Despite they're build under the same Kconfig option
(CONFIG_CRYPTO_DEV_OCTEONTX2_CPT), it's better do link the common
code into a standalone module and export the shared functions. Under
certain circumstances, this can lead to the same situation as fixed
by commit 637a642f5ca5 ("zstd: Fixing mixed module-builtin objects").
Plus, those three common object files are relatively big to duplicate
them several times.

Introduce the new module, rvu_cptcommon, to provide the common
functions to both modules.

Fixes: 19d8e8c7be15 ("crypto: octeontx2 - add virtual function driver suppo=
rt")
Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 drivers/crypto/marvell/octeontx2/Makefile          | 11 +++++------
 drivers/crypto/marvell/octeontx2/cn10k_cpt.c       |  9 +++++++--
 drivers/crypto/marvell/octeontx2/cn10k_cpt.h       |  2 --
 drivers/crypto/marvell/octeontx2/otx2_cpt_common.h |  2 --
 .../marvell/octeontx2/otx2_cpt_mbox_common.c       | 14 ++++++++++++--
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c      | 11 +++++++++++
 drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c |  2 ++
 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c |  2 ++
 8 files changed, 39 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/Makefile b/drivers/crypto/mar=
vell/octeontx2/Makefile
index 965297e96954..f0f2942c1d27 100644
--- a/drivers/crypto/marvell/octeontx2/Makefile
+++ b/drivers/crypto/marvell/octeontx2/Makefile
@@ -1,11 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_CRYPTO_DEV_OCTEONTX2_CPT) +=3D rvu_cptpf.o rvu_cptvf.o
+obj-$(CONFIG_CRYPTO_DEV_OCTEONTX2_CPT) +=3D rvu_cptcommon.o rvu_cptpf.o rv=
u_cptvf.o

+rvu_cptcommon-objs :=3D cn10k_cpt.o otx2_cptlf.o otx2_cpt_mbox_common.o
 rvu_cptpf-objs :=3D otx2_cptpf_main.o otx2_cptpf_mbox.o \
-=09=09  otx2_cpt_mbox_common.o otx2_cptpf_ucode.o otx2_cptlf.o \
-=09=09  cn10k_cpt.o otx2_cpt_devlink.o
-rvu_cptvf-objs :=3D otx2_cptvf_main.o otx2_cptvf_mbox.o otx2_cptlf.o \
-=09=09  otx2_cpt_mbox_common.o otx2_cptvf_reqmgr.o \
-=09=09  otx2_cptvf_algs.o cn10k_cpt.o
+=09=09  otx2_cptpf_ucode.o otx2_cpt_devlink.o
+rvu_cptvf-objs :=3D otx2_cptvf_main.o otx2_cptvf_mbox.o \
+=09=09  otx2_cptvf_reqmgr.o otx2_cptvf_algs.o

 ccflags-y +=3D -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/crypto/marvell/octeontx2/cn10k_cpt.c b/drivers/crypto/=
marvell/octeontx2/cn10k_cpt.c
index 1499ef75b5c2..93d22b328991 100644
--- a/drivers/crypto/marvell/octeontx2/cn10k_cpt.c
+++ b/drivers/crypto/marvell/octeontx2/cn10k_cpt.c
@@ -7,6 +7,9 @@
 #include "otx2_cptlf.h"
 #include "cn10k_cpt.h"

+static void cn10k_cpt_send_cmd(union otx2_cpt_inst_s *cptinst, u32 insts_n=
um,
+=09=09=09       struct otx2_cptlf_info *lf);
+
 static struct cpt_hw_ops otx2_hw_ops =3D {
 =09.send_cmd =3D otx2_cpt_send_cmd,
 =09.cpt_get_compcode =3D otx2_cpt_get_compcode,
@@ -19,8 +22,8 @@ static struct cpt_hw_ops cn10k_hw_ops =3D {
 =09.cpt_get_uc_compcode =3D cn10k_cpt_get_uc_compcode,
 };

-void cn10k_cpt_send_cmd(union otx2_cpt_inst_s *cptinst, u32 insts_num,
-=09=09=09struct otx2_cptlf_info *lf)
+static void cn10k_cpt_send_cmd(union otx2_cpt_inst_s *cptinst, u32 insts_n=
um,
+=09=09=09       struct otx2_cptlf_info *lf)
 {
 =09void __iomem *lmtline =3D lf->lmtline;
 =09u64 val =3D (lf->slot & 0x7FF);
@@ -68,6 +71,7 @@ int cn10k_cptpf_lmtst_init(struct otx2_cptpf_dev *cptpf)

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cn10k_cptpf_lmtst_init, CRYPTO_DEV_OCTEONTX2_CPT);

 int cn10k_cptvf_lmtst_init(struct otx2_cptvf_dev *cptvf)
 {
@@ -91,3 +95,4 @@ int cn10k_cptvf_lmtst_init(struct otx2_cptvf_dev *cptvf)

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(cn10k_cptvf_lmtst_init, CRYPTO_DEV_OCTEONTX2_CPT);
diff --git a/drivers/crypto/marvell/octeontx2/cn10k_cpt.h b/drivers/crypto/=
marvell/octeontx2/cn10k_cpt.h
index c091392b47e0..aaefc7e38e06 100644
--- a/drivers/crypto/marvell/octeontx2/cn10k_cpt.h
+++ b/drivers/crypto/marvell/octeontx2/cn10k_cpt.h
@@ -28,8 +28,6 @@ static inline u8 otx2_cpt_get_uc_compcode(union otx2_cpt_=
res_s *result)
 =09return ((struct cn9k_cpt_res_s *)result)->uc_compcode;
 }

-void cn10k_cpt_send_cmd(union otx2_cpt_inst_s *cptinst, u32 insts_num,
-=09=09=09struct otx2_cptlf_info *lf);
 int cn10k_cptpf_lmtst_init(struct otx2_cptpf_dev *cptpf);
 int cn10k_cptvf_lmtst_init(struct otx2_cptvf_dev *cptvf);

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/c=
rypto/marvell/octeontx2/otx2_cpt_common.h
index 5012b7e669f0..6019066a6451 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -145,8 +145,6 @@ int otx2_cpt_send_mbox_msg(struct otx2_mbox *mbox, stru=
ct pci_dev *pdev);

 int otx2_cpt_send_af_reg_requests(struct otx2_mbox *mbox,
 =09=09=09=09  struct pci_dev *pdev);
-int otx2_cpt_add_read_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
-=09=09=09     u64 reg, u64 *val, int blkaddr);
 int otx2_cpt_add_write_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev=
,
 =09=09=09      u64 reg, u64 val, int blkaddr);
 int otx2_cpt_read_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c b/driv=
ers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
index a317319696ef..115997475beb 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_mbox_common.c
@@ -19,6 +19,7 @@ int otx2_cpt_send_mbox_msg(struct otx2_mbox *mbox, struct=
 pci_dev *pdev)
 =09}
 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cpt_send_mbox_msg, CRYPTO_DEV_OCTEONTX2_CPT);

 int otx2_cpt_send_ready_msg(struct otx2_mbox *mbox, struct pci_dev *pdev)
 {
@@ -36,14 +37,17 @@ int otx2_cpt_send_ready_msg(struct otx2_mbox *mbox, str=
uct pci_dev *pdev)

 =09return otx2_cpt_send_mbox_msg(mbox, pdev);
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cpt_send_ready_msg, CRYPTO_DEV_OCTEONTX2_CPT);

 int otx2_cpt_send_af_reg_requests(struct otx2_mbox *mbox, struct pci_dev *=
pdev)
 {
 =09return otx2_cpt_send_mbox_msg(mbox, pdev);
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cpt_send_af_reg_requests, CRYPTO_DEV_OCTEONTX2_C=
PT);

-int otx2_cpt_add_read_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
-=09=09=09     u64 reg, u64 *val, int blkaddr)
+static int otx2_cpt_add_read_af_reg(struct otx2_mbox *mbox,
+=09=09=09=09    struct pci_dev *pdev, u64 reg,
+=09=09=09=09    u64 *val, int blkaddr)
 {
 =09struct cpt_rd_wr_reg_msg *reg_msg;

@@ -91,6 +95,7 @@ int otx2_cpt_add_write_af_reg(struct otx2_mbox *mbox, str=
uct pci_dev *pdev,

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cpt_add_write_af_reg, CRYPTO_DEV_OCTEONTX2_CPT);

 int otx2_cpt_read_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
 =09=09=09 u64 reg, u64 *val, int blkaddr)
@@ -103,6 +108,7 @@ int otx2_cpt_read_af_reg(struct otx2_mbox *mbox, struct=
 pci_dev *pdev,

 =09return otx2_cpt_send_mbox_msg(mbox, pdev);
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cpt_read_af_reg, CRYPTO_DEV_OCTEONTX2_CPT);

 int otx2_cpt_write_af_reg(struct otx2_mbox *mbox, struct pci_dev *pdev,
 =09=09=09  u64 reg, u64 val, int blkaddr)
@@ -115,6 +121,7 @@ int otx2_cpt_write_af_reg(struct otx2_mbox *mbox, struc=
t pci_dev *pdev,

 =09return otx2_cpt_send_mbox_msg(mbox, pdev);
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cpt_write_af_reg, CRYPTO_DEV_OCTEONTX2_CPT);

 int otx2_cpt_attach_rscrs_msg(struct otx2_cptlfs_info *lfs)
 {
@@ -170,6 +177,7 @@ int otx2_cpt_detach_rsrcs_msg(struct otx2_cptlfs_info *=
lfs)

 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cpt_detach_rsrcs_msg, CRYPTO_DEV_OCTEONTX2_CPT);

 int otx2_cpt_msix_offset_msg(struct otx2_cptlfs_info *lfs)
 {
@@ -202,6 +210,7 @@ int otx2_cpt_msix_offset_msg(struct otx2_cptlfs_info *l=
fs)
 =09}
 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cpt_msix_offset_msg, CRYPTO_DEV_OCTEONTX2_CPT);

 int otx2_cpt_sync_mbox_msg(struct otx2_mbox *mbox)
 {
@@ -216,3 +225,4 @@ int otx2_cpt_sync_mbox_msg(struct otx2_mbox *mbox)

 =09return otx2_mbox_check_rsp_msgs(mbox, 0);
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cpt_sync_mbox_msg, CRYPTO_DEV_OCTEONTX2_CPT);
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.c b/drivers/crypto=
/marvell/octeontx2/otx2_cptlf.c
index c8350fcd60fa..fc484cb05c0f 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.c
@@ -274,6 +274,8 @@ void otx2_cptlf_unregister_interrupts(struct otx2_cptlf=
s_info *lfs)
 =09}
 =09cptlf_disable_intrs(lfs);
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cptlf_unregister_interrupts,
+=09=09     CRYPTO_DEV_OCTEONTX2_CPT);

 static int cptlf_do_register_interrrupts(struct otx2_cptlfs_info *lfs,
 =09=09=09=09=09 int lf_num, int irq_offset,
@@ -321,6 +323,7 @@ int otx2_cptlf_register_interrupts(struct otx2_cptlfs_i=
nfo *lfs)
 =09otx2_cptlf_unregister_interrupts(lfs);
 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cptlf_register_interrupts, CRYPTO_DEV_OCTEONTX2_=
CPT);

 void otx2_cptlf_free_irqs_affinity(struct otx2_cptlfs_info *lfs)
 {
@@ -334,6 +337,7 @@ void otx2_cptlf_free_irqs_affinity(struct otx2_cptlfs_i=
nfo *lfs)
 =09=09free_cpumask_var(lfs->lf[slot].affinity_mask);
 =09}
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cptlf_free_irqs_affinity, CRYPTO_DEV_OCTEONTX2_C=
PT);

 int otx2_cptlf_set_irqs_affinity(struct otx2_cptlfs_info *lfs)
 {
@@ -366,6 +370,7 @@ int otx2_cptlf_set_irqs_affinity(struct otx2_cptlfs_inf=
o *lfs)
 =09otx2_cptlf_free_irqs_affinity(lfs);
 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cptlf_set_irqs_affinity, CRYPTO_DEV_OCTEONTX2_CP=
T);

 int otx2_cptlf_init(struct otx2_cptlfs_info *lfs, u8 eng_grp_mask, int pri=
,
 =09=09    int lfs_num)
@@ -422,6 +427,7 @@ int otx2_cptlf_init(struct otx2_cptlfs_info *lfs, u8 en=
g_grp_mask, int pri,
 =09lfs->lfs_num =3D 0;
 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cptlf_init, CRYPTO_DEV_OCTEONTX2_CPT);

 void otx2_cptlf_shutdown(struct otx2_cptlfs_info *lfs)
 {
@@ -431,3 +437,8 @@ void otx2_cptlf_shutdown(struct otx2_cptlfs_info *lfs)
 =09/* Send request to detach LFs */
 =09otx2_cpt_detach_rsrcs_msg(lfs);
 }
+EXPORT_SYMBOL_NS_GPL(otx2_cptlf_shutdown, CRYPTO_DEV_OCTEONTX2_CPT);
+
+MODULE_AUTHOR("Marvell");
+MODULE_DESCRIPTION("Marvell RVU CPT Common module");
+MODULE_LICENSE("GPL");
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/c=
rypto/marvell/octeontx2/otx2_cptpf_main.c
index a402ccfac557..ddf6e913c1c4 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -831,6 +831,8 @@ static struct pci_driver otx2_cpt_pci_driver =3D {

 module_pci_driver(otx2_cpt_pci_driver);

+MODULE_IMPORT_NS(CRYPTO_DEV_OCTEONTX2_CPT);
+
 MODULE_AUTHOR("Marvell");
 MODULE_DESCRIPTION(OTX2_CPT_DRV_STRING);
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c b/drivers/c=
rypto/marvell/octeontx2/otx2_cptvf_main.c
index 3411e664cf50..392e9fee05e8 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
@@ -429,6 +429,8 @@ static struct pci_driver otx2_cptvf_pci_driver =3D {

 module_pci_driver(otx2_cptvf_pci_driver);

+MODULE_IMPORT_NS(CRYPTO_DEV_OCTEONTX2_CPT);
+
 MODULE_AUTHOR("Marvell");
 MODULE_DESCRIPTION("Marvell RVU CPT Virtual Function Driver");
 MODULE_LICENSE("GPL v2");
--
2.38.1


