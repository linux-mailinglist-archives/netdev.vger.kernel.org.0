Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52F248673B
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 18:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731278AbfHHQiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 12:38:01 -0400
Received: from mga03.intel.com ([134.134.136.65]:59082 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbfHHQiB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 12:38:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Aug 2019 09:38:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,362,1559545200"; 
   d="scan'208";a="169041687"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 08 Aug 2019 09:38:00 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Taehee Yoo <ap420073@gmail.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net v2] ixgbe: fix possible deadlock in ixgbe_service_task()
Date:   Thu,  8 Aug 2019 09:37:56 -0700
Message-Id: <20190808163756.8753-1-jeffrey.t.kirsher@intel.com>
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
v2: removed unnecessary curly brackets

 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index cbaf712d6529..7882148abb43 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -7897,11 +7897,8 @@ static void ixgbe_service_task(struct work_struct *work)
 		return;
 	}
 	if (ixgbe_check_fw_error(adapter)) {
-		if (!test_bit(__IXGBE_DOWN, &adapter->state)) {
-			rtnl_lock();
+		if (!test_bit(__IXGBE_DOWN, &adapter->state))
 			unregister_netdev(adapter->netdev);
-			rtnl_unlock();
-		}
 		ixgbe_service_event_complete(adapter);
 		return;
 	}
-- 
2.21.0

