Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA03F6D6A93
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 19:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236299AbjDDR3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 13:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236295AbjDDR2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 13:28:47 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5639004
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 10:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680629228; x=1712165228;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TVeB2TrYJRU11edpAUThTOSm4gdVNADNQgB4X8v9za4=;
  b=jx2xCw0aLwJy3GyJlpg6jUlVow7VQC4zeo+JACjFia4YeXGNJzH6E7tD
   cdnvLxYQF2gU37Ph6UvrCWY7Hr2stYEXM24Z04G1sA1UjQegIRuYpla/S
   Ou11+kh7wNWXmvuiafFvGKTD0J48IZ+1GdQEubC1negUY50vmz8rdu7kR
   Szynecr3T3tw9PhD3Phf7Fb5/OOMXHJTDAPzaCkrSIcf0Wr7MsE1rmOtI
   vGmmnd3Cdx5vt7S7PLN1V0MVgsL3U/2sMUZ5Bs4JslHZrNQ+vQ4D8MOF+
   cOZ470kElVBuS9cd6W+2e75rCdIVyK8KKd8WCHnStb4G5WbKn2XyOTY+n
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="370072107"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="370072107"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 10:25:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="719022186"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="719022186"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga001.jf.intel.com with ESMTP; 04 Apr 2023 10:25:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Lingyu Liu <lingyu.liu@intel.com>, anthony.l.nguyen@intel.com,
        Junfeng Guo <junfeng.guo@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: [PATCH net 2/2] ice: Reset FDIR counter in FDIR init stage
Date:   Tue,  4 Apr 2023 10:23:06 -0700
Message-Id: <20230404172306.450880-3-anthony.l.nguyen@intel.com>
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

From: Lingyu Liu <lingyu.liu@intel.com>

Reset the FDIR counters when FDIR inits. Without this patch,
when VF initializes or resets, all the FDIR counters are not
cleaned, which may cause unexpected behaviors for future FDIR
rule create (e.g., rule conflict).

Fixes: 1f7ea1cd6a37 ("ice: Enable FDIR Configure for AVF")
Signed-off-by: Junfeng Guo <junfeng.guo@intel.com>
Signed-off-by: Lingyu Liu <lingyu.liu@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/ice/ice_virtchnl_fdir.c   | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
index 4d007d8c2540..daa6a1e894cf 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
@@ -541,6 +541,21 @@ static void ice_vc_fdir_rem_prof_all(struct ice_vf *vf)
 	}
 }
 
+/**
+ * ice_vc_fdir_reset_cnt_all - reset all FDIR counters for this VF FDIR
+ * @fdir: pointer to the VF FDIR structure
+ */
+static void ice_vc_fdir_reset_cnt_all(struct ice_vf_fdir *fdir)
+{
+	enum ice_fltr_ptype flow;
+
+	for (flow = ICE_FLTR_PTYPE_NONF_NONE;
+	     flow < ICE_FLTR_PTYPE_MAX; flow++) {
+		fdir->fdir_fltr_cnt[flow][0] = 0;
+		fdir->fdir_fltr_cnt[flow][1] = 0;
+	}
+}
+
 /**
  * ice_vc_fdir_has_prof_conflict
  * @vf: pointer to the VF structure
@@ -1998,6 +2013,7 @@ void ice_vf_fdir_init(struct ice_vf *vf)
 	spin_lock_init(&fdir->ctx_lock);
 	fdir->ctx_irq.flags = 0;
 	fdir->ctx_done.flags = 0;
+	ice_vc_fdir_reset_cnt_all(fdir);
 }
 
 /**
-- 
2.38.1

