Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F05B738EA85
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbhEXO4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:56:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:34042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234008AbhEXOyL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:54:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C681361209;
        Mon, 24 May 2021 14:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867713;
        bh=TF/qj6MsyTfCWW6Sy3Xf+5vmaVBmzcfNfgM/oOfTEJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cPdOc32cY62IXCACDJgYMRhNzROHUiQ9xQN3FUPZPVib6r0NB9DcOgx7YLQbXbwiN
         QOXhkfmuDcN5RpFCF5/lBKPCjl4H0KGZ6KpqFHkIRyzNVAFECFfsH2TI9T657I/Yhb
         BQhOyiieekhhd9HQeVZusQLDHuH3jDvkoUlJR+bOqJgteXrq4tGX3lK6yS+xZh+V/m
         leU/UEttZFTFmngqTZ1UcyXkrp4o39gka0OmjVrcLRWVgUmPoEk9mdJRFPluTsgpXg
         mOglwZQUH2oagu4jvzXmstc6sWuZy5oAEB5PO4ya815OlLd96UkMBG9V1HC5e67/mG
         KrPLo+/t85/oA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tom Seewald <tseewald@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 40/62] net: liquidio: Add missing null pointer checks
Date:   Mon, 24 May 2021 10:47:21 -0400
Message-Id: <20210524144744.2497894-40-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144744.2497894-1-sashal@kernel.org>
References: <20210524144744.2497894-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Seewald <tseewald@gmail.com>

[ Upstream commit dbc97bfd3918ed9268bfc174cae8a7d6b3d51aad ]

The functions send_rx_ctrl_cmd() in both liquidio/lio_main.c and
liquidio/lio_vf_main.c do not check if the call to
octeon_alloc_soft_command() fails and returns a null pointer. Both
functions also return void so errors are not propagated back to the
caller.

Fix these issues by updating both instances of send_rx_ctrl_cmd() to
return an integer rather than void, and have them return -ENOMEM if an
allocation failure occurs. Also update all callers of send_rx_ctrl_cmd()
so that they now check the return value.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Tom Seewald <tseewald@gmail.com>
Link: https://lore.kernel.org/r/20210503115736.2104747-66-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/cavium/liquidio/lio_main.c   | 28 +++++++++++++------
 .../ethernet/cavium/liquidio/lio_vf_main.c    | 27 +++++++++++++-----
 2 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index e4c220f30040..e0d18e917108 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -1153,7 +1153,7 @@ static void octeon_destroy_resources(struct octeon_device *oct)
  * @lio: per-network private data
  * @start_stop: whether to start or stop
  */
-static void send_rx_ctrl_cmd(struct lio *lio, int start_stop)
+static int send_rx_ctrl_cmd(struct lio *lio, int start_stop)
 {
 	struct octeon_soft_command *sc;
 	union octnet_cmd *ncmd;
@@ -1161,11 +1161,16 @@ static void send_rx_ctrl_cmd(struct lio *lio, int start_stop)
 	int retval;
 
 	if (oct->props[lio->ifidx].rx_on == start_stop)
-		return;
+		return 0;
 
 	sc = (struct octeon_soft_command *)
 		octeon_alloc_soft_command(oct, OCTNET_CMD_SIZE,
 					  16, 0);
+	if (!sc) {
+		netif_info(lio, rx_err, lio->netdev,
+			   "Failed to allocate octeon_soft_command struct\n");
+		return -ENOMEM;
+	}
 
 	ncmd = (union octnet_cmd *)sc->virtdptr;
 
@@ -1187,18 +1192,19 @@ static void send_rx_ctrl_cmd(struct lio *lio, int start_stop)
 	if (retval == IQ_SEND_FAILED) {
 		netif_info(lio, rx_err, lio->netdev, "Failed to send RX Control message\n");
 		octeon_free_soft_command(oct, sc);
-		return;
 	} else {
 		/* Sleep on a wait queue till the cond flag indicates that the
 		 * response arrived or timed-out.
 		 */
 		retval = wait_for_sc_completion_timeout(oct, sc, 0);
 		if (retval)
-			return;
+			return retval;
 
 		oct->props[lio->ifidx].rx_on = start_stop;
 		WRITE_ONCE(sc->caller_is_done, true);
 	}
+
+	return retval;
 }
 
 /**
@@ -1773,6 +1779,7 @@ static int liquidio_open(struct net_device *netdev)
 	struct octeon_device_priv *oct_priv =
 		(struct octeon_device_priv *)oct->priv;
 	struct napi_struct *napi, *n;
+	int ret = 0;
 
 	if (oct->props[lio->ifidx].napi_enabled == 0) {
 		tasklet_disable(&oct_priv->droq_tasklet);
@@ -1808,7 +1815,9 @@ static int liquidio_open(struct net_device *netdev)
 	netif_info(lio, ifup, lio->netdev, "Interface Open, ready for traffic\n");
 
 	/* tell Octeon to start forwarding packets to host */
