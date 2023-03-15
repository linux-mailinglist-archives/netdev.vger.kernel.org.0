Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8322A6BAE87
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 12:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbjCOLGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 07:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbjCOLGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 07:06:38 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD73981CCE
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:06:30 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id p13-20020a05600c358d00b003ed346d4522so676869wmq.2
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112; t=1678878389;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YFt4bxPMCgWg0M7+jSOYYgnyoXJC6PqUm+WV19TP9H4=;
        b=osaePjHp3RUs+eN/4I1mDejB79EY61Itw7Y16r9hbWxfv60LpNsBSXMxYcff1nEF1c
         H8D8bgR4ayHvgrZI3fTPQ2JyhzgVCW4VnvK3AgPtvJwaay44H7tBzD6tFtb7YkgaAKWk
         hsZRE+xijpqBCm7nXKZOhdL241g749MaTKmbjyWkKm2waIJ9+JK8KYDSzWbbgHdQ1xqQ
         YftE5KtMuine9O4ukfkBRPqc18/jrD7DcDn8gkLMYw5oc8QZz5DY/xiCYDVyUmAlHUx3
         5KYJzKnbbrDptDcsUgpq920v8ulCVVxnhqLaULtjbge8DyJ9u/pYL4e0/v2HdJTlLR/b
         rqeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678878389;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YFt4bxPMCgWg0M7+jSOYYgnyoXJC6PqUm+WV19TP9H4=;
        b=O6JLJvbFVZdMZkyGvxXwSwBVyfslmaThEVpB+80mAZIrPxYQpLQy6uMc4UvFFrve0j
         YMvXxkm93AlQL9VgnLS+lGzpxNflxTSKD5sdfs2eoVW3GHfuy7XpZb09IaQa7udk4Tvo
         6aUBl+YQFjR8WyBRpITD+7pbHZmdjQ8J0AX5FS+/+0DijPE4uf/JsmBXmCQEhWb83+Ny
         DFcxrT8O2yHiS3gH7VAl4EoVRhAA+WhQcjHRJKTBdnY595HvklGnYbj2RQlJeQQfgXTN
         Pmwa9ewDEpbWSHVl33M1gOnpX3OIpWSXvA4fNak2mcPbZSlZ9HHCJXRY4lUSUHu9YHH5
         xZUg==
X-Gm-Message-State: AO0yUKWx9z04ahez2c0YuqxqmScYKCSiRN5Lw22F7VLn0YYrk3xylMNv
        7a9qnq8n/Z4Ta4W2oYMhPAuNJw==
X-Google-Smtp-Source: AK7set9SrrVIO5Tr5u+pitVvtYokI1zVZagd2UZW/FYEt80ZOdbt76dQ6LjaMH2+a6Vdbv1k+akbow==
X-Received: by 2002:a05:600c:3595:b0:3ed:2a91:3bc9 with SMTP id p21-20020a05600c359500b003ed2a913bc9mr6268192wmq.15.1678878389346;
        Wed, 15 Mar 2023 04:06:29 -0700 (PDT)
Received: from blmsp.fritz.box ([2001:4090:a247:8056:be7d:83e:a6a5:4659])
        by smtp.gmail.com with ESMTPSA id l4-20020a7bc444000000b003eafc47eb09sm1460563wmi.43.2023.03.15.04.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 04:06:28 -0700 (PDT)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Simon Horman <simon.horman@corigine.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH v3 05/16] can: m_can: Keep interrupts enabled during peripheral read
Date:   Wed, 15 Mar 2023 12:05:35 +0100
Message-Id: <20230315110546.2518305-6-msp@baylibre.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315110546.2518305-1-msp@baylibre.com>
References: <20230315110546.2518305-1-msp@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Interrupts currently get disabled if the interrupt status shows new
received data. Non-peripheral chips handle receiving in a worker thread,
but peripheral chips are handling the receive process in the threaded
interrupt routine itself without scheduling it for a different worker.
So there is no need to disable interrupts for peripheral chips.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/net/can/m_can/m_can.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index e7aceeba3759..a5003435802b 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -972,8 +972,8 @@ static int m_can_rx_peripheral(struct net_device *dev, u32 irqstatus)
 	/* Don't re-enable interrupts if the driver had a fatal error
 	 * (e.g., FIFO read failure).
 	 */
-	if (work_done >= 0)
-		m_can_enable_all_interrupts(cdev);
+	if (work_done < 0)
+		m_can_disable_all_interrupts(cdev);
 
 	return work_done;
 }
@@ -1095,11 +1095,12 @@ static irqreturn_t m_can_isr(int irq, void *dev_id)
 	 */
 	if ((ir & IR_RF0N) || (ir & IR_ERR_ALL_30X)) {
 		cdev->irqstatus = ir;
-		m_can_disable_all_interrupts(cdev);
-		if (!cdev->is_peripheral)
+		if (!cdev->is_peripheral) {
+			m_can_disable_all_interrupts(cdev);
 			napi_schedule(&cdev->napi);
-		else if (m_can_rx_peripheral(dev, ir) < 0)
+		} else if (m_can_rx_peripheral(dev, ir) < 0) {
 			goto out_fail;
+		}
 	}
 
 	if (cdev->version == 30) {
-- 
2.39.2

