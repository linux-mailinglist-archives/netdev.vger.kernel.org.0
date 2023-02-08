Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F24B68F384
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 17:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbjBHQlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 11:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbjBHQkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 11:40:36 -0500
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37474DE0C;
        Wed,  8 Feb 2023 08:40:30 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A60E81BF211;
        Wed,  8 Feb 2023 16:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675874429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XCj30NsK+6xPXdqbwOoZtwRO/ZUoDqTO5hHn+iKnF+o=;
        b=GTQjKeKP6jCXB+susoQC6r7Wao2poP1/a4Ob8/035exSTjKkF1n85RREgusN779F90UUSp
        VAD+NeoYQcdm/pZDqopInkA0VBppi35mawnAN1AiQBezpmMkBa6qjkO+kqxXeAOhM34RLA
        zgx8CfO5qDXiseFzrakMKFj1fQ5hryT90ocK92GhvDoR93YZC8CfYFDasvnnHIjDB0kARr
        psn2hP2/+EyIeEdbUZY5jol+oDQaeVv02aZx6QxRwC1jcmL4xlKHhLHMHJ6dreVIiUJ8BO
        2Rp3Q6RqOf4mEIor/Ahx883YWs1ka9LFFypyBrrtceDqIeQRCPr9ktk7Uj5tbw==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Wong Vee Khee <veekhee@apple.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Jon Hunter <jonathanh@nvidia.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next v2 3/6] net: stmmac: add support to provide pcs from platform data
Date:   Wed,  8 Feb 2023 17:42:00 +0100
Message-Id: <20230208164203.378153-4-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230208164203.378153-1-clement.leger@bootlin.com>
References: <20230208164203.378153-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a pcs field in platform_data to allow providing platform data. This is
gonig to be used by the renesas,rzn1-gmac compatible driver which can make
use of a PCS.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 +++
 include/linux/stmmac.h                            | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 9a8721227b17..8bf5f73eb4c8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7295,6 +7295,9 @@ int stmmac_dvr_probe(struct device *device,
 			goto error_xpcs_setup;
 	}
 
+	if (priv->plat->pcs)
+		priv->hw->phylink_pcs = priv->plat->pcs;
+
 	ret = stmmac_phy_setup(priv);
 	if (ret) {
 		netdev_err(ndev, "failed to setup phy (%d)\n", ret);
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index a152678b82b7..104b3d1101c0 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -273,5 +273,6 @@ struct plat_stmmacenet_data {
 	bool use_phy_wol;
 	bool sph_disable;
 	bool serdes_up_after_phy_linkup;
+	struct phylink_pcs *pcs;
 };
 #endif
-- 
2.39.0

