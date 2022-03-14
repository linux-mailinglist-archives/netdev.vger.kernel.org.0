Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDEF4D7AC9
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 07:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236381AbiCNG1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 02:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233876AbiCNG1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 02:27:50 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E54AE74;
        Sun, 13 Mar 2022 23:26:41 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id s42so13441556pfg.0;
        Sun, 13 Mar 2022 23:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gPdLMfy6QoT4orL1LQVjkJuCG3Mn4Mwk6fwg0e7ckFI=;
        b=IFKvjAGyOf+bU5q8n8Aj+WsQhdxJH0Nxq/8sxO836Z98Sz0hCRerbOPZ3Rs0V6xAU/
         lKUrjRNnuBJSzfDSrF128Fo+97j95cmF1ogp7/8PaYynmR6lh3eCRtVYfWfR+7VPwc9s
         l8GqjKKf/PG1Sl6lLDn/9SJqvaSgxTpf41NqZ/m5VPDpd4Wwl197WSMqdsRvgyacHSc7
         vz7jA4BUE5+EKUmRD5ijQMqnyRREUP5wGCf1AhpQPchxOedqvR5SCuNDosnaJ0sEr1ZG
         WFjUKUcsp7dLHDSReovMWYriYcuL7NhD9czMY+dw/WJom7Kpe4EHhgm5inbw5jRzpfvN
         znXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gPdLMfy6QoT4orL1LQVjkJuCG3Mn4Mwk6fwg0e7ckFI=;
        b=5+LZQClODQxYMObpeMwaSeWwAJxiHd75hHB1Qj3SoO6l3OiCehwJfjQpv4B62wGMrb
         KeOJUTP16LnFPE5Hutkz4TUWarVhvlo3+6PxZPdRRd1KaQHJZgi8eI0I+QAT93P3+H03
         v2sjFaOqxCD7I6K3DTwskdX49m3Bn+zkjXig1iGUi84cuwApOsalhMFbt9EQANWVw6h8
         2uHkJLu+ZhPw2+K4ZEtRIYj/66fDBDb88jLhUIIBo718cBdyTvBW1tc+6RwTy94yqVmL
         gqS2wN6kiZRTLEsCLeoAyEc3ov4mlbLjfAEbth/FvUDqG3CV/PZSz63J7WNrL/OQAYQ5
         rjLA==
X-Gm-Message-State: AOAM533awxZjWbz7fXlkyciVa6Px7JKRb4dKxEVFaq5/8Z8DJWXo4cI8
        Z5f6g+rH56PhB1RL4q2M7M7F+C43XZo=
X-Google-Smtp-Source: ABdhPJzQcrRnTCzRDHm1h7hFHwrahKQiDk+VXWO9lNefAaPWuo0pxeetewBGcxoC3JtyF+8so8NvJg==
X-Received: by 2002:a63:8ac8:0:b0:37f:fcfb:6886 with SMTP id y191-20020a638ac8000000b0037ffcfb6886mr18720834pgd.466.1647239200868;
        Sun, 13 Mar 2022 23:26:40 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id nk11-20020a17090b194b00b001beed2f1046sm19336423pjb.28.2022.03.13.23.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Mar 2022 23:26:40 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     toke@toke.dk
Cc:     kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH V2] ath9k: Use platform_get_irq() to get the interrupt
Date:   Mon, 14 Mar 2022 06:26:35 +0000
Message-Id: <20220314062635.2113747-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

It is not recommened to use platform_get_resource(pdev, IORESOURCE_IRQ)
for requesting IRQ's resources any more, as they can be not ready yet in
case of DT-booting.

platform_get_irq() instead is a recommended way for getting IRQ even if
it was not retrieved earlier.

It also makes code simpler because we're getting "int" value right away
and no conversion from resource to int is required.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
v1->v2:
  - Retain dev_err() call on failure

 drivers/net/wireless/ath/ath9k/ahb.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index cdefb8e2daf1..28c45002c115 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -98,14 +98,12 @@ static int ath_ahb_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (res == NULL) {
+	irq = platform_get_resource(pdev, 0);
+	if (irq < 0) {
 		dev_err(&pdev->dev, "no IRQ resource found\n");
-		return -ENXIO;
+		return irq;
 	}
 
-	irq = res->start;
-
 	ath9k_fill_chanctx_ops();
 	hw = ieee80211_alloc_hw(sizeof(struct ath_softc), &ath9k_ops);
 	if (hw == NULL) {
-- 
2.25.1

