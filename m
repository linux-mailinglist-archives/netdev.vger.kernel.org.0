Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4C4263A06
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730770AbgIJCRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:17:25 -0400
Received: from mga14.intel.com ([192.55.52.115]:25791 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730555AbgIJCO7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 22:14:59 -0400
IronPort-SDR: Cc2xTSmZejgluqUzm45+gca3yJ2ZyAvKXCcUjV/DE3YR2uAT4OfKSCJhNpFsa8tMkFkUbxFlub
 aYfmKjTet6Nw==
X-IronPort-AV: E=McAfee;i="6000,8403,9739"; a="157721717"
X-IronPort-AV: E=Sophos;i="5.76,411,1592895600"; 
   d="scan'208";a="157721717"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 17:04:23 -0700
IronPort-SDR: WFXqPQOLROIwyBNOFErvrpAa1FnYn1HZaIEJQ/8p1GVjrM8d93YsykywPmhTgKNKRDbWrbUoLP
 26nod1Ery7vw==
X-IronPort-AV: E=Sophos;i="5.76,411,1592895600"; 
   d="scan'208";a="341733834"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2020 17:04:22 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Stefan Assmann <sassmann@kpanic.de>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Michal Schmidt <mschmidt@redhat.com>,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net 2/4] i40e: always propagate error value in i40e_set_vsi_promisc()
Date:   Wed,  9 Sep 2020 17:04:09 -0700
Message-Id: <20200910000411.2658780-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200910000411.2658780-1-anthony.l.nguyen@intel.com>
References: <20200910000411.2658780-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

The for loop in i40e_set_vsi_promisc() reports errors via dev_err() but
does not propagate the error up the call chain. Instead it continues the
loop and potentially overwrites the reported error value.
This results in the error being recorded in the log buffer, but the
caller might never know anything went the wrong way.

To avoid this situation i40e_set_vsi_promisc() needs to temporarily store
the error after reporting it. This is still not optimal as multiple
different errors may occur, so store the first error and hope that's
the main issue.

Fixes: 37d318d7805f (i40e: Remove scheduling while atomic possibility)
Reported-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 5defcb777e92..47bfb2e95e2d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -1171,9 +1171,9 @@ static i40e_status
 i40e_set_vsi_promisc(struct i40e_vf *vf, u16 seid, bool multi_enable,
 		     bool unicast_enable, s16 *vl, u16 num_vlans)
 {
+	i40e_status aq_ret, aq_tmp = 0;
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_hw *hw = &pf->hw;
-	i40e_status aq_ret;
 	int i;
 
 	/* No VLAN to set promisc on, set on VSI */
@@ -1222,6 +1222,9 @@ i40e_set_vsi_promisc(struct i40e_vf *vf, u16 seid, bool multi_enable,
 				vf->vf_id,
 				i40e_stat_str(&pf->hw, aq_ret),
 				i40e_aq_str(&pf->hw, aq_err));
+
+			if (!aq_tmp)
+				aq_tmp = aq_ret;
 		}
 
 		aq_ret = i40e_aq_set_vsi_uc_promisc_on_vlan(hw, seid,
@@ -1235,8 +1238,15 @@ i40e_set_vsi_promisc(struct i40e_vf *vf, u16 seid, bool multi_enable,
 				vf->vf_id,
 				i40e_stat_str(&pf->hw, aq_ret),
 				i40e_aq_str(&pf->hw, aq_err));
+
+			if (!aq_tmp)
+				aq_tmp = aq_ret;
 		}
 	}
+
+	if (aq_tmp)
+		aq_ret = aq_tmp;
+
 	return aq_ret;
 }
 
-- 
2.26.2

