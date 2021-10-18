Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C2E431FB2
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232243AbhJROcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:32:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232230AbhJROcI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 10:32:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEBB061212;
        Mon, 18 Oct 2021 14:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634567390;
        bh=L8Mn1vaApizvVOxom4fIniUWoQnu6O0OAb6UlgU5gGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZMo3tQDymsFqToAm4yfXGWqFkMbyDUpYfFi69CIQiZpI73iTKtoRtx2fEh3yUZhL
         F7FOpIdswx3K3Juirc1F9E4kXLcYn7mz03FDo+r5/9ZLdaeJbM8PNxWiLNnuh9ALfh
         IZyq1PywDUD83JaUhkMEkJa/eUhGyJFUWrf/X9jP+jlYezSvzfpcyL8ds9+cWr/0/1
         IjyOkNoMdqaABYPLRCkR21K7M9stgDPzQuJWnyry4GOnhc9bUAcOQdWmwkpsXY/q6/
         MzhE0Ld+jAyj2dWDNlVC8//kAP2uaw0i0qy7WQcLE6a185PNmtIEo5cp2MFh77cfsM
         Q6dMbTsvihCsQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        s.shtylyov@omp.ru, biju.das.jz@bp.renesas.com,
        prabhakar.mahadev-lad.rj@bp.renesas.com
Subject: [PATCH net-next 06/12] ethernet: renesas: use eth_hw_addr_set()
Date:   Mon, 18 Oct 2021 07:29:26 -0700
Message-Id: <20211018142932.1000613-7-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211018142932.1000613-1-kuba@kernel.org>
References: <20211018142932.1000613-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Break the address up into an array on the stack, then call
eth_hw_addr_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: s.shtylyov@omp.ru
CC: biju.das.jz@bp.renesas.com
CC: prabhakar.mahadev-lad.rj@bp.renesas.com
---
 drivers/net/ethernet/renesas/ravb_main.c | 16 +++++++++-------
 drivers/net/ethernet/renesas/sh_eth.c    | 16 +++++++++-------
 2 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index e5243cc87a19..b4c597f4040c 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -136,13 +136,15 @@ static void ravb_read_mac_address(struct device_node *np,
 	if (ret) {
 		u32 mahr = ravb_read(ndev, MAHR);
 		u32 malr = ravb_read(ndev, MALR);
-
-		ndev->dev_addr[0] = (mahr >> 24) & 0xFF;
-		ndev->dev_addr[1] = (mahr >> 16) & 0xFF;
-		ndev->dev_addr[2] = (mahr >>  8) & 0xFF;
-		ndev->dev_addr[3] = (mahr >>  0) & 0xFF;
-		ndev->dev_addr[4] = (malr >>  8) & 0xFF;
-		ndev->dev_addr[5] = (malr >>  0) & 0xFF;
+		u8 addr[ETH_ALEN];
+
+		addr[0] = (mahr >> 24) & 0xFF;
+		addr[1] = (mahr >> 16) & 0xFF;
+		addr[2] = (mahr >>  8) & 0xFF;
+		addr[3] = (mahr >>  0) & 0xFF;
+		addr[4] = (malr >>  8) & 0xFF;
+		addr[5] = (malr >>  0) & 0xFF;
+		eth_hw_addr_set(ndev, addr);
 	}
 }
 
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 0a7d23df45f2..a3fbb2221c9a 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -1157,13 +1157,15 @@ static void read_mac_address(struct net_device *ndev, unsigned char *mac)
 	} else {
 		u32 mahr = sh_eth_read(ndev, MAHR);
 		u32 malr = sh_eth_read(ndev, MALR);
-
-		ndev->dev_addr[0] = (mahr >> 24) & 0xFF;
-		ndev->dev_addr[1] = (mahr >> 16) & 0xFF;
-		ndev->dev_addr[2] = (mahr >>  8) & 0xFF;
-		ndev->dev_addr[3] = (mahr >>  0) & 0xFF;
-		ndev->dev_addr[4] = (malr >>  8) & 0xFF;
-		ndev->dev_addr[5] = (malr >>  0) & 0xFF;
+		u8 addr[ETH_ALEN];
+
+		addr[0] = (mahr >> 24) & 0xFF;
+		addr[1] = (mahr >> 16) & 0xFF;
+		addr[2] = (mahr >>  8) & 0xFF;
+		addr[3] = (mahr >>  0) & 0xFF;
+		addr[4] = (malr >>  8) & 0xFF;
+		addr[5] = (malr >>  0) & 0xFF;
+		eth_hw_addr_set(ndev, addr);
 	}
 }
 
-- 
2.31.1

