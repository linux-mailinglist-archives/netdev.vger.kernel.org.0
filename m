Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A5B39A8DD
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbhFCRSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:18:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233697AbhFCRQT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:16:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BB2861444;
        Thu,  3 Jun 2021 17:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740288;
        bh=wsd71GWpjcCghhnVLpTuvODi+OFI3tJj2bsAKOT2WyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JC105p6fpoOnifZAjLAZcYgwEIU1jEOTn0jUsNWH6vNX+sFikIEOBf0Z3T+n7FSA8
         mqeFQ+RfJ9g4W1op/VTtpjR0BqCSxirS56z609VKJpRvFTjS+LE1ryJ0zStxil3+1D
         ddazN7jTZGbYj28KJkHEgg2MPjorLkAPS7Gg/Rr79bHSk69qgmVR5DnF/jlbF5e3Lm
         mGsYDD+btyrNKQ7Nvs5ZI++toghX2mvg0biQhXbjrnS4W9/tbgLJG0R4LJv4dNXLrm
         dXbfuUj59LK9CTfAsj7qQa55sKiC7Fe+YhlZ7n9tVgw3aUJVz8VVFO/FNd2bY2yTYh
         tUOjvA8tAWwrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saubhik Mukherjee <saubhik.mukherjee@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 11/15] net: appletalk: cops: Fix data race in cops_probe1
Date:   Thu,  3 Jun 2021 13:11:10 -0400
Message-Id: <20210603171114.3170086-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603171114.3170086-1-sashal@kernel.org>
References: <20210603171114.3170086-1-sashal@kernel.org>
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
index 7f2a032c354c..841a5de58c7c 100644
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

