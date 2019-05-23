Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7D1928010
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 16:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730850AbfEWOol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 10:44:41 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33281 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730709AbfEWOol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 10:44:41 -0400
Received: by mail-pf1-f196.google.com with SMTP id z28so3381622pfk.0;
        Thu, 23 May 2019 07:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=trLF/Pu76tcs2yNpJEmVVGLKJPxzPf+7/LopwlS1ci8=;
        b=sf4PXYXeAQSFyn0UVZTTW2ciZr/ivjcuG5sp5GStckkZgxCyuav/So+HN6AeqF2+Uc
         nA2qq6zG1nYL+fCcfs9sDtvvZniacIHuvyBkk5kKq5XAzEpRRikrZeczPUXmSo5RusWg
         Vt9krzTu2EUS8SbY3x+ZUlhF5Fo4sT6eVvBIre3nN3PzAwL+hmmTWhnWqvazYVGiaOxS
         v257kAIWtsYx4eIcnZ+pzmI7Vp8+J1/JS2AuG2NX5f/SHs5U3szZ9QMvIqyuDMT2saD4
         zHYxtj95orWKnwBRtPaMsdifgQLK3YegNcMf/NU/hvlzQ/EQElhwesRZIuMi8IUUMQzm
         4bJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=trLF/Pu76tcs2yNpJEmVVGLKJPxzPf+7/LopwlS1ci8=;
        b=Rjul+5lbuwnu715oVdcNt7U02jpBae4yk+QkGvMkwEikiUS0X6x1hjhhb4cJnRrj4C
         hikx+b+gxf9SzUSeP4228YDHV+tkBqo3c7UTiaeqo/t11mpmHrEOiI7AT93RNsQ2FQBo
         rWbcU4PW299HmxqaNNgTzQY6KONBI9ZON93tOvFQsKXiufEmdRvENRHEUF0j6sAAiWQ4
         xq4mHzScBsFJaH4R6LFQ2UrAAbHnffKUb358wYpZ6K4ab8Sg1Ljd44hPDBWeemNizO/l
         LU4AjWMqUtTmrocCkT3FJCi9yd0G5PwHgouCfSDOT944EhH89zbG7MtytL+Y4QoNX6Xm
         4vtg==
X-Gm-Message-State: APjAAAWcEHBGnmOutXRzNDgEIecXuwxIW3JZWuDJFAsISiOQkyO03IyQ
        XLoEcSPRmlMTGx8K2+w7rAM=
X-Google-Smtp-Source: APXvYqzb4lEsv8vtep4ivojq/y0QGSAnx/qVDcHNABBr29g5D97ty1yHiucaSX80WUZQQvYPoGVKzQ==
X-Received: by 2002:a17:90a:b890:: with SMTP id o16mr1669701pjr.60.1558622680943;
        Thu, 23 May 2019 07:44:40 -0700 (PDT)
Received: from zhanggen-UX430UQ ([66.42.35.75])
        by smtp.gmail.com with ESMTPSA id h6sm42913471pfk.188.2019.05.23.07.44.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 07:44:40 -0700 (PDT)
Date:   Thu, 23 May 2019 22:44:25 +0800
From:   Gen Zhang <blackgod016574@gmail.com>
To:     kvalo@codeaurora.org, eyalreizer@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] sdio: Fix a memory leaking bug in wl1271_probe()
Message-ID: <20190523144425.GA26766@zhanggen-UX430UQ>
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

Similarly, we should free 'pdev_data' when 'glue' is NULL. And we
should free 'pdev_data' and 'glue' when 'ret' is error.

Further, we shoulf free 'glue->dev', 'pdev_data' and 'glue' when this
function normally ends to prevent memory leaking.

Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
---
diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 4d4b0770..232ce5f 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -298,8 +298,10 @@ static int wl1271_probe(struct sdio_func *func,
 	pdev_data->if_ops = &sdio_ops;
 
 	glue = devm_kzalloc(&func->dev, sizeof(*glue), GFP_KERNEL);
-	if (!glue)
-		return -ENOMEM;
+	if (!glue) {
+		ret = -ENOMEM;
+		goto out_free1;
+	}
 
 	glue->dev = &func->dev;
 
@@ -311,7 +313,7 @@ static int wl1271_probe(struct sdio_func *func,
 
 	ret = wlcore_probe_of(&func->dev, &irq, &wakeirq, pdev_data);
 	if (ret)
-		goto out;
+		goto out_free2;
 
 	/* if sdio can keep power while host is suspended, enable wow */
 	mmcflags = sdio_get_host_pm_caps(func);
@@ -340,7 +342,7 @@ static int wl1271_probe(struct sdio_func *func,
 	if (!glue->core) {
 		dev_err(glue->dev, "can't allocate platform_device");
 		ret = -ENOMEM;
-		goto out;
+		goto out_free2;
 	}
 
 	glue->core->dev.parent = &func->dev;
@@ -380,11 +382,20 @@ static int wl1271_probe(struct sdio_func *func,
 		dev_err(glue->dev, "can't add platform device\n");
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
+
+out_free1:
+	devm_kfree(&func->dev, pdev_data);
+
 out:
 	return ret;
 }
---
