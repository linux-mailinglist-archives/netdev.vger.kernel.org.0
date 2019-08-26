Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCE59C9F7
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 09:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729901AbfHZHPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 03:15:09 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36288 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729625AbfHZHPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 03:15:08 -0400
Received: by mail-pf1-f195.google.com with SMTP id w2so11211566pfi.3
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 00:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8n+YcTBfTmkKFgYucRuL8pDTwqdXrd2vM7W5/c926a4=;
        b=DQD23wX5rGLBsx9zqWRJghGYD79QMpq3czy9MyRWPCQTvBl60/tswSG6NiHqZCNjKU
         Zu+SmyTEPx5Tk9S88yTDOYSiKeoKc39DpxqwJU6gULTMAIX/cHdTVlFY3cCw3FHvyRVn
         zOf8meilXbas0AwY9hgFxg+jE4C1Y1iMvmpcJ5wHAt6TuiEEixNUeFKr/sHB6xuEsY31
         RhYDis5ifpS2cFk0R6TnedXvI7wO8o2FyWZ+RypylQoCHetwfXGrS4q20GogitJ5JRHa
         mcgbuCMyJJ0xiyZYIbQzsEaa0L12aGT4G9un2AgBicptMwKd8ai6Vs1p6CmdKNbXHukR
         1QYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8n+YcTBfTmkKFgYucRuL8pDTwqdXrd2vM7W5/c926a4=;
        b=Xprnu9ZQGrODaOW1wTx1WtQBjTc9SIHihbMbZpzBTRHFLmWR3ezqmN0TTTZXglk2i7
         g+YEy41o9ge0yh1PC/ZoNJhaWGeRORJDvPArHZVUp872/lgWMqEB1+YNEnzp9SXbalSL
         HQ+KZU2thE92su3np9xe7zr7S0QwMm/QvQm/un7OUvulA/uj1QJpLw3qEX1TudiCS5N3
         7WyJ0RrPaeFdc48aOAT44TToeAPW1TC/a9Bj3tm/R6jQiq5tUQSp/2TGwqFx5kBUtRAL
         t1CmxEt4vUwlbiE22NNKq8LtbzzWnz0lDqrwOFofg4/l0naSqDmX4eIhmmVhEW94yowH
         Xf6Q==
X-Gm-Message-State: APjAAAUj13GAYCCxx7Dp1utd27YL8v9YdoGJcYx+p7/jO2nY+JMw1317
        pPjB5ALXNs6zFh8NpSvgd3akCQ==
X-Google-Smtp-Source: APXvYqx7ejqPLj9k2h0XJ0X3g0hvXd7pRFFT4LMlGp44C6DeCkTM7znQfZ5bLhx4QWY/s16r13DcEA==
X-Received: by 2002:a17:90a:a105:: with SMTP id s5mr18181660pjp.51.1566803707694;
        Mon, 26 Aug 2019 00:15:07 -0700 (PDT)
Received: from localhost.localdomain (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.gmail.com with ESMTPSA id w2sm11064485pjr.27.2019.08.26.00.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 00:15:07 -0700 (PDT)
From:   Jian-Hong Pan <jian-hong@endlessm.com>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        Jian-Hong Pan <jian-hong@endlessm.com>
Subject: [PATCH v4] rtw88: pci: Move a mass of jobs in hw IRQ to soft IRQ
Date:   Mon, 26 Aug 2019 15:08:29 +0800
Message-Id: <20190826070827.1436-1-jian-hong@endlessm.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D18A5786@RTITMBSVM04.realtek.com.tw>
References: <F7CD281DE3E379468C6D07993EA72F84D18A5786@RTITMBSVM04.realtek.com.tw>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a mass of jobs between spin lock and unlock in the hardware
IRQ which will occupy much time originally. To make system work more
efficiently, this patch moves the jobs to the soft IRQ (bottom half) to
reduce the time in hardware IRQ.

Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
---
v2:
 Change the spin_lock_irqsave/unlock_irqrestore to spin_lock/unlock in
 rtw_pci_interrupt_handler. Because the interrupts are already disabled
 in the hardware interrupt handler.

v3:
 Extend the spin lock protecting area for the TX path in
 rtw_pci_interrupt_threadfn by Realtek's suggestion

v4:
 Remove the WiFi running check in rtw_pci_interrupt_threadfn to avoid AP
 connection failed by Realtek's suggestion.

 drivers/net/wireless/realtek/rtw88/pci.c | 32 +++++++++++++++++++-----
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 00ef229552d5..955dd6c6fb57 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -866,12 +866,29 @@ static irqreturn_t rtw_pci_interrupt_handler(int irq, void *dev)
 {
 	struct rtw_dev *rtwdev = dev;
 	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
-	u32 irq_status[4];
 
 	spin_lock(&rtwpci->irq_lock);
 	if (!rtwpci->irq_enabled)
 		goto out;
 
+	/* disable RTW PCI interrupt to avoid more interrupts before the end of
+	 * thread function
+	 */
+	rtw_pci_disable_interrupt(rtwdev, rtwpci);
+out:
+	spin_unlock(&rtwpci->irq_lock);
+
+	return IRQ_WAKE_THREAD;
+}
+
+static irqreturn_t rtw_pci_interrupt_threadfn(int irq, void *dev)
+{
+	struct rtw_dev *rtwdev = dev;
+	struct rtw_pci *rtwpci = (struct rtw_pci *)rtwdev->priv;
+	unsigned long flags;
+	u32 irq_status[4];
+
+	spin_lock_irqsave(&rtwpci->irq_lock, flags);
 	rtw_pci_irq_recognized(rtwdev, rtwpci, irq_status);
 
 	if (irq_status[0] & IMR_MGNTDOK)
@@ -891,8 +908,9 @@ static irqreturn_t rtw_pci_interrupt_handler(int irq, void *dev)
 	if (irq_status[0] & IMR_ROK)
 		rtw_pci_rx_isr(rtwdev, rtwpci, RTW_RX_QUEUE_MPDU);
 
-out:
-	spin_unlock(&rtwpci->irq_lock);
+	/* all of the jobs for this interrupt have been done */
+	rtw_pci_enable_interrupt(rtwdev, rtwpci);
+	spin_unlock_irqrestore(&rtwpci->irq_lock, flags);
 
 	return IRQ_HANDLED;
 }
@@ -1152,8 +1170,10 @@ static int rtw_pci_probe(struct pci_dev *pdev,
 		goto err_destroy_pci;
 	}
 
-	ret = request_irq(pdev->irq, &rtw_pci_interrupt_handler,
-			  IRQF_SHARED, KBUILD_MODNAME, rtwdev);
+	ret = devm_request_threaded_irq(rtwdev->dev, pdev->irq,
+					rtw_pci_interrupt_handler,
+					rtw_pci_interrupt_threadfn,
+					IRQF_SHARED, KBUILD_MODNAME, rtwdev);
 	if (ret) {
 		ieee80211_unregister_hw(hw);
 		goto err_destroy_pci;
@@ -1192,7 +1212,7 @@ static void rtw_pci_remove(struct pci_dev *pdev)
 	rtw_pci_disable_interrupt(rtwdev, rtwpci);
 	rtw_pci_destroy(rtwdev, pdev);
 	rtw_pci_declaim(rtwdev, pdev);
-	free_irq(rtwpci->pdev->irq, rtwdev);
+	devm_free_irq(rtwdev->dev, rtwpci->pdev->irq, rtwdev);
 	rtw_core_deinit(rtwdev);
 	ieee80211_free_hw(hw);
 }
-- 
2.20.1

