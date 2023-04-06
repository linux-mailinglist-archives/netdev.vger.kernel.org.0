Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBC06D9EBC
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 19:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239900AbjDFRaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 13:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjDFRaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 13:30:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D14986A5
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 10:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E86264A79
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 17:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A998C433D2;
        Thu,  6 Apr 2023 17:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680802219;
        bh=ZJKba0+w5vwtN3goyHbArkfj6XhrRd7mEr46lY1n1Ag=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=A/aOGZg8KrdEMzpZI1ZeCrSP4OnuuIbmN7t1goTxUddA3EpT32t4hIgRvxTsJ/jst
         ZwNNbKdwws39ddAoVRaU1QVsD95W0ubL/CnuF+zr/fpO+t+fQp+cI72uMBpi7lS3Kn
         NLfYa7tGHwTPUkWdexCqfEznsGxvrzHKvuOmtwPzcpqwJjPerGnHofRBDNTUWt1xgx
         j7ZFOI45igB4whQCI+izb+bW8ETqlztIK2h57iYMlbEP2eZoXyl7nUVssesLGOj1bW
         vGgTA16WwcSQYNcakf/rYoZ5F+Dbud8uFg6SWG4dnUkg1DLiw7aldFriFo2r/NnA9m
         a5qZwJJhOm11g==
From:   Simon Horman <horms@kernel.org>
Date:   Thu, 06 Apr 2023 19:30:09 +0200
Subject: [PATCH net-next 1/2] net: stmmac: dwmac-anarion: Use annotation
 __iomem for register base
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230406-dwmac-anarion-sparse-v1-1-b0c866c8be9d@kernel.org>
References: <20230406-dwmac-anarion-sparse-v1-0-b0c866c8be9d@kernel.org>
In-Reply-To: <20230406-dwmac-anarion-sparse-v1-0-b0c866c8be9d@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use __iomem annotation the register base: the ctl_block field of struct
anarion_gmac. I believe this is the normal practice for such variables.

By doing so some casting is avoided.
And sparse no longer reports:

 .../dwmac-anarion.c:29:23: warning: incorrect type in argument 1 (different address spaces)
 .../dwmac-anarion.c:29:23:    expected void const volatile [noderef] __iomem *addr
 .../dwmac-anarion.c:29:23:    got void *
 .../dwmac-anarion.c:34:22: warning: incorrect type in argument 2 (different address spaces)
 .../dwmac-anarion.c:34:22:    expected void volatile [noderef] __iomem *addr
 .../dwmac-anarion.c:34:22:    got void *

No functional change intended.
Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c
index dfbaea06d108..2357e77434fb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-anarion.c
@@ -20,18 +20,18 @@
 #define  GMAC_CONFIG_INTF_RGMII		(0x1 << 0)
 
 struct anarion_gmac {
-	uintptr_t ctl_block;
+	void __iomem *ctl_block;
 	uint32_t phy_intf_sel;
 };
 
 static uint32_t gmac_read_reg(struct anarion_gmac *gmac, uint8_t reg)
 {
-	return readl((void *)(gmac->ctl_block + reg));
+	return readl(gmac->ctl_block + reg);
 };
 
 static void gmac_write_reg(struct anarion_gmac *gmac, uint8_t reg, uint32_t val)
 {
-	writel(val, (void *)(gmac->ctl_block + reg));
+	writel(val, gmac->ctl_block + reg);
 }
 
 static int anarion_gmac_init(struct platform_device *pdev, void *priv)
@@ -77,7 +77,7 @@ static struct anarion_gmac *anarion_config_dt(struct platform_device *pdev)
 	if (!gmac)
 		return ERR_PTR(-ENOMEM);
 
-	gmac->ctl_block = (uintptr_t)ctl_block;
+	gmac->ctl_block = ctl_block;
 
 	err = of_get_phy_mode(pdev->dev.of_node, &phy_mode);
 	if (err)

-- 
2.30.2

