Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC1D1DE04A
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 08:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgEVG4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 02:56:20 -0400
Received: from mga14.intel.com ([192.55.52.115]:18660 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728302AbgEVG4M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 02:56:12 -0400
IronPort-SDR: CbMP9nOqEHJ4rhVwgXZhvl99cSxw27uwD1X2lmjEfF2cQOAg9Vt6S/YvUoYG8CC6mQbSeJjzCV
 y5EMetXrKqNg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 23:56:10 -0700
IronPort-SDR: wVdRAukIMoW3YqAEpvW6hsL7fh6paS3YGk2Rj6NtLFX0Ioc2WucBOYP+J2j7DRJ7GKJFuuh4Qi
 aK5uywOSt+/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,420,1583222400"; 
   d="scan'208";a="290017751"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 21 May 2020 23:56:09 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/17] ice: only drop link once when setting pauseparams
Date:   Thu, 21 May 2020 23:55:56 -0700
Message-Id: <20200522065607.1680050-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
References: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

Currently, the ice driver is setting a PHY configuration,
which causes a link drop, and then additionally it calls
for a nway_reset, which restarts auto-negotiation on the
link, which also causes a link drop.  These two link
events in such close timing is causing the FW to not be
able to generate a link interrupt for the driver to
respond to.

Remove the unnecessary auto-negotiation restart from the
set pauseparams flow.  Also remove error path that
would have performed an ice_down/ice_up as that is
also unnecessary.

Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 66d0bcc51ad9..db547c0c7c6f 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2977,18 +2977,6 @@ ice_set_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
 		err = -EAGAIN;
 	}
 
-	if (!test_bit(__ICE_DOWN, pf->state)) {
-		/* Give it a little more time to try to come back. If still
-		 * down, restart autoneg link or reinitialize the interface.
-		 */
-		msleep(75);
-		if (!test_bit(__ICE_DOWN, pf->state))
-			return ice_nway_reset(netdev);
-
-		ice_down(vsi);
-		ice_up(vsi);
-	}
-
 	return err;
 }
 
-- 
2.26.2

