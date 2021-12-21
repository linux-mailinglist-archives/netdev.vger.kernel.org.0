Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B53C47BA49
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 07:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhLUGvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 01:51:49 -0500
Received: from mga06.intel.com ([134.134.136.31]:29913 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234488AbhLUGvo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 01:51:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640069503; x=1671605503;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BCNruAfSXqdAUXzRbLuYxwWyv2sObYjixtukUjnMrug=;
  b=HHP32kqG0vj1+6mVBfk3FJB6drWri8Ofu71zIQtGX8Fhk+qsGR/pbE2/
   HC3JT5jODa5+zXITMtts7yYshjEj2hRgHslRFwpIic/kDTOzxZdqmPBGB
   LjRfxMknvisARnWL1SE0zocgpcDAhS3HXWU0S+A0xs5uUWLhwm1w7Lyw2
   ua0MGO1bNwr6BhvyLllQawPO+vSY5kV9QfhEdJANomG25yxXqdElE7zfz
   FPSAgphTI+qdt5/4zuX1qxV3Tk1IDMHDedd76Kbd72PjYYfuyAK07qJU/
   hSu3NbfVRD1Far4vESNvUSK6osy/d0ZhOYe7I/pGQH/brGZ7jRmdp8gHf
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="301107546"
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="301107546"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 22:50:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,222,1635231600"; 
   d="scan'208";a="570119131"
Received: from unknown (HELO localhost.localdomain) ([10.228.150.100])
  by fmsmga008.fm.intel.com with ESMTP; 20 Dec 2021 22:50:42 -0800
From:   Mike Ximing Chen <mike.ximing.chen@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org,
        dan.j.williams@intel.com, pierre-louis.bossart@linux.intel.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: [RFC PATCH v12 16/17] dlb: add static queue map register operations
Date:   Tue, 21 Dec 2021 00:50:46 -0600
Message-Id: <20211221065047.290182-17-mike.ximing.chen@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211221065047.290182-1-mike.ximing.chen@intel.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the register accesses that implement the static queue map operation and
handle an unmap request when a queue map operation is in progress.

If a queue map operation is requested before the domain is started, it is a
synchronous procedure on "static"/unchanging hardware. (The "dynamic"
operation, when traffic is flowing in the device, will be added in a later
commit.)

Signed-off-by: Mike Ximing Chen <mike.ximing.chen@intel.com>
---
 drivers/misc/dlb/dlb_resource.c | 163 ++++++++++++++++++++++++++++++++
 1 file changed, 163 insertions(+)

diff --git a/drivers/misc/dlb/dlb_resource.c b/drivers/misc/dlb/dlb_resource.c
index 5d4ffdab69b5..e19c0f6cc321 100644
--- a/drivers/misc/dlb/dlb_resource.c
+++ b/drivers/misc/dlb/dlb_resource.c
@@ -1200,6 +1200,38 @@ static int dlb_verify_map_qid_args(struct dlb_hw *hw, u32 domain_id,
 	return 0;
 }
 
+static bool dlb_port_find_slot(struct dlb_ldb_port *port,
+			       enum dlb_qid_map_state state, int *slot)
+{
+	int i;
+
+	for (i = 0; i < DLB_MAX_NUM_QIDS_PER_LDB_CQ; i++) {
+		if (port->qid_map[i].state == state)
+			break;
+	}
+
+	*slot = i;
+
+	return (i < DLB_MAX_NUM_QIDS_PER_LDB_CQ);
+}
+
+static bool dlb_port_find_slot_queue(struct dlb_ldb_port *port,
+				     enum dlb_qid_map_state state,
+				     struct dlb_ldb_queue *queue, int *slot)
+{
+	int i;
+
+	for (i = 0; i < DLB_MAX_NUM_QIDS_PER_LDB_CQ; i++) {
+		if (port->qid_map[i].state == state &&
+		    port->qid_map[i].qid == queue->id)
+			break;
+	}
+
+	*slot = i;
+
+	return (i < DLB_MAX_NUM_QIDS_PER_LDB_CQ);
+}
+
 static int dlb_verify_unmap_qid_args(struct dlb_hw *hw, u32 domain_id,
 				     struct dlb_unmap_qid_args *args,
 				     struct dlb_cmd_response *resp,
@@ -1720,6 +1752,125 @@ static int dlb_configure_dir_port(struct dlb_hw *hw, struct dlb_hw_domain *domai
 	return 0;
 }
 
+static int dlb_ldb_port_map_qid_static(struct dlb_hw *hw, struct dlb_ldb_port *p,
+				       struct dlb_ldb_queue *q, u8 priority)
+{
+	u32 lsp_qid2cq2;
+	u32 lsp_qid2cq;
+	u32 atm_qid2cq;
+	u32 cq2priov;
+	u32 cq2qid;
+	int i;
+
+	/* Look for a pending or already mapped slot, else an unused slot */
+	if (!dlb_port_find_slot_queue(p, DLB_QUEUE_MAP_IN_PROG, q, &i) &&
+	    !dlb_port_find_slot_queue(p, DLB_QUEUE_MAPPED, q, &i) &&
+	    !dlb_port_find_slot(p, DLB_QUEUE_UNMAPPED, &i)) {
+		dev_err(hw_to_dev(hw),
+			"[%s():%d] Internal error: CQ has no available QID mapping slots\n",
+			__func__, __LINE__);
+		return -EFAULT;
+	}
+
+	/* Read-modify-write the priority and valid bit register */
+	cq2priov = DLB_CSR_RD(hw, LSP_CQ2PRIOV(p->id));
+
+	cq2priov |= (1U << (i + LSP_CQ2PRIOV_V_LOC)) & LSP_CQ2PRIOV_V;
+	cq2priov |= ((priority & 0x7) << (i + LSP_CQ2PRIOV_PRIO_LOC) * 3)
+		    & LSP_CQ2PRIOV_PRIO;
+
+	DLB_CSR_WR(hw, LSP_CQ2PRIOV(p->id), cq2priov);
+
+	/* Read-modify-write the QID map register */
+	if (i < 4)
+		cq2qid = DLB_CSR_RD(hw, LSP_CQ2QID0(p->id));
+	else
+		cq2qid = DLB_CSR_RD(hw, LSP_CQ2QID1(p->id));
+
+	if (i == 0 || i == 4) {
+		cq2qid &= ~LSP_CQ2QID0_QID_P0;
+		cq2qid |= FIELD_PREP(LSP_CQ2QID0_QID_P0, q->id);
+	} else if (i == 1 || i == 5) {
+		cq2qid &= ~LSP_CQ2QID0_QID_P1;
+		cq2qid |= FIELD_PREP(LSP_CQ2QID0_QID_P1, q->id);
+	} else if (i == 2 || i == 6) {
+		cq2qid &= ~LSP_CQ2QID0_QID_P2;
+		cq2qid |= FIELD_PREP(LSP_CQ2QID0_QID_P2, q->id);
+	} else if (i == 3 || i == 7) {
+		cq2qid &= ~LSP_CQ2QID0_QID_P3;
+		cq2qid |= FIELD_PREP(LSP_CQ2QID0_QID_P3, q->id);
+	}
+
+	if (i < 4)
+		DLB_CSR_WR(hw, LSP_CQ2QID0(p->id), cq2qid);
+	else
+		DLB_CSR_WR(hw, LSP_CQ2QID1(p->id), cq2qid);
+
+	atm_qid2cq = DLB_CSR_RD(hw,
+				ATM_QID2CQIDIX(q->id,
+					       p->id / 4));
+
+	lsp_qid2cq = DLB_CSR_RD(hw,
+				LSP_QID2CQIDIX(q->id,
+					       p->id / 4));
+
+	lsp_qid2cq2 = DLB_CSR_RD(hw,
+				 LSP_QID2CQIDIX2(q->id,
+						 p->id / 4));
+
+	switch (p->id % 4) {
+	case 0:
+		atm_qid2cq |= (1 << (i + ATM_QID2CQIDIX_00_CQ_P0_LOC));
+		lsp_qid2cq |= (1 << (i + LSP_QID2CQIDIX_00_CQ_P0_LOC));
+		lsp_qid2cq2 |= (1 << (i + LSP_QID2CQIDIX2_00_CQ_P0_LOC));
+		break;
+
+	case 1:
+		atm_qid2cq |= (1 << (i + ATM_QID2CQIDIX_00_CQ_P1_LOC));
+		lsp_qid2cq |= (1 << (i + LSP_QID2CQIDIX_00_CQ_P1_LOC));
+		lsp_qid2cq2 |= (1 << (i + LSP_QID2CQIDIX2_00_CQ_P1_LOC));
+		break;
+
+	case 2:
+		atm_qid2cq |= (1 << (i + ATM_QID2CQIDIX_00_CQ_P2_LOC));
+		lsp_qid2cq |= (1 << (i + LSP_QID2CQIDIX_00_CQ_P2_LOC));
+		lsp_qid2cq2 |= (1 << (i + LSP_QID2CQIDIX2_00_CQ_P2_LOC));
+		break;
+
+	case 3:
+		atm_qid2cq |= (1 << (i + ATM_QID2CQIDIX_00_CQ_P3_LOC));
+		lsp_qid2cq |= (1 << (i + LSP_QID2CQIDIX_00_CQ_P3_LOC));
+		lsp_qid2cq2 |= (1 << (i + LSP_QID2CQIDIX2_00_CQ_P3_LOC));
+		break;
+	}
+
+	DLB_CSR_WR(hw,
+		   ATM_QID2CQIDIX(q->id, p->id / 4),
+		   atm_qid2cq);
+
+	DLB_CSR_WR(hw,
+		   LSP_QID2CQIDIX(q->id, p->id / 4),
+		   lsp_qid2cq);
+
+	DLB_CSR_WR(hw,
+		   LSP_QID2CQIDIX2(q->id, p->id / 4),
+		   lsp_qid2cq2);
+
+	dlb_flush_csr(hw);
+
+	p->qid_map[i].qid = q->id;
+	p->qid_map[i].priority = priority;
+
+	return 0;
+}
+
+static int dlb_ldb_port_map_qid(struct dlb_hw *hw, struct dlb_hw_domain *domain,
+				struct dlb_ldb_port *port,
+				struct dlb_ldb_queue *queue, u8 prio)
+{
+	return dlb_ldb_port_map_qid_static(hw, port, queue, prio);
+}
+
 static void
 dlb_log_create_sched_domain_args(struct dlb_hw *hw,
 				 struct dlb_create_sched_domain_args *args)
@@ -2155,6 +2306,7 @@ int dlb_hw_map_qid(struct dlb_hw *hw, u32 domain_id,
 	struct dlb_ldb_queue *queue;
 	struct dlb_ldb_port *port;
 	int ret;
+	u8 prio;
 
 	dlb_log_map_qid(hw, domain_id, args);
 
@@ -2167,6 +2319,17 @@ int dlb_hw_map_qid(struct dlb_hw *hw, u32 domain_id,
 	if (ret)
 		return ret;
 
+	prio = args->priority;
+
+	ret = dlb_ldb_port_map_qid(hw, domain, port, queue, prio);
+
+	/* If ret is less than zero, it's due to an internal error */
+	if (ret < 0)
+		return ret;
+
+	if (port->enabled)
+		dlb_ldb_port_cq_enable(hw, port);
+
 	resp->status = 0;
 
 	return 0;
-- 
2.27.0

