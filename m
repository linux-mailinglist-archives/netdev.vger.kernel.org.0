Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B6439BC9C
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 18:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhFDQMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 12:12:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:21972 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230049AbhFDQMR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 12:12:17 -0400
IronPort-SDR: Ohm03s6waftkspaRS9k5aBX2p/XH6Q6tYnvcDi9fsb6O+Bi39rfm4MDqCDQcH2/2nxQyUgEfML
 vq6m4Qc+SkqA==
X-IronPort-AV: E=McAfee;i="6200,9189,10005"; a="201299741"
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="201299741"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 09:06:04 -0700
IronPort-SDR: xiP/lkf9eOTmUxuiLMMEInX1ZbVFEUAHKWzDn2zRpqo9Fu9fZLqsOYCRgG0/GWVaDBB/mY9N85
 H9ll9kWCXnkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="475511681"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Jun 2021 09:05:49 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 1/6] ice: Fix allowing VF to request more/less queues via virtchnl
Date:   Fri,  4 Jun 2021 09:08:11 -0700
Message-Id: <20210604160816.3391716-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210604160816.3391716-1-anthony.l.nguyen@intel.com>
References: <20210604160816.3391716-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Commit 12bb018c538c ("ice: Refactor VF reset") caused a regression
that removes the ability for a VF to request a different amount of
queues via VIRTCHNL_OP_REQUEST_QUEUES. This prevents VF drivers to
either increase or decrease the number of queue pairs they are
allocated. Fix this by using the variable vf->num_req_qs when
determining the vf->num_vf_qs during VF VSI creation.

Fixes: 12bb018c538c ("ice: Refactor VF reset")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 7f7653906fce..d70ee573fde5 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -200,6 +200,8 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi, u16 vf_id)
 		break;
 	case ICE_VSI_VF:
 		vf = &pf->vf[vsi->vf_id];
+		if (vf->num_req_qs)
+			vf->num_vf_qs = vf->num_req_qs;
 		vsi->alloc_txq = vf->num_vf_qs;
 		vsi->alloc_rxq = vf->num_vf_qs;
 		/* pf->num_msix_per_vf includes (VF miscellaneous vector +
-- 
2.26.2

