Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2568A553EB5
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 00:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354869AbiFUWvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 18:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354226AbiFUWvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 18:51:00 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8301EED5
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 15:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655851858; x=1687387858;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z8svdaqad94j6ysgbQnUiVyO8MCoRnqx4OlYy6gvYMQ=;
  b=amrCRawTaQ2CzFzPeGLkNp7Vu0nHNiUeWeumHy9Y13tG2u0ylwFQAv6w
   Cf9B0TCRO3VTedDXoP0gh5sfD3q1yjsXSnPypGDjPj93zcylBEcLjwUdM
   6AkzX66zsdVB3T6Cu3c6iWNw95WN0r4PnuZZiVtH2FPQtfe6zICOEcb73
   x25Y8wapc/xc95RGMiZGMYlgP4I1REZPzXGxuJgLTEqQMOO65XUJXoqrN
   ay+VFCDW61aqBwOWP3ydvgGbiQ0aXaw8t8x64cMy1jQetxppZDSJOPvxj
   TYYmJW88CYGGalsi1IVGFVRkUHum5QRbL8f9xYieB8mJtehRFzHD6zZ79
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="277806457"
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="277806457"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 15:50:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="655359204"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 21 Jun 2022 15:50:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Wojciech Drewek <wojciech.drewek@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net 2/4] ice: Fix switchdev rules book keeping
Date:   Tue, 21 Jun 2022 15:47:54 -0700
Message-Id: <20220621224756.631765-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220621224756.631765-1-anthony.l.nguyen@intel.com>
References: <20220621224756.631765-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>

Adding two filters with same matching criteria ends up with
one rule in hardware with act = ICE_FWD_TO_VSI_LIST.
In order to remove them properly we have to keep the
information about vsi handle which is used in VSI bitmap
(ice_adv_fltr_mgmt_list_entry::vsi_list_info::vsi_map).

Fixes: 0d08a441fb1a ("ice: ndo_setup_tc implementation for PF")
Reported-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index b677c62a244c..b803f2ab3cc7 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -524,6 +524,7 @@ ice_eswitch_add_tc_fltr(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr)
 	 */
 	fltr->rid = rule_added.rid;
 	fltr->rule_id = rule_added.rule_id;
+	fltr->dest_id = rule_added.vsi_handle;
 
 exit:
 	kfree(list);
-- 
2.35.1

