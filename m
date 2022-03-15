Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5810C4D920A
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 02:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242971AbiCOBMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 21:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233127AbiCOBMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 21:12:48 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D44746678
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 18:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647306697; x=1678842697;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LtzD69+vSeu5lLe+fIhUVRXnlxPWKVCxjJYe+cw8OUI=;
  b=LWDSj6VNCN+JPvflPBPclAiK2aRKrdQoih4AwWL9bJuG6xLdhNmJbvzW
   axB8EoVlLsB38chy7OHcbEoZ3s9Z6wFz3XWgV0md4Ta3QInDxreEtdQUd
   kF3Q1kd76y7KEDR6XPFtG8zlkgb9Acy6gHvbljpjeegbcA/WDWeeK3z6M
   mc3nxcE0jQFGP5fewA6SU8doWCSmG8eK0rgtwVm6zhP7EZdcsG0XRCiGk
   antvG7tuO61TKMLLzQXpR8BpogrjJmYF40jZb8vdiIyNgpfJvjNXzd997
   +otaHPrmECwGNdxp0sITnr1F3TF5522OKId78tB2FgxiTgo0Fjbmm63/s
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="256375075"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="256375075"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 18:11:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="540222877"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 14 Mar 2022 18:11:32 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next v2 01/11] ice: rename ice_sriov.c to ice_vf_mbx.c
Date:   Mon, 14 Mar 2022 18:11:45 -0700
Message-Id: <20220315011155.2166817-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220315011155.2166817-1-anthony.l.nguyen@intel.com>
References: <20220315011155.2166817-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_sriov.c file primarily contains code which handles the logic for
mailbox overflow detection and some other utility functions related to
the virtualization mailbox.

The bulk of the SR-IOV implementation is actually found in
ice_virtchnl_pf.c, and this file isn't strictly SR-IOV specific.

In the future, the ice driver will support an additional virtualization
scheme known as Scalable IOV, and the code in this file will be used
for this alternative implementation.

Rename this file (and its associated header) to ice_vf_mbx.c, so that we
can later re-use the ice_sriov.c file as the SR-IOV specific file.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/Makefile                     | 2 +-
 drivers/net/ethernet/intel/ice/ice.h                        | 2 +-
 .../net/ethernet/intel/ice/{ice_sriov.c => ice_vf_mbx.c}    | 2 +-
 .../net/ethernet/intel/ice/{ice_sriov.h => ice_vf_mbx.h}    | 6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)
 rename drivers/net/ethernet/intel/ice/{ice_sriov.c => ice_vf_mbx.c} (99%)
 rename drivers/net/ethernet/intel/ice/{ice_sriov.h => ice_vf_mbx.h} (95%)

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 44b8464b7663..451098e25023 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -36,7 +36,7 @@ ice-y := ice_main.o	\
 ice-$(CONFIG_PCI_IOV) +=	\
 	ice_virtchnl_allowlist.o \
 	ice_virtchnl_fdir.o	\
-	ice_sriov.o		\
+	ice_vf_mbx.o		\
 	ice_vf_vsi_vlan_ops.o	\
 	ice_virtchnl_pf.o
 ice-$(CONFIG_PTP_1588_CLOCK) += ice_ptp.o ice_ptp_hw.o
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 1a130ff562af..9449ee2322b7 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -65,7 +65,7 @@
 #include "ice_sched.h"
 #include "ice_idc_int.h"
 #include "ice_virtchnl_pf.h"
-#include "ice_sriov.h"
+#include "ice_vf_mbx.h"
 #include "ice_ptp.h"
 #include "ice_fdir.h"
 #include "ice_xsk.h"
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_vf_mbx.c
similarity index 99%
rename from drivers/net/ethernet/intel/ice/ice_sriov.c
rename to drivers/net/ethernet/intel/ice/ice_vf_mbx.c
index 52c6bac41bf7..fc8c93fa4455 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_mbx.c
@@ -2,7 +2,7 @@
 /* Copyright (c) 2018, Intel Corporation. */
 
 #include "ice_common.h"
-#include "ice_sriov.h"
+#include "ice_vf_mbx.h"
 
 /**
  * ice_aq_send_msg_to_vf
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.h b/drivers/net/ethernet/intel/ice/ice_vf_mbx.h
similarity index 95%
rename from drivers/net/ethernet/intel/ice/ice_sriov.h
rename to drivers/net/ethernet/intel/ice/ice_vf_mbx.h
index 68686a3fd7e8..582716e6d5f9 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.h
+++ b/drivers/net/ethernet/intel/ice/ice_vf_mbx.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (c) 2018, Intel Corporation. */
 
-#ifndef _ICE_SRIOV_H_
-#define _ICE_SRIOV_H_
+#ifndef _ICE_VF_MBX_H_
+#define _ICE_VF_MBX_H_
 
 #include "ice_type.h"
 #include "ice_controlq.h"
@@ -49,4 +49,4 @@ ice_conv_link_speed_to_virtchnl(bool __always_unused adv_link_support,
 }
 
 #endif /* CONFIG_PCI_IOV */
-#endif /* _ICE_SRIOV_H_ */
+#endif /* _ICE_VF_MBX_H_ */
-- 
2.31.1

