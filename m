Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216FB39A8B8
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhFCRRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:17:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233539AbhFCRPi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:15:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A4DD6143B;
        Thu,  3 Jun 2021 17:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740269;
        bh=p7v+GAQYeiFOtTPwauiD39nslgDXZAnClVjwoDfAYZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YE6vXWQHcIIaSv3TFpcTN/c4MzJwzJPQd6EYK1rf/nrCVIt2uzPxEvjKMQPfXKVvJ
         rveIlhGNdiQ3Pv3CsemUY8IR+Pqf5OdBTglWAOR92HBpz3h7D5SLkHCrW3H7xljkTf
         Q3Y47GJbB/y5iENI2vOgBMgkWLyrQdHW92+S0rv/bZAckdT3e/QvFVb/wbap7V7SZj
         nCUYhOHoBAfZZoFiU526z6dOYL1fuAgfH6Z5YBFY+O6YyGP3Q/LEMZoK25YTFBYGZr
         gxM/Z7eU7Kbj4ujtpPhtiaM3UIoWOD9weBfNWqF8RxtiPGfr4SSU+M5NEPeBYjt1g7
         CJnzgbqjyTAmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saubhik Mukherjee <saubhik.mukherjee@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 13/17] net: appletalk: cops: Fix data race in cops_probe1
Date:   Thu,  3 Jun 2021 13:10:48 -0400
Message-Id: <20210603171052.3169893-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603171052.3169893-1-sashal@kernel.org>
References: <20210603171052.3169893-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saubhik Mukherjee <saubhik.mukherjee@gmail.com>

[ Upstream commit a4dd4fc6105e54393d637450a11d4cddb5fabc4f ]

In cops_probe1(), there is a write to dev->base_addr after requesting an
interrupt line and registering the interrupt handler cops_interrupt().
The handler might be called in parallel to handle an interrupt.
cops_interrupt() tries to read dev->base_addr leading to a potential
data race. So write to dev->base_addr before calling request_irq().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Saubhik Mukherjee <saubhik.mukherjee@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/appletalk/cops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/appletalk/cops.c b/drivers/net/appletalk/cops.c
index 1b2e9217ec78..d520ce32ddbf 100644
--- a/drivers/net/appletalk/cops.c
+++ b/drivers/net/appletalk/cops.c
@@ -324,6 +324,8 @@ static int __init cops_probe1(struct net_device *dev, int ioaddr)
 			break;
 	}
 
+	dev->base_addr = ioaddr;
+
 	/* Reserve any actual interrupt. */
 	if (dev->irq) {
 		retval = request_irq(dev->irq, cops_interrupt, 0, dev->name, dev);
@@ -331,8 +333,6 @@ static int __init cops_probe1(struct net_device *dev, int ioaddr)
 			goto err_out;
 	}
 
-	dev->base_addr = ioaddr;
-
         lp = netdev_priv(dev);
         spin_lock_init(&lp->lock);
 
-- 
2.30.2

