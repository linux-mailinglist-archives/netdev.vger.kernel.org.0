Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6B2FFFAAA
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 17:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfKQQO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 11:14:57 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38366 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfKQQO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 11:14:56 -0500
Received: by mail-pf1-f195.google.com with SMTP id c13so9121732pfp.5
        for <netdev@vger.kernel.org>; Sun, 17 Nov 2019 08:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+uUmPCmo41CB31Cr1JYOoRJfVy7WG3JGiURfTs9RQHk=;
        b=XnbA7Bpz1z8nbITMYZgtyktfMYNenxJzHTIAP2qv3nWTalfiyRiB5OuT6kc3G1CYPG
         oznmq6OL9ptjtlvLixWO4espRXJ5qFOWokKv5Ueu/bfU64+z55uSRRni7YsFxZub57B3
         O1i+SfTUrYK1JloQPJfvgVmmkc7OSZSdovdNaSXFnWCOckpOvhR8Vkf9TETo12ea2Zq7
         rFaWqk3EMXkFQgU5dsSTbL3V6Se2Z80aPsbbN5dVWzIo4eXrenyvJobKb+fUJveyXncj
         R8qlYqeRkJ48ZoPZTcgyAtvSzUppXwjLLdg/oq3rpYye6swjNot61AOa2B8yu4jW8wYc
         nwNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+uUmPCmo41CB31Cr1JYOoRJfVy7WG3JGiURfTs9RQHk=;
        b=Y8jmHBTbVEMDD9yNkhytlMZhRXt8j6PQXN4wbaKkMlGd8bWyzyijs3NfJWEEeSIz1q
         RMqEpsDQ5c7SmLjZuBZR+CxVxWtpfEUA4VfBKJc7yU6FN0T9fk8zyJFae8x4aLJ4wWhs
         W3WZ3rUVJowR+dE1hJUwrAJyjalFKEKtTYRsIKXhww9voFCKSP98tbuIC/7YFxAS6xDi
         M3Zthpon27I6tHy2FeYdsrMdxpo6q7uBNcSUoUSxoNrB55O29IgRSpeGEdwagffbfa5f
         DNajV4IiSODmDhsmWk8RX75Gg8eHklpf9GmOIwrVZxI8zy2BdhcVld9a3gnlkPJyofsu
         kD0Q==
X-Gm-Message-State: APjAAAU/GyZ46yBwVye1CFMVewJWAXTEKMBMHJKwu/2iZnq/yjRlttT3
        G9fwgF0n3+W6kIp9rZsDDGfzz07z+Mw=
X-Google-Smtp-Source: APXvYqwegW26GkSJsr4oBr+LoTaLMP2H5qBSXx8d3QVBpKyxnyc0azTmReX2wTFE13at4Ao7ZyzyVw==
X-Received: by 2002:a63:5417:: with SMTP id i23mr28649988pgb.305.1574007295598;
        Sun, 17 Nov 2019 08:14:55 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id v2sm2675231pgi.79.2019.11.17.08.14.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 17 Nov 2019 08:14:54 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Linu Cherian <lcherian@marvell.com>,
        Rakesh Babu <rsaladi2@marvell.com>,
        Vamsi Attunuru <vamsi.attunuru@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 02/15] octeontx2-af: Add support for importing firmware data
Date:   Sun, 17 Nov 2019 21:44:13 +0530
Message-Id: <1574007266-17123-3-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linu Cherian <lcherian@marvell.com>

Firmware data is essentially a block of one time configuration data
exported from firmware to kernel through shared memory. Base address
of this memory is obtained through CGX firmware interface commands.

With this in place, MAC address of CGX mapped functions are inited
from firmware data if available else they are inited with
random MAC address.

Also
- Added a new mbox for PF/VF to retrieve it's MAC address.
- Now RVU MSIX vector address is also retrieved from this fwdata struct
  instead of from CSR. Otherwise when kexec/kdump crash kernel loads
  CSR will have a IOVA setup by primary kernel which impacts
  RVU PF/VF's interrupts.

