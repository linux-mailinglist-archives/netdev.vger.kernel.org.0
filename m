Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBE428F39
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 04:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388156AbfEXCnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 22:43:25 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37592 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387921AbfEXCnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 22:43:24 -0400
Received: by mail-pl1-f193.google.com with SMTP id p15so3535082pll.4;
        Thu, 23 May 2019 19:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FL96OWjGjcZazAQC1Z3siZkSXdl0SwuUzJLZikcp/Hw=;
        b=tjePZEjMOCilcX+1AimSHAvkEpIIKcT32GMGbPNHoHaZcEJO8pSPzwX/lV+4h4ttyX
         6j9g8Dhqvu7nxpTNQcwvdkzmcKWYS4sGLfeeG7qDuxf7m415pvnWXoYxie9fsbnOlGTr
         SBkvpqOxdMOKtZobvDBVTB1tE8RXvgg6WmFqSUpedADnfhrhDDXtxL1o6puhJ5Vjr3LT
         +TtRVSqeXxA2IByIYDmrpKUxyCgbou3Cx9gv/OXQfIJBAH0t8xFAxgnxIz5l4hdbuOdR
         TXHcNHzvtIVUN32sMZHL8yXVktbzv6BtHkcdY7ghPngXX2h9b3pNDVz8Ac2+zDTtbh8A
         tAJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FL96OWjGjcZazAQC1Z3siZkSXdl0SwuUzJLZikcp/Hw=;
        b=PU9F6DvHHZW02gDbVruFTjT+36lBm8bw0OUO1v7TuZT/tFf1fKOe2U7afIB7WRCrw4
         jsA4kFckMStRB3CUQT5z4bsIs/eT1Fu1OAbIK/D6ic4XGFmybW2eEdMFx2DB9bBqjy7b
         /iqw460xCojbDmbOHpHtIgfMSTDl4N0+OHDMMQdrWoj5sGosYICbTvUg37ISGvEQIhOB
         9vVSYC58z5LTPeAdtsiTzCOBaKt/syTr6UxrTufdru2V/SQdqT82VF7LySiMfPjV181M
         llXpsCtwX4G6eDVtfKdDFiUg8hjli7s+QLH5EZ/g55KtXHH8I58aM4GQHqHKEXdX2x3T
         b43Q==
X-Gm-Message-State: APjAAAUI2f/6T0qXKiD0Xvq8jBCR0JSr8BYF80/hHRu9tLibshSMcjtF
        Mr+1CEtdfQzus+1lxWvzPvTZqoOYFxQ=
X-Google-Smtp-Source: APXvYqw32qj9q34/35k79W04/iywkYz/YBpdBqrQy7r6HlVSYyCUHYMUNjnnDhwTrLHMsraqygRV5w==
X-Received: by 2002:a17:902:8ec3:: with SMTP id x3mr47512107plo.340.1558665802696;
        Thu, 23 May 2019 19:43:22 -0700 (PDT)
Received: from zhanggen-UX430UQ ([66.42.35.75])
        by smtp.gmail.com with ESMTPSA id r77sm645844pgr.93.2019.05.23.19.43.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 19:43:22 -0700 (PDT)
Date:   Fri, 24 May 2019 10:43:07 +0800
From:   Gen Zhang <blackgod016574@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] wlcore: sdio: Fix a memory leaking bug in wl1271_probe()
Message-ID: <20190524024307.GA5639@zhanggen-UX430UQ>
References: <20190523144425.GA26766@zhanggen-UX430UQ>
 <87d0k9b4hm.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d0k9b4hm.fsf@kamboji.qca.qualcomm.com>
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
index 4d4b0770..9110891 100644
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
@@ -380,12 +382,17 @@ static int wl1271_probe(struct sdio_func *func,
 		dev_err(glue->dev, "can't add platform device\n");
 		goto out_dev_put;
 	}
-	return 0;
+	ret = 0;
 
 out_dev_put:
 	platform_device_put(glue->core);
 
-out:
+out_free2:
+	devm_kfree(&func->dev, glue);
+
+out_free1:
+	devm_kfree(&func->dev, pdev_data);
+
 	return ret;
 }
 
---
