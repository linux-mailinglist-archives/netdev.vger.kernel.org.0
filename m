Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAE318EC36
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 21:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgCVUkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 16:40:46 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39802 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbgCVUkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 16:40:45 -0400
Received: by mail-pg1-f195.google.com with SMTP id b22so6070632pgb.6
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 13:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dMvs4qwyLZNH3nsO6ocIhNLYNWrmgGsr92z0U+yTVaM=;
        b=iM+9ScPIkY97XiReIR5dKnAgkHZVB5er6Pu5q0WRqyKtUb63ZIKgjoL8C5vvFjk//+
         uP+4kdRWK4MwwYJtrwPfTHO4Mofliehk23aRJLSHvVlWH+CuwpE40lcEBPAsymh98Y3b
         H32Z82DDgHMcz9SvKPKRU7HMUaw5gU7Tg6+RA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dMvs4qwyLZNH3nsO6ocIhNLYNWrmgGsr92z0U+yTVaM=;
        b=V4Mq3lb3QFn2H47sZ2RPRxekY4gToW1kn4IOepT0/MGc6BQo370J24xQTUkE4i6dNQ
         lXyLTf5PvK51q3ilKmKU75tjzU9zQHuAGWV+myp3zAkvldymaT94t/1qUk4X48QRx1bM
         Y0CvkAiOpkRSGKBh6ZnzXBn1rx7cUimvoDGow7zsrPgJwbAa3XHMnC/afKhZCq/GkbES
         lEjvrXNJHyLeKELeGZxMFqcFb/WLwngxhgaQpiSX5Vhe8nQhvHdOX2RhpMO9yjzyH/XF
         anGr4xWYjIzaLgx632CAlyJieLrr87UL898hprC8XuW8XI7i84U4spymF99Kir7m0ksl
         tCeA==
X-Gm-Message-State: ANhLgQ0YIIg7DlLBFJTEgw5P6wVy0iZm7nAeEUbYozn+CCItiLV72xGP
        Qhf0nnrs71e2Ar1klNfo14DnjA==
X-Google-Smtp-Source: ADFU+vtERUcL3l2XrU6sLUFgaRSYDWacFagdDXPtwYs9EEU9qF2QOziZTVcFRc3ottPdbZxaR060+g==
X-Received: by 2002:a63:9a42:: with SMTP id e2mr17780955pgo.297.1584909643915;
        Sun, 22 Mar 2020 13:40:43 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y131sm11575843pfb.78.2020.03.22.13.40.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Mar 2020 13:40:43 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 4/5] bnxt_en: Free context memory after disabling PCI in probe error path.
Date:   Sun, 22 Mar 2020 16:40:04 -0400
Message-Id: <1584909605-19161-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584909605-19161-1-git-send-email-michael.chan@broadcom.com>
References: <1584909605-19161-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Other shutdown code paths will always disable PCI first to shutdown DMA
before freeing context memory.  Do the same sequence in the error path
of probe to be safe and consistent.

Fixes: c20dc142dd7b ("bnxt_en: Disable bus master during PCI shutdown and driver unload.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 0628a6a..95f4c02 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11970,12 +11970,12 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	bnxt_hwrm_func_drv_unrgtr(bp);
 	bnxt_free_hwrm_short_cmd_req(bp);
 	bnxt_free_hwrm_resources(bp);
-	bnxt_free_ctx_mem(bp);
-	kfree(bp->ctx);
-	bp->ctx = NULL;
 	kfree(bp->fw_health);
 	bp->fw_health = NULL;
 	bnxt_cleanup_pci(bp);
+	bnxt_free_ctx_mem(bp);
+	kfree(bp->ctx);
+	bp->ctx = NULL;
 
 init_err_free:
 	free_netdev(dev);
-- 
2.5.1

