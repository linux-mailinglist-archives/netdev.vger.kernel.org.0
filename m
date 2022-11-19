Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD856311DB
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 00:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235356AbiKSXKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 18:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235358AbiKSXKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 18:10:32 -0500
Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA32E1A388
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 15:10:29 -0800 (PST)
Date:   Sat, 19 Nov 2022 23:10:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail3; t=1668899426; x=1669158626;
        bh=dLpVCSQ868jTQI0UEQak6Ixr4hg4QGS4MH1h5Bp37Lo=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=CLfIVcENLVIOE6aagoAfxqzXNsAY/G0/si5BoaVMxMlPKMHrLyYq5ht21MAj0YUn/
         pLshkIokAYzyq5LpJBJgD2BI134jO05uXsBPglcnfzlM7QGdleh9ChEJK1RB4qadn+
         Rnvhtyg7wB+KDZ23EE86AmWhvEs41O29Zul1Asja7tEEAtdvLFr5OGyApfnyH8rsWS
         DTkZfnPiwlIvkSYb3zYjn7ZA3nS9aCUsoAH13rOzMc9gtVICNastFpb21M8DW78TFM
         vIBoyZr1BVh8yUgZOkgIjZWEEZ4eHGz4KtMhSN1SBhL9sQbUwKA5XzzZSD/xr/Jm1z
         8qlb5S1rFJMtA==
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
Subject: [PATCH 16/18] net: hns3: fix mixed module-builtin object
Message-ID: <20221119225650.1044591-17-alobakin@pm.me>
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

With CONFIG_HNS3_HCLGE=3Dy and CONFIG_HNS3_HCLGEVF=3Dm, objects from
hns3/hns3_common are linked into a module and into vmlinux even
though the expected CFLAGS are different between builtins and
modules.
This is the same situation as fixed by
commit 637a642f5ca5 ("zstd: Fixing mixed module-builtin objects").
There's also no need to duplicate such big piece of object code into
two modules.

Introduce the new module, hclge_common, to provide the common
functions to both hclge and hclgevf.

