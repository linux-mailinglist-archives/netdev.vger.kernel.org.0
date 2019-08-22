Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 664BF9A1F3
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 23:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390535AbfHVVPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 17:15:55 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38468 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390238AbfHVVPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 17:15:53 -0400
Received: by mail-wm1-f66.google.com with SMTP id m125so7097310wmm.3;
        Thu, 22 Aug 2019 14:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EtIN/Xlr6Ip9YVPKEGipzkLuuYaoLg7P8nPJxnIh64A=;
        b=Z4W8X20hXdRXquz+6aomxEmdr1Nw6M30y/29B8Sk9nBVqCiMWQQA0jVA8B00CjXMEh
         HJOB0pxT3z/GPheiZy4Ne1BHS0t5pNAZ3AU1XZ+/UQ5Tx+25X2nDLoeSe9SOfaXBiUZT
         xtzmzLT0ZjJ+f+U6Cgd9WoOUO1D0lBQl0mGGPblPD6D5/C/5JgTrao1vlkrspMU9871K
         ovuwE2RHRte1AeeXmVHtSTcfqGxGsUtyU/ngLnDFzP6kkZtVRy/igk9DSK2nRj6Bupe2
         S7M783ui3HgnAOPNMj5FMxxAC8Ec3zLUFimt/kh0OC66m4gN9H0YrPjeHkvZ+TEWHgAZ
         WvSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EtIN/Xlr6Ip9YVPKEGipzkLuuYaoLg7P8nPJxnIh64A=;
        b=hGzUz6UeeHJEXCHV+d0Q1ptAHTlLip/7vExdVK+IGF/WeCPqAZ9nuS6Mluhfq0U4iZ
         zyKzVLJW5wfwn1oaJT8IeZ7AS4cgmMk3WfG65Xz1/39Fnq+XzuGwe/FMvDC60Yag5fGs
         T/9i21ddgaFmBmemKJZGFrvgvqJy7R/dNXBv1rw4gxvqPGRwMRdVLOQzWTvJDbQWLqHj
         9OJdcvq0kiwi96+/SGcyxC7xNIwybcsirA5BL3a1qlfjaN4yWD1jOQN5RneGVWj9ipSx
         ZkEUST+Rw2K0RUl3XmFgqpai174bGktTGO1HlfHbI9HxjQYyzbI+RmKarOXjefuZp6Ze
         LJNQ==
X-Gm-Message-State: APjAAAXX+0IUe+sP1xcQPRuBY8+89bQ9Gdt/3fakH1WUqO7hNcUGHW1K
        J5M8EoLtOXDHPgMBx1IlUaA=
X-Google-Smtp-Source: APXvYqxLvVfwOSGwbc+tlhQaL4v3QM6AsGH84AkN9rdgEJ+l+bCU8PWZD6UvKDbZssKyf/GeYJr0Pw==
X-Received: by 2002:a1c:1f41:: with SMTP id f62mr1096637wmf.176.1566508550977;
        Thu, 22 Aug 2019 14:15:50 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id g197sm578488wme.30.2019.08.22.14.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 14:15:50 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     broonie@kernel.org
Cc:     linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 2/5] spi: spi-fsl-dspi: Exit the ISR with IRQ_NONE when it's not ours
Date:   Fri, 23 Aug 2019 00:15:11 +0300
Message-Id: <20190822211514.19288-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190822211514.19288-1-olteanv@gmail.com>
References: <20190822211514.19288-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSPI interrupt can be shared between two controllers at least on the
LX2160A. In that case, the driver for one controller might misbehave and
consume the other's interrupt. Fix this by actually checking if any of
the bits in the status register have been asserted.

Fixes: 13aed2392741 ("spi: spi-fsl-dspi: use IRQF_SHARED mode to request IRQ")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/spi/spi-fsl-dspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index c90db7db4121..6ef2279a3699 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -659,7 +659,7 @@ static irqreturn_t dspi_interrupt(int irq, void *dev_id)
 	regmap_write(dspi->regmap, SPI_SR, spi_sr);
 
 	if (!(spi_sr & (SPI_SR_EOQF | SPI_SR_TCFQF)))
-		return IRQ_HANDLED;
+		return IRQ_NONE;
 
 	/* Get transfer counter (in number of SPI transfers). It was
 	 * reset to 0 when transfer(s) were started.
-- 
2.17.1

