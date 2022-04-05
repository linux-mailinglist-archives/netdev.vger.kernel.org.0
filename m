Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0E44F35A6
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 15:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiDEKx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 06:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243882AbiDEJkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 05:40:35 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82219B91BF;
        Tue,  5 Apr 2022 02:25:04 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 59A0022247;
        Tue,  5 Apr 2022 11:25:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1649150702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LFGJ3O9qYA9938AO+AQNVvGHGDybEslbIOzd5ve6rOc=;
        b=Q47t6wRO/Ontk9oWcJ4vW9oK8/E+y+rWODF0rkBnL9v+/QXeae/qrwlUfdccHnDmhLRVX6
        4ZJYbomJ2z88PT80DLdLq9xDxngYJFp7nL83yRLw7NFbNN+nI/gjV3Tq583WBCexaCW0hv
        31+C6oUMXrl2LMJ4rdbUhUXiJsSfdV0=
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
        netdev@vger.kernel.org, David Laight <David.Laight@ACULAB.COM>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH v4 2/2] hwmon: intel-m10-bmc-hwmon: use devm_hwmon_sanitize_name()
Date:   Tue,  5 Apr 2022 11:24:52 +0200
Message-Id: <20220405092452.4033674-3-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220405092452.4033674-1-michael@walle.cc>
References: <20220405092452.4033674-1-michael@walle.cc>
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
use the new devm_hwmon_sanitize_name().

Signed-off-by: Michael Walle <michael@walle.cc>
Acked-by: Xu Yilun <yilun.xu@intel.com>
---
 drivers/hwmon/intel-m10-bmc-hwmon.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/hwmon/intel-m10-bmc-hwmon.c b/drivers/hwmon/intel-m10-bmc-hwmon.c
index 7a08e4c44a4b..6e82f7200d1c 100644
--- a/drivers/hwmon/intel-m10-bmc-hwmon.c
+++ b/drivers/hwmon/intel-m10-bmc-hwmon.c
@@ -515,7 +515,6 @@ static int m10bmc_hwmon_probe(struct platform_device *pdev)
 	struct intel_m10bmc *m10bmc = dev_get_drvdata(pdev->dev.parent);
 	struct device *hwmon_dev, *dev = &pdev->dev;
 	struct m10bmc_hwmon *hw;
-	int i;
 
 	hw = devm_kzalloc(dev, sizeof(*hw), GFP_KERNEL);
 	if (!hw)
@@ -528,13 +527,9 @@ static int m10bmc_hwmon_probe(struct platform_device *pdev)
 	hw->chip.info = hw->bdata->hinfo;
 	hw->chip.ops = &m10bmc_hwmon_ops;
 
-	hw->hw_name = devm_kstrdup(dev, id->name, GFP_KERNEL);
-	if (!hw->hw_name)
-		return -ENOMEM;
-
-	for (i = 0; hw->hw_name[i]; i++)
-		if (hwmon_is_bad_char(hw->hw_name[i]))
-			hw->hw_name[i] = '_';
+	hw->hw_name = devm_hwmon_sanitize_name(dev, id->name);
+	if (IS_ERR(hw->hw_name))
+		return PTR_ERR(hw->hw_name);
 
 	hwmon_dev = devm_hwmon_device_register_with_info(dev, hw->hw_name,
 							 hw, &hw->chip, NULL);
-- 
2.30.2

