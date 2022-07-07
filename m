Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 870D4569F89
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 12:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbiGGKU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 06:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234396AbiGGKU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 06:20:56 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53C91AE4C
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 03:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657189255; x=1688725255;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z6ljLWA0yJSS4H0haMyrgiV+yyrZhPfOehdjPjrbD2U=;
  b=JJJGOnEr+tGrtXuRK4iB8Cqupf/OUFWlveB3hsBbqSnz8JsrItrG+0jl
   mqbc+epOKfC4/jYtgcuArXlVtft4834iL0x+SGTtVLur5gxonNdmzId3a
   giVqr9i0H/NhhzbneciAha78ITqp+w2U7wqllUMh7dgQWN1LfG+pUTmmo
   Xc6ymGqq0ZHGV8d+xO/U9uGrxlC1YMVmEur+yDsVCJS2FAUA/dSaJzNsC
   ctjKm27oY2qkcl2DQPOkzIv2lnIfpKMf7egIjaUnzmjFKT2GgeEOQqnxX
   AhRmS9lAlAS7de/8qlwNq92AmLWK8IRNO1rS/9KWK4XBE1H6msB/NrYrS
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10400"; a="347972262"
X-IronPort-AV: E=Sophos;i="5.92,252,1650956400"; 
   d="scan'208";a="347972262"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 03:20:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,252,1650956400"; 
   d="scan'208";a="696458251"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jul 2022 03:20:52 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        kuba@kernel.org, davem@davemloft.net, magnus.karlsson@intel.com,
        anatolii.gerasymenko@intel.com, alexandr.lobakin@intel.com,
        john.fastabend@gmail.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH intel-net 2/2] ice: do not setup vlan for loopback VSI
Date:   Thu,  7 Jul 2022 12:20:43 +0200
Message-Id: <20220707102044.48775-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220707102044.48775-1-maciej.fijalkowski@intel.com>
References: <20220707102044.48775-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Fixes: 0e674aeb0b77 ("ice: Add handler for ethtool selftest")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c1ac2f746714..2c40873bcbb2 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6010,10 +6010,12 @@ int ice_vsi_cfg(struct ice_vsi *vsi)
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

