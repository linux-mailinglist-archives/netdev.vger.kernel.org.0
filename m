Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6EB692DAE
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 04:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjBKDTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 22:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjBKDTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 22:19:00 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5DB3C3D;
        Fri, 10 Feb 2023 19:18:42 -0800 (PST)
Received: from localhost (unknown [86.120.32.152])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: cristicc)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 002A06602123;
        Sat, 11 Feb 2023 03:18:40 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1676085521;
        bh=3V60+yUqxQRcUNuxYulirFMaKOTYIE7PaGKbZOUC0s0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mnEoqbs0VwxfMXt5qDvLiGFhb8V0gNhxaYj6rJMaOek7O/8UeoKKjk2iAFu+I6EWV
         MPWy3ayM5k8ZQ/I2TproZY5gdjsnltmIP9IdBHvqJopYxTJR41uSWuIyjvtfiJ14zf
         AH04ykzFvWuub2u7ikxOXNuQ68mQwBk6XmJsWzBAE6uHCXUuJ9hYCADWIQNcm/efHu
         z7cAU4mphDdxLakwH1klnEoqmgYugEdmVnjmcb61uYlWQXuq9qWeb2Bb+CS+hAfuvG
         Vq0HNyZSblq2UPQm2yoTgaHiq3f/zCZ1zi1R8CRdS+Gc2UkhoMnnMFsvFTuQDe246+
         RH12SsTplWzLA==
From:   Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
To:     Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
Subject: [PATCH 03/12] soc: sifive: ccache: Add StarFive JH7100 support
Date:   Sat, 11 Feb 2023 05:18:12 +0200
Message-Id: <20230211031821.976408-4-cristian.ciocaltea@collabora.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emil Renner Berthing <kernel@esmil.dk>

This adds support for the StarFive JH7100 SoC which also feature this
SiFive cache controller.

Unfortunately the interrupt for uncorrected data is broken on the JH7100
and fires continuously, so add a quirk to not register a handler for it.

Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
[drop JH7110, rework Kconfig]
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
---
 drivers/soc/sifive/Kconfig         |  1 +
 drivers/soc/sifive/sifive_ccache.c | 11 ++++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/sifive/Kconfig b/drivers/soc/sifive/Kconfig
index e86870be34c9..867cf16273a4 100644
--- a/drivers/soc/sifive/Kconfig
+++ b/drivers/soc/sifive/Kconfig
@@ -4,6 +4,7 @@ if SOC_SIFIVE || SOC_STARFIVE
 
 config SIFIVE_CCACHE
 	bool "Sifive Composable Cache controller"
+	default SOC_STARFIVE
 	help
 	  Support for the composable cache controller on SiFive platforms.
 
diff --git a/drivers/soc/sifive/sifive_ccache.c b/drivers/soc/sifive/sifive_ccache.c
index 3684f5b40a80..676468c35859 100644
--- a/drivers/soc/sifive/sifive_ccache.c
+++ b/drivers/soc/sifive/sifive_ccache.c
@@ -106,6 +106,7 @@ static void ccache_config_read(void)
 static const struct of_device_id sifive_ccache_ids[] = {
 	{ .compatible = "sifive,fu540-c000-ccache" },
 	{ .compatible = "sifive,fu740-c000-ccache" },
+	{ .compatible = "starfive,jh7100-ccache", .data = (void *)BIT(DATA_UNCORR) },
 	{ .compatible = "sifive,ccache0" },
 	{ /* end of table */ }
 };
@@ -210,11 +211,15 @@ static int __init sifive_ccache_init(void)
 	struct device_node *np;
 	struct resource res;
 	int i, rc, intr_num;
+	const struct of_device_id *match;
+	unsigned long broken_irqs;
 
-	np = of_find_matching_node(NULL, sifive_ccache_ids);
+	np = of_find_matching_node_and_match(NULL, sifive_ccache_ids, &match);
 	if (!np)
 		return -ENODEV;
 
+	broken_irqs = (uintptr_t)match->data;
+
 	if (of_address_to_resource(np, 0, &res)) {
 		rc = -ENODEV;
 		goto err_node_put;
@@ -240,6 +245,10 @@ static int __init sifive_ccache_init(void)
 
 	for (i = 0; i < intr_num; i++) {
 		g_irq[i] = irq_of_parse_and_map(np, i);
+
+		if (broken_irqs & BIT(i))
+			continue;
+
 		rc = request_irq(g_irq[i], ccache_int_handler, 0, "ccache_ecc",
 				 NULL);
 		if (rc) {
-- 
2.39.1

