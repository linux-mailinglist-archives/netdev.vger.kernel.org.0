Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B00017545C
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 08:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgCBHUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 02:20:16 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44804 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbgCBHUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 02:20:16 -0500
Received: by mail-pl1-f196.google.com with SMTP id d9so3839035plo.11
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 23:20:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DiX8YhPcnwMFepw3PUm8Vu2+vKcrFABzc3gcJxcoGwY=;
        b=ixLwicT5aVIu1xEt6os2h4XqOlDdj/VJgr/RzGjq0SfieuM/fCwRx8uSR4/g9Iaqyw
         rS5tDgdxDMDuQgFH62fQ3vKHdI8TMAmlrzF/jngcONrzGRG7h1hmc/FCt/49C/m84fL5
         /nNwTvYPz2rgIrUhdgz1Y+FTALTQLi5FPQzf3flosXQ857sHbEGvv+UtLC261b99DLZz
         dkynQmJ1Gq5/XtsiKPUMDph9/y1oNDJOr9zUP14Xrww16FlsPnkmwOuMDV+t6uR1RGw9
         UYMwONy31XdcxslVMMI2LV09jcMiVIs7IU2GXuj4dUtzZtXGhXxSYW0BkLMhKnhrJ9rJ
         rtjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DiX8YhPcnwMFepw3PUm8Vu2+vKcrFABzc3gcJxcoGwY=;
        b=Tfvdn7pqSqs5IbRwZYprP1wq0F4szmF3xr5fKGio+k3aJtSPy9erpd+j4SDfgwcj2u
         PbNEbrJRFE9nEEbxMDlR1+c8VYptMKU4hjU+/+IrwIt9VgfgbrOaJK+n8I3Qx2J5YCWX
         SNda6N81BUttjEGVdHWp/iGK0d3rPqIE1b8G47Lg+XX0ZPTR8+58N6AYm2jy1fsu/e+8
         xz2rbeOD46fijY4UPmAqeVbJmZTwVx/tuclDaHkC5Z2hLaK/AzhD6+G9HvLIE4ukMEKl
         VKITifMR2b+wZ351CYRK1XjagE9/zt60+aKe/5X3mDdZ3FPHalrgyuD5EF8HRpjf8Hs4
         Qpwg==
X-Gm-Message-State: APjAAAUJEkyfI1ol6VzKDsi2JuSvAMzpJVG6C5MuBCzCQkbTZ0aKF7oF
        7SPHo/KqpM9VPPunBSI+FEy9W1lXgVo=
X-Google-Smtp-Source: APXvYqxSkpiGOo1TngqsFkEJeJxeWOqqFOfVuRxFU16D2M7UcDfJKnGQ6RNuKwtBy/nwLgV1O1Ap4g==
X-Received: by 2002:a17:90a:f492:: with SMTP id bx18mr20416441pjb.118.1583133614523;
        Sun, 01 Mar 2020 23:20:14 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id j4sm19835042pfh.152.2020.03.01.23.20.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 01 Mar 2020 23:20:13 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Linu Cherian <lcherian@marvell.com>,
        Christina Jacob <cjacob@marvell.com>,
        Rakesh Babu <rsaladi2@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 4/7] octeontx2-af: Optimize data retrieval from firmware
Date:   Mon,  2 Mar 2020 12:49:25 +0530
Message-Id: <1583133568-5674-5-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583133568-5674-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1583133568-5674-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linu Cherian <lcherian@marvell.com>

For retrieving info like interface MAC addresses, packet
parser key extraction config etc currently a command
is sent to firmware and firmware which periodically polls
for commands, processes these and returns the info.

This is resulting in interface initialization taking lot
of time. To optimize this a memory region is shared between
firmware and this driver, firmware while booting puts
static info like these into that region for driver to
read directly without using commands.

With this
- Logic for retrieving packet parser extraction config
  via commands is removed and repalced with using the
  shared 'fwdata' structure.
- Now RVU MSIX vector address is also retrieved from this fwdata struct
  instead of from CSR. Otherwise when kexec/kdump crash kernel loads
  CSR will have a IOVA setup by primary kernel which impacts
  RVU PF/VF's interrupts.
