Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2A1211623
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbgGAWep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:34:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:25461 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728055AbgGAWed (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 18:34:33 -0400
IronPort-SDR: UpnSO3X6VPv53KtBFTobBk2QWB1+7RtUa/D8msPmG7jf01tZicL0FSjWvWpBDy453DsuHmrMLf
 P6L68o+mGmrw==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="134178609"
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="134178609"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 15:34:22 -0700
IronPort-SDR: nTGNJbtNPjR6VsmYxliLS6/0QQXUg6Udbrso1i1V1C7I86lHuJq9ADf8ra/9KnoFcBeFgRU8Nv
 n2DzDKE6RW4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="455276131"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga005.jf.intel.com with ESMTP; 01 Jul 2020 15:34:22 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, anthony.nguyen@intel.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Jack Vogel <jack.vogel@oracle.com>,
        Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [net-next 11/12] ixgbe: Cleanup unneeded delay in ethtool test
Date:   Wed,  1 Jul 2020 15:34:11 -0700
Message-Id: <20200701223412.2675606-12-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701223412.2675606-1-anthony.l.nguyen@intel.com>
References: <20200701223412.2675606-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

There is a 4 seconds delay in ixgbe_diag_test() that is holding up other
ioctls such as SIOCGIFCONF that Oracle database applications use.
One of Oracle's product runs "ethtool -t ethX online" periodically for
system monitoring and that is impacting database applications that use
SIOCGIFCONF at that same time.

This 4 second delay was needed in out early 1GbE parts to give the PHY
time to recover from a reset.  This code was carried forward to the 10 GbE
driver even it was not needed for the supported PHYs in the ixgbe driver.

CC: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
CC: Jack Vogel <jack.vogel@oracle.com>
Reported-by: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index 8ae2c8c2f6a1..fd6784952766 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -2084,7 +2084,7 @@ static void ixgbe_diag_test(struct net_device *netdev,
 					eth_test->flags |= ETH_TEST_FL_FAILED;
 					clear_bit(__IXGBE_TESTING,
 						  &adapter->state);
-					goto skip_ol_tests;
+					return;
 				}
 			}
 		}
@@ -2156,9 +2156,6 @@ static void ixgbe_diag_test(struct net_device *netdev,
 
 		clear_bit(__IXGBE_TESTING, &adapter->state);
 	}
-
-skip_ol_tests:
-	msleep_interruptible(4 * 1000);
 }
 
 static int ixgbe_wol_exclusion(struct ixgbe_adapter *adapter,
-- 
2.26.2

