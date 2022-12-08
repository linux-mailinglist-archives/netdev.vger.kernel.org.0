Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B03C4647637
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 20:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbiLHTaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 14:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiLHTaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 14:30:12 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5519B2A3;
        Thu,  8 Dec 2022 11:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670527811; x=1702063811;
  h=from:to:subject:date:message-id:mime-version;
  bh=NOuLtBAEfPRVp4erYU2PYxtgRLXk4Rc5kofNmn0gXUs=;
  b=yV9W5ZFIUQ/95TJFWgg2RuzSDIOgV/OJgp6KDp64mjmzrriIk8cyi5CS
   Qht1XRqHEOD3HQlO29Tz52ShzVRU9+CzJa8Kfz9PyqyGiXwK17sv5UxTC
   Lt1lC/vcLWudeMrO7OMxNlB2XTeLQarVEwoJ6cxmy9oXuKD+EUG3knIYC
   SHaVxpz0nLDh3pv9opYjEdNmwK+4QJBY+wKrFaEl2wmuWhKjpecaj6ImX
   Hc5rKOWZJrKfOdur1KryRBe5X2n/m9sNgkdHrLGtZGEoXNIFh9P2+EplR
   awMOH9GXVfhpbcn7+f7R1dsyWLZSP+rUrO6jnM6GYJvS2vzsxOizaRmvp
   A==;
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="187244671"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Dec 2022 12:30:10 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 8 Dec 2022 12:30:08 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 8 Dec 2022 12:30:06 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        Jerry Ray <jerry.ray@microchip.com>
Subject: [PATCH net-next] lan9303: Fix read error execution path
Date:   Thu, 8 Dec 2022 13:30:05 -0600
Message-ID: <20221208193005.12434-1-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes an issue where a read failure of a port statistic counter
will return unknown results.  While it is highly unlikely the read will
ever fail, it is much cleaner to return a zero for the stat count.

Fixes: a1292595e006 ("net: dsa: add new DSA switch driver for the SMSC-LAN9303")

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
 drivers/net/dsa/lan9303-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 80f07bd20593..2e270b479143 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1005,9 +1005,11 @@ static void lan9303_get_ethtool_stats(struct dsa_switch *ds, int port,
 		ret = lan9303_read_switch_port(
 			chip, port, lan9303_mib[u].offset, &reg);
 
-		if (ret)
+		if (ret) {
 			dev_warn(chip->dev, "Reading status port %d reg %u failed\n",
 				 port, lan9303_mib[u].offset);
+			reg = 0;
+		}
 		data[u] = reg;
 	}
 }
-- 
2.17.1

