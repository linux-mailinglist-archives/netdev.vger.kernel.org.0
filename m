Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70269311B22
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 05:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbhBFEub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 23:50:31 -0500
Received: from mga18.intel.com ([134.134.136.126]:21757 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231393AbhBFErs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 23:47:48 -0500
IronPort-SDR: sRMpkN2OkeGJexDlizcKhn4Xv9NdKho55dUJrmr9kK8ORa0xitGGXNoAJB/4Imc4Flyn8sO/sL
 r10kv7e2WO6w==
X-IronPort-AV: E=McAfee;i="6000,8403,9886"; a="169194697"
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="169194697"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 20:40:12 -0800
IronPort-SDR: 3I+WU9C8vmKef3rHVxo5d6mLZ01TllGFExVQ5qhiB7yVpzWeZ6WS++c5z1mwQ0nTsGEum8GrCx
 1ywSKlLGo7ng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,156,1610438400"; 
   d="scan'208";a="434751071"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 05 Feb 2021 20:40:12 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next v2 10/11] ice: use flex_array_size where possible
Date:   Fri,  5 Feb 2021 20:41:00 -0800
Message-Id: <20210206044101.636242-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210206044101.636242-1-anthony.l.nguyen@intel.com>
References: <20210206044101.636242-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

Use the flex_array_size() helper with the recently added flexible array
members in structures.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c    | 2 +-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 6d7e7dd0ebe2..607d33d05a0c 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1653,7 +1653,7 @@ ice_aq_alloc_free_res(struct ice_hw *hw, u16 num_entries,
 	if (!buf)
 		return ICE_ERR_PARAM;
 
-	if (buf_size < (num_entries * sizeof(buf->elem[0])))
+	if (buf_size < flex_array_size(buf, elem, num_entries))
 		return ICE_ERR_PARAM;
 
 	ice_fill_dflt_direct_cmd_desc(&desc, opc);
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index f5e81b555353..cf5b717b9293 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -1525,7 +1525,7 @@ ice_pkg_buf_reserve_section(struct ice_buf_build *bld, u16 count)
 	bld->reserved_section_table_entries += count;
 
 	data_end = le16_to_cpu(buf->data_end) +
-		   (count * sizeof(buf->section_entry[0]));
+		flex_array_size(buf, section_entry, count);
 	buf->data_end = cpu_to_le16(data_end);
 
 	return 0;
-- 
2.26.2

