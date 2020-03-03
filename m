Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0F4176DE2
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 05:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgCCEQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 23:16:04 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45229 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbgCCEQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 23:16:04 -0500
Received: by mail-pf1-f193.google.com with SMTP id 2so769322pfg.12
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 20:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6BJD4y/MJKY4TduWGLVqWk4PWDU4OuLSC5J4NWYa63U=;
        b=AzdN1oCgX/h23JucRvoxwnb4gJeYu0LG+eC9jMwXh5ygVUgNh/Uyjz1IouSIIa7y31
         XDKKPdS0N6BFYULcNApLp12ocxdmlB6tw310r4dPHPDqDpdxCs4rHG838LT6Q/4Py/N0
         fWE4zM+3/l5R0iYdLxlhdtpHWL5QRwEP50GpNciLBTj75fUkxn2YA+pNzpC5pedaBCI+
         b76XZa3Yrx2+gMqK5XE2BfZ98012OrFSv/CkdY6XpWL6VcWYMXbftUcg2CYhyMKwJUHX
         DiA1lHdPknYHA/I8UMbhfG0rHxQz3pEjKRqGu5wGJA5FGmucUjOognKy9k1ZMQFC/uon
         7Txg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6BJD4y/MJKY4TduWGLVqWk4PWDU4OuLSC5J4NWYa63U=;
        b=tbMV6dvhuMXSBNh8j2EMpTgBsEytr0WCZp0Owum7ZokvJootVi02k5b2q8QH+QRzeP
         HU0C8epSgTpO1gIhVFRqn1zxyevDqNHMtwMlZjx9PWeMhtrfx1Icx2RV58B0vRA6et0/
         dRvk2cEaphwty1mcCFpSpXrmu+CcLZgWx+QgeKxqWhceLP5fwVy2oXFp5flMxVh04wes
         C1fkOq26u2m8grNQ6mdCAHF5zfPXITUA5+tjg7SICtNNXbhUSy1Ba6uSvFulG2lcV/T9
         Gu0P1CHKf0y6uEOyj4Hm0ZcnmGxAbzpnvJEO1VcFLq08TEI88i8WGPvveZiNsO1Lig5b
         40jA==
X-Gm-Message-State: ANhLgQ1ZHdI0XMRSjTB2Kl3X+gJZCjtqnZJD2JMXcLZAlx3aqHu6xDWG
        TAH/BIE8I8+149joTsTFwj/5IA==
X-Google-Smtp-Source: ADFU+vu/uwvH42bCe5JPxXu4/WW7hic7J8+Gb8j4UgQaVcRUQ+TyGIMKTSs9E0KpYBzAPesX5MOLWw==
X-Received: by 2002:a63:2a02:: with SMTP id q2mr2202212pgq.198.1583208961283;
        Mon, 02 Mar 2020 20:16:01 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t7sm396682pjy.1.2020.03.02.20.16.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Mar 2020 20:16:00 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/8] ionic: keep ionic dev on lif init fail
Date:   Mon,  2 Mar 2020 20:15:38 -0800
Message-Id: <20200303041545.1611-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200303041545.1611-1-snelson@pensando.io>
References: <20200303041545.1611-1-snelson@pensando.io>
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

