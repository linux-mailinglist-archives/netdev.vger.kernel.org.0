Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B144989CC
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344250AbiAXS6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344438AbiAXSyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:54:40 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89FAC06176F
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:28 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id 192so13467675pfz.3
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 10:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ra8Ps2jZvFPDf3HnLFC6X3YCeKlI5Q4v2gjiu5SN0hc=;
        b=zRA9DFJ/Tz9BQPiOiQAgGls/GtRnOXHxzeyynRC82dY1YlUQd5agxMtsofcK617x7k
         aSiDJHidkeavImGzXwSuVAJOfiPW10TPI8uoMX1wirLkFm6IEDdXZpycpmjAAZxTo4yh
         8jSgS6fQD72VbP2Z576ERxvUC4kMQkYr/d6PsCzWdJOQMYRp6DjhB4F1YDrxoQ6OYuMH
         yZAEytH2prYsPmWHxjGMx+lR2Yz4pn91kCIOQl7vFqJNwxI5yOBWQHBr6bMFxsv7YHvh
         sIYXNNL0phOJXD4vNo4jR3QDUtr+TK9YXuRYjglnepK35/5/S1oR7PceZOrwxSngJJuB
         rcnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ra8Ps2jZvFPDf3HnLFC6X3YCeKlI5Q4v2gjiu5SN0hc=;
        b=iC9WXmTDBqcD9mxgItva4MzM9qAYvx9qx05bRKMcbyWaWw57EpPxwqXDK8ndjjgk7Q
         GSMlXxtH4nWAQ8kmrdIEYZxcl2fD8pm8UvcBPC3xR2XZClXIs48SGbPYQIwFuPALnynP
         y9Oilr0/BS+8LRqetqzN7Dfb5IEDQpXmHJrncf/+wDju9JrQ9FOLivhGPzIYSvSrSGGc
         NTKczkMfBlb+7fPWeWPD6vctC8OwIeVoHZvJiDmRxSfUUgMsRljYrPd3VN5Dp87ue2nT
         xz+fFuus+PQTWzlPxoaPD9qlbGZ1jGai+WhpNQzGzu/eBZ+arTFWZYzavMjegc94kQms
         4ojg==
X-Gm-Message-State: AOAM533hWQjS59L4CiUZfS4wmilQLOmOXNxcpDgO/HJdicRE3VpanU53
        RA51OAgkH30xoqFe3+W5ZnCbcw==
X-Google-Smtp-Source: ABdhPJyw6o3a9YTBM582yXU26suZPOMT0H5JcU/RQ1myW1Ew2hR4NW7oWa2LrebgTLp8hC0D1NynwA==
X-Received: by 2002:a05:6a00:18a6:b0:4ca:38e0:400d with SMTP id x38-20020a056a0018a600b004ca38e0400dmr2259677pfh.22.1643050408453;
        Mon, 24 Jan 2022 10:53:28 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id cq14sm85177pjb.33.2022.01.24.10.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 10:53:28 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 02/16] ionic: start watchdog after all is setup
Date:   Mon, 24 Jan 2022 10:52:58 -0800
Message-Id: <20220124185312.72646-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220124185312.72646-1-snelson@pensando.io>
References: <20220124185312.72646-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The watchdog expects the lif to fully exist when it goes off,
so lets not start the watchdog until all is ready in case there
is some quirky time dialation that makes probe take multiple
seconds.

Fixes: 089406bc5ad6 ("ionic: add a watchdog timer to monitor heartbeat")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c | 4 +++-
 drivers/net/ethernet/pensando/ionic/ionic_dev.c     | 3 ---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 7e296fa71b36..40fa5bce2ac2 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -331,6 +331,9 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out_deregister_lifs;
 	}
 
+	mod_timer(&ionic->watchdog_timer,
+		  round_jiffies(jiffies + ionic->watchdog_period));
+
 	return 0;
 
 err_out_deregister_lifs:
@@ -348,7 +351,6 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_out_reset:
 	ionic_reset(ionic);
 err_out_teardown:
-	del_timer_sync(&ionic->watchdog_timer);
 	pci_clear_master(pdev);
 	/* Don't fail the probe for these errors, keep
 	 * the hw interface around for inspection
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index d57e80d44c9d..4044c630f8b4 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -122,9 +122,6 @@ int ionic_dev_setup(struct ionic *ionic)
 	idev->fw_generation = IONIC_FW_STS_F_GENERATION &
 			      ioread8(&idev->dev_info_regs->fw_status);
 
-	mod_timer(&ionic->watchdog_timer,
-		  round_jiffies(jiffies + ionic->watchdog_period));
-
 	idev->db_pages = bar->vaddr;
 	idev->phy_db_pages = bar->bus_addr;
 
-- 
2.17.1

