Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25515595B19
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 14:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbiHPMBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 08:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235424AbiHPMAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 08:00:36 -0400
Received: from smtp1.axis.com (smtp1.axis.com [195.60.68.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DBCA2866;
        Tue, 16 Aug 2022 04:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1660650349;
  x=1692186349;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0PwUiz2cZ6J2ZE4+k54D/cPS4GO274f8vuj7tTp6RnQ=;
  b=eEzpxSwUQW2HhH1j9RdkArFphB/ZwBjtX1b48V4nFRbVe9LNOdAS8CT6
   9aqzYneMVnbhLMn2JJBXV5dG2boPtIZ74XGOjE4V347qMNeUbwAjQvqVX
   VUacou23TEiXAX4BtYg99tfw0wXcQ0RUKPLUJqtMP1n3PoigRkH9YVjPJ
   jO8tsxXeFgWZBb7UN/My3Jvsv4Cb6acjo46lA4RfIffgT8ZqFkaxZ58Kf
   rkGDSlFfYKWoPm7kJfNQJqZ1jjioqZY6hkCBRqOxT1vpj71A1gV2mX4du
   1F8yhk+dGcNtG9p2hfde2nTIJ4mE6/ga65IdcN41Uh2/mwklRlZaBwg1h
   A==;
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
Subject: [PATCH] net: dsa: mv88e6xxx: support RGMII cmode
Date:   Tue, 16 Aug 2022 13:45:34 +0200
Message-ID: <20220816114534.10407-1-marcus.carlberg@axis.com>
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
 drivers/net/dsa/mv88e6xxx/port.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 90c55f23b7c9..2e005449e733 100644
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
-- 
2.20.1

