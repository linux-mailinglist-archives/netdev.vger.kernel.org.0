Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A02288CEA
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 17:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389383AbgJIPgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 11:36:36 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31560 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389384AbgJIPge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 11:36:34 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 099FV3Th023632;
        Fri, 9 Oct 2020 08:36:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=kTxyd3UDiOXiohVAAemSNEtdB1fYJI8HLWgo5Yl6Vts=;
 b=Fty1cE7vEtfREGaJPLY0cH6PVWg2iPKvTfzoYvZ/ClVSAgW7bGqVXIoOD0V+59JmwFl4
 HhPTPXkBttlfimHZonR4BT75QvbRnKc8nCJkfZ5qiX5beKBjn+3jxrBjCRvX1UmrnLVo
 ia/EDDgt86jbzdGv+P5zK3kvcKNoL+WgprriwOx2AOe/MWjy59CXgzkBArJ3HaKPTpgd
 o6k9r/6LIShWqBUu6oMYXfypINBxOi4SuGmS0O2R9QdChTNowmk0b2CiHS+tr8NbDkyV
 f6ZDweZLFyhMLmCqNzMCh5u4ob4/nu4iNVrDayn4XcdU5ngaGTejyzKcvzMYxiehY6CX sQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3429hh34s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 09 Oct 2020 08:36:17 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Oct
 2020 08:36:15 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 9 Oct
 2020 08:36:14 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 9 Oct 2020 08:36:14 -0700
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id D02AA3F703F;
        Fri,  9 Oct 2020 08:36:10 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <kuba@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <schandran@marvell.com>,
        <pathreya@marvell.com>, Srujana Challa <schalla@marvell.com>
Subject: [PATCH v4,net-next,12/13] crypto: octeontx2: add support to process the crypto request
Date:   Fri, 9 Oct 2020 21:04:20 +0530
Message-ID: <20201009153421.30562-13-schalla@marvell.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201009153421.30562-1-schalla@marvell.com>
References: <20201009153421.30562-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-09_06:2020-10-09,2020-10-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Attach LFs to CPT VF to process the crypto requests and register LF
interrupts.

Signed-off-by: Suheil Chandran <schandran@marvell.com>
Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/crypto/marvell/octeontx2/Makefile     |   2 +-
 .../marvell/octeontx2/otx2_cpt_reqmgr.h       | 145 +++++
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h |   7 +
 .../marvell/octeontx2/otx2_cptvf_main.c       | 196 +++++++
 .../marvell/octeontx2/otx2_cptvf_mbox.c       |  26 +
 .../marvell/octeontx2/otx2_cptvf_reqmgr.c     | 532 ++++++++++++++++++
 6 files changed, 907 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c

diff --git a/drivers/crypto/marvell/octeontx2/Makefile b/drivers/crypto/marvell/octeontx2/Makefile
index ef6fb2ab3571..41c0a5832b3f 100644
--- a/drivers/crypto/marvell/octeontx2/Makefile
+++ b/drivers/crypto/marvell/octeontx2/Makefile
@@ -4,6 +4,6 @@ obj-$(CONFIG_CRYPTO_DEV_OCTEONTX2_CPT) += octeontx2-cpt.o octeontx2-cptvf.o
 octeontx2-cpt-objs := otx2_cptpf_main.o otx2_cptpf_mbox.o \
 		      otx2_cpt_mbox_common.o otx2_cptpf_ucode.o otx2_cptlf.o
 octeontx2-cptvf-objs := otx2_cptvf_main.o otx2_cptvf_mbox.o otx2_cptlf.o \
-			otx2_cpt_mbox_common.o
+			otx2_cpt_mbox_common.o otx2_cptvf_reqmgr.o
 
 ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
index 9184f91c68c1..5e191434ab98 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h
@@ -10,6 +10,22 @@
 /* Completion code size and initial value */
 #define OTX2_CPT_COMPLETION_CODE_SIZE 8
 #define OTX2_CPT_COMPLETION_CODE_INIT OTX2_CPT_COMP_E_NOTDONE
+/*
+ * Maximum total number of SG buffers is 100, we divide it equally
+ * between input and output
+ */
+#define OTX2_CPT_MAX_SG_IN_CNT  50
+#define OTX2_CPT_MAX_SG_OUT_CNT 50
+
+/* DMA mode direct or SG */
+#define OTX2_CPT_DMA_MODE_DIRECT 0
+#define OTX2_CPT_DMA_MODE_SG     1
+
+/* Context source CPTR or DPTR */
+#define OTX2_CPT_FROM_CPTR 0
+#define OTX2_CPT_FROM_DPTR 1
+
+#define OTX2_CPT_MAX_REQ_SIZE 65535
 
 union otx2_cpt_opcode {
 	u16 flags;
@@ -19,6 +35,13 @@ union otx2_cpt_opcode {
 	} s;
 };
 
