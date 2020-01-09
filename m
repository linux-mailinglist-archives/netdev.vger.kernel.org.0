Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE703135D24
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 16:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731114AbgAIPpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 10:45:40 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:35508 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728293AbgAIPpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 10:45:40 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9ACA74C0058;
        Thu,  9 Jan 2020 15:45:38 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 9 Jan 2020 15:45:33 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 8/9] sfc: conditioned some functionality
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <4d915542-3699-e864-5558-bef616b2fe66@solarflare.com>
Message-ID: <29a21f9b-89cf-7b96-7d40-dc6e4337f5a7@solarflare.com>
Date:   Thu, 9 Jan 2020 15:45:29 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <4d915542-3699-e864-5558-bef616b2fe66@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25156.003
X-TM-AS-Result: No-1.575200-8.000000-10
X-TMASE-MatchedRID: EZ7U6sBz/WkiXL+V+zm5iWXaK3KHx/xpfglgnB0nDhORjx4hNpIk+MiT
        Wug2C4DNl1M7KT9/aqCJYZ+Td59n+wihmwiXCMoGPwKTD1v8YV5UENBIMyKD0Z6fSoF3Lt+MBd8
        bdVqDg9aIzrX3FVHctr9EmJCg8SyV5SstZ9GMMDLVsW2YGqoUtPi4nVERfgwd4uxAgOavdLkeKT
        4XxefQztkSGtLuaHmmwiLT2fbw6Ec4lC5Kv9wUbvKUR83BvqItu8ZgmQ167rWZfDRE1uqSghbjW
        LZHubLuNi549oderixIeru43e37021A5vznb2t5k3rl+MaNgxABDya2JbH/+pjXwNZnZ8zAjUea
        G9ClNrji8zVgXoAltlwtzewu2M63jaPj0W1qn0SujVRFkkVsmxrqfx3VAbA3g8Ystwpe1vsu/Ob
        jZgMg6zxN67gKONwvIT0uOlCF7ViFdHHpiqV5sKqptXt1VEOmaWsxNvCL7JGQR1p5b/QLQZBEcr
        kRxYJ4UjKnO1KVKKwSkbDwum07zqq0MV8nSMBvqoKcUEhMHDg=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-1.575200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25156.003
X-MDID: 1578584739-CofA3q4r6wsZ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before calling certain function pointers, check that they are non-NULL.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/efx_channels.c |  6 ++--
 drivers/net/ethernet/sfc/efx_common.c   | 47 +++++++++++++++----------
 2 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 21bd71daf5a0..aeb5e8aa2f2a 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -1039,7 +1039,7 @@ void efx_stop_channels(struct efx_nic *efx)
 	struct efx_tx_queue *tx_queue;
 	struct efx_rx_queue *rx_queue;
 	struct efx_channel *channel;
-	int rc;
+	int rc = 0;
 
 	/* Stop RX refill */
 	efx_for_each_channel(channel, efx) {
@@ -1060,7 +1060,9 @@ void efx_stop_channels(struct efx_nic *efx)
 		}
 	}
 
-	rc = efx->type->fini_dmaq(efx);
+	if (efx->type->fini_dmaq)
+		rc = efx->type->fini_dmaq(efx);
+
 	if (rc) {
 		netif_err(efx, drv, efx->net_dev, "failed to flush queues\n");
 	} else {
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index fe74c66c8ec6..3add2b577503 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -141,9 +141,11 @@ void efx_destroy_reset_workqueue(void)
  */
 void efx_mac_reconfigure(struct efx_nic *efx)
 {
-	down_read(&efx->filter_sem);
-	efx->type->reconfigure_mac(efx);
-	up_read(&efx->filter_sem);
+	if (efx->type->reconfigure_mac) {
+		down_read(&efx->filter_sem);
+		efx->type->reconfigure_mac(efx);
+		up_read(&efx->filter_sem);
+	}
 }
 
 /* Asynchronous work item for changing MAC promiscuity and multicast
@@ -296,7 +298,8 @@ static void efx_start_datapath(struct efx_nic *efx)
 		netdev_features_change(efx->net_dev);
 
 	/* RX filters may also have scatter-enabled flags */
-	if (efx->rx_scatter != old_rx_scatter)
+	if ((efx->rx_scatter != old_rx_scatter) &&
+	    efx->type->filter_update_rx_scatter)
 		efx->type->filter_update_rx_scatter(efx);
 
 	/* We must keep at least one descriptor in a TX ring empty.
@@ -405,11 +408,13 @@ void efx_start_all(struct efx_nic *efx)
 		efx_link_status_changed(efx);
 	mutex_unlock(&efx->mac_lock);
 
-	efx->type->start_stats(efx);
-	efx->type->pull_stats(efx);
-	spin_lock_bh(&efx->stats_lock);
-	efx->type->update_stats(efx, NULL, NULL);
-	spin_unlock_bh(&efx->stats_lock);
+	if (efx->type->start_stats) {
+		efx->type->start_stats(efx);
+		efx->type->pull_stats(efx);
+		spin_lock_bh(&efx->stats_lock);
+		efx->type->update_stats(efx, NULL, NULL);
+		spin_unlock_bh(&efx->stats_lock);
+	}
 }
 
 /* Quiesce the hardware and software data path, and regular activity
@@ -425,14 +430,17 @@ void efx_stop_all(struct efx_nic *efx)
 	if (!efx->port_enabled)
 		return;
 
-	/* update stats before we go down so we can accurately count
-	 * rx_nodesc_drops
-	 */
-	efx->type->pull_stats(efx);
-	spin_lock_bh(&efx->stats_lock);
-	efx->type->update_stats(efx, NULL, NULL);
-	spin_unlock_bh(&efx->stats_lock);
-	efx->type->stop_stats(efx);
+	if (efx->type->update_stats) {
+		/* update stats before we go down so we can accurately count
+		 * rx_nodesc_drops
+		 */
+		efx->type->pull_stats(efx);
+		spin_lock_bh(&efx->stats_lock);
+		efx->type->update_stats(efx, NULL, NULL);
+		spin_unlock_bh(&efx->stats_lock);
+		efx->type->stop_stats(efx);
+	}
+
 	efx_stop_port(efx);
 
 	/* Stop the kernel transmit interface.  This is only valid if
@@ -456,7 +464,7 @@ void efx_stop_all(struct efx_nic *efx)
 int __efx_reconfigure_port(struct efx_nic *efx)
 {
 	enum efx_phy_mode phy_mode;
-	int rc;
+	int rc = 0;
 
 	WARN_ON(!mutex_is_locked(&efx->mac_lock));
 
@@ -467,7 +475,8 @@ int __efx_reconfigure_port(struct efx_nic *efx)
 	else
 		efx->phy_mode &= ~PHY_MODE_TX_DISABLED;
 
-	rc = efx->type->reconfigure_port(efx);
+	if (efx->type->reconfigure_port)
+		rc = efx->type->reconfigure_port(efx);
 
 	if (rc)
 		efx->phy_mode = phy_mode;
-- 
2.20.1


