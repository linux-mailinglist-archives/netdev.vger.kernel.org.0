Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66DBD35A687
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 21:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234880AbhDITCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 15:02:06 -0400
Received: from mga04.intel.com ([192.55.52.120]:13032 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234825AbhDITBz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 15:01:55 -0400
IronPort-SDR: QEANcEU5+lOW2Q4CK7NkyjHe+dtlowgPkXdT7PcsQpJ2d1mT+0NE+Q3aJlUQuyCHWfjQrS1Y1C
 GQQ8bFGJpJCw==
X-IronPort-AV: E=McAfee;i="6000,8403,9949"; a="191674938"
X-IronPort-AV: E=Sophos;i="5.82,210,1613462400"; 
   d="scan'208";a="191674938"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2021 12:01:33 -0700
IronPort-SDR: HXdsUcLdD/UAGQDofA0qdRNmLVRMryccxGUBl+Nf15lkX9Kjnxkpxzhsaav1nzvLvYHx9NOsG9
 MTzH4iIGt0XA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,210,1613462400"; 
   d="scan'208";a="449181592"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Apr 2021 12:01:32 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Radoslaw Tyl <radoslawx.tyl@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 2/4] ixgbe: aggregate of all receive errors through netdev's rx_errors
Date:   Fri,  9 Apr 2021 12:03:12 -0700
Message-Id: <20210409190314.946192-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210409190314.946192-1-anthony.l.nguyen@intel.com>
References: <20210409190314.946192-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Radoslaw Tyl <radoslawx.tyl@intel.com>

The global rx error does not take into account all the error counters
that are counted by device.

Extend rx error with the following counters:
- illegal byte error
- number of receive fragment errors
- receive jabber
- receive oversize error
- receive undersize error
- frames marked as checksum invalid by hardware

The above were added in order to align statistics with other products.

Signed-off-by: Radoslaw Tyl <radoslawx.tyl@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 7ba1c2985ef7..7711828401d9 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -7240,12 +7240,21 @@ void ixgbe_update_stats(struct ixgbe_adapter *adapter)
 	hwstats->ptc1023 += IXGBE_READ_REG(hw, IXGBE_PTC1023);
 	hwstats->ptc1522 += IXGBE_READ_REG(hw, IXGBE_PTC1522);
 	hwstats->bptc += IXGBE_READ_REG(hw, IXGBE_BPTC);
+	hwstats->illerrc += IXGBE_READ_REG(hw, IXGBE_ILLERRC);
 
 	/* Fill out the OS statistics structure */
 	netdev->stats.multicast = hwstats->mprc;
 
 	/* Rx Errors */
-	netdev->stats.rx_errors = hwstats->crcerrs + hwstats->rlec;
+	netdev->stats.rx_errors = hwstats->crcerrs +
+				    hwstats->illerrc +
+				    hwstats->rlec +
+				    hwstats->rfc +
+				    hwstats->rjc +
+				    hwstats->roc +
+				    hwstats->ruc +
+				    hw_csum_rx_error;
+
 	netdev->stats.rx_dropped = 0;
 	netdev->stats.rx_length_errors = hwstats->rlec;
 	netdev->stats.rx_crc_errors = hwstats->crcerrs;
-- 
2.26.2