Signed-off-by: Linu Cherian <lcherian@marvell.com>
Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Vamsi Attunuru <vamsi.attunuru@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  18 ++++
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |   1 +
 .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  |   8 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   9 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    | 111 +++++++++++++++++++--
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  30 ++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  23 ++++-
 7 files changed, 191 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 5ca7886..aa2ce5e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -697,6 +697,24 @@ int cgx_lmac_evh_unregister(void *cgxd, int lmac_id)
 }
 EXPORT_SYMBOL(cgx_lmac_evh_unregister);
 
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
index 096a04a..cd3a903 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -124,5 +124,6 @@ int cgx_lmac_internal_loopback(void *cgxd, int lmac_id, bool enable);
 int cgx_get_link_info(void *cgxd, int lmac_id,
 		      struct cgx_link_user_info *linfo);
 int cgx_lmac_linkup_start(void *cgxd);
+int cgx_get_fwdata_base(u64 *base);
 int cgx_get_mkex_prfl_info(u64 *addr, u64 *size);
 #endif /* CGX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
index fb3ba49..cc505bc 100644
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
index eea174d..b6acc6e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -214,6 +214,7 @@ M(NIX_RXVLAN_ALLOC,	0x8012, nix_rxvlan_alloc, msg_req, msg_rsp)	\
 M(NIX_BP_ENABLE,	0x8016, nix_bp_enable, nix_bp_cfg_req,	\
 				nix_bp_cfg_rsp)	\
 M(NIX_BP_DISABLE,	0x8017, nix_bp_disable, nix_bp_cfg_req, msg_rsp) \
+M(NIX_GET_MAC_ADDR, 0x8018, nix_get_mac_addr, msg_req, nix_get_mac_addr_rsp)
 
 /* Messages initiated by AF (range 0xC00 - 0xDFF) */
 #define MBOX_UP_CGX_MESSAGES						\
@@ -253,7 +254,8 @@ enum rvu_af_status {
 
 struct ready_msg_rsp {
 	struct mbox_msghdr hdr;
-	u16    sclk_feq;	/* SCLK frequency */
+	u16    sclk_freq;	/* SCLK frequency (in MHz) */
+	u16    rclk_freq;	/* RCLK frequency (in MHz) */
 };
 
 /* Structure for requesting resource provisioning.
@@ -621,6 +623,11 @@ struct nix_set_mac_addr {
 	u8 mac_addr[ETH_ALEN]; /* MAC address to be set for this pcifunc */
 };
 
