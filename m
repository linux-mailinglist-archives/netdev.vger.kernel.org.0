Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9741BDFB8
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 15:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgD2N5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 09:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727089AbgD2N47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 09:56:59 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785E9C03C1AD;
        Wed, 29 Apr 2020 06:56:59 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id h12so2341859pjz.1;
        Wed, 29 Apr 2020 06:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U2+xNJj7blIBAN27XYooXiQDtKXv0S4FTtN6zbBijtI=;
        b=HUrMkgpKn/ZQfsXraS+H1vmtx/FSvAbCf908nuuZ7ZDLAdtoWMU8EkzdzlU9JQ8QZu
         ANH8otGBqQl1q8UKJ2BjvOLrPE/YUkMH0q7UJYzSgGxKc2hXik53ixcLC5VWbrBfD14G
         1Z1mu6ZdCWob82MPl0lnDmXBq9sobyEHrLjc7S+8hveoKPmNgzUjJYh4YYeJhGc6xlNr
         DMHFpsP3cMWgpeULqF22dvF6j5frUCp6jOHv6Fvk52H/DB/MTfJXqI/ZLKA0Xog92Ozu
         VUH5PIb0x3uZ1qJKdRPSMA65ZyjNRwWpOqydQknghkWfN8EQxcTd7wBF466HVIiqKwXL
         rxjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U2+xNJj7blIBAN27XYooXiQDtKXv0S4FTtN6zbBijtI=;
        b=dNHqoIi0MKxZ1Yfx5u8jsRaAhS819pEOApvHDFzeVAvX+x5kqKI3eXjK1E6zzP0VdL
         jix5gzdhde1swZ/EA3r+e4uLZflnD5L+VSYobMJUqCPII6Do963QtmZbzSBVhUilyX7Q
         xFYiDVRJ5chCqDcNrzrt+EK/ckR1KHiZjbotOf5EcWIsvFnONIkMkAYEjMPZq3vwHULT
         DBpz8TUzIe9XLAQAS2yk6W1l/l1E5oapQpMZQdDxNvjsExrhX/pVW++T8B6R7Us2ekjf
         cpzejkMvj9oG7nBjKESh9vVZjix/UFwOa+iVL9wFoovuO0JvbtSj2YSa4tYgNDl2waDl
         Pb7w==
X-Gm-Message-State: AGi0PuZt/Gd9cl63ftTk0fJBNjSuUf/BOlPat1F7Y59UxZMoG/jVsRI6
        a1Hd6CYH236AL0wHGSv/Sj8=
X-Google-Smtp-Source: APiQypKa+Cdcrw/FaZJ+foMVdSOwfzVUl6D63+bLwA17pYPZl+DSsM1xY5H1GhaEVm3nVM20+u00ZA==
X-Received: by 2002:a17:902:8ec1:: with SMTP id x1mr33887861plo.180.1588168619043;
        Wed, 29 Apr 2020 06:56:59 -0700 (PDT)
Received: from localhost ([89.208.244.169])
        by smtp.gmail.com with ESMTPSA id y24sm1151342pfn.211.2020.04.29.06.56.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 Apr 2020 06:56:58 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     nicolas.ferre@microchip.com, davem@davemloft.net,
        paul.walmsley@sifive.com, palmer@dabbelt.com, yash.shah@sifive.com,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH net v2] net: macb: fix an issue about leak related system resources
Date:   Wed, 29 Apr 2020 21:56:51 +0800
Message-Id: <20200429135651.32635-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A call of the function macb_init() can fail in the function
fu540_c000_init. The related system resources were not released
then. use devm_platform_ioremap_resource() to replace ioremap()
to fix it.

Fixes: c218ad559020ff9 ("macb: Add support for SiFive FU540-C000")
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Yash Shah <yash.shah@sifive.com>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v1 -> v2:
	- Nicolas and Andy suggest use devm_platform_ioremap_resource()
	  to repalce devm_ioremap() to fix this issue. Thanks Nicolas
	  and Andy.
	- Yash help me to review this patch, Thanks Yash!

 drivers/net/ethernet/cadence/macb_main.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index a0e8c5bbabc0..99354e327d1f 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4172,13 +4172,7 @@ static int fu540_c000_clk_init(struct platform_device *pdev, struct clk **pclk,
 
 static int fu540_c000_init(struct platform_device *pdev)
 {
-	struct resource *res;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (!res)
-		return -ENODEV;
-
-	mgmt->reg = ioremap(res->start, resource_size(res));
+	mgmt->reg = devm_platform_ioremap_resource(pdev, 1);
 	if (!mgmt->reg)
 		return -ENOMEM;
 
-- 
2.25.0

