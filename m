Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D65B0A738C
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 21:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfICTUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 15:20:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6830 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725914AbfICTUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 15:20:42 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x83JHjO2025350;
        Tue, 3 Sep 2019 15:20:33 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2usuxj4e23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Sep 2019 15:20:32 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x83JJfTj008333;
        Tue, 3 Sep 2019 19:20:31 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma01dal.us.ibm.com with ESMTP id 2uqgh71m9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Sep 2019 19:20:31 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x83JKU6m51642688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 3 Sep 2019 19:20:30 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52826C6061;
        Tue,  3 Sep 2019 19:20:30 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D233C605A;
        Tue,  3 Sep 2019 19:20:30 +0000 (GMT)
Received: from localhost (unknown [9.18.235.139])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  3 Sep 2019 19:20:29 +0000 (GMT)
From:   "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        davem@davemloft.net, Andrew Bowers <andrewx.bowers@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        maurosr@linux.vnet.ibm.com
Subject: [PATCH v2 net-next 1/2] i40e: fix hw_dbg usage in i40e_hmc_get_object_va
Date:   Tue,  3 Sep 2019 16:20:20 -0300
Message-Id: <20190903192021.25789-1-maurosr@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-03_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1909030191
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mentioned function references a i40e_hw attribute, as parameter for
hw_dbg, but it doesn't exist in the function scope.
Fixes it by changing  parameters from i40e_hmc_info to i40e_hw which can
retrieve the necessary i40e_hmc_info.

v2:
 - Fixed reverse xmas tree code style issue as suggested by Jakub Kicinski

Signed-off-by: Mauro S. M. Rodrigues <maurosr@linux.vnet.ibm.com>
---
 drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c b/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c
index 994011c38fb4..fd987f7ae6e5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2013 - 2018 Intel Corporation. */
 
+#include "i40e.h"
 #include "i40e_osdep.h"
 #include "i40e_register.h"
 #include "i40e_type.h"
@@ -963,7 +964,7 @@ static i40e_status i40e_set_hmc_context(u8 *context_bytes,
 
 /**
  * i40e_hmc_get_object_va - retrieves an object's virtual address
- * @hmc_info: pointer to i40e_hmc_info struct
+ * @hw: the hardware struct, from which we obtain the i40e_hmc_info pointer
  * @object_base: pointer to u64 to get the va
  * @rsrc_type: the hmc resource type
  * @obj_idx: hmc object index
@@ -972,16 +973,17 @@ static i40e_status i40e_set_hmc_context(u8 *context_bytes,
  * base pointer.  This function is used for LAN Queue contexts.
  **/
 static
-i40e_status i40e_hmc_get_object_va(struct i40e_hmc_info *hmc_info,
+i40e_status i40e_hmc_get_object_va(struct i40e_hw *hw,
 					u8 **object_base,
 					enum i40e_hmc_lan_rsrc_type rsrc_type,
 					u32 obj_idx)
 {
+	struct i40e_hmc_info *hmc_info = &hw->hmc;
 	u32 obj_offset_in_sd, obj_offset_in_pd;
-	i40e_status ret_code = 0;
 	struct i40e_hmc_sd_entry *sd_entry;
 	struct i40e_hmc_pd_entry *pd_entry;
 	u32 pd_idx, pd_lmt, rel_pd_idx;
+	i40e_status ret_code = 0;
 	u64 obj_offset_in_fpm;
 	u32 sd_idx, sd_lmt;
 
@@ -1047,7 +1049,7 @@ i40e_status i40e_clear_lan_tx_queue_context(struct i40e_hw *hw,
 	i40e_status err;
 	u8 *context_bytes;
 
-	err = i40e_hmc_get_object_va(&hw->hmc, &context_bytes,
+	err = i40e_hmc_get_object_va(hw, &context_bytes,
 				     I40E_HMC_LAN_TX, queue);
 	if (err < 0)
 		return err;
@@ -1068,7 +1070,7 @@ i40e_status i40e_set_lan_tx_queue_context(struct i40e_hw *hw,
 	i40e_status err;
 	u8 *context_bytes;
 
-	err = i40e_hmc_get_object_va(&hw->hmc, &context_bytes,
+	err = i40e_hmc_get_object_va(hw, &context_bytes,
 				     I40E_HMC_LAN_TX, queue);
 	if (err < 0)
 		return err;
@@ -1088,7 +1090,7 @@ i40e_status i40e_clear_lan_rx_queue_context(struct i40e_hw *hw,
 	i40e_status err;
 	u8 *context_bytes;
 
-	err = i40e_hmc_get_object_va(&hw->hmc, &context_bytes,
+	err = i40e_hmc_get_object_va(hw, &context_bytes,
 				     I40E_HMC_LAN_RX, queue);
 	if (err < 0)
 		return err;
@@ -1109,7 +1111,7 @@ i40e_status i40e_set_lan_rx_queue_context(struct i40e_hw *hw,
 	i40e_status err;
 	u8 *context_bytes;
 
-	err = i40e_hmc_get_object_va(&hw->hmc, &context_bytes,
+	err = i40e_hmc_get_object_va(hw, &context_bytes,
 				     I40E_HMC_LAN_RX, queue);
 	if (err < 0)
 		return err;
-- 
2.21.0

