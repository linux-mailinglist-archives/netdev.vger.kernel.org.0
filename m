Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48379694A6
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391391AbfGOOaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403836AbfGOO3y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:29:54 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC45721537;
        Mon, 15 Jul 2019 14:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200993;
        bh=s53WbnFm4I6XyE3LnDexWv29+hu4nWC7lg1rwZPd+18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J61m+C0sJMkvTfyCC69YIFWD8GZNx5xSBpQB4ODKuisngl5vGBSkC3nXqoMi9IPPJ
         0e9wMy9AZ+/1AaMe2DQovSzGgl+c4YeqYV2A0gnvhTMdLeoJxMhGG0Td4DFtBmd4GS
         rStmgNJBjx1VAkOfnI9HZMa2bP/PupkfgAFmRKXI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Joseph Yasi <joe.yasi@gmail.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Oleksandr Natalenko <oleksandr@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 022/105] Revert "e1000e: fix cyclic resets at link up with active tx"
Date:   Mon, 15 Jul 2019 10:27:16 -0400
Message-Id: <20190715142839.9896-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715142839.9896-1-sashal@kernel.org>
References: <20190715142839.9896-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

[ Upstream commit caff422ea81e144842bc44bab408d85ac449377b ]

This reverts commit 0f9e980bf5ee1a97e2e401c846b2af989eb21c61.

That change cased false-positive warning about hardware hang:

e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
e1000e 0000:00:1f.6 eth0: Detected Hardware Unit Hang:
   TDH                  <0>
   TDT                  <1>
   next_to_use          <1>
   next_to_clean        <0>
buffer_info[next_to_clean]:
   time_stamp           <fffba7a7>
   next_to_watch        <0>
   jiffies              <fffbb140>
   next_to_watch.status <0>
MAC Status             <40080080>
PHY Status             <7949>
PHY 1000BASE-T Status  <0>
PHY Extended Status    <3000>
PCI Status             <10>
e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx

Besides warning everything works fine.
Original issue will be fixed property in following patch.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Reported-by: Joseph Yasi <joe.yasi@gmail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=203175
Tested-by: Joseph Yasi <joe.yasi@gmail.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Tested-by: Oleksandr Natalenko <oleksandr@redhat.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 3c214a47c1c4..5c364321d3c6 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5306,13 +5306,8 @@ static void e1000_watchdog_task(struct work_struct *work)
 			/* 8000ES2LAN requires a Rx packet buffer work-around
 			 * on link down event; reset the controller to flush
 			 * the Rx packet buffer.
-			 *
-			 * If the link is lost the controller stops DMA, but
-			 * if there is queued Tx work it cannot be done.  So
-			 * reset the controller to flush the Tx packet buffers.
 			 */
-			if ((adapter->flags & FLAG_RX_NEEDS_RESTART) ||
-			    e1000_desc_unused(tx_ring) + 1 < tx_ring->count)
+			if (adapter->flags & FLAG_RX_NEEDS_RESTART)
 				adapter->flags |= FLAG_RESTART_NOW;
 			else
 				pm_schedule_suspend(netdev->dev.parent,
@@ -5335,6 +5330,14 @@ static void e1000_watchdog_task(struct work_struct *work)
 	adapter->gotc_old = adapter->stats.gotc;
 	spin_unlock(&adapter->stats64_lock);
 
+	/* If the link is lost the controller stops DMA, but
+	 * if there is queued Tx work it cannot be done.  So
+	 * reset the controller to flush the Tx packet buffers.
+	 */
+	if (!netif_carrier_ok(netdev) &&
+	    (e1000_desc_unused(tx_ring) + 1 < tx_ring->count))
+		adapter->flags |= FLAG_RESTART_NOW;
+
 	/* If reset is necessary, do it outside of interrupt context. */
 	if (adapter->flags & FLAG_RESTART_NOW) {
 		schedule_work(&adapter->reset_task);
-- 
2.20.1

