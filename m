Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6986B538F
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 22:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbjCJV6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 16:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjCJV5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 16:57:45 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D911B14162F
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 13:54:31 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id a25so26370844edb.0
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 13:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678485252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mUBJvPnvYIjkmn4O8oZhEpaIiBhxp2RHHJ3TqWmbT9w=;
        b=heTpSUvmKKM7jEkS6R8ooYJUrQ68nrwYQqxyLSK1rSCaM1Bjwx9wV+JLDDrgEqSw+f
         PlhcDZsXDB/XKIOyHj792sbbeYNw323Eru6WryisyDCHE5yH5dv+mGUtWywmeOGDd/AG
         0eZ+bgrJxAqjheW9pGe6R8py+C3eO7VnsabPoPUk9BmvNmRCJzIc7FLGRO5/l/Cj6dIf
         4H5hzfPgrj71jzXS3vSp+3yDcsrsV4CCH2KYFoAijvYiaVoOvehxPgZo3JJ/RoSalvuE
         V0XsjMZbG/suFejcLiuTaigSQQx6MblxK8B/PVhKqGX50P1zOIS1rYXYfquMaMtUfCjl
         Xiow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678485252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mUBJvPnvYIjkmn4O8oZhEpaIiBhxp2RHHJ3TqWmbT9w=;
        b=Kqytaq30s02XgXartdBIgNjeI49DTKU0aP/naLGnIDZNIWf8r6ZlwlK7+VYgzspOEx
         HNJbmJqL9KqHvWj0c4RguWbvFZ8MujC+eoJ83/Q0x7zorjDn1Gpw/GoEpBLn7PNaD9kZ
         nlvKx/hYadRG4rmHK9zye/LKpE3MQJuzLw/Nxvgg73j7AQDZVqjdP6KqFojj0/8FYxuM
         zpB1D9yL9CgVu+RamhQZTN/0uG359e19wLvwd2WsSdDFdskELeWwJE6qm8ULxRt65ojV
         dsSDiovWXQc6cOKsVRNdI3+srTAB7X/eJXy3X24qfp3/iflUuHdYiyFXHqXja5BbnqPm
         MWew==
X-Gm-Message-State: AO0yUKXc9odwIqEbWJ+giBtiBacRum2KXxmgXp7XcgWfe7xczx6WRh1d
        hePJQ9+/S9lArW1quI/3uKxuSKfX3gS3qNMGeU4=
X-Google-Smtp-Source: AK7set9osGjpQrpxJegDF8sKXKCQx5GDmuDhzB67DU5cdXSBv9c2wl4JYEXcMCat4OxS1PxXgAHWcw==
X-Received: by 2002:a05:6402:1854:b0:4ac:b614:dd00 with SMTP id v20-20020a056402185400b004acb614dd00mr22252359edy.30.1678484804740;
        Fri, 10 Mar 2023 13:46:44 -0800 (PST)
Received: from krzk-bin.. ([2a02:810d:15c0:828:34:52e3:a77e:cac5])
        by smtp.gmail.com with ESMTPSA id t5-20020a50ab45000000b004bf7905559asm488088edc.44.2023.03.10.13.46.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 13:46:44 -0800 (PST)
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
Subject: [PATCH 2/5] net: stmmac: generic: drop of_match_ptr for ID table
Date:   Fri, 10 Mar 2023 22:46:29 +0100
Message-Id: <20230310214632.275648-2-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230310214632.275648-1-krzysztof.kozlowski@linaro.org>
References: <20230310214632.275648-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver can match only via the DT table so the table should be always
used and the of_match_ptr does not have any sense (this also allows ACPI
matching via PRP0001, even though it is not relevant here).

  drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c:72:34: error: ‘dwmac_generic_match’ defined but not used [-Werror=unused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c
index 5e731a72cce8..ef8f3a940938 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-generic.c
@@ -91,7 +91,7 @@ static struct platform_driver dwmac_generic_driver = {
 	.driver = {
 		.name           = STMMAC_RESOURCE_NAME,
 		.pm		= &stmmac_pltfr_pm_ops,
-		.of_match_table = of_match_ptr(dwmac_generic_match),
+		.of_match_table = dwmac_generic_match,
 	},
 };
 module_platform_driver(dwmac_generic_driver);
-- 
2.34.1

