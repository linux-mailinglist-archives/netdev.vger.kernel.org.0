Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42A55ED3AF
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 05:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232905AbiI1D6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 23:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiI1D6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 23:58:42 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5218C115BC6
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:58:40 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28RKaZIb017863;
        Tue, 27 Sep 2022 20:58:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=n3tI7eg6A/mbeinWu+4ivnV4Xpk+jcqYptz4jpwYv2c=;
 b=ZX3s4YhetAXqwW2wEc9lkivngHh7eupzSYXqROdvB28zV9rRD1ZhZVbUtXDXh51Eyd+H
 MaUuXoYhXbjmKTelRpvwjSDjZU1NvVFNxEOzQo0sAJ4sx6fJ4D/ash3baWony26949uw
 IHqk18vbXhNNv0lQN1Q75g8jISPYbm/XFENIrRRKQosjnIr5ZzsoqdJpcIWzHXmo6X7v
 tP5z8gUN1kk2KqljFmHPXgxgpAMkfnoItSfTllzlgrbGEUo2vd3Wrss5PMxzelLn+arH
 nAKIz/9BfDL3twZqq9xtj+9n7hqf/Yr2bMbCLbJLDoTgdJwx5G9hTfB1j4HKfsOZq+Ub Mg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3jt1dpcy7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 27 Sep 2022 20:58:27 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 27 Sep
 2022 20:58:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 27 Sep 2022 20:58:25 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 8BB8F3F70E9;
        Tue, 27 Sep 2022 20:58:22 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <naveenm@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Vamsi Attunuru <vattunuru@marvell.com>,
        "Subbaraya Sundeep" <sbhatta@marvell.com>
Subject: [net-next PATCH v2 1/8] octeontx2-af: cn10k: Introduce driver for macsec block.
Date:   Wed, 28 Sep 2022 09:28:03 +0530
Message-ID: <1664337490-20231-2-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1664337490-20231-1-git-send-email-sbhatta@marvell.com>
References: <1664337490-20231-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: X1gHmvluCl1FdBkEIzcNfsIDQv_oPrVM
X-Proofpoint-GUID: X1gHmvluCl1FdBkEIzcNfsIDQv_oPrVM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-27_12,2022-09-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

CN10K-B and CNF10K-B has macsec block(MCS) to encrypt and
decrypt packets at MAC level. This block is a global resource
with hardware resources like SecYs, SCs and SAs and is in
between NIX block and RPM LMAC. CN10K-B silicon has only one MCS
block which receives packets from all LMACS whereas CNF10K-B has
seven MCS blocks for seven LMACs. Both MCS blocks are
similar in operation except for few register offsets and some
configurations require writing to different registers. Those
differences between IPs are handled using separate ops.
This patch adds basic driver and does the initial hardware
calibration and parser configuration.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Vamsi Attunuru <vattunuru@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/Makefile |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c    | 368 +++++++++++++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/mcs.h    |  92 ++++++
 .../ethernet/marvell/octeontx2/af/mcs_cnf10kb.c    |  65 ++++
 .../net/ethernet/marvell/octeontx2/af/mcs_reg.h    |  78 +++++
 .../net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c |  52 +++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  14 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   8 +
 8 files changed, 678 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/mcs.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/mcs.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/mcs_cnf10kb.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/Makefile b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
index 4020356..3cf4c82 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
@@ -11,4 +11,4 @@ rvu_mbox-y := mbox.o rvu_trace.o
 rvu_af-y := cgx.o rvu.o rvu_cgx.o rvu_npa.o rvu_nix.o \
 		  rvu_reg.o rvu_npc.o rvu_debugfs.o ptp.o rvu_npc_fs.o \
 		  rvu_cpt.o rvu_devlink.o rpm.o rvu_cn10k.o rvu_switch.o \
