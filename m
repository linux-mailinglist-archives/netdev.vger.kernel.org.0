Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE77539BC9E
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 18:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhFDQMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 12:12:30 -0400
Received: from mga17.intel.com ([192.55.52.151]:3595 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230034AbhFDQMa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 12:12:30 -0400
IronPort-SDR: RmigRTlQ2NSDVE1TLai8ypPrXUBPAEpsSyVfzbxEf0L83J1fIHraTD9JpIP8diN7rIYBF3n/zq
 bqb7+A+6XPmw==
X-IronPort-AV: E=McAfee;i="6200,9189,10005"; a="184689332"
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="184689332"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2021 09:06:04 -0700
IronPort-SDR: y+NpWE0YBZIicEobrBbtIHXciGVOvvJaJOw5+daqzw/tHUrHbps74N/ca99MvEapNMfBVHgPof
 D11hGfixgx1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="475511732"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Jun 2021 09:05:50 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Haiyue Wang <haiyue.wang@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 3/6] ice: handle the VF VSI rebuild failure
Date:   Fri,  4 Jun 2021 09:08:13 -0700
Message-Id: <20210604160816.3391716-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210604160816.3391716-1-anthony.l.nguyen@intel.com>
References: <20210604160816.3391716-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyue Wang <haiyue.wang@intel.com>

VSI rebuild can be failed for LAN queue config, then the VF's VSI will
be NULL, the VF reset should be stopped with the VF entering into the
disable state.

Fixes: 12bb018c538c ("ice: Refactor VF reset")
Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 944d861c8579..97a46c616aca 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1700,7 +1700,12 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 		ice_vf_ctrl_vsi_release(vf);
 
 	ice_vf_pre_vsi_rebuild(vf);
-	ice_vf_rebuild_vsi_with_release(vf);
+
+	if (ice_vf_rebuild_vsi_with_release(vf)) {
+		dev_err(dev, "Failed to release and setup the VF%u's VSI\n", vf->vf_id);
+		return false;
+	}
+
 	ice_vf_post_vsi_rebuild(vf);
 
 	/* if the VF has been reset allow it to come up again */
-- 
2.26.2

