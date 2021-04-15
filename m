Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461C435FEE4
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 02:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbhDOA3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 20:29:12 -0400
Received: from mga12.intel.com ([192.55.52.136]:27426 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231536AbhDOA2v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 20:28:51 -0400
IronPort-SDR: c5evs6w1v99lJ3rN2p//GVzTcHwD1hINbnRngFo2L59RuSPYigOEsXd3pjvx8q2UC558l8+2rW
 5pcBE16DqO/w==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="174262249"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="174262249"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 17:28:27 -0700
IronPort-SDR: 5hisaCci6u4JMG1i2bxh6psd8cokFr08NHWeZV8PFZXQhAR1RHLybZHJuSuw2CJ+rj8nlAcUjd
 ZA2QY6B4ezXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="399379533"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 14 Apr 2021 17:28:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 12/15] ice: Set vsi->vf_id as ICE_INVAL_VFID for non VF VSI types
Date:   Wed, 14 Apr 2021 17:30:10 -0700
Message-Id: <20210415003013.19717-13-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
References: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently the vsi->vf_id is set only for ICE_VSI_VF and it's left as 0
for all other VSI types. This is confusing and could be problematic
since 0 is a valid vf_id. Fix this by always setting non VF VSI types to
ICE_INVAL_VFID.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 0443338f9eaf..eb6e352d3387 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -158,6 +158,8 @@ static void ice_vsi_set_num_qs(struct ice_vsi *vsi, u16 vf_id)
 
 	if (vsi->type == ICE_VSI_VF)
 		vsi->vf_id = vf_id;
+	else
+		vsi->vf_id = ICE_INVAL_VFID;
 
 	switch (vsi->type) {
 	case ICE_VSI_PF:
-- 
2.26.2

