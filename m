Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2565C3B5C3
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 15:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390271AbfFJNGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 09:06:49 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:28415 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388848AbfFJNGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 09:06:49 -0400
Received: from fcoe-test11.asicdesigners.com (fcoe-test11.blr.asicdesigners.com [10.193.185.180])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x5AD6g4J026709;
        Mon, 10 Jun 2019 06:06:43 -0700
From:   Varun Prakash <varun@chelsio.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, dt@chelsio.com, indranil@chelsio.com,
        ganji.aravind@chelsio.com, varun@chelsio.com
Subject: [PATCH v3 net-next] cxgb4/libcxgb/cxgb4i/cxgbit: enable eDRAM page pods for iSCSI
Date:   Mon, 10 Jun 2019 18:36:34 +0530
Message-Id: <1560171994-9505-1-git-send-email-varun@chelsio.com>
X-Mailer: git-send-email 2.0.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Page pods are used for direct data placement, this patch
enables eDRAM page pods if firmware supports this feature.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 v3: reordered local variable declarations in reverse christmas tree format
 v2: fixed incorrect spelling of "contiguous"

 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    | 57 ++++++++++++++++++++++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h     |  1 +
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h      |  3 ++
 drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c | 47 +++++++++++++++---
 drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.h |  7 +--
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c                 | 10 ++--
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c                 | 17 +++++--
 drivers/scsi/cxgbi/libcxgbi.c                      | 15 +++---
 drivers/scsi/cxgbi/libcxgbi.h                      |  9 ++--
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c           |  6 ++-
 10 files changed, 142 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index cd957a1..5490800 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -782,6 +782,40 @@ static void free_msix_queue_irqs(struct adapter *adap)
 	}
 }
 
