Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6BFADE166
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 02:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfJUAKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 20:10:35 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:35199 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfJUAKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 20:10:34 -0400
Received: by mail-lf1-f65.google.com with SMTP id y6so2296530lfj.2
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 17:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kkHVPrwW+udBDpjAVf93ePr4kr7CnBbxsMjmX8osV5o=;
        b=VQit91pF8e5h0je2IrXBZjvqhweZKHs/fnKtt4b1yfmIyboo7b6zrjHF3srL8BPXIk
         gvdWDNH0BuAy7iKpY26ZeqlahiRcU3cWChG8eox2o7tqK/sgWiEhN+I5r5UaQMIoagnU
         qGKzPTRohi+ZDVeVA8R3AV49WJ3ILlMyLzWcSfXtNRwz0oDMgLhEIIzbOopUkZLH/oGb
         FNqCbGxfm/f32fxB5Bus8e0kEuvj3PVN+TUO81mVn1sDoyQsNrDy8UY9qTiXAjWZctx6
         peD3F5SoSQDnSoU79Jr1oF97ZkvZ+gIh5KyarUsqi1lKpvt5/1L59SBDAPID2TCS6zgN
         88bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kkHVPrwW+udBDpjAVf93ePr4kr7CnBbxsMjmX8osV5o=;
        b=ShvlV1aJtWXwCaDQ3xIUWCyJGlcJuhM3vaoZ+FZVcCKCjoajt9K6k/3q8EtByesz4K
         BOKBUjqvbo1VkgJRa/WCd8Bg2Gy7kUX5xk98NWbzb48Q9Gopu3DwFSCeHwzKgZoxCSXx
         xZdvxH6zWgLLTmCq3EPncGcFljBFDJZaqS7eNdw1a1Eb3jh1MQqcgCpwgNP1Wq+CorK0
         SuxHyprWGjsknj5fDcNPCnxEcYrVPxbJaDtBsj630yojIMNKIB7pDic1d3XR3sI/bfSX
         fuCS7+RFzITldUtjZ623f70JJ7sMxZr4xmUU3CE1sgiQnDA0C1pPknGhGCGwNyZWGqUv
         TuIQ==
X-Gm-Message-State: APjAAAX9vjMDVeDQ9HgfCx1RWgXxygGqysjHtCdtvYdADA1vNCEYpeuJ
        evlP60fSIycE/4SQjfaX3LLdfRpsLGg=
X-Google-Smtp-Source: APXvYqyoR3pjF3oYDFveupK1joCwQCvKMrpJjsrfnRrTURD977nvEQlCwip3QFrHaysfRvsXHLYYmw==
X-Received: by 2002:a19:ed16:: with SMTP id y22mr2359217lfy.166.1571616632149;
        Sun, 20 Oct 2019 17:10:32 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-79c8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.200.121])
        by smtp.gmail.com with ESMTPSA id a18sm2723081lfi.15.2019.10.20.17.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2019 17:10:27 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 07/10] net: ehernet: ixp4xx: Use devm_alloc_etherdev()
Date:   Mon, 21 Oct 2019 02:08:21 +0200
Message-Id: <20191021000824.531-8-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191021000824.531-1-linus.walleij@linaro.org>
References: <20191021000824.531-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using the devm_alloc_etherdev() function simplifies the error
path. I also patch the message to use dev_info().

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index fbe328693de5..df18d8ebb170 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1378,7 +1378,7 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 
 	plat = dev_get_platdata(dev);
 
-	if (!(ndev = alloc_etherdev(sizeof(struct port))))
+	if (!(ndev = devm_alloc_etherdev(dev, sizeof(struct port))))
 		return -ENOMEM;
 
 	SET_NETDEV_DEV(ndev, dev);
@@ -1432,8 +1432,7 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 		regs_phys  = IXP4XX_EthC_BASE_PHYS;
 		break;
 	default:
-		err = -ENODEV;
-		goto err_free;
+		return -ENODEV;
 	}
 
 	ndev->netdev_ops = &ixp4xx_netdev_ops;
@@ -1442,10 +1441,8 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 
 	netif_napi_add(ndev, &port->napi, eth_poll, NAPI_WEIGHT);
 
-	if (!(port->npe = npe_request(NPE_ID(port->id)))) {
-		err = -EIO;
-		goto err_free;
-	}
+	if (!(port->npe = npe_request(NPE_ID(port->id))))
+		return -EIO;
 
 	port->mem_res = request_mem_region(regs_phys, REGS_SIZE, ndev->name);
 	if (!port->mem_res) {
@@ -1479,8 +1476,8 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	if ((err = register_netdev(ndev)))
 		goto err_phy_dis;
 
-	printk(KERN_INFO "%s: MII PHY %i on %s\n", ndev->name, plat->phy,
-	       npe_name(port->npe));
+	dev_info(dev, "%s: MII PHY %i on %s\n", ndev->name, plat->phy,
+		 npe_name(port->npe));
 
 	return 0;
 
@@ -1491,8 +1488,6 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	release_resource(port->mem_res);
 err_npe_rel:
 	npe_release(port->npe);
-err_free:
-	free_netdev(ndev);
 	return err;
 }
 
@@ -1508,7 +1503,6 @@ static int ixp4xx_eth_remove(struct platform_device *pdev)
 	npe_port_tab[NPE_ID(port->id)] = NULL;
 	npe_release(port->npe);
 	release_resource(port->mem_res);
-	free_netdev(ndev);
 	return 0;
 }
 
-- 
2.21.0