- Also added a mbox handler for PF/VF interfaces to retrieve their MAC
  addresses from AF.

Signed-off-by: Linu Cherian <lcherian@marvell.com>
Signed-off-by: Christina Jacob <cjacob@marvell.com>
Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  71 ++++--------
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |   2 +-
 .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  |   8 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   3 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    | 120 +++++++++++++++++++--
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  30 ++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |   4 +-
 7 files changed, 173 insertions(+), 65 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index fb1971c..a4e65da 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -645,59 +645,6 @@ static inline bool cgx_event_is_linkevent(u64 event)
 		return false;
 }
 
-static inline int cgx_fwi_get_mkex_prfl_sz(u64 *prfl_sz,
-					   struct cgx *cgx)
-{
-	u64 req = 0;
-	u64 resp;
-	int err;
-
-	req = FIELD_SET(CMDREG_ID, CGX_CMD_GET_MKEX_PRFL_SIZE, req);
-	err = cgx_fwi_cmd_generic(req, &resp, cgx, 0);
-	if (!err)
-		*prfl_sz = FIELD_GET(RESP_MKEX_PRFL_SIZE, resp);
-
-	return err;
-}
-
-static inline int cgx_fwi_get_mkex_prfl_addr(u64 *prfl_addr,
-					     struct cgx *cgx)
-{
-	u64 req = 0;
-	u64 resp;
-	int err;
-
-	req = FIELD_SET(CMDREG_ID, CGX_CMD_GET_MKEX_PRFL_ADDR, req);
-	err = cgx_fwi_cmd_generic(req, &resp, cgx, 0);
-	if (!err)
-		*prfl_addr = FIELD_GET(RESP_MKEX_PRFL_ADDR, resp);
-
-	return err;
-}
-
-int cgx_get_mkex_prfl_info(u64 *addr, u64 *size)
-{
-	struct cgx *cgx_dev;
-	int err;
-
-	if (!addr || !size)
-		return -EINVAL;
-
-	cgx_dev = list_first_entry(&cgx_list, struct cgx, cgx_list);
-	if (!cgx_dev)
-		return -ENXIO;
-
-	err = cgx_fwi_get_mkex_prfl_sz(size, cgx_dev);
-	if (err)
-		return -EIO;
-
-	err = cgx_fwi_get_mkex_prfl_addr(addr, cgx_dev);
-	if (err)
-		return -EIO;
-
-	return 0;
-}
-
 static irqreturn_t cgx_fwi_event_handler(int irq, void *data)
 {
 	struct lmac *lmac = data;
@@ -781,6 +728,24 @@ int cgx_lmac_evh_unregister(void *cgxd, int lmac_id)
 	return 0;
 }
 
