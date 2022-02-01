Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC6F4A53B8
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 01:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbiBAAFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 19:05:39 -0500
Received: from mga04.intel.com ([192.55.52.120]:65448 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230008AbiBAAFi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 19:05:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643673938; x=1675209938;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=25y7iU2DdNS32SL9Y9avfhtljBeY2ZQS/appRDE4o7g=;
  b=VxBhfQb4Z0Y4qyL51mjOpLnlVYV4qmt+jw/AEXShYmNWuax6dpBWMjxx
   THdEwR84JJ3oqZ1mm6pO+GtYAPgvUBj//nUWoFAKFOfus4IAynUmdlY0r
   AbY+/OLR2eP5/FNEGR7unI2PcVWbMYoc0tKtNIncWaB8azgzs3+zx0aGi
   dtb6Wg3zzMiH7fnLdZugO43lad8FAHUreDPykjXlvPAKVkZQN42Vyn2wM
   Gx0sIjhJTIV7HbiF8atp1dJ74TVqEb2LciE/isoJsYvxpEjUU0Jk5GTEg
   QzFOrdF5Nk6F9gDvENVEWup5yLy+4cJL7twe8BSlJzqxAwW+YEcdU9xSD
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="246417048"
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="246417048"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 16:05:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="698209559"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 31 Jan 2022 16:05:37 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Imam Hassan Reza Biswas <imam.hassan.reza.biswas@intel.com>
Subject: [PATCH net 1/2] i40e: Fix reset bw limit when DCB enabled with 1 TC
Date:   Mon, 31 Jan 2022 16:05:21 -0800
Message-Id: <20220201000522.505909-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220201000522.505909-1-anthony.l.nguyen@intel.com>
References: <20220201000522.505909-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

There was an AQ error I40E_AQ_RC_EINVAL when trying
to reset bw limit as part of bw allocation setup.
This was caused by trying to reset bw limit with
DCB enabled. Bw limit should not be reset when
DCB is enabled. The code was relying on the pf->flags
to check if DCB is enabled but if only 1 TC is available
this flag will not be set even though DCB is enabled.
Add a check for number of TC and if it is 1
don't try to reset bw limit even if pf->flags shows
DCB as disabled.

Fixes: fa38e30ac73f ("i40e: Fix for Tx timeouts when interface is brought up if DCB is enabled")
Suggested-by: Alexander Lobakin <alexandr.lobakin@intel.com> # Flatten the condition
Signed-off-by: Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Tested-by: Imam Hassan Reza Biswas <imam.hassan.reza.biswas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index f70c478dafdb..5cb4dc69fe87 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5372,7 +5372,15 @@ static int i40e_vsi_configure_bw_alloc(struct i40e_vsi *vsi, u8 enabled_tc,
 	/* There is no need to reset BW when mqprio mode is on.  */
 	if (pf->flags & I40E_FLAG_TC_MQPRIO)
 		return 0;
-	if (!vsi->mqprio_qopt.qopt.hw && !(pf->flags & I40E_FLAG_DCB_ENABLED)) {
+
+	if (!vsi->mqprio_qopt.qopt.hw) {
+		if (pf->flags & I40E_FLAG_DCB_ENABLED)
+			goto skip_reset;
+
+		if (IS_ENABLED(CONFIG_I40E_DCB) &&
+		    i40e_dcb_hw_get_num_tc(&pf->hw) == 1)
+			goto skip_reset;
+
 		ret = i40e_set_bw_limit(vsi, vsi->seid, 0);
 		if (ret)
 			dev_info(&pf->pdev->dev,
@@ -5380,6 +5388,8 @@ static int i40e_vsi_configure_bw_alloc(struct i40e_vsi *vsi, u8 enabled_tc,
 				 vsi->seid);
 		return ret;
 	}
+
+skip_reset:
 	memset(&bw_data, 0, sizeof(bw_data));
 	bw_data.tc_valid_bits = enabled_tc;
 	for (i = 0; i < I40E_MAX_TRAFFIC_CLASS; i++)
-- 
2.31.1

