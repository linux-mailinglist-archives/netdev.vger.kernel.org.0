Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215EB1AFDCD
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 21:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgDSTvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 15:51:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:45111 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726468AbgDSTve (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 15:51:34 -0400
IronPort-SDR: PNO33n8AuLN7E20mRxTD82PCs0Zz63A4Hp5UtXpAoSMSh/yM5oLtqzTZbNpuriNP86VTk23eFr
 o7EDv9rRxwfw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2020 12:51:34 -0700
IronPort-SDR: pImYey2N0QFm0L9+o94RkjrWyuM/afKc7aeLIld/sYEWzdTEw5Mt2h4oT22u1z+471DtzpP5H7
 epqNWTm6osYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,404,1580803200"; 
   d="scan'208";a="279034412"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 19 Apr 2020 12:51:33 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/14] igc: Fix igc_uc_unsync()
Date:   Sun, 19 Apr 2020 12:51:23 -0700
Message-Id: <20200419195131.1068144-7-jeffrey.t.kirsher@intel.com>
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

In case igc_del_mac_filter() returns error, that error is masked
since the functions always return 0 (success). This patch fixes
igc_uc_unsync() so it returns whatever value igc_del_mac_filter()
returns (0 on success, negative number on error).

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 7c060c731a7e..dc4632428117 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2284,9 +2284,7 @@ static int igc_uc_unsync(struct net_device *netdev, const unsigned char *addr)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
 
-	igc_del_mac_filter(adapter, addr, adapter->num_rx_queues, 0);
-
-	return 0;
+	return igc_del_mac_filter(adapter, addr, adapter->num_rx_queues, 0);
 }
 
 /**
-- 
2.25.2

