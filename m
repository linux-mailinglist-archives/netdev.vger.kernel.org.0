Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71557269D6B
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 06:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgIOEZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 00:25:14 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46674 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbgIOEZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 00:25:05 -0400
Received: by mail-pg1-f196.google.com with SMTP id 34so1264778pgo.13;
        Mon, 14 Sep 2020 21:25:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=deF/Fb8nYOYqTWT29+DXa40R35LsuxAmpivI4tm7Tbc=;
        b=AXgb6zcO9yXIhAQ01mNLOARK8Gedfa1aQbgPmZVs3sl3fO6QYy6em2VStY183+rXVp
         x+H5ZJrHiz/5jCWuzH4x8v5XcICSmnq3hi97qC4zzU1mSTeBpunyjnKaeeE0xAysQg/z
         iRYppgXi2KoStm148ggT9OHjdGmKivF0NDGcT1Q7AdmDYak2i6cOotXiD0Lol/fXuhZt
         aaYuH7IkIOGM+4romyViMV7kdkUnruKBlZo8P+c9sFWLCxNyTgdWFbDMBK4zgRKvBOEi
         1ZgQXfsPehyrIaMWnNzZbZowx7lFpzJ+3MSisH3bOthAkneJKEGFie6gEfXCpHA5ewPS
         4qvA==
X-Gm-Message-State: AOAM530Xx9yqwEQ0m0/5YM7fcljVfZYL7oOAyGeMM3Q7tMUzgkRFjDh7
        n8heq0TKG8LJjr1l3AM0Dmk=
X-Google-Smtp-Source: ABdhPJxSuO5fCxCjxpUwsmWROo4G6Nu+y4ib2eGNg5Zco6p9UQXh4QWcAs3VET3qPVlpjZetUoaxtg==
X-Received: by 2002:a63:4625:: with SMTP id t37mr8263179pga.180.1600143905087;
        Mon, 14 Sep 2020 21:25:05 -0700 (PDT)
Received: from localhost ([2601:647:5b00:1162:1ac0:17a6:4cc6:d1ef])
        by smtp.gmail.com with ESMTPSA id r123sm12080741pfc.187.2020.09.14.21.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 21:25:04 -0700 (PDT)
From:   Moritz Fischer <mdf@kernel.org>
To:     davem@davemloft.net
Cc:     snelson@pensando.io, mst@redhat.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, moritzf@google.com,
        Moritz Fischer <mdf@kernel.org>
Subject: [PATCH net-next v2 1/3] net: dec: tulip: de2104x: Replace alloc_etherdev by devm_alloc_etherdev
Date:   Mon, 14 Sep 2020 21:24:50 -0700
Message-Id: <20200915042452.26155-2-mdf@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915042452.26155-1-mdf@kernel.org>
References: <20200915042452.26155-1-mdf@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace devm_alloc_etherdev() with its devres version.

Signed-off-by: Moritz Fischer <mdf@kernel.org>
---
 drivers/net/ethernet/dec/tulip/de2104x.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
index 42b798a3fad4..9bcfc82b71d1 100644
--- a/drivers/net/ethernet/dec/tulip/de2104x.c
+++ b/drivers/net/ethernet/dec/tulip/de2104x.c
@@ -1986,7 +1986,7 @@ static int de_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 #endif
 
 	/* allocate a new ethernet device structure, and fill in defaults */
-	dev = alloc_etherdev(sizeof(struct de_private));
+	dev = devm_alloc_etherdev(&pdev->dev, sizeof(struct de_private));
 	if (!dev)
 		return -ENOMEM;
 
@@ -2011,7 +2011,7 @@ static int de_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* wake up device, assign resources */
 	rc = pci_enable_device(pdev);
 	if (rc)
-		goto err_out_free;
+		return rc;
 
 	/* reserve PCI resources to ensure driver atomicity */
 	rc = pci_request_regions(pdev, DRV_NAME);
@@ -2098,8 +2098,6 @@ static int de_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_release_regions(pdev);
 err_out_disable:
 	pci_disable_device(pdev);
-err_out_free:
-	free_netdev(dev);
 	return rc;
 }
 
@@ -2114,7 +2112,6 @@ static void de_remove_one(struct pci_dev *pdev)
 	iounmap(de->regs);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-	free_netdev(dev);
 }
 
 #ifdef CONFIG_PM
-- 
2.28.0

