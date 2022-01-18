Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDE4491470
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244824AbiARCWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:22:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36166 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244930AbiARCWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:22:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C6EAB81238;
        Tue, 18 Jan 2022 02:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64580C36AEB;
        Tue, 18 Jan 2022 02:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472522;
        bh=NuiIAk9+6AutmDT+wY0fXkJUI9tIu3M/c9EfX1hpyp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=koZafB/O+uub+J6LdGF5h4+pX7PXVzSAakAqaXQw1uo9V3TOusmZitfLg79VxXhuT
         MVmlm9AOOw8OHNxrTNBoBxKd2Ql6SgdIRYJy8mNBkV3UR1kZ3bPcqHfNXjt1/EfKvO
         LP2lGVsr04vJkMCydvZkBCpprcTW9Ot+udl0knR0vBHN/G3Cvat7kDM7erJwFfkDNk
         jPulZM1x7W87G7grCK/Ok7E77M8VaTNdfLI0pBBg/Pkc96yrzwtGHReRAQ6YPOGI9c
         rLZjWM/uJUlj/SKic1GLz9LJbjt3/xO20Iz2GsQ7EAv3UyR/B+c6fqczqwVNusKOac
         98k1GUCFrKKwg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, arnd@arndb.de,
        tanghui20@huawei.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 040/217] 8390: smc-ultra: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:16:43 -0500
Message-Id: <20220118021940.1942199-40-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 5114ddf8dd881f9059147d3f130e9415ce94125e ]

IO reads, so save to an array then eth_hw_addr_set().

Fixes build on Alpha.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/8390/smc-ultra.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/8390/smc-ultra.c b/drivers/net/ethernet/8390/smc-ultra.c
index 0890fa493f70f..6e62c37c94005 100644
--- a/drivers/net/ethernet/8390/smc-ultra.c
+++ b/drivers/net/ethernet/8390/smc-ultra.c
@@ -204,6 +204,7 @@ static int __init ultra_probe1(struct net_device *dev, int ioaddr)
 {
 	int i, retval;
 	int checksum = 0;
+	u8 macaddr[ETH_ALEN];
 	const char *model_name;
 	unsigned char eeprom_irq = 0;
 	static unsigned version_printed;
@@ -239,7 +240,8 @@ static int __init ultra_probe1(struct net_device *dev, int ioaddr)
 	model_name = (idreg & 0xF0) == 0x20 ? "SMC Ultra" : "SMC EtherEZ";
 
 	for (i = 0; i < 6; i++)
-		dev->dev_addr[i] = inb(ioaddr + 8 + i);
+		macaddr[i] = inb(ioaddr + 8 + i);
+	eth_hw_addr_set(dev, macaddr);
 
 	netdev_info(dev, "%s at %#3x, %pM", model_name,
 		    ioaddr, dev->dev_addr);
-- 
2.34.1

