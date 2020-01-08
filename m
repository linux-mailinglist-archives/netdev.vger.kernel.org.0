Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B85E813474B
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729363AbgAHQLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:11:22 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:38364 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727668AbgAHQLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:11:22 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id BB3C3B40068;
        Wed,  8 Jan 2020 16:11:20 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 8 Jan 2020 16:11:15 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 04/14] sfc: move mac configuration and status
 functions
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <a0cfb828-b98e-3a63-15d9-592675e81b5f@solarflare.com>
Message-ID: <0699c82f-34d2-188d-e0a3-a99af174ecfa@solarflare.com>
Date:   Wed, 8 Jan 2020 16:11:13 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <a0cfb828-b98e-3a63-15d9-592675e81b5f@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25154.003
X-TM-AS-Result: No-5.432000-8.000000-10
X-TMASE-MatchedRID: ZzU6oHPcbeCh9oPbMj7PPPCoOvLLtsMhP6Tki+9nU38HZBaLwEXlKGb6
        PphVtfZgzmS/x2PkpQxXt0iLVmIq+jIM8IwPLX4dHPYwOJi6PLlvV3/OnMClWnqm3WhT4L+kN17
        Xwn/rN3MnN5ylEm/V3D+etFGa6kdcE34mKqQRiekylU6xjA3vw3607foZgOWy3PShNosIMB74v0
        Dh0LIwCbgKxOTuaXR6+NC+ZuiroDtviq96/QrpGAe06kQGFaIWjoRIaAJe+CjRLEyE6G4DROa7d
        U3Gy7xFP3YGXieKVC2PuKATZf3lO5PhC4EdGR/2j0FWpA5CVPnKIqAq0jIHiss8rKRy6vifMbFL
        Md9Np8yyqbOmmvfNa8zRxGVWzuvgo8WMkQWv6iV95l0nVeyiuJlS5UJNBtxnwrbXMGDYqV+ytvz
        1/F3QBb3abTocZ1+P+E0DdTQKoWrQrQLgIroBoGeZGVMKj/8WVlxr1FJij9s=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.432000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25154.003
X-MDID: 1578499881-MSEA0KzDaKA4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two small functions with different purposes.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c        | 44 --------------------------
 drivers/net/ethernet/sfc/efx_common.c | 45 +++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index c881e35b0477..752470baf4be 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -935,40 +935,6 @@ void efx_channel_dummy_op_void(struct efx_channel *channel)
  *
  **************************************************************************/
 
-/* This ensures that the kernel is kept informed (via
- * netif_carrier_on/off) of the link status, and also maintains the
- * link status's stop on the port's TX queue.
- */
-void efx_link_status_changed(struct efx_nic *efx)
-{
-	struct efx_link_state *link_state = &efx->link_state;
-
-	/* SFC Bug 5356: A net_dev notifier is registered, so we must ensure
-	 * that no events are triggered between unregister_netdev() and the
-	 * driver unloading. A more general condition is that NETDEV_CHANGE
-	 * can only be generated between NETDEV_UP and NETDEV_DOWN */
-	if (!netif_running(efx->net_dev))
-		return;
-
-	if (link_state->up != netif_carrier_ok(efx->net_dev)) {
-		efx->n_link_state_changes++;
-
-		if (link_state->up)
-			netif_carrier_on(efx->net_dev);
-		else
-			netif_carrier_off(efx->net_dev);
-	}
-
-	/* Status message for kernel log */
-	if (link_state->up)
-		netif_info(efx, link, efx->net_dev,
-			   "link up at %uMbps %s-duplex (MTU %d)\n",
-			   link_state->speed, link_state->fd ? "full" : "half",
-			   efx->net_dev->mtu);
-	else
-		netif_info(efx, link, efx->net_dev, "link down\n");
-}
-
 void efx_link_set_advertising(struct efx_nic *efx,
 			      const unsigned long *advertising)
 {
@@ -1010,16 +976,6 @@ void efx_link_set_wanted_fc(struct efx_nic *efx, u8 wanted_fc)
 
 static void efx_fini_port(struct efx_nic *efx);
 
-/* We assume that efx->type->reconfigure_mac will always try to sync RX
- * filters and therefore needs to read-lock the filter table against freeing
- */
-void efx_mac_reconfigure(struct efx_nic *efx)
-{
-	down_read(&efx->filter_sem);
-	efx->type->reconfigure_mac(efx);
-	up_read(&efx->filter_sem);
-}
-
 /* Push loopback/power/transmit disable settings to the PHY, and reconfigure
  * the MAC appropriately. All other PHY configuration changes are pushed
  * through phy_op->set_settings(), and pushed asynchronously to the MAC
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 5cadfba37fc4..be8e80c9d513 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -56,3 +56,48 @@ void efx_destroy_reset_workqueue(void)
 		reset_workqueue = NULL;
 	}
 }
+
+/* We assume that efx->type->reconfigure_mac will always try to sync RX
+ * filters and therefore needs to read-lock the filter table against freeing
+ */
+void efx_mac_reconfigure(struct efx_nic *efx)
+{
+	down_read(&efx->filter_sem);
+	efx->type->reconfigure_mac(efx);
+	up_read(&efx->filter_sem);
+}
+
+/* This ensures that the kernel is kept informed (via
+ * netif_carrier_on/off) of the link status, and also maintains the
+ * link status's stop on the port's TX queue.
+ */
+void efx_link_status_changed(struct efx_nic *efx)
+{
+	struct efx_link_state *link_state = &efx->link_state;
+
+	/* SFC Bug 5356: A net_dev notifier is registered, so we must ensure
+	 * that no events are triggered between unregister_netdev() and the
+	 * driver unloading. A more general condition is that NETDEV_CHANGE
+	 * can only be generated between NETDEV_UP and NETDEV_DOWN
+	 */
+	if (!netif_running(efx->net_dev))
+		return;
+
+	if (link_state->up != netif_carrier_ok(efx->net_dev)) {
+		efx->n_link_state_changes++;
+
+		if (link_state->up)
+			netif_carrier_on(efx->net_dev);
+		else
+			netif_carrier_off(efx->net_dev);
+	}
+
+	/* Status message for kernel log */
+	if (link_state->up)
+		netif_info(efx, link, efx->net_dev,
+			   "link up at %uMbps %s-duplex (MTU %d)\n",
+			   link_state->speed, link_state->fd ? "full" : "half",
+			   efx->net_dev->mtu);
+	else
+		netif_info(efx, link, efx->net_dev, "link down\n");
+}
-- 
2.20.1