+struct nix_get_mac_addr_rsp {
+	struct mbox_msghdr hdr;
+	u8 mac_addr[ETH_ALEN];
+};
+
 struct nix_mark_format_cfg {
 	struct mbox_msghdr hdr;
 	u8 offset;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 5c190c3..90c30e6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -603,7 +603,12 @@ static int rvu_setup_msix_resources(struct rvu *rvu)
 	 */
 	cfg = rvu_read64(rvu, BLKADDR_RVUM, RVU_PRIV_CONST);
 	max_msix = cfg & 0xFFFFF;
-	phy_addr = rvu_read64(rvu, BLKADDR_RVUM, RVU_AF_MSIXTR_BASE);
+	if (rvu->fwdata && rvu->fwdata->msixtr_base)
+		phy_addr = rvu->fwdata->msixtr_base;
+	else
+		phy_addr = rvu_read64(rvu, BLKADDR_RVUM, RVU_AF_MSIXTR_BASE);
+	/* Register save */
+	rvu->msixtr_base_phy = phy_addr;
 	iova = dma_map_resource(rvu->dev, phy_addr,
 				max_msix * PCI_MSIX_ENTRY_SIZE,
 				DMA_BIDIRECTIONAL, 0);
@@ -617,6 +622,13 @@ static int rvu_setup_msix_resources(struct rvu *rvu)
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
+		/* Assign MAC address to VFs*/
+		rvu_get_pf_numvfs(rvu, pf, &numvfs, &hwvf);
+		for (vf = 0; vf < numvfs; vf++, hwvf++) {
+			pfvf =  &rvu->hwvf[hwvf];
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
@@ -836,11 +923,14 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 
 	err = rvu_npc_init(rvu);
 	if (err)
-		goto exit;
+		goto fwdata_err;
 
 	err = rvu_cgx_init(rvu);
 	if (err)
-		goto exit;
+		goto fwdata_err;
+
+	/* Assign MACs for CGX mapped functions */
+	rvu_setup_pfvf_macaddress(rvu);
 
 	err = rvu_npa_init(rvu);
 	if (err)
@@ -854,7 +944,10 @@ static int rvu_setup_hw_resources(struct rvu *rvu)
 
 cgx_err:
 	rvu_cgx_exit(rvu);
-exit:
+fwdata_err:
+	rvu_fwdata_exit(rvu);
+msix_err:
+	rvu_reset_msix(rvu);
 	return err;
 }
 
@@ -901,6 +994,10 @@ int rvu_aq_alloc(struct rvu *rvu, struct admin_queue **ad_queue,
 int rvu_mbox_handler_ready(struct rvu *rvu, struct msg_req *req,
 			   struct ready_msg_rsp *rsp)
 {
+	if (rvu->fwdata) {
+		rsp->rclk_freq = rvu->fwdata->rclk;
+		rsp->sclk_freq = rvu->fwdata->sclk;
+	}
 	return 0;
 }
 
@@ -2506,6 +2603,7 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	rvu_mbox_destroy(&rvu->afpf_wq_info);
 err_hwsetup:
 	rvu_cgx_exit(rvu);
+	rvu_fwdata_exit(rvu);
 	rvu_reset_all_blocks(rvu);
 	rvu_free_hw_resources(rvu);
 err_release_regions:
@@ -2527,6 +2625,7 @@ static void rvu_remove(struct pci_dev *pdev)
 	rvu_unregister_interrupts(rvu);
 	rvu_flr_wq_destroy(rvu);
 	rvu_cgx_exit(rvu);
+	rvu_fwdata_exit(rvu);
 	rvu_mbox_destroy(&rvu->afpf_wq_info);
 	rvu_disable_sriov(rvu);
 	rvu_reset_all_blocks(rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index b252d86..b7002f4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -269,6 +269,26 @@ struct mbox_wq_info {
 	struct workqueue_struct *mbox_wq;
 };
 
+struct rvu_fwdata {
+#define RVU_FWDATA_HEADER_MAGIC	0xCFDA	/*Custom Firmware Data*/
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
+	u64			msixtr_base_phy;/* Register reset value */
 
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
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index cb1d653..83bd42e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2666,6 +2666,7 @@ int rvu_mbox_handler_nix_set_mac_addr(struct rvu *rvu,
 				      struct nix_set_mac_addr *req,
 				      struct msg_rsp *rsp)
 {
+	bool from_vf = !!(req->hdr.pcifunc & RVU_PFVF_FUNC_MASK);
 	struct rvu_hwinfo *hw = rvu->hw;
 	u16 pcifunc = req->hdr.pcifunc;
 	struct rvu_pfvf *pfvf;
@@ -2680,7 +2681,10 @@ int rvu_mbox_handler_nix_set_mac_addr(struct rvu *rvu,
 	if (nixlf < 0)
 		return NIX_AF_ERR_AF_LF_INVALID;
 
-	ether_addr_copy(pfvf->mac_addr, req->mac_addr);
+	/* Skip updating mac addr if request is from vf */
+	if (!from_vf)
+		ether_addr_copy(pfvf->mac_addr, req->mac_addr);
+
 
 	rvu_npc_install_ucast_entry(rvu, pcifunc, nixlf,
 				    pfvf->rx_chan_base, req->mac_addr);
@@ -2690,6 +2694,23 @@ int rvu_mbox_handler_nix_set_mac_addr(struct rvu *rvu,
 	return 0;
 }
 
+int rvu_mbox_handler_nix_get_mac_addr(struct rvu *rvu,
+				      struct msg_req *req,
+				      struct nix_get_mac_addr_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	struct rvu_pfvf *pfvf;
+
+	if (!is_nixlf_attached(rvu, pcifunc))
+		return NIX_AF_ERR_AF_LF_INVALID;
+
+	pfvf = rvu_get_pfvf(rvu, pcifunc);
+
+	ether_addr_copy(rsp->mac_addr, pfvf->mac_addr);
+
+	return 0;
+}
+
 int rvu_mbox_handler_nix_set_rx_mode(struct rvu *rvu, struct nix_rx_mode *req,
 				     struct msg_rsp *rsp)
 {
-- 
2.7.4

