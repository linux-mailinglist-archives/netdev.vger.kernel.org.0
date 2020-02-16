Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2F22160725
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 00:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgBPXMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 18:12:20 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:40229 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728148AbgBPXMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 18:12:16 -0500
Received: by mail-pj1-f65.google.com with SMTP id 12so6347651pjb.5
        for <netdev@vger.kernel.org>; Sun, 16 Feb 2020 15:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=43HSTFMFDLMK5OsuXjIiOKhf3nldU6Wm+nyTF1bRCNQ=;
        b=aOOpoCEIsIX803ZCd2RiLTFP48wI/AkxTde/FBKFMc/sYG1BkhLn/9radeJzxbpNRq
         zY55gaAUQNMU+Bfws4L5njXmXO2Muc9/ZH3nD5xckeDLh6m3pCms6ykgTfNlEfGz5Ng7
         JQ7VeTxXj53SzaOVx7KcLg4DqDqszvl8rVBHTKXJmZtvfosTrhwcZYzybuFhvwuF6wUk
         c9lzcwNc85/QCseOgycndDtjpeLZkCoJdIA8h3tqEJK1ppkgR9VHwtAYVitWosm3lHzb
         k1zs8EhQxOHgn++00OjNcL+i5TgW1M0GN73rEhz9kwV2YhzIT3w28z9Mm6vGuXEoux0t
         Vnlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=43HSTFMFDLMK5OsuXjIiOKhf3nldU6Wm+nyTF1bRCNQ=;
        b=FnBjvA/OjUpGxAX8z+nSZVEgrHnvVoZ/4yNEvg87ITjK67FzVGLCVfyHJQQH1/lhIv
         Yvo9WOt5EtpZmZgsWO4VdimHKWZMEvFIs67vcgBZrX1gqqXTvUCgy+93Ep5QpVhhHmMg
         2xJPtod6qN+2mp+esbRLvqCsPCBD3/V1/s79nnldokOH4kwk05iDBq0Xfh9+ztdtoNhF
         qTFWGRHWLVwbxM2CyO52ZBAb5Fj45iTVqj11W5Uz080vcheCTyUw7fxiBDc50spCsItp
         1BzjdWwpDIl8+mNEEDKXVy0sITeNj/55nIv8it63Daz4/zkEAI1sjY139LFHrE0d0BWY
         s+EQ==
X-Gm-Message-State: APjAAAXu1aOiw0c33DQFcBgyzXe6XnV5WBNOJz1qz8Mc1rCMZrYmpeEy
        2cu0hWHC+ddzLFvtZvFQws4dic2Mi/5cNQ==
X-Google-Smtp-Source: APXvYqzUY4NvNyjaE7pxAtsgMLlQUTCYGc89BWDYctMF3Y4A44hXxALDACFIqqa8/f4MacI9Kc/qgA==
X-Received: by 2002:a17:90a:3745:: with SMTP id u63mr16416246pjb.123.1581894735975;
        Sun, 16 Feb 2020 15:12:15 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id 70sm14074573pgd.28.2020.02.16.15.12.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Feb 2020 15:12:15 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 9/9] ionic: keep ionic dev on lif init fail
Date:   Sun, 16 Feb 2020 15:11:58 -0800
Message-Id: <20200216231158.5678-10-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200216231158.5678-1-snelson@pensando.io>
References: <20200216231158.5678-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the basic ionic interface works but the lif creation fails,
don't fail the probe.  This will allow us to use the driver to
help inspect the hw/fw/pci interface for debugging purposes.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c | 8 ++++++++
 drivers/net/ethernet/pensando/ionic/ionic_lif.c     | 3 +++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 448d7b23b2f7..554bafac1147 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -37,6 +37,9 @@ int ionic_bus_alloc_irq_vectors(struct ionic *ionic, unsigned int nintrs)
 
 void ionic_bus_free_irq_vectors(struct ionic *ionic)
 {
+	if (!ionic->nintrs)
+		return;
+
 	pci_free_irq_vectors(ionic->pdev);
 }
 
@@ -346,6 +349,11 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ionic_reset(ionic);
 err_out_teardown:
 	ionic_dev_teardown(ionic);
+	/* Don't fail the probe for these errors, keep
+	 * the hw interface around for inspection
+	 */
+	return 0;
+
 err_out_unmap_bars:
 	ionic_unmap_bars(ionic);
 	pci_release_regions(pdev);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 85dfd76ff0c6..a6fd6aa4ce40 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2486,6 +2486,9 @@ void ionic_lifs_unregister(struct ionic *ionic)
 	 * current model, so don't bother searching the
 	 * ionic->lif for candidates to unregister
 	 */
+	if (!ionic->master_lif)
+		return;
+
 	cancel_work_sync(&ionic->master_lif->deferred.work);
 	cancel_work_sync(&ionic->master_lif->tx_timeout_work);
 	if (ionic->master_lif->netdev->reg_state == NETREG_REGISTERED)
-- 
2.17.1

