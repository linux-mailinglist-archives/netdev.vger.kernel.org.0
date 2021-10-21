Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A524356F4
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 02:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbhJUAXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 20:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231727AbhJUAXb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 20:23:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8970061374;
        Thu, 21 Oct 2021 00:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775676;
        bh=F4e7r/rNpG6DdfngI7GrT/fuUKS/XfxaHkfpxSKvNgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bUMu/6AEzhbAFOHnodx9uaccVqLyrZdUYQjYYOe5J6H7nNi4Jy6itGqyykG7lwVMx
         7IvnXo7kpffHivrTZq+FOnA3uNa+tE3uUyG1YFWlg/oRdFui+1Dg3DbT8aa95bE+1L
         NEq0Bo0AOlxO0sVrSjrXNLq+ARd+zKJAnaXNbyNs5+py0i/HLWv7FQVWiYNbYmzr0a
         Z27t6O3jIZG7NAxEmU/yXvqUH1nee81coBQARrNWmbnRIxXOHOPfGMsXvMK1xoWEnV
         7DM2CY9dWKPCbuHxVLqIa9buJfqoHBY+yMO4eEgJxT4W8ADk1px/r9JLJ0O88JRyGd
         e8TCe/0d5s1LQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Herve Codina <herve.codina@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        kuba@kernel.org, mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 12/26] net: stmmac: add support for dwmac 3.40a
Date:   Wed, 20 Oct 2021 20:20:09 -0400
Message-Id: <20211021002023.1128949-12-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002023.1128949-1-sashal@kernel.org>
References: <20211021002023.1128949-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit 9cb1d19f47fafad7dcf7c8564e633440c946cfd7 ]

dwmac 3.40a is an old ip version that can be found on SPEAr3xx soc.

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c   | 1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c
index fbfda55b4c52..5e731a72cce8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c
@@ -71,6 +71,7 @@ static int dwmac_generic_probe(struct platform_device *pdev)
 
 static const struct of_device_id dwmac_generic_match[] = {
 	{ .compatible = "st,spear600-gmac"},
+	{ .compatible = "snps,dwmac-3.40a"},
 	{ .compatible = "snps,dwmac-3.50a"},
 	{ .compatible = "snps,dwmac-3.610"},
 	{ .compatible = "snps,dwmac-3.70a"},
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 62cec9bfcd33..232ac98943cd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -508,6 +508,14 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 		plat->pmt = 1;
 	}
 
+	if (of_device_is_compatible(np, "snps,dwmac-3.40a")) {
+		plat->has_gmac = 1;
+		plat->enh_desc = 1;
+		plat->tx_coe = 1;
+		plat->bugged_jumbo = 1;
+		plat->pmt = 1;
+	}
+
 	if (of_device_is_compatible(np, "snps,dwmac-4.00") ||
 	    of_device_is_compatible(np, "snps,dwmac-4.10a") ||
 	    of_device_is_compatible(np, "snps,dwmac-4.20a") ||
-- 
2.33.0

