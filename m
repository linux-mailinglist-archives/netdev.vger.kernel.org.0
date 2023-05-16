Return-Path: <netdev+bounces-3065-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DE32705532
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:44:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C1611C20ED9
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 17:44:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 554F61429D;
	Tue, 16 May 2023 17:44:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37ABD11C93
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 17:44:05 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5B793C9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 10:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684259042; x=1715795042;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uzHjPsoaidhCYSgOmndrvGLm7rLqmFoCt3vUdF7eiOA=;
  b=HQqzaR1TLrB2vIFLczcZds1/+RaIIfrBnPjEQ0Kp66Peu631zc2v3iBb
   7N07PgekQraDf8I3VpvtTHQjsclqGHVOcbyhTUcW10e5kbmO/zwpO8MZT
   TP5rb3dStPJEEyhx62k7pSkHxfeY3j5k8KDWFIAF8Io9UsBuH2aAac6pi
   ARH+My8cqQbTAqJ8549I4avcI/L4MsQ/O56iwen6msCPfoWzTrSdMS1tX
   QkQrsJgHu9IrnDEZa6tgHwV84Db17KPxmpD38xcNuxMBzBgHap4Ozo1HU
   vdV5pQUcVsyQjIKvgLhCHP6UmYEIdiGJOb+NFlWhz3qsqv8PxOqQZLl4G
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="353831916"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="353831916"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 10:44:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10712"; a="875733037"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="875733037"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga005.jf.intel.com with ESMTP; 16 May 2023 10:44:00 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Piotr Raczynski <piotr.raczynski@intel.com>,
	anthony.l.nguyen@intel.com,
	Jacob Keller <jacob.e.keller@intel.com>,
	Simon Horman <simon.horman@corigine.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH net-next v2 1/8] ice: move interrupt related code to separate file
Date: Tue, 16 May 2023 10:40:14 -0700
Message-Id: <20230516174021.2707029-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230516174021.2707029-1-anthony.l.nguyen@intel.com>
References: <20230516174021.2707029-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Piotr Raczynski <piotr.raczynski@intel.com>

Keep interrupt handling code in a dedicated file. This helps keep driver
structured better and prepares for more functionality added to this file.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/Makefile   |   1 +
 drivers/net/ethernet/intel/ice/ice.h      |   1 +
 drivers/net/ethernet/intel/ice/ice_irq.c  | 226 ++++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_irq.h  |  10 +
 drivers/net/ethernet/intel/ice/ice_main.c | 218 ---------------------
 5 files changed, 238 insertions(+), 218 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_irq.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_irq.h

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 5d89392f969b..817977e3039d 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -18,6 +18,7 @@ ice-y := ice_main.o	\
 	 ice_txrx_lib.o	\
 	 ice_txrx.o	\
 	 ice_fltr.o	\
+	 ice_irq.o	\
 	 ice_pf_vsi_vlan_ops.o \
 	 ice_vsi_vlan_ops.o \
 	 ice_vsi_vlan_lib.o \
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index aa32111afd6e..4dc4c6bec081 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -74,6 +74,7 @@
 #include "ice_lag.h"
 #include "ice_vsi_vlan_ops.h"
 #include "ice_gnss.h"
+#include "ice_irq.h"
 
 #define ICE_BAR0		0
 #define ICE_REQ_DESC_MULTIPLE	32