+int cgx_get_fwdata_base(u64 *base)
+{
+	u64 req = 0, resp;
+	struct cgx *cgx;
+	int err;
+
+	cgx = list_first_entry_or_null(&cgx_list, struct cgx, cgx_list);
+	if (!cgx)
+		return -ENXIO;
+
+	req = FIELD_SET(CMDREG_ID, CGX_CMD_GET_FWD_BASE, req);
+	err = cgx_fwi_cmd_generic(req, &resp, cgx, 0);
+	if (!err)
+		*base = FIELD_GET(RESP_FWD_BASE, resp);
+
+	return err;
+}
+
 static int cgx_fwi_link_change(struct cgx *cgx, int lmac_id, bool enable)
 {
 	u64 req = 0;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index 115f5ec..394f965 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -134,9 +134,9 @@ int cgx_lmac_internal_loopback(void *cgxd, int lmac_id, bool enable);
 int cgx_get_link_info(void *cgxd, int lmac_id,
 		      struct cgx_link_user_info *linfo);
 int cgx_lmac_linkup_start(void *cgxd);
+int cgx_get_fwdata_base(u64 *base);
 int cgx_lmac_get_pause_frm(void *cgxd, int lmac_id,
 			   u8 *tx_pause, u8 *rx_pause);
 int cgx_lmac_set_pause_frm(void *cgxd, int lmac_id,
 			   u8 tx_pause, u8 rx_pause);
-int cgx_get_mkex_prfl_info(u64 *addr, u64 *size);
 #endif /* CGX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
index 473d975..c3702fa 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
@@ -79,7 +79,8 @@ enum cgx_cmd_id {
 	CGX_CMD_MODE_CHANGE,		/* hot plug support */
 	CGX_CMD_INTF_SHUTDOWN,
 	CGX_CMD_GET_MKEX_PRFL_SIZE,
-	CGX_CMD_GET_MKEX_PRFL_ADDR
+	CGX_CMD_GET_MKEX_PRFL_ADDR,
+	CGX_CMD_GET_FWD_BASE,		/* get base address of shared FW data */
 };
 
 /* async event ids */
@@ -149,6 +150,11 @@ enum cgx_cmd_own {
  */
 #define RESP_MKEX_PRFL_ADDR		GENMASK_ULL(63, 9)
 
+/* Response to cmd ID as CGX_CMD_GET_FWD_BASE with cmd status as
+ * CGX_STAT_SUCCESS
+ */
+#define RESP_FWD_BASE		GENMASK_ULL(56, 9)
+
 /* Response to cmd ID - CGX_CMD_LINK_BRING_UP/DOWN, event ID CGX_EVT_LINK_CHANGE
  * status can be either CGX_STAT_FAIL or CGX_STAT_SUCCESS
  *
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index b2a6bee..6dfd0f9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -256,7 +256,8 @@ enum rvu_af_status {
 
 struct ready_msg_rsp {
 	struct mbox_msghdr hdr;
-	u16    sclk_feq;	/* SCLK frequency */
+	u16    sclk_freq;	/* SCLK frequency (in MHz) */
+	u16    rclk_freq;	/* RCLK frequency (in MHz) */
 };
 
 /* Structure for requesting resource provisioning.
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 5c190c3..e56b1f8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -603,7 +603,11 @@ static int rvu_setup_msix_resources(struct rvu *rvu)
 	 */
 	cfg = rvu_read64(rvu, BLKADDR_RVUM, RVU_PRIV_CONST);
 	max_msix = cfg & 0xFFFFF;
-	phy_addr = rvu_read64(rvu, BLKADDR_RVUM, RVU_AF_MSIXTR_BASE);
+	if (rvu->fwdata && rvu->fwdata->msixtr_base)
+		phy_addr = rvu->fwdata->msixtr_base;
+	else
+		phy_addr = rvu_read64(rvu, BLKADDR_RVUM, RVU_AF_MSIXTR_BASE);
+
 	iova = dma_map_resource(rvu->dev, phy_addr,
 				max_msix * PCI_MSIX_ENTRY_SIZE,
 				DMA_BIDIRECTIONAL, 0);
@@ -613,10 +617,18 @@ static int rvu_setup_msix_resources(struct rvu *rvu)
 
 	rvu_write64(rvu, BLKADDR_RVUM, RVU_AF_MSIXTR_BASE, (u64)iova);
 	rvu->msix_base_iova = iova;
+	rvu->msixtr_base_phy = phy_addr;
 
 	return 0;
 }
 
+static void rvu_reset_msix(struct rvu *rvu)
+{
+	/* Restore msixtr base register */
+	rvu_write64(rvu, BLKADDR_RVUM, RVU_AF_MSIXTR_BASE,
+		    rvu->msixtr_base_phy);
+}
+
 static void rvu_free_hw_resources(struct rvu *rvu)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
@@ -655,9 +667,80 @@ static void rvu_free_hw_resources(struct rvu *rvu)
 			   max_msix * PCI_MSIX_ENTRY_SIZE,
 			   DMA_BIDIRECTIONAL, 0);
 
+	rvu_reset_msix(rvu);
 	mutex_destroy(&rvu->rsrc_lock);
 }
 
