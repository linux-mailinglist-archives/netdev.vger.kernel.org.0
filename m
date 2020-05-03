Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061DD1C2C2C
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 14:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbgECMce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 08:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728067AbgECMcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 08:32:33 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3738C061A0C;
        Sun,  3 May 2020 05:32:32 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id q124so7171193pgq.13;
        Sun, 03 May 2020 05:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OjKNsWuIlNWqOK8ZTfhDbmoOKJ5lMhGgdYyR3P+yrPs=;
        b=ROSqKV+TRSB/gN3uXuCuk55t9hWftXZdrFL+65lO6rz7wY/CWQAQacEmEpatwFLMJw
         LVLLkwT0K2DG9p7hjGtPM3hrYO2Go0ULqgaVohy3Ec7WmfizN08PMfhx7sqtIGdQP5SW
         MABDmweWRpHFK3TY47EdA3ValTXg7f7sEdrpJaa8ASjtjm5/CiiRiEjBdJ03STsV6j8E
         EqZLUW2DrYu9VThXk7A+L3sbm3MN7MsEECMFht0UtN7o5z3mE3f9+Kyxtx5QjtxkCE2O
         SmyAFZuXVKtYEGWcfaSUExg4XhjI5Qc3VYYtbsYwvSxm1mO4IScjdQBpefMa3+v1m+bJ
         lNTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OjKNsWuIlNWqOK8ZTfhDbmoOKJ5lMhGgdYyR3P+yrPs=;
        b=VN1SP+YuFKIZXM7QBmp7H9PpHW9SSoo7rp3kQq3jk1FBGASN4IIc+PraEEQUD99sNq
         Mr2kI2WZuxSK7HtFjqSsjwm2VeazGr2cP3ojQylboJdsJ376VM2c7q0/nNUxieRoUfGE
         7KZPucxhwIfizrA1H70HAfF00vXX3GtRMoRYCAp14CiJ50m6eSdLvBMNQ7EKAEpRc+hH
         sppVSJcZEkqAV3PRHN4wnneDExTB7xSKgjm3ErsG8vuOo5zzPNJPiYdBHYj2OCRt7Ehp
         0wim37aXUgwQAShDSC0qmXMDRgfRAlK17E3U9jehUQ9+K8Iaz8zgt0elmwS/Cc5AnXFy
         y3lw==
X-Gm-Message-State: AGi0PuZmN/3tZDe4myy+yUXM71IsRe7pzkUAQfZ+nB5K1tXXg1qtUetr
        PMhHqgpkKkdx59onF5ZzIXU=
X-Google-Smtp-Source: APiQypJb994dlbUr1k5iWSh9AbhTGKGKo5AP/hP7Juwv642dHfO6NJAVOM2+pS3z5nSs0K2zQLX5NA==
X-Received: by 2002:a63:da02:: with SMTP id c2mr12284369pgh.22.1588509152596;
        Sun, 03 May 2020 05:32:32 -0700 (PDT)
Received: from localhost ([89.208.244.169])
        by smtp.gmail.com with ESMTPSA id x132sm6476464pfc.57.2020.05.03.05.32.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 03 May 2020 05:32:32 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     nicolas.ferre@microchip.com, davem@davemloft.net,
        paul.walmsley@sifive.com, palmer@dabbelt.com, yash.shah@sifive.com,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH net v3] net: macb: fix an issue about leak related system resources
Date:   Sun,  3 May 2020 20:32:26 +0800
Message-Id: <20200503123226.7092-1-zhengdejin5@gmail.com>
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
Suggested-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
v2 -> v3:
	- use IS_ERR() and PTR_ERR() for error handling by Nicolas's
	  suggestion. Thanks Nicolas!
v1 -> v2:
	- Nicolas and Andy suggest use devm_platform_ioremap_resource()
	  to repalce devm_ioremap() to fix this issue. Thanks Nicolas
	  and Andy.
	- Yash help me to review this patch, Thanks Yash!

 drivers/net/ethernet/cadence/macb_main.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index a0e8c5bbabc0..f040a36d6e54 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4172,15 +4172,9 @@ static int fu540_c000_clk_init(struct platform_device *pdev, struct clk **pclk,
 
 static int fu540_c000_init(struct platform_device *pdev)
 {
-	struct resource *res;
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (!res)
-		return -ENODEV;
-
-	mgmt->reg = ioremap(res->start, resource_size(res));
-	if (!mgmt->reg)
-		return -ENOMEM;
+	mgmt->reg = devm_platform_ioremap_resource(pdev, 1);
+	if (IS_ERR(mgmt->reg))
+		return PTR_ERR(mgmt->reg);
 
 	return macb_init(pdev);
 }
-- 
2.25.0

