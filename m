Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C7D43577C
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 02:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbhJUA0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 20:26:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232137AbhJUAZ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 20:25:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA6B661260;
        Thu, 21 Oct 2021 00:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775791;
        bh=qmnfZ1A8ecuIGUREcjAFkojUBDHknIeD//6jyvwyaOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZuCfCP7N4PJgKo6WR55noBmkvz/YpSgQiydD56d12/uOG/0ZiiDQ1eJUn2f0VYMUM
         hYmBOGunoOQl6Dm9coDk9J3TXvP9gW/jrGkmI5mf0HxbC/rbPa7Nrd0DOnmJRrjxBZ
         OXyFfMQBMNZgVsFY3QSAa4MImfDNgavdeRZmXOszNS3/TpHrd14PsBAQr10FOynvI5
         pmyzZwn7dzV3Zy/EJeBvJDamVzqLGUjCrdHKQu4rHoYNU5xBtjfBe3+Lr8RO4U9YfZ
         Hb9j3wT73nzuyg9A5yBYWprxSBdJtvHEVoggSmK6MDeKynt5TSYFCYt4q+RIov8AXC
         Nx7722oTZudBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Herve Codina <herve.codina@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        kuba@kernel.org, mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 03/10] net: stmmac: add support for dwmac 3.40a
Date:   Wed, 20 Oct 2021 20:22:58 -0400
Message-Id: <20211021002305.1129633-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002305.1129633-1-sashal@kernel.org>
References: <20211021002305.1129633-1-sashal@kernel.org>
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
index 2b800ce1d5bf..05f5084158bf 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -469,6 +469,14 @@ stmmac_probe_config_dt(struct platform_device *pdev, const char **mac)
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

