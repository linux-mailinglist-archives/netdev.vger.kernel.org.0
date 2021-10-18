Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232DE431FAD
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbhJROcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:32:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232464AbhJROb7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 10:31:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49B9860FDA;
        Mon, 18 Oct 2021 14:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634567388;
        bh=OjZwUp1zcomFupzttYqn2IxBtb7Bvrr1uj68/IcvdQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M6J+/Ci/oU0p9k5qErYTjJwboADQZf0mSYEkE24snI3wnxTvb0Ojh1RUNHSdpI7PJ
         NaLy7NCPTOVdRcV6cB/H7XWybKGLui5eACSoJ/17ZazkqgIb1p2wnkfMJ63k7SjKkw
         hbkht2wr25mt515V2C2vHTAsit7uc3i+50Zx8VT0WNHmSHZnnn9QAbyIcMN32dGapM
         zTzHijit80AjddEDL4wWbtxBajZqUOtaZmC40KfDN+373pJOHrcQr0uVmP40qncQa/
         8AD2btNKwZXeTnXwewySCjCAMczbZ3poOebZaSIMPbazCMtnWmR8g5dcGyHTTwtVj6
         qRIlq8OfVR0LQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        sebastian.hesselbarth@gmail.com
Subject: [PATCH net-next 01/12] ethernet: mv643xx: use eth_hw_addr_set()
Date:   Mon, 18 Oct 2021 07:29:21 -0700
Message-Id: <20211018142932.1000613-2-kuba@kernel.org>
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

Read the address into an array on the stack, then call
eth_hw_addr_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: sebastian.hesselbarth@gmail.com
---
 drivers/net/ethernet/marvell/mv643xx_eth.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index a63d9a5c8059..bb14fa2241a3 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2925,10 +2925,14 @@ static void set_params(struct mv643xx_eth_private *mp,
 	struct net_device *dev = mp->dev;
 	unsigned int tx_ring_size;
 
-	if (is_valid_ether_addr(pd->mac_addr))
+	if (is_valid_ether_addr(pd->mac_addr)) {
 		eth_hw_addr_set(dev, pd->mac_addr);
-	else
-		uc_addr_get(mp, dev->dev_addr);
+	} else {
+		u8 addr[ETH_ALEN];
+
+		uc_addr_get(mp, addr);
+		eth_hw_addr_set(dev, addr);
+	}
 
 	mp->rx_ring_size = DEFAULT_RX_QUEUE_SIZE;
 	if (pd->rx_queue_size)
-- 
2.31.1

