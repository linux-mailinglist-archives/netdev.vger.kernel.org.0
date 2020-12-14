Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331C12D9AE1
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 16:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgLNPY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 10:24:29 -0500
Received: from mga17.intel.com ([192.55.52.151]:28670 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727908AbgLNPYI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 10:24:08 -0500
IronPort-SDR: zikulLBhGY4nyepekg1Jv3vhpXvzhiI5L8Nt/e9d8M2G23PtCGMea+1w+OfOuhyaNhrP1zetNT
 OLgaFjQHfbdg==
X-IronPort-AV: E=McAfee;i="6000,8403,9834"; a="154531359"
X-IronPort-AV: E=Sophos;i="5.78,420,1599548400"; 
   d="scan'208";a="154531359"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2020 07:23:07 -0800
IronPort-SDR: tMWyc6D7apkB+5WNsBfOIi7PhA1KpYYKW0XEbqrlnAFjJeU72prQ8475bbhanQagkBaYMRx4/B
 4GFm0E8cep7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,420,1599548400"; 
   d="scan'208";a="411285741"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga001.jf.intel.com with ESMTP; 14 Dec 2020 07:23:04 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 net-next 6/8] ice: remove redundant checks in ice_change_mtu
Date:   Mon, 14 Dec 2020 16:13:06 +0100
Message-Id: <20201214151308.15275-7-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201214151308.15275-1-maciej.fijalkowski@intel.com>
References: <20201214151308.15275-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev_validate_mtu checks that mtu value specified by user is not less
than min mtu and not greater than max allowed mtu. It is being done
before calling the ndo_change_mtu exposed by driver, so remove these
redundant checks in ice_change_mtu.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2dea4d0e9415..476e20af7309 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6126,15 +6126,6 @@ static int ice_change_mtu(struct net_device *netdev, int new_mtu)
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

