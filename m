Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6AF1B86A6
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 14:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgDYM5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 08:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbgDYM5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 08:57:47 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05FAC09B04B;
        Sat, 25 Apr 2020 05:57:47 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id q18so6001794pgm.11;
        Sat, 25 Apr 2020 05:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OJs6nOWPM7GxxDhYSSl2MaH+M7ss8TdfBBLyxmUdc6U=;
        b=ArzQ62dDlG0VVfaZ0mEBF6nr4VeuKO42k4lzxz1MP32ee14B2GfrO4A6fOt3KBiw0T
         IiE5HdHcrhsCm2HHtVAkENZnt6Yog1OkytjfsbfaOTcWGjwTqOva1sbaX+tnsX90hSDI
         oH8zL/6ie8j0c38R+/Xxaq8QBOTqn+TWUailMm8KJ39zI5s2WBJoRlZf4WoPlkmMMj6o
         orEIlETxlfooAyg7sbXNJfMUPBGRzmzSy4g6le8MR+djbQyfq7pc9u2NasnxcLgBfFKs
         jRYNuuQZtZ6rCJTbm2fBiV3uM2JdcWJHWt8rTt+WEupBPROzb2jwvDyrgS12ZH0wbJT9
         b/oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OJs6nOWPM7GxxDhYSSl2MaH+M7ss8TdfBBLyxmUdc6U=;
        b=JjOfPBEXVKpHsc5B3mhGRipMmx40qV06g0ajSnm/cq7K3G9x3K1D18seS4R+MMr3BR
         Qpy/S6PpLEUxtLbB+fzate+IPpf6WnlVdmkFuzEdbzo0sQOZvuTDOInuA2gb02p/HoZZ
         gWimKHP3JE9eQLvtlYvB7dGVDQ/Xesv+KdIxLruayC4NNo2bIvSuqbHiG8dh3Ds4WnbK
         A+ZitVWyvA7EkT+kCHGWiFELazojsDOaykncj8Hx0D+mfSNgP7A85baPfQOgLgRVIeQ1
         aA2HwQmPo7C/2NZ2K9yVe6cPP9YV8LZHgOaeE/t4CSzBwxMHaRxWTG8T8ktn4fxv8WYT
         qmzw==
X-Gm-Message-State: AGi0PuaSSz3vywODcs6fBBZXXWF700eZVlDNdtn0CvvcZbb/FTw6lQeF
        1d6YuuwtEEbPYcmDKozwcfQ=
X-Google-Smtp-Source: APiQypLYaruEmLlFLs9ueJvdOOa/o+8W+tfx3VZP7HkAZ3Lx3zlX59hKPdudTBB+qWvlpkiH9vlIxQ==
X-Received: by 2002:aa7:8ec1:: with SMTP id b1mr14774164pfr.103.1587819467128;
        Sat, 25 Apr 2020 05:57:47 -0700 (PDT)
Received: from localhost ([176.122.158.64])
        by smtp.gmail.com with ESMTPSA id b7sm8064794pft.147.2020.04.25.05.57.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 25 Apr 2020 05:57:46 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     davem@davemloft.net, paul.walmsley@sifive.com, palmer@dabbelt.com,
        nicolas.ferre@microchip.com, yash.shah@sifive.com,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH net v1] net: macb: fix an issue about leak related system resources
Date:   Sat, 25 Apr 2020 20:57:37 +0800
Message-Id: <20200425125737.5245-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A call of the function macb_init() can fail in the function
fu540_c000_init. The related system resources were not released
then. use devm_ioremap() to replace ioremap() for fix it.

Fixes: c218ad559020ff9 ("macb: Add support for SiFive FU540-C000")
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index a0e8c5bbabc0..edba2eb56231 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4178,7 +4178,7 @@ static int fu540_c000_init(struct platform_device *pdev)
 	if (!res)
 		return -ENODEV;
 
-	mgmt->reg = ioremap(res->start, resource_size(res));
+	mgmt->reg = devm_ioremap(&pdev->dev, res->start, resource_size(res));
 	if (!mgmt->reg)
 		return -ENOMEM;
 
-- 
2.25.0

