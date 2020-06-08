Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82D81F2FC1
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733302AbgFIAxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:53:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728509AbgFHXJs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:09:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F6B0208FE;
        Mon,  8 Jun 2020 23:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657787;
        bh=jLox+8Gi6bC9/N3l0vacC+fK6yX3qEtgPqcMiIXdWZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nMRFeyMkQrhgT48q24DKEP0czU89K2T65O+/c8kW3xEnN9tuZMLJ0ZonwdymA2J7O
         Eq4ZziMRzJUxcZdnZygO15OD4+6xdETi8YoEPCnXTZ7CLTXyNLY8wU8RcOTvAR6njx
         mHd2Ip2E7+NzqHwl2MZVYWXRh36A1SDH2Jry03PE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 168/274] dsa: sja1105: dynamically allocate stats structure
Date:   Mon,  8 Jun 2020 19:04:21 -0400
Message-Id: <20200608230607.3361041-168-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit ae1804de93f6f1626906567ae7deec8e0111259d ]

The addition of sja1105_port_status_ether structure into the
statistics causes the frame size to go over the warning limit:

drivers/net/dsa/sja1105/sja1105_ethtool.c:421:6: error: stack frame size of 1104 bytes in function 'sja1105_get_ethtool_stats' [-Werror,-Wframe-larger-than=]

Use dynamic allocation to avoid this.

Fixes: 336aa67bd027 ("net: dsa: sja1105: show more ethtool statistics counters for P/Q/R/S")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_ethtool.c | 144 +++++++++++-----------
 1 file changed, 74 insertions(+), 70 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_ethtool.c b/drivers/net/dsa/sja1105/sja1105_ethtool.c
