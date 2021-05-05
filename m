Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0581374563
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238232AbhEERFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:05:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237525AbhEERAf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 13:00:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FD37619B9;
        Wed,  5 May 2021 16:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232811;
        bh=vI5LWT6H714BA7fXwBiqMpEcxeof87DXV4W9TPRXmZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XSmolPgMAoQCaEqCR9v2vDeA3qRhdsrOg5y5BNZqeZ1c095AHZPtAu21UzrB4ZCsC
         q5zHa2vhnhx+GI3naOzOSYrhoojKnP3oQj0NxbZ0A3wJqJP7Epkw65ntNgta44WJAC
         uAI0Q0euaH5MTha3mwh6Om0ge/JA38dUARJmyJTyet0YkwkFXZFAbNIMo/dgZcG10/
         KUrHn/90WmN7z+vmecCB4NA7lJUJSap/toJwms9/T8F1O91sQp2xlIxQnAkkVhxl60
         BPY5xjaGvb56jC38aaq34aboFIdQbyFPU8nlQUTX2+2wMQKKOlyGRNZm3W/GHFcijb
         3EAYaMcjiDgDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan McDowell <noodles@earth.li>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 04/32] net: stmmac: Set FIFO sizes for ipq806x
Date:   Wed,  5 May 2021 12:39:36 -0400
Message-Id: <20210505164004.3463707-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505164004.3463707-1-sashal@kernel.org>
References: <20210505164004.3463707-1-sashal@kernel.org>
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
index 826626e870d5..0f56f8e33691 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
@@ -351,6 +351,8 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
 	plat_dat->bsp_priv = gmac;
 	plat_dat->fix_mac_speed = ipq806x_gmac_fix_mac_speed;
 	plat_dat->multicast_filter_bins = 0;
+	plat_dat->tx_fifo_size = 8192;
+	plat_dat->rx_fifo_size = 8192;
 
 	err = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (err)
-- 
2.30.2