+struct otx2_cptvf_request {
+	u32 param1;
+	u32 param2;
+	u16 dlen;
+	union otx2_cpt_opcode opcode;
+};
+
 /*
  * CPT_INST_S software command definitions
  * Words EI (0-3)
@@ -48,4 +71,126 @@ struct otx2_cpt_iq_command {
 	union otx2_cpt_iq_cmd_word3 cptr;
 };
 
+struct otx2_cpt_pending_entry {
+	void *completion_addr;	/* Completion address */
+	void *info;
+	/* Kernel async request callback */
+	void (*callback)(int status, void *arg1, void *arg2);
+	struct crypto_async_request *areq; /* Async request callback arg */
+	u8 resume_sender;	/* Notify sender to resume sending requests */
+	u8 busy;		/* Entry status (free/busy) */
+};
+
+struct otx2_cpt_pending_queue {
+	struct otx2_cpt_pending_entry *head; /* Head of the queue */
+	u32 front;		/* Process work from here */
+	u32 rear;		/* Append new work here */
+	u32 pending_count;	/* Pending requests count */
+	u32 qlen;		/* Queue length */
+	spinlock_t lock;	/* Queue lock */
+};
+
+struct otx2_cpt_buf_ptr {
+	u8 *vptr;
+	dma_addr_t dma_addr;
+	u16 size;
+};
+
+union otx2_cpt_ctrl_info {
+	u32 flags;
+	struct {
+#if defined(__BIG_ENDIAN_BITFIELD)
+		u32 reserved_6_31:26;
+		u32 grp:3;	/* Group bits */
+		u32 dma_mode:2;	/* DMA mode */
+		u32 se_req:1;	/* To SE core */
+#else
+		u32 se_req:1;	/* To SE core */
+		u32 dma_mode:2;	/* DMA mode */
+		u32 grp:3;	/* Group bits */
+		u32 reserved_6_31:26;
+#endif
+	} s;
+};
+
+struct otx2_cpt_req_info {
+	/* Kernel async request callback */
+	void (*callback)(int status, void *arg1, void *arg2);
+	struct crypto_async_request *areq; /* Async request callback arg */
+	struct otx2_cptvf_request req;/* Request information (core specific) */
+	union otx2_cpt_ctrl_info ctrl;/* User control information */
+	struct otx2_cpt_buf_ptr in[OTX2_CPT_MAX_SG_IN_CNT];
+	struct otx2_cpt_buf_ptr out[OTX2_CPT_MAX_SG_OUT_CNT];
+	u8 *iv_out;     /* IV to send back */
+	u16 rlen;	/* Output length */
+	u8 in_cnt;	/* Number of input buffers */
+	u8 out_cnt;	/* Number of output buffers */
+	u8 req_type;	/* Type of request */
+	u8 is_enc;	/* Is a request an encryption request */
+	u8 is_trunc_hmac;/* Is truncated hmac used */
+};
+
+struct otx2_cpt_inst_info {
+	struct otx2_cpt_pending_entry *pentry;
+	struct otx2_cpt_req_info *req;
+	struct pci_dev *pdev;
+	void *completion_addr;
+	u8 *out_buffer;
+	u8 *in_buffer;
+	dma_addr_t dptr_baddr;
+	dma_addr_t rptr_baddr;
+	dma_addr_t comp_baddr;
+	unsigned long time_in;
+	u32 dlen;
+	u32 dma_len;
+	u8 extra_time;
+};
+
+struct otx2_cpt_sglist_component {
+	__be16 len0;
+	__be16 len1;
+	__be16 len2;
+	__be16 len3;
+	__be64 ptr0;
+	__be64 ptr1;
+	__be64 ptr2;
+	__be64 ptr3;
+};
+
+static inline void otx2_cpt_info_destroy(struct pci_dev *pdev,
+					 struct otx2_cpt_inst_info *info)
+{
+	struct otx2_cpt_req_info *req;
+	int i;
+
+	if (info->dptr_baddr)
+		dma_unmap_single(&pdev->dev, info->dptr_baddr,
+				 info->dma_len, DMA_BIDIRECTIONAL);
+
+	if (info->req) {
+		req = info->req;
+		for (i = 0; i < req->out_cnt; i++) {
+			if (req->out[i].dma_addr)
+				dma_unmap_single(&pdev->dev,
+						 req->out[i].dma_addr,
+						 req->out[i].size,
+						 DMA_BIDIRECTIONAL);
+		}
+
+		for (i = 0; i < req->in_cnt; i++) {
+			if (req->in[i].dma_addr)
+				dma_unmap_single(&pdev->dev,
+						 req->in[i].dma_addr,
+						 req->in[i].size,
+						 DMA_BIDIRECTIONAL);
+		}
+	}
+	kzfree(info);
+}
+
+struct otx2_cptlf_wqe;
+int otx2_cpt_do_request(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
+			int cpu_num);
+void otx2_cpt_post_process(struct otx2_cptlf_wqe *wqe);
+
 #endif /* __OTX2_CPT_REQMGR_H */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
index edf404f039cf..18cedfb06131 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptlf.h
@@ -80,6 +80,7 @@ struct otx2_cptlf_info {
 	u8 slot;                                /* Slot number of this LF */
 
 	struct otx2_cpt_inst_queue iqueue;/* Instruction queue */
+	struct otx2_cpt_pending_queue pqueue; /* Pending queue */
 	struct otx2_cptlf_wqe *wqe;       /* Tasklet work info */
 };
 
@@ -91,6 +92,7 @@ struct otx2_cptlfs_info {
 	struct otx2_mbox *mbox;
 	u8 are_lfs_attached;	/* Whether CPT LFs are attached */
 	u8 lfs_num;		/* Number of CPT LFs */
+	u8 kcrypto_eng_grp_num;	/* Kernel crypto engine group number */
 	atomic_t state;         /* LF's state. started/reset */
 };
 
@@ -333,6 +335,11 @@ static inline void otx2_cpt_send_cmd(union otx2_cpt_inst_s *cptinst,
 	} while (!ret);
 }
 
