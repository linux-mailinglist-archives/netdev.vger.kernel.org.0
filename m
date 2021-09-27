Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B634419598
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 15:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234687AbhI0OAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 10:00:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234645AbhI0OAe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 10:00:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 123F460F46;
        Mon, 27 Sep 2021 13:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632751136;
        bh=rXDXE/lV9ztJuIJrcfo0ufjzJVIQz5WYCaSugqmwOiM=;
        h=From:To:Cc:Subject:Date:From;
        b=PaCxMuZ3LY6eODYPf7LnJv+s8p8D6rwG1/Vi8HhO1hlLLeuf7i5Dm66XtPVH8AvT7
         sfzu3hEx5RG9H0Jj8vhAU3p6w29JfBzzqEJ4yLyozjOVx+e/QSVuK1aAYFZ8O1y6oT
         95StV/QSyno9YrKWm+F6s0nDtrF4+mENue41KReey11spVF+6SVwcd4YX5Na/vodkO
         gaOS+1DmubBrNYsuyWV4YjpLZq5JTJ2XEMLFe6ZU9O0Y3OGNwaNzRxISEK+rXjPia4
         A2aOqKj7rXid6BVkvfghfHDe5BR4KBKv+4ADjRwPDs5Cy1anZo5lvxZAeWDtPOtrU3
         BqlmQVW+EBgmw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc:     Russell King <linux@armlinux.org.uk>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Voon Weifeng <weifeng.voon@intel.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: stmmac: fix off-by-one error in sanity check
Date:   Mon, 27 Sep 2021 15:58:29 +0200
Message-Id: <20210927135849.1595484-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

My previous patch had an off-by-one error in the added sanity
check, the arrays are MTL_MAX_{RX,TX}_QUEUES long, so if that
index is that number, it has overflown.

The patch silenced the warning anyway because the strings could
no longer overlap with the input, but they could still overlap
with other fields.

Fixes: 3e0d5699a975 ("net: stmmac: fix gcc-10 -Wrestrict warning")
Reported-by: Russell King (Oracle) <linux@armlinux.org.uk>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 640c0ffdff3d..fd4c6517125e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3502,7 +3502,7 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 
 	/* Request Rx MSI irq */
 	for (i = 0; i < priv->plat->rx_queues_to_use; i++) {
-		if (i > MTL_MAX_RX_QUEUES)
+		if (i >= MTL_MAX_RX_QUEUES)
 			break;
 		if (priv->rx_irq[i] == 0)
 			continue;
@@ -3527,7 +3527,7 @@ static int stmmac_request_irq_multi_msi(struct net_device *dev)
 
 	/* Request Tx MSI irq */
 	for (i = 0; i < priv->plat->tx_queues_to_use; i++) {
-		if (i > MTL_MAX_TX_QUEUES)
+		if (i >= MTL_MAX_TX_QUEUES)
 			break;
 		if (priv->tx_irq[i] == 0)
 			continue;
-- 
2.29.2

