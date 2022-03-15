Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19B94D920B
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 02:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243225AbiCOBMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 21:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234023AbiCOBMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 21:12:48 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51094667D
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 18:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647306697; x=1678842697;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YJiKnYuUwUuH+pMq5jWSrLufR5N0avguQnUXrUJI2jk=;
  b=lNd6lC/tCbmexPcpWR/3S4irs8OXOdCB/xdqw2sPBTl9DjDfdbuzUPgU
   HKmhFEDdyardKvxag4wqXfcCcdZHRX+q9goQRoCKihH2eRlxkl+I8eGBO
   J6LFQXgIFF4q5r86sS42Ud/jotV+Rd1HY8cExEvQVfLrsRDT4Y6v0uyFS
   A/6q/2HO5oVYjOJWglFXk2fvpti6CQdFHhj4zS0B06ikrYp0+3jgZK2q0
   GytHAJVzDrLe9oppl8RuMFsCnDNM3mJlJD+Mz/cpqVGM2jqW+N86icsDH
   kQKdfmw0tdsUIHejdasX43u1EweTYa+zY/ZkwPsLwpxdJjimEMWEONZY0
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="256375076"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="256375076"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 18:11:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="540222880"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 14 Mar 2022 18:11:32 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next v2 02/11] ice: rename ice_virtchnl_pf.c to ice_sriov.c
Date:   Mon, 14 Mar 2022 18:11:46 -0700
Message-Id: <20220315011155.2166817-3-anthony.l.nguyen@intel.com>
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

The ice_virtchnl_pf.c and ice_virtchnl_pf.h files are where most of the
code for implementing Single Root IOV virtualization resides. This code
includes support for bringing up and tearing down VFs, hooks into the
kernel SR-IOV netdev operations, and for handling virtchnl messages from
VFs.

In the future, we plan to support Scalable IOV in addition to Single
Root IOV as an alternative virtualization scheme. This implementation
will re-use some but not all of the code in ice_virtchnl_pf.c

To prepare for this future, we want to refactor and split up the code in
ice_virtchnl_pf.c into the following scheme:

 * ice_vf_lib.[ch]

   Basic VF structures and accessors. This is where scheme-independent
   code will reside.

 * ice_virtchnl.[ch]

   Virtchnl message handling. This is where the bulk of the logic for
   processing messages from VFs using the virtchnl messaging scheme will
   reside. This is separated from ice_vf_lib.c because it is distinct
   and has a bulk of the processing code.

 * ice_sriov.[ch]

   Single Root IOV implementation, including initialization and the
   routines for interacting with SR-IOV based netdev operations.

 * (future) ice_siov.[ch]

   Scalable IOV implementation.

As a first step, lets assume that all of the code in
ice_virtchnl_pf.[ch] is for Single Root IOV. Rename this file to
ice_sriov.c and its header to ice_sriov.h

Future changes will further split out the code in these files following
the plan outlined here.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/Makefile                     | 2 +-
 drivers/net/ethernet/intel/ice/ice.h                        | 2 +-
 drivers/net/ethernet/intel/ice/ice_base.c                   | 2 +-
 drivers/net/ethernet/intel/ice/ice_repr.c                   | 2 +-
 .../ethernet/intel/ice/{ice_virtchnl_pf.c => ice_sriov.c}   | 0
 .../ethernet/intel/ice/{ice_virtchnl_pf.h => ice_sriov.h}   | 6 +++---
 drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c        | 2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)
 rename drivers/net/ethernet/intel/ice/{ice_virtchnl_pf.c => ice_sriov.c} (100%)
 rename drivers/net/ethernet/intel/ice/{ice_virtchnl_pf.h => ice_sriov.h} (99%)

diff --git a/drivers/net/ethernet/intel/ice/Makefile b/drivers/net/ethernet/intel/ice/Makefile
index 451098e25023..816e81832b7f 100644
--- a/drivers/net/ethernet/intel/ice/Makefile
+++ b/drivers/net/ethernet/intel/ice/Makefile
@@ -38,7 +38,7 @@ ice-$(CONFIG_PCI_IOV) +=	\
 	ice_virtchnl_fdir.o	\
 	ice_vf_mbx.o		\
 	ice_vf_vsi_vlan_ops.o	\
-	ice_virtchnl_pf.o
+	ice_sriov.o
 ice-$(CONFIG_PTP_1588_CLOCK) += ice_ptp.o ice_ptp_hw.o
 ice-$(CONFIG_TTY) += ice_gnss.o
 ice-$(CONFIG_DCB) += ice_dcb.o ice_dcb_nl.o ice_dcb_lib.o
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 9449ee2322b7..24325df8dc7d 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -64,7 +64,7 @@
 #include "ice_flow.h"
 #include "ice_sched.h"
 #include "ice_idc_int.h"
-#include "ice_virtchnl_pf.h"
+#include "ice_sriov.h"
 #include "ice_vf_mbx.h"
 #include "ice_ptp.h"
 #include "ice_fdir.h"
diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
index a3094470d31d..136d7911adb4 100644
--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -5,7 +5,7 @@
 #include "ice_base.h"
 #include "ice_lib.h"
 #include "ice_dcb_lib.h"
-#include "ice_virtchnl_pf.h"
+#include "ice_sriov.h"
 
 static bool ice_alloc_rx_buf_zc(struct ice_rx_ring *rx_ring)
 {
diff --git a/drivers/net/ethernet/intel/ice/ice_repr.c b/drivers/net/ethernet/intel/ice/ice_repr.c
index f8db3ca521da..e0be27657569 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.c
+++ b/drivers/net/ethernet/intel/ice/ice_repr.c
@@ -4,7 +4,7 @@
 #include "ice.h"
 #include "ice_eswitch.h"
 #include "ice_devlink.h"
-#include "ice_virtchnl_pf.h"
+#include "ice_sriov.h"
 #include "ice_tc_lib.h"
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
similarity index 100%
rename from drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
rename to drivers/net/ethernet/intel/ice/ice_sriov.c
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_sriov.h
similarity index 99%
rename from drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
rename to drivers/net/ethernet/intel/ice/ice_sriov.h
index 7f16ed9c70d6..bf42f7792d68 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (c) 2018, Intel Corporation. */
 
-#ifndef _ICE_VIRTCHNL_PF_H_
-#define _ICE_VIRTCHNL_PF_H_
+#ifndef _ICE_SRIOV_H_
+#define _ICE_SRIOV_H_
 #include "ice.h"
 #include "ice_virtchnl_fdir.h"
 #include "ice_vsi_vlan_ops.h"
@@ -434,4 +434,4 @@ static inline bool ice_vf_is_port_vlan_ena(struct ice_vf __always_unused *vf)
 	return false;
 }
 #endif /* CONFIG_PCI_IOV */
-#endif /* _ICE_VIRTCHNL_PF_H_ */
+#endif /* _ICE_SRIOV_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c b/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
index b16f946185f2..5ecc0ee9a78e 100644
--- a/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
+++ b/drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
@@ -6,7 +6,7 @@
 #include "ice_vlan_mode.h"
 #include "ice.h"
 #include "ice_vf_vsi_vlan_ops.h"
-#include "ice_virtchnl_pf.h"
+#include "ice_sriov.h"
 
 static int
 noop_vlan_arg(struct ice_vsi __always_unused *vsi,
-- 
2.31.1

