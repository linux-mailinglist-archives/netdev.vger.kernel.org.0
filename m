Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85FC3E2FB9
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 21:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243804AbhHFTOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 15:14:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243651AbhHFTOb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 15:14:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95D5C60FE7;
        Fri,  6 Aug 2021 19:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628277255;
        bh=S0NLSVNOkPnCNQLU6WMZArQYHq84pOpdEHa4pG7usZU=;
        h=From:To:Cc:Subject:Date:From;
        b=Qk58ppStHuW1QItokiGwD2dv9tPrfG82EjokWbtulDZHWjyN4xpd5gzUINZwfc9lk
         n9ZtvQ2C/t1wQ6MYtRuXQeToMpm+id1Iq6b69X+1tbh0qFcWyKmJBj6wO6LE2ilGpS
         2TnKK7bHXBQPdrrzMdywL4nFe9YoeJixgMt6aXQm0HZuzaTFstq0ntOXNruaVH31I5
         cO3xjlhksGFPQqMd4EugsDyDIYCzZGEoOWpHAxh8YTdQg0eAX1VX7LF3W9cBfTk/Vh
         di6ll2TqnF6+u3KOTLJNcxY0lBlA04/CiATc/uMhTsbr3uHPPq8jzPnslQC8umM2Rk
         hw1TW1kfPE78Q==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH] net: ethernet: stmmac: Do not use unreachable() in ipq806x_gmac_probe()
Date:   Fri,  6 Aug 2021 12:13:40 -0700
Message-Id: <20210806191339.576318-1-nathan@kernel.org>
X-Mailer: git-send-email 2.33.0.rc0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When compiling with clang in certain configurations, an objtool warning
appears:

drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.o: warning: objtool:
ipq806x_gmac_probe() falls through to next function phy_modes()

This happens because the unreachable annotation in the third switch
statement is not eliminated. The compiler should know that the first
default case would prevent the second and third from being reached as
the comment notes but sanitizer options can make it harder for the
compiler to reason this out.

Help the compiler out by eliminating the unreachable() annotation and
unifying the default case error handling so that there is no objtool
warning, the meaning of the code stays the same, and there is less
duplication.

Reported-by: Sami Tolvanen <samitolvanen@google.com>
Tested-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 .../ethernet/stmicro/stmmac/dwmac-ipq806x.c    | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
index 28dd0ed85a82..f7dc8458cde8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
@@ -289,10 +289,7 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
 		val &= ~NSS_COMMON_GMAC_CTL_PHY_IFACE_SEL;
 		break;
 	default:
-		dev_err(&pdev->dev, "Unsupported PHY mode: \"%s\"\n",
-			phy_modes(gmac->phy_mode));
-		err = -EINVAL;
-		goto err_remove_config_dt;
+		goto err_unsupported_phy;
 	}
 	regmap_write(gmac->nss_common, NSS_COMMON_GMAC_CTL(gmac->id), val);
 
@@ -309,10 +306,7 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
 			NSS_COMMON_CLK_SRC_CTRL_OFFSET(gmac->id);
 		break;
 	default:
-		dev_err(&pdev->dev, "Unsupported PHY mode: \"%s\"\n",
-			phy_modes(gmac->phy_mode));
-		err = -EINVAL;
-		goto err_remove_config_dt;
+		goto err_unsupported_phy;
 	}
 	regmap_write(gmac->nss_common, NSS_COMMON_CLK_SRC_CTRL, val);
 
@@ -329,8 +323,7 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
 				NSS_COMMON_CLK_GATE_GMII_TX_EN(gmac->id);
 		break;
 	default:
-		/* We don't get here; the switch above will have errored out */
-		unreachable();
+		goto err_unsupported_phy;
 	}
 	regmap_write(gmac->nss_common, NSS_COMMON_CLK_GATE, val);
 
@@ -361,6 +354,11 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_unsupported_phy:
+	dev_err(&pdev->dev, "Unsupported PHY mode: \"%s\"\n",
+		phy_modes(gmac->phy_mode));
+	err = -EINVAL;
+
 err_remove_config_dt:
 	stmmac_remove_config_dt(pdev, plat_dat);
 

base-commit: 8fbebef80107d779b8e356cf60323454a4099d76
-- 
2.33.0.rc0

