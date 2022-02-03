Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9746E4A9040
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 22:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355522AbiBCVv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 16:51:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:63985 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231545AbiBCVvw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 16:51:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643925112; x=1675461112;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oT9PIHlcYKPi3EEQZ1tCE1QvLkX/awAILH0vZwVZn94=;
  b=X9uHAnWWUovnkoBojbH1tCQLMDN7GI2nz0Wc4otqc6z1dgUuJvyul0fk
   mrSM2qyrwC5SZcUCIzgZHTKOY6boRHmHt7GjqkPom5wgb6Rw+hFJ6eVwB
   RXvo6noYYCxnB5HP7UJALERdAxtvgDoz9GBEEK3UDjBKV+WM298cjvL5Y
   HvCFfj7c4AKqD5GVBJ0HiadXr5yZ2/sxPX2cv0vJkigjXt6EesR+H8QcJ
   bcARfRVgAvpIysZFmfFLfNJrUmu5O4vmdP/I2+PANZHOntffAEYvl/6Q1
   2HonwsSNiJY2Oh5j7/uEGQdsqrzTCTzaaFZ8UYd3JWoIQAE6pBUr9M9or
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10247"; a="272760133"
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="272760133"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2022 13:51:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,340,1635231600"; 
   d="scan'208";a="498295205"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga002.jf.intel.com with ESMTP; 03 Feb 2022 13:51:51 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Witold Fijalkowski <witoldx.fijalkowski@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 4/7] i40e: Add sending commands in atomic context
Date:   Thu,  3 Feb 2022 13:51:37 -0800
Message-Id: <20220203215140.969227-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220203215140.969227-1-anthony.l.nguyen@intel.com>
References: <20220203215140.969227-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

Change functions:
- i40e_aq_add_macvlan
- i40e_aq_remove_macvlan
- i40e_aq_delete_element
- i40e_aq_add_vsi
- i40e_aq_update_vsi_params
to explicitly use i40e_asq_send_command_atomic(..., true)
instead of i40e_asq_send_command, as they use mutexes and do some
work in an atomic context.
Without this change setting vlan via netdev will fail with
call trace cased by bug "BUG: scheduling while atomic".

Signed-off-by: Witold Fijalkowski <witoldx.fijalkowski@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_common.c | 21 +++++++++++--------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index 9ddeb015eb7e..e830987a8c6d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -1899,8 +1899,9 @@ i40e_status i40e_aq_add_vsi(struct i40e_hw *hw,
 
 	desc.flags |= cpu_to_le16((u16)(I40E_AQ_FLAG_BUF | I40E_AQ_FLAG_RD));
 
-	status = i40e_asq_send_command(hw, &desc, &vsi_ctx->info,
-				    sizeof(vsi_ctx->info), cmd_details);
+	status = i40e_asq_send_command_atomic(hw, &desc, &vsi_ctx->info,
+					      sizeof(vsi_ctx->info),
+					      cmd_details, true);
 
 	if (status)
 		goto aq_add_vsi_exit;
@@ -2287,8 +2288,9 @@ i40e_status i40e_aq_update_vsi_params(struct i40e_hw *hw,
 
 	desc.flags |= cpu_to_le16((u16)(I40E_AQ_FLAG_BUF | I40E_AQ_FLAG_RD));
 
-	status = i40e_asq_send_command(hw, &desc, &vsi_ctx->info,
-				    sizeof(vsi_ctx->info), cmd_details);
+	status = i40e_asq_send_command_atomic(hw, &desc, &vsi_ctx->info,
+					      sizeof(vsi_ctx->info),
+					      cmd_details, true);
 
 	vsi_ctx->vsis_allocated = le16_to_cpu(resp->vsi_used);
 	vsi_ctx->vsis_unallocated = le16_to_cpu(resp->vsi_free);
@@ -2673,8 +2675,8 @@ i40e_status i40e_aq_add_macvlan(struct i40e_hw *hw, u16 seid,
 	if (buf_size > I40E_AQ_LARGE_BUF)
 		desc.flags |= cpu_to_le16((u16)I40E_AQ_FLAG_LB);
 
-	status = i40e_asq_send_command(hw, &desc, mv_list, buf_size,
-				       cmd_details);
+	status = i40e_asq_send_command_atomic(hw, &desc, mv_list, buf_size,
+					      cmd_details, true);
 
 	return status;
 }
@@ -2715,8 +2717,8 @@ i40e_status i40e_aq_remove_macvlan(struct i40e_hw *hw, u16 seid,
 	if (buf_size > I40E_AQ_LARGE_BUF)
 		desc.flags |= cpu_to_le16((u16)I40E_AQ_FLAG_LB);
 
-	status = i40e_asq_send_command(hw, &desc, mv_list, buf_size,
-				       cmd_details);
+	status = i40e_asq_send_command_atomic(hw, &desc, mv_list, buf_size,
+					      cmd_details, true);
 
 	return status;
 }
@@ -3868,7 +3870,8 @@ i40e_status i40e_aq_delete_element(struct i40e_hw *hw, u16 seid,
 
 	cmd->seid = cpu_to_le16(seid);
 
-	status = i40e_asq_send_command(hw, &desc, NULL, 0, cmd_details);
+	status = i40e_asq_send_command_atomic(hw, &desc, NULL, 0,
+					      cmd_details, true);
 
 	return status;
 }
-- 
2.31.1

