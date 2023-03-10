Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3925B6B5367
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 22:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbjCJVvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 16:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbjCJVun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 16:50:43 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9E713EBB1
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 13:47:50 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id x3so26034243edb.10
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 13:47:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678484797;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SeJX9lSGwZbRGOASyeKJInBHWHmDyRL8Oo8/OupUB9Q=;
        b=I4VhGR8BarZ8ZUC/EPGtBWoticWk4MDuo0tG3Tg1iNkyklQ2Ur0SuiqcPODtE2eMBf
         PyeDV5OcJpdUHGd0wHSGqBEZB7YeXs9mEOxD3htiyMPdbfO2dAPkaOJsB+Kr6WWn9Z2s
         8Jl4R5WOgnBRXbpBKvAa0kEOAHXE9/7qfcblWSrM0YZbuJi6EqOK4NitnHKNs4cC+3/4
         7hjMaA4G9lfyHpVebanLvVFUMkYNajOyIg6C33wTk/rGYaR+zfx5s9neSPUZ4CrX7w9a
         8o+Mdt+mzzNn7Cvv4pxDZHRchsZWOOmGTSFXDGk/q8Jrf3q/9lsgLKvERaYG9NyaLVKc
         vB1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678484797;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SeJX9lSGwZbRGOASyeKJInBHWHmDyRL8Oo8/OupUB9Q=;
        b=L/ybQEwcC4/DhxbINPk1P0tI7fIdQ/6UWb4ryDhgX/GH2/VG0s74bUSmVmHEbyV3dW
         UMLuPOWOkhm+6xCQuZNr0DEdIzYp3T9hTvWlmWknGEhR2H0NcS17NdZnIof9nrRahYJB
         xQjNHgs8b7vDbh/EmOr21YqHxCHCe5vXAww2I/3yTH/NoDeDxZWJdsAyjFQjStoyRzh+
         CQSEWPSTnesxeYxq31mNj5H8nHUpv3XufgI0QT/nVwA+McRv+JnMR7N4Ljnu9/kZ0OG1
         YemYeo6z0epCFxlio7/s2qZH02sfdtR0+0e5oXeiLL9ZtEnfw4F9Sy5RrlWcGt2owzsL
         VqoQ==
X-Gm-Message-State: AO0yUKV1qC6lR1UsrV7Fz7oZ8Nh8XT1mbzDsXqqRcphCAPqAkU/R+f5O
        h9BEjw9lkyBoQzFII/ZcH29MHw==
X-Google-Smtp-Source: AK7set+fefzslhk3HVdoFlRZdjEzX/BPXogkmHteV4hEH093tDdyyFmRA7z+gYHRC6c1yXWYakLf5g==
X-Received: by 2002:a05:6402:1608:b0:4bf:da1a:2be3 with SMTP id f8-20020a056402160800b004bfda1a2be3mr22977290edv.34.1678484796905;
        Fri, 10 Mar 2023 13:46:36 -0800 (PST)
Received: from krzk-bin.. ([2a02:810d:15c0:828:34:52e3:a77e:cac5])
        by smtp.gmail.com with ESMTPSA id t5-20020a50ab45000000b004bf7905559asm488088edc.44.2023.03.10.13.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 13:46:36 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Byungho An <bh74.an@samsung.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Vinod Koul <vkoul@kernel.org>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 1/5] net: stmmac: qcom: drop of_match_ptr for ID table
Date:   Fri, 10 Mar 2023 22:46:28 +0100
Message-Id: <20230310214632.275648-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver is specific to ARCH_QCOM which depends on OF thus the driver
is OF-only.  Its of_device_id table is built unconditionally, thus
of_match_ptr() for ID table does not make sense.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index 732774645c1a..32763566c214 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -606,7 +606,7 @@ static struct platform_driver qcom_ethqos_driver = {
 	.driver = {
 		.name           = "qcom-ethqos",
 		.pm		= &stmmac_pltfr_pm_ops,
-		.of_match_table = of_match_ptr(qcom_ethqos_match),
+		.of_match_table = qcom_ethqos_match,
 	},
 };
 module_platform_driver(qcom_ethqos_driver);
-- 
2.34.1

