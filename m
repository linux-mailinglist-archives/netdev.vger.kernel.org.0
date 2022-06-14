Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC19D54B816
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 19:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344491AbiFNRsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 13:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344154AbiFNRsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 13:48:06 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C7D3054A;
        Tue, 14 Jun 2022 10:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655228885; x=1686764885;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZWfOItZVbDUCiGAyHfDstCui//COUhEuRjhViiZyBfE=;
  b=LIfEWLesEBdDfG1wGN9+pjiI5mjg+Q74HgtyAetzhApneSXuY+Kurpi1
   GB0Key+TW+E+te4Mq1J0hlfE2WdPnjdJe5+pfinudmb5Q6eVsmSv0NXiL
   JAT77oms/bOwv5qS0bRFsirI+sqJdMjOKOmXkBx60Orm/gGTU74vVBNHm
   ff3cqx8nB7ClsUwSgOE/CFiJu+M0uhXnddv7vyS0XBNjRonXes/ZcsC1i
   0gci+I9cthaBAusrY52K7576qlNixNLBlC2U+4fzOYA6pa/QhwsFOU8YX
   tHvWIyJoWB/spxgqVZU6kyOSYh3cO3rXdkgLifsUnwIZB5xUbbXJopZch
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="340356789"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="340356789"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 10:48:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="570110082"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga002.jf.intel.com with ESMTP; 14 Jun 2022 10:47:58 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 bpf-next 03/10] ice: do not setup vlan for loopback VSI
Date:   Tue, 14 Jun 2022 19:47:42 +0200
Message-Id: <20220614174749.901044-4-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220614174749.901044-1-maciej.fijalkowski@intel.com>
References: <20220614174749.901044-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently loopback test is failiing due to the error returned from
ice_vsi_vlan_setup(). Skip calling it when preparing loopback VSI.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index ab00b0361e87..4418970edcf3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6011,10 +6011,12 @@ int ice_vsi_cfg(struct ice_vsi *vsi)
 	if (vsi->netdev) {
 		ice_set_rx_mode(vsi->netdev);
 
-		err = ice_vsi_vlan_setup(vsi);
+		if (vsi->type != ICE_VSI_LB) {
+			err = ice_vsi_vlan_setup(vsi);
 
-		if (err)
-			return err;
+			if (err)
+				return err;
+		}
 	}
 	ice_vsi_cfg_dcb_rings(vsi);
 
-- 
2.27.0

