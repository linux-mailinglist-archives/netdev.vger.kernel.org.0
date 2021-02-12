Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDCC31A806
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 23:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbhBLWsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 17:48:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:44414 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232320AbhBLWof (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 17:44:35 -0500
IronPort-SDR: A+ULsP2tGglTASaCWoegVz5osu7Arlq8jlCf0cOw73NiXY9KC7DSFTuPV+F0ncx8gwDihYjcGu
 zrnJx/G3fv0Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="169617163"
X-IronPort-AV: E=Sophos;i="5.81,174,1610438400"; 
   d="scan'208";a="169617163"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 14:39:01 -0800
IronPort-SDR: R18r/tEjiGZ6xCeKsdpyfmV+aNnNf381HZqTW3vZKUjgvpPc1CFY8J/S81ST4yUx0Efw6LFMdE
 B0UmlopfajXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,174,1610438400"; 
   d="scan'208";a="381885370"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 12 Feb 2021 14:39:00 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 06/11] ice: remove redundant checks in ice_change_mtu
Date:   Fri, 12 Feb 2021 14:39:47 -0800
Message-Id: <20210212223952.1172568-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210212223952.1172568-1-anthony.l.nguyen@intel.com>
References: <20210212223952.1172568-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

dev_validate_mtu checks that mtu value specified by user is not less
than min mtu and not greater than max allowed mtu. It is being done
before calling the ndo_change_mtu exposed by driver, so remove these
redundant checks in ice_change_mtu.

Reviewed-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 813ec6b8ac23..2c23c8f468a5 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6154,15 +6154,6 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
 		}
 	}
 
-	if (new_mtu < (int)netdev->min_mtu) {
-		netdev_err(netdev, "new MTU invalid. min_mtu is %d\n",
-			   netdev->min_mtu);
-		return -EINVAL;
-	} else if (new_mtu > (int)netdev->max_mtu) {
-		netdev_err(netdev, "new MTU invalid. max_mtu is %d\n",
-			   netdev->min_mtu);
-		return -EINVAL;
-	}
 	/* if a reset is in progress, wait for some time for it to complete */
 	do {
 		if (ice_is_reset_in_progress(pf->state)) {
-- 
2.26.2

