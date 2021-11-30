Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A156463521
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 14:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238462AbhK3NNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 08:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237116AbhK3NNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 08:13:30 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FAAC061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 05:10:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=a9zSFhCge3atN444w/0ux3z3DvGwPJZ2iUbDRUXnbeU=; b=oOAOLlxXSK23VtZkpZX+iOjDPG
        mfUiF8L/W6r2VwQNCSoubyixtEARJ46StWSXffL6nuVnykXNIjRX0XD/f1NcN+cL4ZoSFWiZ9trDt
        OwomeRFSljt5VSOW6V69ux+3Q7xHfTfov6AXM8HYdg5qQxA0CCA+0tyiO+JUk821FLaMlhsG1wsg+
        gtHISDQXHnfd8z3eSneX7AWwZajV4uMqaP5HvRxKZQ/UJujb1vbdwDlk0YFFCfog4SUHN6hJEaL1D
        XRWGeGvHjh/ZYnEC5oypCS+ueMNmj2N76AwhTROVmZcbKuoB1fbSbhbpxX/V4ZKyTcAkdikJiWi3v
        9NoZn14Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:39440 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ms2ta-0006vW-LB; Tue, 30 Nov 2021 13:10:06 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ms2ta-00ECJH-6c; Tue, 30 Nov 2021 13:10:06 +0000
In-Reply-To: <YaYiiU9nvmVugqnJ@shell.armlinux.org.uk>
References: <YaYiiU9nvmVugqnJ@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 3/5] net: dsa: support use of
 phylink_generic_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ms2ta-00ECJH-6c@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 30 Nov 2021 13:10:06 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support the use of phylink_generic_validate() when there is no
phylink_validate method given in the DSA switch operations and
mac_capabilities have been set in the phylink_config structure by the
DSA switch driver.

This gives DSA switch drivers the option to use this if they provide
the supported_interfaces and mac_capabilities, while still giving them
an option to override the default implementation if necessary.

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 net/dsa/port.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index ef0acf005f8f..6d5ebe61280b 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -981,8 +981,11 @@ static void dsa_port_phylink_validate(struct phylink_config *config,
 	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
 	struct dsa_switch *ds = dp->ds;
 
-	if (!ds->ops->phylink_validate)
+	if (!ds->ops->phylink_validate) {
+		if (config->mac_capabilities)
+			phylink_generic_validate(config, supported, state);
 		return;
+	}
 
 	ds->ops->phylink_validate(ds, dp->index, supported, state);
 }
-- 
2.30.2

