Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17753164F77
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 21:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbgBSUDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 15:03:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:51506 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727125AbgBSUC5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 15:02:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 12:02:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,461,1574150400"; 
   d="scan'208";a="228700490"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.76])
  by fmsmga007.fm.intel.com with ESMTP; 19 Feb 2020 12:02:56 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Michal Swiatkowski <michal.swiatkowski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 2/3] ice: Don't tell the OS that link is going down
Date:   Wed, 19 Feb 2020 12:02:50 -0800
Message-Id: <20200219200251.370445-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200219200251.370445-1-jeffrey.t.kirsher@intel.com>
References: <20200219200251.370445-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@intel.com>

Remove code that tell the OS that link is going down when user
change flow control via ethtool. When link is up it isn't certain
that link goes down after 0x0605 aq command. If link doesn't go
down, OS thinks that link is down, but physical link is up. To
reset this state user have to take interface down and up.

If link goes down after 0x0605 command, FW send information
about that and after that driver tells the OS that the link goes
down. So this code in ethtool is unnecessary.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index a88763066681..77c412a7e7a4 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -2936,13 +2936,6 @@ ice_set_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
 	else
 		return -EINVAL;
 
-	/* Tell the OS link is going down, the link will go back up when fw
-	 * says it is ready asynchronously
-	 */
-	ice_print_link_msg(vsi, false);
-	netif_carrier_off(netdev);
-	netif_tx_stop_all_queues(netdev);
-
 	/* Set the FC mode and only restart AN if link is up */
 	status = ice_set_fc(pi, &aq_failures, link_up);
 
-- 
2.24.1

