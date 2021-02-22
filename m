Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9863222DA
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 00:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbhBVX6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 18:58:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:20936 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231279AbhBVX6K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 18:58:10 -0500
IronPort-SDR: GUzDiqhRuNfA+u+OR7i5cciwucCNKanTUfflK3//MdmSxBSHzUQkecC1/b2M7h5iP0UcdVGR/u
 2eS2q00bnROA==
X-IronPort-AV: E=McAfee;i="6000,8403,9903"; a="184751842"
X-IronPort-AV: E=Sophos;i="5.81,198,1610438400"; 
   d="scan'208";a="184751842"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2021 15:57:13 -0800
IronPort-SDR: KY0C9gxJVl9vX1Y16Msxv9nDRqUYEW1ua6YTovNDMpZK/H7JstqXxrqkhntv1KBn1XcrZZs1G7
 EySSG0j6J8pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,198,1610438400"; 
   d="scan'208";a="592882902"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 22 Feb 2021 15:57:13 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 2/5] ice: Set trusted VF as default VSI when setting allmulti on
Date:   Mon, 22 Feb 2021 15:58:11 -0800
Message-Id: <20210222235814.834282-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210222235814.834282-1-anthony.l.nguyen@intel.com>
References: <20210222235814.834282-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently the PF will only set a trusted VF as the default VSI when it
requests FLAG_VF_UNICAST_PROMISC over VIRTCHNL. However, when
FLAG_VF_MULTICAST_PROMISC is set it's expected that the trusted VF will
see multicast packets that don't have a matching destination MAC in the
devices internal switch. Fix this by setting the trusted VF as the
default VSI if either FLAG_VF_UNICAST_PROMISC or
FLAG_VF_MULTICAST_PROMISC is set.

Fixes: 01b5e89aab49 ("ice: Add VF promiscuous support")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index bf5fd812ea0e..07fae37a78be 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2420,7 +2420,7 @@ static int ice_vc_cfg_promiscuous_mode_msg(struct ice_vf *vf, u8 *msg)
 	}
 
 	if (!test_bit(ICE_FLAG_VF_TRUE_PROMISC_ENA, pf->flags)) {
-		bool set_dflt_vsi = !!(info->flags & FLAG_VF_UNICAST_PROMISC);
+		bool set_dflt_vsi = alluni || allmulti;
 
 		if (set_dflt_vsi && !ice_is_dflt_vsi_in_use(pf->first_sw))
 			/* only attempt to set the default forwarding VSI if
-- 
2.26.2

