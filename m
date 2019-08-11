Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8F8D89236
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 17:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfHKPKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 11:10:01 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44248 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbfHKPKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 11:10:00 -0400
Received: by mail-wr1-f66.google.com with SMTP id p17so102482260wrf.11;
        Sun, 11 Aug 2019 08:09:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zQ5jk2zBiGOX8kvtlaUrE9zeV0LbnVUP8cNg6rY4+bo=;
        b=X8MLPsROl1dmqkBusutFm7dAVkU9qw4121R/flE0NuD6Bfbf6I1geFMYE3DRepY4Ej
         zbj4X8I7MykkboSV7SLg/EPY12Zhs4IQg0rP7jPjd+GEKX1ZFODvVeMqouk2ZblZBteK
         J7ys5upUVxEmqndx8yQhblqbJoo4//8gMYqxVenzQNc37QqBYIUsdT/+cCh7agXGzheW
         kI0/IFYe/QgQSUZOuS1fzFUO7vQ9RTQpa59F3UTN3gOtfIRULDKXo3eoZeVrrQDUmgS6
         3KcJ2F/bpAhnfVVqvvMZGXJqBpmjC8IxI6OSuetGnbm2rloMQ44IdpJBgGNv/Ti/7b8k
         EgQw==
X-Gm-Message-State: APjAAAWjVR76h022hcQnL4M5zWKqICLc0o7bP0SabSFo86dMsIcuLIIK
        nVxxtsfs7qRG6QxLYZS1c+c=
X-Google-Smtp-Source: APXvYqwtpXMA/ATmIUzg8Uz0IIOf1hxCxO2YXWI/DXx6dbUrzIeJgQVBwEV3sqHRsytdBVNq6SVJRw==
X-Received: by 2002:a5d:48cf:: with SMTP id p15mr37023414wrs.151.1565536198605;
        Sun, 11 Aug 2019 08:09:58 -0700 (PDT)
Received: from localhost.localdomain (broadband-188-32-48-208.ip.moscow.rt.ru. [188.32.48.208])
        by smtp.googlemail.com with ESMTPSA id y16sm227049408wrg.85.2019.08.11.08.09.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Aug 2019 08:09:58 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     Denis Efremov <efremov@linux.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] PCI/net: Use PCI_STD_NUM_BARS in loops instead of PCI_STD_RESOURCE_END
Date:   Sun, 11 Aug 2019 18:08:00 +0300
Message-Id: <20190811150802.2418-5-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190811150802.2418-1-efremov@linux.com>
References: <20190811150802.2418-1-efremov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch refactors the loop condition scheme from
'i <= PCI_STD_RESOURCE_END' to 'i < PCI_STD_NUM_BARS'.

Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c | 4 ++--
 drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c   | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index 86f9c07a38cf..cfe496cdd78b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -258,7 +258,7 @@ static int stmmac_pci_probe(struct pci_dev *pdev,
 	}
 
 	/* Get the base address of device */
-	for (i = 0; i <= PCI_STD_RESOURCE_END; i++) {
+	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
 		if (pci_resource_len(pdev, i) == 0)
 			continue;
 		ret = pcim_iomap_regions(pdev, BIT(i), pci_name(pdev));
@@ -296,7 +296,7 @@ static void stmmac_pci_remove(struct pci_dev *pdev)
 
 	stmmac_dvr_remove(&pdev->dev);
 
-	for (i = 0; i <= PCI_STD_RESOURCE_END; i++) {
+	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
 		if (pci_resource_len(pdev, i) == 0)
 			continue;
 		pcim_iounmap_regions(pdev, BIT(i));
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c
index 386bafe74c3f..fa8604d7b797 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c
@@ -34,7 +34,7 @@ static int xlgmac_probe(struct pci_dev *pcidev, const struct pci_device_id *id)
 		return ret;
 	}
 
-	for (i = 0; i <= PCI_STD_RESOURCE_END; i++) {
+	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
 		if (pci_resource_len(pcidev, i) == 0)
 			continue;
 		ret = pcim_iomap_regions(pcidev, BIT(i), XLGMAC_DRV_NAME);
-- 
2.21.0

