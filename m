Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9124D8B75
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 19:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243660AbiCNSL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 14:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243616AbiCNSLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 14:11:13 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277563ED28
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 11:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647281401; x=1678817401;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BXOXQyDR4nuz6yLVve9ZwmKD57om3oidLdTRhzKj92U=;
  b=CG86HpcBpRDPcwrEYj9BBa+O/55sbSbZR29lZQiP6XY1eS9NmsEZfEmx
   qov7pXLn+caUMK5fEYewQRrX7Nuk837VQ7wTIccJXcJ1Hhjs3u0XrZYlm
   N0AurB3IoQvWR15c6TNdIrK163nkuzUn3eMNkuMOOmxMq+kvhW89SSCVA
   iYwZfLvFHVv9P/2ZSBVlVpt04WDEmgrdiUN11/FfqA1h3U/V+RFmzB+3J
   VO/yyDBSoy2vWMOeB0AdHcoTbmWnlK7YthkP7UW4phHtQNv489IcHxp83
   huHr1M5mmeEI7dvW51t9M1TmIq38jUVBx1kj5DWPIEXnhoTGU1K8Vn5lh
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="238275379"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="238275379"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 11:10:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="634297614"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Mar 2022 11:09:59 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 13/25] ice: fix incorrect dev_dbg print mistaking 'i' for vf->vf_id
Date:   Mon, 14 Mar 2022 11:10:04 -0700
Message-Id: <20220314181016.1690595-14-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220314181016.1690595-1-anthony.l.nguyen@intel.com>
References: <20220314181016.1690595-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

If we fail to clear the malicious VF indication after a VF reset, the
dev_dbg message which is printed uses the local variable 'i' when it
meant to use vf->vf_id. Fix this.

Fixes: 0891c89674e8 ("ice: warn about potentially malicious VFs")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sriov.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sriov.c b/drivers/net/ethernet/intel/ice/ice_sriov.c
index 2f74fcf51c2c..91d106528b66 100644
--- a/drivers/net/ethernet/intel/ice/ice_sriov.c
+++ b/drivers/net/ethernet/intel/ice/ice_sriov.c
@@ -1381,7 +1381,8 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	/* if the VF has been reset allow it to come up again */
 	if (ice_mbx_clear_malvf(&hw->mbx_snapshot, pf->vfs.malvfs,
 				ICE_MAX_SRIOV_VFS, vf->vf_id))
-		dev_dbg(dev, "failed to clear malicious VF state for VF %u\n", i);
+		dev_dbg(dev, "failed to clear malicious VF state for VF %u\n",
+			vf->vf_id);
 
 	return true;
 }
-- 
2.31.1

