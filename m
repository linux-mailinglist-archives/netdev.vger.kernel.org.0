Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB29A3EBE24
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 00:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbhHMWDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 18:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235246AbhHMWDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 18:03:12 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF33FC06129D
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 15:02:43 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id n17so22432957lft.13
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 15:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nj5RTF35gQsW0AqxyNE0lXSMA9c7c05/wwrJgBCDQ4U=;
        b=oib6oA8EaW2M8z2hR0IrRBmSmBQ9PIGW9IK/vqwp9Eo6k1+FUphjHMx4QaVQeiSAGb
         b2kfVEa7/XznTL07vUYqpcZKW57fhTUsrK2j3M7MWqyaBMJRRhoQniBfL62/VLxaL23P
         HOVKUxy86dxVKxlsLRdhSB10rAD5fhAhX/yiKvwejiaLDNAAzeA2l+bcWGTnWCV+egsX
         DQU7h5A8E76P7TfWqzvmUQr8JdSxVwuRvbTAxSwaiWMXLzOF0XXIt8VKzE6zanCF0gat
         tKGCn0Y/gDWLK7uK+w2dWD7zRBGMm+6iQofxciolKSA52hVe2yfMWuwZAHAogc7ppxvZ
         XAeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nj5RTF35gQsW0AqxyNE0lXSMA9c7c05/wwrJgBCDQ4U=;
        b=BKPOPwSUiir47rjp19dtnLe1WJrAxZPj+wPVuCjPjoBxCjBEt0r7QJFeuC32n/MZAZ
         d5tjDmsVZBainWkG0UtO+dtJ3M9ARr4iTAa2vbXraVVUriVy/FI0plZYjYYgpvzIY/2x
         0ZPmxUHegNcIFcbI2BziMCuFMIdmorsWrxaCFVQGEm5LX0kJYvzZM+36ErAUGX4+/K5a
         uQCAHZI7T8NIUcH8qQvKuHm9TWulEir68cki7I/4L3yQZJDyIVkzIE7YSJiiVaawkkAx
         7ufxtZpXTDX8Rq6ugI95o/JOywPklfygC4tVhO+TLB1X2k/JaQzM/FxY1vAescZvzkDY
         TyMw==
X-Gm-Message-State: AOAM533aNKBE7Uv8iRxmM6qVJGBVJ+4tGK6kRIvcmgTnlorRZWHO4gyD
        mLOky08Sl2RVQhF7gNqVdHK9Q0hhFThqSg==
X-Google-Smtp-Source: ABdhPJw2tSKW5Nq/AS1Lyq5aB/+LeaMrZvuz+PEGDl02mJ+sAgBa3krlwgVujFYFczGsS91v0uWzkQ==
X-Received: by 2002:ac2:5503:: with SMTP id j3mr3042988lfk.397.1628892162061;
        Fri, 13 Aug 2021 15:02:42 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id s17sm274912ljp.61.2021.08.13.15.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 15:02:41 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khalasa@piap.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next 6/6 v2] ixp4xx_eth: Probe the PTP module from the device tree
Date:   Sat, 14 Aug 2021 00:00:11 +0200
Message-Id: <20210813220011.921211-7-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210813220011.921211-1-linus.walleij@linaro.org>
References: <20210813220011.921211-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds device tree probing support for the PTP module
adjacent to the ethernet module. It is pretty straight
forward, all resources are in the device tree as they
come to the platform device.

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/ethernet/xscale/ptp_ixp46x.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ptp_ixp46x.c b/drivers/net/ethernet/xscale/ptp_ixp46x.c
index c7ff150bf23f..ecece21315c3 100644
--- a/drivers/net/ethernet/xscale/ptp_ixp46x.c
+++ b/drivers/net/ethernet/xscale/ptp_ixp46x.c
@@ -6,6 +6,7 @@
  */
 #include <linux/device.h>
 #include <linux/module.h>
+#include <linux/mod_devicetable.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -311,9 +312,19 @@ static int ptp_ixp_probe(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id ptp_ixp_match[] = {
+	{
+		.compatible = "intel,ixp46x-ptp-timer",
+	},
+	{ },
+};
+
 static struct platform_driver ptp_ixp_driver = {
-	.driver.name = "ptp-ixp46x",
-	.driver.suppress_bind_attrs = true,
+	.driver = {
+		.name = "ptp-ixp46x",
+		.of_match_table = ptp_ixp_match,
+		.suppress_bind_attrs = true,
+	},
 	.probe = ptp_ixp_probe,
 };
 module_platform_driver(ptp_ixp_driver);
-- 
2.31.1

