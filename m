Return-Path: <netdev+bounces-5017-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6917B70F71E
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:01:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E02DB1C20DE1
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:01:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E138560860;
	Wed, 24 May 2023 13:01:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BF3174C4
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 13:01:19 +0000 (UTC)
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C729E;
	Wed, 24 May 2023 06:01:17 -0700 (PDT)
Received: (Authenticated sender: alexis.lothore@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id CDDAB60003;
	Wed, 24 May 2023 13:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1684933276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bw3Rp4/KFKRFsgYgrZiOxtsLi8IyON0SD+IlPylnYKo=;
	b=DcQhFbXKiCjUiqacfKgDWAGhxg1n5OuxOmLAgYXSkV6zvUakNOf/xX153Tiibit0UDHJQQ
	eKFMdUal30EGQ31W92YwzpI9wddIfszsWlXPe5Mhu8s3cV2I172bYjzoU6WIBX3dHscfeF
	7ShtoWLQ3dOtSzY9JEZxwUFNyWhCs+nyMra8tlR6cTnfZK60+bhtA1ighp6Rjgb4pNWsCl
	87OSGnf/AY1Zjuz4EiCo3RdHO0TNBtS0Z1qIb/mdF+D/VsvtuOfMmPxKCFMGBv50q8GpUS
	PYS8iDgCkJJpZffirU9aG9mKMOJ92gPWWno9BnwIXlbSWjD53Q2ZbgFrlvheCg==
From: =?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>
To: Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Russell King <linux@armlinux.org.uk>
Cc: linux-kernel@vger.kernel.org ,
	netdev@vger.kernel.org ,
	devicetree@vger.kernel.org ,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	paul.arola@telus.com ,
	scott.roberts@telus.com ,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
	Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next v3 2/7] net: dsa: mv88e6xxx: pass directly chip structure to mv88e6xxx_phy_is_internal
Date: Wed, 24 May 2023 15:01:22 +0200
Message-Id: <20230524130127.268201-3-alexis.lothore@bootlin.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230524130127.268201-1-alexis.lothore@bootlin.com>
References: <20230524130127.268201-1-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Since this function is a simple helper, we do not need to pass a full
dsa_switch structure, we can directly pass the mv88e6xxx_chip structure.
Doing so will allow to share this function with any other function
not manipulating dsa_switch structure but needing info about number of
internal phys

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

---
Changes since v2:
- add reviewed-by tags

Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 64a2f2f83735..93bcfa5c80e1 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -463,10 +463,8 @@ static int mv88e6xxx_port_setup_mac(struct mv88e6xxx_chip *chip, int port,
 	return err;
 }
 
-static int mv88e6xxx_phy_is_internal(struct dsa_switch *ds, int port)
+static int mv88e6xxx_phy_is_internal(struct mv88e6xxx_chip *chip, int port)
 {
-	struct mv88e6xxx_chip *chip = ds->priv;
-
 	return port < chip->info->num_internal_phys;
 }
 
@@ -584,7 +582,7 @@ static void mv88e6095_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
 
 	config->mac_capabilities = MAC_SYM_PAUSE | MAC_10 | MAC_100;
 
-	if (mv88e6xxx_phy_is_internal(chip->ds, port)) {
+	if (mv88e6xxx_phy_is_internal(chip, port)) {
 		__set_bit(PHY_INTERFACE_MODE_MII, config->supported_interfaces);
 	} else {
 		if (cmode < ARRAY_SIZE(mv88e6185_phy_interface_modes) &&
@@ -832,7 +830,7 @@ static void mv88e6xxx_get_caps(struct dsa_switch *ds, int port,
 	chip->info->ops->phylink_get_caps(chip, port, config);
 	mv88e6xxx_reg_unlock(chip);
 
-	if (mv88e6xxx_phy_is_internal(ds, port)) {
+	if (mv88e6xxx_phy_is_internal(chip, port)) {
 		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
 			  config->supported_interfaces);
 		/* Internal ports with no phy-mode need GMII for PHYLIB */
@@ -853,7 +851,7 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 
 	mv88e6xxx_reg_lock(chip);
 
-	if (mode != MLO_AN_PHY || !mv88e6xxx_phy_is_internal(ds, port)) {
+	if (mode != MLO_AN_PHY || !mv88e6xxx_phy_is_internal(chip, port)) {
 		/* In inband mode, the link may come up at any time while the
 		 * link is not forced down. Force the link down while we
 		 * reconfigure the interface mode.
-- 
2.40.1


