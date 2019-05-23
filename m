Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 472EB27ED7
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 15:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730846AbfEWNx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 09:53:58 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44715 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730323AbfEWNx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 09:53:57 -0400
Received: by mail-pg1-f196.google.com with SMTP id n2so3172062pgp.11;
        Thu, 23 May 2019 06:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=wBOus5XnMT/GSFm7Ta2azVSwxrEw9Cm7MC3BR8HqZMQ=;
        b=AYqyVghC2krw5toK68f4xOM57O3RMbSdGaDaNMebJfETjLn/GEMAAcQ1+mBmNK7dmY
         ljlsrUa3QizI/pO79Q0a+D9ZxtBFPJINAA3WfdMDmbO7wuqpe/eDcKr/c0BnlYfOnrXa
         36hY+yot8t+cf59FWTZ8oaW1/5sLEBxOsHzdzDjIODlgJ/Sx1EeCr8+v/SVOg59hBL9q
         7MKg//dmuoJlbxnZ+uBtuz/Z9FXj6R0MA+KRgL+/hQxR4g/oFHV6OHZW4LuUvfi2LB97
         7nQMQZtL2Oyhx1B7qaZPxKD3pBgF2PVEst0tGfbE9MLIUtr41utsqNJaltFKndXPZFyv
         xpJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=wBOus5XnMT/GSFm7Ta2azVSwxrEw9Cm7MC3BR8HqZMQ=;
        b=ehRd8E93chCojwH/SruG6YBzvqLPLg6/YdztZ+xVKEcTKOwyzHpK5V/RTV7DAc3sdH
         5wyjdhJVBjYyZQswTlzBNWc44vJ0uwQC+4F0+qpMCuF5bkPQvUTIYp8Xnp5xjGXzUpJ5
         lvJi7WgxIbZZQXIK4lV/QBwYkJnSPvnix4m73IGaalqpt0fet+Gjrxhar+QTo5jGIpZH
         AW4DoblVb2kNeeK8Gfz7Vmm0Y1nJzAL6Q5pfdnYgAOw2/ou5gNh20CX6I8GwkbI0kCe7
         HmWbfBT9RQDZGbcx3+ambNCx8SrkkEdJ3c8Rxj+6xqKb7In6uo3aqxJDfLGDZdt/XpBZ
         y+Ow==
X-Gm-Message-State: APjAAAV1VqHDKlO3Ayes0snIg5jYIE/LOwR0aT0zoB2RYSJslLh+2oEu
        6EY+ktjuC9Hs5czDO09JepZM7QmwXQg=
X-Google-Smtp-Source: APXvYqyjfGFyvo1lLdMR/jT+jVGxH8yZMja3v8JHFTQYYTIDpJj5qCC6LIDRsy0lm1J2aJ3us2ZShg==
X-Received: by 2002:a62:2ec4:: with SMTP id u187mr103116784pfu.84.1558619636990;
        Thu, 23 May 2019 06:53:56 -0700 (PDT)
Received: from zhanggen-UX430UQ ([66.42.35.75])
        by smtp.gmail.com with ESMTPSA id q70sm959922pja.31.2019.05.23.06.53.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 06:53:56 -0700 (PDT)
Date:   Thu, 23 May 2019 21:53:26 +0800
From:   Gen Zhang <blackgod016574@gmail.com>
To:     kvalo@codeaurora.org, eyalreizer@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sdio: Fix a memory leaking bug in wl1271_probe()
Message-ID: <20190523135326.GA25841@zhanggen-UX430UQ>
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

Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
---
diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 4d4b0770..e134f30 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -340,7 +340,7 @@ static int wl1271_probe(struct sdio_func *func,
 	if (!glue->core) {
 		dev_err(glue->dev, "can't allocate platform_device");
 		ret = -ENOMEM;
-		goto out;
+		goto out_free;
 	}
 
 	glue->core->dev.parent = &func->dev;
@@ -385,6 +385,10 @@ static int wl1271_probe(struct sdio_func *func,
 out_dev_put:
 	platform_device_put(glue->core);
 
+out_free:
+	devm_kfree(&func->dev, pdev_data);
+	devm_kfree(&func->dev, glue);
+
 out:
 	return ret;
 }
---