+static inline bool otx2_cptlf_started(struct otx2_cptlfs_info *lfs)
+{
+	return atomic_read(&lfs->state) == OTX2_CPTLF_STARTED;
+}
+
 int otx2_cptlf_init(struct otx2_cptlfs_info *lfs, u8 eng_grp_msk, int pri,
 		    int lfs_num);
 void otx2_cptlf_shutdown(struct otx2_cptlfs_info *lfs);
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
index 73f0f0721a18..6798e42dfade 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
@@ -3,6 +3,7 @@
 
 #include "otx2_cpt_common.h"
 #include "otx2_cptvf.h"
+#include "otx2_cptlf.h"
 #include <rvu_reg.h>
 
 #define OTX2_CPTVF_DRV_NAME "octeontx2-cptvf"
@@ -94,6 +95,193 @@ static void cptvf_pfvf_mbox_destroy(struct otx2_cptvf_dev *cptvf)
 	otx2_mbox_destroy(&cptvf->pfvf_mbox);
 }
 
+static void cptlf_work_handler(unsigned long data)
+{
+	otx2_cpt_post_process((struct otx2_cptlf_wqe *) data);
+}
+
+static void cleanup_tasklet_work(struct otx2_cptlfs_info *lfs)
+{
+	int i;
+
+	for (i = 0; i <  lfs->lfs_num; i++) {
+		if (!lfs->lf[i].wqe)
+			continue;
+
+		tasklet_kill(&lfs->lf[i].wqe->work);
+		kfree(lfs->lf[i].wqe);
+		lfs->lf[i].wqe = NULL;
+	}
+}
+
+static int init_tasklet_work(struct otx2_cptlfs_info *lfs)
+{
+	struct otx2_cptlf_wqe *wqe;
+	int i, ret = 0;
+
+	for (i = 0; i < lfs->lfs_num; i++) {
+		wqe = kzalloc(sizeof(struct otx2_cptlf_wqe), GFP_KERNEL);
+		if (!wqe) {
+			ret = -ENOMEM;
+			goto cleanup_tasklet;
+		}
+
+		tasklet_init(&wqe->work, cptlf_work_handler, (u64) wqe);
+		wqe->lfs = lfs;
+		wqe->lf_num = i;
+		lfs->lf[i].wqe = wqe;
+	}
+	return 0;
+cleanup_tasklet:
+	cleanup_tasklet_work(lfs);
+	return ret;
+}
+
+static void free_pending_queues(struct otx2_cptlfs_info *lfs)
+{
+	int i;
+
+	for (i = 0; i < lfs->lfs_num; i++) {
+		kfree(lfs->lf[i].pqueue.head);
+		lfs->lf[i].pqueue.head = NULL;
+	}
+}
+
+static int alloc_pending_queues(struct otx2_cptlfs_info *lfs)
+{
+	int size, ret, i;
+
+	if (!lfs->lfs_num)
+		return -EINVAL;
+
+	for (i = 0; i < lfs->lfs_num; i++) {
+		lfs->lf[i].pqueue.qlen = OTX2_CPT_INST_QLEN_MSGS;
+		size = lfs->lf[i].pqueue.qlen *
+		       sizeof(struct otx2_cpt_pending_entry);
+
+		lfs->lf[i].pqueue.head = kzalloc(size, GFP_KERNEL);
+		if (!lfs->lf[i].pqueue.head) {
+			ret = -ENOMEM;
+			goto error;
+		}
+
+		/* Initialize spin lock */
+		spin_lock_init(&lfs->lf[i].pqueue.lock);
+	}
+	return 0;
+error:
+	free_pending_queues(lfs);
+	return ret;
+}
+
+static void lf_sw_cleanup(struct otx2_cptlfs_info *lfs)
+{
+	cleanup_tasklet_work(lfs);
+	free_pending_queues(lfs);
+}
+
+static int lf_sw_init(struct otx2_cptlfs_info *lfs)
+{
+	int ret;
+
+	ret = alloc_pending_queues(lfs);
+	if (ret) {
+		dev_err(&lfs->pdev->dev,
+			"Allocating pending queues failed\n");
+		return ret;
+	}
+	ret = init_tasklet_work(lfs);
+	if (ret) {
+		dev_err(&lfs->pdev->dev,
+			"Tasklet work init failed\n");
+		goto pending_queues_free;
+	}
+	return 0;
+
+pending_queues_free:
+	free_pending_queues(lfs);
+	return ret;
+}
+
+static void cptvf_lf_shutdown(struct otx2_cptlfs_info *lfs)
+{
+	atomic_set(&lfs->state, OTX2_CPTLF_IN_RESET);
+
+	/* Remove interrupts affinity */
+	otx2_cptlf_free_irqs_affinity(lfs);
+	/* Disable instruction queue */
+	otx2_cptlf_disable_iqueues(lfs);
+	/* Unregister LFs interrupts */
+	otx2_cptlf_unregister_interrupts(lfs);
+	/* Cleanup LFs software side */
+	lf_sw_cleanup(lfs);
+	/* Send request to detach LFs */
+	otx2_cpt_detach_rsrcs_msg(lfs);
+}
+
+static int cptvf_lf_init(struct otx2_cptvf_dev *cptvf)
+{
+	struct otx2_cptlfs_info *lfs = &cptvf->lfs;
+	struct device *dev = &cptvf->pdev->dev;
+	int ret, lfs_num;
+	u8 eng_grp_msk;
+
+	/* Get engine group number for symmetric crypto */
+	cptvf->lfs.kcrypto_eng_grp_num = OTX2_CPT_INVALID_CRYPTO_ENG_GRP;
+	ret = otx2_cptvf_send_eng_grp_num_msg(cptvf, OTX2_CPT_SE_TYPES);
+	if (ret)
+		return ret;
+
+	if (cptvf->lfs.kcrypto_eng_grp_num == OTX2_CPT_INVALID_CRYPTO_ENG_GRP) {
+		dev_err(dev, "Engine group for kernel crypto not available\n");
+		ret = -ENOENT;
+		return ret;
+	}
+	eng_grp_msk = 1 << cptvf->lfs.kcrypto_eng_grp_num;
+
+	lfs->reg_base = cptvf->reg_base;
+	lfs->pdev = cptvf->pdev;
+	lfs->mbox = &cptvf->pfvf_mbox;
+
+	lfs_num = num_online_cpus();
+	ret = otx2_cptlf_init(lfs, eng_grp_msk, OTX2_CPT_QUEUE_HI_PRIO,
+			      lfs_num);
+	if (ret)
+		return ret;
+
+	/* Get msix offsets for attached LFs */
+	ret = otx2_cpt_msix_offset_msg(lfs);
+	if (ret)
+		goto cleanup_lf;
+
+	/* Initialize LFs software side */
+	ret = lf_sw_init(lfs);
+	if (ret)
+		goto cleanup_lf;
+
+	/* Register LFs interrupts */
+	ret = otx2_cptlf_register_interrupts(lfs);
+	if (ret)
+		goto cleanup_lf_sw;
+
+	/* Set interrupts affinity */
+	ret = otx2_cptlf_set_irqs_affinity(lfs);
+	if (ret)
+		goto unregister_intr;
+
+	atomic_set(&lfs->state, OTX2_CPTLF_STARTED);
+
+	return 0;
+unregister_intr:
+	otx2_cptlf_unregister_interrupts(lfs);
+cleanup_lf_sw:
+	lf_sw_cleanup(lfs);
+cleanup_lf:
+	otx2_cptlf_shutdown(lfs);
+
+	return ret;
+}
+
 static int otx2_cptvf_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *ent)
 {
@@ -156,7 +344,14 @@ static int otx2_cptvf_probe(struct pci_dev *pdev,
 	if (ret)
 		goto destroy_pfvf_mbox;
 
+	/* Initialize CPT LFs */
+	ret = cptvf_lf_init(cptvf);
+	if (ret)
+		goto unregister_interrupts;
+
 	return 0;
+unregister_interrupts:
+	cptvf_disable_pfvf_mbox_intrs(cptvf);
 destroy_pfvf_mbox:
 	cptvf_pfvf_mbox_destroy(cptvf);
 clear_drvdata:
@@ -173,6 +368,7 @@ static void otx2_cptvf_remove(struct pci_dev *pdev)
 		dev_err(&pdev->dev, "Invalid CPT VF device.\n");
 		return;
 	}
+	cptvf_lf_shutdown(&cptvf->lfs);
 	/* Disable PF-VF mailbox interrupt */
 	cptvf_disable_pfvf_mbox_intrs(cptvf);
 	/* Destroy PF-VF mbox */
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
index 417099a86742..092a5ab18417 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_mbox.c
@@ -28,6 +28,7 @@ static void process_pfvf_mbox_mbox_msg(struct otx2_cptvf_dev *cptvf,
 				       struct mbox_msghdr *msg)
 {
 	struct otx2_cptlfs_info *lfs = &cptvf->lfs;
+	struct otx2_cpt_egrp_num_rsp *rsp_grp;
 	struct cpt_rd_wr_reg_msg *rsp_reg;
 	struct msix_offset_rsp *rsp_msix;
 	int i;
@@ -75,6 +76,10 @@ static void process_pfvf_mbox_mbox_msg(struct otx2_cptvf_dev *cptvf,
 		if (!rsp_reg->is_write)
 			*rsp_reg->ret_val = rsp_reg->val;
 		break;
+	case MBOX_MSG_GET_ENG_GRP_NUM:
+		rsp_grp = (struct otx2_cpt_egrp_num_rsp *) msg;
+		cptvf->lfs.kcrypto_eng_grp_num = rsp_grp->eng_grp_num;
+		break;
 	default:
 		dev_err(&cptvf->pdev->dev, "Unsupported msg %d received.\n",
 			msg->id);
@@ -111,3 +116,24 @@ void otx2_cptvf_pfvf_mbox_handler(struct work_struct *work)
 	}
 	otx2_mbox_reset(pfvf_mbox, 0);
 }
+
+int otx2_cptvf_send_eng_grp_num_msg(struct otx2_cptvf_dev *cptvf, int eng_type)
+{
+	struct otx2_mbox *mbox = &cptvf->pfvf_mbox;
+	struct pci_dev *pdev = cptvf->pdev;
+	struct otx2_cpt_egrp_num_msg *req;
+
+	req = (struct otx2_cpt_egrp_num_msg *)
+	      otx2_mbox_alloc_msg_rsp(mbox, 0, sizeof(*req),
+				      sizeof(struct otx2_cpt_egrp_num_rsp));
+	if (req == NULL) {
+		dev_err(&pdev->dev, "RVU MBOX failed to get message.\n");
+		return -EFAULT;
+	}
+	req->hdr.id = MBOX_MSG_GET_ENG_GRP_NUM;
+	req->hdr.sig = OTX2_MBOX_REQ_SIG;
+	req->hdr.pcifunc = OTX2_CPT_RVU_PFFUNC(cptvf->vf_id, 0);
+	req->eng_type = eng_type;
+
+	return otx2_cpt_send_mbox_msg(mbox, pdev);
+}
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
new file mode 100644
index 000000000000..05fd59082b5a
--- /dev/null
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c
@@ -0,0 +1,532 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2020 Marvell. */
+
+#include "otx2_cptvf.h"
+#include "otx2_cpt_common.h"
+
+/* SG list header size in bytes */
+#define SG_LIST_HDR_SIZE	8
+
+/* Default timeout when waiting for free pending entry in us */
+#define CPT_PENTRY_TIMEOUT	1000
+#define CPT_PENTRY_STEP		50
+
+/* Default threshold for stopping and resuming sender requests */
+#define CPT_IQ_STOP_MARGIN	128
+#define CPT_IQ_RESUME_MARGIN	512
+
+/* Default command timeout in seconds */
+#define CPT_COMMAND_TIMEOUT	4
+#define CPT_TIME_IN_RESET_COUNT 5
+
+static void otx2_cpt_dump_sg_list(struct pci_dev *pdev,
+				  struct otx2_cpt_req_info *req)
+{
+	int i;
+
+	pr_debug("Gather list size %d\n", req->in_cnt);
+	for (i = 0; i < req->in_cnt; i++) {
+		pr_debug("Buffer %d size %d, vptr 0x%p, dmaptr 0x%p\n", i,
+			 req->in[i].size, req->in[i].vptr,
+			 (void *) req->in[i].dma_addr);
+		pr_debug("Buffer hexdump (%d bytes)\n",
+			 req->in[i].size);
+		print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1,
+				     req->in[i].vptr, req->in[i].size, false);
+	}
+	pr_debug("Scatter list size %d\n", req->out_cnt);
+	for (i = 0; i < req->out_cnt; i++) {
+		pr_debug("Buffer %d size %d, vptr 0x%p, dmaptr 0x%p\n", i,
+			 req->out[i].size, req->out[i].vptr,
+			 (void *) req->out[i].dma_addr);
+		pr_debug("Buffer hexdump (%d bytes)\n", req->out[i].size);
+		print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1,
+				     req->out[i].vptr, req->out[i].size, false);
+	}
+}
+
+static inline struct otx2_cpt_pending_entry *get_free_pending_entry(
+					struct otx2_cpt_pending_queue *q,
+					int qlen)
+{
+	struct otx2_cpt_pending_entry *ent = NULL;
+
+	ent = &q->head[q->rear];
+	if (unlikely(ent->busy))
+		return NULL;
+
+	q->rear++;
+	if (unlikely(q->rear == qlen))
+		q->rear = 0;
+
+	return ent;
+}
+
+static inline u32 modulo_inc(u32 index, u32 length, u32 inc)
+{
+	if (WARN_ON(inc > length))
+		inc = length;
+
+	index += inc;
+	if (unlikely(index >= length))
+		index -= length;
+
+	return index;
+}
+
+static inline void free_pentry(struct otx2_cpt_pending_entry *pentry)
+{
+	pentry->completion_addr = NULL;
+	pentry->info = NULL;
+	pentry->callback = NULL;
+	pentry->areq = NULL;
+	pentry->resume_sender = false;
+	pentry->busy = false;
+}
+
+static inline int setup_sgio_components(struct pci_dev *pdev,
+					struct otx2_cpt_buf_ptr *list,
+					int buf_count, u8 *buffer)
+{
+	struct otx2_cpt_sglist_component *sg_ptr = NULL;
+	int ret = 0, i, j;
+	int components;
+
+	if (unlikely(!list)) {
+		dev_err(&pdev->dev, "Input list pointer is NULL\n");
+		return -EFAULT;
+	}
+
+	for (i = 0; i < buf_count; i++) {
+		if (unlikely(!list[i].vptr))
+			continue;
+		list[i].dma_addr = dma_map_single(&pdev->dev, list[i].vptr,
+						  list[i].size,
+						  DMA_BIDIRECTIONAL);
+		if (unlikely(dma_mapping_error(&pdev->dev, list[i].dma_addr))) {
+			dev_err(&pdev->dev, "Dma mapping failed\n");
+			ret = -EIO;
+			goto sg_cleanup;
+		}
+	}
+	components = buf_count / 4;
+	sg_ptr = (struct otx2_cpt_sglist_component *)buffer;
+	for (i = 0; i < components; i++) {
+		sg_ptr->len0 = cpu_to_be16(list[i * 4 + 0].size);
+		sg_ptr->len1 = cpu_to_be16(list[i * 4 + 1].size);
+		sg_ptr->len2 = cpu_to_be16(list[i * 4 + 2].size);
+		sg_ptr->len3 = cpu_to_be16(list[i * 4 + 3].size);
+		sg_ptr->ptr0 = cpu_to_be64(list[i * 4 + 0].dma_addr);
+		sg_ptr->ptr1 = cpu_to_be64(list[i * 4 + 1].dma_addr);
+		sg_ptr->ptr2 = cpu_to_be64(list[i * 4 + 2].dma_addr);
+		sg_ptr->ptr3 = cpu_to_be64(list[i * 4 + 3].dma_addr);
+		sg_ptr++;
+	}
+	components = buf_count % 4;
+
+	switch (components) {
+	case 3:
+		sg_ptr->len2 = cpu_to_be16(list[i * 4 + 2].size);
+		sg_ptr->ptr2 = cpu_to_be64(list[i * 4 + 2].dma_addr);
+		fallthrough;
+	case 2:
+		sg_ptr->len1 = cpu_to_be16(list[i * 4 + 1].size);
+		sg_ptr->ptr1 = cpu_to_be64(list[i * 4 + 1].dma_addr);
+		fallthrough;
+	case 1:
+		sg_ptr->len0 = cpu_to_be16(list[i * 4 + 0].size);
+		sg_ptr->ptr0 = cpu_to_be64(list[i * 4 + 0].dma_addr);
+		break;
+	default:
+		break;
+	}
+	return ret;
+
+sg_cleanup:
+	for (j = 0; j < i; j++) {
+		if (list[j].dma_addr) {
+			dma_unmap_single(&pdev->dev, list[j].dma_addr,
+					 list[j].size, DMA_BIDIRECTIONAL);
+		}
+
+		list[j].dma_addr = 0;
+	}
+	return ret;
+}
+
+static inline struct otx2_cpt_inst_info *info_create(struct pci_dev *pdev,
+					      struct otx2_cpt_req_info *req,
+					      gfp_t gfp)
+{
+	int align = OTX2_CPT_DMA_MINALIGN;
+	struct otx2_cpt_inst_info *info;
+	u32 dlen, align_dlen, info_len;
+	u16 g_sz_bytes, s_sz_bytes;
+	u32 total_mem_len;
+
+	if (unlikely(req->in_cnt > OTX2_CPT_MAX_SG_IN_CNT ||
+		     req->out_cnt > OTX2_CPT_MAX_SG_OUT_CNT)) {
+		dev_err(&pdev->dev, "Error too many sg components\n");
+		return NULL;
+	}
+
+	g_sz_bytes = ((req->in_cnt + 3) / 4) *
+		      sizeof(struct otx2_cpt_sglist_component);
+	s_sz_bytes = ((req->out_cnt + 3) / 4) *
+		      sizeof(struct otx2_cpt_sglist_component);
+
+	dlen = g_sz_bytes + s_sz_bytes + SG_LIST_HDR_SIZE;
+	align_dlen = ALIGN(dlen, align);
+	info_len = ALIGN(sizeof(*info), align);
+	total_mem_len = align_dlen + info_len + sizeof(union otx2_cpt_res_s);
+
+	info = kzalloc(total_mem_len, gfp);
+	if (unlikely(!info))
+		return NULL;
+
+	info->dlen = dlen;
+	info->in_buffer = (u8 *)info + info_len;
+
+	((u16 *)info->in_buffer)[0] = req->out_cnt;
+	((u16 *)info->in_buffer)[1] = req->in_cnt;
+	((u16 *)info->in_buffer)[2] = 0;
+	((u16 *)info->in_buffer)[3] = 0;
+	cpu_to_be64s((u64 *)info->in_buffer);
+
+	/* Setup gather (input) components */
+	if (setup_sgio_components(pdev, req->in, req->in_cnt,
+				  &info->in_buffer[8])) {
+		dev_err(&pdev->dev, "Failed to setup gather list\n");
+		goto destroy_info;
+	}
+
+	if (setup_sgio_components(pdev, req->out, req->out_cnt,
+				  &info->in_buffer[8 + g_sz_bytes])) {
+		dev_err(&pdev->dev, "Failed to setup scatter list\n");
+		goto destroy_info;
+	}
+
+	info->dma_len = total_mem_len - info_len;
+	info->dptr_baddr = dma_map_single(&pdev->dev, info->in_buffer,
+					  info->dma_len, DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(&pdev->dev, info->dptr_baddr))) {
+		dev_err(&pdev->dev, "DMA Mapping failed for cpt req\n");
+		goto destroy_info;
+	}
+	/*
+	 * Get buffer for union otx2_cpt_res_s response
+	 * structure and its physical address
+	 */
+	info->completion_addr = info->in_buffer + align_dlen;
+	info->comp_baddr = info->dptr_baddr + align_dlen;
+
+	return info;
+destroy_info:
+	otx2_cpt_info_destroy(pdev, info);
+	return NULL;
+}
+
+static int process_request(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
+			   struct otx2_cpt_pending_queue *pqueue,
+			   struct otx2_cptlf_info *lf)
+{
+	struct otx2_cptvf_request *cpt_req = &req->req;
+	struct otx2_cpt_pending_entry *pentry = NULL;
+	union otx2_cpt_ctrl_info *ctrl = &req->ctrl;
+	struct otx2_cpt_inst_info *info = NULL;
+	union otx2_cpt_res_s *result = NULL;
+	struct otx2_cpt_iq_command iq_cmd;
+	union otx2_cpt_inst_s cptinst;
+	int retry, ret = 0;
+	u8 resume_sender;
+	gfp_t gfp;
+
+	gfp = (req->areq->flags & CRYPTO_TFM_REQ_MAY_SLEEP) ? GFP_KERNEL :
+							      GFP_ATOMIC;
+	if (unlikely(!otx2_cptlf_started(lf->lfs)))
+		return -ENODEV;
+
+	info = info_create(pdev, req, gfp);
+	if (unlikely(!info)) {
+		dev_err(&pdev->dev, "Setting up cpt inst info failed");
+		return -ENOMEM;
+	}
+	cpt_req->dlen = info->dlen;
+
+	result = info->completion_addr;
+	result->s.compcode = OTX2_CPT_COMPLETION_CODE_INIT;
+
+	spin_lock_bh(&pqueue->lock);
+	pentry = get_free_pending_entry(pqueue, pqueue->qlen);
+	retry = CPT_PENTRY_TIMEOUT / CPT_PENTRY_STEP;
+	while (unlikely(!pentry) && retry--) {
+		spin_unlock_bh(&pqueue->lock);
+		udelay(CPT_PENTRY_STEP);
+		spin_lock_bh(&pqueue->lock);
+		pentry = get_free_pending_entry(pqueue, pqueue->qlen);
+	}
+
+	if (unlikely(!pentry)) {
+		ret = -ENOSPC;
+		goto destroy_info;
+	}
+
+	/*
+	 * Check if we are close to filling in entire pending queue,
+	 * if so then tell the sender to stop/sleep by returning -EBUSY
+	 * We do it only for context which can sleep (GFP_KERNEL)
+	 */
+	if (gfp == GFP_KERNEL &&
+	    pqueue->pending_count > (pqueue->qlen - CPT_IQ_STOP_MARGIN)) {
+		pentry->resume_sender = true;
+	} else
+		pentry->resume_sender = false;
+	resume_sender = pentry->resume_sender;
+	pqueue->pending_count++;
+
+	pentry->completion_addr = info->completion_addr;
+	pentry->info = info;
+	pentry->callback = req->callback;
+	pentry->areq = req->areq;
+	pentry->busy = true;
+	info->pentry = pentry;
+	info->time_in = jiffies;
+	info->req = req;
+
+	/* Fill in the command */
+	iq_cmd.cmd.u = 0;
+	iq_cmd.cmd.s.opcode = cpu_to_be16(cpt_req->opcode.flags);
+	iq_cmd.cmd.s.param1 = cpu_to_be16(cpt_req->param1);
+	iq_cmd.cmd.s.param2 = cpu_to_be16(cpt_req->param2);
+	iq_cmd.cmd.s.dlen   = cpu_to_be16(cpt_req->dlen);
+
+	/* 64-bit swap for microcode data reads, not needed for addresses*/
+	cpu_to_be64s(&iq_cmd.cmd.u);
+	iq_cmd.dptr = info->dptr_baddr;
+	iq_cmd.rptr = 0;
+	iq_cmd.cptr.u = 0;
+	iq_cmd.cptr.s.grp = ctrl->s.grp;
+
+	/* Fill in the CPT_INST_S type command for HW interpretation */
+	otx2_cpt_fill_inst(&cptinst, &iq_cmd, info->comp_baddr);
+
+	/* Print debug info if enabled */
+	otx2_cpt_dump_sg_list(pdev, req);
+	pr_debug("Cpt_inst_s hexdump (%d bytes)\n", OTX2_CPT_INST_SIZE);
+	print_hex_dump_debug("", 0, 16, 1, &cptinst, OTX2_CPT_INST_SIZE, false);
+	pr_debug("Dptr hexdump (%d bytes)\n", cpt_req->dlen);
+	print_hex_dump_debug("", 0, 16, 1, info->in_buffer,
+			     cpt_req->dlen, false);
+
+	/* Send CPT command */
+	otx2_cpt_send_cmd(&cptinst, 1, lf);
+
+	/*
+	 * We allocate and prepare pending queue entry in critical section
+	 * together with submitting CPT instruction to CPT instruction queue
+	 * to make sure that order of CPT requests is the same in both
+	 * pending and instruction queues
+	 */
+	spin_unlock_bh(&pqueue->lock);
+
+	ret = resume_sender ? -EBUSY : -EINPROGRESS;
+	return ret;
+destroy_info:
+	spin_unlock_bh(&pqueue->lock);
+	otx2_cpt_info_destroy(pdev, info);
+	return ret;
+}
+
+int otx2_cpt_do_request(struct pci_dev *pdev, struct otx2_cpt_req_info *req,
+			int cpu_num)
+{
+	struct otx2_cptvf_dev *cptvf = pci_get_drvdata(pdev);
+	struct otx2_cptlfs_info *lfs = &cptvf->lfs;
+
+	return process_request(lfs->pdev, req, &lfs->lf[cpu_num].pqueue,
+			       &lfs->lf[cpu_num]);
+}
+
+static int cpt_process_ccode(struct pci_dev *pdev,
+			     union otx2_cpt_res_s *cpt_status,
+			     struct otx2_cpt_inst_info *info,
+			     u32 *res_code)
+{
+	u8 uc_ccode = cpt_status->s.uc_compcode;
+	u8 ccode = cpt_status->s.compcode;
+
+	switch (ccode) {
+	case OTX2_CPT_COMP_E_FAULT:
+		dev_err(&pdev->dev,
+			"Request failed with DMA fault\n");
+		otx2_cpt_dump_sg_list(pdev, info->req);
+		break;
+
+	case OTX2_CPT_COMP_E_HWERR:
+		dev_err(&pdev->dev,
+			"Request failed with hardware error\n");
+		otx2_cpt_dump_sg_list(pdev, info->req);
+		break;
+
+	case OTX2_CPT_COMP_E_INSTERR:
+		dev_err(&pdev->dev,
+			"Request failed with instruction error\n");
+		otx2_cpt_dump_sg_list(pdev, info->req);
+		break;
+
+	case OTX2_CPT_COMP_E_NOTDONE:
+		/* check for timeout */
+		if (time_after_eq(jiffies, info->time_in +
+				  CPT_COMMAND_TIMEOUT * HZ))
+			dev_warn(&pdev->dev,
+				 "Request timed out 0x%p", info->req);
+		else if (info->extra_time < CPT_TIME_IN_RESET_COUNT) {
+			info->time_in = jiffies;
+			info->extra_time++;
+		}
+		return 1;
+
+	case OTX2_CPT_COMP_E_GOOD:
+		/*
+		 * Check microcode completion code, it is only valid
+		 * when completion code is CPT_COMP_E::GOOD
+		 */
+		if (uc_ccode != OTX2_CPT_UCC_SUCCESS) {
+			/*
+			 * If requested hmac is truncated and ucode returns
+			 * s/g write length error then we report success
+			 * because ucode writes as many bytes of calculated
+			 * hmac as available in gather buffer and reports
+			 * s/g write length error if number of bytes in gather
+			 * buffer is less than full hmac size.
+			 */
+			if (info->req->is_trunc_hmac &&
+			    uc_ccode == OTX2_CPT_UCC_SG_WRITE_LENGTH) {
+				*res_code = 0;
+				break;
+			}
+
+			dev_err(&pdev->dev,
+				"Request failed with software error code 0x%x\n",
+				cpt_status->s.uc_compcode);
+			otx2_cpt_dump_sg_list(pdev, info->req);
+			break;
+		}
+		/* Request has been processed with success */
+		*res_code = 0;
+		break;
+
+	default:
+		dev_err(&pdev->dev,
+			"Request returned invalid status %d\n", ccode);
+		break;
+	}
+	return 0;
+}
+
+static inline void process_pending_queue(struct pci_dev *pdev,
+					 struct otx2_cpt_pending_queue *pqueue)
+{
+	struct otx2_cpt_pending_entry *resume_pentry = NULL;
+	void (*callback)(int status, void *arg, void *req);
+	struct otx2_cpt_pending_entry *pentry = NULL;
+	union otx2_cpt_res_s *cpt_status = NULL;
+	struct otx2_cpt_inst_info *info = NULL;
+	struct otx2_cpt_req_info *req = NULL;
+	struct crypto_async_request *areq;
+	u32 res_code, resume_index;
+
+	while (1) {
+		spin_lock_bh(&pqueue->lock);
+		pentry = &pqueue->head[pqueue->front];
+
+		if (WARN_ON(!pentry)) {
+			spin_unlock_bh(&pqueue->lock);
+			break;
+		}
+
+		res_code = -EINVAL;
+		if (unlikely(!pentry->busy)) {
+			spin_unlock_bh(&pqueue->lock);
+			break;
+		}
+
+		if (unlikely(!pentry->callback)) {
+			dev_err(&pdev->dev, "Callback NULL\n");
+			goto process_pentry;
+		}
+
+		info = pentry->info;
+		if (unlikely(!info)) {
+			dev_err(&pdev->dev, "Pending entry post arg NULL\n");
+			goto process_pentry;
+		}
+
+		req = info->req;
+		if (unlikely(!req)) {
+			dev_err(&pdev->dev, "Request NULL\n");
+			goto process_pentry;
+		}
+
+		cpt_status = pentry->completion_addr;
+		if (unlikely(!cpt_status)) {
+			dev_err(&pdev->dev, "Completion address NULL\n");
+			goto process_pentry;
+		}
+
+		if (cpt_process_ccode(pdev, cpt_status, info, &res_code)) {
+			spin_unlock_bh(&pqueue->lock);
+			return;
+		}
+		info->pdev = pdev;
+
+process_pentry:
+		/*
+		 * Check if we should inform sending side to resume
+		 * We do it CPT_IQ_RESUME_MARGIN elements in advance before
+		 * pending queue becomes empty
+		 */
+		resume_index = modulo_inc(pqueue->front, pqueue->qlen,
+					  CPT_IQ_RESUME_MARGIN);
+		resume_pentry = &pqueue->head[resume_index];
+		if (resume_pentry &&
+		    resume_pentry->resume_sender) {
+			resume_pentry->resume_sender = false;
+			callback = resume_pentry->callback;
+			areq = resume_pentry->areq;
+
+			if (callback) {
+				spin_unlock_bh(&pqueue->lock);
+
+				/*
+				 * EINPROGRESS is an indication for sending
+				 * side that it can resume sending requests
+				 */
+				callback(-EINPROGRESS, areq, info);
+				spin_lock_bh(&pqueue->lock);
+			}
+		}
+
+		callback = pentry->callback;
+		areq = pentry->areq;
+		free_pentry(pentry);
+
+		pqueue->pending_count--;
+		pqueue->front = modulo_inc(pqueue->front, pqueue->qlen, 1);
+		spin_unlock_bh(&pqueue->lock);
+
+		/*
+		 * Call callback after current pending entry has been
+		 * processed, we don't do it if the callback pointer is
+		 * invalid.
+		 */
+		if (callback)
+			callback(res_code, areq, info);
+	}
+}
+
+void otx2_cpt_post_process(struct otx2_cptlf_wqe *wqe)
+{
+	process_pending_queue(wqe->lfs->pdev,
+			      &wqe->lfs->lf[wqe->lf_num].pqueue);
+}
-- 
2.28.0

