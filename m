Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9EC3DC921
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 02:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhHAAcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 20:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbhHAAcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 20:32:12 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E898C06179A
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 17:32:02 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id q2so18716642ljq.5
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 17:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vwWjpyFqdMPmfFC5PqGzeA4NCE1Pl8UqRbJa3TNnNSc=;
        b=usssoOhJnU50r4WXu4DqIn9E3DSokkyKeK1/SJeC3mAgbIDLw/DjgC7TQCpHTrZFk4
         U9I2HEHXfQbgtZVFeKFX3T0g9BMu1fPy8tm369pkTtys/AHI18F3BQL4f3nj84YmfzT0
         P0Zd5cOf7kDk1mvf9ACjedBYFYzBkqHWqutvkNDyEvZwFht/aQGCXK8wU8wsktvsVNcW
         +sdRkBN4xqQjNaQIUAWN4Jw++gvbbVQTNVpErlWneF6RiB6B/25SFtxj9IAY7T27HfIR
         AVhiLGaIuVBId4Yh0zvzXh/tiJPVPgC/wlxSLRKr8QA9B/POk4OOO1wLXzVZvF7r1U3W
         CVAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vwWjpyFqdMPmfFC5PqGzeA4NCE1Pl8UqRbJa3TNnNSc=;
        b=sStcN+jztA8SK/igIAMfxJnGy7jG/6FceqNss6XpMSWM9gl10jB/J9kF7XDbjSAtlK
         wy8J3Ye+ujN+98G1MZFlm1h/B8G4/lPqaA6rwuAetktyrASNyuevmwKyYfucgpDKrngC
         5Xt7kuEw3/ju8wS1A5y64ph/3BtE4jks/aJJKix7yFoaTaNLnXhJHmUXawXTKO8KLTQd
         kPs6VQxBLJoYH0k285j6R41vAKQ9ctM4VGUd/iuRgODy1f6VfeM8BaBSzsXDMlHZX3F6
         nLXtPHXNdUZCVp+Q5QLzBJsWYNZ+GUEfIGTqHfGXgpyj4iq3MxciR/3ityvM/I7KCOBm
         1Q8A==
X-Gm-Message-State: AOAM532EuNVB1U5DTr4ksOl1ALb8E+qjQ4qESn6uKHH0HvgVGuTwx9pT
        MMOvFEO5PTnlQSYQBIEuLD7V6QcICjVNAw==
X-Google-Smtp-Source: ABdhPJz6E/P4ETw3eSDvIis0a7tO5jlf0jIJgjARGMjzHj/76VcPPU9/K0vePg+Ck4CL7PafRq6YHg==
X-Received: by 2002:a2e:9814:: with SMTP id a20mr6531000ljj.402.1627777920501;
        Sat, 31 Jul 2021 17:32:00 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id r6sm485255ljk.76.2021.07.31.17.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 17:32:00 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khalasa@piap.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next 6/6] ixp4xx_eth: Probe the PTP module from the device tree
Date:   Sun,  1 Aug 2021 02:27:37 +0200
Message-Id: <20210801002737.3038741-7-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210801002737.3038741-1-linus.walleij@linaro.org>
References: <20210801002737.3038741-1-linus.walleij@linaro.org>
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
index 3ed40b0d0ad2..1f382777aa5a 100644
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
@@ -309,9 +310,19 @@ static int ptp_ixp_probe(struct platform_device *pdev)
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

