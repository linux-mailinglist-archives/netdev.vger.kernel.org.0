Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE93B9A1F8
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 23:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392411AbfHVVQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 17:16:19 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33085 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390356AbfHVVPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 17:15:53 -0400
Received: by mail-wm1-f65.google.com with SMTP id p77so7911718wme.0;
        Thu, 22 Aug 2019 14:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Qbsyx6cF/8P/pZdaXCMzm6cKCGUBSYy56F5PBcg7/6U=;
        b=IurdQHEZbGF35XnlZ8UF4pR7YW1Lwv8gIaLu9L09hnAbFrbd4V1JAFAzo2b43ecYX6
         u9uJyo2I1maGQ8DtMmZYEx1bADj3Fy6rD31yTojMMljpfUyC1f6iE7rcqwTbY+eYiUfy
         PS1z3EQn2OOrFa98leV17thaU5l5iCxxVlJKROvg1X0tGD94ka299HYefzbngW5+tv0M
         mE76oeUVca+Z4DzEWgiVNRYJ52H9OtO8Pfw0wsAf9oGHzofofBNcqqvIyTS0+RjGce25
         3jJ7514tEQwiKNJevx2LUNmmZZqDdN0I2vS9UBU0uFJeoM42TD7pkmHXg2J1QLBwHSn5
         iZpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Qbsyx6cF/8P/pZdaXCMzm6cKCGUBSYy56F5PBcg7/6U=;
        b=cDijmRTogNGVevN0x7AHhpBnBICNrKahjBhz4b6+nYq5nSjazhpFKl0m38QMuzFIs7
         UnPVXtAEFUbkdbISxYVAUoeQfL5+5PHjcJLUh38R2HPByZu6l+oiP0BnEywKMD/9TokO
         T6Y+TBsUpJIaeKwJwOpdHTiXjEginAg9h8SBcn1bQYIUb459OHv+XdHhOmIRvx66Cs/Z
         jUidarWCmCYImfgBZDo2HwjrYql1nhQSx7y/hPbh5lCAWxPRfOmOGn8IKD3w/AxJRJfD
         Abf2DmsA9lmVXq6hmD9jAw+AZxPP4P5nk1s8CzlLG/2Z8uYFQa10z6C8yWX8zjtv8j9c
         aT3Q==
X-Gm-Message-State: APjAAAVeWM/20NFlSckv/wTWCeXH4JD/s8PUIN9kYYBCg4kd3EKiN4KS
        lik8aX9GLstKi64nUk/2O/0=
X-Google-Smtp-Source: APXvYqzC0gNtmlawfUqHbSI/k/ZCR1IkvUuCXPArTbZVL4HwXj+ZTZ3lPdnNyswf3HvdzID+RE48xA==
X-Received: by 2002:a1c:18a:: with SMTP id 132mr1079271wmb.15.1566508551835;
        Thu, 22 Aug 2019 14:15:51 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id g197sm578488wme.30.2019.08.22.14.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 14:15:51 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     broonie@kernel.org
Cc:     linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 3/5] spi: spi-fsl-dspi: Remove impossible to reach error check
Date:   Fri, 23 Aug 2019 00:15:12 +0300
Message-Id: <20190822211514.19288-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190822211514.19288-1-olteanv@gmail.com>
References: <20190822211514.19288-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dspi->devtype_data is under the total control of the driver. Therefore,
a bad value is a driver bug and checking it at runtime (and during an
ISR, at that!) is pointless.

The second "else if" check is only for clarity (instead of a broader
"else") in case other transfer modes are added in the future. But the
printing is dead code and can be removed.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/spi/spi-fsl-dspi.c | 24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 6ef2279a3699..6d2c7984ab0e 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -670,18 +670,10 @@ static irqreturn_t dspi_interrupt(int irq, void *dev_id)
 	msg->actual_length += spi_tcnt * dspi->bytes_per_word;
 
 	trans_mode = dspi->devtype_data->trans_mode;
-	switch (trans_mode) {
-	case DSPI_EOQ_MODE:
+	if (trans_mode == DSPI_EOQ_MODE)
 		dspi_eoq_read(dspi);
-		break;
-	case DSPI_TCFQ_MODE:
+	else if (trans_mode == DSPI_TCFQ_MODE)
 		dspi_tcfq_read(dspi);
-		break;
-	default:
-		dev_err(&dspi->pdev->dev, "unsupported trans_mode %u\n",
-			trans_mode);
-			return IRQ_HANDLED;
-	}
 
 	if (!dspi->len) {
 		dspi->waitflags = 1;
@@ -689,18 +681,10 @@ static irqreturn_t dspi_interrupt(int irq, void *dev_id)
 		return IRQ_HANDLED;
 	}
 
-	switch (trans_mode) {
-	case DSPI_EOQ_MODE:
+	if (trans_mode == DSPI_EOQ_MODE)
 		dspi_eoq_write(dspi);
-		break;
-	case DSPI_TCFQ_MODE:
+	else if (trans_mode == DSPI_TCFQ_MODE)
 		dspi_tcfq_write(dspi);
-		break;
-	default:
-		dev_err(&dspi->pdev->dev,
-			"unsupported trans_mode %u\n",
-			trans_mode);
-	}
 
 	return IRQ_HANDLED;
 }
-- 
2.17.1

