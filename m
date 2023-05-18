Return-Path: <netdev+bounces-3567-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A103707E13
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 12:27:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB37B2813D1
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 10:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14F9E125CE;
	Thu, 18 May 2023 10:26:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086B9125CD
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 10:26:40 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB22A1BDF
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 03:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684405598; x=1715941598;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AlgnQdk73zCrGewRdJQyDhOw9Np8EC2kj0Np8NZ1S34=;
  b=j87fU2Gx0Dp2FqZaFYj07zrW/zguI8v0iVr4Ouf11TV6rHN0vHsJXaVo
   w/tfYCoWqVmA6QPX7LWkakl3jSxeX+Qk1sWapUI5DIY0St/xhF+yV5RfI
   ZoUYPX60M3e9KDmMZb6iUDLPXhvdCRqOQf8A2sFJ+3fiuIHac2Y/qphCl
   PslYQRkF0+1eZ7kpGXKbo9DH+1kXsQ+TUmFz0hihw9TCtSMQGri7ZR5mR
   /1hJpDuk/f33aGcPb6454tac3DZjZUXi7mG9ZRWa22aYvfMJSj0LqLtDf
   FA255weOwmAUx5ORYoM64jW4Ea+w90KiYgvSnKA1RuH7AR7zGhT8EPz4A
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="438371433"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="438371433"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 03:26:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10713"; a="767143743"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="767143743"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga008.fm.intel.com with ESMTP; 18 May 2023 03:26:24 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id 37C0A36C11;
	Thu, 18 May 2023 11:26:23 +0100 (IST)
From: Wojciech Drewek <wojciech.drewek@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	alexandr.lobakin@intel.com,
	david.m.ertman@intel.com,
	michal.swiatkowski@linux.intel.com,
	marcin.szycik@linux.intel.com,
	pawel.chmielewski@intel.com,
	sridhar.samudrala@intel.com
Subject: [PATCH iwl-next v2 06/10] ice: Accept LAG netdevs in bridge offloads
Date: Thu, 18 May 2023 12:25:05 +0200
Message-Id: <20230518102509.20913-7-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230518102509.20913-1-wojciech.drewek@intel.com>
References: <20230518102509.20913-1-wojciech.drewek@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Allow LAG interfaces to be used in bridge offload using
netif_is_lag_master. In this case, search for ice netdev in
the list of LAG's lower devices.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
v2: braces added in ice_eswitch_br_get_uplnik_from_lag,
    use else in ice_eswitch_br_netdev_to_port and
    ice_eswitch_br_port_link
---
 .../net/ethernet/intel/ice/ice_eswitch_br.c   | 47 +++++++++++++++++--
 1 file changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch_br.c b/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
index 9941b0a5aaba..7b7eecec8497 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch_br.c
@@ -15,8 +15,23 @@ static const struct rhashtable_params ice_fdb_ht_params = {
 
 static bool ice_eswitch_br_is_dev_valid(const struct net_device *dev)
 {
-	/* Accept only PF netdev and PRs */
-	return ice_is_port_repr_netdev(dev) || netif_is_ice(dev);
+	/* Accept only PF netdev, PRs and LAG */
+	return ice_is_port_repr_netdev(dev) || netif_is_ice(dev) ||
+		netif_is_lag_master(dev);
+}
+
+static struct net_device *
+ice_eswitch_br_get_uplnik_from_lag(struct net_device *lag_dev)
+{
+	struct net_device *lower;
+	struct list_head *iter;
+
+	netdev_for_each_lower_dev(lag_dev, lower, iter) {
+		if (netif_is_ice(lower))
+			return lower;
+	}
+
+	return NULL;
 }
 
 static struct ice_esw_br_port *
@@ -26,8 +41,19 @@ ice_eswitch_br_netdev_to_port(struct net_device *dev)
 		struct ice_repr *repr = ice_netdev_to_repr(dev);
 
 		return repr->br_port;
-	} else if (netif_is_ice(dev)) {
-		struct ice_pf *pf = ice_netdev_to_pf(dev);
+	} else if (netif_is_ice(dev) || netif_is_lag_master(dev)) {
+		struct net_device *ice_dev;
+		struct ice_pf *pf;
+
+		if (netif_is_lag_master(dev))
+			ice_dev = ice_eswitch_br_get_uplnik_from_lag(dev);
+		else
+			ice_dev = dev;
+
+		if (!ice_dev)
+			return NULL;
+
+		pf = ice_netdev_to_pf(ice_dev);
 
 		return pf->br_port;
 	}
@@ -716,7 +742,18 @@ ice_eswitch_br_port_link(struct ice_esw_br_offloads *br_offloads,
 
 		err = ice_eswitch_br_vf_repr_port_init(bridge, repr);
 	} else {
-		struct ice_pf *pf = ice_netdev_to_pf(dev);
+		struct net_device *ice_dev;
+		struct ice_pf *pf;
+
+		if (netif_is_lag_master(dev))
+			ice_dev = ice_eswitch_br_get_uplnik_from_lag(dev);
+		else
+			ice_dev = dev;
+
+		if (!ice_dev)
+			return 0;
+
+		pf = ice_netdev_to_pf(ice_dev);
 
 		err = ice_eswitch_br_uplink_port_init(bridge, pf);
 	}
-- 
2.40.1


