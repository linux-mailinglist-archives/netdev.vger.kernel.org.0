Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B22917897B
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 05:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbgCDEUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 23:20:25 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:47030 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbgCDEUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 23:20:25 -0500
Received: by mail-pf1-f195.google.com with SMTP id o24so259008pfp.13
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 20:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6BJD4y/MJKY4TduWGLVqWk4PWDU4OuLSC5J4NWYa63U=;
        b=ypORS6EXesxKCgPHLJc5QCYj9wNqypHaplifPRaz4Pff1eR86dkxAhfkuUiWtOykP4
         iMvaMo9gnAeUuiXsRSazvIbIBY8Yw3PcLDGzPBKqhnqMPll9UamYbp00hG1AnfRbMMXq
         qY61KZDyRRP7RzaaRhEX2phT3J8FAUETrR+aNBP69AE/eahtzJi5DyQ/vR/sjw2stGkw
         gm1BqZSBNHYHiPDLCSJgtsyplADpzMBOBvToGGW1QkzUenHkB6c/deoXrU6xnuDMKkWP
         s+QmKDp1kjI40wRHvRDJvvySwA1D35zw+Jm1CH8nysSaYxkkL6m8J78akJ9uzXc/KziN
         G5SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6BJD4y/MJKY4TduWGLVqWk4PWDU4OuLSC5J4NWYa63U=;
        b=flCqrasMtmbAOZDjfKAV4aQdPuEsF7zOWglHlxQ+U8RhinaqZ7ZMF0doCTZcnRMr+Y
         qtBhvpRj31AveUB+DnxmHH2edht2fCMZa3S0q09QOTYkYQ6fvQ13g96kimF6TCaQPTRP
         hJH25N5GuxFGjSy6vmIfpaclKpKdUjmU7n4hShqk2J8rU6wLzQWDQS+U/4eZSESvBaIq
         TMZzKY/il3ySwAYhSZixFk7MIy1soBYANYtE+6qS7APT6eJX/PDrVmedFq74H5hIdSr/
         KJMhS3Cq9Hrwp2e0/1BGAoa2OzrsU05ZV8xOH2UaLvx2kcJ8kczGMptkO9YWlYfKDu5z
         VqRw==
X-Gm-Message-State: ANhLgQ374qhmbt7qiiTJtK/PUWA8/gut98CFW5AxV/uZdHnLjq34oLGz
        W6GzvriECNcw7oMxxuojscjekw==
X-Google-Smtp-Source: ADFU+vsPdGhVml3jO3A5kRxHPEiagTaGXsGpXtQvENGDM6x7PdM8tWcT1O+kSHARITql1U55wSEZKQ==
X-Received: by 2002:a62:382:: with SMTP id 124mr1232683pfd.11.1583295622895;
        Tue, 03 Mar 2020 20:20:22 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id c2sm671702pjo.28.2020.03.03.20.20.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Mar 2020 20:20:22 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 1/8] ionic: keep ionic dev on lif init fail
Date:   Tue,  3 Mar 2020 20:20:06 -0800
Message-Id: <20200304042013.51970-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200304042013.51970-1-snelson@pensando.io>
References: <20200304042013.51970-1-snelson@pensando.io>
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

