Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA114D7AEA
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 07:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236450AbiCNGqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 02:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiCNGqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 02:46:20 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8373CFF3;
        Sun, 13 Mar 2022 23:45:11 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n2so12722241plf.4;
        Sun, 13 Mar 2022 23:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HwGDi1sVfgM6vEwjYmQWuo614yIWTc+TjSIxyxAMlAA=;
        b=OFglV4YNTV4B9RvfWrcOyp9Ky6jz7gYFN7V7XkdY05sSHo7bTVSZDN3d19BzcABKaH
         YRxwvKCbXXsxHsJshYEh8PshhCQ7REiQ1N7UUe1p/YJphK3FRhTOiEqS4hXeNTjlVQfa
         K4fIgWVNKaSRMM/FxdX4Thgz1rjs/StrkDfB3M3GOKCcRnMY5GgvkBLOA+Qrrs5kaoRP
         8a4JmdyOpGlPlpUGr/TpkhYUfJK4DuWGRkE5q8J0U7DwzKDAR7mCySxnMbM031pn2sMz
         g6l1r3u0LizvyiBt0JBJ0vtCkl8p4QxbuelD5GNKSaNSq6KzSlMj78Wm8VZunw78bYux
         AfHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HwGDi1sVfgM6vEwjYmQWuo614yIWTc+TjSIxyxAMlAA=;
        b=178e+uDxVbCOZCQP/vgakmLnZqbTgxLz/jpHi6xDfJg+VbGLtVFfSKHXt98Ej2o4Dt
         qMzeRMJBOLyqNDZZgkiTx+s8E1dZLmAlGFfZxya3jl0YDEjCosgxhPfbEt5PMK1Cmnpy
         QbHg6zJiI/L1aSebmDWOtQ3WDHT4DnTo45NW5+MVd0d7ZGhAaFfoi9E5OJUBXQsF6bnC
         R211d8HnMjkIVjA+gLOEfPwv2x7DHkXFUWdtu3oJj+WK6nv1DtnqWM5uyhmvoL+MVlgc
         lxSiS5L3NZ6yxldpTjlCBv9GyzbPcTeJUEuhUTsI3toTBDUDeeKVxF+Rxdm9p+zvJrxn
         6D4g==
X-Gm-Message-State: AOAM532NIBFZWmebqqz7mUE5vmujEv8Rly9TEtzu700y/Dv7ZKjr+Ov7
        G+96Ca0fspI1yyLOKOwDPHs=
X-Google-Smtp-Source: ABdhPJx/JtpuTG5tp1CzzSrpghu2Tp9YzGYf8rw4hriJbh8ezMW/YgFFEn7thGrGtrX7buLcrYgEDA==
X-Received: by 2002:a17:902:6903:b0:151:6781:9397 with SMTP id j3-20020a170902690300b0015167819397mr22502299plk.137.1647240311126;
        Sun, 13 Mar 2022 23:45:11 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id u18-20020a056a00099200b004f737cdd046sm20342127pfg.145.2022.03.13.23.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Mar 2022 23:45:10 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     toke@toke.dk
Cc:     kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH V2] ath9k: Use platform_get_irq() to get the interrupt
Date:   Mon, 14 Mar 2022 06:45:01 +0000
Message-Id: <20220314064501.2114002-1-chi.minghao@zte.com.cn>
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
index cdefb8e2daf1..c9b853af41d1 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -98,14 +98,12 @@ static int ath_ahb_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (res == NULL) {
+	irq = platform_get_irq(pdev, 0);
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

