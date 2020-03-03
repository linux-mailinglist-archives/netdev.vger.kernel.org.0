Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94079176ACE
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 03:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbgCCCql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 21:46:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:41208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727589AbgCCCql (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 21:46:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2ABF246BB;
        Tue,  3 Mar 2020 02:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203600;
        bh=MnCbQzpf+r5tSeJRjSgxcK5ybmbnMHs7rXK6mHvkUdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PFTMEd9JIZgx7JNrHk9k724bryTJb+XqkrJvQBnPHg5azRWcpLnLtSugBvC2ApWvS
         MI2MvLNCLQPNQ263CAaIi1Z+A2BnlRRnvyC2Q2yUMTlYv3nQv9x/Jx4s6+Di+GbSTC
         0Kk3XTjkEGcMDo9v0WgTS3QVLgtY6pWKnC5b0DIA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 20/66] net: macb: ensure interface is not suspended on at91rm9200
Date:   Mon,  2 Mar 2020 21:45:29 -0500
Message-Id: <20200303024615.8889-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024615.8889-1-sashal@kernel.org>
References: <20200303024615.8889-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit e6a41c23df0d5da01540d2abef41591589c0b4be ]

Because of autosuspend, at91ether_start is called with clocks disabled.
Ensure that pm_runtime doesn't suspend the interface as soon as it is
opened as there is no pm_runtime support is the other relevant parts of the
platform support for at91rm9200.

Fixes: d54f89af6cc4 ("net: macb: Add pm runtime support")
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 71bb0d56533a6..e916fc223621d 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3751,6 +3751,10 @@ static int at91ether_open(struct net_device *dev)
 	u32 ctl;
 	int ret;
 
+	ret = pm_runtime_get_sync(&lp->pdev->dev);
+	if (ret < 0)
+		return ret;
+
 	/* Clear internal statistics */
 	ctl = macb_readl(lp, NCR);
 	macb_writel(lp, NCR, ctl | MACB_BIT(CLRSTAT));
@@ -3815,7 +3819,7 @@ static int at91ether_close(struct net_device *dev)
 			  q->rx_buffers, q->rx_buffers_dma);
 	q->rx_buffers = NULL;
 
-	return 0;
+	return pm_runtime_put(&lp->pdev->dev);
 }
 
 /* Transmit packet */
-- 
2.20.1

