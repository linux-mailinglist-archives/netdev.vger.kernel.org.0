Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D99126820F
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 02:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbgINAKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 20:10:30 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:52931 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgINAKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 20:10:24 -0400
Received: by mail-pj1-f68.google.com with SMTP id o16so4544037pjr.2;
        Sun, 13 Sep 2020 17:10:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mvFFXcZ1+76mKofPZLr+kseVKd3+sG4bbeo2yjUvYe4=;
        b=bmHuUHEKs8S4X1H5SceJaLajr/9Jh/3uM76dvcokQRefdihRxDCdIhyWp5Tsq4a0YK
         yUOnUAN5VdJVV8/QM8yh1Jw6yUHXA/IUAzQ3PUubOYnWnRfJ+ZNQt2jVtLXKRQMp3XfQ
         p6g97XpuON1vX57eWcg7vdj373BLQmNYTYX3lVZAVcQiJOyQYi8afd1virXy4gkuPY61
         xG1yCbdwVBDjA3yYBjfrC1T02k24lKjOkygeZke2HSPDdI22YvusUDLA6LnY0/0+r4DH
         Am8x/SzsfP3mnTwbPPdLH/DndcZuPT6Q4593MmcEdNlPtU9BZY90iJoPbLBzcpmuEPRG
         3xiA==
X-Gm-Message-State: AOAM533jro3vrlOFUR5xVMjU0CRUPgx3knPbWJDDgtGJF6N1yCmwzBeW
        rCGqykUXmM8KUwqP8pFLqHz7s78lVzOcdg==
X-Google-Smtp-Source: ABdhPJyIoFR8tBBd/eSfSluquJ1cqMZXSejoSblcQTEfFRkuxxsxui39TX/xmUM6x1UYMc0/WMicnA==
X-Received: by 2002:a17:90a:4802:: with SMTP id a2mr11271354pjh.5.1600042223154;
        Sun, 13 Sep 2020 17:10:23 -0700 (PDT)
Received: from localhost ([2601:647:5b00:1162:1ac0:17a6:4cc6:d1ef])
        by smtp.gmail.com with ESMTPSA id f5sm8023418pfj.212.2020.09.13.17.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2020 17:10:22 -0700 (PDT)
From:   Moritz Fischer <mdf@kernel.org>
To:     davem@davemloft.net
Cc:     snelson@pensando.io, mst@redhat.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, moritzf@google.com,
        Moritz Fischer <mdf@kernel.org>
Subject: [PATCH net-next 2/3] net: dec: tulip: de2104x: Replace pci_enable_device with devres version
Date:   Sun, 13 Sep 2020 17:10:01 -0700
Message-Id: <20200914001002.8623-3-mdf@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200914001002.8623-1-mdf@kernel.org>
References: <20200914001002.8623-1-mdf@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace pci_enable_device() with its devres counterpart
pcim_enable_device().

Signed-off-by: Moritz Fischer <mdf@kernel.org>
---
 drivers/net/ethernet/dec/tulip/de2104x.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
index 9bcfc82b71d1..e4189c45c2ba 100644
--- a/drivers/net/ethernet/dec/tulip/de2104x.c
+++ b/drivers/net/ethernet/dec/tulip/de2104x.c
@@ -2009,14 +2009,14 @@ static int de_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netif_carrier_off(dev);
 
 	/* wake up device, assign resources */
-	rc = pci_enable_device(pdev);
+	rc = pcim_enable_device(pdev);
 	if (rc)
 		return rc;
 
 	/* reserve PCI resources to ensure driver atomicity */
 	rc = pci_request_regions(pdev, DRV_NAME);
 	if (rc)
-		goto err_out_disable;
+		return rc;
 
 	/* check for invalid IRQ value */
 	if (pdev->irq < 2) {
@@ -2096,8 +2096,6 @@ static int de_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	iounmap(regs);
 err_out_res:
 	pci_release_regions(pdev);
-err_out_disable:
-	pci_disable_device(pdev);
 	return rc;
 }
 
@@ -2111,7 +2109,6 @@ static void de_remove_one(struct pci_dev *pdev)
 	kfree(de->ee_data);
 	iounmap(de->regs);
 	pci_release_regions(pdev);
-	pci_disable_device(pdev);
 }
 
 #ifdef CONFIG_PM
-- 
2.28.0

