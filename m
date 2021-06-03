Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A591939A761
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232409AbhFCRLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:11:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232212AbhFCRKv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:10:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E2F061402;
        Thu,  3 Jun 2021 17:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740146;
        bh=9DsQAlrXIIkKDZkN+WHC7MUMFp4igyRwhLat0llSGY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VVq03wfr3FX3pePOTSRfYMeN3mUE7CW0nWBX66W5vPAm7R1XiIz1psIuCKrXV4qU7
         6ry9lYFZ9x/6ET5QGg8Anob+qzuHMNPJpC3gl/uoHX2ZVLwPFQTYByNM5GDA88us2Q
         XL/Kyg0TCbOJXcNHsQk2i0YYHKZeT2sU+4Qvz/39JX6HESwTsefsT6C+9Lf8tViRIn
         tsAwVFWVGZ3fBngOcrk0Izt2TGEtk7/9ouAfU/agXdUwKB7URMuH5Ot0dtsJ/4eTTY
         aoxVyLuCdn/wf5FhtY2TAGbfvfjOZTgGlyAAuIRlWKLtTJb9w2F0NjQYuwGacNfV4v
         DNCiTBNeTwo6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Saubhik Mukherjee <saubhik.mukherjee@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 30/39] net: appletalk: cops: Fix data race in cops_probe1
Date:   Thu,  3 Jun 2021 13:08:20 -0400
Message-Id: <20210603170829.3168708-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170829.3168708-1-sashal@kernel.org>
References: <20210603170829.3168708-1-sashal@kernel.org>
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
index ba8e70a8e312..6b12ce822e51 100644
--- a/drivers/net/appletalk/cops.c
+++ b/drivers/net/appletalk/cops.c
@@ -327,6 +327,8 @@ static int __init cops_probe1(struct net_device *dev, int ioaddr)
 			break;
 	}
 
+	dev->base_addr = ioaddr;
+
 	/* Reserve any actual interrupt. */
 	if (dev->irq) {
 		retval = request_irq(dev->irq, cops_interrupt, 0, dev->name, dev);
@@ -334,8 +336,6 @@ static int __init cops_probe1(struct net_device *dev, int ioaddr)
 			goto err_out;
 	}
 
-	dev->base_addr = ioaddr;
-
         lp = netdev_priv(dev);
         spin_lock_init(&lp->lock);
 
-- 
2.30.2

