Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73E52621B98
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 19:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234416AbiKHSMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 13:12:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234356AbiKHSMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 13:12:01 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673A357B56
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 10:12:00 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id y16so22219683wrt.12
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 10:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1m1DidO2rzjDMZlrvrKtja69hwcXTFXw0zP1Dxjbaww=;
        b=P1bMXtA9ILahSmDOLipS/vaBF54BtW3he0nIKaV3F1tou04OZJoD1ZlskG63rQ/p/e
         f5QqCc36wvzp5Wcs+dnGtQ6GV5bmbADV9jb8khubwXHU2YVQd5Xcobtw+ab0rr8bGP5y
         RF4IoulpEZo6LZt+n9U1NK4OT8LfR+BAZUQjGkcqp0ymrEYTmsCP8bKANJgFFfqIB3ex
         sSAz9wt9TtxnZks6JtFG/IdC4ncWgjTEWd3/ls8cvd2uTo5/OQV1ffhJatQ/Ru8OXOYE
         +ZZhB+4M24NZbsexDA2VUToTZAIAw3V3FXgmj8s3ryRuBh8z9DtioUDF+y+VYamqhFEF
         jMpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1m1DidO2rzjDMZlrvrKtja69hwcXTFXw0zP1Dxjbaww=;
        b=t5LNe+SZ6kqn/fm7IQefnM/Sh3BhI8mHvzBLyWZlAcQ+hZACQJU0WK64VBw2g3VSWg
         /R7qmBZm77Pw08VgwJzVLWRGS8Cgvu5vYHlIsdEGtbPpBWNl4UwYx/lpt0yE4i5cBYKS
         WZlsCXU78HlHURJQlb+RVyHmOxRrTMeM2OPqz8C/cfcF0aRYK2O+AjxRv+Vld4R57QdA
         xKnOvLRgXjHzCoKiWjBaon5ZzEwcIDZ0I+Hr26BfJtrzLzKMlH3sVFvEWD5kWQ6wO1KJ
         sLArBBs0ImjdL3r3MVXc5jXVha7vyoFNwZJodBDhTle5cg3MloYsMvr3v1ZaI8HZcOaO
         qhyQ==
X-Gm-Message-State: ACrzQf3VQLr+iPUMtLQI+mLLRFIpKHqlCADZomweJv3UKhiUv3v/qXpY
        ClYJMsdzOcAlLNZj8/LHylvORQ==
X-Google-Smtp-Source: AMsMyM4zwNIKjWHFWuuVksh8ihwA/QeBVm6znp/91kqCcZh6c1XMvSaZUB3EAGZQ+xveSVcckOCYDQ==
X-Received: by 2002:adf:f943:0:b0:232:ce6b:40d4 with SMTP id q3-20020adff943000000b00232ce6b40d4mr37395557wrr.453.1667931118943;
        Tue, 08 Nov 2022 10:11:58 -0800 (PST)
Received: from nicolas-Precision-3551.home ([2001:861:5180:dcc0:7d10:e9e8:fd9a:2f72])
        by smtp.gmail.com with ESMTPSA id q12-20020a5d61cc000000b002238ea5750csm13037109wrv.72.2022.11.08.10.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 10:11:58 -0800 (PST)
From:   Nicolas Frayer <nfrayer@baylibre.com>
To:     nm@ti.com, ssantosh@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, peter.ujfalusi@gmail.com,
        vkoul@kernel.org, dmaengine@vger.kernel.org,
        grygorii.strashko@ti.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     khilman@baylibre.com, glaroque@baylibre.com, nfrayer@baylibre.com
Subject: [PATCH v4 2/4] soc: ti: Add module build support
Date:   Tue,  8 Nov 2022 19:11:42 +0100
Message-Id: <20221108181144.433087-3-nfrayer@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221108181144.433087-1-nfrayer@baylibre.com>
References: <20221108181144.433087-1-nfrayer@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added module build support for the TI K3 SoC info driver.

Signed-off-by: Nicolas Frayer <nfrayer@baylibre.com>
---
 arch/arm64/Kconfig.platforms |  1 -
 drivers/soc/ti/Kconfig       |  3 ++-
 drivers/soc/ti/k3-socinfo.c  | 11 +++++++++++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Kconfig.platforms b/arch/arm64/Kconfig.platforms
index 76580b932e44..4f2f92eb499f 100644
--- a/arch/arm64/Kconfig.platforms
+++ b/arch/arm64/Kconfig.platforms
@@ -130,7 +130,6 @@ config ARCH_K3
 	select TI_SCI_PROTOCOL
 	select TI_SCI_INTR_IRQCHIP
 	select TI_SCI_INTA_IRQCHIP
-	select TI_K3_SOCINFO
 	help
 	  This enables support for Texas Instruments' K3 multicore SoC
 	  architecture.
diff --git a/drivers/soc/ti/Kconfig b/drivers/soc/ti/Kconfig
index 7e2fb1c16af1..1a730c057cce 100644
--- a/drivers/soc/ti/Kconfig
+++ b/drivers/soc/ti/Kconfig
@@ -74,7 +74,8 @@ config TI_K3_RINGACC
 	  If unsure, say N.
 
 config TI_K3_SOCINFO
-	bool
+	tristate "TI K3 SoC info driver"
+	default y
 	depends on ARCH_K3 || COMPILE_TEST
 	select SOC_BUS
 	select MFD_SYSCON
diff --git a/drivers/soc/ti/k3-socinfo.c b/drivers/soc/ti/k3-socinfo.c
index 19f3e74f5376..98348f998e0f 100644
--- a/drivers/soc/ti/k3-socinfo.c
+++ b/drivers/soc/ti/k3-socinfo.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/sys_soc.h>
+#include <linux/module.h>
 
 #define CTRLMMR_WKUP_JTAGID_REG		0
 /*
@@ -141,6 +142,7 @@ static const struct of_device_id k3_chipinfo_of_match[] = {
 	{ .compatible = "ti,am654-chipid", },
 	{ /* sentinel */ },
 };
+MODULE_DEVICE_TABLE(of, k3_chipinfo_of_match);
 
 static struct platform_driver k3_chipinfo_driver = {
 	.driver = {
@@ -156,3 +158,12 @@ static int __init k3_chipinfo_init(void)
 	return platform_driver_register(&k3_chipinfo_driver);
 }
 subsys_initcall(k3_chipinfo_init);
+
+static void __exit k3_chipinfo_exit(void)
+{
+	platform_driver_unregister(&k3_chipinfo_driver);
+}
+module_exit(k3_chipinfo_exit);
+
+MODULE_DESCRIPTION("TI K3 SoC info driver");
+MODULE_LICENSE("GPL");
-- 
2.25.1

