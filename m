Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22E28688DC
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 14:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729977AbfGOM0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 08:26:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46840 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728933AbfGOM0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 08:26:09 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1hn03R-0004qz-1F; Mon, 15 Jul 2019 12:26:05 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     jeffrey.t.kirsher@intel.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH v2] e1000e: Make speed detection on hotplugging cable more reliable
Date:   Mon, 15 Jul 2019 20:25:55 +0800
Message-Id: <20190715122555.11922-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190715084355.9962-1-kai.heng.feng@canonical.com>
References: <20190715084355.9962-1-kai.heng.feng@canonical.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After hotplugging an 1Gbps ethernet cable with 1Gbps link partner, the
MII_BMSR may report 10Mbps, renders the network rather slow.

The issue has much lower fail rate after commit 59653e6497d1 ("e1000e:
Make watchdog use delayed work"), which essentially introduces some
delay before running the watchdog task.

But there's still a chance that the hotplugging event and the queued
watchdog task gets run at the same time, then the original issue can be
observed once again.

So let's use mod_delayed_work() to add a deterministic 1 second delay
before running watchdog task, after an interrupt.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index e4baa13b3cda..c83bf5349d53 100644
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
2.17.1

