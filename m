Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D74928F5E
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 05:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388275AbfEXDCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 23:02:47 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46788 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387408AbfEXDCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 23:02:46 -0400
Received: by mail-pg1-f196.google.com with SMTP id o11so4001952pgm.13;
        Thu, 23 May 2019 20:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=9i4cdB60faPnhj45QCC3TV0kbSmOz80HuRNljtezoro=;
        b=Pl6kuPKCqT2Q2oqWLMY2G/Aqvgnsz1h3rLNo9Ip+f9K51gbOm4wbz4gzPIh23B4zFt
         de0y8r8yLnm3vrKDEWnPBcABSrqVskubxL6cCsSlrxHKVUTt8u3oYJL9Thh8UEHrNfav
         95GYHvUmUtKe15ViJGyKHxPtAgSCFPmKWL2Y69uhBVG7HR/5FPJY0crXj5ov2e8OKZrL
         YZvvfdWJ9zrwUBTu65KHkfVsX36i09gyOtxEVN01SPznbDnETM2CzOvCeCgxs0kX8Uvg
         eLzcUUHht/UaG+ZFqXyOZ1cRuc7X3TDMM0m+/AT+avXiAp+RowA83sUCkju/J3odSk7W
         agYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=9i4cdB60faPnhj45QCC3TV0kbSmOz80HuRNljtezoro=;
        b=MffBXsMNSlzxP29rE85Ekcy1r2wkEGCdaIVqWlAfet2Y6fp+3tGrnAt1gg6EmSJeJq
         LTqoUJ8InV8ZKBhR3D82ufb1r+0kPyEi6upzve30FhxUK69B4rN9x/OeHhL2Sn/QYz76
         FPGOp6Ja3CVS88xelXieUI1foTIlttsIqcWxun3PgkFSFd3SvKIy1pZviu/YLvLsb+1r
         W0s3junLaTM8FRvJS60lU5QV5rDqgIL+N0zlnujS7xUfvFy4GYAe7V9316xob44KN0jn
         SGkza8BFx7Se04z743O6xYdboOZUaysNkB8UDW0wfPL1Eq9gI29c4gHD4C8ybipKfIzH
         rGzg==
X-Gm-Message-State: APjAAAWKNqL2id9bNtv8nyL7GiMYviAbRBo29CF6Lk1W0BM4gj2QEfZV
        8f2Yto9dB48o5dEzy64acEg=
X-Google-Smtp-Source: APXvYqxFnZzo4mqSLdYWWn4mWlqTNetxBxGG8ORG2e9Mz6qv9InBYuy1nKjifzuIF79F+cfmc+Zk1g==
X-Received: by 2002:a65:62d8:: with SMTP id m24mr8026193pgv.141.1558666965582;
        Thu, 23 May 2019 20:02:45 -0700 (PDT)
Received: from zhanggen-UX430UQ ([66.42.35.75])
        by smtp.gmail.com with ESMTPSA id e184sm857669pfa.169.2019.05.23.20.02.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 20:02:45 -0700 (PDT)
Date:   Fri, 24 May 2019 11:02:35 +0800
From:   Gen Zhang <blackgod016574@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wlcore: spi: Fix a memory leaking bug in wl1271_probe()
Message-ID: <20190524030117.GA6024@zhanggen-UX430UQ>
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
index 62ce54a..ea0ec26 100644
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
@@ -557,10 +562,14 @@ static int wl1271_probe(struct spi_device *spi)
 		goto out_dev_put;
 	}
 
-	return 0;
+	ret =  0;
 
 out_dev_put:
 	platform_device_put(glue->core);
+out_free2:
+	devm_kfree(&func->dev, glue);
+out_free1:
+	devm_kfree(&func->dev, pdev_data);
 	return ret;
 }
 
---
