Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5249D3685EA
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 19:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238690AbhDVRaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 13:30:22 -0400
Received: from mga03.intel.com ([134.134.136.65]:60039 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238305AbhDVRaM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 13:30:12 -0400
IronPort-SDR: Jkr/7VwHa6/PzjvgEYxCNeVP76dsH8UKb0/zUu6TbWrymWe3jis8sUi7chDQl7f0cccNgM3cfS
 W0JVmxPpYPJA==
X-IronPort-AV: E=McAfee;i="6200,9189,9962"; a="195991479"
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="195991479"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2021 10:29:35 -0700
IronPort-SDR: TcO1sd5y+U55yagO6/6U5a/2dytB85tQgHJy9R3hbKpgjVmqEiMlzczJE3sFV8ejZzaSBcIfUc
 YSiktt0I/Bug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,243,1613462400"; 
   d="scan'208";a="535286268"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 22 Apr 2021 10:29:35 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 03/12] ice: Advertise virtchnl UDP segmentation offload capability
Date:   Thu, 22 Apr 2021 10:31:21 -0700
Message-Id: <20210422173130.1143082-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210422173130.1143082-1-anthony.l.nguyen@intel.com>
References: <20210422173130.1143082-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

As the hardware is capable of supporting UDP segmentation offload, add a
capability bit to virtchnl.h to communicate this and have the driver
advertise its support.

Suggested-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 3 +++
 include/linux/avf/virtchnl.h                     | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index ccd6b3e8a5a9..1292a0b06eb5 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2118,6 +2118,9 @@ static int ice_vc_get_vf_res_msg(struct ice_vf *vf, u8 *msg)
 	if (vf->driver_caps & VIRTCHNL_VF_CAP_ADV_LINK_SPEED)
 		vfres->vf_cap_flags |= VIRTCHNL_VF_CAP_ADV_LINK_SPEED;
 
+	if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_USO)
+		vfres->vf_cap_flags |= VIRTCHNL_VF_OFFLOAD_USO;
+
 	vfres->num_vsis = 1;
 	/* Tx and Rx queue are equal for VF */
 	vfres->num_queue_pairs = vsi->num_txq;
diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index debdd196773b..9e0341cf2c36 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -251,6 +251,7 @@ VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_vsi_resource);
 #define VIRTCHNL_VF_OFFLOAD_ENCAP_CSUM		0X00200000
 #define VIRTCHNL_VF_OFFLOAD_RX_ENCAP_CSUM	0X00400000
 #define VIRTCHNL_VF_OFFLOAD_ADQ			0X00800000
+#define VIRTCHNL_VF_OFFLOAD_USO			0X02000000
 #define VIRTCHNL_VF_OFFLOAD_FDIR_PF		0X10000000
 
 /* Define below the capability flags that are not offloads */
-- 
2.26.2

