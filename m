Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9697B4A8EC7
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 21:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355489AbiBCUiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 15:38:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38908 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354946AbiBCUgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 15:36:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2CE0B835BF;
        Thu,  3 Feb 2022 20:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE474C340E8;
        Thu,  3 Feb 2022 20:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920610;
        bh=NWXtWuPcTk1NqFEhAom7jp65/IRafTnTScGEgINFwbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mb0Mg6QXlWGk9D8UAB/Ewi3v8Z5/KAUPnEtcTCKUS9yGi3wNlCHb6KksKt6GmRG/+
         jpSdyk1gXRHXVFFds7eIp6HQqfxIMff3jTADURPv6D3MclkKFhOrtaOkVsFksM4VMK
         8RsbcbU3ZQFqC7P2qhEdq2snYgARHEV5RXlHDR1344zSRlSY/fpun2fkg2R2dK1Vro
         uj6gneb7zuuoR3nKwRivmJxoBLh58+7fQ+WRAYaIelHJXZ6yj9AzoIy+NExehwdF/m
         F8jG4jw0i4rHlvESJ6S7wmerKM/YZWa4B80wCbqZ6YabGvHV7kdCjXv7z00goyhJr/
         FMfMR0uOB0S5g==
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
Subject: [PATCH AUTOSEL 4.14 9/9] net: stmmac: dwmac-sun8i: use return val of readl_poll_timeout()
Date:   Thu,  3 Feb 2022 15:36:33 -0500
Message-Id: <20220203203633.4685-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203633.4685-1-sashal@kernel.org>
References: <20220203203633.4685-1-sashal@kernel.org>
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
index 8e60315a087c9..1027831e5d814 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
@@ -630,7 +630,7 @@ static int sun8i_dwmac_reset(struct stmmac_priv *priv)
 
 	if (err) {
 		dev_err(priv->device, "EMAC reset timeout\n");
-		return -EFAULT;
+		return err;
 	}
 	return 0;
 }
-- 
2.34.1

