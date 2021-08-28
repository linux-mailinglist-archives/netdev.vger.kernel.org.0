Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20D643FA6FA
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 19:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234634AbhH1RTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 13:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234629AbhH1RTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 13:19:05 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC82DC0617AD
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 10:18:10 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id b4so21395392lfo.13
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 10:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nj5RTF35gQsW0AqxyNE0lXSMA9c7c05/wwrJgBCDQ4U=;
        b=IfXR0FKMeE+Lt8UhIHMyKqhJoWd2hmRNFgP+lqpFRp8FIE4OuVVBbH4UcxZE5jNcOI
         WCipCy3BCDT13kpCqJEv2Oq73F0yPNwT5lI+SvyH6AO7gxZjYD4pEnCg2ly2qVsfiP8Q
         z+bXgihCFQXRelsCxwa5mjzkuiBCFKZXJ30f872qE4xq8S/8PWKpegkltDcup6UW7Zde
         yhFNLQUNE0gWDhIj5Dix4LmguPYLGQhlSa3tbjWJHKsbwRneR/UnJCiPLTRXjopfqvOZ
         aHr1dhtMhF9DITddZxeHRqAamx5cIP6p81kV8jpY9fAh/UAc4AJtyZNruv1qIFT6Q8+8
         ic6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nj5RTF35gQsW0AqxyNE0lXSMA9c7c05/wwrJgBCDQ4U=;
        b=cBz1P91TF77iGcMh/qK0SIFZgsLMZ9JFKLf1PYalUh4B0OLArCcz4FTQ74Ly2T0w1q
         KTdlMhlc1QM23idKfX8vhloYLwKhxyK4w6T+CS/0ZyelNp9vWdOH+a5LvEVhtDqdxHWQ
         /SpSgFiD2mvhKxsNMMewyNR5YqAyON4MoI36fIPOCi4VCAn1sSakD0OTRZBi3nHQ169T
         aihobc+LbWuBHba+Xk80mUaGkrw6U4bhfuVYA8okpBwYpz5d4arg2OdJQxEtubi5CAED
         mexMEdm+ROEHJ+pYEnbJp72VEokoS06xIJ8NlIXypA4zcz3IsGggO0zc8OE1lR+9+E80
         nG5Q==
X-Gm-Message-State: AOAM532MR7Lj79nBdJjLg+npMNhRbZMsZyG3iTBIobAPVwa62w78rlKf
        v5Wi8zUOzdSbSK4qv3XqplCx3LHCu0ocLA==
X-Google-Smtp-Source: ABdhPJyCNrvkR7yByPNyc1nkcqB7n0EuWRNanxaapky+L6ZPYZC/t4pnzoiB7v9xkbP/T2mMojZ1Qg==
X-Received: by 2002:a05:6512:b9e:: with SMTP id b30mr10915963lfv.428.1630171089042;
        Sat, 28 Aug 2021 10:18:09 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id p1sm202195lfo.255.2021.08.28.10.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 10:18:08 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khalasa@piap.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next 5/5 v3] ixp4xx_eth: Probe the PTP module from the device tree
Date:   Sat, 28 Aug 2021 19:15:48 +0200
Message-Id: <20210828171548.143057-6-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210828171548.143057-1-linus.walleij@linaro.org>
References: <20210828171548.143057-1-linus.walleij@linaro.org>
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

