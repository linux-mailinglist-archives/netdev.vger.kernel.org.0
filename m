Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60DBD6B53C2
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 23:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjCJWFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 17:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbjCJWEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 17:04:41 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB0526C3F
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 14:02:17 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id fm20-20020a05600c0c1400b003ead37e6588so7087204wmb.5
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 14:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678485736;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+zUn8pocVr2r//jTaSouyLBckQgozo/ZDRdK2pwrVA0=;
        b=pgl6i6qaK/haxczMMVcfdcZ5b+1c5e91jl0ikcWk5bgsz5iNpvYMa6+7NvzJejBCFz
         l8C62Ql3jjjmUDq8H3KIjw54M71OvXsYHeW4pfo+iI+2x1w3CG2jbc0l0vs0dDMJta/P
         wKV+FQUVgbEPe/9GLaq0tzv56vlu6XjDk2N9NLXfo+JFmiHESnbY3D6X5yPQFa4YLzvl
         EIOWwOkCSooo0kTezdti7qT/+SJKKejSH6ucUX4H8oFO4RhqAagBsKEWds+dhlDZzwvC
         AODeUOGWOyKc9W8IdiL3LhrMQ7LZgcxPMwB+QOhsbZ4h9kNhqUVFLzSWT4uo52sHgieH
         TRkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678485736;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+zUn8pocVr2r//jTaSouyLBckQgozo/ZDRdK2pwrVA0=;
        b=nJ3ofj4mGkFRF1sRUEw6wpch9eRs4avpDriHq3ZfzxffTJ76zNc5yBC67ac8EfUKij
         rwATQ3+DGRUq151jfYuRFRIuWlcBTd1EYZa132/1uB6gfcPPZiYY5s6p7qmqw1GgdT7O
         RMgpl8QgXgDxV3cctSK4GgH1boBPpwl77+IWPeYfRbeyBrFG7LCPgQioGixJeLam60rs
         8Ug+e6sPVf6zpNUtHbJ+RbvdYSGKoT1xFDYp/pIPDsdpxjhiyqg4+HfHswOfVRUnRTas
         iohggm83zcJyZU6sw/84JBj5i0J4NVOdSlzoVFF50US8kQ8idjlhufK7EtoHoVP5RPH+
         vfTA==
X-Gm-Message-State: AO0yUKUw7vuVG38FdU+yrB3369+B/5iYJKARkSdjkQxEotebJddBky5Q
        oNMvw/5YpjlTUSxp3subYbrBdhynvGdYjdiT+dU=
X-Google-Smtp-Source: AK7set9z+aZBSopwb5K37dZnsHY8LksXJaCSbHMf2DdGMdLvLsqY5zIox8FrR0zcO/9qVVkZepZBRA==
X-Received: by 2002:a17:907:6a8a:b0:90b:20bf:42cc with SMTP id ri10-20020a1709076a8a00b0090b20bf42ccmr28105595ejc.21.1678484806327;
        Fri, 10 Mar 2023 13:46:46 -0800 (PST)
Received: from krzk-bin.. ([2a02:810d:15c0:828:34:52e3:a77e:cac5])
        by smtp.gmail.com with ESMTPSA id t5-20020a50ab45000000b004bf7905559asm488088edc.44.2023.03.10.13.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 13:46:45 -0800 (PST)
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
Subject: [PATCH 3/5] net: marvell: pxa168_eth: drop of_match_ptr for ID table
Date:   Fri, 10 Mar 2023 22:46:30 +0100
Message-Id: <20230310214632.275648-3-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230310214632.275648-1-krzysztof.kozlowski@linaro.org>
References: <20230310214632.275648-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

The driver can match only via the DT table so the table should be always
used and the of_match_ptr does not have any sense (this also allows ACPI
matching via PRP0001, even though it is not relevant here).

  drivers/net/ethernet/marvell/pxa168_eth.c:1575:34: error: ‘pxa168_eth_of_match’ defined but not used [-Werror=unused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/net/ethernet/marvell/pxa168_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 87fff539d39d..d5691b6a2bc5 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1586,7 +1586,7 @@ static struct platform_driver pxa168_eth_driver = {
 	.suspend = pxa168_eth_suspend,
 	.driver = {
 		.name		= DRIVER_NAME,
-		.of_match_table	= of_match_ptr(pxa168_eth_of_match),
+		.of_match_table	= pxa168_eth_of_match,
 	},
 };
 
-- 
2.34.1

