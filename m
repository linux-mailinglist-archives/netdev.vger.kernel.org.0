Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD1F42E119
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 20:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233915AbhJNSXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 14:23:52 -0400
Received: from mga04.intel.com ([192.55.52.120]:62163 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230422AbhJNSXv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 14:23:51 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="226531109"
X-IronPort-AV: E=Sophos;i="5.85,373,1624345200"; 
   d="scan'208";a="226531109"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 11:21:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,373,1624345200"; 
   d="scan'208";a="717815819"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 14 Oct 2021 11:21:44 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        linux-rdma@vger.kernel.org, shiraz.saleem@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 3/4] ice: fix getting UDP tunnel entry
Date:   Thu, 14 Oct 2021 11:19:52 -0700
Message-Id: <20211014181953.3538330-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211014181953.3538330-1-anthony.l.nguyen@intel.com>
References: <20211014181953.3538330-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Correct parameters order in call to ice_tunnel_idx_to_entry function.

Entry in sparse port table is correct when the idx is 0. For idx 1 one
correct entry should be skipped, for idx 2 two of them should be skipped
etc. Change if condition to be true when idx is 0, which means that
previous valid entry of this tunnel type were skipped.

Fixes: b20e6c17c468 ("ice: convert to new udp_tunnel infrastructure")
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 06ac9badee77..1ac96dc66d0d 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -1668,7 +1668,7 @@ static u16 ice_tunnel_idx_to_entry(struct ice_hw *hw, enum ice_tunnel_type type,
 	for (i = 0; i < hw->tnl.count && i < ICE_TUNNEL_MAX_ENTRIES; i++)
 		if (hw->tnl.tbl[i].valid &&
 		    hw->tnl.tbl[i].type == type &&
-		    idx--)
+		    idx-- == 0)
 			return i;
 
 	WARN_ON_ONCE(1);
@@ -1828,7 +1828,7 @@ int ice_udp_tunnel_set_port(struct net_device *netdev, unsigned int table,
 	u16 index;
 
 	tnl_type = ti->type == UDP_TUNNEL_TYPE_VXLAN ? TNL_VXLAN : TNL_GENEVE;
-	index = ice_tunnel_idx_to_entry(&pf->hw, idx, tnl_type);
+	index = ice_tunnel_idx_to_entry(&pf->hw, tnl_type, idx);
 
 	status = ice_create_tunnel(&pf->hw, index, tnl_type, ntohs(ti->port));
 	if (status) {
-- 
2.31.1

