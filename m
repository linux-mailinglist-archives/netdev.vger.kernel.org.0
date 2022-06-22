Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4DB554A12
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbiFVMfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 08:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbiFVMfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 08:35:53 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248D728E23;
        Wed, 22 Jun 2022 05:35:52 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id DCB7522238;
        Wed, 22 Jun 2022 14:35:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1655901350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bh6Jq1ub4SzChkhbySxsHr+OtTcBRwkh5DtwncsKeks=;
        b=V9SxZd/BW4PgvfUF3uSc7yg9bHJEVhAH82I1OgkMY0+NUrcbO03vPaeFPgdH37rBwKyGzM
        4REoaZB4KW5EiccqerSlsKzJPn35uYyeGVNCngI+zSaAuOtLjtXmIG+rgqyJOI8hPIrHoF
        sDgc6n4bkHRID7I9ec44CzQ3GBWDCDU=
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Michael Walle <michael@walle.cc>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next 1/2] net: sfp: use hwmon_sanitize_name()
Date:   Wed, 22 Jun 2022 14:35:42 +0200
Message-Id: <20220622123543.3463209-2-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220622123543.3463209-1-michael@walle.cc>
References: <20220622123543.3463209-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of open-coding the bad characters replacement in the hwmon name,
use the new hwmon_sanitize_name().

Signed-off-by: Michael Walle <michael@walle.cc>
Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 9a5d5a10560f..81a529c3dbe4 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1290,7 +1290,7 @@ static const struct hwmon_chip_info sfp_hwmon_chip_info = {
 static void sfp_hwmon_probe(struct work_struct *work)
 {
 	struct sfp *sfp = container_of(work, struct sfp, hwmon_probe.work);
-	int err, i;
+	int err;
 
 	/* hwmon interface needs to access 16bit registers in atomic way to
 	 * guarantee coherency of the diagnostic monitoring data. If it is not
@@ -1318,16 +1318,12 @@ static void sfp_hwmon_probe(struct work_struct *work)
 		return;
 	}
 
-	sfp->hwmon_name = kstrdup(dev_name(sfp->dev), GFP_KERNEL);
-	if (!sfp->hwmon_name) {
+	sfp->hwmon_name = hwmon_sanitize_name(dev_name(sfp->dev));
+	if (IS_ERR(sfp->hwmon_name)) {
 		dev_err(sfp->dev, "out of memory for hwmon name\n");
 		return;
 	}
 
-	for (i = 0; sfp->hwmon_name[i]; i++)
-		if (hwmon_is_bad_char(sfp->hwmon_name[i]))
-			sfp->hwmon_name[i] = '_';
-
 	sfp->hwmon_dev = hwmon_device_register_with_info(sfp->dev,
 							 sfp->hwmon_name, sfp,
 							 &sfp_hwmon_chip_info,
-- 
2.30.2

