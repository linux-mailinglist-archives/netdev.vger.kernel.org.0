Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE2C653332
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 16:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbiLUPZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 10:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234626AbiLUPZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 10:25:48 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA842DC5
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:45 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id d14so22402459edj.11
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fh+i7sl1pIQRS50o8+ESJqbTkr0TABVbPKqpvGqBGr8=;
        b=Fyz4WV+Qcjmsg/j0ljHqQmf9ASBggxmEprXdUABioB/YrkWMvXLyW92wARKEk7z5Sh
         PVmefH0BUZ2sLpnpZpjxUO6AcPh/xQIxz+nouiwurmLphKjOvq6jhs3O9ld2nGBof2Rg
         SO69IPSiiZBHiIaiU8wcRygLOh5Fgt1Fs4+oA4XRBBkr5TKZBBB7ox5obfwgx/7ZqhHs
         lRoM+7KKOELPyuJFI5uPs49DB979r4D2l3tXaHDCvG0JbAQGEQO72NXSxiCY0G+UWwV3
         ynSHEdQ/dn03Ooy4Bw5IntDOfXNjqQf7OD7Sk3mwzFnxyFnFRV1xZE/LbdbbfBl/dZWr
         sGEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fh+i7sl1pIQRS50o8+ESJqbTkr0TABVbPKqpvGqBGr8=;
        b=xGRtsQzgwz1lyKCteOazLR37t5dBcHqXrPnBjofcJ60OWNAt07rJiAkGP8WNA5HP+2
         S2chRuTTu30MqPWsNuPcDrk+RMFwvA9iN+64OdqIVweuBTGkYU0ObqLWVovOkIwikDyk
         An1dqHyEDtil8qfwZa8thhP/MjMJsaxUYwx3julUyDRG45+DXhCOv7rQ9T2hm3VIuaD+
         ROfWWWqQHtoQWE6SOVtPbN95Fydpm0v+u+PQ6jgqMIe66H8PD8SaN29eONAQjhKF8xJQ
         TQ1paBoMXGMm0xf5ba/1EqPRvDz1MHCzM8kdhxXe/btF32Bm+FXDjLbcZ9Y64C97EogA
         Rf+Q==
X-Gm-Message-State: AFqh2koBq28cryDnZJn2aUhXQNy2zQTu+2NLEKaVefoHReKz1RUJzHWF
        Gg6c7MPMy9W73MDvtMAuu3wr3Q==
X-Google-Smtp-Source: AMrXdXts5VqcxXBejx6ArtwFQxv/ElIJnhO2KyvgLGbQ6gFXYM0JNTN7d58wNZ8U91NzFMvCTRgdlA==
X-Received: by 2002:a05:6402:1f15:b0:46c:e2f1:3a81 with SMTP id b21-20020a0564021f1500b0046ce2f13a81mr1815011edb.37.1671636344513;
        Wed, 21 Dec 2022 07:25:44 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a245:805c:8713:84e4:2a9e:cbe8])
        by smtp.gmail.com with ESMTPSA id n19-20020aa7c793000000b0045cf4f72b04sm7105428eds.94.2022.12.21.07.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Dec 2022 07:25:44 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH 04/18] can: m_can: Always acknowledge all interrupts
Date:   Wed, 21 Dec 2022 16:25:23 +0100
Message-Id: <20221221152537.751564-5-msp@baylibre.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221221152537.751564-1-msp@baylibre.com>
References: <20221221152537.751564-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code already exits the function on !ir before this condition. No
need to check again if anything is set as IR_ALL_INT is 0xffffffff.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index a43abc667757..4b387403a7c7 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1073,8 +1073,7 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 		return IRQ_NONE;
 
 	/* ACK all irqs */
-	if (ir & IR_ALL_INT)
-		m_can_write(cdev, M_CAN_IR, ir);
+	m_can_write(cdev, M_CAN_IR, ir);
 
 	if (cdev->ops->clear_interrupts)
 		cdev->ops->clear_interrupts(cdev);
-- 
2.38.1

