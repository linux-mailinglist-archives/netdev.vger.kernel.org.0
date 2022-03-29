Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4414EB165
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 18:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239371AbiC2QJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 12:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239327AbiC2QJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 12:09:32 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0785725ECB6;
        Tue, 29 Mar 2022 09:07:47 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id D22702224D;
        Tue, 29 Mar 2022 18:07:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648570066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m8voqXgytYyDMBr4Anf3saVzxi+gWiv76fTQ2j03gg4=;
        b=XfVp/4GxL4q+U/mutEbzMeEqYACGjzV4JkukcMsoPiomBUljaLDvgwNHo9D7HzAVFs39Rb
        1QFQMiQpZho4oywGBA1K1Sc30FQ2iz8e5GwUV6Mi0/iuNQH2xKgzFMWZp8gL3KmwqIVnKQ
        Lg6NPD2YtubzncZNVh/isn8JfjoLkys=
From:   Michael Walle <michael@walle.cc>
To:     Xu Yilun <yilun.xu@intel.com>, Tom Rix <trix@redhat.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH v2 3/5] net: sfp: use hwmon_sanitize_name()
Date:   Tue, 29 Mar 2022 18:07:28 +0200
Message-Id: <20220329160730.3265481-4-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220329160730.3265481-1-michael@walle.cc>
References: <20220329160730.3265481-1-michael@walle.cc>
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
---
 drivers/net/phy/sfp.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 4dfb79807823..0d5dba30444d 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1289,7 +1289,7 @@ static const struct hwmon_chip_info sfp_hwmon_chip_info = {
 static void sfp_hwmon_probe(struct work_struct *work)
 {
 	struct sfp *sfp = container_of(work, struct sfp, hwmon_probe.work);
-	int err, i;
+	int err;
 
 	/* hwmon interface needs to access 16bit registers in atomic way to
 	 * guarantee coherency of the diagnostic monitoring data. If it is not
@@ -1317,16 +1317,12 @@ static void sfp_hwmon_probe(struct work_struct *work)
 		return;
 	}
 
-	sfp->hwmon_name = kstrdup(dev_name(sfp->dev), GFP_KERNEL);
+	sfp->hwmon_name = hwmon_sanitize_name(dev_name(sfp->dev));
 	if (!sfp->hwmon_name) {
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

