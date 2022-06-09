Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E803A5451EC
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 18:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244422AbiFIQ3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 12:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238095AbiFIQ3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 12:29:22 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEBA618F2F7
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 09:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654792161; x=1686328161;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1HoDkRbCT4RBitFqgJIkfznnaOPJTfoSt4ISJ9gxgwY=;
  b=GMsbqvP4/+73fs/KA/EHWkCY8G+yifTbKXN2PhkZutNnVqyJN8f4PEE+
   2ecJQAupIVlKgOuh0PMC4EumQI9XEDmzkAsQuCH/boCLfZS/4AEr7H+qw
   MjrfgUCMthyAa1UaDExtUTw0Nb24fLYh0yriZxMliBbPxCpv8oJBPqAYd
   oGrZdoNxUNSyE7MlSYRh1Aa1yA1nXA/JiD3a3UtgkehJlkdMvKneskCIf
   FtPeMRe9XIHO+70p0tqSP6yEHKickWbb4Qofg7t7zOcvg7d15jxaDPESH
   aNwXTrxfcOdGVhRNOo9NEPlJ453hYnbtsthiI1c0CgS7U6WHBQXwjm6os
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="278486082"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="278486082"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 09:29:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="615975886"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 09 Jun 2022 09:29:20 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Subject: [PATCH net 2/4] i40e: Fix calculating the number of queue pairs
Date:   Thu,  9 Jun 2022 09:26:18 -0700
Message-Id: <20220609162620.2619258-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220609162620.2619258-1-anthony.l.nguyen@intel.com>
References: <20220609162620.2619258-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>

If ADQ is enabled for a VF, then actual number of queue pair
is a number of currently available traffic classes for this VF.

Without this change the configuration of the Rx/Tx queues
fails with error.

Fixes: d29e0d233e0d ("i40e: missing input validation on VF message handling by the PF")
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 2606e8f0f19b..033ea71763e3 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2282,7 +2282,7 @@ static int i40e_vc_config_queues_msg(struct i40e_vf *vf, u8 *msg)
 	}
 
 	if (vf->adq_enabled) {
-		for (i = 0; i < I40E_MAX_VF_VSI; i++)
+		for (i = 0; i < vf->num_tc; i++)
 			num_qps_all += vf->ch[i].num_qps;
 		if (num_qps_all != qci->num_queue_pairs) {
 			aq_ret = I40E_ERR_PARAM;
-- 
2.35.1

