Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E8722FD69
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 01:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbgG0X13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 19:27:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728314AbgG0XYw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 19:24:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BE0E22B40;
        Mon, 27 Jul 2020 23:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595892291;
        bh=bgAddR/u870zWR7NHJFFnORjmWhzCSF1Zmk3C6mtp4o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hPdMPOgYT/kMi9qj3Z56zjSAaEtlPTRkzZFpfk6FVVCwP9asoO6amYy1Esrx8z2Rr
         +qtUSE8EXdfIPy75RMFjeuPA9d84aK5NSXNKWFuBt6rmrKEFP0zPgYHX6gntdw1foo
         8rHc3q0rJaE2LGvFCfebKc3prrluWRje1Z0qk/+g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 05/10] net: ethernet: ravb: exit if re-initialization fails in tx timeout
Date:   Mon, 27 Jul 2020 19:24:38 -0400
Message-Id: <20200727232443.718000-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200727232443.718000-1-sashal@kernel.org>
References: <20200727232443.718000-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit 015c5d5e6aa3523c758a70eb87b291cece2dbbb4 ]

According to the report of [1], this driver is possible to cause
the following error in ravb_tx_timeout_work().

ravb e6800000.ethernet ethernet: failed to switch device to config mode

This error means that the hardware could not change the state
from "Operation" to "Configuration" while some tx and/or rx queue
are operating. After that, ravb_config() in ravb_dmac_init() will fail,
and then any descriptors will be not allocaled anymore so that NULL
pointer dereference happens after that on ravb_start_xmit().

To fix the issue, the ravb_tx_timeout_work() should check
the return values of ravb_stop_dma() and ravb_dmac_init().
If ravb_stop_dma() fails, ravb_tx_timeout_work() re-enables TX and RX
and just exits. If ravb_dmac_init() fails, just exits.

[1]
https://lore.kernel.org/linux-renesas-soc/20200518045452.2390-1-dirk.behme@de.bosch.com/

Reported-by: Dirk Behme <dirk.behme@de.bosch.com>
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 26 ++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index faaf74073a120..569e698b5c807 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1445,6 +1445,7 @@ static void ravb_tx_timeout_work(struct work_struct *work)
 	struct ravb_private *priv = container_of(work, struct ravb_private,
 						 work);
 	struct net_device *ndev = priv->ndev;
+	int error;
 
 	netif_tx_stop_all_queues(ndev);
 
@@ -1453,15 +1454,36 @@ static void ravb_tx_timeout_work(struct work_struct *work)
 		ravb_ptp_stop(ndev);
 
 	/* Wait for DMA stopping */
-	ravb_stop_dma(ndev);
+	if (ravb_stop_dma(ndev)) {
+		/* If ravb_stop_dma() fails, the hardware is still operating
+		 * for TX and/or RX. So, this should not call the following
+		 * functions because ravb_dmac_init() is possible to fail too.
+		 * Also, this should not retry ravb_stop_dma() again and again
+		 * here because it's possible to wait forever. So, this just
+		 * re-enables the TX and RX and skip the following
+		 * re-initialization procedure.
+		 */
+		ravb_rcv_snd_enable(ndev);
+		goto out;
+	}
 
 	ravb_ring_free(ndev, RAVB_BE);
 	ravb_ring_free(ndev, RAVB_NC);
 
 	/* Device init */
-	ravb_dmac_init(ndev);
+	error = ravb_dmac_init(ndev);
+	if (error) {
+		/* If ravb_dmac_init() fails, descriptors are freed. So, this
+		 * should return here to avoid re-enabling the TX and RX in
+		 * ravb_emac_init().
+		 */
+		netdev_err(ndev, "%s: ravb_dmac_init() failed, error %d\n",
+			   __func__, error);
+		return;
+	}
 	ravb_emac_init(ndev);
 
+out:
 	/* Initialise PTP Clock driver */
 	if (priv->chip_id == RCAR_GEN2)
 		ravb_ptp_init(ndev, priv->pdev);
-- 
2.25.1

