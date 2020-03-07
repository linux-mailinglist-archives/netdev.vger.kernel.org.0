Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 506F017CA12
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 02:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbgCGBET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 20:04:19 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33413 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbgCGBET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 20:04:19 -0500
Received: by mail-pf1-f194.google.com with SMTP id n7so1943838pfn.0
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 17:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0gypjuYKS7HohaEOg7+s1YFRfeYJ42Vyad0SvROHo7w=;
        b=s0CSEjf0FP3FBkjdB2t3JGLxp+4+3I1oMcp+0UzQnf/IQWbbh333/ivj8STMkHwrG1
         fTQT3lDkkNCccaeYjZUttOkKUZxnR2buYlRjeW6kCwDbur9/bBeMUznHrWy+w0MmiyIa
         LFZ89IEGFqZAmMR8OeL6LH63raaY3AxXxjGBm1/kNOnw25R3VSc0oMmFf78hsKZQ2IJE
         psFjG/M9edXWWaF4Yucqya799cMl0/8rPGczPZA30eOeM6htvhYch4iDm7WxZpmM07+C
         4vLM4gTItmCrykW9GcXfBrp2NcNPAk0PjvQ26sKsoUBi5q9FLd3a+ivrBWcumjBeSz7D
         J/Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0gypjuYKS7HohaEOg7+s1YFRfeYJ42Vyad0SvROHo7w=;
        b=rYUPfMdxxy/y05V0aAi/1UjRJUp0V8Nl2e/pH8A/tdpDAR8mvh9n1fgH84NTn4quQR
         6Ej5zDTom9VMF8xjiJJap4trEgeEyulrjpOqKKuBgDTrfZTQP6ry0KddS77IuQoM59k2
         wZK/X34h4V7TMcCF6FL9wsEi1iPsxlNQvQvfPycRh6k5E+CQYXX/6iGn7oLcLG3j2Em3
         3H+Hz6BVfNbctUxIbfxNM6M+DR43jHycv6Y6LJIgaJ2I4XZfP1ba3viTaem26q5v+O5c
         t8tGymE8HQXB3cgzttP6KgC3faTxCjwWw7qAf79BX4mxtmvSoOx/CZh5nE+6UL+Vk1cv
         dz7A==
X-Gm-Message-State: ANhLgQ3RaVEARvPxpgmK5SlYGWEBihPy17kILL+9ZQJordK5n97fa/Mc
        hVCBQ1JMJH3ql311jybrnaDsdfIMzMA=
X-Google-Smtp-Source: ADFU+vvinw58NCE+kfA6bwp/jFg6oRThGsjJnIbYW+iFfsaCapClteryDMU1u3wS2yXtOYeRMKgsMQ==
X-Received: by 2002:a63:af52:: with SMTP id s18mr5890775pgo.281.1583543058204;
        Fri, 06 Mar 2020 17:04:18 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id o66sm23224949pfb.93.2020.03.06.17.04.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Mar 2020 17:04:17 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v4 net-next 1/8] ionic: keep ionic dev on lif init fail
Date:   Fri,  6 Mar 2020 17:04:01 -0800
Message-Id: <20200307010408.65704-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200307010408.65704-1-snelson@pensando.io>
References: <20200307010408.65704-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the basic ionic interface works but the lif creation fails,
don't fail the probe.  This will allow us to use the driver to
help inspect the hw/fw/pci interface for debugging purposes.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_bus_pci.c   | 21 ++++++++++++++-----
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  3 +++
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 448d7b23b2f7..0ac6acbc5f31 100644
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
@@ -369,11 +377,14 @@ static void ionic_remove(struct pci_dev *pdev)
 	if (!ionic)
 		return;
 
-	ionic_devlink_unregister(ionic);
-	ionic_lifs_unregister(ionic);
-	ionic_lifs_deinit(ionic);
-	ionic_lifs_free(ionic);
-	ionic_bus_free_irq_vectors(ionic);
+	if (ionic->master_lif) {
+		ionic_devlink_unregister(ionic);
+		ionic_lifs_unregister(ionic);
+		ionic_lifs_deinit(ionic);
+		ionic_lifs_free(ionic);
+		ionic_bus_free_irq_vectors(ionic);
+	}
+
 	ionic_port_reset(ionic);
 	ionic_reset(ionic);
 	ionic_dev_teardown(ionic);
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

