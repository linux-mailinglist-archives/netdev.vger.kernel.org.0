Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF68137401A
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbhEEQcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:32:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234138AbhEEQcl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:32:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 549A6613F3;
        Wed,  5 May 2021 16:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232304;
        bh=kEnxKvRvXtsSjAMGQKobqwfi53MrIc8FrAhY6aWVDy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IA3LKfUBvJMgmLY6BU4JAyfWmFim84Dz5PP5Gh6lG7xSKLdBL+Z6Wkm2Wgm3iouWB
         RPKt8Ru6vvMDiE40S/zK07iFZ449CRd49KO/209uCRdK76LkuwTgY/yzpPTW9V1X5c
         dglvCzdUYP6rqEyV7278b4f1CZz5zY14FdFgw/jZSULFpEN18akfcQqQD0S5DqvJkX
         xvQaiDocjXOvpyFCuQ9hb975eSrAUqeuBY7SoWrBSirXTU+IIyvqkouNNlOButMWWg
         YEjpu4bnuBpLtRCxfeWTZD1qHya733kBpZfZY4ZxGXzXaHjrP+aEeGcJF7PJhNEXeo
         oVSdH33/WLN4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan McDowell <noodles@earth.li>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 014/116] net: stmmac: Set FIFO sizes for ipq806x
Date:   Wed,  5 May 2021 12:29:42 -0400
Message-Id: <20210505163125.3460440-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan McDowell <noodles@earth.li>

[ Upstream commit e127906b68b49ddb3ecba39ffa36a329c48197d3 ]

Commit eaf4fac47807 ("net: stmmac: Do not accept invalid MTU values")
started using the TX FIFO size to verify what counts as a valid MTU
request for the stmmac driver.  This is unset for the ipq806x variant.
Looking at older patches for this it seems the RX + TXs buffers can be
up to 8k, so set appropriately.

(I sent this as an RFC patch in June last year, but received no replies.
I've been running with this on my hardware (a MikroTik RB3011) since
then with larger MTUs to support both the internal qca8k switch and
VLANs with no problems. Without the patch it's impossible to set the
larger MTU required to support this.)

Signed-off-by: Jonathan McDowell <noodles@earth.li>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
index bf3250e0e59c..749585fe6fc9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
@@ -352,6 +352,8 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
 	plat_dat->bsp_priv = gmac;
 	plat_dat->fix_mac_speed = ipq806x_gmac_fix_mac_speed;
 	plat_dat->multicast_filter_bins = 0;
+	plat_dat->tx_fifo_size = 8192;
+	plat_dat->rx_fifo_size = 8192;
 
 	err = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (err)
-- 
2.30.2

