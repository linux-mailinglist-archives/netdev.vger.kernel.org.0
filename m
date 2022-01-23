Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51071496EFD
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 01:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235597AbiAWAPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 19:15:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235307AbiAWAO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 19:14:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCDAC0617AA;
        Sat, 22 Jan 2022 16:13:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CAA560F7E;
        Sun, 23 Jan 2022 00:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251ACC340E4;
        Sun, 23 Jan 2022 00:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896799;
        bh=27M5pdyOBTJQl0t01fS3kfKWUEDLQ3XzMe1jAaZborI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OM/PlGSpbyxr/bV/2QzJp1/0gp9pdoPW7WzXOTysow525KMf5Y7gSQ6zg8Sg6Uec3
         kvUrWsgIKhlh56HATABwZrU7fyGksjwjxGztbQnfRSERZR1I1Zwp0rr/auzxSfLlCm
         T8RobxRsYvHup6sLjCqhWWq3NVGz6oibaUOWiCj5TUvWp8q1L6H43efgUnQ2SFXnEW
         Mkt+DddTAr3TDhQuFIVEooX4P5ebvyfnI9nE7vz0ZLjvQwvzvfkqg7MVGiUgOBHTYx
         lBACj1RtX9SLW3G/4WGQeREpzLLqXkpqrID5xrDwLWaJX4W7MWO0LzcGE0ZyfpaoMK
         aKHcGmv1WYiAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, tanghui20@huawei.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 6/9] net: apple: bmac: Fix build since dev_addr constification
Date:   Sat, 22 Jan 2022 19:12:55 -0500
Message-Id: <20220123001258.2460594-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001258.2460594-1-sashal@kernel.org>
References: <20220123001258.2460594-1-sashal@kernel.org>
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
index 1e4e402f07d76..19c7cd9beeef3 100644
--- a/drivers/net/ethernet/apple/bmac.c
+++ b/drivers/net/ethernet/apple/bmac.c
@@ -1240,6 +1240,7 @@ static int bmac_probe(struct macio_dev *mdev, const struct of_device_id *match)
 	struct bmac_data *bp;
 	const unsigned char *prop_addr;
 	unsigned char addr[6];
+	u8 macaddr[6];
 	struct net_device *dev;
 	int is_bmac_plus = ((int)match->data) != 0;
 
@@ -1287,7 +1288,9 @@ static int bmac_probe(struct macio_dev *mdev, const struct of_device_id *match)
 
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

