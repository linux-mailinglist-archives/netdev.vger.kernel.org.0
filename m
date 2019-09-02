Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D994A53E8
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 12:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730640AbfIBKWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 06:22:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38492 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729489AbfIBKWo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 06:22:44 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 79B6D3CA06
        for <netdev@vger.kernel.org>; Mon,  2 Sep 2019 10:22:43 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id o5so8560888wrg.15
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 03:22:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uYlK6QI4FJuSi+NVELKHQCxpvfJb7issMkJStovlq7g=;
        b=sPlKAUWaEjSKWlMg+bhE0KrnYnt/mSNcnqnd8XqIp/2rfnShYYJ94qpdpUC3wMvseI
         CYTsQt5LOhoqhucBeCHezDiwaittCauojX+0+x8D1s3yG6EulEeEtj5ar+b1RiODhjbz
         r3Inv3bfKlnePMvTjd0WKCfebeIHglwJTt4GsO8tuv6bVVyeblQSrn7ZD1NDJJrJCMGV
         eebaGU6xyroOjBkMw4hYlvZ+UacbpyLBWWq/Vgl7FglMLLtTy/UfIEnozrQhAbl7uCjk
         CGv2g3SXePRhmMmz8nb4iREnEO/ESC3lmZ7X+1E+bkSZxwseUMykLGC2EKOFANifsNGN
         7xDA==
X-Gm-Message-State: APjAAAVONWNsdTPJZCJEBkEvxbJtrj+grfQ/16jtcOPTXEq6mJGSJ/iX
        vPWn56+owp6Hvozxiy7OwKPZZbp0AeldpneySpzYFW4IUqXBIXOyMm0z8as9Wl483hnVx0KfVET
        gItETpgkrtt6D2XMD
X-Received: by 2002:a05:600c:2111:: with SMTP id u17mr36512709wml.64.1567419760670;
        Mon, 02 Sep 2019 03:22:40 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxuhLcHy/1QVFk0n0VNx0oSvOa8rSLK8XVGuHeSFOxDJzAgBVeks8gZL/vABqBcyS4Mqyr4sg==
X-Received: by 2002:a05:600c:2111:: with SMTP id u17mr36512669wml.64.1567419760369;
        Mon, 02 Sep 2019 03:22:40 -0700 (PDT)
Received: from mcroce-redhat.redhat.com (host221-208-dynamic.27-79-r.retail.telecomitalia.it. [79.27.208.221])
        by smtp.gmail.com with ESMTPSA id h23sm15824669wml.43.2019.09.02.03.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2019 03:22:39 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next 1/2] mvpp2: refactor BM pool functions
Date:   Mon,  2 Sep 2019 12:21:36 +0200
Message-Id: <20190902102137.841-2-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190902102137.841-1-mcroce@redhat.com>
References: <20190902102137.841-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor mvpp2_bm_pool_create(), mvpp2_bm_pool_destroy() and
mvpp2_bm_pools_init() so that they accept a struct device instead
of a struct platform_device, as they just need platform_device->dev.

Removing such dependency makes the BM code more reusable in context
where we don't have a pointer to the platform_device.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 35 +++++++++----------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index ccdd47f3b8fb..871f14cc7284 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -323,8 +323,7 @@ static void mvpp2_frag_free(const struct mvpp2_bm_pool *pool, void *data)
 /* Buffer Manager configuration routines */
 
 /* Create pool */
