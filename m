Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176611E711F
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 02:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438031AbgE2AJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 20:09:09 -0400
Received: from mga07.intel.com ([134.134.136.100]:40391 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437976AbgE2AIf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 20:08:35 -0400
IronPort-SDR: gnZX50WTe7gOwLlASJHE/+p3HvluOH5ttBmqnpL5QFVlAlzAhMRsTnuh9gntBjZDkPTf2gqoUp
 Xh6t8r9i394A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 17:08:34 -0700
IronPort-SDR: t3rHJEidJCNNwFxGNyr3x8B4mt9LzqhU2Z2JSFCfyOXshqRgVACuXQd24JgBm8JfPKCQmL310Q
 J43/THdD5hwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,446,1583222400"; 
   d="scan'208";a="302651649"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 28 May 2020 17:08:34 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/15] ice: Add function to set trust mode bit on reset
Date:   Thu, 28 May 2020 17:08:27 -0700
Message-Id: <20200529000831.2803870-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529000831.2803870-1-jeffrey.t.kirsher@intel.com>
References: <20200529000831.2803870-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

As the title says, use a function to set trust mode bit on reset.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c    | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 92a442ec7314..4005a4caf2f0 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -610,6 +610,18 @@ static int ice_alloc_vsi_res(struct ice_vf *vf)
 	return status;
 }
 
+/**
+ * ice_vf_set_host_trust_cfg - set trust setting based on pre-reset value
+ * @vf: VF to configure trust setting for
+ */
+static void ice_vf_set_host_trust_cfg(struct ice_vf *vf)
+{
+	if (vf->trusted)
+		set_bit(ICE_VIRTCHNL_VF_CAP_PRIVILEGE, &vf->vf_caps);
+	else
+		clear_bit(ICE_VIRTCHNL_VF_CAP_PRIVILEGE, &vf->vf_caps);
+}
+
 /**
  * ice_alloc_vf_res - Allocate VF resources
  * @vf: pointer to the VF structure
@@ -635,10 +647,7 @@ static int ice_alloc_vf_res(struct ice_vf *vf)
 	if (status)
 		goto ice_alloc_vf_res_exit;
 
-	if (vf->trusted)
-		set_bit(ICE_VIRTCHNL_VF_CAP_PRIVILEGE, &vf->vf_caps);
-	else
-		clear_bit(ICE_VIRTCHNL_VF_CAP_PRIVILEGE, &vf->vf_caps);
+	ice_vf_set_host_trust_cfg(vf);
 
 	/* VF is now completely initialized */
 	set_bit(ICE_VF_STATE_INIT, vf->vf_states);
-- 
2.26.2

