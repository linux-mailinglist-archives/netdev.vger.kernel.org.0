Return-Path: <netdev+bounces-3925-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCA55709932
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 16:13:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95C0F281CB0
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 14:13:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8FD31096B;
	Fri, 19 May 2023 14:13:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB1610955
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 14:13:06 +0000 (UTC)
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D746A192;
	Fri, 19 May 2023 07:13:04 -0700 (PDT)
Received: (Authenticated sender: alexis.lothore@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id E1648E0018;
	Fri, 19 May 2023 14:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1684505583;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RbnRwa+V9iC7DR2jK0YOcpyWlvO4fLpqpNlnKGwZALk=;
	b=ZGm68zV8E4hlpG7EeqdCgsf8/g8ZH4dx0knLP4oAQIkggF7GFrJkjcFBr+aiY3Vjb9jF2X
	2IttnsEYN0CSB5SNVBVGQdxer0lyJoaWC95EKRXo+FIszaAZRM1nJ0/36I66fsRAiQSsIv
	RJQNAvwDu3FjCuvdIIimmLSCDvbuGwDSojoTDINtOh833TKxBgqHWjC922WlumBan9Q0um
	PiphIjaroRsBw90R90UB2kCxz+ceyqC7kNnXnxKQJ+1+wJ28jFddJ0IxJH/dv1HZpbFoSg
	fux5FEqS/w85dYNLR8cwDoPcQr2WpYOvk1SrnjLEDjr0zuMR/Vlt2alVa4AywQ==
From: alexis.lothore@bootlin.com
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
Cc: netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	thomas.petazzoni@bootlin.com,
	paul.arola@telus.com,
	scott.roberts@telus.com,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>
Subject: [PATCH net-next v2 2/7] net: dsa: mv88e6xxx: pass directly chip structure to mv88e6xxx_phy_is_internal
Date: Fri, 19 May 2023 16:12:58 +0200
Message-Id: <20230519141303.245235-3-alexis.lothore@bootlin.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230519141303.245235-1-alexis.lothore@bootlin.com>
References: <20230519141303.245235-1-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alexis Lothoré <alexis.lothore@bootlin.com>

Since this function is a simple helper, we do not need to pass a full
dsa_switch structure, we can directly pass the mv88e6xxx_chip structure.
Doing so will allow to share this function with any other function
not manipulating dsa_switch structure but needing info about number of
internal phys

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


