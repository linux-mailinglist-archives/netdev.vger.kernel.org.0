Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA0F43397F
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 17:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbhJSPCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 11:02:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232126AbhJSPCe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 11:02:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D1F9613A4;
        Tue, 19 Oct 2021 15:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634655619;
        bh=k1ZFk/5FR8UhXYQ4Om34BhWCra8K/FHBV30wgh0SiRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XNSa3rfwGmmK3PTbmdF8eIfrZIjQX719ot7oeeJzRd0Rw+kfEc2SvqMFPGYjVHHur
         0/+qiafPznSGq979mAwD17VGfxJlGGrbdKj3pgaVzt+mTGqHP1U6pw0qkeYD0pTtzi
         PUQ3zd8xu9EzGAKqVGJ9shp9hD0Adn4LlI2N48t9jJ0QuWH6Xw3pxaXIQtyZrTxCek
         7sq8zAJC+OklUjNMJhsJsl7MZybTe764tqz9viskxFB7D8p4DFgLKEo4dEHBcw+GiZ
         cQCHG16jIWXJwGzdYjNfXpG9KtQN6gYRRhx7AMgtWe7HNdado0cZU1EhZ71b6PIzG8
         WZs48BITVHnbg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        romieu@fr.zoreil.com
Subject: [PATCH net-next 6/6] ethernet: via-velocity: use eth_hw_addr_set()
Date:   Tue, 19 Oct 2021 08:00:11 -0700
Message-Id: <20211019150011.1355755-7-kuba@kernel.org>
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
CC: romieu@fr.zoreil.com
---
 drivers/net/ethernet/via/via-velocity.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index 4b9c30f735b5..be2b992f24d9 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -2767,6 +2767,7 @@ static int velocity_probe(struct device *dev, int irq,
 	struct velocity_info *vptr;
 	struct mac_regs __iomem *regs;
 	int ret = -ENOMEM;
+	u8 addr[ETH_ALEN];
 
 	/* FIXME: this driver, like almost all other ethernet drivers,
 	 * can support more than MAX_UNITS.
@@ -2820,7 +2821,8 @@ static int velocity_probe(struct device *dev, int irq,
 	mac_wol_reset(regs);
 
 	for (i = 0; i < 6; i++)
-		netdev->dev_addr[i] = readb(&regs->PAR[i]);
+		addr[i] = readb(&regs->PAR[i]);
+	eth_hw_addr_set(netdev, addr);
 
 
 	velocity_get_options(&vptr->options, velocity_nics);
-- 
2.31.1

