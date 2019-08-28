Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 522D39FAB8
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 08:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbfH1GoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 02:44:14 -0400
Received: from mga03.intel.com ([134.134.136.65]:35206 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726246AbfH1GoN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 02:44:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 23:44:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,440,1559545200"; 
   d="scan'208";a="171443787"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga007.jf.intel.com with ESMTP; 27 Aug 2019 23:44:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/15] e1000e: Make speed detection on hotplugging cable more reliable
Date:   Tue, 27 Aug 2019 23:43:55 -0700
Message-Id: <20190828064407.30168-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828064407.30168-1-jeffrey.t.kirsher@intel.com>
References: <20190828064407.30168-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

After hot plugging an 1Gbps Ethernet cable with 1Gbps link partner, the
MII_BMSR may report 10Mbps, renders the network rather slow.

The issue has much lower fail rate after commit 59653e6497d1 ("e1000e:
Make watchdog use delayed work"), which essentially introduces some
delay before running the watchdog task.

But there's still a chance that the hot plugging event and the queued
watchdog task gets run at the same time, then the original issue can be
observed once again.

So let's use mod_delayed_work() to add a deterministic 1 second delay
before running watchdog task, after an interrupt.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 8a3f035c3a5f..d7d56e42a6aa 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -1780,8 +1780,8 @@ static irqreturn_t e1000_intr_msi(int __always_unused irq, void *data)
 		}
 		/* guard against interrupt when we're going down */
 		if (!test_bit(__E1000_DOWN, &adapter->state))
-			queue_delayed_work(adapter->e1000_workqueue,
-					   &adapter->watchdog_task, 1);
+			mod_delayed_work(adapter->e1000_workqueue,
+					 &adapter->watchdog_task, HZ);
 	}
 
 	/* Reset on uncorrectable ECC error */
@@ -1861,8 +1861,8 @@ static irqreturn_t e1000_intr(int __always_unused irq, void *data)
 		}
 		/* guard against interrupt when we're going down */
 		if (!test_bit(__E1000_DOWN, &adapter->state))
-			queue_delayed_work(adapter->e1000_workqueue,
-					   &adapter->watchdog_task, 1);
+			mod_delayed_work(adapter->e1000_workqueue,
+					 &adapter->watchdog_task, HZ);
 	}
 
 	/* Reset on uncorrectable ECC error */
@@ -1907,8 +1907,8 @@ static irqreturn_t e1000_msix_other(int __always_unused irq, void *data)
 		hw->mac.get_link_status = true;
 		/* guard against interrupt when we're going down */
 		if (!test_bit(__E1000_DOWN, &adapter->state))
-			queue_delayed_work(adapter->e1000_workqueue,
-					   &adapter->watchdog_task, 1);
+			mod_delayed_work(adapter->e1000_workqueue,
+					 &adapter->watchdog_task, HZ);
 	}
 
 	if (!test_bit(__E1000_DOWN, &adapter->state))
-- 
2.21.0

