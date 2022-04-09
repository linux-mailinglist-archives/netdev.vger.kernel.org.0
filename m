Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0644FA566
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 08:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237246AbiDIG1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 02:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233998AbiDIG1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 02:27:08 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A353638B1;
        Fri,  8 Apr 2022 23:25:02 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id s14so113328plk.8;
        Fri, 08 Apr 2022 23:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pA0w4O8CRiuXzvroFL62p9tDgX2SohP+G9Ok90h6Fcc=;
        b=L3BiklhbmiTW5WIODOPjQsK+EqQy7cAIB1x2Ta48ZFCfL4ylkePY8rt0k48ijrGnZi
         yixG4Dzh0uwl7HYOFM7N+jvM0QLUjtKWdA4yb2tPDqQk6EcusiqFXjMOhfl8Jll3ABuc
         zDDTkFd7lclif8zLg4LqGoqfkPhI/qwY8YJcTeuVnc/+n9mRAbI0WS19SP9HGW+/eExk
         3QMpyEg2nHGqLpYREc01qy10tC2Vqro0SaIcXAh4xq4ZwiE6u9+8w4t+waUqLgmM34iY
         l3EkMkk1EhIX+gEuD4Wp2BK0aa4uKjbp3DYjNVA57eakqIhvLkV7URyfm0gg7kxs23Q8
         PReQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pA0w4O8CRiuXzvroFL62p9tDgX2SohP+G9Ok90h6Fcc=;
        b=bxlqsgxb2fj4d1Z0iKItHO+eXub6Jhqg1BEx3uldIOXzB1Wm8JRvzEz7owas1is+3C
         nNt8YN8AzGOPa2ia+Ob6gUROGDN0zwV3R7OeYYKbQXAYdgD4xOkHDH0r7m1/Yd4c/9gY
         dkc8mMXuD0b0/hPqnL3Q0KRc+r9/VpwoMR4KxOx0csfqJuLaowrVdiqw1dyUna5IG5w1
         CvlNyCw34cugMnXoGP7mvbNsgGKldZu+Bi4UVs1iqwLgSwO6+c+l5Wa2n2GrDjBHjnR8
         FFzGrClHYHO1GTdZGm6SJhM246Ek7SJoJVF02aOu24l47tZcwEU9ZgfhmUVBRBO6pN3K
         6Yuw==
X-Gm-Message-State: AOAM533dFdYVXUr5RoJl2aa/uyH4lQCqUSKrkWijZh0BlQA+eHgxS4OZ
        JLgOsvhGykiHyxpV0cXITA==
X-Google-Smtp-Source: ABdhPJzWQcBOPqOngHyVHxk75RPQHA6pbYbYLBoE2zEL49QqbCtGx9ArK4Djp3I7JPx7JN+5JB7VIA==
X-Received: by 2002:a17:90b:1e4e:b0:1c7:3507:30db with SMTP id pi14-20020a17090b1e4e00b001c7350730dbmr25713445pjb.39.1649485502117;
        Fri, 08 Apr 2022 23:25:02 -0700 (PDT)
Received: from localhost.localdomain ([144.202.91.207])
        by smtp.gmail.com with ESMTPSA id 8-20020a056a00070800b004e14ae3e8d7sm26387128pfl.164.2022.04.08.23.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 23:25:01 -0700 (PDT)
From:   Zheyu Ma <zheyuma97@gmail.com>
To:     stas.yakovlev@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH] wireless: ipw2x00: Refine the error handling of ipw2100_pci_init_one()
Date:   Sat,  9 Apr 2022 14:24:49 +0800
Message-Id: <20220409062449.3752252-1-zheyuma97@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver should release resources in reverse order, i.e., the
resources requested first should be released last, and the driver
should adjust the order of error handling code by this rule.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 34 +++++++++-----------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 2ace2b27ecad..b10d10660eb8 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -6166,7 +6166,7 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 		printk(KERN_WARNING DRV_NAME
 		       "Error calling ioremap.\n");
 		err = -EIO;
-		goto fail;
+		goto out;
 	}
 
 	/* allocate and initialize our net_device */
@@ -6175,36 +6175,33 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 		printk(KERN_WARNING DRV_NAME
 		       "Error calling ipw2100_alloc_device.\n");
 		err = -ENOMEM;
-		goto fail;
+		goto fail_iounmap;
 	}
 
+	priv = libipw_priv(dev);
+	pci_set_master(pci_dev);
+	pci_set_drvdata(pci_dev, priv);
+
 	/* set up PCI mappings for device */
 	err = pci_enable_device(pci_dev);
 	if (err) {
 		printk(KERN_WARNING DRV_NAME
 		       "Error calling pci_enable_device.\n");
-		return err;
+		goto fail_dev;
 	}
 
-	priv = libipw_priv(dev);
-
-	pci_set_master(pci_dev);
-	pci_set_drvdata(pci_dev, priv);
-
 	err = dma_set_mask(&pci_dev->dev, DMA_BIT_MASK(32));
 	if (err) {
 		printk(KERN_WARNING DRV_NAME
 		       "Error calling pci_set_dma_mask.\n");
-		pci_disable_device(pci_dev);
-		return err;
+		goto fail_disable;
 	}
 
 	err = pci_request_regions(pci_dev, DRV_NAME);
 	if (err) {
 		printk(KERN_WARNING DRV_NAME
 		       "Error calling pci_request_regions.\n");
-		pci_disable_device(pci_dev);
-		return err;
+		goto fail_disable;
 	}
 
 	/* We disable the RETRY_TIMEOUT register (0x41) to keep
@@ -6306,9 +6303,13 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 out:
 	return err;
 
-      fail_unlock:
+fail_unlock:
 	mutex_unlock(&priv->action_mutex);
-      fail:
+fail:
+	pci_release_regions(pci_dev);
+fail_disable:
+	pci_disable_device(pci_dev);
+fail_dev:
 	if (dev) {
 		if (registered >= 2)
 			unregister_netdev(dev);
@@ -6334,11 +6335,8 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 
 		free_libipw(dev, 0);
 	}
-
+fail_iounmap:
 	pci_iounmap(pci_dev, ioaddr);
-
-	pci_release_regions(pci_dev);
-	pci_disable_device(pci_dev);
 	goto out;
 }
 
-- 
2.25.1

