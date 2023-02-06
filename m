Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0DB68C8E9
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 22:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjBFVsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 16:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjBFVsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 16:48:54 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849FC298D8
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675720133; x=1707256133;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2VvjtjyzbScbSIfybI0cx422NbIKoY0+wcbKWQqmZOs=;
  b=VfHOfFHLk3llrPuXSwZ31ler8FrwZ7PWn9BOow++FZ4kY9CX+CcMqVwA
   7u0gsZgw/n7ZIpqVHiFi6/EFXLdOJkBPfacdVHF4e/Y9YGkaUF/CnliJq
   KRa9BgOJqRintg+Fp7ULCxurmK5/cnP7OXox0QvD5LPLxllTCytzBQFZq
   afT0Hj7/6QNN+QmXyd2QGWiWVxKgvBxL5FtkFxhq4MZ5H2MwQW8tYD/AD
   I4iotb+6M+FrpIeyejZ2RgFSeynH5aMRNqbQprc9u8NQHZcMWpIfBcfwx
   0XK4eMokw6e6pMECq/yV9qEWBTulrkkjvWmTqgP89eo88CIxJO7pNw1rA
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="317338091"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="317338091"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 13:48:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="616576180"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="616576180"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga003.jf.intel.com with ESMTP; 06 Feb 2023 13:48:32 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Kalyan Kodamagula <kalyan.kodamagula@intel.com>,
        Piotr Tyda <piotr.tyda@intel.com>
Subject: [PATCH net-next 01/13] ice: Add more usage of existing function ice_get_vf_vsi(vf)
Date:   Mon,  6 Feb 2023 13:48:01 -0800
Message-Id: <20230206214813.20107-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230206214813.20107-1-anthony.l.nguyen@intel.com>
References: <20230206214813.20107-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Extend the usage of function ice_get_vf_vsi(vf) in multiple places
instead of VF's VSI by using a long string of dereferences
(i.e. vf->pf->vsi[vf->lan_vsi_idx]).

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Kalyan Kodamagula <kalyan.kodamagula@intel.com>
Tested-by: Piotr Tyda <piotr.tyda@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
index c6a58343d81d..e6ef6b303222 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
@@ -113,7 +113,7 @@ ice_vc_fdir_param_check(struct ice_vf *vf, u16 vsi_id)
 	if (!ice_vc_isvalid_vsi_id(vf, vsi_id))
 		return -EINVAL;
 
-	if (!pf->vsi[vf->lan_vsi_idx])
+	if (!ice_get_vf_vsi(vf))
 		return -EINVAL;
 
 	return 0;
@@ -494,7 +494,7 @@ ice_vc_fdir_rem_prof(struct ice_vf *vf, enum ice_fltr_ptype flow, int tun)
 
 	vf_prof = fdir->fdir_prof[flow];
 
-	vf_vsi = pf->vsi[vf->lan_vsi_idx];
+	vf_vsi = ice_get_vf_vsi(vf);
 	if (!vf_vsi) {
 		dev_dbg(dev, "NULL vf %d vsi pointer\n", vf->vf_id);
 		return;
@@ -572,7 +572,7 @@ ice_vc_fdir_write_flow_prof(struct ice_vf *vf, enum ice_fltr_ptype flow,
 	pf = vf->pf;
 	dev = ice_pf_to_dev(pf);
 	hw = &pf->hw;
-	vf_vsi = pf->vsi[vf->lan_vsi_idx];
+	vf_vsi = ice_get_vf_vsi(vf);
 	if (!vf_vsi)
 		return -EINVAL;
 
@@ -1205,7 +1205,7 @@ static int ice_vc_fdir_write_fltr(struct ice_vf *vf,
 	pf = vf->pf;
 	dev = ice_pf_to_dev(pf);
 	hw = &pf->hw;
-	vsi = pf->vsi[vf->lan_vsi_idx];
+	vsi = ice_get_vf_vsi(vf);
 	if (!vsi) {
 		dev_dbg(dev, "Invalid vsi for VF %d\n", vf->vf_id);
 		return -EINVAL;
-- 
2.38.1

