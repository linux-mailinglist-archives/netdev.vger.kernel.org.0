Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9F9214A477
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgA0NGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:06:02 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38778 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgA0NGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:06:02 -0500
Received: by mail-pl1-f193.google.com with SMTP id t6so3739336plj.5
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 05:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1Va5HGcEEI+wJRTYxbIJfdMpYS03cBHfI5W2HSdNmNk=;
        b=q4FtI0DHd1gg4rO3M2+fetbDrNAtc0PU/foOUItZgib4qsMK/OvvTY9PTDLn/IzDlH
         GmISFeSWNlM7KtgeSqrrqd5wTtscI6CXwO2MSBATdrAAFDqajNz/9FpJ3xgTsK6X9XDp
         joE2cfRcA9H/t8W8Fl1UkbCUDu6knNidtjJrx2Vbu6y/0c026JUMBvHRgdPYF2Ix1Ehr
         /xKjP5onWDsJm6FZI8A5Rl1p8jm96Kd/1wM6mnmAafyVTJWhpXOoD/+p2q32crbSbf2C
         IRXVQQVX3e1/6gN9UCyUhza1LmXCC8spd31hoyes0wQvKht8cjymUQKUDCIKLf6+/uDP
         iaww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1Va5HGcEEI+wJRTYxbIJfdMpYS03cBHfI5W2HSdNmNk=;
        b=mxd3KUOsOcLLXo7nyrZg624PwBlQYa47AuqcJDZynrudxdqOkAXQNOwqbgBADqznxA
         QrSzkvTVCSoPhelq8DksTzXmW6eoMBnSCbvsno717CvW1rGABB8ng5sflZrv3poY1DFv
         L+i1NTnj+taaoSyJz7e/OLHOeKfXA2g0wVBlJGNDh7K2aRBen76y3JuUpKYqIHePc8Qj
         5v+7XI8cHVIZtFx+gKp+dGNBdAgf4j4s5HKjega0WlZPmHI5dO3O34qh/OXYhruN2AXQ
         kpzutdt/9UeRauYwJ/rhpgROX+WkKM3xgNeKZMocUMaO0Aj5iOVNsF3mNIRhaj49bGcC
         ymcw==
X-Gm-Message-State: APjAAAXellwnCs9W5liNTyso/FyCX46appD+1BfngpOEc2kTBStbi0ws
        UPuNUFRQTlPHFQ4BZ8pskWD14W5sYK0=
X-Google-Smtp-Source: APXvYqwTcS4o37XpOU8+f16+7obK3lXlsJvpwG3cGFZ+ATftN5V5T3amRjLt3bNcpqzuajM6RNGpPA==
X-Received: by 2002:a17:90a:1f8c:: with SMTP id x12mr2690683pja.27.1580130360704;
        Mon, 27 Jan 2020 05:06:00 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id c15sm17241717pja.30.2020.01.27.05.05.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 Jan 2020 05:06:00 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        maciej.fijalkowski@intel.com, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v6 05/17] octeontx2-pf: Setup interrupts and NAPI handler
Date:   Mon, 27 Jan 2020 18:35:19 +0530
Message-Id: <1580130331-8964-6-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580130331-8964-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1580130331-8964-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Completion queue (CQ) is the one with which HW notifies SW on a packet
reception or transmission. Each of the RQ and SQ are mapped to a unique
CQ and again both CQs are mapped to same interrupt ie the CINT. So that
each core has one interrupt source in whose handler both Rx and Tx
notifications are processed.

Also
- Registered a NAPI handler for the CINT.
- Setup coalescing parameters.
- IRQ affinity hints etc

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |   2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  55 +++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  54 +++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 125 ++++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  68 +++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |  38 ++++++-
 6 files changed, 332 insertions(+), 10 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
index 339fde8..0484d70 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/Makefile
@@ -5,6 +5,6 @@
 
 obj-$(CONFIG_OCTEONTX2_PF) += octeontx2_nicpf.o
 
