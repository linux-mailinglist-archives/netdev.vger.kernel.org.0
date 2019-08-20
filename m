Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 807E595680
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 07:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbfHTFJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 01:09:38 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41999 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729108AbfHTFJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 01:09:38 -0400
Received: by mail-pl1-f194.google.com with SMTP id y1so2105754plp.9
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 22:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DV/WqxRBj1zmpM+E4gMAZS0eS9d1iKH2+F8A7pnrP0Y=;
        b=sE1VeczhPDfa9x422ZzMyCbZLrf9ia7yAAOeHIpaWioXnYZn1E/SZ5WW3O7YkpHDW9
         tJ//D1tmP9QCYKvD2Ax7eeb6ivFGMKgdVKj4w8ZFF4t8Mcj7OoC2Oiod3R1LJVDd0zSk
         LWTtyrxOHyyqboZsYO1vWJ6r+3BcH03x+szIVzRVKF0nFnll8trBP29tlcmmL+xK90l3
         UBtksYy4OVb+y25cLifjI0m7Q4rYXvda4kMPsf8CA/9LpHdrfj6d56B/Lyvv04KD8rR5
         gpbCVAC4++xSqNmb2lXDcki7da8Bc2pYKnLezmFduIAYqNiHmleN+kd37mzG9ghz4S/4
         Un9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DV/WqxRBj1zmpM+E4gMAZS0eS9d1iKH2+F8A7pnrP0Y=;
        b=d0pX3KTm5jxnozP1LtBzpvMipTNaIHZqs9TH8TVpCLhiiuAB/8mUqgFCP32B0Wea6Q
         bllbZocJnUxfnk7CPckbioijVqDNdEt5vQml1o3YvVgCXzmkfaEZdR5zuMkHS+830OcZ
         QlEbhmPthjQwKElZSO9V3xqCR4ketcKTY5rWKvaFP+rfz7Oda/oBfBAZ+rUWw6e0l3EA
         6QW2VUknbg2OD9z2yMePvLJHE+FaLxLbS7WrNK+dKHqGONYoFux0sWqRlPOh9ytqPo34
         YL/Rrhv6c+XeDy3hx+gV1m1Cp37szNRpH4ArEQLMLg34kKEahaKeVter1sU7aFTKBWe+
         eBtw==
X-Gm-Message-State: APjAAAV3K6HDRVU0mL+e8D6Odf+aI6//J8UxEeBgKh3BsTO2D1jsgHGX
        fMlkilAAzR0nIEFYP0XBqNWCug==
X-Google-Smtp-Source: APXvYqxKjd535rM4n/0gwnMzd/Oeg9Dm9I6Cy1cfG3BImIqyaXap5RLsjm5lQg4ypBPf1pKYU8Gd4A==
X-Received: by 2002:a17:902:a612:: with SMTP id u18mr25603093plq.181.1566277777185;
        Mon, 19 Aug 2019 22:09:37 -0700 (PDT)
Received: from localhost.localdomain (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.gmail.com with ESMTPSA id r1sm16023902pgv.70.2019.08.19.22.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 22:09:36 -0700 (PDT)
From:   Jian-Hong Pan <jian-hong@endlessm.com>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        Jian-Hong Pan <jian-hong@endlessm.com>
Subject: [PATCH v3] rtw88: pci: Move a mass of jobs in hw IRQ to soft IRQ
Date:   Tue, 20 Aug 2019 12:59:35 +0800
Message-Id: <20190820045934.24841-1-jian-hong@endlessm.com>
X-Mailer: git-send-email 2.22.1
In-Reply-To: <CAPpJ_edU68X-Ki+J61qfws+1-=zv54bcak9tzkMX=CkDS5mOMA@mail.gmail.com>
References: <CAPpJ_edU68X-Ki+J61qfws+1-=zv54bcak9tzkMX=CkDS5mOMA@mail.gmail.com>
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

 drivers/net/wireless/realtek/rtw88/pci.c | 33 +++++++++++++++++++-----
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 00ef229552d5..a8c17a01f318 100644
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
@@ -891,8 +908,10 @@ static irqreturn_t rtw_pci_interrupt_handler(int irq, void *dev)
 	if (irq_status[0] & IMR_ROK)
 		rtw_pci_rx_isr(rtwdev, rtwpci, RTW_RX_QUEUE_MPDU);
 
-out:
-	spin_unlock(&rtwpci->irq_lock);
+	/* all of the jobs for this interrupt have been done */
+	if (rtw_flag_check(rtwdev, RTW_FLAG_RUNNING))
+		rtw_pci_enable_interrupt(rtwdev, rtwpci);
+	spin_unlock_irqrestore(&rtwpci->irq_lock, flags);
 
 	return IRQ_HANDLED;
 }
@@ -1152,8 +1171,10 @@ static int rtw_pci_probe(struct pci_dev *pdev,
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
@@ -1192,7 +1213,7 @@ static void rtw_pci_remove(struct pci_dev *pdev)
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