-static int mvpp2_bm_pool_create(struct platform_device *pdev,
-				struct mvpp2 *priv,
+static int mvpp2_bm_pool_create(struct device *dev, struct mvpp2 *priv,
 				struct mvpp2_bm_pool *bm_pool, int size)
 {
 	u32 val;
@@ -343,7 +342,7 @@ static int mvpp2_bm_pool_create(struct platform_device *pdev,
 	else
 		bm_pool->size_bytes = 2 * sizeof(u64) * size;
 
-	bm_pool->virt_addr = dma_alloc_coherent(&pdev->dev, bm_pool->size_bytes,
+	bm_pool->virt_addr = dma_alloc_coherent(dev, bm_pool->size_bytes,
 						&bm_pool->dma_addr,
 						GFP_KERNEL);
 	if (!bm_pool->virt_addr)
@@ -351,9 +350,9 @@ static int mvpp2_bm_pool_create(struct platform_device *pdev,
 
 	if (!IS_ALIGNED((unsigned long)bm_pool->virt_addr,
 			MVPP2_BM_POOL_PTR_ALIGN)) {
-		dma_free_coherent(&pdev->dev, bm_pool->size_bytes,
+		dma_free_coherent(dev, bm_pool->size_bytes,
 				  bm_pool->virt_addr, bm_pool->dma_addr);
-		dev_err(&pdev->dev, "BM pool %d is not %d bytes aligned\n",
+		dev_err(dev, "BM pool %d is not %d bytes aligned\n",
 			bm_pool->id, MVPP2_BM_POOL_PTR_ALIGN);
 		return -ENOMEM;
 	}
@@ -468,15 +467,14 @@ static int mvpp2_check_hw_buf_num(struct mvpp2 *priv, struct mvpp2_bm_pool *bm_p
 }
 
 /* Cleanup pool */
-static int mvpp2_bm_pool_destroy(struct platform_device *pdev,
-				 struct mvpp2 *priv,
+static int mvpp2_bm_pool_destroy(struct device *dev, struct mvpp2 *priv,
 				 struct mvpp2_bm_pool *bm_pool)
 {
 	int buf_num;
 	u32 val;
 
 	buf_num = mvpp2_check_hw_buf_num(priv, bm_pool);
-	mvpp2_bm_bufs_free(&pdev->dev, priv, bm_pool, buf_num);
+	mvpp2_bm_bufs_free(dev, priv, bm_pool, buf_num);
 
 	/* Check buffer counters after free */
 	buf_num = mvpp2_check_hw_buf_num(priv, bm_pool);
@@ -490,14 +488,13 @@ static int mvpp2_bm_pool_destroy(struct platform_device *pdev,
 	val |= MVPP2_BM_STOP_MASK;
 	mvpp2_write(priv, MVPP2_BM_POOL_CTRL_REG(bm_pool->id), val);
 
-	dma_free_coherent(&pdev->dev, bm_pool->size_bytes,
+	dma_free_coherent(dev, bm_pool->size_bytes,
 			  bm_pool->virt_addr,
 			  bm_pool->dma_addr);
 	return 0;
 }
 
-static int mvpp2_bm_pools_init(struct platform_device *pdev,
-			       struct mvpp2 *priv)
+static int mvpp2_bm_pools_init(struct device *dev, struct mvpp2 *priv)
 {
 	int i, err, size;
 	struct mvpp2_bm_pool *bm_pool;
@@ -507,7 +504,7 @@ static int mvpp2_bm_pools_init(struct platform_device *pdev,
 	for (i = 0; i < MVPP2_BM_POOLS_NUM; i++) {
 		bm_pool = &priv->bm_pools[i];
 		bm_pool->id = i;
-		err = mvpp2_bm_pool_create(pdev, priv, bm_pool, size);
+		err = mvpp2_bm_pool_create(dev, priv, bm_pool, size);
 		if (err)
 			goto err_unroll_pools;
 		mvpp2_bm_pool_bufsize_set(priv, bm_pool, 0);
@@ -515,13 +512,13 @@ static int mvpp2_bm_pools_init(struct platform_device *pdev,
 	return 0;
 
 err_unroll_pools:
-	dev_err(&pdev->dev, "failed to create BM pool %d, size %d\n", i, size);
+	dev_err(dev, "failed to create BM pool %d, size %d\n", i, size);
 	for (i = i - 1; i >= 0; i--)
-		mvpp2_bm_pool_destroy(pdev, priv, &priv->bm_pools[i]);
+		mvpp2_bm_pool_destroy(dev, priv, &priv->bm_pools[i]);
 	return err;
 }
 
-static int mvpp2_bm_init(struct platform_device *pdev, struct mvpp2 *priv)
+static int mvpp2_bm_init(struct device *dev, struct mvpp2 *priv)
 {
 	int i, err;
 
@@ -533,12 +530,12 @@ static int mvpp2_bm_init(struct platform_device *pdev, struct mvpp2 *priv)
 	}
 
 	/* Allocate and initialize BM pools */
-	priv->bm_pools = devm_kcalloc(&pdev->dev, MVPP2_BM_POOLS_NUM,
+	priv->bm_pools = devm_kcalloc(dev, MVPP2_BM_POOLS_NUM,
 				      sizeof(*priv->bm_pools), GFP_KERNEL);
 	if (!priv->bm_pools)
 		return -ENOMEM;
 
-	err = mvpp2_bm_pools_init(pdev, priv);
+	err = mvpp2_bm_pools_init(dev, priv);
 	if (err < 0)
 		return err;
 	return 0;
@@ -5497,7 +5494,7 @@ static int mvpp2_init(struct platform_device *pdev, struct mvpp2 *priv)
 	mvpp2_write(priv, MVPP2_TX_SNOOP_REG, 0x1);
 
 	/* Buffer Manager initialization */
-	err = mvpp2_bm_init(pdev, priv);
+	err = mvpp2_bm_init(&pdev->dev, priv);
 	if (err < 0)
 		return err;
 
@@ -5766,7 +5763,7 @@ static int mvpp2_remove(struct platform_device *pdev)
 	for (i = 0; i < MVPP2_BM_POOLS_NUM; i++) {
 		struct mvpp2_bm_pool *bm_pool = &priv->bm_pools[i];
 
-		mvpp2_bm_pool_destroy(pdev, priv, bm_pool);
+		mvpp2_bm_pool_destroy(&pdev->dev, priv, bm_pool);
 	}
 
 	for (i = 0; i < MVPP2_MAX_THREADS; i++) {
-- 
2.21.0