-octeontx2_nicpf-y := otx2_pf.o otx2_common.o
+octeontx2_nicpf-y := otx2_pf.o otx2_common.o otx2_txrx.o
 
 ccflags-y += -I$(srctree)/drivers/net/ethernet/marvell/octeontx2/af
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 3ebbf04..8f7b2cf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -15,6 +15,20 @@
 #include "otx2_common.h"
 #include "otx2_struct.h"
 
+void otx2_config_irq_coalescing(struct otx2_nic *pfvf, int qidx)
+{
+	/* Configure CQE interrupt coalescing parameters
+	 *
+	 * HW triggers an irq when ECOUNT > cq_ecount_wait, hence
+	 * set 1 less than cq_ecount_wait. And cq_time_wait is in
+	 * usecs, convert that to 100ns count.
+	 */
+	otx2_write64(pfvf, NIX_LF_CINTX_WAIT(qidx),
+		     ((u64)(pfvf->hw.cq_time_wait * 10) << 48) |
+		     ((u64)pfvf->hw.cq_qcount_wait << 32) |
+		     (pfvf->hw.cq_ecount_wait - 1));
+}
+
 dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
 			   gfp_t gfp)
 {
@@ -904,6 +918,47 @@ void mbox_handler_msix_offset(struct otx2_nic *pfvf,
 	pfvf->hw.nix_msixoff = rsp->nix_msixoff;
 }
 
+void otx2_free_cints(struct otx2_nic *pfvf, int n)
+{
+	struct otx2_qset *qset = &pfvf->qset;
+	struct otx2_hw *hw = &pfvf->hw;
+	int irq, qidx;
+
+	for (qidx = 0, irq = hw->nix_msixoff + NIX_LF_CINT_VEC_START;
+	     qidx < n;
+	     qidx++, irq++) {
+		int vector = pci_irq_vector(pfvf->pdev, irq);
+
+		irq_set_affinity_hint(vector, NULL);
+		free_cpumask_var(hw->affinity_mask[irq]);
+		free_irq(vector, &qset->napi[qidx]);
+	}
+}
+
+void otx2_set_cints_affinity(struct otx2_nic *pfvf)
+{
+	struct otx2_hw *hw = &pfvf->hw;
+	int vec, cpu, irq, cint;
+
+	vec = hw->nix_msixoff + NIX_LF_CINT_VEC_START;
+	cpu = cpumask_first(cpu_online_mask);
+
+	/* CQ interrupts */
+	for (cint = 0; cint < pfvf->hw.cint_cnt; cint++, vec++) {
+		if (!alloc_cpumask_var(&hw->affinity_mask[vec], GFP_KERNEL))
+			return;
+
+		cpumask_set_cpu(cpu, hw->affinity_mask[vec]);
+
+		irq = pci_irq_vector(pfvf->pdev, vec);
+		irq_set_affinity_hint(irq, hw->affinity_mask[vec]);
+
+		cpu = cpumask_next(cpu, cpu_online_mask);
+		if (unlikely(cpu >= nr_cpu_ids))
+			cpu = 0;
+	}
+}
+
 #define M(_name, _id, _fn_name, _req_type, _rsp_type)			\
 int __weak								\
 otx2_mbox_up_handler_ ## _fn_name(struct otx2_nic *pfvf,		\
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index a4f1c60..92e08f5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -21,6 +21,8 @@
 /* PCI device IDs */
 #define PCI_DEVID_OCTEONTX2_RVU_PF              0xA063
 
+#define PCI_SUBSYS_DEVID_96XX_RVU_PFVF		0xB200
+
 /* PCI BAR nos */
 #define PCI_CFG_REG_BAR_NUM                     2
 #define PCI_MBOX_BAR_NUM                        4
@@ -32,6 +34,13 @@ enum arua_mapped_qtypes {
 	AURA_NIX_SQ,
 };
 
+/* NIX LF interrupts range*/
+#define NIX_LF_QINT_VEC_START			0x00
+#define NIX_LF_CINT_VEC_START			0x40
+#define NIX_LF_GINT_VEC				0x80
+#define NIX_LF_ERR_VEC				0x81
+#define NIX_LF_POISON_VEC			0x82
+
 struct mbox {
 	struct otx2_mbox	mbox;
 	struct work_struct	mbox_wrk;
@@ -64,9 +73,13 @@ struct otx2_hw {
 	/* HW settings, coalescing etc */
 	u16			rx_chan_base;
 	u16			tx_chan_base;
+	u16			cq_qcount_wait;
+	u16			cq_ecount_wait;
 	u16			rq_skid;
+	u8			cq_time_wait;
 
 	/* MSI-X */
+	u8			cint_cnt; /* CQ interrupt count */
 	u16			npa_msixoff; /* Offset of NPA vectors */
 	u16			nix_msixoff; /* Offset of NIX vectors */
 	char			*irq_name;
@@ -94,6 +107,36 @@ struct otx2_nic {
 	int			nix_blkaddr;
 };
 
+static inline bool is_96xx_A0(struct pci_dev *pdev)
+{
+	return (pdev->revision == 0x00) &&
+		(pdev->subsystem_device == PCI_SUBSYS_DEVID_96XX_RVU_PFVF);
+}
+
+static inline bool is_96xx_B0(struct pci_dev *pdev)
+{
+	return (pdev->revision == 0x01) &&
+		(pdev->subsystem_device == PCI_SUBSYS_DEVID_96XX_RVU_PFVF);
+}
+
+static inline void otx2_setup_dev_hw_settings(struct otx2_nic *pfvf)
+{
+	pfvf->hw.cq_time_wait = CQ_TIMER_THRESH_DEFAULT;
+	pfvf->hw.cq_ecount_wait = CQ_CQE_THRESH_DEFAULT;
+	pfvf->hw.cq_qcount_wait = CQ_QCOUNT_DEFAULT;
+
+	if (is_96xx_A0(pfvf->pdev)) {
+		/* Time based irq coalescing is not supported */
+		pfvf->hw.cq_qcount_wait = 0x0;
+
+		/* Due to HW issue previous silicons required minimum
+		 * 600 unused CQE to avoid CQ overflow.
+		 */
+		pfvf->hw.rq_skid = 600;
+		pfvf->qset.rqe_cnt = Q_COUNT(Q_SIZE_1K);
+	}
+}
+
 /* Register read/write APIs */
 static inline void __iomem *otx2_get_regaddr(struct otx2_nic *nic, u64 offset)
 {
@@ -337,6 +380,11 @@ MBOX_UP_CGX_MESSAGES
 #define	RVU_PFVF_FUNC_SHIFT	0
 #define	RVU_PFVF_FUNC_MASK	0x3FF
 
+static inline int rvu_get_pf(u16 pcifunc)
+{
+	return (pcifunc >> RVU_PFVF_PF_SHIFT) & RVU_PFVF_PF_MASK;
+}
+
 static inline dma_addr_t otx2_dma_map_page(struct otx2_nic *pfvf,
 					   struct page *page,
 					   size_t offset, size_t size,
@@ -359,6 +407,12 @@ static inline void otx2_dma_unmap_page(struct otx2_nic *pfvf,
 			     dir, DMA_ATTR_SKIP_CPU_SYNC);
 }
 
+/* MSI-X APIs */
+void otx2_free_cints(struct otx2_nic *pfvf, int n);
+void otx2_set_cints_affinity(struct otx2_nic *pfvf);
+
+void otx2_config_irq_coalescing(struct otx2_nic *pfvf, int qidx);
+
 /* RVU block related APIs */
 int otx2_attach_npa_nix(struct otx2_nic *pfvf);
 int otx2_detach_resources(struct mbox *mbox);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 7351889..32c8bc4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -386,6 +386,38 @@ static int otx2_set_real_num_queues(struct net_device *netdev,
 	return err;
 }
 
+static irqreturn_t otx2_cq_intr_handler(int irq, void *cq_irq)
+{
+	struct otx2_cq_poll *cq_poll = (struct otx2_cq_poll *)cq_irq;
+	struct otx2_nic *pf = (struct otx2_nic *)cq_poll->dev;
+	int qidx = cq_poll->cint_idx;
+
+	/* Disable interrupts.
+	 *
+	 * Completion interrupts behave in a level-triggered interrupt
+	 * fashion, and hence have to be cleared only after it is serviced.
+	 */
+	otx2_write64(pf, NIX_LF_CINTX_ENA_W1C(qidx), BIT_ULL(0));
+
+	/* Schedule NAPI */
+	napi_schedule_irqoff(&cq_poll->napi);
+
+	return IRQ_HANDLED;
+}
+
+static void otx2_disable_napi(struct otx2_nic *pf)
+{
+	struct otx2_qset *qset = &pf->qset;
+	struct otx2_cq_poll *cq_poll;
+	int qidx;
+
+	for (qidx = 0; qidx < pf->hw.cint_cnt; qidx++) {
+		cq_poll = &qset->napi[qidx];
+		napi_disable(&cq_poll->napi);
+		netif_napi_del(&cq_poll->napi);
+	}
+}
+
 static void otx2_free_cq_res(struct otx2_nic *pf)
 {
 	struct otx2_qset *qset = &pf->qset;
@@ -564,12 +596,21 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
 static int otx2_open(struct net_device *netdev)
 {
 	struct otx2_nic *pf = netdev_priv(netdev);
+	struct otx2_cq_poll *cq_poll = NULL;
 	struct otx2_qset *qset = &pf->qset;
-	int err = 0;
+	int err = 0, qidx, vec;
+	char *irq_name;
 
 	netif_carrier_off(netdev);
 
 	pf->qset.cq_cnt = pf->hw.rx_queues + pf->hw.tx_queues;
+	/* RQ and SQs are mapped to different CQs,
+	 * so find out max CQ IRQs (i.e CINTs) needed.
+	 */
+	pf->hw.cint_cnt = max(pf->hw.rx_queues, pf->hw.tx_queues);
+	qset->napi = kcalloc(pf->hw.cint_cnt, sizeof(*cq_poll), GFP_KERNEL);
+	if (!qset->napi)
+		return -ENOMEM;
 
 	/* CQ size of RQ */
 	qset->rqe_cnt = qset->rqe_cnt ? qset->rqe_cnt : Q_COUNT(Q_SIZE_256);
@@ -591,23 +632,100 @@ static int otx2_open(struct net_device *netdev)
 	if (err)
 		goto err_free_mem;
 
+	/* Register NAPI handler */
+	for (qidx = 0; qidx < pf->hw.cint_cnt; qidx++) {
+		cq_poll = &qset->napi[qidx];
+		cq_poll->cint_idx = qidx;
+		/* RQ0 & SQ0 are mapped to CINT0 and so on..
+		 * 'cq_ids[0]' points to RQ's CQ and
+		 * 'cq_ids[1]' points to SQ's CQ and
+		 */
+		cq_poll->cq_ids[CQ_RX] =
+			(qidx <  pf->hw.rx_queues) ? qidx : CINT_INVALID_CQ;
+		cq_poll->cq_ids[CQ_TX] = (qidx < pf->hw.tx_queues) ?
+				      qidx + pf->hw.rx_queues : CINT_INVALID_CQ;
+		cq_poll->dev = (void *)pf;
+		netif_napi_add(netdev, &cq_poll->napi,
+			       otx2_napi_handler, NAPI_POLL_WEIGHT);
+		napi_enable(&cq_poll->napi);
+	}
+
+	/* Register CQ IRQ handlers */
+	vec = pf->hw.nix_msixoff + NIX_LF_CINT_VEC_START;
+	for (qidx = 0; qidx < pf->hw.cint_cnt; qidx++) {
+		irq_name = &pf->hw.irq_name[vec * NAME_SIZE];
+
+		snprintf(irq_name, NAME_SIZE, "%s-rxtx-%d", pf->netdev->name,
+			 qidx);
+
+		err = request_irq(pci_irq_vector(pf->pdev, vec),
+				  otx2_cq_intr_handler, 0, irq_name,
+				  &qset->napi[qidx]);
+		if (err) {
+			dev_err(pf->dev,
+				"RVUPF%d: IRQ registration failed for CQ%d\n",
+				rvu_get_pf(pf->pcifunc), qidx);
+			goto err_free_cints;
+		}
+		vec++;
+
+		otx2_config_irq_coalescing(pf, qidx);
+
+		/* Enable CQ IRQ */
+		otx2_write64(pf, NIX_LF_CINTX_INT(qidx), BIT_ULL(0));
+		otx2_write64(pf, NIX_LF_CINTX_ENA_W1S(qidx), BIT_ULL(0));
+	}
+
+	otx2_set_cints_affinity(pf);
+
 	return 0;
+
+err_free_cints:
+	otx2_free_cints(pf, qidx);
+	otx2_disable_napi(pf);
+	otx2_free_hw_resources(pf);
 err_free_mem:
 	kfree(qset->sq);
 	kfree(qset->cq);
+	kfree(qset->napi);
 	return err;
 }
 
 static int otx2_stop(struct net_device *netdev)
 {
 	struct otx2_nic *pf = netdev_priv(netdev);
+	struct otx2_cq_poll *cq_poll = NULL;
 	struct otx2_qset *qset = &pf->qset;
+	int qidx, vec;
+
+	netif_carrier_off(netdev);
+	netif_tx_stop_all_queues(netdev);
+
+	/* Cleanup CQ NAPI and IRQ */
+	vec = pf->hw.nix_msixoff + NIX_LF_CINT_VEC_START;
+	for (qidx = 0; qidx < pf->hw.cint_cnt; qidx++) {
+		/* Disable interrupt */
+		otx2_write64(pf, NIX_LF_CINTX_ENA_W1C(qidx), BIT_ULL(0));
+
+		synchronize_irq(pci_irq_vector(pf->pdev, vec));
+
+		cq_poll = &qset->napi[qidx];
+		napi_synchronize(&cq_poll->napi);
+		vec++;
+	}
+
+	netif_tx_disable(netdev);
 
 	otx2_free_hw_resources(pf);
+	otx2_free_cints(pf, pf->hw.cint_cnt);
+	otx2_disable_napi(pf);
+
+	for (qidx = 0; qidx < netdev->num_tx_queues; qidx++)
+		netdev_tx_reset_queue(netdev_get_tx_queue(netdev, qidx));
 
 	kfree(qset->sq);
 	kfree(qset->cq);
-
+	kfree(qset->napi);
 	/* Do not clear RQ/SQ ringsize settings */
 	memset((void *)qset + offsetof(struct otx2_qset, sqe_cnt), 0,
 	       sizeof(*qset) - offsetof(struct otx2_qset, sqe_cnt));
@@ -646,7 +764,6 @@ static int otx2_realloc_msix_vectors(struct otx2_nic *pf)
 	 * upto NIX vector offset.
 	 */
 	num_vec = hw->nix_msixoff;
-#define NIX_LF_CINT_VEC_START			0x40
 	num_vec += NIX_LF_CINT_VEC_START + hw->max_queues;
 
 	otx2_disable_mbox_intr(pf);
@@ -769,6 +886,8 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_detach_rsrc;
 
+	otx2_setup_dev_hw_settings(pf);
+
 	/* NPA's pool is a stack to which SW frees buffer pointers via Aura.
 	 * HW allocates buffer pointer from stack and uses it for DMA'ing
 	 * ingress packet. In some scenarios HW can free back allocated buffer
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
new file mode 100644
index 0000000..b07082e
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell OcteonTx2 RVU Ethernet driver
+ *
+ * Copyright (C) 2020 Marvell International Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/etherdevice.h>
+#include <net/ip.h>
+
+#include "otx2_reg.h"
+#include "otx2_common.h"
+#include "otx2_struct.h"
+#include "otx2_txrx.h"
+
+static int otx2_rx_napi_handler(struct otx2_nic *pfvf,
+				struct napi_struct *napi,
+				struct otx2_cq_queue *cq, int budget)
+{
+	 /* Nothing to do, for now */
+	return 0;
+}
+
+static int otx2_tx_napi_handler(struct otx2_nic *pfvf,
+				struct otx2_cq_queue *cq, int budget)
+{
+	 /* Nothing to do, for now */
+	return 0;
+}
+
+int otx2_napi_handler(struct napi_struct *napi, int budget)
+{
+	struct otx2_cq_poll *cq_poll;
+	int workdone = 0, cq_idx, i;
+	struct otx2_cq_queue *cq;
+	struct otx2_qset *qset;
+	struct otx2_nic *pfvf;
+
+	cq_poll = container_of(napi, struct otx2_cq_poll, napi);
+	pfvf = (struct otx2_nic *)cq_poll->dev;
+	qset = &pfvf->qset;
+
+	for (i = CQS_PER_CINT - 1; i >= 0; i--) {
+		cq_idx = cq_poll->cq_ids[i];
+		if (unlikely(cq_idx == CINT_INVALID_CQ))
+			continue;
+		cq = &qset->cq[cq_idx];
+		if (cq->cq_type == CQ_RX) {
+			workdone += otx2_rx_napi_handler(pfvf, napi,
+							 cq, budget);
+		} else {
+			workdone += otx2_tx_napi_handler(pfvf, cq, budget);
+		}
+	}
+
+	/* Clear the IRQ */
+	otx2_write64(pfvf, NIX_LF_CINTX_INT(cq_poll->cint_idx), BIT_ULL(0));
+
+	if (workdone < budget && napi_complete_done(napi, workdone)) {
+		/* Re-enable interrupts */
+		otx2_write64(pfvf, NIX_LF_CINTX_ENA_W1S(cq_poll->cint_idx),
+			     BIT_ULL(0));
+	}
+	return workdone;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index ce6efcf..a81bdc6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -37,6 +37,22 @@
 		((x) - OTX2_HEAD_ROOM - \
 		OTX2_DATA_ALIGN(sizeof(struct skb_shared_info)))
 
+/* IRQ triggered when NIX_LF_CINTX_CNT[ECOUNT]
+ * is equal to this value.
+ */
+#define CQ_CQE_THRESH_DEFAULT	10
+
+/* IRQ triggered when NIX_LF_CINTX_CNT[ECOUNT]
+ * is nonzero and this much time elapses after that.
+ */
+#define CQ_TIMER_THRESH_DEFAULT	1  /* 1 usec */
+#define CQ_TIMER_THRESH_MAX     25 /* 25 usec */
+
+/* Min number of CQs (of the ones mapped to this CINT)
+ * with valid CQEs.
+ */
+#define CQ_QCOUNT_DEFAULT	1
+
 struct otx2_snd_queue {
 	u8			aura_id;
 	u16			sqe_size;
@@ -52,6 +68,20 @@ struct otx2_snd_queue {
 	u64			*sqb_ptrs;
 } ____cacheline_aligned_in_smp;
 
+enum cq_type {
+	CQ_RX,
+	CQ_TX,
+	CQS_PER_CINT = 2, /* RQ + SQ */
+};
+
+struct otx2_cq_poll {
+	void			*dev;
+#define CINT_INVALID_CQ		255
+	u8			cint_idx;
+	u8			cq_ids[CQS_PER_CINT];
+	struct napi_struct	napi;
+};
+
 struct otx2_pool {
 	struct qmem		*stack;
 	struct qmem		*fc_addr;
@@ -62,12 +92,6 @@ struct otx2_pool {
 	struct page		*page;
 };
 
-enum cq_type {
-	CQ_RX,
-	CQ_TX,
-	CQS_PER_CINT = 2, /* RQ + SQ */
-};
-
 struct otx2_cq_queue {
 	u8			cq_idx;
 	u8			cq_type;
@@ -86,6 +110,7 @@ struct otx2_qset {
 	u16			cq_cnt;
 	u16			xqe_size;
 	struct otx2_pool	*pool;
+	struct otx2_cq_poll	*napi;
 	struct otx2_cq_queue	*cq;
 	struct otx2_snd_queue	*sq;
 };
@@ -99,4 +124,5 @@ static inline u64 otx2_iova_to_phys(void *iommu_domain, dma_addr_t dma_addr)
 	return dma_addr;
 }
 
+int otx2_napi_handler(struct napi_struct *napi, int budget);
 #endif /* OTX2_TXRX_H */
-- 
2.7.4