Fixes: eaa5607db377 ("net: hns3: refactor hclge_cmd_send with new hclge_com=
m_cmd_send API")
Fixes: 1bfd6682e9b5 ("net: hns3: create new set of common rss get APIs for =
PF and VF rss module")
Fixes: 287db5c40d15 ("net: hns3: create new set of common tqp stats APIs fo=
r PF and VF reuse")
Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 drivers/net/ethernet/hisilicon/Kconfig        |  5 ++++
 drivers/net/ethernet/hisilicon/hns3/Makefile  | 13 +++++----
 .../hns3/hns3_common/hclge_comm_cmd.c         | 27 +++++++++++++------
 .../hns3/hns3_common/hclge_comm_cmd.h         |  8 ------
 .../hns3/hns3_common/hclge_comm_rss.c         | 17 ++++++++++++
 .../hns3/hns3_common/hclge_comm_tqp_stats.c   |  5 ++++
 .../hisilicon/hns3/hns3pf/hclge_main.c        |  2 ++
 .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  2 ++
 8 files changed, 58 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/Kconfig b/drivers/net/ethernet/=
hisilicon/Kconfig
index 3312e1d93c3b..9d2be93d0378 100644
--- a/drivers/net/ethernet/hisilicon/Kconfig
+++ b/drivers/net/ethernet/hisilicon/Kconfig
@@ -100,11 +100,15 @@ config HNS3

 if HNS3

+config HNS3_HCLGE_COMMON
+=09tristate
+
 config HNS3_HCLGE
 =09tristate "Hisilicon HNS3 HCLGE Acceleration Engine & Compatibility Laye=
r Support"
 =09default m
 =09depends on PCI_MSI
 =09depends on PTP_1588_CLOCK_OPTIONAL
+=09select HNS3_HCLGE_COMMON
 =09help
 =09  This selects the HNS3_HCLGE network acceleration engine & its hardwar=
e
 =09  compatibility layer. The engine would be used in Hisilicon hip08 fami=
ly of
@@ -123,6 +127,7 @@ config HNS3_HCLGEVF
 =09tristate "Hisilicon HNS3VF Acceleration Engine & Compatibility Layer Su=
pport"
 =09depends on PCI_MSI
 =09depends on HNS3_HCLGE
+=09select HNS3_HCLGE_COMMON
 =09help
 =09  This selects the HNS3 VF drivers network acceleration engine & its ha=
rdware
 =09  compatibility layer. The engine would be used in Hisilicon hip08 fami=
ly of
diff --git a/drivers/net/ethernet/hisilicon/hns3/Makefile b/drivers/net/eth=
ernet/hisilicon/hns3/Makefile
index 6efea4662858..09d0e442b7fb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/Makefile
+++ b/drivers/net/ethernet/hisilicon/hns3/Makefile
@@ -13,17 +13,20 @@ obj-$(CONFIG_HNS3) +=3D hnae3.o
 obj-$(CONFIG_HNS3_ENET) +=3D hns3.o
 hns3-objs =3D hns3_enet.o hns3_ethtool.o hns3_debugfs.o

+obj-$(CONFIG_HNS3_HCLGE_COMMON)=09+=3D hclge_common.o
+hclge_common-objs :=3D=09=09=09=09\
+=09hns3_common/hclge_comm_cmd.o=09=09\
+=09hns3_common/hclge_comm_rss.o=09=09\
+=09hns3_common/hclge_comm_tqp_stats.o
+
 hns3-$(CONFIG_HNS3_DCB) +=3D hns3_dcbnl.o

 obj-$(CONFIG_HNS3_HCLGEVF) +=3D hclgevf.o

-hclgevf-objs =3D hns3vf/hclgevf_main.o hns3vf/hclgevf_mbx.o  hns3vf/hclgev=
f_devlink.o \
-=09=09hns3_common/hclge_comm_cmd.o hns3_common/hclge_comm_rss.o hns3_commo=
n/hclge_comm_tqp_stats.o
+hclgevf-objs =3D hns3vf/hclgevf_main.o hns3vf/hclgevf_mbx.o  hns3vf/hclgev=
f_devlink.o

 obj-$(CONFIG_HNS3_HCLGE) +=3D hclge.o
 hclge-objs =3D hns3pf/hclge_main.o hns3pf/hclge_mdio.o hns3pf/hclge_tm.o \
-=09=09hns3pf/hclge_mbx.o hns3pf/hclge_err.o  hns3pf/hclge_debugfs.o hns3pf=
/hclge_ptp.o hns3pf/hclge_devlink.o \
-=09=09hns3_common/hclge_comm_cmd.o hns3_common/hclge_comm_rss.o hns3_commo=
n/hclge_comm_tqp_stats.o
-
+=09=09hns3pf/hclge_mbx.o hns3pf/hclge_err.o  hns3pf/hclge_debugfs.o hns3pf=
/hclge_ptp.o hns3pf/hclge_devlink.o

 hclge-$(CONFIG_HNS3_DCB) +=3D hns3pf/hclge_dcb.o
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd=
.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
index f671a63cecde..ff76ae425829 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
@@ -33,7 +33,7 @@ static void hclge_comm_cmd_config_regs(struct hclge_comm_=
hw *hw,
 =09}
 }

-void hclge_comm_cmd_init_regs(struct hclge_comm_hw *hw)
+static void hclge_comm_cmd_init_regs(struct hclge_comm_hw *hw)
 {
 =09hclge_comm_cmd_config_regs(hw, &hw->cmq.csq);
 =09hclge_comm_cmd_config_regs(hw, &hw->cmq.crq);
@@ -48,6 +48,7 @@ void hclge_comm_cmd_reuse_desc(struct hclge_desc *desc, b=
ool is_read)
 =09else
 =09=09desc->flag &=3D cpu_to_le16(~HCLGE_COMM_CMD_FLAG_WR);
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_cmd_reuse_desc, HNS3_HCLGE_COMMON);

 static void hclge_comm_set_default_capability(struct hnae3_ae_dev *ae_dev,
 =09=09=09=09=09      bool is_pf)
@@ -72,9 +73,10 @@ void hclge_comm_cmd_setup_basic_desc(struct hclge_desc *=
desc,
 =09if (is_read)
 =09=09desc->flag |=3D cpu_to_le16(HCLGE_COMM_CMD_FLAG_WR);
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_cmd_setup_basic_desc, HNS3_HCLGE_COMMON);

-int hclge_comm_firmware_compat_config(struct hnae3_ae_dev *ae_dev,
-=09=09=09=09      struct hclge_comm_hw *hw, bool en)
+static int hclge_comm_firmware_compat_config(struct hnae3_ae_dev *ae_dev,
+=09=09=09=09=09     struct hclge_comm_hw *hw, bool en)
 {
 =09struct hclge_comm_firmware_compat_cmd *req;
 =09struct hclge_desc desc;
@@ -99,7 +101,7 @@ int hclge_comm_firmware_compat_config(struct hnae3_ae_de=
v *ae_dev,
 =09return hclge_comm_cmd_send(hw, &desc, 1);
 }

-void hclge_comm_free_cmd_desc(struct hclge_comm_cmq_ring *ring)
+static void hclge_comm_free_cmd_desc(struct hclge_comm_cmq_ring *ring)
 {
 =09int size  =3D ring->desc_num * sizeof(struct hclge_desc);

@@ -186,7 +188,7 @@ hclge_comm_parse_capability(struct hnae3_ae_dev *ae_dev=
, bool is_pf,
 =09=09=09set_bit(caps_map[i].local_bit, ae_dev->caps);
 }

-int hclge_comm_alloc_cmd_queue(struct hclge_comm_hw *hw, int ring_type)
+static int hclge_comm_alloc_cmd_queue(struct hclge_comm_hw *hw, int ring_t=
ype)
 {
 =09struct hclge_comm_cmq_ring *ring =3D
 =09=09(ring_type =3D=3D HCLGE_COMM_TYPE_CSQ) ? &hw->cmq.csq :
@@ -204,9 +206,10 @@ int hclge_comm_alloc_cmd_queue(struct hclge_comm_hw *h=
w, int ring_type)
 =09return ret;
 }

-int hclge_comm_cmd_query_version_and_capability(struct hnae3_ae_dev *ae_de=
v,
-=09=09=09=09=09=09struct hclge_comm_hw *hw,
-=09=09=09=09=09=09u32 *fw_version, bool is_pf)
+static int
+hclge_comm_cmd_query_version_and_capability(struct hnae3_ae_dev *ae_dev,
+=09=09=09=09=09    struct hclge_comm_hw *hw,
+=09=09=09=09=09    u32 *fw_version, bool is_pf)
 {
 =09struct hclge_comm_query_version_cmd *resp;
 =09struct hclge_desc desc;
@@ -474,6 +477,7 @@ int hclge_comm_cmd_send(struct hclge_comm_hw *hw, struc=
t hclge_desc *desc,

 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_cmd_send, HNS3_HCLGE_COMMON);

 static void hclge_comm_cmd_uninit_regs(struct hclge_comm_hw *hw)
 {
@@ -510,6 +514,7 @@ void hclge_comm_cmd_uninit(struct hnae3_ae_dev *ae_dev,
 =09hclge_comm_free_cmd_desc(&cmdq->csq);
 =09hclge_comm_free_cmd_desc(&cmdq->crq);
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_cmd_uninit, HNS3_HCLGE_COMMON);

 int hclge_comm_cmd_queue_init(struct pci_dev *pdev, struct hclge_comm_hw *=
hw)
 {
@@ -548,6 +553,7 @@ int hclge_comm_cmd_queue_init(struct pci_dev *pdev, str=
uct hclge_comm_hw *hw)
 =09hclge_comm_free_cmd_desc(&hw->cmq.csq);
 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_cmd_queue_init, HNS3_HCLGE_COMMON);

 int hclge_comm_cmd_init(struct hnae3_ae_dev *ae_dev, struct hclge_comm_hw =
*hw,
 =09=09=09u32 *fw_version, bool is_pf,
@@ -618,3 +624,8 @@ int hclge_comm_cmd_init(struct hnae3_ae_dev *ae_dev, st=
ruct hclge_comm_hw *hw,

 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_cmd_init, HNS3_HCLGE_COMMON);
+
+MODULE_AUTHOR("Huawei Tech. Co., Ltd.");
+MODULE_DESCRIPTION("HCLGE Common module");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd=
.h b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
index b1f9383b418f..b16438d3885b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
@@ -441,17 +441,9 @@ static inline u32 hclge_comm_read_reg(u8 __iomem *base=
, u32 reg)
 #define hclge_comm_read_dev(a, reg) \
 =09hclge_comm_read_reg((a)->io_base, reg)

-void hclge_comm_cmd_init_regs(struct hclge_comm_hw *hw);
-int hclge_comm_cmd_query_version_and_capability(struct hnae3_ae_dev *ae_de=
v,
-=09=09=09=09=09=09struct hclge_comm_hw *hw,
-=09=09=09=09=09=09u32 *fw_version, bool is_pf);
-int hclge_comm_alloc_cmd_queue(struct hclge_comm_hw *hw, int ring_type);
 int hclge_comm_cmd_send(struct hclge_comm_hw *hw, struct hclge_desc *desc,
 =09=09=09int num);
 void hclge_comm_cmd_reuse_desc(struct hclge_desc *desc, bool is_read);
-int hclge_comm_firmware_compat_config(struct hnae3_ae_dev *ae_dev,
-=09=09=09=09      struct hclge_comm_hw *hw, bool en);
-void hclge_comm_free_cmd_desc(struct hclge_comm_cmq_ring *ring);
 void hclge_comm_cmd_setup_basic_desc(struct hclge_desc *desc,
 =09=09=09=09     enum hclge_opcode_type opcode,
 =09=09=09=09     bool is_read);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss=
.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c
index e23729ac3bb8..b266e69b3675 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c
@@ -62,6 +62,7 @@ int hclge_comm_rss_init_cfg(struct hnae3_handle *nic,

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_rss_init_cfg, HNS3_HCLGE_COMMON);

 void hclge_comm_get_rss_tc_info(u16 rss_size, u8 hw_tc_map, u16 *tc_offset=
,
 =09=09=09=09u16 *tc_valid, u16 *tc_size)
@@ -78,6 +79,7 @@ void hclge_comm_get_rss_tc_info(u16 rss_size, u8 hw_tc_ma=
p, u16 *tc_offset,
 =09=09tc_offset[i] =3D (hw_tc_map & BIT(i)) ? rss_size * i : 0;
 =09}
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_get_rss_tc_info, HNS3_HCLGE_COMMON);

 int hclge_comm_set_rss_tc_mode(struct hclge_comm_hw *hw, u16 *tc_offset,
 =09=09=09       u16 *tc_valid, u16 *tc_size)
@@ -113,6 +115,7 @@ int hclge_comm_set_rss_tc_mode(struct hclge_comm_hw *hw=
, u16 *tc_offset,

 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_set_rss_tc_mode, HNS3_HCLGE_COMMON);

 int hclge_comm_set_rss_hash_key(struct hclge_comm_rss_cfg *rss_cfg,
 =09=09=09=09struct hclge_comm_hw *hw, const u8 *key,
@@ -143,6 +146,7 @@ int hclge_comm_set_rss_hash_key(struct hclge_comm_rss_c=
fg *rss_cfg,

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_set_rss_hash_key, HNS3_HCLGE_COMMON);

 int hclge_comm_set_rss_tuple(struct hnae3_ae_dev *ae_dev,
 =09=09=09     struct hclge_comm_hw *hw,
@@ -185,11 +189,13 @@ int hclge_comm_set_rss_tuple(struct hnae3_ae_dev *ae_=
dev,
 =09rss_cfg->rss_tuple_sets.ipv6_fragment_en =3D req->ipv6_fragment_en;
 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_set_rss_tuple, HNS3_HCLGE_COMMON);

 u32 hclge_comm_get_rss_key_size(struct hnae3_handle *handle)
 {
 =09return HCLGE_COMM_RSS_KEY_SIZE;
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_get_rss_key_size, HNS3_HCLGE_COMMON);

 void hclge_comm_get_rss_type(struct hnae3_handle *nic,
 =09=09=09     struct hclge_comm_rss_tuple_cfg *rss_tuple_sets)
@@ -207,6 +213,7 @@ void hclge_comm_get_rss_type(struct hnae3_handle *nic,
 =09else
 =09=09nic->kinfo.rss_type =3D PKT_HASH_TYPE_NONE;
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_get_rss_type, HNS3_HCLGE_COMMON);

 int hclge_comm_parse_rss_hfunc(struct hclge_comm_rss_cfg *rss_cfg,
 =09=09=09       const u8 hfunc, u8 *hash_algo)
@@ -225,6 +232,7 @@ int hclge_comm_parse_rss_hfunc(struct hclge_comm_rss_cf=
g *rss_cfg,
 =09=09return -EINVAL;
 =09}
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_parse_rss_hfunc, HNS3_HCLGE_COMMON);

 void hclge_comm_rss_indir_init_cfg(struct hnae3_ae_dev *ae_dev,
 =09=09=09=09   struct hclge_comm_rss_cfg *rss_cfg)
@@ -234,6 +242,7 @@ void hclge_comm_rss_indir_init_cfg(struct hnae3_ae_dev =
*ae_dev,
 =09for (i =3D 0; i < ae_dev->dev_specs.rss_ind_tbl_size; i++)
 =09=09rss_cfg->rss_indirection_tbl[i] =3D i % rss_cfg->rss_size;
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_rss_indir_init_cfg, HNS3_HCLGE_COMMON);

 int hclge_comm_get_rss_tuple(struct hclge_comm_rss_cfg *rss_cfg, int flow_=
type,
 =09=09=09     u8 *tuple_sets)
@@ -267,6 +276,7 @@ int hclge_comm_get_rss_tuple(struct hclge_comm_rss_cfg =
*rss_cfg, int flow_type,

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_get_rss_tuple, HNS3_HCLGE_COMMON);

 static void
 hclge_comm_append_rss_msb_info(struct hclge_comm_rss_ind_tbl_cmd *req,
@@ -321,6 +331,7 @@ int hclge_comm_set_rss_indir_table(struct hnae3_ae_dev =
*ae_dev,
 =09}
 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_set_rss_indir_table, HNS3_HCLGE_COMMON);

 int hclge_comm_set_rss_input_tuple(struct hnae3_handle *nic,
 =09=09=09=09   struct hclge_comm_hw *hw, bool is_pf,
@@ -353,6 +364,7 @@ int hclge_comm_set_rss_input_tuple(struct hnae3_handle =
*nic,
 =09=09=09"failed to configure rss input, ret =3D %d.\n", ret);
 =09return ret;
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_set_rss_input_tuple, HNS3_HCLGE_COMMON);

 void hclge_comm_get_rss_hash_info(struct hclge_comm_rss_cfg *rss_cfg, u8 *=
key,
 =09=09=09=09  u8 *hfunc)
@@ -376,6 +388,7 @@ void hclge_comm_get_rss_hash_info(struct hclge_comm_rss=
_cfg *rss_cfg, u8 *key,
 =09if (key)
 =09=09memcpy(key, rss_cfg->rss_hash_key, HCLGE_COMM_RSS_KEY_SIZE);
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_get_rss_hash_info, HNS3_HCLGE_COMMON);

 void hclge_comm_get_rss_indir_tbl(struct hclge_comm_rss_cfg *rss_cfg,
 =09=09=09=09  u32 *indir, u16 rss_ind_tbl_size)
@@ -388,6 +401,7 @@ void hclge_comm_get_rss_indir_tbl(struct hclge_comm_rss=
_cfg *rss_cfg,
 =09for (i =3D 0; i < rss_ind_tbl_size; i++)
 =09=09indir[i] =3D rss_cfg->rss_indirection_tbl[i];
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_get_rss_indir_tbl, HNS3_HCLGE_COMMON);

 int hclge_comm_set_rss_algo_key(struct hclge_comm_hw *hw, const u8 hfunc,
 =09=09=09=09const u8 *key)
@@ -429,6 +443,7 @@ int hclge_comm_set_rss_algo_key(struct hclge_comm_hw *h=
w, const u8 hfunc,

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_set_rss_algo_key, HNS3_HCLGE_COMMON);

 static u8 hclge_comm_get_rss_hash_bits(struct ethtool_rxnfc *nfc)
 {
@@ -507,6 +522,7 @@ int hclge_comm_init_rss_tuple_cmd(struct hclge_comm_rss=
_cfg *rss_cfg,

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_init_rss_tuple_cmd, HNS3_HCLGE_COMMON);

 u64 hclge_comm_convert_rss_tuple(u8 tuple_sets)
 {
@@ -523,3 +539,4 @@ u64 hclge_comm_convert_rss_tuple(u8 tuple_sets)

 =09return tuple_data;
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_convert_rss_tuple, HNS3_HCLGE_COMMON);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp=
_stats.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_s=
tats.c
index f3c9395d8351..6f1ba82f83e7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.=
c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.=
c
@@ -26,6 +26,7 @@ u64 *hclge_comm_tqps_get_stats(struct hnae3_handle *handl=
e, u64 *data)

 =09return buff;
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_tqps_get_stats, HNS3_HCLGE_COMMON);

 int hclge_comm_tqps_get_sset_count(struct hnae3_handle *handle)
 {
@@ -33,6 +34,7 @@ int hclge_comm_tqps_get_sset_count(struct hnae3_handle *h=
andle)

 =09return kinfo->num_tqps * HCLGE_COMM_QUEUE_PAIR_SIZE;
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_tqps_get_sset_count, HNS3_HCLGE_COMMON);

 u8 *hclge_comm_tqps_get_strings(struct hnae3_handle *handle, u8 *data)
 {
@@ -56,6 +58,7 @@ u8 *hclge_comm_tqps_get_strings(struct hnae3_handle *hand=
le, u8 *data)

 =09return buff;
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_tqps_get_strings, HNS3_HCLGE_COMMON);

 int hclge_comm_tqps_update_stats(struct hnae3_handle *handle,
 =09=09=09=09 struct hclge_comm_hw *hw)
@@ -99,6 +102,7 @@ int hclge_comm_tqps_update_stats(struct hnae3_handle *ha=
ndle,

 =09return 0;
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_tqps_update_stats, HNS3_HCLGE_COMMON);

 void hclge_comm_reset_tqp_stats(struct hnae3_handle *handle)
 {
@@ -113,3 +117,4 @@ void hclge_comm_reset_tqp_stats(struct hnae3_handle *ha=
ndle)
 =09=09memset(&tqp->tqp_stats, 0, sizeof(tqp->tqp_stats));
 =09}
 }
+EXPORT_SYMBOL_NS_GPL(hclge_comm_reset_tqp_stats, HNS3_HCLGE_COMMON);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/driv=
ers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 987271da6e9b..39a7ab51be31 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -13133,6 +13133,8 @@ static void __exit hclge_exit(void)
 module_init(hclge_init);
 module_exit(hclge_exit);

+MODULE_IMPORT_NS(HNS3_HCLGE_COMMON);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Huawei Tech. Co., Ltd.");
 MODULE_DESCRIPTION("HCLGE Driver");
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/dr=
ivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index db6f7cdba958..5d0a8801a375 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -3452,6 +3452,8 @@ static void __exit hclgevf_exit(void)
 module_init(hclgevf_init);
 module_exit(hclgevf_exit);

+MODULE_IMPORT_NS(HNS3_HCLGE_COMMON);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Huawei Tech. Co., Ltd.");
 MODULE_DESCRIPTION("HCLGEVF Driver");
--
2.38.1


