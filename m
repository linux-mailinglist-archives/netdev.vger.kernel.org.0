Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D73671A25
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjARLMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 06:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjARLLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:11:37 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202D3798C5
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 02:21:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7yX8nKX7y1EnRpL5y4PIUgD1StxrJY1pR3+srN0vym8=; b=xiFQo3YmUCsw610DWIfdYV2Dj2
        h4wL6L1kpiil8XjK9r0G16OzXU+2A3alGGbDZXtZGspytZ7Hr2RdqanWq0JzST6WVpvCZTTy6a3uX
        GYkcn0U3b3eqyl4UG5ZK75m0Ng1dauGqNydWocq7Hhogar/ICAFdx8Sso3blhl1STj74r0n/yhAv9
        fqMDlXCaid4DxfSz1LjUlpj+I1wLfiNMutmC7wrhXfPw/hGmfOLBeHQ0ty2g+NR171j465hH8kdo0
        6uST1GThv2PDfxSHlEPP5BosPWV5WvDZpsgNk+AQQ5cjeffXMawNK5Vcp9aUcx63t96GBMQsBV/dH
        ze7CI48w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:59186 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pI5Yx-0001PG-1p; Wed, 18 Jan 2023 10:20:58 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pI5Yw-006GoI-3l; Wed, 18 Jan 2023 10:20:58 +0000
In-Reply-To: <Y8fH+Vqx6huYQFDU@shell.armlinux.org.uk>
References: <Y8fH+Vqx6huYQFDU@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 1/5] net: sfp: use i2c_get_adapter_by_fwnode()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pI5Yw-006GoI-3l@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 18 Jan 2023 10:20:58 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the newly introduced i2c_get_adapter_by_fwnode() API, so that we
can retrieve the I2C adapter in a firmware independent manner once we
have the fwnode handle for the adapter.

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 83b99d95b278..aa2f7ebbdebc 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -2644,10 +2644,8 @@ static void sfp_cleanup(void *data)
 
 static int sfp_i2c_get(struct sfp *sfp)
 {
-	struct acpi_handle *acpi_handle;
 	struct fwnode_handle *h;
 	struct i2c_adapter *i2c;
-	struct device_node *np;
 	int err;
 
 	h = fwnode_find_reference(dev_fwnode(sfp->dev), "i2c-bus", 0);
@@ -2656,16 +2654,7 @@ static int sfp_i2c_get(struct sfp *sfp)
 		return -ENODEV;
 	}
 
-	if (is_acpi_device_node(h)) {
-		acpi_handle = ACPI_HANDLE_FWNODE(h);
-		i2c = i2c_acpi_find_adapter_by_handle(acpi_handle);
-	} else if ((np = to_of_node(h)) != NULL) {
-		i2c = of_find_i2c_adapter_by_node(np);
-	} else {
-		err = -EINVAL;
-		goto put;
-	}
-
+	i2c = i2c_get_adapter_by_fwnode(h);
 	if (!i2c) {
 		err = -EPROBE_DEFER;
 		goto put;
-- 
2.30.2

