Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB75D4EB163
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 18:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239415AbiC2QJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 12:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239330AbiC2QJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 12:09:32 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCE025EC9F;
        Tue, 29 Mar 2022 09:07:47 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 8122722249;
        Tue, 29 Mar 2022 18:07:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648570065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e5UG7gDs4FZr3J53shS1BpkjUTdnpD0iO94yDhlgvUA=;
        b=m9ss5IumVUrEEKWoVvbHpkoGmEcDkC4SFZfBRxtH9q9UBBDSUPHQZJbdhvlbnXmU4+mU91
        5ASgPWa8b2G4rsGO9yrMEDYdFDqaSWJnPTgwmHcFPQ49Ym1UfH6mMOUFoxGVqHbVZf8b6q
        z0/jhG8Eot6dWpbkzMxBS/ftt+rEM9o=
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
Subject: [PATCH v2 2/5] hwmon: intel-m10-bmc-hwmon: use devm_hwmon_sanitize_name()
Date:   Tue, 29 Mar 2022 18:07:27 +0200
Message-Id: <20220329160730.3265481-3-michael@walle.cc>
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
use the new devm_hwmon_sanitize_name().

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/hwmon/intel-m10-bmc-hwmon.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/hwmon/intel-m10-bmc-hwmon.c b/drivers/hwmon/intel-m10-bmc-hwmon.c
index 7a08e4c44a4b..29370108fa1c 100644
--- a/drivers/hwmon/intel-m10-bmc-hwmon.c
+++ b/drivers/hwmon/intel-m10-bmc-hwmon.c
@@ -515,7 +515,6 @@ static int m10bmc_hwmon_probe(struct platform_device *pdev)
 	struct intel_m10bmc *m10bmc = dev_get_drvdata(pdev->dev.parent);
 	struct device *hwmon_dev, *dev = &pdev->dev;
 	struct m10bmc_hwmon *hw;
-	int i;
 
 	hw = devm_kzalloc(dev, sizeof(*hw), GFP_KERNEL);
 	if (!hw)
@@ -528,14 +527,10 @@ static int m10bmc_hwmon_probe(struct platform_device *pdev)
 	hw->chip.info = hw->bdata->hinfo;
 	hw->chip.ops = &m10bmc_hwmon_ops;
 
-	hw->hw_name = devm_kstrdup(dev, id->name, GFP_KERNEL);
+	hw->hw_name = devm_hwmon_sanitize_name(dev, id->name);
 	if (!hw->hw_name)
 		return -ENOMEM;
 
-	for (i = 0; hw->hw_name[i]; i++)
-		if (hwmon_is_bad_char(hw->hw_name[i]))
-			hw->hw_name[i] = '_';
-
 	hwmon_dev = devm_hwmon_device_register_with_info(dev, hw->hw_name,
 							 hw, &hw->chip, NULL);
 	return PTR_ERR_OR_ZERO(hwmon_dev);
-- 
2.30.2

