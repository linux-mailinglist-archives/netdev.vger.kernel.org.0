Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16426C49CE
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 13:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjCVMAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 08:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbjCVMAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 08:00:21 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E17A58C08;
        Wed, 22 Mar 2023 05:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8nTXt9jwCRvOhTsm0b98Gb8SczR5k6rwx9F+YdbECbg=; b=It1DEF6JvIsPSYpkNMbiq/hfH3
        g/C6n2PDShXjrOiRdjUXqU3nAv1ZLuOMlnl39hRvyD4fW2FVgtxXBuW8pZdULpn1UXyYZbWEFLBWo
        3P0WS183DyR1NcrHOozpc+ECG3IyLnXwylzjICxSdKlohqr75LXXKUsFnU/+0AYswl7QnFsGpY5ag
        Kak9lqzTfS2lWfAr5Cnd1nSSxxrNn8kmvjspshizwSLYl79C095IlnE7Ic1MbKB+cuHvw78XBkOAk
        Wm2xdt7cmTRg7D4hYAfZxTHVpP7M8pl0LGJXJTfK09KIEMaMW7Rar8ZYJF1dWii+q87h94wN62xFC
        mpIzYeqw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45528 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pex8b-00036M-6A; Wed, 22 Mar 2023 12:00:17 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pex8a-00Dvo3-G7; Wed, 22 Mar 2023 12:00:16 +0000
In-Reply-To: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH RFC net-next 5/7] net: dsa: avoid DT validation for drivers
 which provide default config
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pex8a-00Dvo3-G7@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 22 Mar 2023 12:00:16 +0000
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a DSA driver (e.g. mv88e6xxx) provides a default configuration,
avoid validating the DT description as missing elements will be
provided by the DSA driver.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 net/dsa/port.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index c30e3a7d2145..23d9970c02d3 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1951,6 +1951,9 @@ static void dsa_shared_port_validate_of(struct dsa_port *dp,
 	*missing_phy_mode = false;
 	*missing_link_description = false;
 
+	if (dp->ds->ops->port_get_fwnode)
+		return;
+
 	if (of_get_phy_mode(dn, &mode)) {
 		*missing_phy_mode = true;
 		dev_err(ds->dev,
-- 
2.30.2

