Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D64FC8FEF2
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 11:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfHPJ0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 05:26:18 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37679 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbfHPJ0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 05:26:17 -0400
Received: by mail-wm1-f65.google.com with SMTP id z23so3519587wmf.2;
        Fri, 16 Aug 2019 02:26:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zu/6tv2CuG9JSQuI18kICycXFKyLsNIBW3plqogVCew=;
        b=PXLHyB6ISITixXWc1WLZQ7AynlA3Qlu5U64S3tCJe+EBXEkFPMPkHj3F4VPewv8t0O
         gbKYi9983RHiTcEVeZg2GCNPgHVBByg/KUI1xeFx+2uG0Rl7ZScsbFuHAS16QCzuhxDR
         ca8thiwKld6yjNiNwQTwTzvXKUG13W8Mg1f/K/19YL17iz3PEWo1u5IX/QZNeEsKI/8K
         DnVhIurYjV27PCDIysVEQdiOfmpryAMno+ySd8AJSYtfXKetCWMpYD53UCDaPJLZ2XbU
         e71E3bpoworFdqbJerD1OD9Ga0p5pT4EmEGbxaI7P39xP5vjO0nRy+053IL3FQCYbvTB
         +1AA==
X-Gm-Message-State: APjAAAXl+xuJSi5OkCf2DAoO7JypMnMJvSJ7JgCELVFgA1iyO9zP/845
        SiItgP+O5LWiZ5nZkr9yTkQ=
X-Google-Smtp-Source: APXvYqwkeKKLiMCmGh1NBcy9Mq6BnTtP4R9CiQ5W4g6W/f7Sgo6YX/5uTrr5xdEP7iD3iZb+FpsCLg==
X-Received: by 2002:a1c:5a56:: with SMTP id o83mr6219308wmb.103.1565947574930;
        Fri, 16 Aug 2019 02:26:14 -0700 (PDT)
Received: from localhost.localdomain (broadband-188-32-48-208.ip.moscow.rt.ru. [188.32.48.208])
        by smtp.googlemail.com with ESMTPSA id q20sm16521138wrc.79.2019.08.16.02.26.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 02:26:14 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     Denis Efremov <efremov@linux.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/10] stmmac: pci: Loop using PCI_STD_NUM_BARS
Date:   Fri, 16 Aug 2019 12:24:31 +0300
Message-Id: <20190816092437.31846-5-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190816092437.31846-1-efremov@linux.com>
References: <20190816092437.31846-1-efremov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor loops to use 'i < PCI_STD_NUM_BARS' instead of
'i <= PCI_STD_RESOURCE_END'.

Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
-- 
2.21.0

