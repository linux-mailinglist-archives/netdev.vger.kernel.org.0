Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A61D35F8E0
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 18:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352689AbhDNQTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 12:19:15 -0400
Received: from mga18.intel.com ([134.134.136.126]:61890 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352674AbhDNQTL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 12:19:11 -0400
IronPort-SDR: /yCCQg6LKG3d2ABNFN7gEWIUVk0wem9TdCY2bS+sYyqyS02KNZO8mhXLOmr4N8LuigmuePtnJR
 mzd+awJllqWg==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="182179985"
X-IronPort-AV: E=Sophos;i="5.82,222,1613462400"; 
   d="scan'208";a="182179985"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 09:18:48 -0700
IronPort-SDR: lvYrbyLwf3yghaXeliSaBOkHojfB8n++mLEutchMxOCKhIZItaeYrsE2ApxvEKvytWGUMMnrut
 tdWsFufc+PAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,222,1613462400"; 
   d="scan'208";a="452520791"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 14 Apr 2021 09:18:47 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 3/3] ice: Fix potential infinite loop when using u8 loop counter
Date:   Wed, 14 Apr 2021 09:20:32 -0700
Message-Id: <20210414162032.3846384-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210414162032.3846384-1-anthony.l.nguyen@intel.com>
References: <20210414162032.3846384-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

A for-loop is using a u8 loop counter that is being compared to
a u32 cmp_dcbcfg->numapp to check for the end of the loop. If
cmp_dcbcfg->numapp is larger than 255 then the counter j will wrap
around to zero and hence an infinite loop occurs. Fix this by making
counter j the same type as cmp_dcbcfg->numapp.

Addresses-Coverity: ("Infinite loop")
Fixes: aeac8ce864d9 ("ice: Recognize 860 as iSCSI port in CEE mode")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_dcb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.c b/drivers/net/ethernet/intel/ice/ice_dcb.c
index 211ac6f907ad..28e834a128c0 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -747,8 +747,8 @@ ice_cee_to_dcb_cfg(struct ice_aqc_get_cee_dcb_cfg_resp *cee_cfg,
 		   struct ice_port_info *pi)
 {
 	u32 status, tlv_status = le32_to_cpu(cee_cfg->tlv_status);
-	u32 ice_aqc_cee_status_mask, ice_aqc_cee_status_shift;
-	u8 i, j, err, sync, oper, app_index, ice_app_sel_type;
+	u32 ice_aqc_cee_status_mask, ice_aqc_cee_status_shift, j;
+	u8 i, err, sync, oper, app_index, ice_app_sel_type;
 	u16 app_prio = le16_to_cpu(cee_cfg->oper_app_prio);
 	u16 ice_aqc_cee_app_mask, ice_aqc_cee_app_shift;
 	struct ice_dcbx_cfg *cmp_dcbcfg, *dcbcfg;
-- 
2.26.2