-	send_rx_ctrl_cmd(lio, 1);
+	ret = send_rx_ctrl_cmd(lio, 1);
+	if (ret)
+		return ret;
 
 	/* start periodical statistics fetch */
 	INIT_DELAYED_WORK(&lio->stats_wk.work, lio_fetch_stats);
@@ -1819,7 +1828,7 @@ static int liquidio_open(struct net_device *netdev)
 	dev_info(&oct->pci_dev->dev, "%s interface is opened\n",
 		 netdev->name);
 
-	return 0;
+	return ret;
 }
 
 /**
@@ -1833,6 +1842,7 @@ static int liquidio_stop(struct net_device *netdev)
 	struct octeon_device_priv *oct_priv =
 		(struct octeon_device_priv *)oct->priv;
 	struct napi_struct *napi, *n;
+	int ret = 0;
 
 	ifstate_reset(lio, LIO_IFSTATE_RUNNING);
 
@@ -1849,7 +1859,9 @@ static int liquidio_stop(struct net_device *netdev)
 	lio->link_changes++;
 
 	/* Tell Octeon that nic interface is down. */
-	send_rx_ctrl_cmd(lio, 0);
+	ret = send_rx_ctrl_cmd(lio, 0);
+	if (ret)
+		return ret;
 
 	if (OCTEON_CN23XX_PF(oct)) {
 		if (!oct->msix_on)
@@ -1884,7 +1896,7 @@ static int liquidio_stop(struct net_device *netdev)
 
 	dev_info(&oct->pci_dev->dev, "%s interface is stopped\n", netdev->name);
 
-	return 0;
+	return ret;
 }
 
 /**
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 103440f97bc8..226a7842d2fd 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -595,7 +595,7 @@ static void octeon_destroy_resources(struct octeon_device *oct)
  * @lio: per-network private data
  * @start_stop: whether to start or stop
  */
-static void send_rx_ctrl_cmd(struct lio *lio, int start_stop)
+static int send_rx_ctrl_cmd(struct lio *lio, int start_stop)
 {
 	struct octeon_device *oct = (struct octeon_device *)lio->oct_dev;
 	struct octeon_soft_command *sc;
@@ -603,11 +603,16 @@ static void send_rx_ctrl_cmd(struct lio *lio, int start_stop)
 	int retval;
 
 	if (oct->props[lio->ifidx].rx_on == start_stop)
-		return;
+		return 0;
 
 	sc = (struct octeon_soft_command *)
 		octeon_alloc_soft_command(oct, OCTNET_CMD_SIZE,
 					  16, 0);
+	if (!sc) {
+		netif_info(lio, rx_err, lio->netdev,
+			   "Failed to allocate octeon_soft_command struct\n");
+		return -ENOMEM;
+	}
 
 	ncmd = (union octnet_cmd *)sc->virtdptr;
 
@@ -635,11 +640,13 @@ static void send_rx_ctrl_cmd(struct lio *lio, int start_stop)
 		 */
 		retval = wait_for_sc_completion_timeout(oct, sc, 0);
 		if (retval)
-			return;
+			return retval;
 
 		oct->props[lio->ifidx].rx_on = start_stop;
 		WRITE_ONCE(sc->caller_is_done, true);
 	}
+
+	return retval;
 }
 
 /**
@@ -906,6 +913,7 @@ static int liquidio_open(struct net_device *netdev)
 	struct octeon_device_priv *oct_priv =
 		(struct octeon_device_priv *)oct->priv;
 	struct napi_struct *napi, *n;
+	int ret = 0;
 
 	if (!oct->props[lio->ifidx].napi_enabled) {
 		tasklet_disable(&oct_priv->droq_tasklet);
@@ -932,11 +940,13 @@ static int liquidio_open(struct net_device *netdev)
 					(LIQUIDIO_NDEV_STATS_POLL_TIME_MS));
 
 	/* tell Octeon to start forwarding packets to host */
-	send_rx_ctrl_cmd(lio, 1);
+	ret = send_rx_ctrl_cmd(lio, 1);
+	if (ret)
+		return ret;
 
 	dev_info(&oct->pci_dev->dev, "%s interface is opened\n", netdev->name);
 
-	return 0;
+	return ret;
 }
 
 /**
@@ -950,9 +960,12 @@ static int liquidio_stop(struct net_device *netdev)
 	struct octeon_device_priv *oct_priv =
 		(struct octeon_device_priv *)oct->priv;
 	struct napi_struct *napi, *n;
+	int ret = 0;
 
 	/* tell Octeon to stop forwarding packets to host */
-	send_rx_ctrl_cmd(lio, 0);
+	ret = send_rx_ctrl_cmd(lio, 0);
+	if (ret)
+		return ret;
 
 	netif_info(lio, ifdown, lio->netdev, "Stopping interface!\n");
 	/* Inform that netif carrier is down */
@@ -986,7 +999,7 @@ static int liquidio_stop(struct net_device *netdev)
 
 	dev_info(&oct->pci_dev->dev, "%s interface is stopped\n", netdev->name);
 
-	return 0;
+	return ret;
 }
 
 /**
-- 
2.30.2

