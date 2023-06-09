Return-Path: <netdev+bounces-9719-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEBAA72A53A
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 23:16:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9973281AB2
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:16:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8BC523C75;
	Fri,  9 Jun 2023 21:14:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9B01E53C
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 21:14:53 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C293E35A2
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 14:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686345292; x=1717881292;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZcktkyReBoekPCrncd60liaRlzuPJdhoC9sOwTVQHXw=;
  b=Ew3hJtdu47QrwVwlj/A5820GlhXAsXaqQkC6SUc3fmoafOn+E36wV9YD
   eOP5iWpDLq+xXcacrg1BkV6GcdC6JYhKZLInhY7/92fle05yuAUePgfDI
   HN9f/jlwEp5uJj0e0yTcYM48v1yH08drOdYh6BxuPkLHoEZTLNQwfRY2i
   8uDoCkqRfoQkNEzzV2QKRlXRDL0BHh2WI8tb6mMpLHBGI5eDZqiP4XSB8
   Cb/Y7V9KOJFIyLNZsoin/MwhhT2NX/YM4LB8vbRq1G88XsdadNXIypaSU
   jWzr41hDGB1slU7AT6+NAfLJEEpMQIiyprd7ABCFvzY/K1DgUviaReIyD
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="356583192"
X-IronPort-AV: E=Sophos;i="6.00,230,1681196400"; 
   d="scan'208";a="356583192"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 14:14:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="823194637"
X-IronPort-AV: E=Sophos;i="6.00,230,1681196400"; 
   d="scan'208";a="823194637"
Received: from dmert-dev.jf.intel.com ([10.166.241.14])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 14:14:48 -0700
From: Dave Ertman <david.m.ertman@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: daniel.machon@microchip.com,
	simon.horman@corigine.com,
	netdev@vger.kernel.org
Subject: [PATCH iwl-next v4 07/10] ice: support non-standard teardown of bond interface
Date: Fri,  9 Jun 2023 14:16:23 -0700
Message-Id: <20230609211626.621968-8-david.m.ertman@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230609211626.621968-1-david.m.ertman@intel.com>
References: <20230609211626.621968-1-david.m.ertman@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Code for supporting removal of the PF driver (NETDEV_UNREGISTER) events for
both when the bond has the primary interface as active and when failed over
to thew secondary interface.

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lag.c | 47 ++++++++++++++++++++----
 1 file changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lag.c b/drivers/net/ethernet/intel/ice/ice_lag.c
index 1faf4343935e..9e685ee1a181 100644
--- a/drivers/net/ethernet/intel/ice/ice_lag.c
+++ b/drivers/net/ethernet/intel/ice/ice_lag.c
@@ -1183,15 +1183,16 @@ static void ice_lag_changeupper_event(struct ice_lag *lag, void *ptr)
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
 
@@ -1399,6 +1400,38 @@ ice_lag_chk_comp(struct ice_lag *lag, void *ptr)
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
@@ -1444,8 +1477,8 @@ static void ice_lag_process_event(struct work_struct *work)
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


