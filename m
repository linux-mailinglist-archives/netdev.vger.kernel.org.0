Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99EB31D1B2E
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389724AbgEMQfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389693AbgEMQff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 12:35:35 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366C2C061A0E;
        Wed, 13 May 2020 09:35:35 -0700 (PDT)
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 739E323058;
        Wed, 13 May 2020 18:35:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1589387733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bY/J/CBPj6MSaAL1eh16G6C6UJlwXuGbpIxuuGEazEU=;
        b=YuG+iA8amJ9rcCLSXGvwBjBW9gp71Qw30WkBV9lwld0X1TaLK2Oi5ZIQt/6VmezBPJLsQm
        INQ8bU9Cv7iFYzmhg971hf66f1zfii/29VatikWTkov3+TnvXvNRBmKoHiNqAj+zsDBLAr
        tE7piSMoBHKUhHStpRszwJAgMInj+D4=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v2 4/4] net: phy: bcm54140: add cable diagnostics support
Date:   Wed, 13 May 2020 18:35:24 +0200
Message-Id: <20200513163524.31256-5-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200513163524.31256-1-michael@walle.cc>
References: <20200513163524.31256-1-michael@walle.cc>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
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

