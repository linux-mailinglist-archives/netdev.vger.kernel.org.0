Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84B843397C
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 17:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbhJSPCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 11:02:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233040AbhJSPCa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 11:02:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFE3760FDA;
        Tue, 19 Oct 2021 15:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634655618;
        bh=5S4lrfcK6SdE4Qlnl4jFyo3ZGNQ0119VEEkIwnOqteQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DVXn2C++U6k1yvSYov25rErGp9sw0PPwsovfKwyG7ox0HG59tfOwizFNB0Gusgk9B
         hR/fL5N899iPtGwofcwJ7QaGzAGlyXwMncVQemK36r2h2zyjP5r5wQ/WAkmH/VXYF9
         xvFiKnb2btpm8G188yOzmmt2Yvzh8MTtiHRRJYBhDBXOr/JYhAzRW3Hp8AgwfwokHH
         c+fZqmTgBXe2kW+mRh1IXY0dQKHEYCnOppRv43FKJIF91pUWFegVEKrF08HAgQ5l7d
         tiPHAquDzhQJnoO07sZC3qvpLlSNWAx7jiEaTUb70yV0SvMCl86T5ItkQOIPeUT9GD
         0qaDfR0Sqi18Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org
Subject: [PATCH net-next 1/6] ethernet: netsec: use eth_hw_addr_set()
Date:   Tue, 19 Oct 2021 08:00:06 -0700
Message-Id: <20211019150011.1355755-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019150011.1355755-1-kuba@kernel.org>
References: <20211019150011.1355755-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Read the address into an array on the stack, then call
eth_hw_addr_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jaswinder.singh@linaro.org
CC: ilias.apalodimas@linaro.org
---
 drivers/net/ethernet/socionext/netsec.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index baa9f5d1c549..de7d8bf2c226 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -2037,13 +2037,15 @@ static int netsec_probe(struct platform_device *pdev)
 	if (ret && priv->eeprom_base) {
 		void __iomem *macp = priv->eeprom_base +
 					NETSEC_EEPROM_MAC_ADDRESS;
-
-		ndev->dev_addr[0] = readb(macp + 3);
-		ndev->dev_addr[1] = readb(macp + 2);
-		ndev->dev_addr[2] = readb(macp + 1);
-		ndev->dev_addr[3] = readb(macp + 0);
-		ndev->dev_addr[4] = readb(macp + 7);
-		ndev->dev_addr[5] = readb(macp + 6);
+		u8 addr[ETH_ALEN];
+
+		addr[0] = readb(macp + 3);
+		addr[1] = readb(macp + 2);
+		addr[2] = readb(macp + 1);
+		addr[3] = readb(macp + 0);
+		addr[4] = readb(macp + 7);
+		addr[5] = readb(macp + 6);
+		eth_hw_addr_set(ndev, addr);
 	}
 
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
-- 
2.31.1

