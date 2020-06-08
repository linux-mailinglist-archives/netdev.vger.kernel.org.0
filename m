Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759771F2D8A
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733164AbgFIAeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:34:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729860AbgFHXOk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:14:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 240F220B80;
        Mon,  8 Jun 2020 23:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658080;
        bh=rrjn21lIwbVsYMAky8QjM0Drt8vWHEafCQYkuckifaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zb7FJYs55fFUxCLo+hv1nZucmhoVxk8NW8oChDs23eKIKvetgoKaNsbbHjZOUNcSA
         LN4yunzAQjmko5/beefzUZJpYwuVcmnG+JTpY+qCIZVkt6OOXnM934DbhYM+zc7yS9
         wJSroqLDXNWWs5nFPCLPnppCUhHd30Ym0DVgzTPw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Petrov <mmrmaximuzz@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.6 124/606] stmmac: fix pointer check after utilization in stmmac_interrupt
Date:   Mon,  8 Jun 2020 19:04:09 -0400
Message-Id: <20200608231211.3363633-124-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Petrov <mmrmaximuzz@gmail.com>

[ Upstream commit f42234ffd531ca6b13d9da02faa60b72eccf8334 ]

The paranoidal pointer check in IRQ handler looks very strange - it
really protects us only against bogus drivers which request IRQ line
with null pointer dev_id. However, the code fragment is incorrect
because the dev pointer is used before the actual check which leads
to undefined behavior. Remove the check to avoid confusing people
with incorrect code.

Signed-off-by: Maxim Petrov <mmrmaximuzz@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 7da18c9afa01..d564459290ce 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3988,7 +3988,7 @@ static int stmmac_set_features(struct net_device *netdev,
 /**
  *  stmmac_interrupt - main ISR
  *  @irq: interrupt number.
- *  @dev_id: to pass the net device pointer.
+ *  @dev_id: to pass the net device pointer (must be valid).
  *  Description: this is the main driver interrupt service routine.
  *  It can call:
  *  o DMA service routine (to manage incoming frame reception and transmission
@@ -4012,11 +4012,6 @@ static irqreturn_t stmmac_interrupt(int irq, void *dev_id)
 	if (priv->irq_wake)
 		pm_wakeup_event(priv->device, 0);
 
-	if (unlikely(!dev)) {
-		netdev_err(priv->dev, "%s: invalid dev pointer\n", __func__);
-		return IRQ_NONE;
-	}
-
 	/* Check if adapter is up */
 	if (test_bit(STMMAC_DOWN, &priv->state))
 		return IRQ_HANDLED;
-- 
2.25.1

