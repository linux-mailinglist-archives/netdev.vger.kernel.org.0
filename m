Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360274D287C
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 06:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiCIFg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 00:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiCIFg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 00:36:27 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CCA149966;
        Tue,  8 Mar 2022 21:35:29 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id eq14so1221448qvb.3;
        Tue, 08 Mar 2022 21:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rMWVx69slUxdMBkJoGlbP/cK/UUy/WgqXolJWODJNJI=;
        b=miIJeeXOZ26m9nKSOMODNuWEJlRXmuLyA/KvDD4RXVBQOm8Z+vCp8rzaJRn3vW6riC
         SEOFY0J8Dgj+aDuuDujfZDB19Ajpj0ADIEeOxscBKWRVvmKvp6+hMBEXHqrBAoqoUkmy
         WDYQAags5fzS5LSneH366PXjLGCZrW4+YtmXHf28huTZ54sew8cp3tszf5XJ2OUZRDBS
         HPQ0Ho31deurJQ4jNeKa8sQeyRMnl9RLaki5ImfxQMfTztfA5hFjBLSSiEFHingfrvpt
         6HgKRmQ4/sxo8To8D/t920McfJR28HPHmruWNeCOx+vAfGsTsoU6UwRcTssmMjMA+J6A
         FaSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rMWVx69slUxdMBkJoGlbP/cK/UUy/WgqXolJWODJNJI=;
        b=M7K21nBioiW8gIeBn9ymWIdcyxNrtHMFTh+DZCwYK2w3GJQyhbkLYE6HvU9WLQ7Gtt
         7F5B1Egt+5bR/zLWVLNrZMjiaOsY+VOthGcrAaQLt+XmFHpSAj/fkQO9kVykbyQfVIS8
         7I2ZiEjN51Dnzd9QM6z4xeLwxWaEahhyr2fHTRjmGzWztrz8ajiCIS6HBpYWdS6ZHbcp
         eLTTdCyKILS5Z3dUKkCH6GWpT9wzZq1q7cqXGTBVOLinkgr/NxIXC0SODWhyfZQDIvxz
         p0EPBzoigxvSk8qxVq3sSevn2536q9r63vVInx0Y0VOZUJNDQCw5Ca/Sbh2h5RRVM2sT
         mPuA==
X-Gm-Message-State: AOAM530LVhF7VvgAmcfpWmHxfZtyFFXJuBp+0COddrN8RSdlTZ38JvvV
        rxdpTpuotRSv7oPcG7rReuE=
X-Google-Smtp-Source: ABdhPJys2RVmbyGtcByT+knJyfG1+0rR2k3s0/w0elWwfRFqaZJS7ZKELcfQNn229emZmY4GjiJtnQ==
X-Received: by 2002:a0c:d692:0:b0:432:3605:6192 with SMTP id k18-20020a0cd692000000b0043236056192mr14965909qvi.90.1646804128279;
        Tue, 08 Mar 2022 21:35:28 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id 186-20020a370cc3000000b0067d36e3481dsm302648qkm.17.2022.03.08.21.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 21:35:27 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     toke@toke.dk
Cc:     kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] ath9k: Use platform_get_irq() to get the interrupt
Date:   Wed,  9 Mar 2022 05:35:21 +0000
Message-Id: <20220309053521.2081129-1-chi.minghao@zte.com.cn>
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
 drivers/net/wireless/ath/ath9k/ahb.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index cdefb8e2daf1..9cd12b20b18d 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -98,13 +98,9 @@ static int ath_ahb_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "no IRQ resource found\n");
-		return -ENXIO;
-	}
-
-	irq = res->start;
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
 
 	ath9k_fill_chanctx_ops();
 	hw = ieee80211_alloc_hw(sizeof(struct ath_softc), &ath9k_ops);
-- 
2.25.1

