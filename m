Return-Path: <netdev+bounces-10360-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E1D172E1C4
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 13:36:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BABD61C20C53
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 11:36:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D803294EE;
	Tue, 13 Jun 2023 11:36:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5C929114
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 11:36:02 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4A2DC
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 04:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686656158; x=1718192158;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Av+c/b633S9bk+xfV7TrmvsJOzSsUmzTjPEr5rXGgJA=;
  b=P0bspMSX61LpX4H8yRpUCHVoL7YNcB8NyNuTBf4FMOjve1aZSvaOJ1r0
   qiy+05hJZta4xdsRdpHib+CpVG/6W8WRH7xFixt0NOl7SqW2fTbqLzSBW
   qXwr6Gx/vu+jZGImfdewSTtVrlehLy8VekiFmj6B+BxMqJyfDLjoGZO0b
   ALSsySoFks3fSKDUChGQzIEm9bNzqd4+/RXmzB95fp3VEGxi0NO2v2GqM
   Xgb0fn7nB6HGm1erfc6FBPohrpTF6OrO+ht5Pv4RIOnrbvdHwTGZ6f0Np
   YTB+f0TTFWzx5afxrwF/Dh2cawiDJsUJYV7fcmx97kiKqkMUe7HADNxDA
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="421900065"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="421900065"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 04:35:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="801439221"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="801439221"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jun 2023 04:35:56 -0700
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	anthony.l.nguyen@intel.com,
	magnus.karlsson@intel.com,
	przemyslaw.kitszel@intel.com,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 iwl-next] ice: use ice_down_up() where applicable
Date: Tue, 13 Jun 2023 13:35:52 +0200
Message-Id: <20230613113552.336520-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

ice_change_mtu() is currently using a separate ice_down() and ice_up()
calls to reflect changed MTU. ice_down_up() serves this purpose, so do
the refactoring here.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---

v1->v2:
- avoid setting ICE_VSI_DOWN bit as ice_down_up() covers it [Przemek]

 drivers/net/ethernet/intel/ice/ice_main.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a1f7c8edc22f..8f7c6ef3c487 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -7631,21 +7631,9 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 	}
 
 	netdev->mtu = (unsigned int)new_mtu;
-
-	/* if VSI is up, bring it down and then back up */
-	if (!test_and_set_bit(ICE_VSI_DOWN, vsi->state)) {
-		err = ice_down(vsi);
-		if (err) {
-			netdev_err(netdev, "change MTU if_down err %d\n", err);
-			return err;
-		}
-
-		err = ice_up(vsi);
-		if (err) {
-			netdev_err(netdev, "change MTU if_up err %d\n", err);
-			return err;
-		}
-	}
+	err = ice_down_up(vsi);
+	if (err)
+		return err;
 
 	netdev_dbg(netdev, "changed MTU to %d\n", new_mtu);
 	set_bit(ICE_FLAG_MTU_CHANGED, pf->flags);
-- 
2.34.1


