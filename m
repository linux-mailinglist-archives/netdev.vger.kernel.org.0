Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D907D4D920D
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 02:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243525AbiCOBNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 21:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245470AbiCOBMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 21:12:49 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D05D46671
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 18:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647306698; x=1678842698;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nq7+GBa+ofJ2Y3NlrubeZ9NDO4UJH/Z208gWs/kEqW0=;
  b=D3TT/BfaRRLKJ0YOBgwmTlK0VReM81EUxEkL7iCmf/eY6OX1/Q2fA23p
   q/cNKGMqBgZcfv4eT7fFtaJuypmG/RujdvL7AqZ+PJ3CcX0M3DSpYnFFQ
   BtHY3k6VJK8VxfHkPkygR8vaSMawQJPI78kEX9kXKqA84C+9WsaabkTnC
   IzPGZJioD6qBFGv5dqmimc1JB5uaOm1Ltjk0zE8fjSUztgjEgkBtEmbEk
   nCSnGIMZKdmCTis/jo3QAN1gujitChURcIEq9I1FOXnCR496yOQac/jUI
   Nn4ZNULFu/OKrfrYOzot/ilOmT8AM23+XoUk3Ah7VxVxACHyAUxB8Klfb
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="256375077"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="256375077"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 18:11:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="540222883"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 14 Mar 2022 18:11:33 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next v2 03/11] ice: remove circular header dependencies on ice.h
Date:   Mon, 14 Mar 2022 18:11:47 -0700
Message-Id: <20220315011155.2166817-4-anthony.l.nguyen@intel.com>
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

Several headers in the ice driver include ice.h even though they are
themselves included by that header. The most notable of these is
ice_common.h, but several other headers also do this.

Such a recursive inclusion is problematic as it forces headers to be
included in a strict order, otherwise compilation errors can result. The
circular inclusions do not trigger an endless loop due to standard
header inclusion guards, however other errors can occur.

For example, ice_flow.h defines ice_rss_hash_cfg, which is used by
ice_sriov.h as part of the definition of ice_vf_hash_ip_ctx.

ice_flow.h includes ice_acl.h, which includes ice_common.h, and which
finally includes ice.h. Since ice.h itself includes ice_sriov.h, this
creates a circular dependency.

The definition in ice_sriov.h requires things from ice_flow.h, but
ice_flow.h itself will lead to trying to load ice_sriov.h as part of its
process for expanding ice.h. The current code avoids this issue by
having an implicit dependency without the include of ice_flow.h.

If we were to fix that so that ice_sriov.h explicitly depends on
ice_flow.h the following pattern would occur:

  ice_flow.h -> ice_acl.h -> ice_common.h -> ice.h -> ice_sriov.h

At this point, during the expansion of, the header guard for ice_flow.h
is already set, so when ice_sriov.h attempts to load the ice_flow.h
header it is skipped. Then, we go on to begin including the rest of
ice_sriov.h, including structure definitions which depend on
ice_rss_hash_cfg. This produces a compiler warning because
ice_rss_hash_cfg hasn't yet been included. Remember, we're just at the
start of ice_flow.h!

If the order of headers is incorrect (ice_flow.h is not implicitly
loaded first in all files which include ice_sriov.h) then we get the
same failure.

Removing this recursive inclusion requires fixing a few cases where some
headers depended on the header inclusions from ice.h. In addition, a few
other changes are also required.

Most notably, ice_hw_to_dev is implemented as a macro in ice_osdep.h,
which is the likely reason that ice_common.h includes ice.h at all. This
macro implementation requires the full definition of ice_pf in order to
properly compile.

Fix this by moving it to a function declared in ice_main.c, so that we
do not require all files to depend on the layout of the ice_pf
structure.

