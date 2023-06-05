Return-Path: <netdev+bounces-8147-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8311B722E9A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:22:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECF2E1C20C89
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 18:22:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CD7E2412D;
	Mon,  5 Jun 2023 18:21:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBBE2412A
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 18:21:23 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C7DF9
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 11:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685989281; x=1717525281;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zWueIugLkPzhRFxbraw5mn+1MtNWom7DwGEFAkOH278=;
  b=OS//WS9TpFCYLvJt3N+PSwZkIlbAPIoBn6zh328aU9YhKYeG1xrcSxDO
   dtCqd8WKyZ1PTC84zgZyk47usZKBow8SBfMZHeGVtWC9qFz3yFR8qJgIw
   CoogEPE7XbE7WUsjyiLGUy8vGeTbKdIJnuLXXnAx01Ew+E6V1RsFt9F6Y
   lX8naNZkT2zlKS05uuZMyLC/tPQqOU/GYow0hwXSaMaUz8GFjV+ptFqdc
   +p17QhdbnPxzTmmc5kp6px8vTTMx20Zg8JIW5EU7jhdmfZwEM12+fCPJ/
   VRu/My1IKnWhhZLKuUA9EGn0pTiNV8oA/wZJ7pKgWNh/teLT9SeqaRpLf
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="358896815"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="358896815"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 11:21:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="1038863375"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="1038863375"
Received: from dmert-dev.jf.intel.com ([10.166.241.14])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 11:21:16 -0700
From: Dave Ertman <david.m.ertman@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org
Subject: [PATCH net v2 07/10] ice: support non-standard teardown of bond interface
Date: Mon,  5 Jun 2023 11:22:55 -0700
Message-Id: <20230605182258.557933-8-david.m.ertman@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230605182258.557933-1-david.m.ertman@intel.com>
References: <20230605182258.557933-1-david.m.ertman@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Code for supporting removal of the PF driver (NETDEV_UNREGISTER) events for
both when the bond has the primary interface as active and when failed over
to thew secondary interface.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lag.c | 47 ++++++++++++++++++++----
 1 file changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lag.c b/drivers/net/ethernet/intel/ice/ice_lag.c
index e46234ad836d..665faa9bf3eb 100644
--- a/drivers/net/ethernet/intel/ice/ice_lag.c
+++ b/drivers/net/ethernet/intel/ice/ice_lag.c
@@ -1226,15 +1226,16 @@ static void ice_lag_changeupper_event(struct ice_lag *lag, void *ptr)
 		if (!primary_lag && lag->primary)
 			primary_lag = lag;
 
-		if (primary_lag) {
-			if (!lag->primary) {
-				ice_lag_set_swid(0, lag, false);
-			} else {
+		if (!lag->primary) {
+			ice_lag_set_swid(0, lag, false);
+		} else {
+			if (primary_lag && lag->primary) {
 				ice_lag_primary_swid(lag, false);
 				ice_lag_del_prune_list(primary_lag, lag->pf);
 			}
-			ice_lag_cfg_cp_fltr(lag, false);
 		}
+		/* remove filter for control packets */
+		ice_lag_cfg_cp_fltr(lag, false);
 	}
 }
 
@@ -1442,6 +1443,38 @@ ice_lag_chk_comp(struct ice_lag *lag, void *ptr)
 static void
 ice_lag_unregister(struct ice_lag *lag, struct net_device *event_netdev)
 {
+	struct ice_netdev_priv *np;
+	struct ice_pf *event_pf;
+	struct ice_lag *p_lag;
+
+	p_lag = ice_lag_find_primary(lag);
+	np = netdev_priv(event_netdev);
+	event_pf = np->vsi->back;
+
+	if (p_lag) {
+		if (p_lag->active_port != p_lag->pf->hw.port_info->lport &&
+		    p_lag->active_port != ICE_LAG_INVALID_PORT) {
+			struct ice_hw *active_hw;
+
+			active_hw = ice_lag_find_hw_by_lport(lag,
+							     p_lag->active_port);
+			if (active_hw)
+				ice_lag_reclaim_vf_nodes(p_lag, active_hw);
+			lag->active_port = ICE_LAG_INVALID_PORT;
+		}
+	}
+
+	/* primary processing for primary */
+	if (lag->primary && lag->netdev == event_netdev)
+		ice_lag_primary_swid(lag, false);
+
+	/* primary processing for secondary */
+	if (lag->primary && lag->netdev != event_netdev)
+		ice_lag_del_prune_list(lag, event_pf);
+
+	/* secondary processing for secondary */
+	if (!lag->primary && lag->netdev == event_netdev)
+		ice_lag_set_swid(0, lag, false);
 }
 
 /**
@@ -1487,8 +1520,8 @@ static void ice_lag_process_event(struct work_struct *work)
 	case NETDEV_UNREGISTER:
 		if (ice_is_feature_supported(pf, ICE_F_SRIOV_LAG)) {
 			netdev = lag_work->info.bonding_info.info.dev;
-			if (netdev == lag_work->lag->netdev &&
-			    lag_work->lag->bonded)
+			if ((netdev == lag_work->lag->netdev ||
+			     lag_work->lag->primary) && lag_work->lag->bonded)
 				ice_lag_unregister(lag_work->lag, netdev);
 		}
 		break;
-- 
2.40.1


