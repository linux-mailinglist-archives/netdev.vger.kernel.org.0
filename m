Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977D31AFDCE
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 21:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgDSTvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 15:51:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:45111 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726474AbgDSTve (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 15:51:34 -0400
IronPort-SDR: Wt7fcsI7yCUVQU30qRCoRL/sXbVfQJwwPSumIARD/J33Z6+hAfSHQZgobrW8+h0DCRmHSRVOfn
 RS0H+d11Qh6w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2020 12:51:34 -0700
IronPort-SDR: cuu4+orhvisFJDZNSb43+4MRSyzTz90CsRCxuYekRCYroTqv9bHwkTRyLEIlrR5KbQq87QVDx+
 bGn28KpfMhyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,404,1580803200"; 
   d="scan'208";a="279034419"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 19 Apr 2020 12:51:34 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/14] igc: Improve address check in igc_del_mac_filter()
Date:   Sun, 19 Apr 2020 12:51:25 -0700
Message-Id: <20200419195131.1068144-9-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200419195131.1068144-1-jeffrey.t.kirsher@intel.com>
References: <20200419195131.1068144-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

igc_add_mac_filter() doesn't allow filters with invalid MAC address to
be added to adapter->mac_table so, in igc_del_mac_filter(), we can early
return if MAC address is invalid. No need to traverse the table.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 2f6c8f7fa6f4..070df92bb4e9 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2246,7 +2246,7 @@ static int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 	int rar_entries = hw->mac.rar_entry_count;
 	int i;
 
-	if (is_zero_ether_addr(addr))
+	if (!is_valid_ether_addr(addr))
 		return -EINVAL;
 
 	/* Search for matching entry in the MAC table based on given address
-- 
2.25.2

