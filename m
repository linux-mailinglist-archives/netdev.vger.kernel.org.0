Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 180C239A87A
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233266AbhFCRP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:15:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233238AbhFCRN4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:13:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DF7661437;
        Thu,  3 Jun 2021 17:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740247;
        bh=bYIvQUL/L8SXdwowI50911FbHROn5SVxawabsKcL6vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DM2j7YAJr2xz0zCrZYvHzN54LR7KUY1m1eFvOcsZWWjv/m322fQ+h1EECSs15m6cA
         XRHVPRNpotMfkOEN02WIYyaEJk3r3FM1EBFGeHAxWg2sJKU7TgMEE7WUzGeTI6q+zV
         TwKrUdj9ZMZpMq6eQfFjEgjeB8+cwe8G8anLt3o5A5fh+cOiXFZaoCQpea4GhhsY8S
         9fJTeuHuCWvOwIZ8XPSS8N9GmIsyP5ILRtYbrISDQm3dKPYKWEWKjfr8Ar747eWiMw
         /bGAhCYU08JpdLqmeQ5PKN5DkrMgFPA5EXpBJk6hYPXhvPlcZ1YCnHlPCUuGbPOd46
         jW7NTf8s0xeVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saubhik Mukherjee <saubhik.mukherjee@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 14/18] net: appletalk: cops: Fix data race in cops_probe1
Date:   Thu,  3 Jun 2021 13:10:25 -0400
Message-Id: <20210603171029.3169669-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603171029.3169669-1-sashal@kernel.org>
References: <20210603171029.3169669-1-sashal@kernel.org>
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
index 486e1e6997fc..dde0cda3f696 100644
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

