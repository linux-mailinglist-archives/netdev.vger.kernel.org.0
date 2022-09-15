Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0DA5B9C32
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 15:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiIONof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 09:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiIONoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 09:44:10 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59708E4DA
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 06:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663249446; x=1694785446;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Nke7d2x9Bvaff8axwb3NiFFBpszxvtpgar8miEokzLY=;
  b=gmItATAkiX+1qKYh7eZrLZgqdvup+VmXx60Ic6UeAz6jJ2W+BSJoLHlv
   gqX3n+Tn8riwoyQSYAExYQV1shpoLhmy2ajOflV1IA87hQtOvWtvZLe3G
   /eol22S5yHuQulFR3FmwiZ0OEOyBR9PO+UpCmtYHyrDFC7WMMaR5GYMf5
   qy2Pe4DzzP7iYdcLObXpEpoDBBPf526/OW3l4+wwrESsiKhJ2mL72W2/b
   wddlOtHU8a/nzsyk38Ifa2Y7n5f7sWybIFBPfG7bzETjWWxGGmRyn1Svq
   jk5h0IrPtbzObHebO6CoMhV2Ogl/otj5Y7TqcdQalhrkDo2mSy/BV/Xg4
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="279100043"
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="279100043"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 06:44:06 -0700
X-IronPort-AV: E=Sophos;i="5.93,318,1654585200"; 
   d="scan'208";a="617279008"
Received: from unknown (HELO DCG-LAB-MODULE2.gar.corp.intel.com) ([10.123.220.6])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 06:44:04 -0700
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, dchumak@nvidia.com, maximmi@nvidia.com,
        jiri@resnulli.us, simon.horman@corigine.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [RFC PATCH net-next v4 5/6] ice: Export Tx scheduler configuration to devlink-rate
Date:   Thu, 15 Sep 2022 15:42:38 +0200
Message-Id: <20220915134239.1935604-6-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220915134239.1935604-1-michal.wilczynski@intel.com>
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a need to export Tx scheduler configuration to devlink-rate
kernel mechanism. We also need a complete list of queues in the
scheduling topology. Unfortunately, when the reset happens
ice_sched_node objects that represents queues are re-created. This
forces us to re-initialize devlink-rate representation of the driver Tx
scheduler tree.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index 2b4c791b6cba..0f0a03b7725e 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -12,6 +12,7 @@
 #include "ice_vlan.h"
 #include "ice_flex_pipe.h"
 #include "ice_dcb_lib.h"
+#include "ice_devlink.h"
 
 #define FIELD_SELECTOR(proto_hdr_field) \
 		BIT((proto_hdr_field) & PROTO_HDR_FIELD_MASK)
@@ -1597,6 +1598,7 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 	    (struct virtchnl_vsi_queue_config_info *)msg;
 	struct virtchnl_queue_pair_info *qpi;
 	struct ice_pf *pf = vf->pf;
+	struct devlink *devlink;
 	struct ice_vsi *vsi;
 	int i = -1, q_idx;
 
@@ -1655,6 +1657,14 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 			}
 		}
 
+		devlink = priv_to_devlink(pf);
+
+		devl_lock(devlink);
+		devl_rate_objects_destroy(devlink);
+		devl_unlock(devlink);
+
+		ice_devlink_rate_init_tx_topology(devlink, ice_get_main_vsi(pf));
+
 		/* copy Rx queue info from VF into VSI */
 		if (qpi->rxq.ring_len > 0) {
 			u16 max_frame_size = ice_vc_get_max_frame_size(vf);
-- 
2.37.2

