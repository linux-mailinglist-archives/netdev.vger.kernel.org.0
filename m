Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCC36B24A3
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 13:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbjCIMz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 07:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbjCIMzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 07:55:11 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102887EA25;
        Thu,  9 Mar 2023 04:55:10 -0800 (PST)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id CEE2D85EAF;
        Thu,  9 Mar 2023 13:55:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1678366507;
        bh=LhwqYlLtNlbnyPzhlWpUbhP4oPhGsA1F/iawWH4ZQg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oLr6iOBNwWqKd4Yh9oHWRRENKHcRN9Vspq4LCOg8gYRFUOgAeXANtyI436Ynbjwtw
         SlWdtSSTxCBZTnU2bmiaYsXlne4qpFJuD3FZPAlxKQHIZStfa7LaN3s9/7MYYl0u7m
         5pzwj1OFUrc9r9xqfflRN/5G4R33FZAz/ZuSom4LBzEArLz7sUSHtrPXfIZW3Zmkld
         blOlnF6aWAkTrCvP5AlnPCF1ChjK0OdugCsWO3JjIVTgP1M4igaMQ9J/iOVLcaZHEF
         YpV3dLdtnGzkwjCQHj/EecsUNpP40n5v0S4s9US2GoS2bXnLMzZEpNd1vYVE81oVz6
         corfZl7EFF2ig==
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz Majewski <lukma@denx.de>
Subject: [PATCH 6/7] dsa: marvell: Correct value of max_frame_size variable after validation
Date:   Thu,  9 Mar 2023 13:54:20 +0100
Message-Id: <20230309125421.3900962-7-lukma@denx.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230309125421.3900962-1-lukma@denx.de>
References: <20230309125421.3900962-1-lukma@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Running of the mv88e6xxx_validate_frame_size() function provided following
results:

[    1.585565] BUG: Marvell 88E6020 has differing max_frame_size: 1632 != 2048
[    1.592540] BUG: Marvell 88E6071 has differing max_frame_size: 1632 != 2048
		^------ Correct -> mv88e6250 family max frame size = 2048B

[    1.599507] BUG: Marvell 88E6085 has differing max_frame_size: 1632 != 1522
[    1.606476] BUG: Marvell 88E6165 has differing max_frame_size: 1522 != 1632
[    1.613445] BUG: Marvell 88E6190X has differing max_frame_size: 10240 != 1522
[    1.620590] BUG: Marvell 88E6191X has differing max_frame_size: 10240 != 1522
[    1.627730] BUG: Marvell 88E6193X has differing max_frame_size: 10240 != 1522
		^------ Needs to be fixed!!!

[    1.634871] BUG: Marvell 88E6220 has differing max_frame_size: 1632 != 2048
[    1.641842] BUG: Marvell 88E6250 has differing max_frame_size: 1632 != 2048
		^------ Correct -> mv88e6250 family max frame size = 2048B

This commit removes the validation function and provides correct values
for the max frame size field.

Signed-off-by: Lukasz Majewski <lukma@denx.de>
---
Changes for v5:
- New patch
---
 drivers/net/dsa/mv88e6xxx/chip.c | 32 +++++---------------------------
 1 file changed, 5 insertions(+), 27 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index af14eb8a1bfd..dbb69787f4ef 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5669,7 +5669,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 5,
 		.max_vid = 4095,
 		.max_sid = 63,
-		.max_frame_size = 1522,
+		.max_frame_size = 1632,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -5837,7 +5837,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 0,
 		.max_vid = 4095,
 		.max_sid = 63,
-		.max_frame_size = 1632,
+		.max_frame_size = 1522,
 		.port_base_addr = 0x10,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6012,7 +6012,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_gpio = 16,
 		.max_vid = 8191,
 		.max_sid = 63,
-		.max_frame_size = 1522,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x0,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6060,7 +6060,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 9,
 		.max_vid = 8191,
 		.max_sid = 63,
-		.max_frame_size = 1522,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x0,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -6084,7 +6084,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 9,
 		.max_vid = 8191,
 		.max_sid = 63,
-		.max_frame_size = 1522,
+		.max_frame_size = 10240,
 		.port_base_addr = 0x0,
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
@@ -7169,27 +7169,6 @@ static int __maybe_unused mv88e6xxx_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(mv88e6xxx_pm_ops, mv88e6xxx_suspend, mv88e6xxx_resume);
 
-static void mv88e6xxx_validate_frame_size(void)
-{
-	int max;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(mv88e6xxx_table); i++) {
-		/* same logic as in mv88e6xxx_get_max_mtu() */
-		if (mv88e6xxx_table[i].ops->port_set_jumbo_size)
-			max = 10240;
-		else if (mv88e6xxx_table[i].ops->set_max_frame_size)
-			max = 1632;
-		else
-			max = 1522;
-
-		if (mv88e6xxx_table[i].max_frame_size != max)
-			pr_err("BUG: %s has differing max_frame_size: %d != %d\n",
-			       mv88e6xxx_table[i].name, max,
-			       mv88e6xxx_table[i].max_frame_size);
-	}
-}
-
 static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 {
 	struct dsa_mv88e6xxx_pdata *pdata = mdiodev->dev.platform_data;
@@ -7323,7 +7302,6 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 	if (err)
 		goto out_mdio;
 
-	mv88e6xxx_validate_frame_size();
 	return 0;
 
 out_mdio:
-- 
2.20.1

