Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDF2649170E
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346373AbiARChj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:37:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51370 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343672AbiARCeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:34:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6B1761268;
        Tue, 18 Jan 2022 02:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA79C36AEB;
        Tue, 18 Jan 2022 02:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473244;
        bh=Eia1I/7kXiGFDysXVFjJwEP3xWDF4EvGMO70qbMvXbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vn/M1ESlGoayUwMPh1va3lIdzWYfvkJOu/WYfN5dszdhbYuPbLrShZO85m4KUfMzK
         DhYYzX8U6GNODAUj6E/kPWu1uORwBlTF9qxtWta1W1gnIWdvYQAhadqiCgAxCy7EqZ
         cks9pgt6vtU/QX61t+ctW37LKkM5JJpSN3hQPmMCzKD26eeO6j3fMVle2CK3RDLbUw
         3FqRhkvKCwrWBGBChYn+pTBePTZQQGqAG34Nnnhftdnlw4E/Rvg7QNPEZBTehctN/W
         Yu6u33JBNN3c+GAmcnuOvKBJvwnVTKxGJR62xKWRFexNwQXbLEBygrw+p/xFMLGAUQ
         E3VYMJ83zsm0Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, tanghui20@huawei.com,
        arnd@arndb.de, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 038/188] smc9194: use eth_hw_addr_set()
Date:   Mon, 17 Jan 2022 21:29:22 -0500
Message-Id: <20220118023152.1948105-38-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 80db345e7df0c507a83bd12ac7766fb054443804 ]

dev_addr is set from IO reads, and broken from a u16 value.

Fixes build on Alpha.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/smsc/smc9194.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smc9194.c b/drivers/net/ethernet/smsc/smc9194.c
index 0ce403fa5f1a4..af661c65ffe2f 100644
--- a/drivers/net/ethernet/smsc/smc9194.c
+++ b/drivers/net/ethernet/smsc/smc9194.c
@@ -856,6 +856,7 @@ static int __init smc_probe(struct net_device *dev, int ioaddr)
 	word configuration_register;
 	word memory_info_register;
 	word memory_cfg_register;
+	u8 addr[ETH_ALEN];
 
 	/* Grab the region so that no one else tries to probe our ioports. */
 	if (!request_region(ioaddr, SMC_IO_EXTENT, DRV_NAME))
@@ -924,9 +925,10 @@ static int __init smc_probe(struct net_device *dev, int ioaddr)
 		word	address;
 
 		address = inw( ioaddr + ADDR0 + i  );
-		dev->dev_addr[ i + 1] = address >> 8;
-		dev->dev_addr[ i ] = address & 0xFF;
+		addr[i + 1] = address >> 8;
+		addr[i] = address & 0xFF;
 	}
+	eth_hw_addr_set(dev, addr);
 
 	/* get the memory information */
 
-- 
2.34.1

