Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D489889228
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 17:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfHKPId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 11:08:33 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45433 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbfHKPIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 11:08:32 -0400
Received: by mail-wr1-f67.google.com with SMTP id q12so12232034wrj.12;
        Sun, 11 Aug 2019 08:08:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nxzAYP11S0d/1a3dYYvLWUsgWAZhT+IPIf01ibLHMzA=;
        b=tERWaxWvAJHPhNnSUfvH2TV0d5qSZRIgCjVz6UZokXxJqBTytjsuS/M6JRAO4kzdf+
         bJy+sYgFdnSsj5q2c/HndwoO4nHSsckPH0QmpvSIYhM+Yv0QjlJ+MhmbMPi/Uvxdg/Nu
         2pw0L7kZQyR9wFCg7qKRnus4l+XE+V6zefnl+ro5BQ/Ua4idwnVhE4b7tSrA70oDAmNy
         WRSlh0Ezikj0WaCQQCzSV2U40yIy+QqaWgZczB+aEtjHnF29V5I+rGsxhpHYDWEUpDi3
         KyiqDiyC3ZTO7xB9q9Xc3uO86YBWQOMOoJEoUjnMigTb3bAjh13Xg4Q1I64+RCtqp+Kd
         NeuA==
X-Gm-Message-State: APjAAAX/i4HZVmLZwBdi3byVL/gts2DL2ZrwXy8lYFpKuMz/fbh/1X7P
        MCkmCs88yt8EKv+nAOTM4iU=
X-Google-Smtp-Source: APXvYqxmOhuT2C9Rk5NraUXMAcsMupScQ5Aoa3l0Jcg3FmKsUIC3Gv4rRck3bH+3r4UQqkKyZE5f1Q==
X-Received: by 2002:adf:f186:: with SMTP id h6mr34996098wro.274.1565536109482;
        Sun, 11 Aug 2019 08:08:29 -0700 (PDT)
Received: from localhost.localdomain (broadband-188-32-48-208.ip.moscow.rt.ru. [188.32.48.208])
        by smtp.googlemail.com with ESMTPSA id y16sm227049408wrg.85.2019.08.11.08.08.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Aug 2019 08:08:29 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     Denis Efremov <efremov@linux.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        Peter Jones <pjones@redhat.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-fbdev@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, linux-s390@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] PCI: Add define for the number of standard PCI BARs
Date:   Sun, 11 Aug 2019 18:07:56 +0300
Message-Id: <20190811150802.2418-2-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190811150802.2418-1-efremov@linux.com>
References: <20190811150802.2418-1-efremov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Code that iterates over all standard PCI BARs typically uses
PCI_STD_RESOURCE_END. However, it requires the "unusual" loop condition
"i <= PCI_STD_RESOURCE_END" rather than something more standard like
"i < PCI_STD_NUM_BARS".

This patch adds the definition PCI_STD_NUM_BARS which is equivalent to
"PCI_STD_RESOURCE_END + 1" and updates loop conditions to use it.

Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/pci/quirks.c          | 2 +-
 include/linux/pci.h           | 2 +-
 include/uapi/linux/pci_regs.h | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 208aacf39329..02bdf3a0231e 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -475,7 +475,7 @@ static void quirk_extend_bar_to_page(struct pci_dev *dev)
 {
 	int i;
 
-	for (i = 0; i <= PCI_STD_RESOURCE_END; i++) {
+	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
 		struct resource *r = &dev->resource[i];
 
 		if (r->flags & IORESOURCE_MEM && resource_size(r) < PAGE_SIZE) {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 9e700d9f9f28..7b9590d5dc2d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -76,7 +76,7 @@ enum pci_mmap_state {
 enum {
 	/* #0-5: standard PCI resources */
 	PCI_STD_RESOURCES,
-	PCI_STD_RESOURCE_END = 5,
+	PCI_STD_RESOURCE_END = PCI_STD_RESOURCES + PCI_STD_NUM_BARS - 1,
 
 	/* #6: expansion ROM resource */
 	PCI_ROM_RESOURCE,
diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index f28e562d7ca8..68b571d491eb 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -34,6 +34,7 @@
  * of which the first 64 bytes are standardized as follows:
  */
 #define PCI_STD_HEADER_SIZEOF	64
+#define PCI_STD_NUM_BARS	6	/* Number of standard BARs */
 #define PCI_VENDOR_ID		0x00	/* 16 bits */
 #define PCI_DEVICE_ID		0x02	/* 16 bits */
 #define PCI_COMMAND		0x04	/* 16 bits */
-- 
2.21.0

