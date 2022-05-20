Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD5C52E435
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 07:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345467AbiETFPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 01:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345343AbiETFP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 01:15:28 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB41A5ABB
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 22:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=njJOW31hE6Iyw3q2LDGKceK2GR+MFh0E9jbIHQPzijs=; b=ToQuVVUzwnd8pzWENjNRyRlW7N
        xT9LlVbd1rPHbTPy3mFfqUBkF69fAykqlw3VPySjpfJFthr26urxIUqMynC4+3F2u4xzpauYKa4oc
        Fx8bxR8YBSqR8LiPi+tNXc6Fshh/SMGYokj2USkdGjm8B8qlcb2jvdW4tkGDdhC3dH1ShWvhTI/G+
        31GyHK9y9cp5uvl7gCZ20oVOhoh+urn0eEjRaUxWsA/d+zegN9MNEfvfHHVcasfLXezMnyIcKz7WY
        aSQgiPtSSD+ErvMlV7d1au8vfr0CLAI+NL7Q03N9AP//HuGxzP1+/QS3KpfPzLwKFJ6BSqSePc1HL
        75hdu3EQ==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nruyy-00AYRy-Tn; Fri, 20 May 2022 05:15:25 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Juergen Borleis <jbe@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Mans Rullgard <mans@mansr.com>
Subject: [PATCH v2] net: dsa: restrict SMSC_LAN9303_I2C kconfig
Date:   Thu, 19 May 2022 22:15:23 -0700
Message-Id: <20220520051523.10281-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since kconfig 'select' does not follow dependency chains, if symbol KSA
selects KSB, then KSA should also depend on the same symbols that KSB
depends on, in order to prevent Kconfig warnings and possible build
errors.

Change NET_DSA_SMSC_LAN9303_I2C and NET_DSA_SMSC_LAN9303_MDIO so that
they are limited to VLAN_8021Q if the latter is enabled. This prevents
the Kconfig warning:

WARNING: unmet direct dependencies detected for NET_DSA_SMSC_LAN9303
  Depends on [m]: NETDEVICES [=y] && NET_DSA [=y] && (VLAN_8021Q [=m] || VLAN_8021Q [=m]=n)
  Selected by [y]:
  - NET_DSA_SMSC_LAN9303_I2C [=y] && NETDEVICES [=y] && NET_DSA [=y] && I2C [=y]

Fixes: 430065e26719 ("net: dsa: lan9303: add VLAN IDs to master device")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: Juergen Borleis <jbe@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Mans Rullgard <mans@mansr.com>
---
v2: drop 'depends' for NET_DSA_SMSC_LAN9303 and add it for
    NET_DSA_SMSC_LAN9303_MDIO; (Vladimir - thanks)
    correct for Fixes: tag; (Vladimir - thanks)

 drivers/net/dsa/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -72,7 +72,6 @@ source "drivers/net/dsa/realtek/Kconfig"
 
 config NET_DSA_SMSC_LAN9303
 	tristate
-	depends on VLAN_8021Q || VLAN_8021Q=n
 	select NET_DSA_TAG_LAN9303
 	select REGMAP
 	help
@@ -82,6 +81,7 @@ config NET_DSA_SMSC_LAN9303
 config NET_DSA_SMSC_LAN9303_I2C
 	tristate "SMSC/Microchip LAN9303 3-ports 10/100 ethernet switch in I2C managed mode"
 	depends on I2C
+	depends on VLAN_8021Q || VLAN_8021Q=n
 	select NET_DSA_SMSC_LAN9303
 	select REGMAP_I2C
 	help
@@ -91,6 +91,7 @@ config NET_DSA_SMSC_LAN9303_I2C
 config NET_DSA_SMSC_LAN9303_MDIO
 	tristate "SMSC/Microchip LAN9303 3-ports 10/100 ethernet switch in MDIO managed mode"
 	select NET_DSA_SMSC_LAN9303
+	depends on VLAN_8021Q || VLAN_8021Q=n
 	help
 	  Enable access functions if the SMSC/Microchip LAN9303 is configured
 	  for MDIO managed mode.