+static int setup_ppod_edram(struct adapter *adap)
+{
+	unsigned int param, val;
+	int ret;
+
+	/* Driver sends FW_PARAMS_PARAM_DEV_PPOD_EDRAM read command to check
+	 * if firmware supports ppod edram feature or not. If firmware
+	 * returns 1, then driver can enable this feature by sending
+	 * FW_PARAMS_PARAM_DEV_PPOD_EDRAM write command with value 1 to
+	 * enable ppod edram feature.
+	 */
+	param = (FW_PARAMS_MNEM_V(FW_PARAMS_MNEM_DEV) |
+		FW_PARAMS_PARAM_X_V(FW_PARAMS_PARAM_DEV_PPOD_EDRAM));
+
+	ret = t4_query_params(adap, adap->mbox, adap->pf, 0, 1, &param, &val);
+	if (ret < 0) {
+		dev_warn(adap->pdev_dev,
+			 "querying PPOD_EDRAM support failed: %d\n",
+			 ret);
+		return -1;
+	}
+
+	if (val != 1)
+		return -1;
+
+	ret = t4_set_params(adap, adap->mbox, adap->pf, 0, 1, &param, &val);
+	if (ret < 0) {
+		dev_err(adap->pdev_dev,
+			"setting PPOD_EDRAM failed: %d\n", ret);
+		return -1;
+	}
+	return 0;
+}
+
 /**
  *	cxgb4_write_rss - write the RSS table for a given port
  *	@pi: the port
@@ -4166,6 +4200,13 @@ static int adap_init0_config(struct adapter *adapter, int reset)
 		dev_err(adapter->pdev_dev,
 			"HMA configuration failed with error %d\n", ret);
 
+	if (is_t6(adapter->params.chip)) {
+		ret = setup_ppod_edram(adapter);
+		if (!ret)
+			dev_info(adapter->pdev_dev, "Successfully enabled "
+				 "ppod edram feature\n");
+	}
+
 	/*
 	 * And finally tell the firmware to initialize itself using the
 	 * parameters from the Configuration File.
@@ -4789,6 +4830,22 @@ static int adap_init0(struct adapter *adap)
 			goto bye;
 		adap->vres.iscsi.start = val[0];
 		adap->vres.iscsi.size = val[1] - val[0] + 1;
+		if (is_t6(adap->params.chip)) {
+			params[0] = FW_PARAM_PFVF(PPOD_EDRAM_START);
+			params[1] = FW_PARAM_PFVF(PPOD_EDRAM_END);
+			ret = t4_query_params(adap, adap->mbox, adap->pf, 0, 2,
+					      params, val);
+			if (!ret) {
+				adap->vres.ppod_edram.start = val[0];
+				adap->vres.ppod_edram.size =
+					val[1] - val[0] + 1;
+
+				dev_info(adap->pdev_dev,
+					 "ppod edram start 0x%x end 0x%x size 0x%x\n",
+					 val[0], val[1],
+					 adap->vres.ppod_edram.size);
+			}
+		}
 		/* LIO target and cxgb4i initiaitor */
 		adap->num_ofld_uld += 2;
 	}
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
index 42ae28d..cee582e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h
@@ -292,6 +292,7 @@ struct cxgb4_virt_res {                      /* virtualized HW resources */
 	struct cxgb4_range ocq;
 	struct cxgb4_range key;
 	unsigned int ncrypto_fc;
+	struct cxgb4_range ppod_edram;
 };
 
 struct chcr_stats_debug {
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
index 0be4ce5..65313f6 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h
@@ -1270,6 +1270,7 @@ enum fw_params_param_dev {
 	FW_PARAMS_PARAM_DEV_TPCHMAP     = 0x1F,
 	FW_PARAMS_PARAM_DEV_HMA_SIZE	= 0x20,
 	FW_PARAMS_PARAM_DEV_RDMA_WRITE_WITH_IMM = 0x21,
+	FW_PARAMS_PARAM_DEV_PPOD_EDRAM  = 0x23,
 	FW_PARAMS_PARAM_DEV_RI_WRITE_CMPL_WR    = 0x24,
 	FW_PARAMS_PARAM_DEV_OPAQUE_VIID_SMT_EXTN = 0x27,
 	FW_PARAMS_PARAM_DEV_HASHFILTER_WITH_OFLD = 0x28,
@@ -1332,6 +1333,8 @@ enum fw_params_param_pfvf {
 	FW_PARAMS_PARAM_PFVF_RAWF_END = 0x37,
 	FW_PARAMS_PARAM_PFVF_NCRYPTO_LOOKASIDE = 0x39,
 	FW_PARAMS_PARAM_PFVF_PORT_CAPS32 = 0x3A,
+	FW_PARAMS_PARAM_PFVF_PPOD_EDRAM_START = 0x3B,
+	FW_PARAMS_PARAM_PFVF_PPOD_EDRAM_END = 0x3C,
 	FW_PARAMS_PARAM_PFVF_LINK_STATE = 0x40,
 };
 
diff --git a/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c b/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c
index e291900..2103453 100644
--- a/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c
+++ b/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c
@@ -123,6 +123,9 @@ static int ppm_get_cpu_entries(struct cxgbi_ppm *ppm, unsigned int count,
 	unsigned int cpu;
 	int i;
 
+	if (!ppm->pool)
+		return -EINVAL;
+
 	cpu = get_cpu();
 	pool = per_cpu_ptr(ppm->pool, cpu);
 	spin_lock_bh(&pool->lock);
@@ -169,7 +172,9 @@ static int ppm_get_entries(struct cxgbi_ppm *ppm, unsigned int count,
 	}
 
 	ppm->next = i + count;
-	if (ppm->next >= ppm->bmap_index_max)
+	if (ppm->max_index_in_edram && (ppm->next >= ppm->max_index_in_edram))
+		ppm->next = 0;
+	else if (ppm->next >= ppm->bmap_index_max)
 		ppm->next = 0;
 
 	spin_unlock_bh(&ppm->map_lock);
@@ -382,18 +387,36 @@ static struct cxgbi_ppm_pool *ppm_alloc_cpu_pool(unsigned int *total,
 
 int cxgbi_ppm_init(void **ppm_pp, struct net_device *ndev,
 		   struct pci_dev *pdev, void *lldev,
-		   struct cxgbi_tag_format *tformat,
-		   unsigned int ppmax,
-		   unsigned int llimit,
-		   unsigned int start,
-		   unsigned int reserve_factor)
+		   struct cxgbi_tag_format *tformat, unsigned int iscsi_size,
+		   unsigned int llimit, unsigned int start,
+		   unsigned int reserve_factor, unsigned int iscsi_edram_start,
+		   unsigned int iscsi_edram_size)
 {
 	struct cxgbi_ppm *ppm = (struct cxgbi_ppm *)(*ppm_pp);
 	struct cxgbi_ppm_pool *pool = NULL;
-	unsigned int ppmax_pool = 0;
 	unsigned int pool_index_max = 0;
-	unsigned int alloc_sz;
+	unsigned int ppmax_pool = 0;
 	unsigned int ppod_bmap_size;
+	unsigned int alloc_sz;
+	unsigned int ppmax;
+
+	if (!iscsi_edram_start)
+		iscsi_edram_size = 0;
+
+	if (iscsi_edram_size &&
+	    ((iscsi_edram_start + iscsi_edram_size) != start)) {
+		pr_err("iscsi ppod region not contiguous: EDRAM start 0x%x "
+			"size 0x%x DDR start 0x%x\n",
+			iscsi_edram_start, iscsi_edram_size, start);
+		return -EINVAL;
+	}
+
+	if (iscsi_edram_size) {
+		reserve_factor = 0;
+		start = iscsi_edram_start;
+	}
+
+	ppmax = (iscsi_edram_size + iscsi_size) >> PPOD_SIZE_SHIFT;
 
 	if (ppm) {
 		pr_info("ippm: %s, ppm 0x%p,0x%p already initialized, %u/%u.\n",
@@ -434,6 +457,14 @@ int cxgbi_ppm_init(void **ppm_pp, struct net_device *ndev,
 			__func__, ppmax, ppmax_pool, ppod_bmap_size, start,
 			end);
 	}
+	if (iscsi_edram_size) {
+		unsigned int first_ddr_idx =
+				iscsi_edram_size >> PPOD_SIZE_SHIFT;
+
+		ppm->max_index_in_edram = first_ddr_idx - 1;
+		bitmap_set(ppm->ppod_bmap, first_ddr_idx, 1);
+		pr_debug("reserved %u ppod in bitmap\n", first_ddr_idx);
+	}
 
 	spin_lock_init(&ppm->map_lock);
 	kref_init(&ppm->refcnt);
diff --git a/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.h b/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.h
index a91ad76..7b02c20 100644
--- a/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.h
+++ b/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.h
@@ -143,6 +143,7 @@ struct cxgbi_ppm {
 	spinlock_t map_lock;		/* ppm map lock */
 	unsigned int bmap_index_max;
 	unsigned int next;
+	unsigned int max_index_in_edram;
 	unsigned long *ppod_bmap;
 	struct cxgbi_ppod_data ppod_data[0];
 };
@@ -324,9 +325,9 @@ int cxgbi_ppm_ppods_reserve(struct cxgbi_ppm *, unsigned short nr_pages,
 			    unsigned long caller_data);
 int cxgbi_ppm_init(void **ppm_pp, struct net_device *, struct pci_dev *,
 		   void *lldev, struct cxgbi_tag_format *,
-		   unsigned int ppmax, unsigned int llimit,
-		   unsigned int start,
-		   unsigned int reserve_factor);
+		   unsigned int iscsi_size, unsigned int llimit,
+		   unsigned int start, unsigned int reserve_factor,
+		   unsigned int edram_start, unsigned int edram_size);
 int cxgbi_ppm_release(struct cxgbi_ppm *ppm);
 void cxgbi_tagmask_check(unsigned int tagmask, struct cxgbi_tag_format *);
 unsigned int cxgbi_tagmask_set(unsigned int ppmax);
diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index b8dd9e6..524cdbc 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -1243,8 +1243,12 @@ static int cxgb3i_ddp_init(struct cxgbi_device *cdev)
 		tformat.pgsz_order[i] = uinfo.pgsz_factor[i];
 	cxgbi_tagmask_check(tagmask, &tformat);
 
-	cxgbi_ddp_ppm_setup(&tdev->ulp_iscsi, cdev, &tformat, ppmax,
-			    uinfo.llimit, uinfo.llimit, 0);
+	err = cxgbi_ddp_ppm_setup(&tdev->ulp_iscsi, cdev, &tformat,
+				  (uinfo.ulimit - uinfo.llimit + 1),
+				  uinfo.llimit, uinfo.llimit, 0, 0, 0);
+	if (err)
+		return err;
+
 	if (!(cdev->flags & CXGBI_FLAG_DDP_OFF)) {
 		uinfo.tagmask = tagmask;
 		uinfo.ulimit = uinfo.llimit + (ppmax << PPOD_SIZE_SHIFT);
@@ -1318,7 +1322,7 @@ static void cxgb3i_dev_open(struct t3cdev *t3dev)
 
 	err = cxgb3i_ddp_init(cdev);
 	if (err) {
-		pr_info("0x%p ddp init failed\n", cdev);
+		pr_info("0x%p ddp init failed %d\n", cdev, err);
 		goto err_out;
 	}
 
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 124f334..66d6e1f 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -2070,7 +2070,7 @@ static int cxgb4i_ddp_init(struct cxgbi_device *cdev)
 	struct net_device *ndev = cdev->ports[0];
 	struct cxgbi_tag_format tformat;
 	unsigned int ppmax;
-	int i;
+	int i, err;
 
 	if (!lldi->vr->iscsi.size) {
 		pr_warn("%s, iscsi NOT enabled, check config!\n", ndev->name);
@@ -2086,8 +2086,17 @@ static int cxgb4i_ddp_init(struct cxgbi_device *cdev)
 					 & 0xF;
 	cxgbi_tagmask_check(lldi->iscsi_tagmask, &tformat);
 
-	cxgbi_ddp_ppm_setup(lldi->iscsi_ppm, cdev, &tformat, ppmax,
-			    lldi->iscsi_llimit, lldi->vr->iscsi.start, 2);
+	pr_info("iscsi_edram.start 0x%x iscsi_edram.size 0x%x",
+		lldi->vr->ppod_edram.start, lldi->vr->ppod_edram.size);
+
+	err = cxgbi_ddp_ppm_setup(lldi->iscsi_ppm, cdev, &tformat,
+				  lldi->vr->iscsi.size, lldi->iscsi_llimit,
+				  lldi->vr->iscsi.start, 2,
+				  lldi->vr->ppod_edram.start,
+				  lldi->vr->ppod_edram.size);
+
+	if (err < 0)
+		return err;
 
 	cdev->csk_ddp_setup_digest = ddp_setup_conn_digest;
 	cdev->csk_ddp_setup_pgidx = ddp_setup_conn_pgidx;
@@ -2141,7 +2150,7 @@ static void *t4_uld_add(const struct cxgb4_lld_info *lldi)
 
 	rc = cxgb4i_ddp_init(cdev);
 	if (rc) {
-		pr_info("t4 0x%p ddp init failed.\n", cdev);
+		pr_info("t4 0x%p ddp init failed %d.\n", cdev, rc);
 		goto err_out;
 	}
 	rc = cxgb4i_ofld_init(cdev);
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 7d43e01..3e17af8 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1285,14 +1285,15 @@ EXPORT_SYMBOL_GPL(cxgbi_ddp_set_one_ppod);
 
 static unsigned char padding[4];
 
-void cxgbi_ddp_ppm_setup(void **ppm_pp, struct cxgbi_device *cdev,
-			 struct cxgbi_tag_format *tformat, unsigned int ppmax,
-			 unsigned int llimit, unsigned int start,
-			 unsigned int rsvd_factor)
+int cxgbi_ddp_ppm_setup(void **ppm_pp, struct cxgbi_device *cdev,
+			struct cxgbi_tag_format *tformat,
+			unsigned int iscsi_size, unsigned int llimit,
+			unsigned int start, unsigned int rsvd_factor,
+			unsigned int edram_start, unsigned int edram_size)
 {
 	int err = cxgbi_ppm_init(ppm_pp, cdev->ports[0], cdev->pdev,
-				cdev->lldev, tformat, ppmax, llimit, start,
-				rsvd_factor);
+				cdev->lldev, tformat, iscsi_size, llimit, start,
+				rsvd_factor, edram_start, edram_size);
 
 	if (err >= 0) {
 		struct cxgbi_ppm *ppm = (struct cxgbi_ppm *)(*ppm_pp);
@@ -1304,6 +1305,8 @@ void cxgbi_ddp_ppm_setup(void **ppm_pp, struct cxgbi_device *cdev,
 	} else {
 		cdev->flags |= CXGBI_FLAG_DDP_OFF;
 	}
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(cxgbi_ddp_ppm_setup);
 
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 1917ff5..84b96af 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -617,8 +617,9 @@ void cxgbi_ddp_page_size_factor(int *);
 void cxgbi_ddp_set_one_ppod(struct cxgbi_pagepod *,
 			    struct cxgbi_task_tag_info *,
 			    struct scatterlist **sg_pp, unsigned int *sg_off);
-void cxgbi_ddp_ppm_setup(void **ppm_pp, struct cxgbi_device *,
-			 struct cxgbi_tag_format *, unsigned int ppmax,
-			 unsigned int llimit, unsigned int start,
-			 unsigned int rsvd_factor);
+int cxgbi_ddp_ppm_setup(void **ppm_pp, struct cxgbi_device *cdev,
+			struct cxgbi_tag_format *tformat,
+			unsigned int iscsi_size, unsigned int llimit,
+			unsigned int start, unsigned int rsvd_factor,
+			unsigned int edram_start, unsigned int edram_size);
 #endif	/*__LIBCXGBI_H__*/
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
index d57fd3e..1443ef0 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
@@ -318,8 +318,10 @@ int cxgbit_ddp_init(struct cxgbit_device *cdev)
 
 	ret = cxgbi_ppm_init(lldi->iscsi_ppm, cdev->lldi.ports[0],
 			     cdev->lldi.pdev, &cdev->lldi, &tformat,
-			     ppmax, lldi->iscsi_llimit,
-			     lldi->vr->iscsi.start, 2);
+			     lldi->vr->iscsi.size, lldi->iscsi_llimit,
+			     lldi->vr->iscsi.start, 2,
+			     lldi->vr->ppod_edram.start,
+			     lldi->vr->ppod_edram.size);
 	if (ret >= 0) {
 		struct cxgbi_ppm *ppm = (struct cxgbi_ppm *)(*lldi->iscsi_ppm);
 
-- 
2.0.2

