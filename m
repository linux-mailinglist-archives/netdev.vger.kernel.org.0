Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0908B491467
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245014AbiARCW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244954AbiARCWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:22:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54EF5C061747;
        Mon, 17 Jan 2022 18:22:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E773A61163;
        Tue, 18 Jan 2022 02:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F5DC36AE3;
        Tue, 18 Jan 2022 02:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472532;
        bh=hYeI/RffiKpdM6X+dBkRzZja9+0y5/A2IGZkn+XN/zY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OfAr8+9tq6Z5IyPazNv8mbHTP3V0Q3FZ7gxJ8VgirzO6flrG3YK+rWX719q999bGN
         7PDKKiJihBHMLWOivO0nQ3w5Wiky7Tims34Xejqh5fSRcaUPyh9qMF71DK4x7vcJUl
         RLGfYqiJYswxLGHTytWylNNAWvHKqtsQ1VwrLw4YpV+GVUIyA06lRtIjSImD2SKg7e
         E44Kfn0VcnipfSztRAOyj5tnA9d0T9Ex9mKOLFMixr75UWXE7Aga3eGVZCZ+2sXgLl
         kI6O51b40kf4axt6p6MRdyT1YGJPq+suFgu6tOzKV1wmxkUk7VrboBY+uaqYWAaiG9
         F13LxQvgPiAug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, arnd@arndb.de,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 043/217] 8390: wd: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:16:46 -0500
Message-Id: <20220118021940.1942199-43-sashal@kernel.org>
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

[ Upstream commit f95f8e890a2aa576425402fea44bfa657e8ccaa6 ]

IO reads, so save to an array then eth_hw_addr_set().

Fixes build on x86 (32bit).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/8390/wd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/8390/wd.c b/drivers/net/ethernet/8390/wd.c
index 263a942d81fad..5b00c452bede6 100644
--- a/drivers/net/ethernet/8390/wd.c
+++ b/drivers/net/ethernet/8390/wd.c
@@ -168,6 +168,7 @@ static int __init wd_probe1(struct net_device *dev, int ioaddr)
 	int checksum = 0;
 	int ancient = 0;			/* An old card without config registers. */
 	int word16 = 0;				/* 0 = 8 bit, 1 = 16 bit */
+	u8 addr[ETH_ALEN];
 	const char *model_name;
 	static unsigned version_printed;
 	struct ei_device *ei_local = netdev_priv(dev);
@@ -191,7 +192,8 @@ static int __init wd_probe1(struct net_device *dev, int ioaddr)
 		netdev_info(dev, version);
 
 	for (i = 0; i < 6; i++)
-		dev->dev_addr[i] = inb(ioaddr + 8 + i);
+		addr[i] = inb(ioaddr + 8 + i);
+	eth_hw_addr_set(dev, addr);
 
 	netdev_info(dev, "WD80x3 at %#3x, %pM", ioaddr, dev->dev_addr);
 
-- 
2.34.1

