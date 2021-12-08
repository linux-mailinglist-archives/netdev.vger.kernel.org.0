Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAE346DDBC
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 22:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238719AbhLHVod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 16:44:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:15036 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234333AbhLHVoc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 16:44:32 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10192"; a="237757855"
X-IronPort-AV: E=Sophos;i="5.88,190,1635231600"; 
   d="scan'208";a="237757855"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2021 13:12:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,190,1635231600"; 
   d="scan'208";a="606528268"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 08 Dec 2021 13:12:48 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Yahui Cao <yahui.cao@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net v2 1/7] ice: fix FDIR init missing when reset VF
Date:   Wed,  8 Dec 2021 13:11:38 -0800
Message-Id: <20211208211144.2629867-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211208211144.2629867-1-anthony.l.nguyen@intel.com>
References: <20211208211144.2629867-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yahui Cao <yahui.cao@intel.com>

When VF is being reset, ice_reset_vf() will be called and FDIR
resource should be released and initialized again.

Fixes: 1f7ea1cd6a37 ("ice: Enable FDIR Configure for AVF")
Signed-off-by: Yahui Cao <yahui.cao@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 217ff5e9a6f1..c2431bc9d9ce 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1617,6 +1617,7 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
 		ice_vc_set_default_allowlist(vf);
 
 		ice_vf_fdir_exit(vf);
+		ice_vf_fdir_init(vf);
 		/* clean VF control VSI when resetting VFs since it should be
 		 * setup only when VF creates its first FDIR rule.
 		 */
@@ -1747,6 +1748,7 @@ bool ice_reset_vf(struct ice_vf *vf, bool is_vflr)
 	}
 
 	ice_vf_fdir_exit(vf);
+	ice_vf_fdir_init(vf);
 	/* clean VF control VSI when resetting VF since it should be setup
 	 * only when VF creates its first FDIR rule.
 	 */
-- 
2.31.1

