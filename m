Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 710C0825D5
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 22:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbfHEUEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 16:04:07 -0400
Received: from mga03.intel.com ([134.134.136.65]:18729 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727802AbfHEUEH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 16:04:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Aug 2019 13:04:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,350,1559545200"; 
   d="scan'208";a="192491788"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga001.fm.intel.com with ESMTP; 05 Aug 2019 13:04:06 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Taehee Yoo <ap420073@gmail.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net] ixgbe: fix possible deadlock in ixgbe_service_task()
Date:   Mon,  5 Aug 2019 13:04:03 -0700
Message-Id: <20190805200403.23512-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

ixgbe_service_task() calls unregister_netdev() under rtnl_lock().
But unregister_netdev() internally calls rtnl_lock().
So deadlock would occur.

Fixes: 59dd45d550c5 ("ixgbe: firmware recovery mode")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index cbaf712d6529..3386e752e458 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -7898,9 +7898,7 @@ static void ixgbe_service_task(struct work_struct *work)
 	}
 	if (ixgbe_check_fw_error(adapter)) {
 		if (!test_bit(__IXGBE_DOWN, &adapter->state)) {
-			rtnl_lock();
 			unregister_netdev(adapter->netdev);
-			rtnl_unlock();
 		}
 		ixgbe_service_event_complete(adapter);
 		return;
-- 
2.21.0

