Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9290269D71
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 06:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgIOEZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 00:25:33 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44690 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgIOEZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 00:25:09 -0400
Received: by mail-pg1-f194.google.com with SMTP id 7so1275946pgm.11;
        Mon, 14 Sep 2020 21:25:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HmHolgvrbuagVXTL4BA3meP6qEGQOiV1kQvj6Hedeks=;
        b=sqpJQojQW3NGFzOOC9jfLuAVA7bax6JCc9nnq9U7wpwY7k1jpBWhsnYNK33d9dNDK7
         1r8D9kNjXHu5yRpeMMiTMafyeKokvXHZJ7z5921O7R+ROdQJGukTd98VYOIe/sGt3/gk
         Lla97Q4Igb53S/aEX09OR6dWuP9+nW5Bo/cTRCoPBzPAf4EAClVekwQw8KJVOQgnTQnv
         MBgwYg4iR9s0bxrQq2nYw58hP+j2mOx1GwqU/IZXmn/yF8JJIyUxQNUfv8DwcMhokYDE
         E0UM0TlWEPXNhDdpVk+04gB7suFrcFMxlFW99G+pjhFtlWi7syFKM4UgScntnQAEYYlm
         1Mtg==
X-Gm-Message-State: AOAM533ORC6+6tnlzw01XHZE9OHgNtZVZYnR9mjPCevyIv3jjPUoSts+
        l8iZIg8oaeaQ/vSwNQxK/Sw=
X-Google-Smtp-Source: ABdhPJzr5hqDtRuoKMCCbApHHYEm1y/ARC9VSbVQlQGag/jlbY/XJtHLKoQkBRu6c18iJtfx8kPKxA==
X-Received: by 2002:aa7:9e4e:0:b029:13c:1611:6589 with SMTP id z14-20020aa79e4e0000b029013c16116589mr16397171pfq.6.1600143906302;
        Mon, 14 Sep 2020 21:25:06 -0700 (PDT)
Received: from localhost ([2601:647:5b00:1162:1ac0:17a6:4cc6:d1ef])
        by smtp.gmail.com with ESMTPSA id k4sm2172417pga.76.2020.09.14.21.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 21:25:05 -0700 (PDT)
From:   Moritz Fischer <mdf@kernel.org>
To:     davem@davemloft.net
Cc:     snelson@pensando.io, mst@redhat.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, moritzf@google.com,
        Moritz Fischer <mdf@kernel.org>
Subject: [PATCH net-next v2 2/3] net: dec: tulip: de2104x: Replace pci_enable_device with devres version
Date:   Mon, 14 Sep 2020 21:24:51 -0700
Message-Id: <20200915042452.26155-3-mdf@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915042452.26155-1-mdf@kernel.org>
References: <20200915042452.26155-1-mdf@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace pci_enable_device() with its devres counterpart
pcim_enable_device().

Signed-off-by: Moritz Fischer <mdf@kernel.org>
---

Note: Please check my logic on this, it would seem to me
calling pci_disable_device() on devices enabled with
pcim_enable_device() *should* be fine.

Changes from v1:
- Fixed missing replace for resume function
---
 drivers/net/ethernet/dec/tulip/de2104x.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
index 9bcfc82b71d1..698d79bc4784 100644
--- a/drivers/net/ethernet/dec/tulip/de2104x.c
+++ b/drivers/net/ethernet/dec/tulip/de2104x.c
@@ -2009,14 +2009,14 @@ static int de_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netif_carrier_off(dev);
 
 	/* wake up device, assign resources */
-	rc = pci_enable_device(pdev);
+	rc = pcim_enable_device(pdev);
 	if (rc)
 		return rc;
 
 	/* reserve PCI resources to ensure driver atomicity */
 	rc = pci_request_regions(pdev, DRV_NAME);
 	if (rc)
-		goto err_out_disable;
+		return rc;
 
 	/* check for invalid IRQ value */
 	if (pdev->irq < 2) {
@@ -2096,8 +2096,6 @@ static int de_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	iounmap(regs);
 err_out_res:
 	pci_release_regions(pdev);
-err_out_disable:
-	pci_disable_device(pdev);
 	return rc;
 }
 
@@ -2111,7 +2109,6 @@ static void de_remove_one(struct pci_dev *pdev)
 	kfree(de->ee_data);
 	iounmap(de->regs);
 	pci_release_regions(pdev);
-	pci_disable_device(pdev);
 }
 
 #ifdef CONFIG_PM
@@ -2164,7 +2161,7 @@ static int de_resume (struct pci_dev *pdev)
 		goto out;
 	if (!netif_running(dev))
 		goto out_attach;
-	if ((retval = pci_enable_device(pdev))) {
+	if ((retval = pcim_enable_device(pdev))) {
 		netdev_err(dev, "pci_enable_device failed in resume\n");
 		goto out;
 	}
-- 
2.28.0