diff --git a/drivers/net/ethernet/intel/ice/ice_irq.c b/drivers/net/ethernet/intel/ice/ice_irq.c
new file mode 100644
index 000000000000..1fc7daec9732
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_irq.c
@@ -0,0 +1,226 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2023, Intel Corporation. */
+
+#include "ice.h"
+#include "ice_lib.h"
+#include "ice_irq.h"
+
+/**
+ * ice_reduce_msix_usage - Reduce usage of MSI-X vectors
+ * @pf: board private structure
+ * @v_remain: number of remaining MSI-X vectors to be distributed
+ *
+ * Reduce the usage of MSI-X vectors when entire request cannot be fulfilled.
+ * pf->num_lan_msix and pf->num_rdma_msix values are set based on number of
+ * remaining vectors.
+ */
+static void ice_reduce_msix_usage(struct ice_pf *pf, int v_remain)
+{
+	int v_rdma;
+
+	if (!ice_is_rdma_ena(pf)) {
+		pf->num_lan_msix = v_remain;
+		return;
+	}
+
+	/* RDMA needs at least 1 interrupt in addition to AEQ MSIX */
+	v_rdma = ICE_RDMA_NUM_AEQ_MSIX + 1;
+
+	if (v_remain < ICE_MIN_LAN_TXRX_MSIX + ICE_MIN_RDMA_MSIX) {
+		dev_warn(ice_pf_to_dev(pf), "Not enough MSI-X vectors to support RDMA.\n");
+		clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
+
+		pf->num_rdma_msix = 0;
+		pf->num_lan_msix = ICE_MIN_LAN_TXRX_MSIX;
+	} else if ((v_remain < ICE_MIN_LAN_TXRX_MSIX + v_rdma) ||
+		   (v_remain - v_rdma < v_rdma)) {
+		/* Support minimum RDMA and give remaining vectors to LAN MSIX
+		 */
+		pf->num_rdma_msix = ICE_MIN_RDMA_MSIX;
+		pf->num_lan_msix = v_remain - ICE_MIN_RDMA_MSIX;
+	} else {
+		/* Split remaining MSIX with RDMA after accounting for AEQ MSIX
+		 */
+		pf->num_rdma_msix = (v_remain - ICE_RDMA_NUM_AEQ_MSIX) / 2 +
+				    ICE_RDMA_NUM_AEQ_MSIX;
+		pf->num_lan_msix = v_remain - pf->num_rdma_msix;
+	}
+}
+
+/**
+ * ice_ena_msix_range - Request a range of MSIX vectors from the OS
+ * @pf: board private structure
+ *
+ * Compute the number of MSIX vectors wanted and request from the OS. Adjust
+ * device usage if there are not enough vectors. Return the number of vectors
+ * reserved or negative on failure.
+ */
+static int ice_ena_msix_range(struct ice_pf *pf)
+{
+	int num_cpus, hw_num_msix, v_other, v_wanted, v_actual;
+	struct device *dev = ice_pf_to_dev(pf);
+	int err, i;
+
+	hw_num_msix = pf->hw.func_caps.common_cap.num_msix_vectors;
+	num_cpus = num_online_cpus();
+
+	/* LAN miscellaneous handler */
+	v_other = ICE_MIN_LAN_OICR_MSIX;
+
+	/* Flow Director */
+	if (test_bit(ICE_FLAG_FD_ENA, pf->flags))
+		v_other += ICE_FDIR_MSIX;
+
+	/* switchdev */
+	v_other += ICE_ESWITCH_MSIX;
+
+	v_wanted = v_other;
+
+	/* LAN traffic */
+	pf->num_lan_msix = num_cpus;
+	v_wanted += pf->num_lan_msix;
+
+	/* RDMA auxiliary driver */
+	if (ice_is_rdma_ena(pf)) {
+		pf->num_rdma_msix = num_cpus + ICE_RDMA_NUM_AEQ_MSIX;
+		v_wanted += pf->num_rdma_msix;
+	}
+
+	if (v_wanted > hw_num_msix) {
+		int v_remain;
+
+		dev_warn(dev, "not enough device MSI-X vectors. wanted = %d, available = %d\n",
+			 v_wanted, hw_num_msix);
+
+		if (hw_num_msix < ICE_MIN_MSIX) {
+			err = -ERANGE;
+			goto exit_err;
+		}
+
+		v_remain = hw_num_msix - v_other;
+		if (v_remain < ICE_MIN_LAN_TXRX_MSIX) {
+			v_other = ICE_MIN_MSIX - ICE_MIN_LAN_TXRX_MSIX;
+			v_remain = ICE_MIN_LAN_TXRX_MSIX;
+		}
+
+		ice_reduce_msix_usage(pf, v_remain);
+		v_wanted = pf->num_lan_msix + pf->num_rdma_msix + v_other;
+
+		dev_notice(dev, "Reducing request to %d MSI-X vectors for LAN traffic.\n",
+			   pf->num_lan_msix);
+		if (ice_is_rdma_ena(pf))
+			dev_notice(dev, "Reducing request to %d MSI-X vectors for RDMA.\n",
+				   pf->num_rdma_msix);
+	}
+
+	pf->msix_entries = devm_kcalloc(dev, v_wanted,
+					sizeof(*pf->msix_entries), GFP_KERNEL);
+	if (!pf->msix_entries) {
+		err = -ENOMEM;
+		goto exit_err;
+	}
+
+	for (i = 0; i < v_wanted; i++)
+		pf->msix_entries[i].entry = i;
+
+	/* actually reserve the vectors */
+	v_actual = pci_enable_msix_range(pf->pdev, pf->msix_entries,
+					 ICE_MIN_MSIX, v_wanted);
+	if (v_actual < 0) {
+		dev_err(dev, "unable to reserve MSI-X vectors\n");
+		err = v_actual;
+		goto msix_err;
+	}
+
+	if (v_actual < v_wanted) {
+		dev_warn(dev, "not enough OS MSI-X vectors. requested = %d, obtained = %d\n",
+			 v_wanted, v_actual);
+
+		if (v_actual < ICE_MIN_MSIX) {
+			/* error if we can't get minimum vectors */
+			pci_disable_msix(pf->pdev);
+			err = -ERANGE;
+			goto msix_err;
+		} else {
+			int v_remain = v_actual - v_other;
+
+			if (v_remain < ICE_MIN_LAN_TXRX_MSIX)
+				v_remain = ICE_MIN_LAN_TXRX_MSIX;
+
+			ice_reduce_msix_usage(pf, v_remain);
+
+			dev_notice(dev, "Enabled %d MSI-X vectors for LAN traffic.\n",
+				   pf->num_lan_msix);
+
+			if (ice_is_rdma_ena(pf))
+				dev_notice(dev, "Enabled %d MSI-X vectors for RDMA.\n",
+					   pf->num_rdma_msix);
+		}
+	}
+
+	return v_actual;
+
+msix_err:
+	devm_kfree(dev, pf->msix_entries);
+
+exit_err:
+	pf->num_rdma_msix = 0;
+	pf->num_lan_msix = 0;
+	return err;
+}
+
+/**
+ * ice_dis_msix - Disable MSI-X interrupt setup in OS
+ * @pf: board private structure
+ */
+static void ice_dis_msix(struct ice_pf *pf)
+{
+	pci_disable_msix(pf->pdev);
+	devm_kfree(ice_pf_to_dev(pf), pf->msix_entries);
+	pf->msix_entries = NULL;
+}
+
+/**
+ * ice_clear_interrupt_scheme - Undo things done by ice_init_interrupt_scheme
+ * @pf: board private structure
+ */
+void ice_clear_interrupt_scheme(struct ice_pf *pf)
+{
+	ice_dis_msix(pf);
+
+	if (pf->irq_tracker) {
+		devm_kfree(ice_pf_to_dev(pf), pf->irq_tracker);
+		pf->irq_tracker = NULL;
+	}
+}
+
+/**
+ * ice_init_interrupt_scheme - Determine proper interrupt scheme
+ * @pf: board private structure to initialize
+ */
+int ice_init_interrupt_scheme(struct ice_pf *pf)
+{
+	int vectors;
+
+	vectors = ice_ena_msix_range(pf);
+
+	if (vectors < 0)
+		return vectors;
+
+	/* set up vector assignment tracking */
+	pf->irq_tracker = devm_kzalloc(ice_pf_to_dev(pf),
+				       struct_size(pf->irq_tracker, list,
+						   vectors),
+				       GFP_KERNEL);
+	if (!pf->irq_tracker) {
+		ice_dis_msix(pf);
+		return -ENOMEM;
+	}
+
+	/* populate SW interrupts pool with number of OS granted IRQs. */
+	pf->num_avail_sw_msix = (u16)vectors;
+	pf->irq_tracker->num_entries = (u16)vectors;
+	pf->irq_tracker->end = pf->irq_tracker->num_entries;
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_irq.h b/drivers/net/ethernet/intel/ice/ice_irq.h
new file mode 100644
index 000000000000..82475162ab70
--- /dev/null
+++ b/drivers/net/ethernet/intel/ice/ice_irq.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2023, Intel Corporation. */
+
+#ifndef _ICE_IRQ_H_
+#define _ICE_IRQ_H_
+
+int ice_init_interrupt_scheme(struct ice_pf *pf);
+void ice_clear_interrupt_scheme(struct ice_pf *pf);
+
+#endif
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a1f7c8edc22f..c377bacc5e2e 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3900,224 +3900,6 @@ static int ice_init_pf(struct ice_pf *pf)
 	return 0;
 }
 
