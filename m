Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48DB9581B54
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 22:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239982AbiGZUuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 16:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239857AbiGZUtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 16:49:51 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296DA205CA
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 13:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658868591; x=1690404591;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C0U5nFzGDyiHXy6zWt5y7n3jFGqtL08AB+VT3vWibWM=;
  b=Vr7GphEmo0JtGqkWGWMQbH29Z09Y3oqaX9qY7rW3jmPzUbksQe6JbLWY
   a48yx1gdFqpZ2a8OsQjy+dZJ1uWr8hhpOU2fgZYG370p+ds8xXjb2rVaQ
   lYecMYq/aggv8jXcM5TzC4HHtK+ZteO6veZ0Mwy3VP5X1dyUHi4MGHvzx
   jHQyHVeFgv3q4U39yA8EGWebX1fVIYYB+1hVEgILAGHoq9/bIgXhaednD
   rkkZyyAGdGbDuQ7e1xd+LQft9PdvC935vgNrr/j+OJZZpKH5XFCIubUSb
   G6aCBPWXcoGg+mVU7et2h/wTysLHu3OpIZ2OLaCKeG3dcLqIF1OxTBJIQ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="268440958"
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="268440958"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 13:49:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,194,1654585200"; 
   d="scan'208";a="575654585"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 26 Jul 2022 13:49:48 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Subject: [PATCH net 5/5] ice: do not setup vlan for loopback VSI
Date:   Tue, 26 Jul 2022 13:46:46 -0700
Message-Id: <20220726204646.2171589-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220726204646.2171589-1-anthony.l.nguyen@intel.com>
References: <20220726204646.2171589-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Currently loopback test is failiing due to the error returned from
ice_vsi_vlan_setup(). Skip calling it when preparing loopback VSI.

Fixes: 0e674aeb0b77 ("ice: Add handler for ethtool selftest")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index b41a45c03d22..9f02b60459f1 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6013,10 +6013,12 @@ int ice_vsi_cfg(struct ice_vsi *vsi)
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
2.35.1

