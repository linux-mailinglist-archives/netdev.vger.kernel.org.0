Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3411639A82C
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhFCRN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:13:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232871AbhFCRMr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:12:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D8096140D;
        Thu,  3 Jun 2021 17:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740222;
        bh=/f5/PT2xx4N7dbC4wjL8KivoMw/jk3dF0uhC+34gCV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dxmr5fWH65ee5FSZJ/D4qMXeuRBT5Lp1Eq5C2/4SmT9Vj9FxftsQy4JGlwN18020m
         R7Lt3fN0oi020yfObM0NcjIZGPMYY+dIcEtgHVcNG5D0bLwi9cHmw22qepG1gPBx7X
         4VsQZMk4fk8dWgM+S7Z1642ouJkn3f23MSv7JBsa6802aOJOyhWv+5gheJwLTnNMQO
         /QSipMRBJUDndbnJOlXW9OIt/6do+VcfDKI2hqjLYt6UApw2hRbYxQe+XLok7lGg+9
         3V2MjOEx3Eic7BlgqMglYW9tahHTA9M0Bz+7SWGbpjGTs1M94Vz7S1YSRdjtXvOIER
         T3e8XfWb4hi0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saubhik Mukherjee <saubhik.mukherjee@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 18/23] net: appletalk: cops: Fix data race in cops_probe1
Date:   Thu,  3 Jun 2021 13:09:54 -0400
Message-Id: <20210603170959.3169420-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170959.3169420-1-sashal@kernel.org>
References: <20210603170959.3169420-1-sashal@kernel.org>
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
index bb49f6e40a19..0a7889abf2b2 100644
--- a/drivers/net/appletalk/cops.c
+++ b/drivers/net/appletalk/cops.c
@@ -325,6 +325,8 @@ static int __init cops_probe1(struct net_device *dev, int ioaddr)
 			break;
 	}
 
+	dev->base_addr = ioaddr;
+
 	/* Reserve any actual interrupt. */
 	if (dev->irq) {
 		retval = request_irq(dev->irq, cops_interrupt, 0, dev->name, dev);
@@ -332,8 +334,6 @@ static int __init cops_probe1(struct net_device *dev, int ioaddr)
 			goto err_out;
 	}
 
-	dev->base_addr = ioaddr;
-
         lp = netdev_priv(dev);
         spin_lock_init(&lp->lock);
 
-- 
2.30.2