+static void rvu_setup_pfvf_macaddress(struct rvu *rvu)
+{
+	struct rvu_hwinfo *hw = rvu->hw;
+	int pf, vf, numvfs, hwvf;
+	struct rvu_pfvf *pfvf;
+	u64 *mac;
+
+	for (pf = 0; pf < hw->total_pfs; pf++) {
+		if (!is_pf_cgxmapped(rvu, pf))
+			continue;
+		/* Assign MAC address to PF */
+		pfvf = &rvu->pf[pf];
+		if (rvu->fwdata && pf < PF_MACNUM_MAX) {
+			mac = &rvu->fwdata->pf_macs[pf];
+			if (*mac)
+				u64_to_ether_addr(*mac, pfvf->mac_addr);
+			else
+				eth_random_addr(pfvf->mac_addr);
+		} else {
+			eth_random_addr(pfvf->mac_addr);
+		}
+
+		/* Assign MAC address to VFs */
+		rvu_get_pf_numvfs(rvu, pf, &numvfs, &hwvf);
+		for (vf = 0; vf < numvfs; vf++, hwvf++) {
+			pfvf = &rvu->hwvf[hwvf];
+			if (rvu->fwdata && hwvf < VF_MACNUM_MAX) {
+				mac = &rvu->fwdata->vf_macs[hwvf];
+				if (*mac)
+					u64_to_ether_addr(*mac, pfvf->mac_addr);
+				else
+					eth_random_addr(pfvf->mac_addr);
+			} else {
+				eth_random_addr(pfvf->mac_addr);
+			}
+		}
+	}
+}
+
+static int rvu_fwdata_init(struct rvu *rvu)
+{
+	u64 fwdbase;
+	int err;
+
+	/* Get firmware data base address */
+	err = cgx_get_fwdata_base(&fwdbase);
+	if (err)
+		goto fail;
+	rvu->fwdata = ioremap_wc(fwdbase, sizeof(struct rvu_fwdata));
+	if (!rvu->fwdata)
+		goto fail;
+	if (!is_rvu_fwdata_valid(rvu)) {
+		dev_err(rvu->dev,
+			"Mismatch in 'fwdata' struct btw kernel and firmware\n");
+		iounmap(rvu->fwdata);
+		rvu->fwdata = NULL;
+		return -EINVAL;
+	}
+	return 0;
+fail:
+	dev_info(rvu->dev, "Unable to fetch 'fwdata' from firmware\n");
+	return -EIO;
+}
+
+static void rvu_fwdata_exit(struct rvu *rvu)
+{
+	if (rvu->fwdata)
+		iounmap(rvu->fwdata);
+}
+
 static int rvu_setup_hw_resources(struct rvu *rvu)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
@@ -813,6 +896,8 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 
 	mutex_init(&rvu->rsrc_lock);
 
+	rvu_fwdata_init(rvu);
+
 	err = rvu_setup_msix_resources(rvu);
 	if (err)
 		return err;
@@ -825,8 +910,10 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 		/* Allocate memory for block LF/slot to pcifunc mapping info */
 		block->fn_map = devm_kcalloc(rvu->dev, block->lf.max,
 					     sizeof(u16), GFP_KERNEL);
-		if (!block->fn_map)
-			return -ENOMEM;
+		if (!block->fn_map) {
+			err = -ENOMEM;
+			goto msix_err;
+		}
 
 		/* Scan all blocks to check if low level firmware has
 		 * already provisioned any of the resources to a PF/VF.
@@ -836,25 +923,36 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 
 	err = rvu_npc_init(rvu);
 	if (err)
-		goto exit;
+		goto npc_err;
 
 	err = rvu_cgx_init(rvu);
 	if (err)
-		goto exit;
+		goto cgx_err;
+
+	/* Assign MACs for CGX mapped functions */
+	rvu_setup_pfvf_macaddress(rvu);
 
 	err = rvu_npa_init(rvu);
 	if (err)
-		goto cgx_err;
+		goto npa_err;
 
 	err = rvu_nix_init(rvu);
 	if (err)
-		goto cgx_err;
+		goto nix_err;
 
 	return 0;
 
+nix_err:
+	rvu_nix_freemem(rvu);
+npa_err:
+	rvu_npa_freemem(rvu);
 cgx_err:
 	rvu_cgx_exit(rvu);
-exit:
+npc_err:
+	rvu_npc_freemem(rvu);
+	rvu_fwdata_exit(rvu);
+msix_err:
+	rvu_reset_msix(rvu);
 	return err;
 }
 