index d742ffcbfce9..709f035055c5 100644
--- a/drivers/net/dsa/sja1105/sja1105_ethtool.c
+++ b/drivers/net/dsa/sja1105/sja1105_ethtool.c
@@ -421,92 +421,96 @@ static char sja1105pqrs_extra_port_stats[][ETH_GSTRING_LEN] = {
 void sja1105_get_ethtool_stats(struct dsa_switch *ds, int port, u64 *data)
 {
 	struct sja1105_private *priv = ds->priv;
-	struct sja1105_port_status status;
+	struct sja1105_port_status *status;
 	int rc, i, k = 0;
 
-	memset(&status, 0, sizeof(status));
+	status = kzalloc(sizeof(*status), GFP_KERNEL);
+	if (!status)
+		goto out;
 
-	rc = sja1105_port_status_get(priv, &status, port);
+	rc = sja1105_port_status_get(priv, status, port);
 	if (rc < 0) {
 		dev_err(ds->dev, "Failed to read port %d counters: %d\n",
 			port, rc);
-		return;
+		goto out;
 	}
 	memset(data, 0, ARRAY_SIZE(sja1105_port_stats) * sizeof(u64));
-	data[k++] = status.mac.n_runt;
-	data[k++] = status.mac.n_soferr;
-	data[k++] = status.mac.n_alignerr;
-	data[k++] = status.mac.n_miierr;
-	data[k++] = status.mac.typeerr;
-	data[k++] = status.mac.sizeerr;
-	data[k++] = status.mac.tctimeout;
-	data[k++] = status.mac.priorerr;
-	data[k++] = status.mac.nomaster;
-	data[k++] = status.mac.memov;
-	data[k++] = status.mac.memerr;
-	data[k++] = status.mac.invtyp;
-	data[k++] = status.mac.intcyov;
-	data[k++] = status.mac.domerr;
-	data[k++] = status.mac.pcfbagdrop;
-	data[k++] = status.mac.spcprior;
-	data[k++] = status.mac.ageprior;
-	data[k++] = status.mac.portdrop;
-	data[k++] = status.mac.lendrop;
-	data[k++] = status.mac.bagdrop;
-	data[k++] = status.mac.policeerr;
-	data[k++] = status.mac.drpnona664err;
-	data[k++] = status.mac.spcerr;
-	data[k++] = status.mac.agedrp;
-	data[k++] = status.hl1.n_n664err;
-	data[k++] = status.hl1.n_vlanerr;
-	data[k++] = status.hl1.n_unreleased;
-	data[k++] = status.hl1.n_sizeerr;
-	data[k++] = status.hl1.n_crcerr;
-	data[k++] = status.hl1.n_vlnotfound;
-	data[k++] = status.hl1.n_ctpolerr;
-	data[k++] = status.hl1.n_polerr;
-	data[k++] = status.hl1.n_rxfrm;
-	data[k++] = status.hl1.n_rxbyte;
-	data[k++] = status.hl1.n_txfrm;
-	data[k++] = status.hl1.n_txbyte;
-	data[k++] = status.hl2.n_qfull;
-	data[k++] = status.hl2.n_part_drop;
-	data[k++] = status.hl2.n_egr_disabled;
-	data[k++] = status.hl2.n_not_reach;
+	data[k++] = status->mac.n_runt;
+	data[k++] = status->mac.n_soferr;
+	data[k++] = status->mac.n_alignerr;
+	data[k++] = status->mac.n_miierr;
+	data[k++] = status->mac.typeerr;
+	data[k++] = status->mac.sizeerr;
+	data[k++] = status->mac.tctimeout;
+	data[k++] = status->mac.priorerr;
+	data[k++] = status->mac.nomaster;
+	data[k++] = status->mac.memov;
+	data[k++] = status->mac.memerr;
+	data[k++] = status->mac.invtyp;
+	data[k++] = status->mac.intcyov;
+	data[k++] = status->mac.domerr;
+	data[k++] = status->mac.pcfbagdrop;
+	data[k++] = status->mac.spcprior;
+	data[k++] = status->mac.ageprior;
+	data[k++] = status->mac.portdrop;
+	data[k++] = status->mac.lendrop;
+	data[k++] = status->mac.bagdrop;
+	data[k++] = status->mac.policeerr;
+	data[k++] = status->mac.drpnona664err;
+	data[k++] = status->mac.spcerr;
+	data[k++] = status->mac.agedrp;
+	data[k++] = status->hl1.n_n664err;
+	data[k++] = status->hl1.n_vlanerr;
+	data[k++] = status->hl1.n_unreleased;
+	data[k++] = status->hl1.n_sizeerr;
+	data[k++] = status->hl1.n_crcerr;
+	data[k++] = status->hl1.n_vlnotfound;
+	data[k++] = status->hl1.n_ctpolerr;
+	data[k++] = status->hl1.n_polerr;
+	data[k++] = status->hl1.n_rxfrm;
+	data[k++] = status->hl1.n_rxbyte;
+	data[k++] = status->hl1.n_txfrm;
+	data[k++] = status->hl1.n_txbyte;
+	data[k++] = status->hl2.n_qfull;
+	data[k++] = status->hl2.n_part_drop;
+	data[k++] = status->hl2.n_egr_disabled;
+	data[k++] = status->hl2.n_not_reach;
 
 	if (priv->info->device_id == SJA1105E_DEVICE_ID ||
 	    priv->info->device_id == SJA1105T_DEVICE_ID)
-		return;
+		goto out;;
 
 	memset(data + k, 0, ARRAY_SIZE(sja1105pqrs_extra_port_stats) *
 			sizeof(u64));
 	for (i = 0; i < 8; i++) {
-		data[k++] = status.hl2.qlevel_hwm[i];
-		data[k++] = status.hl2.qlevel[i];
+		data[k++] = status->hl2.qlevel_hwm[i];
+		data[k++] = status->hl2.qlevel[i];
 	}
-	data[k++] = status.ether.n_drops_nolearn;
-	data[k++] = status.ether.n_drops_noroute;
-	data[k++] = status.ether.n_drops_ill_dtag;
-	data[k++] = status.ether.n_drops_dtag;
-	data[k++] = status.ether.n_drops_sotag;
-	data[k++] = status.ether.n_drops_sitag;
-	data[k++] = status.ether.n_drops_utag;
-	data[k++] = status.ether.n_tx_bytes_1024_2047;
-	data[k++] = status.ether.n_tx_bytes_512_1023;
-	data[k++] = status.ether.n_tx_bytes_256_511;
-	data[k++] = status.ether.n_tx_bytes_128_255;
-	data[k++] = status.ether.n_tx_bytes_65_127;
-	data[k++] = status.ether.n_tx_bytes_64;
-	data[k++] = status.ether.n_tx_mcast;
-	data[k++] = status.ether.n_tx_bcast;
-	data[k++] = status.ether.n_rx_bytes_1024_2047;
-	data[k++] = status.ether.n_rx_bytes_512_1023;
-	data[k++] = status.ether.n_rx_bytes_256_511;
-	data[k++] = status.ether.n_rx_bytes_128_255;
-	data[k++] = status.ether.n_rx_bytes_65_127;
-	data[k++] = status.ether.n_rx_bytes_64;
-	data[k++] = status.ether.n_rx_mcast;
-	data[k++] = status.ether.n_rx_bcast;
+	data[k++] = status->ether.n_drops_nolearn;
+	data[k++] = status->ether.n_drops_noroute;
+	data[k++] = status->ether.n_drops_ill_dtag;
+	data[k++] = status->ether.n_drops_dtag;
+	data[k++] = status->ether.n_drops_sotag;
+	data[k++] = status->ether.n_drops_sitag;
+	data[k++] = status->ether.n_drops_utag;
+	data[k++] = status->ether.n_tx_bytes_1024_2047;
+	data[k++] = status->ether.n_tx_bytes_512_1023;
+	data[k++] = status->ether.n_tx_bytes_256_511;
+	data[k++] = status->ether.n_tx_bytes_128_255;
+	data[k++] = status->ether.n_tx_bytes_65_127;
+	data[k++] = status->ether.n_tx_bytes_64;
+	data[k++] = status->ether.n_tx_mcast;
+	data[k++] = status->ether.n_tx_bcast;
+	data[k++] = status->ether.n_rx_bytes_1024_2047;
+	data[k++] = status->ether.n_rx_bytes_512_1023;
+	data[k++] = status->ether.n_rx_bytes_256_511;
+	data[k++] = status->ether.n_rx_bytes_128_255;
+	data[k++] = status->ether.n_rx_bytes_65_127;
+	data[k++] = status->ether.n_rx_bytes_64;
+	data[k++] = status->ether.n_rx_mcast;
+	data[k++] = status->ether.n_rx_bcast;
+out:
+	kfree(status);
 }
 
 void sja1105_get_strings(struct dsa_switch *ds, int port,
-- 
2.25.1

