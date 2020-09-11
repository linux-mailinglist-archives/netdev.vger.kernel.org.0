Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B85267681
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 01:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgIKXYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 19:24:10 -0400
Received: from mga06.intel.com ([134.134.136.31]:17602 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbgIKXWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 19:22:16 -0400
IronPort-SDR: QinarTd4lHNplZk9T0c+Bke8jDoCxJM1ECKpNWLEFHoTt7hp0a/qZ7n8Zk3Pb6Y/nYipKIDiaP
 61mzfYPed5mg==
X-IronPort-AV: E=McAfee;i="6000,8403,9741"; a="220426161"
X-IronPort-AV: E=Sophos;i="5.76,418,1592895600"; 
   d="scan'208";a="220426161"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 16:22:13 -0700
IronPort-SDR: Zs7G3ORumwk8iZUH35NTL6MjE6HQLVYYwr3KPokE49ogR49gjZT7jLZ2hS2AH3AYMX9R2fl4r/
 aw+tCtIFaIQQ==
X-IronPort-AV: E=Sophos;i="5.76,418,1592895600"; 
   d="scan'208";a="505656584"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 16:22:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Stefan Assmann <sassmann@kpanic.de>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        Michal Schmidt <mschmidt@redhat.com>,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [RESEND net 2/4] i40e: always propagate error value in i40e_set_vsi_promisc()
Date:   Fri, 11 Sep 2020 16:22:05 -0700
Message-Id: <20200911232207.3417169-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200911232207.3417169-1-anthony.l.nguyen@intel.com>
References: <20200911232207.3417169-1-anthony.l.nguyen@intel.com>
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

