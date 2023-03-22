Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1E86C5084
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjCVQZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjCVQZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:25:35 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704C63B64A
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 09:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679502333; x=1711038333;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SBi7Y4fdYfxk1MlrJj2NbUVQ0brHu217vpbbCGUjVA0=;
  b=NdSm6Za7weodJFMvXgU0JoWVLTeiuy82s9FaQ99P+oHO03pnso/69oqF
   QJ+vX3u4itAnXfCf21ngtIIRn6ZKbvpp7GZwZDk8GlVKWgkOMVNOhrZq+
   ng4TiMPBOa+rlM6OZ23JGbCoKDmWlVfwYcZRgb3dImSLRgjtNEy7QPrZI
   ZqFad77giUzkVldW58oNBDgw0jEREBMZ2+3m94r/t8QA8ijZTfallt4RY
   YWEnLkLDt5DRf8i65vucuRw17YN+wZ/diPJ1SqZiY0psU4c2FLv5qmiDl
   Ft5vJsdDQ0CizvnQM6UGmluOMVzsHpPCOViLganDnJCIZmelvzk3XAmml
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="404151277"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="404151277"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 09:25:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="825462714"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="825462714"
Received: from nimitz.igk.intel.com ([10.102.21.231])
  by fmsmga001.fm.intel.com with ESMTP; 22 Mar 2023 09:25:30 -0700
From:   Piotr Raczynski <piotr.raczynski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, michal.swiatkowski@intel.com,
        shiraz.saleem@intel.com, jacob.e.keller@intel.com,
        sridhar.samudrala@intel.com, jesse.brandeburg@intel.com,
        aleksander.lobakin@intel.com, lukasz.czapnik@intel.com,
        Piotr Raczynski <piotr.raczynski@intel.com>
Subject: [PATCH net-next v2 1/8] ice: move interrupt related code to separate file
Date:   Wed, 22 Mar 2023 17:25:23 +0100
Message-Id: <20230322162530.3317238-2-piotr.raczynski@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230322162530.3317238-1-piotr.raczynski@intel.com>
References: <20230322162530.3317238-1-piotr.raczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Keep interrupt handling code in a dedicated file. This helps keep driver
structured better and prepares for more functionality added to this file.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
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
index 3290f594286e..db96ec26fdbf 100644
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
index 2a5632ff8081..2dc180385976 100644
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
index faaf25b7dfcb..6ed5a7a68653 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3938,224 +3938,6 @@ static int ice_init_pf(struct ice_pf *pf)
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

