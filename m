Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01ED32FA4A6
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 16:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405820AbhARP1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 10:27:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:63424 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393453AbhARPYk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 10:24:40 -0500
IronPort-SDR: VnmMtiq3XwfHbDH6euXN7XOvzkEJhYJbVtI7OILUgxtaNyYlgU+IQUFALBiG2wclMa7t8oKtZM
 GZ+4Gl2r1HrQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9867"; a="165905528"
X-IronPort-AV: E=Sophos;i="5.79,356,1602572400"; 
   d="scan'208";a="165905528"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2021 07:23:07 -0800
IronPort-SDR: 9Z09z4AQZSOaXL7RKy7c++fmufl2dMwJ7Auq1L5+b+VxYQVh06y4eIeWJTu6M1s1vfTWZWfDTj
 gjID006UC1uQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,356,1602572400"; 
   d="scan'208";a="500676349"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 18 Jan 2021 07:23:05 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 net-next 06/11] ice: remove redundant checks in ice_change_mtu
Date:   Mon, 18 Jan 2021 16:13:13 +0100
Message-Id: <20210118151318.12324-7-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210118151318.12324-1-maciej.fijalkowski@intel.com>
References: <20210118151318.12324-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev_validate_mtu checks that mtu value specified by user is not less
than min mtu and not greater than max allowed mtu. It is being done
before calling the ndo_change_mtu exposed by driver, so remove these
redundant checks in ice_change_mtu.

Reviewed-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 6e251dfffc91..868d4c224eaf 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6123,15 +6123,6 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
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
2.20.1