-		  rvu_sdp.o rvu_npc_hash.o
+		  rvu_sdp.o rvu_npc_hash.o mcs.o mcs_rvu_if.o mcs_cnf10kb.o
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
new file mode 100644
index 0000000..a4e919c
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
@@ -0,0 +1,368 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell MCS driver
+ *
+ * Copyright (C) 2022 Marvell.
+ */
+
+#include <linux/bitfield.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+
+#include "mcs.h"
+#include "mcs_reg.h"
+
+#define DRV_NAME	"Marvell MCS Driver"
+
+#define PCI_CFG_REG_BAR_NUM	0
+
+static const struct pci_device_id mcs_id_table[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, PCI_DEVID_CN10K_MCS) },
+	{ 0, }  /* end of table */
+};
+
+static LIST_HEAD(mcs_list);
+
+static void *alloc_mem(struct mcs *mcs, int n)
+{
+	return devm_kcalloc(mcs->dev, n, sizeof(u16), GFP_KERNEL);
+}
+
+static int mcs_alloc_struct_mem(struct mcs *mcs, struct mcs_rsrc_map *res)
+{
+	struct hwinfo *hw = mcs->hw;
+	int err;
+
+	res->flowid2pf_map = alloc_mem(mcs, hw->tcam_entries);
+	if (!res->flowid2pf_map)
+		return -ENOMEM;
+
+	res->secy2pf_map = alloc_mem(mcs, hw->secy_entries);
+	if (!res->secy2pf_map)
+		return -ENOMEM;
+
+	res->sc2pf_map = alloc_mem(mcs, hw->sc_entries);
+	if (!res->sc2pf_map)
+		return -ENOMEM;
+
+	res->sa2pf_map = alloc_mem(mcs, hw->sa_entries);
+	if (!res->sa2pf_map)
+		return -ENOMEM;
+
+	res->flowid2secy_map = alloc_mem(mcs, hw->tcam_entries);
+	if (!res->flowid2secy_map)
+		return -ENOMEM;
+
+	res->flow_ids.max = hw->tcam_entries - MCS_RSRC_RSVD_CNT;
+	err = rvu_alloc_bitmap(&res->flow_ids);
+	if (err)
+		return err;
+
+	res->secy.max = hw->secy_entries - MCS_RSRC_RSVD_CNT;
+	err = rvu_alloc_bitmap(&res->secy);
+	if (err)
+		return err;
+
+	res->sc.max = hw->sc_entries;
+	err = rvu_alloc_bitmap(&res->sc);
+	if (err)
+		return err;
+
+	res->sa.max = hw->sa_entries;
+	err = rvu_alloc_bitmap(&res->sa);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+int mcs_get_blkcnt(void)
+{
+	struct mcs *mcs;
+	int idmax = -ENODEV;
+
+	/* Check MCS block is present in hardware */
+	if (!pci_dev_present(mcs_id_table))
+		return 0;
+
+	list_for_each_entry(mcs, &mcs_list, mcs_list)
+		if (mcs->mcs_id > idmax)
+			idmax = mcs->mcs_id;
+
+	if (idmax < 0)
+		return 0;
+
+	return idmax + 1;
+}
+
+struct mcs *mcs_get_pdata(int mcs_id)
+{
+	struct mcs *mcs_dev;
+
+	list_for_each_entry(mcs_dev, &mcs_list, mcs_list) {
+		if (mcs_dev->mcs_id == mcs_id)
+			return mcs_dev;
+	}
+	return NULL;
+}
+
+/* Set lmac to bypass/operational mode */
+void mcs_set_lmac_mode(struct mcs *mcs, int lmac_id, u8 mode)
+{
+	u64 reg;
+
+	reg = MCSX_MCS_TOP_SLAVE_CHANNEL_CFG(lmac_id * 2);
+	mcs_reg_write(mcs, reg, (u64)mode);
+}
+
+void cn10kb_mcs_parser_cfg(struct mcs *mcs)
+{
+	u64 reg, val;
+
+	/* VLAN CTag */
+	val = BIT_ULL(0) | (0x8100ull & 0xFFFF) << 1 | BIT_ULL(17);
+	/* RX */
+	reg = MCSX_PEX_RX_SLAVE_VLAN_CFGX(0);
+	mcs_reg_write(mcs, reg, val);
+
+	/* TX */
+	reg = MCSX_PEX_TX_SLAVE_VLAN_CFGX(0);
+	mcs_reg_write(mcs, reg, val);
+
+	/* VLAN STag */
+	val = BIT_ULL(0) | (0x88a8ull & 0xFFFF) << 1 | BIT_ULL(18);
+	/* RX */
+	reg = MCSX_PEX_RX_SLAVE_VLAN_CFGX(1);
+	mcs_reg_write(mcs, reg, val);
+
+	/* TX */
+	reg = MCSX_PEX_TX_SLAVE_VLAN_CFGX(1);
+	mcs_reg_write(mcs, reg, val);
+}
+
+static void mcs_lmac_init(struct mcs *mcs, int lmac_id)
+{
+	u64 reg;
+
+	/* Port mode 25GB */
+	reg = MCSX_PAB_RX_SLAVE_PORT_CFGX(lmac_id);
+	mcs_reg_write(mcs, reg, 0);
+
+	if (mcs->hw->mcs_blks > 1) {
+		reg = MCSX_PAB_RX_SLAVE_FIFO_SKID_CFGX(lmac_id);
+		mcs_reg_write(mcs, reg, 0xe000e);
+		return;
+	}
+
+	reg = MCSX_PAB_TX_SLAVE_PORT_CFGX(lmac_id);
+	mcs_reg_write(mcs, reg, 0);
+}
+
+int mcs_set_lmac_channels(int mcs_id, u16 base)
+{
+	struct mcs *mcs;
+	int lmac;
+	u64 cfg;
+
+	mcs = mcs_get_pdata(mcs_id);
+	if (!mcs)
+		return -ENODEV;
+	for (lmac = 0; lmac < mcs->hw->lmac_cnt; lmac++) {
+		cfg = mcs_reg_read(mcs, MCSX_LINK_LMACX_CFG(lmac));
+		cfg &= ~(MCSX_LINK_LMAC_BASE_MASK | MCSX_LINK_LMAC_RANGE_MASK);
+		cfg |=	FIELD_PREP(MCSX_LINK_LMAC_RANGE_MASK, ilog2(16));
+		cfg |=	FIELD_PREP(MCSX_LINK_LMAC_BASE_MASK, base);
+		mcs_reg_write(mcs, MCSX_LINK_LMACX_CFG(lmac), cfg);
+		base += 16;
+	}
+	return 0;
+}
+
+static int mcs_x2p_calibration(struct mcs *mcs)
+{
+	unsigned long timeout = jiffies + usecs_to_jiffies(20000);
+	int i, err = 0;
+	u64 val;
+
+	/* set X2P calibration */
+	val = mcs_reg_read(mcs, MCSX_MIL_GLOBAL);
+	val |= BIT_ULL(5);
+	mcs_reg_write(mcs, MCSX_MIL_GLOBAL, val);
+
+	/* Wait for calibration to complete */
+	while (!(mcs_reg_read(mcs, MCSX_MIL_RX_GBL_STATUS) & BIT_ULL(0))) {
+		if (time_before(jiffies, timeout)) {
+			usleep_range(80, 100);
+			continue;
+		} else {
+			err = -EBUSY;
+			dev_err(mcs->dev, "MCS X2P calibration failed..ignoring\n");
+			return err;
+		}
+	}
+
+	val = mcs_reg_read(mcs, MCSX_MIL_RX_GBL_STATUS);
+	for (i = 0; i < mcs->hw->mcs_x2p_intf; i++) {
+		if (val & BIT_ULL(1 + i))
+			continue;
+		err = -EBUSY;
+		dev_err(mcs->dev, "MCS:%d didn't respond to X2P calibration\n", i);
+	}
+	/* Clear X2P calibrate */
+	mcs_reg_write(mcs, MCSX_MIL_GLOBAL, mcs_reg_read(mcs, MCSX_MIL_GLOBAL) & ~BIT_ULL(5));
+
+	return err;
+}
+
+static void mcs_set_external_bypass(struct mcs *mcs, u8 bypass)
+{
+	u64 val;
+
+	/* Set MCS to external bypass */
+	val = mcs_reg_read(mcs, MCSX_MIL_GLOBAL);
+	if (bypass)
+		val |= BIT_ULL(6);
+	else
+		val &= ~BIT_ULL(6);
+	mcs_reg_write(mcs, MCSX_MIL_GLOBAL, val);
+}
+
+static void mcs_global_cfg(struct mcs *mcs)
+{
+	/* Disable external bypass */
+	mcs_set_external_bypass(mcs, false);
+
+	/* Set MCS to perform standard IEEE802.1AE macsec processing */
+	if (mcs->hw->mcs_blks == 1) {
+		mcs_reg_write(mcs, MCSX_IP_MODE, BIT_ULL(3));
+		return;
+	}
+
+	mcs_reg_write(mcs, MCSX_BBE_RX_SLAVE_CAL_ENTRY, 0xe4);
+	mcs_reg_write(mcs, MCSX_BBE_RX_SLAVE_CAL_LEN, 4);
+}
+
+void cn10kb_mcs_set_hw_capabilities(struct mcs *mcs)
+{
+	struct hwinfo *hw = mcs->hw;
+
+	hw->tcam_entries = 128;		/* TCAM entries */
+	hw->secy_entries  = 128;	/* SecY entries */
+	hw->sc_entries = 128;		/* SC CAM entries */
+	hw->sa_entries = 256;		/* SA entries */
+	hw->lmac_cnt = 20;		/* lmacs/ports per mcs block */
+	hw->mcs_x2p_intf = 5;		/* x2p clabration intf */
+	hw->mcs_blks = 1;		/* MCS blocks */
+}
+
+struct mcs_ops cn10kb_mcs_ops = {
+	.mcs_set_hw_capabilities	= cn10kb_mcs_set_hw_capabilities,
+	.mcs_parser_cfg			= cn10kb_mcs_parser_cfg,
+};
+
+static int mcs_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct device *dev = &pdev->dev;
+	int lmac, err = 0;
+	struct mcs *mcs;
+
+	mcs = devm_kzalloc(dev, sizeof(*mcs), GFP_KERNEL);
+	if (!mcs)
+		return -ENOMEM;
+
+	mcs->hw = devm_kzalloc(dev, sizeof(struct hwinfo), GFP_KERNEL);
+	if (!mcs->hw)
+		return -ENOMEM;
+
+	err = pci_enable_device(pdev);
+	if (err) {
+		dev_err(dev, "Failed to enable PCI device\n");
+		pci_set_drvdata(pdev, NULL);
+		return err;
+	}
+
+	err = pci_request_regions(pdev, DRV_NAME);
+	if (err) {
+		dev_err(dev, "PCI request regions failed 0x%x\n", err);
+		goto exit;
+	}
+
+	mcs->reg_base = pcim_iomap(pdev, PCI_CFG_REG_BAR_NUM, 0);
+	if (!mcs->reg_base) {
+		dev_err(dev, "mcs: Cannot map CSR memory space, aborting\n");
+		err = -ENOMEM;
+		goto exit;
+	}
+
+	pci_set_drvdata(pdev, mcs);
+	mcs->pdev = pdev;
+	mcs->dev = &pdev->dev;
+
+	if (pdev->subsystem_device == PCI_SUBSYS_DEVID_CN10K_B)
+		mcs->mcs_ops = &cn10kb_mcs_ops;
+	else
+		mcs->mcs_ops = cnf10kb_get_mac_ops();
+
+	/* Set hardware capabilities */
+	mcs->mcs_ops->mcs_set_hw_capabilities(mcs);
+
+	mcs_global_cfg(mcs);
+
+	/* Perform X2P clibration */
+	err = mcs_x2p_calibration(mcs);
+	if (err)
+		goto err_x2p;
+
+	mcs->mcs_id = (pci_resource_start(pdev, PCI_CFG_REG_BAR_NUM) >> 24)
+			& MCS_ID_MASK;
+
+	/* Set mcs tx side resources */
+	err = mcs_alloc_struct_mem(mcs, &mcs->tx);
+	if (err)
+		goto err_x2p;
+
+	/* Set mcs rx side resources */
+	err = mcs_alloc_struct_mem(mcs, &mcs->rx);
+	if (err)
+		goto err_x2p;
+
+	/* per port config */
+	for (lmac = 0; lmac < mcs->hw->lmac_cnt; lmac++)
+		mcs_lmac_init(mcs, lmac);
+
+	/* Parser configuration */
+	mcs->mcs_ops->mcs_parser_cfg(mcs);
+
+	list_add(&mcs->mcs_list, &mcs_list);
+
+	return 0;
+
+err_x2p:
+	/* Enable external bypass */
+	mcs_set_external_bypass(mcs, true);
+exit:
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
+	return err;
+}
+
+static void mcs_remove(struct pci_dev *pdev)
+{
+	struct mcs *mcs = pci_get_drvdata(pdev);
+
+	/* Set MCS to external bypass */
+	mcs_set_external_bypass(mcs, true);
+	pci_free_irq_vectors(pdev);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
+}
+
+struct pci_driver mcs_driver = {
+	.name = DRV_NAME,
+	.id_table = mcs_id_table,
+	.probe = mcs_probe,
+	.remove = mcs_remove,
+};
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.h b/drivers/net/ethernet/marvell/octeontx2/af/mcs.h
new file mode 100644
index 0000000..002fee8
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.h
@@ -0,0 +1,92 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Marvell CN10K MCS driver
+ *
+ * Copyright (C) 2022 Marvell.
+ */
+
+#ifndef MCS_H
+#define MCS_H
+
+#include <linux/bits.h>
+#include "rvu.h"
+
+#define PCI_DEVID_CN10K_MCS		0xA096
+
+#define MCSX_LINK_LMAC_RANGE_MASK	GENMASK_ULL(19, 16)
+#define MCSX_LINK_LMAC_BASE_MASK	GENMASK_ULL(11, 0)
+
+#define MCS_ID_MASK			0x7
+
+/* Reserved resources for default bypass entry */
+#define MCS_RSRC_RSVD_CNT		1
+
+struct mcs_rsrc_map {
+	u16 *flowid2pf_map;
+	u16 *secy2pf_map;
+	u16 *sc2pf_map;
+	u16 *sa2pf_map;
+	u16 *flowid2secy_map;	/* bitmap flowid mapped to secy*/
+	struct rsrc_bmap	flow_ids;
+	struct rsrc_bmap	secy;
+	struct rsrc_bmap	sc;
+	struct rsrc_bmap	sa;
+};
+
+struct hwinfo {
+	u8 tcam_entries;
+	u8 secy_entries;
+	u8 sc_entries;
+	u16 sa_entries;
+	u8 mcs_x2p_intf;
+	u8 lmac_cnt;
+	u8 mcs_blks;
+	unsigned long	lmac_bmap; /* bitmap of enabled mcs lmac */
+};
+
+struct mcs {
+	void __iomem		*reg_base;
+	struct pci_dev		*pdev;
+	struct device		*dev;
+	struct hwinfo		*hw;
+	struct mcs_rsrc_map	tx;
+	struct mcs_rsrc_map	rx;
+	u8			mcs_id;
+	struct mcs_ops		*mcs_ops;
+	struct list_head	mcs_list;
+};
+
+struct mcs_ops {
+	void	(*mcs_set_hw_capabilities)(struct mcs *mcs);
+	void	(*mcs_parser_cfg)(struct mcs *mcs);
+};
+
+extern struct pci_driver mcs_driver;
+
+static inline void mcs_reg_write(struct mcs *mcs, u64 offset, u64 val)
+{
+	writeq(val, mcs->reg_base + offset);
+}
+
+static inline u64 mcs_reg_read(struct mcs *mcs, u64 offset)
+{
+	return readq(mcs->reg_base + offset);
+}
+
+/* MCS APIs */
+struct mcs *mcs_get_pdata(int mcs_id);
+int mcs_get_blkcnt(void);
+int mcs_set_lmac_channels(int mcs_id, u16 base);
+
+int mcs_install_flowid_bypass_entry(struct mcs *mcs);
+void mcs_set_lmac_mode(struct mcs *mcs, int lmac_id, u8 mode);
+
+/* CN10K-B APIs */
+void cn10kb_mcs_set_hw_capabilities(struct mcs *mcs);
+void cn10kb_mcs_parser_cfg(struct mcs *mcs);
+
+/* CNF10K-B APIs */
+struct mcs_ops *cnf10kb_get_mac_ops(void);
+void cnf10kb_mcs_set_hw_capabilities(struct mcs *mcs);
+void cnf10kb_mcs_parser_cfg(struct mcs *mcs);
+
+#endif /* MCS_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_cnf10kb.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs_cnf10kb.c
new file mode 100644
index 0000000..68bcee0
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_cnf10kb.c
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell MCS driver
+ *
+ * Copyright (C) 2022 Marvell.
+ */
+
+#include "mcs.h"
+#include "mcs_reg.h"
+
+static struct mcs_ops		cnf10kb_mcs_ops   = {
+	.mcs_set_hw_capabilities	= cnf10kb_mcs_set_hw_capabilities,
+	.mcs_parser_cfg			= cnf10kb_mcs_parser_cfg,
+};
+
+struct mcs_ops *cnf10kb_get_mac_ops(void)
+{
+	return &cnf10kb_mcs_ops;
+}
+
+void cnf10kb_mcs_set_hw_capabilities(struct mcs *mcs)
+{
+	struct hwinfo *hw = mcs->hw;
+
+	hw->tcam_entries = 64;		/* TCAM entries */
+	hw->secy_entries  = 64;		/* SecY entries */
+	hw->sc_entries = 64;		/* SC CAM entries */
+	hw->sa_entries = 128;		/* SA entries */
+	hw->lmac_cnt = 4;		/* lmacs/ports per mcs block */
+	hw->mcs_x2p_intf = 1;		/* x2p clabration intf */
+	hw->mcs_blks = 7;		/* MCS blocks */
+}
+
+void cnf10kb_mcs_parser_cfg(struct mcs *mcs)
+{
+	u64 reg, val;
+
+	/* VLAN Ctag */
+	val = (0x8100ull & 0xFFFF) | BIT_ULL(20) | BIT_ULL(22);
+
+	reg = MCSX_PEX_RX_SLAVE_CUSTOM_TAGX(0);
+	mcs_reg_write(mcs, reg, val);
+
+	reg = MCSX_PEX_TX_SLAVE_CUSTOM_TAGX(0);
+	mcs_reg_write(mcs, reg, val);
+
+	/* VLAN STag */
+	val = (0x88a8ull & 0xFFFF) | BIT_ULL(20) | BIT_ULL(23);
+
+	/* RX */
+	reg = MCSX_PEX_RX_SLAVE_CUSTOM_TAGX(1);
+	mcs_reg_write(mcs, reg, val);
+
+	/* TX */
+	reg = MCSX_PEX_TX_SLAVE_CUSTOM_TAGX(1);
+	mcs_reg_write(mcs, reg, val);
+
+	/* Enable custom tage 0 and 1 and sectag */
+	val = BIT_ULL(0) | BIT_ULL(1) | BIT_ULL(12);
+
+	reg = MCSX_PEX_RX_SLAVE_ETYPE_ENABLE;
+	mcs_reg_write(mcs, reg, val);
+
+	reg = MCSX_PEX_TX_SLAVE_ETYPE_ENABLE;
+	mcs_reg_write(mcs, reg, val);
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
new file mode 100644
index 0000000..61bf8ab
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
@@ -0,0 +1,78 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Marvell MCS driver
+ *
+ * Copyright (C) 2022 Marvell.
+ */
+
+#ifndef MCS_REG_H
+#define MCS_REG_H
+
+#include <linux/bits.h>
+
+/* Registers */
+#define MCSX_IP_MODE					0x900c8ull
+
+#define MCSX_MCS_TOP_SLAVE_CHANNEL_CFG(a) ({		\
+	u64 offset;					\
+							\
+	offset = 0x808ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xa68ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_MIL_GLOBAL	({				\
+	u64 offset;					\
+							\
+	offset = 0x80000ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x60000ull;			\
+	offset; })
+
+#define MCSX_LINK_LMACX_CFG(a) ({			\
+	u64 offset;					\
+							\
+	offset = 0x90000ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x70000ull;			\
+	offset += (a) * 0x800ull;			\
+	offset; })
+
+#define MCSX_MIL_RX_GBL_STATUS ({			\
+	u64 offset;					\
+							\
+	offset = 0x800c8ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x600c8ull;			\
+	offset; })
+
+/* PAB */
+#define MCSX_PAB_RX_SLAVE_PORT_CFGX(a) ({	\
+	u64 offset;				\
+						\
+	offset = 0x1718ull;			\
+	if (mcs->hw->mcs_blks > 1)		\
+		offset = 0x280ull;		\
+	offset += (a) * 0x40ull;		\
+	offset; })
+
+#define MCSX_PAB_TX_SLAVE_PORT_CFGX(a)			(0x2930ull + (a) * 0x40ull)
+
+/* PEX registers */
+#define MCSX_PEX_RX_SLAVE_VLAN_CFGX(a)          (0x3b58ull + (a) * 0x8ull)
+#define MCSX_PEX_TX_SLAVE_VLAN_CFGX(a)          (0x46f8ull + (a) * 0x8ull)
+
+/* CNF10K-B */
+#define MCSX_PEX_RX_SLAVE_CUSTOM_TAGX(a)        (0x4c8ull + (a) * 0x8ull)
+#define MCSX_PEX_TX_SLAVE_CUSTOM_TAGX(a)        (0x748ull + (a) * 0x8ull)
+#define MCSX_PEX_RX_SLAVE_ETYPE_ENABLE          0x6e8ull
+#define MCSX_PEX_TX_SLAVE_ETYPE_ENABLE          0x968ull
+
+/* BEE */
+#define MCSX_BBE_RX_SLAVE_PADDING_CTL			0xe08ull
+#define MCSX_BBE_TX_SLAVE_PADDING_CTL			0x12f8ull
+#define MCSX_BBE_RX_SLAVE_CAL_ENTRY			0x180ull
+#define MCSX_BBE_RX_SLAVE_CAL_LEN			0x188ull
+#define MCSX_PAB_RX_SLAVE_FIFO_SKID_CFGX(a)		(0x290ull + (a) * 0x40ull)
+
+#endif
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
new file mode 100644
index 0000000..c3f5b39
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell CN10K MCS driver
+ *
+ * Copyright (C) 2022 Marvell.
+ */
+
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+
+#include "mcs.h"
+#include "rvu.h"
+#include "lmac_common.h"
+
+static void rvu_mcs_set_lmac_bmap(struct rvu *rvu)
+{
+	struct mcs *mcs = mcs_get_pdata(0);
+	unsigned long lmac_bmap;
+	int cgx, lmac, port;
+
+	for (port = 0; port < mcs->hw->lmac_cnt; port++) {
+		cgx = port / rvu->hw->lmac_per_cgx;
+		lmac = port % rvu->hw->lmac_per_cgx;
+		if (!is_lmac_valid(rvu_cgx_pdata(cgx, rvu), lmac))
+			continue;
+		set_bit(port, &lmac_bmap);
+	}
+	mcs->hw->lmac_bmap = lmac_bmap;
+}
+
+int rvu_mcs_init(struct rvu *rvu)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	int err = 0;
+
+	rvu->mcs_blk_cnt = mcs_get_blkcnt();
+
+	if (!rvu->mcs_blk_cnt)
+		return 0;
+
+	/* Needed only for CN10K-B */
+	if (rvu->mcs_blk_cnt == 1) {
+		err = mcs_set_lmac_channels(0, hw->cgx_chan_base);
+		if (err)
+			return err;
+		/* Set active lmacs */
+		rvu_mcs_set_lmac_bmap(rvu);
+	}
+
+	return err;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 7282a82..5d74641 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -16,6 +16,7 @@
 #include "rvu.h"
 #include "rvu_reg.h"
 #include "ptp.h"
