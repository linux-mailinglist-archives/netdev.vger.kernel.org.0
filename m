Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070A149D6E4
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbiA0Ajm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:39:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiA0Ajl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:39:41 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F82AC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 16:39:41 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id y15so2095678lfa.9
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 16:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+GIxO9t7GK60UodQDUm3YPw0+VVmnmfOHWk+Nsi9ZSg=;
        b=cd4Xmm2RAl7hiupe4x/3mYFfEBz7brlTG+NF+3p02XPAQ8+61CsCIlu8ZrTrt/kw4M
         YcJO+ICvw13wYIIHUDtRdnt96sJjSl5uJejSCB3/tVd+WDEYVXzMFspM+aHORSzRNqtb
         u6EN8RU/wmvc21EbS4JFiPuF1kx/5b8BsLKodeD7HmdATwQM/k5kdHVOnPlrF2faogNH
         41IkDu/+//kv8lXorbxmPuOcXiyr1Pegw+xmd3RuIwqRZiNcahJC5YvoLtfThEZXBwPm
         hBNtgR/0LoTvdz7aKgNdiWhN3fCRYYw2iFD++S+GP//MkaNnaDRrWivHuhnR85W98KRh
         +JJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+GIxO9t7GK60UodQDUm3YPw0+VVmnmfOHWk+Nsi9ZSg=;
        b=FZhgBZwDesIWAkZJNTYWGMzA99f/MefWqfKcB2HKjEQ3VUq46fp+8PgFqQWnT3X0vs
         eehYxV5PCE3cOHpEdYf8zW0DxH3oK6jFl49ttIT/vY/MfmMbr5+p7I/A7vG+gQ2FO9YZ
         Ru5akMzNC0IS6MgCeoyHPLqVj3Z+HbBgJgH+cfxLB2StjAxslmV1d0IHeEynaWw6Fi8u
         mUJdwAtkDBR13VUPPhtQhsAF5c2BS9U/uHeUP1DAD3GFRFxvdZsxNSTX1MKH7G3a3Sau
         kEufgZVoBOeIupGmwzedWgm5BEcR60IFnNvb5B9KTdWahHDte6CaYLsZ2xnYSfhMY/KX
         C9Lw==
X-Gm-Message-State: AOAM5330omL55Vf1cxX3fNmobC4F9dAKLviyMo1HlGQpFesg+n4UBngH
        okcoayhFj1cUN/6OleDEsaJa+Q==
X-Google-Smtp-Source: ABdhPJy8m9QSPebHjw4tsLV/vIlLG5gwRsiEfmMVpJ3WY0TwwQhg3ub1jkor6rrJrOUzCcwF6jsqgA==
X-Received: by 2002:a05:6512:2314:: with SMTP id o20mr1160355lfu.590.1643243979759;
        Wed, 26 Jan 2022 16:39:39 -0800 (PST)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id y28sm1989701lfa.226.2022.01.26.16.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 16:39:39 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-arm-kernel@lists.infradead.org,
        Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 09/13] net: ixp4xx_hss: Check features using syscon
Date:   Thu, 27 Jan 2022 01:36:52 +0100
Message-Id: <20220127003656.330161-10-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127003656.330161-1-linus.walleij@linaro.org>
References: <20220127003656.330161-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