@@ -901,6 +999,10 @@ int rvu_aq_alloc(struct rvu *rvu, struct admin_queue **ad_queue,
 int rvu_mbox_handler_ready(struct rvu *rvu, struct msg_req *req,
 			   struct ready_msg_rsp *rsp)
 {
+	if (rvu->fwdata) {
+		rsp->rclk_freq = rvu->fwdata->rclk;
+		rsp->sclk_freq = rvu->fwdata->sclk;
+	}
 	return 0;
 }
 
@@ -2506,6 +2608,7 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	rvu_mbox_destroy(&rvu->afpf_wq_info);
 err_hwsetup:
 	rvu_cgx_exit(rvu);
+	rvu_fwdata_exit(rvu);
 	rvu_reset_all_blocks(rvu);
 	rvu_free_hw_resources(rvu);
 err_release_regions:
@@ -2527,6 +2630,7 @@ static void rvu_remove(struct pci_dev *pdev)
 	rvu_unregister_interrupts(rvu);
 	rvu_flr_wq_destroy(rvu);
 	rvu_cgx_exit(rvu);
+	rvu_fwdata_exit(rvu);
 	rvu_mbox_destroy(&rvu->afpf_wq_info);
 	rvu_disable_sriov(rvu);
 	rvu_reset_all_blocks(rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 7afb7ca..dcf25a0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -269,6 +269,26 @@ struct mbox_wq_info {
 	struct workqueue_struct *mbox_wq;
 };
 
+struct rvu_fwdata {
+#define RVU_FWDATA_HEADER_MAGIC	0xCFDA	/* Custom Firmware Data*/
+#define RVU_FWDATA_VERSION	0x0001
+	u32 header_magic;
+	u32 version;		/* version id */
+
+	/* MAC address */
+#define PF_MACNUM_MAX	32
+#define VF_MACNUM_MAX	256
+	u64 pf_macs[PF_MACNUM_MAX];
+	u64 vf_macs[VF_MACNUM_MAX];
+	u64 sclk;
+	u64 rclk;
+	u64 mcam_addr;
+	u64 mcam_sz;
+	u64 msixtr_base;
+#define FWDATA_RESERVED_MEM 1023
+	u64 reserved[FWDATA_RESERVED_MEM];
+};
+
 struct rvu {
 	void __iomem		*afreg_base;
 	void __iomem		*pfreg_base;
@@ -294,6 +314,7 @@ struct rvu {
 	char			*irq_name;
 	bool			*irq_allocated;
 	dma_addr_t		msix_base_iova;
+	u64			msixtr_base_phy; /* Register reset value */
 
 	/* CGX */
 #define PF_CGXMAP_BASE		1 /* PF 0 is reserved for RVU PF */
@@ -313,6 +334,9 @@ struct rvu {
 
 	char mkex_pfl_name[MKEX_NAME_LEN]; /* Configured MKEX profile name */
 
+	/* Firmware data */
+	struct rvu_fwdata	*fwdata;
+
 #ifdef CONFIG_DEBUG_FS
 	struct rvu_debugfs	rvu_dbg;
 #endif
@@ -363,6 +387,12 @@ static inline int is_afvf(u16 pcifunc)
 	return !(pcifunc & ~RVU_PFVF_FUNC_MASK);
 }
 
+static inline bool is_rvu_fwdata_valid(struct rvu *rvu)
+{
+	return (rvu->fwdata->header_magic == RVU_FWDATA_HEADER_MAGIC) &&
+		(rvu->fwdata->version == RVU_FWDATA_VERSION);
+}
+
 int rvu_alloc_bitmap(struct rsrc_bmap *rsrc);
 int rvu_alloc_rsrc(struct rsrc_bmap *rsrc);
 void rvu_free_rsrc(struct rsrc_bmap *rsrc, int id);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 40e431d..0a21408 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -825,8 +825,10 @@ static void npc_load_mkex_profile(struct rvu *rvu, int blkaddr)
 	if (!strncmp(mkex_profile, "default", MKEX_NAME_LEN))
 		goto load_default;
 
-	if (cgx_get_mkex_prfl_info(&prfl_addr, &prfl_sz))
+	if (!rvu->fwdata)
 		goto load_default;
+	prfl_addr = rvu->fwdata->mcam_addr;
+	prfl_sz = rvu->fwdata->mcam_sz;
 
 	if (!prfl_addr || !prfl_sz)
 		goto load_default;
-- 
2.7.4

