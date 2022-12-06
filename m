Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8806442A5
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 12:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbiLFL5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 06:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235109AbiLFL5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 06:57:40 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088C36596
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 03:57:39 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id n21so5553668ejb.9
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 03:57:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fPY/i2W9DO4EoXlKXBgjR2RaogZYXbKp1PtuK+1K7lo=;
        b=lHue8XX3/w6oT10x3GOfSeKr/cEhp3RW+YOtl/a9x3yzg+YxzZu2POfZyEOPevFKpg
         RY3eovz4dJzdelqPaW9ezwc5ctZZ3YdDh2UT3juvKIubGKwaSZ3J0FtyBtFPWQiv1Drl
         VlzLIN589cuDcToWTH/Dl5+8Y9mZXD9nwa7gHqld/aSVEDKcEU799r8Du8LzTHkQ11KK
         UeVt3EG3B2/EdKldT/clXPZh4ZVmLYXfJtLCFMeUJM5Kc+EePKo5xLmBzS0o9v75I+cC
         Iypdn4hRgvQLcMQ7D2r83jh6oCYk4ORN5SuhLHw7MFEgXyeZdOHlbIOz0xI58esuPp0F
         2bbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fPY/i2W9DO4EoXlKXBgjR2RaogZYXbKp1PtuK+1K7lo=;
        b=pRvCMSxfBf5yxPJUwwR8kU8JHxhaXAm/r12p3+4Q2iL0MUU2ubAes9IC84jGhs/Dko
         aTIZ+rPY6cAfBHbVpZbexEoNK1Xh1zHsD+nXZWnFVYFr4WrlLSJbNZVRYyUQfwQu3AKY
         heAE2QXFqUmAbR2w6/4vZLXh/z08rKviH8SyGxVP/yt1TQAn1HeaIp99rC/WsNih0mGd
         dNbjRYxL39HO0X5ZK2zHJdYbvMyHXwlnDbqah1imaJBWvapr+SLUPFYKiRlIHJj3elE0
         4F74+dwBras/oTXb78CQ4mbtPx6zFATq3cmtKE7z4VT9alRzQqjIqN5Fpy3spIXmyIaC
         rgmg==
X-Gm-Message-State: ANoB5pmC1smO8USMwzWidtF2pox783OTbpR5wT2OzcHADelHKJb07YGr
        skDcUndejbuuXNoD3wL1cqiz/Q==
X-Google-Smtp-Source: AA0mqf7xsb8tS6Ea0DlvvR6lLe4tw1gGV4xlvBn6EzLzPGCKm16uB7/45j/fxJ1XrHQfNT5a29sGNA==
X-Received: by 2002:a17:906:48d6:b0:7c1:b67:6a28 with SMTP id d22-20020a17090648d600b007c10b676a28mr2000190ejt.2.1670327857491;
        Tue, 06 Dec 2022 03:57:37 -0800 (PST)
Received: from blmsp.fritz.box ([2001:4091:a245:805c:8713:84e4:2a9e:cbe8])
        by smtp.gmail.com with ESMTPSA id ky20-20020a170907779400b007c0ac4e6b6esm6472076ejc.143.2022.12.06.03.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 03:57:37 -0800 (PST)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH v2 02/11] can: m_can: Avoid reading irqstatus twice
Date:   Tue,  6 Dec 2022 12:57:19 +0100
Message-Id: <20221206115728.1056014-3-msp@baylibre.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221206115728.1056014-1-msp@baylibre.com>
References: <20221206115728.1056014-1-msp@baylibre.com>
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

For peripheral devices the m_can_rx_handler is called directly after
setting cdev->irqstatus. This means we don't have to read the irqstatus
again in m_can_rx_handler. Avoid this by adding a parameter that is
false for direct calls.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 0cc0abde9b1d..d30afbb3503b 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -895,14 +895,13 @@ static int m_can_handle_bus_errors(struct net_device *dev, u32 irqstatus,
 	return work_done;
 }
 
-static int m_can_rx_handler(struct net_device *dev, int quota)
+static int m_can_rx_handler(struct net_device *dev, int quota, u32 irqstatus)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	int rx_work_or_err;
 	int work_done = 0;
-	u32 irqstatus, psr;
+	u32 psr;
 
-	irqstatus = cdev->irqstatus | m_can_read(cdev, M_CAN_IR);
 	if (!irqstatus)
 		goto end;
 
@@ -946,12 +945,12 @@ static int m_can_rx_handler(struct net_device *dev, int quota)
 	return work_done;
 }
 
-static int m_can_rx_peripheral(struct net_device *dev)
+static int m_can_rx_peripheral(struct net_device *dev, u32 irqstatus)
 {
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	int work_done;
 
-	work_done = m_can_rx_handler(dev, NAPI_POLL_WEIGHT);
+	work_done = m_can_rx_handler(dev, NAPI_POLL_WEIGHT, irqstatus);
 
 	/* Don't re-enable interrupts if the driver had a fatal error
 	 * (e.g., FIFO read failure).
@@ -967,8 +966,11 @@ static int m_can_poll(struct napi_struct *napi, int quota)
 	struct net_device *dev = napi->dev;
 	struct m_can_classdev *cdev = netdev_priv(dev);
 	int work_done;
+	u32 irqstatus;
+
+	irqstatus = cdev->irqstatus | m_can_read(cdev, M_CAN_IR);
 
-	work_done = m_can_rx_handler(dev, quota);
+	work_done = m_can_rx_handler(dev, quota, irqstatus);
 
 	/* Don't re-enable interrupts if the driver had a fatal error
 	 * (e.g., FIFO read failure).
@@ -1078,7 +1080,7 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 		m_can_disable_all_interrupts(cdev);
 		if (!cdev->is_peripheral)
 			napi_schedule(&cdev->napi);
-		else if (m_can_rx_peripheral(dev) < 0)
+		else if (m_can_rx_peripheral(dev, ir) < 0)
 			goto out_fail;
 	}
 
-- 
2.38.1

