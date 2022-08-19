Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BD7599D25
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 15:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348933AbiHSN5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 09:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348540AbiHSN5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 09:57:34 -0400
Received: from smtp2.axis.com (smtp2.axis.com [195.60.68.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E10FFF7E;
        Fri, 19 Aug 2022 06:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1660917453;
  x=1692453453;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=n2YiM1VkOWanmoZq6F/KNDCGL6g5QejwONGhMN+1ATQ=;
  b=FhwyQPftgjFihBg+Vb16DwmOHrAb9hKPE/XcklRBbN7mLExhFEaR6ziP
   113SsXwR9VUDJV/JqoUEktrd4AxYa+8+1iGw4/0wgz1GNzxYW3uCXOPI9
   bXuQthSDhp25z0cA+JXEYtt14c6DZIq0PCV00cvBdw2f7rFuVwW+dcR63
   u5IJf3j2Pf6IZUDpUbiG2we2YBOlAQRJqSbPxgCzSrBvLtvg8gWN+hbIe
   iDpS+/rWwnf+sijUIyiVGkau+54SVXGfi+Kra0mm6wR3iNT7jLSqZ0eyj
   aUwu5k0v10AQpQGJYSWCJT5qjyb3d4SzR93sG+xjZk0o3T9iz59sRXlHL
   Q==;
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
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] net: dsa: mv88e6xxx: support RGMII cmode
Date:   Fri, 19 Aug 2022 15:56:29 +0200
Message-ID: <20220819135629.32590-1-marcus.carlberg@axis.com>
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

Signed-off-by: Marcus Carlberg <marcus.carlberg@axis.com>
---

Notes:
    v2: add phy mode input validation for SERDES only ports

 drivers/net/dsa/mv88e6xxx/port.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

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

