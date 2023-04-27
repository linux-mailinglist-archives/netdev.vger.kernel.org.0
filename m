Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6326F0059
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 07:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242691AbjD0FQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 01:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjD0FQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 01:16:29 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41ADEE5D
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 22:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682572588; x=1714108588;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Ax1iHNDOz68QYb0nmNeUoZrbFq3pcH/YD2ufToMu8f0=;
  b=AZaD4+Tqh21NZ6ObtzoG7vKM26Ww1VM/QIdVR6VRBQESzAjz2b3xMR2K
   5zthKCB4RRh3ykbIZ16zys368IQ0Ysgak2MmoMJkdlMFNi7WF4robF5oc
   B3pYm1zmGkutXXvKdpnhUYnpNp2PgTHQX0RwFUm9qSqZWBKRRTaimNhqr
   eY+JiqyBcD+4UVu86HIfI9XgwWC38vZdP+3CsfTieEWL3ECw/o5PG5OM5
   mmPPZcstccd1kwlTQj5xm4/55P6AOH0J9ipci+mmGNL8KV2Xe/NEjhWPb
   GAN9Te3TwUdSA1lL0Gs9iYVUnO7mAgTOs9R5JW7Pq1BmZ65UHZ6PDQEBG
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="412660655"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="412660655"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 22:16:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="724736867"
X-IronPort-AV: E=Sophos;i="5.99,230,1677571200"; 
   d="scan'208";a="724736867"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by orsmga008.jf.intel.com with ESMTP; 26 Apr 2023 22:16:26 -0700
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, wojciech.drewek@intel.com,
        marcin.szycik@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Sujai Buvaneswaran <Sujai.Buvaneswaran@intel.com>
Subject: [PATCH net v1] ice: block LAN in case of VF to VF offload
Date:   Thu, 27 Apr 2023 06:57:11 +0200
Message-Id: <20230427045711.1625449-1-michal.swiatkowski@linux.intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VF to VF traffic shouldn't go outside. To enforce it, set only the loopback
enable bit in case of all ingress type rules added via the tc tool.

Fixes: 0d08a441fb1a ("ice: ndo_setup_tc implementation for PF")
Reported-by: Sujai Buvaneswaran <Sujai.Buvaneswaran@intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index 76f29a5bf8d7..d1a31f236d26 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -693,17 +693,18 @@ ice_eswitch_add_tc_fltr(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr)
 	 * results into order of switch rule evaluation.
 	 */
 	rule_info.priority = 7;
+	rule_info.flags_info.act_valid = true;
 
 	if (fltr->direction == ICE_ESWITCH_FLTR_INGRESS) {
 		rule_info.sw_act.flag |= ICE_FLTR_RX;
 		rule_info.sw_act.src = hw->pf_id;
 		rule_info.rx = true;
+		rule_info.flags_info.act = ICE_SINGLE_ACT_LB_ENABLE;
 	} else {
 		rule_info.sw_act.flag |= ICE_FLTR_TX;
 		rule_info.sw_act.src = vsi->idx;
 		rule_info.rx = false;
 		rule_info.flags_info.act = ICE_SINGLE_ACT_LAN_ENABLE;
-		rule_info.flags_info.act_valid = true;
 	}
 
 	/* specify the cookie as filter_rule_id */
-- 
2.39.2

