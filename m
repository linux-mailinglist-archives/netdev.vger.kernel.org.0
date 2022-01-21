Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E94B49572A
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 01:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378316AbiAUADd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 19:03:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:55926 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233910AbiAUADc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 19:03:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642723412; x=1674259412;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v3z/SuTC8tvCqn3ivDQ8hZgpF0q5E4A5VE2mvZxgpMI=;
  b=hM7bdAXlpYL0rm/FuDJKP909bZob6ou2YWi4lPSYD78BU/c+YJDHPeXp
   UcCspN1OKSysucQAryfBglOoVq7+1ZGjMkMKYNys69KfV723ezG8YYaNJ
   q89rOZGZc8VugeUZmLDbkuYJ6MaTpKBCVmAYLrLPS2Nz9IgESA63uq57d
   CyEVPqckKf0/lfV85zfm0zcN2tDOob5dW8u3mue0GwzldAgEPBhCGsy/w
   CxlhjkdWXSa9Vtz7u3sTlr6uTCLpkhQvwz6+KIoYrNW8wAWXkezar5EIH
   LiKgNbVYR2VyNf2Ez7Wp5/lPQ0NWIIN3izjfcMIl42HwLnomITrFCXfYx
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10233"; a="232879178"
X-IronPort-AV: E=Sophos;i="5.88,303,1635231600"; 
   d="scan'208";a="232879178"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 16:03:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,303,1635231600"; 
   d="scan'208";a="478015667"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 20 Jan 2022 16:03:31 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com, Jaroslaw Gawin <jaroslawx.gawin@intel.com>,
        Slawomir Laba <slawomirx.laba@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 2/5] i40e: Fix issue when maximum queues is exceeded
Date:   Thu, 20 Jan 2022 16:03:02 -0800
Message-Id: <20220121000305.1423587-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220121000305.1423587-1-anthony.l.nguyen@intel.com>
References: <20220121000305.1423587-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

Before this patch VF interface vanished when
maximum queue number was exceeded. Driver tried
to add next queues even if there was not enough
space. PF sent incorrect number of queues to
the VF when there were not enough of them.

Add an additional condition introduced to check
available space in 'qp_pile' before proceeding.
This condition makes it impossible to add queues
if they number is greater than the number resulting
from available space.
Also add the search for free space in PF queue
pair piles.

Without this patch VF interfaces are not seen
when available space for queues has been
exceeded and following logs appears permanently
in dmesg:
"Unable to get VF config (-32)".
"VF 62 failed opcode 3, retval: -5"
"Unable to get VF config due to PF error condition, not retrying"

