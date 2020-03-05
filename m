Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6185179F17
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 06:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725914AbgCEFXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 00:23:33 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45706 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgCEFXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 00:23:32 -0500
Received: by mail-pg1-f194.google.com with SMTP id m15so2148769pgv.12
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 21:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6BJD4y/MJKY4TduWGLVqWk4PWDU4OuLSC5J4NWYa63U=;
        b=CF/Yn230gl0OwWYQBPb/hMUTusbPmYdtQHOyznSyzwNlZ+bjRZDBo6BtQY8gripEcB
         6WaLpxL251TiJg+z3fTxAw7PXtCaf1wyPXLcC0DWqcVlT1EDXZZ0NgsL/zipnjGdtDoq
         Qw3VIvlMyVVMdbXsfOUlmD0X7YX98ngGIcSEMhMe46aNeK3lmmlwl407yqe7EZaubuVi
         ku9MQXk6zvTME5P80a+0uwuS3NhqB6GvIH003E7b8eU/pLLLvQ+p464uvBcqofTxfZ+B
         XjoAmdhFFiBEtXwiFbDAApf3IYd+5eoYXPp3cGjz9jwBcm+0CO6X4D46nWXSpYCQVV5o
         lDZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6BJD4y/MJKY4TduWGLVqWk4PWDU4OuLSC5J4NWYa63U=;
        b=b/hboRS+L+5tyin451x6CcnhQr3jC8UmPnPhvReoUP8zZMpgtMtJRJVoV4PmEaNsYO
         ipDmRwn+SZ6MlFIxneNe/su6EoHUykgI0AXkhu9GhyhBN/p9dJTpSVPz7TdWXrk8NwHx
         eY04YtvC0ETgBDGOB8ijBWZakVt4tf5cHCBaObPJCDIZoCbb1BXKt4MuFE+vPMqA7IHi
         HNW1AkevaC6A7wHdcqR9JuDwa1JnHNiNjcUGPJyLcKki3RSwfMH75a2s7srPVRWgCV04
         ye+51d2Tn1gjW7M1EiXXyUh7RZKFYWFr0C5is6aZj2ZW0+ZVicYbNemXMzUWRSdonb6t
         P9XQ==
X-Gm-Message-State: ANhLgQ0vciQFAkc/W956fZHvAXfwv0YfVX2kJ3UWS/GD04qa3i+hPVfH
        9RgehnLvkdwU/ZBHWK6HZrPqzKEMXKA=
X-Google-Smtp-Source: ADFU+vssiSkbLRhM0zP+lG1kUCZGl55pU0kgNhm/wJywQUF/69DwJFu8l3a/4cb5OuNr+J9fWSff/A==
X-Received: by 2002:a63:617:: with SMTP id 23mr5994307pgg.208.1583385809471;
        Wed, 04 Mar 2020 21:23:29 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h2sm29337759pgv.40.2020.03.04.21.23.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Mar 2020 21:23:28 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 1/8] ionic: keep ionic dev on lif init fail
Date:   Wed,  4 Mar 2020 21:23:12 -0800
Message-Id: <20200305052319.14682-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200305052319.14682-1-snelson@pensando.io>
References: <20200305052319.14682-1-snelson@pensando.io>
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
index 191271f6260d..1b7e18fe83db 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2408,6 +2408,9 @@ void ionic_lifs_unregister(struct ionic *ionic)
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

