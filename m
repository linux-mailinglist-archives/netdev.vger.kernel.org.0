Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAA06D6A91
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 19:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236338AbjDDR2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 13:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236286AbjDDR23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 13:28:29 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498795FDC
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 10:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680629209; x=1712165209;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GS5irId0q7EnhVS1eMvK82nWXXKrTNznIMhOVpIHA58=;
  b=IzMm61E8QiLIwN0T8icqeGYETqHZj7Yj/bZj/e0mOuL8EWAE6/+yaUrV
   ZdRFBSZXtgEZusWqRUSVqUJL0rXxotn/bA9StdgzNI2xaerwZpwul1xmq
   1IZgHM+RzK5Utm7LKRCGs1asBie8+ZuSGOETmp3HqGhqwTuMHutKfmT2U
   pBG/GeZaJm3bbs4/zJFgvoEvjDwbhUeehJ3WBYTrowZD4hM9T+lOeHgi3
   OP2NoQGRKfunB0JZaUUIaRO+ag9XUKpfVGiOG6xRNLfAsMvKCqGQAF/Og
   dt2cc0aLJD0kEooOwDIGC8FKe6AkopGLvkQRnQI1GaayfGRdyhx69xK3Y
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="370072104"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="370072104"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 10:25:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="719022183"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="719022183"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 04 Apr 2023 10:25:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Simei Su <simei.su@intel.com>, anthony.l.nguyen@intel.com,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: [PATCH net 1/2] ice: fix wrong fallback logic for FDIR
Date:   Tue,  4 Apr 2023 10:23:05 -0700
Message-Id: <20230404172306.450880-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230404172306.450880-1-anthony.l.nguyen@intel.com>
References: <20230404172306.450880-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simei Su <simei.su@intel.com>

When adding a FDIR filter, if ice_vc_fdir_set_irq_ctx returns failure,
the inserted fdir entry will not be removed and if ice_vc_fdir_write_fltr
returns failure, the fdir context info for irq handler will not be cleared
which may lead to inconsistent or memory leak issue. This patch refines
failure cases to resolve this issue.

Fixes: 1f7ea1cd6a37 ("ice: Enable FDIR Configure for AVF")
Signed-off-by: Simei Su <simei.su@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
index 5fd75e75772e..4d007d8c2540 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
@@ -1871,7 +1871,7 @@ int ice_vc_add_fdir_fltr(struct ice_vf *vf, u8 *msg)
 		v_ret = VIRTCHNL_STATUS_SUCCESS;
 		stat->status = VIRTCHNL_FDIR_FAILURE_RULE_NORESOURCE;
 		dev_dbg(dev, "VF %d: set FDIR context failed\n", vf->vf_id);
-		goto err_free_conf;
+		goto err_rem_entry;
 	}
 
 	ret = ice_vc_fdir_write_fltr(vf, conf, true, is_tun);
@@ -1880,15 +1880,16 @@ int ice_vc_add_fdir_fltr(struct ice_vf *vf, u8 *msg)
 		stat->status = VIRTCHNL_FDIR_FAILURE_RULE_NORESOURCE;
 		dev_err(dev, "VF %d: writing FDIR rule failed, ret:%d\n",
 			vf->vf_id, ret);
-		goto err_rem_entry;
+		goto err_clr_irq;
 	}
 
 exit:
 	kfree(stat);
 	return ret;
 
-err_rem_entry:
+err_clr_irq:
 	ice_vc_fdir_clear_irq_ctx(vf);
+err_rem_entry:
 	ice_vc_fdir_remove_entry(vf, conf, conf->flow_id);
 err_free_conf:
 	devm_kfree(dev, conf);
-- 
2.38.1

