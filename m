Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12E12F037D
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 21:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbhAIUfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 15:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbhAIUfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 15:35:11 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A838C061786
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 12:34:31 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id y24so14723840edt.10
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 12:34:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3h+LjHYgxPVyC1T6XpepcyH48UKw/gGTg3pw1KUNu1Y=;
        b=r5SYxzgrurQLFTm2eL9nnNyR702hNruRtGpennaFwLIAKpxoMEb7oCONUKXsb6YroK
         JfVyDQLU9IPXPUE1sxwIFt/9AwN72UN4DWJJPvFrfwVH12HeRFJzhLyvC8gAoy6DkZfE
         e9pXOjFT9XLBR8fl1xJXLvuCChCyPwdHXDyqR5z9xeir7dpsw8lFW3zEVAZC73VIs4Yf
         o0HXzQsFCIT5RNcFDLfLATtdn5x5/UtA2C23YIstqRoZGSeEgKEZ6rojKF8tF/nQkNoy
         t+sMmfqBIzZtwrqJQUy5iCVey6MdWokJe+hLLcTRr4tKPF3teyhkxwl+vgtIxFvGNEWP
         s0aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3h+LjHYgxPVyC1T6XpepcyH48UKw/gGTg3pw1KUNu1Y=;
        b=Ba7XdZ6M6nn4ajR80PsnfR1nZ8zgM53Al9eaaEq40EVyToYEQTic7tJxV7zjd6bvF7
         QBCBdNdYEmsRVLbd0mJsp+coZIgcALtxksJS+B4/V9jhAc1CLHlzXuJSRAS2TjXsBBRz
         RYiPQuIsMgFzyEBYAHzYZdavpwvtMSBuerATQMt9noq9WtiT9iSdjef+2WWcr9MEvhbn
         Bd5YG2qlwMrUMi6SgZUOamS5IvLj3F77FkEMP+iAskHzYV/PDVkiksXeOa6Tw4HDU76q
         XeyInlfpeB+Z8SzUNXKqsVsvv3V72MD51I03qX+z996wqWyJIgZ8nWp7ya3/fD8xHSRe
         OLmQ==
X-Gm-Message-State: AOAM531Q6KQV/afgIoqU+f6ZYpHH5zM1px7dA1+LF9OBBL1KsIMwHJG2
        7wGAvaUN/B89mxVnAYR/nlY6/hPdbiE=
X-Google-Smtp-Source: ABdhPJxQ2LaTWG03yxSIYhwnuceVeOfMC+GaQwnk0P3FVQd38N9tNcY4wtv2Xqx37YcyB6sp4KZG8A==
X-Received: by 2002:a05:6402:388:: with SMTP id o8mr9380656edv.359.1610224469966;
        Sat, 09 Jan 2021 12:34:29 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h23sm4960465ejg.37.2021.01.09.12.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 12:34:29 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Subject: [PATCH net-next] net: dsa: felix: the switch does not support DMA
Date:   Sat,  9 Jan 2021 22:34:15 +0200
Message-Id: <20210109203415.2120142-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The code that sets the DMA mask to 64 bits is bogus, it is taken from
the enetc driver together with the rest of the PCI probing boilerplate.

Since this patch is touching the error path to delete err_dma, let's
also change the err_alloc_felix label which was incorrect. The kzalloc
failure does not need a kfree, but it doesn't hurt either, since kfree
works with NULL pointers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 2e5bbdca5ea4..a87597eef8cf 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1408,17 +1408,6 @@ static int felix_pci_probe(struct pci_dev *pdev,
 		goto err_pci_enable;
 	}
 
-	/* set up for high or low dma */
-	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
-	if (err) {
-		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
-		if (err) {
-			dev_err(&pdev->dev,
-				"DMA configuration failed: 0x%x\n", err);
-			goto err_dma;
-		}
-	}
-
 	felix = kzalloc(sizeof(struct felix), GFP_KERNEL);
 	if (!felix) {
 		err = -ENOMEM;
@@ -1474,9 +1463,8 @@ static int felix_pci_probe(struct pci_dev *pdev,
 	kfree(ds);
 err_alloc_ds:
 err_alloc_irq:
-err_alloc_felix:
 	kfree(felix);
-err_dma:
+err_alloc_felix:
 	pci_disable_device(pdev);
 err_pci_enable:
 	return err;
-- 
2.25.1