-/**
- * ice_reduce_msix_usage - Reduce usage of MSI-X vectors
- * @pf: board private structure
- * @v_remain: number of remaining MSI-X vectors to be distributed
- *
- * Reduce the usage of MSI-X vectors when entire request cannot be fulfilled.
- * pf->num_lan_msix and pf->num_rdma_msix values are set based on number of
- * remaining vectors.
- */
-static void ice_reduce_msix_usage(struct ice_pf *pf, int v_remain)
-{
-	int v_rdma;
-
-	if (!ice_is_rdma_ena(pf)) {
-		pf->num_lan_msix = v_remain;
-		return;
-	}
-
-	/* RDMA needs at least 1 interrupt in addition to AEQ MSIX */
-	v_rdma = ICE_RDMA_NUM_AEQ_MSIX + 1;
-
-	if (v_remain < ICE_MIN_LAN_TXRX_MSIX + ICE_MIN_RDMA_MSIX) {
-		dev_warn(ice_pf_to_dev(pf), "Not enough MSI-X vectors to support RDMA.\n");
-		clear_bit(ICE_FLAG_RDMA_ENA, pf->flags);
-
-		pf->num_rdma_msix = 0;
-		pf->num_lan_msix = ICE_MIN_LAN_TXRX_MSIX;
-	} else if ((v_remain < ICE_MIN_LAN_TXRX_MSIX + v_rdma) ||
-		   (v_remain - v_rdma < v_rdma)) {
-		/* Support minimum RDMA and give remaining vectors to LAN MSIX */
-		pf->num_rdma_msix = ICE_MIN_RDMA_MSIX;
-		pf->num_lan_msix = v_remain - ICE_MIN_RDMA_MSIX;
-	} else {
-		/* Split remaining MSIX with RDMA after accounting for AEQ MSIX
-		 */
-		pf->num_rdma_msix = (v_remain - ICE_RDMA_NUM_AEQ_MSIX) / 2 +
-				    ICE_RDMA_NUM_AEQ_MSIX;
-		pf->num_lan_msix = v_remain - pf->num_rdma_msix;
-	}
-}
-
-/**
- * ice_ena_msix_range - Request a range of MSIX vectors from the OS
- * @pf: board private structure
- *
- * Compute the number of MSIX vectors wanted and request from the OS. Adjust
- * device usage if there are not enough vectors. Return the number of vectors
- * reserved or negative on failure.
- */
-static int ice_ena_msix_range(struct ice_pf *pf)
-{
-	int num_cpus, hw_num_msix, v_other, v_wanted, v_actual;
-	struct device *dev = ice_pf_to_dev(pf);
-	int err, i;
-
-	hw_num_msix = pf->hw.func_caps.common_cap.num_msix_vectors;
-	num_cpus = num_online_cpus();
-
-	/* LAN miscellaneous handler */
-	v_other = ICE_MIN_LAN_OICR_MSIX;
-
-	/* Flow Director */
-	if (test_bit(ICE_FLAG_FD_ENA, pf->flags))
-		v_other += ICE_FDIR_MSIX;
-
-	/* switchdev */
-	v_other += ICE_ESWITCH_MSIX;
-
-	v_wanted = v_other;
-
-	/* LAN traffic */
-	pf->num_lan_msix = num_cpus;
-	v_wanted += pf->num_lan_msix;
-
-	/* RDMA auxiliary driver */
-	if (ice_is_rdma_ena(pf)) {
-		pf->num_rdma_msix = num_cpus + ICE_RDMA_NUM_AEQ_MSIX;
-		v_wanted += pf->num_rdma_msix;
-	}
-
-	if (v_wanted > hw_num_msix) {
-		int v_remain;
-
-		dev_warn(dev, "not enough device MSI-X vectors. wanted = %d, available = %d\n",
-			 v_wanted, hw_num_msix);
-
-		if (hw_num_msix < ICE_MIN_MSIX) {
-			err = -ERANGE;
-			goto exit_err;
-		}
-
-		v_remain = hw_num_msix - v_other;
-		if (v_remain < ICE_MIN_LAN_TXRX_MSIX) {
-			v_other = ICE_MIN_MSIX - ICE_MIN_LAN_TXRX_MSIX;
-			v_remain = ICE_MIN_LAN_TXRX_MSIX;
-		}
-
-		ice_reduce_msix_usage(pf, v_remain);
-		v_wanted = pf->num_lan_msix + pf->num_rdma_msix + v_other;
-
-		dev_notice(dev, "Reducing request to %d MSI-X vectors for LAN traffic.\n",
-			   pf->num_lan_msix);
-		if (ice_is_rdma_ena(pf))
-			dev_notice(dev, "Reducing request to %d MSI-X vectors for RDMA.\n",
-				   pf->num_rdma_msix);
-	}
-
-	pf->msix_entries = devm_kcalloc(dev, v_wanted,
-					sizeof(*pf->msix_entries), GFP_KERNEL);
-	if (!pf->msix_entries) {
-		err = -ENOMEM;
-		goto exit_err;
-	}
-
-	for (i = 0; i < v_wanted; i++)
-		pf->msix_entries[i].entry = i;
-
-	/* actually reserve the vectors */
-	v_actual = pci_enable_msix_range(pf->pdev, pf->msix_entries,
-					 ICE_MIN_MSIX, v_wanted);
-	if (v_actual < 0) {
-		dev_err(dev, "unable to reserve MSI-X vectors\n");
-		err = v_actual;
-		goto msix_err;
-	}
-
-	if (v_actual < v_wanted) {
-		dev_warn(dev, "not enough OS MSI-X vectors. requested = %d, obtained = %d\n",
-			 v_wanted, v_actual);
-
-		if (v_actual < ICE_MIN_MSIX) {
-			/* error if we can't get minimum vectors */
-			pci_disable_msix(pf->pdev);
-			err = -ERANGE;
-			goto msix_err;
-		} else {
-			int v_remain = v_actual - v_other;
-
-			if (v_remain < ICE_MIN_LAN_TXRX_MSIX)
-				v_remain = ICE_MIN_LAN_TXRX_MSIX;
-
-			ice_reduce_msix_usage(pf, v_remain);
-
-			dev_notice(dev, "Enabled %d MSI-X vectors for LAN traffic.\n",
-				   pf->num_lan_msix);
-
-			if (ice_is_rdma_ena(pf))
-				dev_notice(dev, "Enabled %d MSI-X vectors for RDMA.\n",
-					   pf->num_rdma_msix);
-		}
-	}
-
-	return v_actual;
-
-msix_err:
-	devm_kfree(dev, pf->msix_entries);
-
-exit_err:
-	pf->num_rdma_msix = 0;
-	pf->num_lan_msix = 0;
-	return err;
-}
-
-/**
- * ice_dis_msix - Disable MSI-X interrupt setup in OS
- * @pf: board private structure
- */
-static void ice_dis_msix(struct ice_pf *pf)
-{
-	pci_disable_msix(pf->pdev);
-	devm_kfree(ice_pf_to_dev(pf), pf->msix_entries);
-	pf->msix_entries = NULL;
-}
-
-/**
- * ice_clear_interrupt_scheme - Undo things done by ice_init_interrupt_scheme
- * @pf: board private structure
- */
-static void ice_clear_interrupt_scheme(struct ice_pf *pf)
-{
-	ice_dis_msix(pf);
-
-	if (pf->irq_tracker) {
-		devm_kfree(ice_pf_to_dev(pf), pf->irq_tracker);
-		pf->irq_tracker = NULL;
-	}
-}
-
-/**
- * ice_init_interrupt_scheme - Determine proper interrupt scheme
- * @pf: board private structure to initialize
- */
-static int ice_init_interrupt_scheme(struct ice_pf *pf)
-{
-	int vectors;
-
-	vectors = ice_ena_msix_range(pf);
-
-	if (vectors < 0)
-		return vectors;
-
-	/* set up vector assignment tracking */
-	pf->irq_tracker = devm_kzalloc(ice_pf_to_dev(pf),
-				       struct_size(pf->irq_tracker, list, vectors),
-				       GFP_KERNEL);
-	if (!pf->irq_tracker) {
-		ice_dis_msix(pf);
-		return -ENOMEM;
-	}
-
-	/* populate SW interrupts pool with number of OS granted IRQs. */
-	pf->num_avail_sw_msix = (u16)vectors;
-	pf->irq_tracker->num_entries = (u16)vectors;
-	pf->irq_tracker->end = pf->irq_tracker->num_entries;
-
-	return 0;
-}
-
 /**
  * ice_is_wol_supported - check if WoL is supported
  * @hw: pointer to hardware info
-- 
2.38.1


