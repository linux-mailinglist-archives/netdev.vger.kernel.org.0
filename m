Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8540640AC3
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 17:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbiLBQ2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 11:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234170AbiLBQ2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 11:28:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17BB7B4A7;
        Fri,  2 Dec 2022 08:27:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0AF2B821E6;
        Fri,  2 Dec 2022 16:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E34C433B5;
        Fri,  2 Dec 2022 16:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669998456;
        bh=kZpD9Zd8fK5FsBNX8yWTE04dqx5btwD+2Ef6ipOw9BU=;
        h=From:To:Cc:Subject:Date:From;
        b=Rm0yQzBdKVK1FBZNHoIlyZG39wuLaY4SGohEy613Qrb9ahp8keVOgCj/k2xJxhYkS
         MKcrfYV+i7fCxBF+ez0fPKXH/mE8UAtn4Uj6GgdleLLwf5onAwtGru5dZz0ZQNYM5U
         NUM7hC9Qf76HUOqtV3AeG0wE5IzOye3kMgR5CIaPf6sBQUCHkR2yduwkCzJUVLzMZN
         S73vEeRGZveehiko234vPUyNWKsUgZcSVu7W9WfgqwP/gGIQP4O4y26OabDBvvfvVK
         q6at7Gk5LYxvwT6JGOn1EHElynaez0C4U8T3dX0mZMkPAKOKXbnZou/icapxATcr2u
         CD3pGvrDTPbDA==
From:   Jisheng Zhang <jszhang@kernel.org>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: stmmac: fix "snps,axi-config" node property parsing
Date:   Sat,  3 Dec 2022 00:17:39 +0800
Message-Id: <20221202161739.2203-1-jszhang@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In dt-binding snps,dwmac.yaml, some properties under "snps,axi-config"
node are named without "axi_" prefix, but the driver expects the
prefix. Since the dt-binding has been there for a long time, we'd
better make driver match the binding for compatibility.

Fixes: afea03656add ("stmmac: rework DMA bus setting and introduce new platform AXI structure")
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 50f6b4a14be4..eb6d9cd8e93f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -108,10 +108,10 @@ static struct stmmac_axi *stmmac_axi_setup(struct platform_device *pdev)
 
 	axi->axi_lpi_en = of_property_read_bool(np, "snps,lpi_en");
 	axi->axi_xit_frm = of_property_read_bool(np, "snps,xit_frm");
-	axi->axi_kbbe = of_property_read_bool(np, "snps,axi_kbbe");
-	axi->axi_fb = of_property_read_bool(np, "snps,axi_fb");
-	axi->axi_mb = of_property_read_bool(np, "snps,axi_mb");
-	axi->axi_rb =  of_property_read_bool(np, "snps,axi_rb");
+	axi->axi_kbbe = of_property_read_bool(np, "snps,kbbe");
+	axi->axi_fb = of_property_read_bool(np, "snps,fb");
+	axi->axi_mb = of_property_read_bool(np, "snps,mb");
+	axi->axi_rb =  of_property_read_bool(np, "snps,rb");
 
 	if (of_property_read_u32(np, "snps,wr_osr_lmt", &axi->axi_wr_osr_lmt))
 		axi->axi_wr_osr_lmt = 1;
-- 
2.38.1

