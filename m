Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3FC402FC3
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 22:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346756AbhIGUbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 16:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346448AbhIGUbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 16:31:10 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC9EC061575;
        Tue,  7 Sep 2021 13:30:04 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so2297530pjr.1;
        Tue, 07 Sep 2021 13:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dQzHW/n6+AZxWAAIo667muUBbxUuxw9wi7r6fWFMw9Y=;
        b=ms0Sw7US8U0OtDcI+6UH4pynu3O9rstuQRLd8hX53x/1O5fxXG78n9ybhuwvZyk75n
         ZTKLpIbc2kJsfHHzA+4oH7mbICBHdVQ3H3cOhu0/tspjqoFPoUai/Osz0yVhz4e5p92v
         lUA41DffByuiRUDutXFjyZ/WZ7ta8HrI+kK99m/5yKLi1qhSFugwjf5QOrEgN74ho0N0
         Kt0dpX6WMxJ8XsntpacnKZG45Yhv5W6hWR6UQJZDY5hJzxQEOhEzY4l45wL4VFeFWIVT
         ckho9Xai/481R6RzD2s8y4HZJwCxpliYNTua3IYqM3n+NpfM9FmWLH6X707DhDxMyHDK
         4wEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dQzHW/n6+AZxWAAIo667muUBbxUuxw9wi7r6fWFMw9Y=;
        b=kJdmObmbYP/ijfEJBhO7RYune2nk0xxIh+pR8uX+XiGU/Bgl8zGd0yPq64s81ze9O3
         aqWx5JpIXlQFoiXooBMTRAy/bsBDjQLxgrKsl4k0CDCXwm42gbWAo0xqCvEBpOLtMfAq
         4/3rbthJqdIcFd532/oAdr4s6Dvomg9WuKnU44NJLJBViXDhY4YhGJIavahtniU5JVzU
         1QrZyW/HvO/wBjObguDGqbgtwdqJY3mbkVG+Di3zKfywoQYFplwjEQ/LVTKyEAR/CzEx
         nOI6tFIL6zfKSCLLSVzTa/rcU1yog//lQJwuQj2DWjmdlcw1+3Pd9SdtklLhE9piznCS
         W7xw==
X-Gm-Message-State: AOAM533TjNMZ5jqm6RRKMq//Ah99HYMSf13Ys/7CgtY1WY/kA5ibgH4o
        0TNcw7+D8rwnidtwSXNAunE=
X-Google-Smtp-Source: ABdhPJx76LqGqxy56XZNTwiOd5T8iyICiAeGmq0uJreKwrQ75+yDp5V3hBaeBHtTBj96boGw93u03Q==
X-Received: by 2002:a17:90b:388e:: with SMTP id mu14mr233077pjb.109.1631046603457;
        Tue, 07 Sep 2021 13:30:03 -0700 (PDT)
Received: from tong-desktop.local (99-105-211-126.lightspeed.sntcca.sbcglobal.net. [99.105.211.126])
        by smtp.googlemail.com with ESMTPSA id j6sm11447957pfn.107.2021.09.07.13.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 13:30:03 -0700 (PDT)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>
Subject: [PATCH v1] net: macb: fix use after free on rmmod
Date:   Tue,  7 Sep 2021 13:29:58 -0700
Message-Id: <20210907202958.692166-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

plat_dev->dev->platform_data is released by platform_device_unregister(),
use of pclk and hclk is use after free. This patch keeps a copy to fix
the issue.

[   31.261225] BUG: KASAN: use-after-free in macb_remove+0x77/0xc6 [macb_pci]
[   31.275563] Freed by task 306:
[   30.276782]  platform_device_release+0x25/0x80

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/net/ethernet/cadence/macb_pci.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_pci.c b/drivers/net/ethernet/cadence/macb_pci.c
index 8b7b59908a1a..4dd0cec2e542 100644
--- a/drivers/net/ethernet/cadence/macb_pci.c
+++ b/drivers/net/ethernet/cadence/macb_pci.c
@@ -110,10 +110,12 @@ static void macb_remove(struct pci_dev *pdev)
 {
 	struct platform_device *plat_dev = pci_get_drvdata(pdev);
 	struct macb_platform_data *plat_data = dev_get_platdata(&plat_dev->dev);
+	struct clk *pclk = plat_data->pclk;
+	struct clk *hclk = plat_data->hclk;
 
 	platform_device_unregister(plat_dev);
-	clk_unregister(plat_data->pclk);
-	clk_unregister(plat_data->hclk);
+	clk_unregister(pclk);
+	clk_unregister(hclk);
 }
 
 static const struct pci_device_id dev_id_table[] = {
-- 
2.25.1

