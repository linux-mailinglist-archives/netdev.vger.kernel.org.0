Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C451227FB2
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 16:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730796AbfEWObT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 10:31:19 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:47009 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730708AbfEWObT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 10:31:19 -0400
Received: by mail-pl1-f196.google.com with SMTP id r18so2825971pls.13;
        Thu, 23 May 2019 07:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=OzO5RxAs85LgaOleUXBoRLjXCQwekMSHZAP0cUDWHtg=;
        b=jVOwhhEJb5le1IMdGM9kPsH/V44mOmocvvXjZUIcPBj8+ylGNBd8RN7RuTlVrd7HqV
         8zuhWExktEV+QaezF41L5rt9x7FFCyTtdBf6DB7OWiGEXBQQ3hZMKd4fZwGLyVDfsj8h
         /qpN62uubjW7lQ/GJs2rXKJZYAXjlqJCU9ADo+ZeAKaodrbdpdoqHAAjHkhRrIL2UZVm
         MohVf0uPAqvR+flYQBiETtqq//jtOB3vSecQexEe967n7OIatP91SFq3OYWnw/OSMQ5T
         Y6QTnTaTDZpp18F/1AUYP5EJzU5aqkwMWDoHlMe8NnPI2xSjHPXH635j4FSygTN3asHH
         s94Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=OzO5RxAs85LgaOleUXBoRLjXCQwekMSHZAP0cUDWHtg=;
        b=XGyMQP/8F0M4RQNhHmOxmZVTOGOTyiy+EyEH+y4kzlon9PZdWyiwzQ6uDEKgz+UWwb
         2QQeO2blf1BhESHaQKCSKPJcZ2WzMJLfGcAmFEvSEuEZvCPiZj/sWEsjnvT85QVwSzdw
         FoCDt95JaKOQJTojpnXt/wW8KGBPEqNW4uD2iABj5Q2iByHqIvb6//GXTqUouz5yvtO9
         OPLBoVZlAk61CXibrpxuXUUsxLfgX7TZsaK9IhHVigZJeWlTrQeTE3ZW4wnsKP5ikd8U
         52wA+XgjmCjuYkqSqgD9ytysr4eGknWLssEizTheUHxkiXsWAvhQtPZTT/wl3BkhZBGQ
         g5+A==
X-Gm-Message-State: APjAAAWqkRJ/e/YJMNe7Xv7WV3cXCSLURdyEpUlI3ADLjNOmIgi4BnaT
        /moGhyeq7jSnu3aGpT6tdAUwkWrGZ8c=
X-Google-Smtp-Source: APXvYqxpzb5BE4r9ASutH0halvaxX8CdPejd0RKIzvdRu7HWvgwdf6uNbOj44MJftLqExn5j5LV8ww==
X-Received: by 2002:a17:902:e18d:: with SMTP id cd13mr31139018plb.301.1558621878491;
        Thu, 23 May 2019 07:31:18 -0700 (PDT)
Received: from zhanggen-UX430UQ ([66.42.35.75])
        by smtp.gmail.com with ESMTPSA id 140sm45674391pfw.123.2019.05.23.07.30.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 07:31:17 -0700 (PDT)
Date:   Thu, 23 May 2019 22:30:22 +0800
From:   Gen Zhang <blackgod016574@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] spi: Fix a memory leaking bug in wl1271_probe()
Message-ID: <20190523143022.GA26485@zhanggen-UX430UQ>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In wl1271_probe(), 'glue->core' is allocated by platform_device_alloc(),
when this allocation fails, ENOMEM is returned. However, 'pdev_data'
and 'glue' are allocated by devm_kzalloc() before 'glue->core'. When
platform_device_alloc() returns NULL, we should also free 'pdev_data'
and 'glue' before wl1271_probe() ends to prevent leaking memory.

Similarly, we shoulf free 'pdev_data' when 'glue' is NULL. And we should
free 'pdev_data' and 'glue' when 'glue->reg' is error and when 'ret' is
error.

Further, we should free 'glue->core', 'pdev_data' and 'glue' when this 
function normally ends to prevent leaking memory.

Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
---
diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index 62ce54a..3a020bd 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -480,7 +480,7 @@ static int wl1271_probe(struct spi_device *spi)
 	struct wl12xx_spi_glue *glue;
 	struct wlcore_platdev_data *pdev_data;
 	struct resource res[1];
-	int ret;
+	int ret = -ENOMEM;
 
 	pdev_data = devm_kzalloc(&spi->dev, sizeof(*pdev_data), GFP_KERNEL);
 	if (!pdev_data)
@@ -491,7 +491,8 @@ static int wl1271_probe(struct spi_device *spi)
 	glue = devm_kzalloc(&spi->dev, sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
 		dev_err(&spi->dev, "can't allocate glue\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_free1;
 	}
 
 	glue->dev = &spi->dev;
@@ -503,31 +504,35 @@ static int wl1271_probe(struct spi_device *spi)
 	spi->bits_per_word = 32;
 
 	glue->reg = devm_regulator_get(&spi->dev, "vwlan");
-	if (PTR_ERR(glue->reg) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
+	if (PTR_ERR(glue->reg) == -EPROBE_DEFER) {
+		ret = -EPROBE_DEFER;
+		goto out_free2;
+	}
 	if (IS_ERR(glue->reg)) {
 		dev_err(glue->dev, "can't get regulator\n");
-		return PTR_ERR(glue->reg);
+		ret = PTR_ERR(glue->reg);
+		goto out_free2;
 	}
 
 	ret = wlcore_probe_of(spi, glue, pdev_data);
 	if (ret) {
 		dev_err(glue->dev,
 			"can't get device tree parameters (%d)\n", ret);
-		return ret;
+		goto out_free2;
 	}
 
 	ret = spi_setup(spi);
 	if (ret < 0) {
 		dev_err(glue->dev, "spi_setup failed\n");
-		return ret;
+		goto out_free2;
 	}
 
 	glue->core = platform_device_alloc(pdev_data->family->name,
 					   PLATFORM_DEVID_AUTO);
 	if (!glue->core) {
 		dev_err(glue->dev, "can't allocate platform_device\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out_free2;
 	}
 
 	glue->core->dev.parent = &spi->dev;
@@ -557,10 +562,18 @@ static int wl1271_probe(struct spi_device *spi)
 		goto out_dev_put;
 	}
 
+	platform_device_put(glue->core);
+	devm_kfree(&func->dev, glue);
+	devm_kfree(&func->dev, pdev_data);
 	return 0;
 
 out_dev_put:
 	platform_device_put(glue->core);
+out_free2:
+	devm_kfree(&func->dev, glue);
+out_free1:
+	devm_kfree(&func->dev, pdev_data);
+out:
 	return ret;
 }
 
---
