Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD311496F2F
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 01:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235971AbiAWARL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 19:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236088AbiAWAPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 19:15:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C84FC06135C;
        Sat, 22 Jan 2022 16:14:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A9B060F9D;
        Sun, 23 Jan 2022 00:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE463C340E2;
        Sun, 23 Jan 2022 00:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896847;
        bh=fGEyRrqjxwtMs1X06D+rG0jTgAzWR5SzC0hkejul5TY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LEM269e1pAW4k7G8cuDr9ppZs9Hdg9kWS7gc2WWCCDV+BVd9eSQK/HSGZt+7Kr9bB
         loE9hIrbJZ0/1WhoQXDcn15se0nqRxeAHl46sy7+RyBZFE9zKgtBKuINw8F30NtF8Z
         W4fk7ExKvTDuLoYTlD7bz234GF6+t+/2Cm9bhnaLcdtu265yKbXnZTqEsLyJF1TgIT
         aUwt7O8d//mdf+JOW2+I2HUd852JpxCpeUATnlndR2UxmFAeIVrnj+8P8j31CWId5d
         10x2+1SeXaIvslGYMKUcKketr1RaqfbPJChf0iUE2dJiK4Joo10DQOG6R0JB5zsYor
         0sMH52jCOxDNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, tanghui20@huawei.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 3/5] net: apple: bmac: Fix build since dev_addr constification
Date:   Sat, 22 Jan 2022 19:13:49 -0500
Message-Id: <20220123001353.2460870-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001353.2460870-1-sashal@kernel.org>
References: <20220123001353.2460870-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit ea938248557a52e231a31f338eac4baee36a8626 ]

Since commit adeef3e32146 ("net: constify netdev->dev_addr") the bmac
driver no longer builds with the following errors (pmac32_defconfig):

  linux/drivers/net/ethernet/apple/bmac.c: In function ‘bmac_probe’:
  linux/drivers/net/ethernet/apple/bmac.c:1287:20: error: assignment of read-only location ‘*(dev->dev_addr + (sizetype)j)’
   1287 |   dev->dev_addr[j] = rev ? bitrev8(addr[j]): addr[j];
        |                    ^

Fix it by making the modifications to a local macaddr variable and then
passing that to eth_hw_addr_set().

We don't use the existing addr variable because the bitrev8() would
mutate it, but it is already used unreversed later in the function.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/apple/bmac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/apple/bmac.c b/drivers/net/ethernet/apple/bmac.c
index ab6ce85540b8a..157ad5b81c730 100644
--- a/drivers/net/ethernet/apple/bmac.c
+++ b/drivers/net/ethernet/apple/bmac.c
@@ -1239,6 +1239,7 @@ static int bmac_probe(struct macio_dev *mdev, const struct of_device_id *match)
 	struct bmac_data *bp;
 	const unsigned char *prop_addr;
 	unsigned char addr[6];
+	u8 macaddr[6];
 	struct net_device *dev;
 	int is_bmac_plus = ((int)match->data) != 0;
 
@@ -1286,7 +1287,9 @@ static int bmac_probe(struct macio_dev *mdev, const struct of_device_id *match)
 
 	rev = addr[0] == 0 && addr[1] == 0xA0;
 	for (j = 0; j < 6; ++j)
-		dev->dev_addr[j] = rev ? bitrev8(addr[j]): addr[j];
+		macaddr[j] = rev ? bitrev8(addr[j]): addr[j];
+
+	eth_hw_addr_set(dev, macaddr);
 
 	/* Enable chip without interrupts for now */
 	bmac_enable_and_reset_chip(dev);
-- 
2.34.1

