Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8636559C1C8
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 16:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234269AbiHVOmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 10:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbiHVOmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 10:42:04 -0400
Received: from smtp1.axis.com (smtp1.axis.com [195.60.68.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26791371B1;
        Mon, 22 Aug 2022 07:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1661179323;
  x=1692715323;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=04o6Y1/zm/uWq+8SGUpQ6bwGKSFtfqsQrh2n+bOwVX0=;
  b=nGx2ioXrdF1+nKuo2aCFRuLw92OpA1tAMvHd7hQobCS5jHDzQAGkHKIT
   tclt0fMM8xwz9sU7/pk7m/GvRa0jv4Lyq1xJobolwH01DuoqOVU9F5/W0
   arJ3LgV5ws1crwqQxVhLEGfUjwj1yZjCYTsBsHc6xeI9LvyK1vcgtTTok
   LF22mhz/WJ4G3WTL7yfawNkj96SFORs3rECj4wthDcEOA1DQjKjU8lub7
   YEwYdoK3y6mO4zaWuYswchPnhLxoCQxL2QZdjyqkxt0b76XWIylEAn1yL
   lvzOcjurv4+ATkpvsS+vsIiKU9fvQGXrIy0suptaC9qK0HDYrVeKhE5fq
   w==;
From:   Marcus Carlberg <marcus.carlberg@axis.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <kernel@axis.com>, Marcus Carlberg <marcus.carlberg@axis.com>,
        Pavana Sharma <pavana.sharma@digi.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ashkan Boldaji <ashkan.boldaji@digi.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] net: dsa: mv88e6xxx: support RGMII cmode
Date:   Mon, 22 Aug 2022 16:41:36 +0200
Message-ID: <20220822144136.16627-1-marcus.carlberg@axis.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the probe defaults all interfaces to the highest speed possible
(10GBASE-X in mv88e6393x) before the phy mode configuration from the
devicetree is considered it is currently impossible to use port 0 in
RGMII mode.

This change will allow RGMII modes to be configurable for port 0
enabling port 0 to be configured as RGMII as well as serial depending
on configuration.

Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e6393x family")
Signed-off-by: Marcus Carlberg <marcus.carlberg@axis.com>
---

Notes:
    v2: add phy mode input validation for SERDES only ports
    
    v3: add RGMII phy interface types to supported phy modes list.
        add fixes tag.

 drivers/net/dsa/mv88e6xxx/chip.c |  8 ++++++++
 drivers/net/dsa/mv88e6xxx/port.c | 19 +++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 07e9a4da924c..6403f1f8bdbb 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -816,6 +816,14 @@ static void mv88e6393x_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
 				MAC_10000FD;
 		}
 	}
+
+	if (port == 0) {
+		__set_bit(PHY_INTERFACE_MODE_RMII, supported);
+		__set_bit(PHY_INTERFACE_MODE_RGMII, supported);
+		__set_bit(PHY_INTERFACE_MODE_RGMII_ID, supported);
+		__set_bit(PHY_INTERFACE_MODE_RGMII_RXID, supported);
+		__set_bit(PHY_INTERFACE_MODE_RGMII_TXID, supported);
+	}
 }
 
 static void mv88e6xxx_get_caps(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 90c55f23b7c9..5c4195c635b0 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -517,6 +517,12 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 	case PHY_INTERFACE_MODE_RMII:
 		cmode = MV88E6XXX_PORT_STS_CMODE_RMII;
 		break;
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		cmode = MV88E6XXX_PORT_STS_CMODE_RGMII;
+		break;
 	case PHY_INTERFACE_MODE_1000BASEX:
 		cmode = MV88E6XXX_PORT_STS_CMODE_1000BASEX;
 		break;
@@ -634,6 +640,19 @@ int mv88e6393x_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 	if (port != 0 && port != 9 && port != 10)
 		return -EOPNOTSUPP;
 
+	if (port == 9 || port == 10) {
+		switch (mode) {
+		case PHY_INTERFACE_MODE_RMII:
+		case PHY_INTERFACE_MODE_RGMII:
+		case PHY_INTERFACE_MODE_RGMII_ID:
+		case PHY_INTERFACE_MODE_RGMII_RXID:
+		case PHY_INTERFACE_MODE_RGMII_TXID:
+			return -EINVAL;
+		default:
+			break;
+		}
+	}
+
 	/* mv88e6393x errata 4.5: EEE should be disabled on SERDES ports */
 	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_MAC_CTL, &reg);
 	if (err)
-- 
2.20.1