Fixes: 7daa6bf3294e ("i40e: driver core headers")
Fixes: 41c445ff0f48 ("i40e: main driver core")
Signed-off-by: Jaroslaw Gawin <jaroslawx.gawin@intel.com>
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h        |  1 -
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 14 +----
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 59 +++++++++++++++++++
 3 files changed, 61 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 4d939af0a626..c8cfe62d5e05 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -174,7 +174,6 @@ enum i40e_interrupt_policy {
 
 struct i40e_lump_tracking {
 	u16 num_entries;
-	u16 search_hint;
 	u16 list[0];
 #define I40E_PILE_VALID_BIT  0x8000
 #define I40E_IWARP_IRQ_PILE_ID  (I40E_PILE_VALID_BIT - 2)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 1b0fd3eacd64..9456641cd24a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -196,10 +196,6 @@ int i40e_free_virt_mem_d(struct i40e_hw *hw, struct i40e_virt_mem *mem)
  * @id: an owner id to stick on the items assigned
  *
  * Returns the base item index of the lump, or negative for error
- *
- * The search_hint trick and lack of advanced fit-finding only work
- * because we're highly likely to have all the same size lump requests.
- * Linear search time and any fragmentation should be minimal.
  **/
 static int i40e_get_lump(struct i40e_pf *pf, struct i40e_lump_tracking *pile,
 			 u16 needed, u16 id)
@@ -214,8 +210,7 @@ static int i40e_get_lump(struct i40e_pf *pf, struct i40e_lump_tracking *pile,
 		return -EINVAL;
 	}
 
-	/* start the linear search with an imperfect hint */
-	i = pile->search_hint;
+	i = 0;
 	while (i < pile->num_entries) {
 		/* skip already allocated entries */
 		if (pile->list[i] & I40E_PILE_VALID_BIT) {
@@ -234,7 +229,6 @@ static int i40e_get_lump(struct i40e_pf *pf, struct i40e_lump_tracking *pile,
 			for (j = 0; j < needed; j++)
 				pile->list[i+j] = id | I40E_PILE_VALID_BIT;
 			ret = i;
-			pile->search_hint = i + j;
 			break;
 		}
 
@@ -257,7 +251,7 @@ static int i40e_put_lump(struct i40e_lump_tracking *pile, u16 index, u16 id)
 {
 	int valid_id = (id | I40E_PILE_VALID_BIT);
 	int count = 0;
-	int i;
+	u16 i;
 
 	if (!pile || index >= pile->num_entries)
 		return -EINVAL;
@@ -269,8 +263,6 @@ static int i40e_put_lump(struct i40e_lump_tracking *pile, u16 index, u16 id)
 		count++;
 	}
 
-	if (count && index < pile->search_hint)
-		pile->search_hint = index;
 
 	return count;
 }
@@ -11786,7 +11778,6 @@ static int i40e_init_interrupt_scheme(struct i40e_pf *pf)
 		return -ENOMEM;
 
 	pf->irq_pile->num_entries = vectors;
-	pf->irq_pile->search_hint = 0;
 
 	/* track first vector for misc interrupts, ignore return */
 	(void)i40e_get_lump(pf, pf->irq_pile, 1, I40E_PILE_VALID_BIT - 1);
@@ -12589,7 +12580,6 @@ static int i40e_sw_init(struct i40e_pf *pf)
 		goto sw_init_done;
 	}
 	pf->qp_pile->num_entries = pf->hw.func_caps.num_tx_qp;
-	pf->qp_pile->search_hint = 0;
 
 	pf->tx_timeout_recovery_level = 1;
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index b785d09c19f8..7dd2a2bab339 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2617,6 +2617,59 @@ static int i40e_vc_disable_queues_msg(struct i40e_vf *vf, u8 *msg)
 				       aq_ret);
 }
 
+/**
+ * i40e_check_enough_queue - find big enough queue number
+ * @vf: pointer to the VF info
+ * @needed: the number of items needed
+ *
+ * Returns the base item index of the queue, or negative for error
+ **/
+static int i40e_check_enough_queue(struct i40e_vf *vf, u16 needed)
+{
+	unsigned int  i, cur_queues, more, pool_size;
+	struct i40e_lump_tracking *pile;
+	struct i40e_pf *pf = vf->pf;
+	struct i40e_vsi *vsi;
+
+	vsi = pf->vsi[vf->lan_vsi_idx];
+	cur_queues = vsi->alloc_queue_pairs;
+
+	/* if current allocated queues are enough for need */
+	if (cur_queues >= needed)
+		return vsi->base_queue;
+
+	pile = pf->qp_pile;
+	if (cur_queues > 0) {
+		/* if the allocated queues are not zero
+		 * just check if there are enough queues for more
+		 * behind the allocated queues.
+		 */
+		more = needed - cur_queues;
+		for (i = vsi->base_queue + cur_queues;
+			i < pile->num_entries; i++) {
+			if (pile->list[i] & I40E_PILE_VALID_BIT)
+				break;
+
+			if (more-- == 1)
+				/* there is enough */
+				return vsi->base_queue;
+		}
+	}
+
+	pool_size = 0;
+	for (i = 0; i < pile->num_entries; i++) {
+		if (pile->list[i] & I40E_PILE_VALID_BIT) {
+			pool_size = 0;
+			continue;
+		}
+		if (needed <= ++pool_size)
+			/* there is enough */
+			return i;
+	}
+
+	return -ENOMEM;
+}
+
 /**
  * i40e_vc_request_queues_msg
  * @vf: pointer to the VF info
@@ -2651,6 +2704,12 @@ static int i40e_vc_request_queues_msg(struct i40e_vf *vf, u8 *msg)
 			 req_pairs - cur_pairs,
 			 pf->queues_left);
 		vfres->num_queue_pairs = pf->queues_left + cur_pairs;
+	} else if (i40e_check_enough_queue(vf, req_pairs) < 0) {
+		dev_warn(&pf->pdev->dev,
+			 "VF %d requested %d more queues, but there is not enough for it.\n",
+			 vf->vf_id,
+			 req_pairs - cur_pairs);
+		vfres->num_queue_pairs = cur_pairs;
 	} else {
 		/* successful request */
 		vf->num_req_queues = req_pairs;
-- 
2.31.1