Note that this change only fixes circular dependencies, but it does not
fully resolve all implicit dependencies where one header may depend on
the inclusion of another. I tried to fix as many of the implicit
dependencies as I noticed, but fixing them all requires a somewhat
tedious analysis of each header and attempting to compile it separately.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h           |  3 ---
 drivers/net/ethernet/intel/ice/ice_arfs.h      |  3 +++
 drivers/net/ethernet/intel/ice/ice_common.h    |  4 ++--
 drivers/net/ethernet/intel/ice/ice_dcb.h       |  1 +
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c |  1 +
 drivers/net/ethernet/intel/ice/ice_flow.c      |  1 +
 drivers/net/ethernet/intel/ice/ice_flow.h      |  2 ++
 drivers/net/ethernet/intel/ice/ice_idc_int.h   |  1 -
 drivers/net/ethernet/intel/ice/ice_main.c      | 15 +++++++++++++++
 drivers/net/ethernet/intel/ice/ice_osdep.h     | 11 +++++++++--
 drivers/net/ethernet/intel/ice/ice_repr.h      |  1 -
 drivers/net/ethernet/intel/ice/ice_sriov.h     |  1 -
 drivers/net/ethernet/intel/ice/ice_type.h      |  1 +
 drivers/net/ethernet/intel/ice/ice_xsk.h       |  1 -
 14 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 24325df8dc7d..e9aa1fb43c3a 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -52,9 +52,6 @@
 #include <net/udp_tunnel.h>
 #include <net/vxlan.h>
 #include <net/gtp.h>
-#if IS_ENABLED(CONFIG_DCB)
-#include <scsi/iscsi_proto.h>
-#endif /* CONFIG_DCB */
 #include "ice_devids.h"
 #include "ice_type.h"
 #include "ice_txrx.h"
diff --git a/drivers/net/ethernet/intel/ice/ice_arfs.h b/drivers/net/ethernet/intel/ice/ice_arfs.h
index 80ed76f0cace..9669ad9bf7b5 100644
--- a/drivers/net/ethernet/intel/ice/ice_arfs.h
+++ b/drivers/net/ethernet/intel/ice/ice_arfs.h
@@ -3,6 +3,9 @@
 
 #ifndef _ICE_ARFS_H_
 #define _ICE_ARFS_H_
