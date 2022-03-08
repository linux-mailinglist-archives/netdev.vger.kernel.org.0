Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63134D106E
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 07:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244931AbiCHGoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 01:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232815AbiCHGoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 01:44:11 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C026313D03;
        Mon,  7 Mar 2022 22:43:15 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id iv12so12486566qvb.6;
        Mon, 07 Mar 2022 22:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hbbtVtfgY5XvdgyEKM2lyoXP1CHPb/nDUKbxx1lHKqY=;
        b=PQKF+49Ik9bxA8mSEa5sexJObC41jR0DWC11DO7tn3XGbhMqXnFnY4C3udmd31Spry
         DWGVqeCMIauYpJOF2m20RELKoyWV+VU4pOZXEh7W7V6Rvk+e5mJuScNU/JBYmqBZ14ye
         3q986RDDnGOfL8+3SSGWoTtDnnGiKB3n355Qn5BuNsk6FuH/4AS4GISpzvjQ3owNbfqZ
         VohcbU6h8avOn8lC7Qta7rMphoUI7cqP0bUVel8INNLNjrm2EIUGz7F9BYnrYkAi4KT5
         p+iaDY1K6P36UPuCiqqYlr2qCBuFNhHgMFNN+FmC52OtFsaQEhiLJSKxZeUNM3/i6hz6
         nr+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hbbtVtfgY5XvdgyEKM2lyoXP1CHPb/nDUKbxx1lHKqY=;
        b=kx0uvTQsdwP9bdtZh7Q0GogJFAgHXOkgBEn7FpjeZzF6WKp5CTibU5fkot9UL5FAcf
         7tvp3UDQrHWsa5Jk+zIwmeJJ7HThQTtxYvGKi7Jk0zOZrfXxOjXmcF0lCT8E85XDO8Kw
         OGiC7wsvwFoSidiZGZYQYRzKmn0pjoKI/mu/OpGfZm46PAYFteOUzZ76Z/p4n7i+MiEE
         kcE+C1RNlcyeKUk+tQO3HfnL+BYenm5dYrmcD2orrcfFZYk+bzsbJSTpqN/Mpx2aqnsB
         kIw6ekX4gUz6GK6mnbbG96r7ziS1DO0QG04T/ITzW8KEfsL/kg2HuzDGIUL+CCvQZVsv
         NuOg==
X-Gm-Message-State: AOAM531w9g/bQ6z7eRxhyOfL4cllqt1kSjqX67XNcTIRYNEDWZpc/fYC
        7hqqbiDzmXtpqjuhU5m/+Ns=
X-Google-Smtp-Source: ABdhPJxDX6+XAizbu2jewMgsBNvkmFC30QfQfnvgP7RQknBQ6Vfr6ZHV/TpqKUgihlcx00a000vxyA==
X-Received: by 2002:a05:6214:5297:b0:435:7a09:1eb9 with SMTP id kj23-20020a056214529700b004357a091eb9mr8186496qvb.127.1646721794954;
        Mon, 07 Mar 2022 22:43:14 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id l13-20020a37a20d000000b0067d17b656acsm463030qke.78.2022.03.07.22.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 22:43:14 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net:mcf8390: Use platform_get_irq() to get the interrupt
Date:   Tue,  8 Mar 2022 06:43:09 +0000
Message-Id: <20220308064309.2078172-1-chi.minghao@zte.com.cn>
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

From: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>

It is not recommened to use platform_get_resource(pdev, IORESOURCE_IRQ)
for requesting IRQ's resources any more, as they can be not ready yet in
case of DT-booting.

platform_get_irq() instead is a recommended way for getting IRQ even if
it was not retrieved earlier.

It also makes code simpler because we're getting "int" value right away
and no conversion from resource to int is required.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
---
 drivers/net/ethernet/8390/mcf8390.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/8390/mcf8390.c b/drivers/net/ethernet/8390/mcf8390.c
index e320cccba61a..90cd7bdf06f5 100644
--- a/drivers/net/ethernet/8390/mcf8390.c
+++ b/drivers/net/ethernet/8390/mcf8390.c
@@ -405,12 +405,12 @@ static int mcf8390_init(struct net_device *dev)
 static int mcf8390_probe(struct platform_device *pdev)
 {
 	struct net_device *dev;
-	struct resource *mem, *irq;
+	struct resource *mem;
 	resource_size_t msize;
-	int ret;
+	int ret, irq;
 
-	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (irq == NULL) {
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
 		dev_err(&pdev->dev, "no IRQ specified?\n");
 		return -ENXIO;
 	}
@@ -433,7 +433,7 @@ static int mcf8390_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	platform_set_drvdata(pdev, dev);
 
-	dev->irq = irq->start;
+	dev->irq = irq;
 	dev->base_addr = mem->start;
 
 	ret = mcf8390_init(dev);
-- 
2.25.1

