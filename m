Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611D0690758
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 12:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbjBIL1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 06:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbjBIL0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 06:26:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8EF65A92A;
        Thu,  9 Feb 2023 03:20:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D981EB82108;
        Thu,  9 Feb 2023 11:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E0DC433D2;
        Thu,  9 Feb 2023 11:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941593;
        bh=iv5B47pNe86/2rxKzaoSgXckV5rpV41e5bD7FuJX/aQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OVHH3rdFT3BotvFYFDwCTw8C2UF5k1s7dCsJL6GTat3YrJcZjIuK7g0dBSLHyXbgg
         gj90tn8NiUD8ATrnQVbVYlXoXx6KaxwpJgaEkbCsZ11+Ap8E+3c8LVkPx6z8gvpWWX
         MmVCOpWX5ddahTSBsCDnSbKwtE+Phx4OsuSq3FB+glIt6AxecMxIKrtSyy7Ohok4AB
         4J/VFprt24hA0Weav1cZ90Q6V4lELORMWk8AlvhKh0gF6l5xTdRp2l2BMJ3S+GZtXY
         SEtf3Y8ZiTYrkEKnncYfesLRqdx/JLzr7oe4//6dGxjws/sb20ZaE6w/Deu/9nYZ9h
         myP8lKYa1i7jA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrey Konovalov <andrey.konovalov@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, vkoul@kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com, veekhee@apple.com,
        jonathanh@nvidia.com, ruppala@nvidia.com,
        tee.min.tan@linux.intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 07/10] net: stmmac: do not stop RX_CLK in Rx LPI state for qcs404 SoC
Date:   Thu,  9 Feb 2023 06:19:16 -0500
Message-Id: <20230209111921.1893095-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111921.1893095-1-sashal@kernel.org>
References: <20230209111921.1893095-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrey Konovalov <andrey.konovalov@linaro.org>

[ Upstream commit 54aa39a513dbf2164ca462a19f04519b2407a224 ]

Currently in phy_init_eee() the driver unconditionally configures the PHY
to stop RX_CLK after entering Rx LPI state. This causes an LPI interrupt
storm on my qcs404-base board.

Change the PHY initialization so that for "qcom,qcs404-ethqos" compatible
device RX_CLK continues to run even in Rx LPI state.

Signed-off-by: Andrey Konovalov <andrey.konovalov@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 2 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c       | 3 ++-
 include/linux/stmmac.h                                  | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index bfc4a92f1d92b..78be62ecc9a9a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -505,6 +505,8 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	plat_dat->has_gmac4 = 1;
 	plat_dat->pmt = 1;
 	plat_dat->tso_en = of_property_read_bool(np, "snps,tso");
+	if (of_device_is_compatible(np, "qcom,qcs404-ethqos"))
+		plat_dat->rx_clk_runs_in_lpi = 1;
 
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (ret)
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 3079e52546663..6a3b0f76d9729 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -932,7 +932,8 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 
 	stmmac_mac_set(priv, priv->ioaddr, true);
 	if (phy && priv->dma_cap.eee) {
-		priv->eee_active = phy_init_eee(phy, 1) >= 0;
+		priv->eee_active =
+			phy_init_eee(phy, !priv->plat->rx_clk_runs_in_lpi) >= 0;
 		priv->eee_enabled = stmmac_eee_init(priv);
 		stmmac_set_eee_pls(priv, priv->hw, true);
 	}
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 0b35747c9837a..88b107e20fc7c 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -178,6 +178,7 @@ struct plat_stmmacenet_data {
 	int rss_en;
 	int mac_port_sel_speed;
 	bool en_tx_lpi_clockgating;
+	bool rx_clk_runs_in_lpi;
 	int has_xgmac;
 	bool sph_disable;
 };
-- 
2.39.0

