Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8C15693B9
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405058AbfGOOq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:46:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405042AbfGOOq1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:46:27 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7004D217D9;
        Mon, 15 Jul 2019 14:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563201986;
        bh=Bcre74LP3qZUlvaMJu16xth5AC2Y+f555bvTJ3SPdNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sxEpS3DyRW3WPBeMlh0U89gcw9YtGWMQquKNRWKFdxND95rnD+ooPkPJll/hk5UDj
         80UeFoO+krl+TJR0rgHpIbpRbEQZTNGcAVwgSKTclmO8Q+JJULjbRk9P531E4PdFAU
         75qSSpg81PdsHJGHfQ5Ri8KsHC6FpnBMVqYG2OMc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Joseph Yasi <joe.yasi@gmail.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Oleksandr Natalenko <oleksandr@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 15/53] e1000e: start network tx queue only when link is up
Date:   Mon, 15 Jul 2019 10:44:57 -0400
Message-Id: <20190715144535.11636-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715144535.11636-1-sashal@kernel.org>
References: <20190715144535.11636-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

[ Upstream commit d17ba0f616a08f597d9348c372d89b8c0405ccf3 ]

Driver does not want to keep packets in Tx queue when link is lost.
But present code only reset NIC to flush them, but does not prevent
queuing new packets. Moreover reset sequence itself could generate
new packets via netconsole and NIC falls into endless reset loop.

This patch wakes Tx queue only when NIC is ready to send packets.

This is proper fix for problem addressed by commit 0f9e980bf5ee
("e1000e: fix cyclic resets at link up with active tx").

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Tested-by: Joseph Yasi <joe.yasi@gmail.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Tested-by: Oleksandr Natalenko <oleksandr@redhat.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 6b1cacd86c6e..7d64edeb1830 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -4171,7 +4171,7 @@ int e1000e_up(struct e1000_adapter *adapter)
 		e1000_configure_msix(adapter);
 	e1000_irq_enable(adapter);
 
-	netif_start_queue(adapter->netdev);
+	/* Tx queue started by watchdog timer when link is up */
 
 	/* fire a link change interrupt to start the watchdog */
 	if (adapter->msix_entries)
@@ -4539,6 +4539,7 @@ static int e1000_open(struct net_device *netdev)
 	pm_runtime_get_sync(&pdev->dev);
 
 	netif_carrier_off(netdev);
+	netif_stop_queue(netdev);
 
 	/* allocate transmit descriptors */
 	err = e1000e_setup_tx_resources(adapter->tx_ring);
@@ -4599,7 +4600,6 @@ static int e1000_open(struct net_device *netdev)
 	e1000_irq_enable(adapter);
 
 	adapter->tx_hang_recheck = false;
-	netif_start_queue(netdev);
 
 	hw->mac.get_link_status = true;
 	pm_runtime_put(&pdev->dev);
@@ -5226,6 +5226,7 @@ static void e1000_watchdog_task(struct work_struct *work)
 			if (phy->ops.cfg_on_link_up)
 				phy->ops.cfg_on_link_up(hw);
 
+			netif_wake_queue(netdev);
 			netif_carrier_on(netdev);
 
 			if (!test_bit(__E1000_DOWN, &adapter->state))
@@ -5239,6 +5240,7 @@ static void e1000_watchdog_task(struct work_struct *work)
 			/* Link status message must follow this format */
 			pr_info("%s NIC Link is Down\n", adapter->netdev->name);
 			netif_carrier_off(netdev);
+			netif_stop_queue(netdev);
 			if (!test_bit(__E1000_DOWN, &adapter->state))
 				mod_timer(&adapter->phy_info_timer,
 					  round_jiffies(jiffies + 2 * HZ));
-- 
2.20.1

