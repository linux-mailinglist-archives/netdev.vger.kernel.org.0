Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BB26C0238
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 15:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjCSOCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 10:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCSOCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 10:02:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296E915167
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 07:02:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDE23B80B16
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 14:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B45C433D2;
        Sun, 19 Mar 2023 14:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679234565;
        bh=y2y1UKkoWZAc1meWUJ2vv0ALzYJ2ceioY05bCEA0EYE=;
        h=From:To:Cc:Subject:Date:From;
        b=pdpG3CvGoniP+JygDlDDSQxgqSiSNGU1TMwFRkdq8oo45QpaJlZKIWedY1jtYnGwf
         /EmVh+q+IKeLltwUrlOqDXG987FFgdbZ+R2XIVkSBP21lpVBai6a90yLHxWzU/TMfi
         CZoxnRyTiStk83RHF7EVm3g9WgT0kXLeJdN9yNkM5pB9U1wpBv2i7RiYS+LG9X4W07
         ipuZLZcTKkVMH1b1LKN9C2uuXz/Zwy/HdMGTA2iHbmfqvmDY4YZkFD7RPTQw7m5SvG
         CPPmQtFecEV94EgaNKhUKBcLISERnyR8UkOCAKJbu3CXa9cge8127OhhGU/B078bP0
         Mxb3r+Y6L+9+A==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Klaus Kudielka <klaus.kudielka@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next] net: dsa: mv88e6xxx: fix mdio bus' phy_mask member
Date:   Sun, 19 Mar 2023 15:02:38 +0100
Message-Id: <20230319140238.9470-1-kabel@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 2c7e46edbd03 ("net: dsa: mv88e6xxx: mask apparently non-existing
phys during probing") added non-trivial bus->phy_mask in
mv88e6xxx_mdio_register() in order to avoid excessive mdio bus
transactions during probing.

But the mask is incorrect for switches with non-zero phy_base_addr (such
as 88E6341).

Fix this.

Fixes: 2c7e46edbd03 ("net: dsa: mv88e6xxx: mask apparently non-existing phys during probing")
Signed-off-by: Marek Behún <kabel@kernel.org>
---
I was unable to test this now, so this change needs testing.
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 260e38c5c6e6..b73d1d6747b7 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3805,7 +3805,9 @@ static int mv88e6xxx_mdio_register(struct mv88e6xxx_chip *chip,
 	bus->read_c45 = mv88e6xxx_mdio_read_c45;
 	bus->write_c45 = mv88e6xxx_mdio_write_c45;
 	bus->parent = chip->dev;
-	bus->phy_mask = GENMASK(31, mv88e6xxx_num_ports(chip));
+	bus->phy_mask = ~GENMASK(chip->info->phy_base_addr +
+				 mv88e6xxx_num_ports(chip) - 1,
+				 chip->info->phy_base_addr);
 
 	if (!external) {
 		err = mv88e6xxx_g2_irq_mdio_setup(chip, bus);
-- 
2.39.2

