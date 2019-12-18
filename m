Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCF10123BA9
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 01:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfLRAfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 19:35:20 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46156 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfLRAfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 19:35:20 -0500
Received: by mail-wr1-f66.google.com with SMTP id z7so362623wrl.13;
        Tue, 17 Dec 2019 16:35:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=DBUq5EnVFqtnsDMr8VZJJ/QiTMGM16+brSy6lgi8AcA=;
        b=V4b7gCmTjHhacC7eRsl3tBh8pyxCxhzeD9tfHyXhQdWlK2NHqjUIeW08cVlCV2PRWX
         V9C2cI1qPSvF80gvkzDX47xc9+yznKBOEc9+In0CIY5cAcKOVAqOEXeuZRAtoD0SuaK4
         hBxNnc6MXi+BfZwS1tC5NXk1+gUwIZSybUDoUwdJIY+ctx0PQ7uj+aYWb4DJv3BMTjGh
         Zb+e13ZOiwkchU1moBJYryfs5W/fMjs2h+5MVtUhX3A9Jciy1IKIB7iUnzowWoO41xjZ
         TCGKzWXHQyHPOdVk1CMn+PwE770JiZxCCBEeXp2jKiKbSwS8fgcPECTKvHXnAfXnsy4N
         6heg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DBUq5EnVFqtnsDMr8VZJJ/QiTMGM16+brSy6lgi8AcA=;
        b=atN1AVGsv3bFQddgqSHjA2bUMR8ArcO8jRmPecktkmTYmXDtSmVBedF+NmbiWrdhg8
         DSDaq7/EkYOIEtLq/yKy9ntRBwkwZhOnzqAJNIRGocgLHcJRNfEm8M0p4oJLwau9RkSU
         veF9zrjlKnTJ10kjj7rNRIHN/T95ux34ig/ZixA4IvP3k2ANQWsqDW6tK4/Z3sBk/kES
         yQOr7v6MH8bE5ce0KWoTu+ug9NnHmsEaMjHji4+YPPUUKc+tjkNEegphqifKZLgSpSBb
         ZO/8V/8mXfWVKXmsKkgPgkDQjql6SKK7pWmtMBggTd87zZeAjBMuFA2zdsg/1hlJx+/S
         cS2Q==
X-Gm-Message-State: APjAAAVW0hIz4G5/AoJaN51Tjc+SKlrBt9iOQdgcTlm1JHsTJNcaLHDz
        PpUaIBBJ3xdG+v1jm0DiOxxGYyEu
X-Google-Smtp-Source: APXvYqz1pmukxUADdnQaos/gzxB8lCVwkK7WqXOV/I0+jI+2k8K2M4z1giqWrmse8KfGKZ7GX4MmWQ==
X-Received: by 2002:adf:f052:: with SMTP id t18mr548266wro.192.1576629317810;
        Tue, 17 Dec 2019 16:35:17 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s82sm567395wms.28.2019.12.17.16.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 16:35:17 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     jakub.kicinski@netronome.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM SYSTEMPORT
        ETHERNET DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: systemport: Set correct DMA mask
Date:   Tue, 17 Dec 2019 16:29:50 -0800
Message-Id: <20191218002950.2125-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SYSTEMPORT is capabable of doing up to 40-bit of physical addresses, set
an appropriate DMA mask to permit that.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 8e3152779a61..1907e47fd0af 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2427,6 +2427,14 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 	if (!of_id || !of_id->data)
 		return -EINVAL;
 
+	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(40));
+	if (ret)
+		ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	if (ret) {
+		dev_err(&pdev->dev, "unable to set DMA mask: %d\n", ret);
+		return ret;
+	}
+
 	/* Fairly quickly we need to know the type of adapter we have */
 	params = of_id->data;
 
-- 
2.17.1

