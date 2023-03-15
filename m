Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA5DD6BAEA1
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 12:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbjCOLHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 07:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbjCOLGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 07:06:44 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C375585A71
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:06:35 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id l7-20020a05600c1d0700b003eb5e6d906bso899334wms.5
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112; t=1678878394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ZThZMgUyn2/5ZBEZWr8O3JON+m0nr5Da03HtR+hrv4=;
        b=1jJdQZBohfY1QzhcZD2so0Dyo46RuqJL5F0a2JAIJmVw9FKiwNSCajBvzLErI/1v4J
         HUWjs90pw38xxhs5Dla/ic9E1QRCaovsRxKxkf7kKfeO5qE/O8h1R3nkbdJFv61ZaEqd
         Zb9lMQL3RLUuauMISsE8ruR+WuZWJV7Uu9PXyOi9er+qIQWWJ1K3VjVp9W8P4dBKCQ1Q
         GtAgjTQs7kmcDpmudifb6FmqcorCzYCdMvABjk1ZPygPtXcd2prhgWwzRTMSSHb+lysq
         J0GT4ToJcATAXE+CGdzBsoCKJTfNng6cYc57GMXImCKFEIY8whIVYP7A4rAYfZjDLIuQ
         IoTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678878394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+ZThZMgUyn2/5ZBEZWr8O3JON+m0nr5Da03HtR+hrv4=;
        b=OnkmYGG/RclT2nGb8rcMoZz72oZfPu5TB4Y4GuEDk1wltefKfzCEDsbH79lafFR6OE
         89YgetjBvr/lxzNOsjD3R0viXKS8YRvyVOgs6aBvf4fXCNXYh0u0liPLyw8mCwoLZ4zq
         b0MFMSqiAj2KjF9qMor9xhKNUfuyoWVx4lc2Jk8DCv2mJbYaeTqhafQcLUDyjy9lMbj1
         aNEzs3wv4B6rTOf7AwkYbIbDnbaYPMR686Tff8RZTNNYp0K37RbwEJlnFfj+SpZmYfbS
         DJjn/Vth6y6HYeibtAx0MsUPPelY2kRSTvjk0OF5lVXiAsy2krz6VoUDjm/6TlpHIylP
         MPHg==
X-Gm-Message-State: AO0yUKUuBy8ekAJ06qMTHj13pLU8PL9g073Z2qo716IixfLszn41SCJw
        YFMsJ4rD8OpciVCw5hxBg+1frw==
X-Google-Smtp-Source: AK7set8QAtooi3inV7eJ09p4r+w6n5rKshX1d2FJ7PxCjdVn8J5aHy+k0idi85WlYXM3mU8/QttPAQ==
X-Received: by 2002:a05:600c:190c:b0:3eb:38e6:f65d with SMTP id j12-20020a05600c190c00b003eb38e6f65dmr17284068wmq.11.1678878394397;
        Wed, 15 Mar 2023 04:06:34 -0700 (PDT)
Received: from blmsp.fritz.box ([2001:4090:a247:8056:be7d:83e:a6a5:4659])
        by smtp.gmail.com with ESMTPSA id l4-20020a7bc444000000b003eafc47eb09sm1460563wmi.43.2023.03.15.04.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 04:06:34 -0700 (PDT)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Simon Horman <simon.horman@corigine.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH v3 11/16] can: m_can: Cache tx putidx
Date:   Wed, 15 Mar 2023 12:05:41 +0100
Message-Id: <20230315110546.2518305-12-msp@baylibre.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315110546.2518305-1-msp@baylibre.com>
References: <20230315110546.2518305-1-msp@baylibre.com>
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

m_can_tx_handler is the only place where data is written to the tx fifo.
We can calculate the putidx in the driver code here to avoid the
dependency on the txfqs register.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 8 +++++++-
 drivers/net/can/m_can/m_can.h | 3 +++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 4e794166664a..d5bcce948d2c 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1475,6 +1475,10 @@ static int m_can_start(struct net_device *dev)
 
 	m_can_enable_all_interrupts(cdev);
 
+	if (cdev->version > 30)
+		cdev->tx_fifo_putidx = FIELD_GET(TXFQS_TFQPI_MASK,
+						 m_can_read(cdev, M_CAN_TXFQS));
+
 	return 0;
 }
 
@@ -1765,7 +1769,7 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 		}
 
 		/* get put index for frame */
-		putidx = FIELD_GET(TXFQS_TFQPI_MASK, txfqs);
+		putidx = cdev->tx_fifo_putidx;
 
 		/* Construct DLC Field, with CAN-FD configuration.
 		 * Use the put index of the fifo as the message marker,
@@ -1798,6 +1802,8 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 
 		/* Enable TX FIFO element to start transfer  */
 		m_can_write(cdev, M_CAN_TXBAR, (1 << putidx));
+		cdev->tx_fifo_putidx = (++cdev->tx_fifo_putidx >= cdev->can.echo_skb_max ?
+					0 : cdev->tx_fifo_putidx);
 
 		/* stop network queue if fifo full */
 		if (m_can_tx_fifo_full(cdev) ||
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index d0c21eddb6ec..548ae908ac4e 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -102,6 +102,9 @@ struct m_can_classdev {
 	u32 tx_max_coalesced_frames_irq;
 	u32 tx_coalesce_usecs_irq;
 
+	// Store this internally to avoid fetch delays on peripheral chips
+	int tx_fifo_putidx;
+
 	struct mram_cfg mcfg[MRAM_CFG_NUM];
 };
 
-- 
2.39.2