+#include "mcs.h"
 
 #include "rvu_trace.h"
 #include "rvu_npc_hash.h"
@@ -1159,6 +1160,12 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 
 	rvu_program_channels(rvu);
 
+	err = rvu_mcs_init(rvu);
+	if (err) {
+		dev_err(rvu->dev, "%s: Failed to initialize mcs\n", __func__);
+		goto nix_err;
+	}
+
 	return 0;
 
 nix_err:
@@ -3354,12 +3361,18 @@ static int __init rvu_init_module(void)
 	if (err < 0)
 		goto ptp_err;
 
+	err = pci_register_driver(&mcs_driver);
+	if (err < 0)
+		goto mcs_err;
+
 	err =  pci_register_driver(&rvu_driver);
 	if (err < 0)
 		goto rvu_err;
 
 	return 0;
 rvu_err:
+	pci_unregister_driver(&mcs_driver);
+mcs_err:
 	pci_unregister_driver(&ptp_driver);
 ptp_err:
 	pci_unregister_driver(&cgx_driver);
@@ -3370,6 +3383,7 @@ static int __init rvu_init_module(void)
 static void __exit rvu_cleanup_module(void)
 {
 	pci_unregister_driver(&rvu_driver);
+	pci_unregister_driver(&mcs_driver);
 	pci_unregister_driver(&ptp_driver);
 	pci_unregister_driver(&cgx_driver);
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index d15bc44..9a150da 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -25,6 +25,8 @@
 /* Subsystem Device ID */
 #define PCI_SUBSYS_DEVID_96XX                  0xB200
 #define PCI_SUBSYS_DEVID_CN10K_A	       0xB900
+#define PCI_SUBSYS_DEVID_CNF10K_B              0xBC00
+#define PCI_SUBSYS_DEVID_CN10K_B               0xBD00
 
 /* PCI BAR nos */
 #define	PCI_AF_REG_BAR_NUM			0
@@ -497,6 +499,8 @@ struct rvu {
 
 	struct ptp		*ptp;
 
+	int			mcs_blk_cnt;
+
 #ifdef CONFIG_DEBUG_FS
 	struct rvu_debugfs	rvu_dbg;
 #endif
@@ -868,4 +872,8 @@ void rvu_switch_update_rules(struct rvu *rvu, u16 pcifunc);
 int rvu_npc_set_parse_mode(struct rvu *rvu, u16 pcifunc, u64 mode, u8 dir,
 			   u64 pkind, u8 var_len_off, u8 var_len_off_mask,
 			   u8 shift_dir);
+
+/* CN10K MCS */
+int rvu_mcs_init(struct rvu *rvu);
+
 #endif /* RVU_H */
-- 
2.7.4