+
+#include "ice_fdir.h"
+
 enum ice_arfs_fltr_state {
 	ICE_ARFS_INACTIVE,
 	ICE_ARFS_ACTIVE,
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 1efe6b2c32f0..872ea7d2332d 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -6,12 +6,12 @@
 
 #include <linux/bitfield.h>
 
-#include "ice.h"
 #include "ice_type.h"
 #include "ice_nvm.h"
 #include "ice_flex_pipe.h"
-#include "ice_switch.h"
 #include <linux/avf/virtchnl.h>
+#include "ice_switch.h"
+#include "ice_fdir.h"
 
 #define ICE_SQ_SEND_DELAY_TIME_MS	10
 #define ICE_SQ_SEND_MAX_EXECUTE		3
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.h b/drivers/net/ethernet/intel/ice/ice_dcb.h
index d73348f279f7..6abf28a14291 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.h
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.h
@@ -5,6 +5,7 @@
 #define _ICE_DCB_H_
 
 #include "ice_type.h"
+#include <scsi/iscsi_proto.h>
 
 #define ICE_DCBX_STATUS_NOT_STARTED	0
 #define ICE_DCBX_STATUS_IN_PROGRESS	1
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 6a336e8d4e4d..c73cdab44f70 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -4,6 +4,7 @@
 #include "ice_common.h"
 #include "ice_flex_pipe.h"
 #include "ice_flow.h"
+#include "ice.h"
 
 /* For supporting double VLAN mode, it is necessary to enable or disable certain
  * boost tcam entries. The metadata labels names that match the following
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
index beed4838dcbe..ef103e47a8dc 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.c
+++ b/drivers/net/ethernet/intel/ice/ice_flow.c
@@ -3,6 +3,7 @@
 
 #include "ice_common.h"
 #include "ice_flow.h"
+#include <net/gre.h>
 
 /* Describe properties of a protocol header field */
 struct ice_flow_field_info {
diff --git a/drivers/net/ethernet/intel/ice/ice_flow.h b/drivers/net/ethernet/intel/ice/ice_flow.h
index 84b6e4464a21..b465d27d9b80 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.h
+++ b/drivers/net/ethernet/intel/ice/ice_flow.h
@@ -4,6 +4,8 @@
 #ifndef _ICE_FLOW_H_
 #define _ICE_FLOW_H_
 
+#include "ice_flex_type.h"
+
 #define ICE_FLOW_ENTRY_HANDLE_INVAL	0
 #define ICE_FLOW_FLD_OFF_INVAL		0xffff
 
diff --git a/drivers/net/ethernet/intel/ice/ice_idc_int.h b/drivers/net/ethernet/intel/ice/ice_idc_int.h
index b7796b8aecbd..4b0c86757df9 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc_int.h
+++ b/drivers/net/ethernet/intel/ice/ice_idc_int.h
@@ -5,7 +5,6 @@
 #define _ICE_IDC_INT_H_
 
 #include <linux/net/intel/iidc.h>
-#include "ice.h"
 
 struct ice_pf;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2694acb1aa01..61ea670c5cfe 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -48,6 +48,21 @@ static DEFINE_IDA(ice_aux_ida);
 DEFINE_STATIC_KEY_FALSE(ice_xdp_locking_key);
 EXPORT_SYMBOL(ice_xdp_locking_key);
 
+/**
+ * ice_hw_to_dev - Get device pointer from the hardware structure
+ * @hw: pointer to the device HW structure
+ *
+ * Used to access the device pointer from compilation units which can't easily
+ * include the definition of struct ice_pf without leading to circular header
+ * dependencies.
+ */
+struct device *ice_hw_to_dev(struct ice_hw *hw)
+{
+	struct ice_pf *pf = container_of(hw, struct ice_pf, hw);
+
+	return &pf->pdev->dev;
+}
+
 static struct workqueue_struct *ice_wq;
 static const struct net_device_ops ice_netdev_safe_mode_ops;
 static const struct net_device_ops ice_netdev_ops;
diff --git a/drivers/net/ethernet/intel/ice/ice_osdep.h b/drivers/net/ethernet/intel/ice/ice_osdep.h
index 380e8ae94fc9..82bc54fec7f3 100644
--- a/drivers/net/ethernet/intel/ice/ice_osdep.h
+++ b/drivers/net/ethernet/intel/ice/ice_osdep.h
@@ -5,7 +5,14 @@
 #define _ICE_OSDEP_H_
 
 #include <linux/types.h>
+#include <linux/ctype.h>
+#include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/bitops.h>
+#include <linux/ethtool.h>
+#include <linux/etherdevice.h>
+#include <linux/if_ether.h>
+#include <linux/pci_ids.h>
 #ifndef CONFIG_64BIT
 #include <linux/io-64-nonatomic-lo-hi.h>
 #endif
@@ -25,8 +32,8 @@ struct ice_dma_mem {
 	size_t size;
 };
 
-#define ice_hw_to_dev(ptr)	\
-	(&(container_of((ptr), struct ice_pf, hw))->pdev->dev)
+struct ice_hw;
+struct device *ice_hw_to_dev(struct ice_hw *hw);
 
 #ifdef CONFIG_DYNAMIC_DEBUG
 #define ice_debug(hw, type, fmt, args...) \
diff --git a/drivers/net/ethernet/intel/ice/ice_repr.h b/drivers/net/ethernet/intel/ice/ice_repr.h
index 0c77ff050d15..378a45bfa256 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.h
+++ b/drivers/net/ethernet/intel/ice/ice_repr.h
@@ -5,7 +5,6 @@
 #define _ICE_REPR_H_
 
 #include <net/dst_metadata.h>
-#include "ice.h"
 
 struct ice_repr {
 	struct ice_vsi *src_vsi;
diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.h b/drivers/net/ethernet/intel/ice/ice_sriov.h
index bf42f7792d68..a5ef3c46953a 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.h
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.h
@@ -3,7 +3,6 @@
 
 #ifndef _ICE_SRIOV_H_
 #define _ICE_SRIOV_H_
-#include "ice.h"
 #include "ice_virtchnl_fdir.h"
 #include "ice_vsi_vlan_ops.h"
 
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 28fcab26b868..f2a518a1fd94 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -9,6 +9,7 @@
 #define ICE_CHNL_MAX_TC		16
 
 #include "ice_hw_autogen.h"
+#include "ice_devids.h"
 #include "ice_osdep.h"
 #include "ice_controlq.h"
 #include "ice_lan_tx_rx.h"
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.h b/drivers/net/ethernet/intel/ice/ice_xsk.h
index 123bb98ebfbe..21faec8e97db 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.h
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.h
@@ -4,7 +4,6 @@
 #ifndef _ICE_XSK_H_
 #define _ICE_XSK_H_
 #include "ice_txrx.h"
-#include "ice.h"
 
 #define PKTS_PER_BATCH 8
 
-- 
2.31.1

