Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96351435752
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 02:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbhJUAZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 20:25:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231895AbhJUAY6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 20:24:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86E5261390;
        Thu, 21 Oct 2021 00:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775763;
        bh=hKNHpUjwbV7GyUuCs1SwwxbPtph0FNdJ+nUJWvu76N4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uyA1iDzR1F4WnsMignNIv/E3Q73BEKSSAsFCYOMP4/cc4FXVRt3WpUYnC+OJ2xac4
         SaoKLe+Ly+M4syXDYfsOtBLlv28HdvOEU4ylvyT+XrDc7GFVBwMV2Mzdtmwgqc/RAJ
         L4eYmsVZ3Q4IttzoEV4QnF3TRFAspJCi8DNo0S0fl116cKYAzCmASHof3wHOnYWnBr
         osMIvFo+zGDLdkgYQvvXalKBkfrUWHDj/xgZAV745zVsfAkuVgk5RCs2J4LEidbjVb
         TxqqdWfx2rjO+WL38qfkfwrcxp0y7b0jb3TqN2IK9ZynvDLeQYmuIpSPe5nc1OzFUY
         fxere45Xya2/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Herve Codina <herve.codina@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        kuba@kernel.org, mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 03/11] net: stmmac: add support for dwmac 3.40a
Date:   Wed, 20 Oct 2021 20:22:29 -0400
Message-Id: <20211021002238.1129482-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002238.1129482-1-sashal@kernel.org>
References: <20211021002238.1129482-1-sashal@kernel.org>
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
index fad503820e04..b3365b34cac7 100644
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
index 678aa2b001e0..a46fea472bc4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -505,6 +505,14 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
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
 	    of_device_is_compatible(np, "snps,dwmac-4.20a")) {
-- 
2.33.0

