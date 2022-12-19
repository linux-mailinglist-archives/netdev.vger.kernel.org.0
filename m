Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2FD650997
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 10:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbiLSJwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 04:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiLSJwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 04:52:14 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BABF57;
        Mon, 19 Dec 2022 01:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=lXNSg2HTXkNzB0XUSh5RAc5wn6uXBjCnHSQ7TYqat2M=; b=gjXY7Z2ty5W8yyZRxH5h9dBlPY
        a1VnsPll7wbpiJCE+b/n/6DPwnpyV2891x+MuIoRoKN/f/OnYO5o4rv22eavsBiUt2eU9UQDOsJz4
        w1Yj84p02XMHpU3+NL5SNuynZjdpsBvR4FI0DCHn6FekqRWtzMhTEXzWqYxY0FhvPtVzlPkqRoNTc
        qZGh3z3zYUrJaYoemeZjo6ZpxlPQ2BRixnzLSbL3tfbZtTVHO+OmGF0pUVq3ELuPSNyZO8WSO15mY
        ffNA43WOJGJXzr7jqPNyBMDFzMpyd1XJbbB81bwB4IOp4iGpdqFhK8S0zliSX6x9icblkFN9kW468
        94jL9YEw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:37892 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1p7Coa-00006J-Cq; Mon, 19 Dec 2022 09:52:08 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1p7CoZ-0012Ur-QD; Mon, 19 Dec 2022 09:52:07 +0000
In-Reply-To: <Y6Az235wsnRWFYWA@shell.armlinux.org.uk>
References: <Y6Az235wsnRWFYWA@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>, Wolfram Sang <wsa@kernel.org>
Subject: [PATCH RFC net-next v2 2/2] net: sfp: use i2c_get_adapter_by_fwnode()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1p7CoZ-0012Ur-QD@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 19 Dec 2022 09:52:07 +0000
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

