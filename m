Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C34F74A8DC9
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 21:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354875AbiBCUd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 15:33:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35094 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243281AbiBCUcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 15:32:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE137B835A7;
        Thu,  3 Feb 2022 20:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF328C340F2;
        Thu,  3 Feb 2022 20:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920332;
        bh=cJz+WCKCtmXCo1AQ+BSDjP3riPuNHgmDjCEGV5+z4VY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C1Qzc6LbReGkGrWb2Eh4KjwhJIHkd9FNiCDVO3gZq4X/buOz9p4UjDWtoDRKcO5DG
         1Zt+nJVcI/5NgBzMJQNsGPfvbcFq6YOeUqzU1bP+/0pNtWkQTCK9tcgESL+mR16LDI
         1yudK/9YRNwuJqU1v7azd9HTLsnnjcqoy8VBZjoRd8uLWlZHg049fwsExyVf3FfZUY
         ZbYXV75gqsidxrSEEgoERl310R9s/2WYKjNw6FLb4aPyD+Mzi+X2bAiD6tIZT/XAoa
         oDAYy+X5ywAysi7UuGt5lHZrYDU+Js31Gb7l6e8Gq2DWMgtnZ2sCJPTrkBdCXAfetS
         WPs8A2yhdj8Uw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jisheng Zhang <jszhang@kernel.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        kuba@kernel.org, mcoquelin.stm32@gmail.com, mripard@kernel.org,
        wens@csie.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev
Subject: [PATCH AUTOSEL 5.16 45/52] net: stmmac: dwmac-sun8i: use return val of readl_poll_timeout()
Date:   Thu,  3 Feb 2022 15:29:39 -0500
Message-Id: <20220203202947.2304-45-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 9e0db41e7a0b6f1271cbcfb16dbf5b8641b4e440 ]

When readl_poll_timeout() timeout, we'd better directly use its return
value.

Before this patch:
[    2.145528] dwmac-sun8i: probe of 4500000.ethernet failed with error -14

After this patch:
[    2.138520] dwmac-sun8i: probe of 4500000.ethernet failed with error -110

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
index 617d0e4c64958..09644ab0d87a7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -756,7 +756,7 @@ static int sun8i_dwmac_reset(struct stmmac_priv *priv)
 
 	if (err) {
 		dev_err(priv->device, "EMAC reset timeout\n");
-		return -EFAULT;
+		return err;
 	}
 	return 0;
 }
-- 
2.34.1

