Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD371CC4F8
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 00:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgEIWhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 18:37:38 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:39705 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbgEIWh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 18:37:27 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 9F06723E3E;
        Sun, 10 May 2020 00:37:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1589063845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FEfXsSfJQkynE4NhXhtkDkgMaGwmoY5MqTSLZLKHVJ8=;
        b=ogqzU8TcNWJHggWNzNEEeVbJk5a9nCcj8Vs4+nxL0Ujchov2j+7SiLK92E8zLeyDpgxgCF
        IBfaeMlGHoJmfMOHGsC/8b9MPt60debR+/jeNh3gDiO6XUsrxJw6wZqNKGJLee/KL13tUS
        a3ubWhnbyDwsqjKTlA2FFiYbe0u/FQs=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 4/4] net: phy: bcm54140: add cable diagnostics support
Date:   Sun, 10 May 2020 00:37:14 +0200
Message-Id: <20200509223714.30855-5-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200509223714.30855-1-michael@walle.cc>
References: <20200509223714.30855-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the generic cable tester functions from bcm-phy-lib to add cable
tester support.

100m cable, A/B/C/D open:
  Cable test started for device eth0.
  Cable test completed for device eth0.
  Pair: Pair A, result: Open Circuit
  Pair: Pair B, result: Open Circuit
  Pair: Pair C, result: Open Circuit
  Pair: Pair D, result: Open Circuit
  Pair: Pair A, fault length: 106.60m
  Pair: Pair B, fault length: 103.32m
  Pair: Pair C, fault length: 104.96m
  Pair: Pair D, fault length: 106.60m

1m cable, A/B connected, pair C shorted, D open:
  Cable test started for device eth0.
  Cable test completed for device eth0.
  Pair: Pair A, result: OK
  Pair: Pair B, result: OK
  Pair: Pair C, result: Short within Pair
  Pair: Pair D, result: Open Circuit
  Pair: Pair C, fault length: 0.82m
  Pair: Pair D, fault length: 1.64m

1m cable, A/B connected, pair C shorted with D:
  Cable test started for device eth0.
  Cable test completed for device eth0.
  Pair: Pair A, result: OK
  Pair: Pair B, result: OK
  Pair: Pair C, result: Short to another pair
  Pair: Pair D, result: Short to another pair
  Pair: Pair C, fault length: 1.64m
  Pair: Pair D, fault length: 1.64m

The granularity of the length measurement seems to be 82cm.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/bcm54140.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/bcm54140.c b/drivers/net/phy/bcm54140.c
index 9ef37a3bc2bb..8998e68bb26b 100644
--- a/drivers/net/phy/bcm54140.c
+++ b/drivers/net/phy/bcm54140.c
@@ -831,6 +831,7 @@ static struct phy_driver bcm54140_drivers[] = {
 		.phy_id         = PHY_ID_BCM54140,
 		.phy_id_mask    = BCM54140_PHY_ID_MASK,
 		.name           = "Broadcom BCM54140",
+		.flags		= PHY_POLL_CABLE_TEST,
 		.features       = PHY_GBIT_FEATURES,
 		.config_init    = bcm54140_config_init,
 		.did_interrupt	= bcm54140_did_interrupt,
@@ -842,6 +843,8 @@ static struct phy_driver bcm54140_drivers[] = {
 		.soft_reset	= genphy_soft_reset,
 		.get_tunable	= bcm54140_get_tunable,
 		.set_tunable	= bcm54140_set_tunable,
+		.cable_test_start = bcm_phy_cable_test_start_rdb,
+		.cable_test_get_status = bcm_phy_cable_test_get_status_rdb,
 	},
 };
 module_phy_driver(bcm54140_drivers);
-- 
2.20.1

