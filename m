Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54B9A4B30B0
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 23:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354253AbiBKWf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 17:35:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354183AbiBKWfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 17:35:03 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF82D82
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 14:34:58 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id 13so19182843lfp.7
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 14:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ydAMZrV8y3PpgB8uEETNV3djZfWmnSWpnhp3QVaSOR0=;
        b=B6XAOl9/37tvd4e2dLwqre0rTB01bjLgeirYECLZO2wt8kdIApImlH8XvncHF8egxi
         MVmUBy+sWx5oOBxSEy1yG70gtTAUAvx+qvjbk/RDKHexJ3nsPeyer9N0XJY/nQgN88G0
         F6dK3lLeapyLjIch4IViHAzKpfarj2mwtC2lUAThIs/xOpIV2Sd6m1iSov2ddNqPSCTL
         XldsonPWERPN5shOGgFN2zvs6UaFbEA5AIVKzIT9os2xFEjWnB9Tz6QoBIRsSdpQKc9B
         ccnARAUPLq866zvp7LP3Mig9R/Zy/jqsBGpzOD67Kp/YyfAgFKTiRExdbZ4KMarZ1U1K
         c7yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ydAMZrV8y3PpgB8uEETNV3djZfWmnSWpnhp3QVaSOR0=;
        b=vQ0PfJICmuFmQP3H5jnNeHTg2WYvAr7yQoHOQmH2LA3lNoY+ayUfI7KXKTJsMS+ClB
         DvFXhcEsMvW6qiChXXc+MXF7RPEP8o5HEc3tssU8vDbok3lRgTAGbV3nC9adaifge16e
         JJeW6yPCsGyhrUIQBeHjPRJFBA+IwUxaKjPK3IWZ9Sz9Gkhkb+OGYUzSf28VxXJgs1Se
         dx5lysQt2bWJfkhdg2fBErcQYDcwtdMN86KwFd6hw7mvHHc203RPzM50omL5c2RBHCdV
         ooLgCKPV4AiKM2LAaw7ASsb2wvXaT4dwwQEZTDVl5lyoIYRwrE6LEWs8xNDx4GDxElzf
         bqyw==
X-Gm-Message-State: AOAM533vAd8sspX+NhLprRKYSLPjkA+ffauA9bdosPpPzznnMYCQp3HC
        y7d5IiNYl6vRDlpbcXfgHdNf+Kalx95ivwGE
X-Google-Smtp-Source: ABdhPJxvVzhNq8tLEkvgY2SXve6m3vkkiarjh8J86JFx5qFzqWqb3AnW30/CRqqJ0tMZCg4RhVJeUQ==
X-Received: by 2002:a05:6512:3d02:: with SMTP id d2mr2746538lfv.138.1644618895847;
        Fri, 11 Feb 2022 14:34:55 -0800 (PST)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id x2sm3296300lji.27.2022.02.11.14.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:34:55 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-arm-kernel@lists.infradead.org,
        Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 09/13 v2] net: ixp4xx_hss: Check features using syscon
Date:   Fri, 11 Feb 2022 23:32:34 +0100
Message-Id: <20220211223238.648934-10-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211223238.648934-1-linus.walleij@linaro.org>
References: <20220211223238.648934-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we access the syscon (expansion bus config registers) using the
syscon regmap instead of relying on direct accessor functions,
we do not need to call this static code in the machine
(arch/arm/mach-ixp4xx/common.c) which makes things less dependent
on custom machine-dependent code.

Look up the syscon regmap and handle the error: this will make
deferred probe work with relation to the syscon.

Select the syscon in Kconfig and depend on OF so we know that
all we need will be available.

Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- No changes.

Network maintainers: I'm looking for an ACK to take this
change through ARM SoC along with other changes removing
these accessor functions.
---
 drivers/net/wan/Kconfig      |  3 ++-
 drivers/net/wan/ixp4xx_hss.c | 39 ++++++++++++++++++++----------------
 2 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index 592a8389fc5a..140780ac1745 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -293,7 +293,8 @@ config SLIC_DS26522
 config IXP4XX_HSS
 	tristate "Intel IXP4xx HSS (synchronous serial port) support"
 	depends on HDLC && IXP4XX_NPE && IXP4XX_QMGR
-	depends on ARCH_IXP4XX
+	depends on ARCH_IXP4XX && OF
+	select MFD_SYSCON
 	help
 	  Say Y here if you want to use built-in HSS ports
 	  on IXP4xx processor.
diff --git a/drivers/net/wan/ixp4xx_hss.c b/drivers/net/wan/ixp4xx_hss.c
index 0b7d9f2f2b8b..863c3e34e136 100644
--- a/drivers/net/wan/ixp4xx_hss.c
+++ b/drivers/net/wan/ixp4xx_hss.c
@@ -16,8 +16,10 @@
 #include <linux/hdlc.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
+#include <linux/mfd/syscon.h>
 #include <linux/platform_device.h>
 #include <linux/poll.h>
+#include <linux/regmap.h>
 #include <linux/slab.h>
 #include <linux/gpio/consumer.h>
 #include <linux/of.h>
@@ -1389,9 +1391,28 @@ static int ixp4xx_hss_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct net_device *ndev;
 	struct device_node *np;
+	struct regmap *rmap;
 	struct port *port;
 	hdlc_device *hdlc;
 	int err;
+	u32 val;
+
+	/*
+	 * Go into the syscon and check if we have the HSS and HDLC
+	 * features available, else this will not work.
+	 */
+	rmap = syscon_regmap_lookup_by_compatible("syscon");
+	if (IS_ERR(rmap))
+		return dev_err_probe(dev, PTR_ERR(rmap),
+				     "failed to look up syscon\n");
+
+	val = cpu_ixp4xx_features(rmap);
+
+	if ((val & (IXP4XX_FEATURE_HDLC | IXP4XX_FEATURE_HSS)) !=
+	    (IXP4XX_FEATURE_HDLC | IXP4XX_FEATURE_HSS)) {
+		dev_err(dev, "HDLC and HSS feature unavailable in platform\n");
+		return -ENODEV;
+	}
 
 	np = dev->of_node;
 
@@ -1516,25 +1537,9 @@ static struct platform_driver ixp4xx_hss_driver = {
 	.probe		= ixp4xx_hss_probe,
 	.remove		= ixp4xx_hss_remove,
 };
-
-static int __init hss_init_module(void)
-{
-	if ((ixp4xx_read_feature_bits() &
-	     (IXP4XX_FEATURE_HDLC | IXP4XX_FEATURE_HSS)) !=
-	    (IXP4XX_FEATURE_HDLC | IXP4XX_FEATURE_HSS))
-		return -ENODEV;
-
-	return platform_driver_register(&ixp4xx_hss_driver);
-}
-
-static void __exit hss_cleanup_module(void)
-{
-	platform_driver_unregister(&ixp4xx_hss_driver);
-}
+module_platform_driver(ixp4xx_hss_driver);
 
 MODULE_AUTHOR("Krzysztof Halasa");
 MODULE_DESCRIPTION("Intel IXP4xx HSS driver");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS("platform:ixp4xx_hss");
-module_init(hss_init_module);
-module_exit(hss_cleanup_module);
-- 
2.34.1

