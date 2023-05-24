Return-Path: <netdev+bounces-5021-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21A3970F729
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:03:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDE3F1C20CD1
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:03:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D709A182C6;
	Wed, 24 May 2023 13:01:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC4818AE3
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 13:01:27 +0000 (UTC)
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968CE12F;
	Wed, 24 May 2023 06:01:24 -0700 (PDT)
Received: (Authenticated sender: alexis.lothore@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id 471356000D;
	Wed, 24 May 2023 13:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1684933283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=58gQgyO8fLA689ZXY0iSxKR4/Zj4aYPmnFUHF1jAFDQ=;
	b=LXmFVWiTlaTVzMbx2Upj8zFtf30EfuNU9h10M0cOAmIZsJGTAIJNv4QAze5ZynD/FmIQgB
	foBF5A/zzWiYKDDpIKvuZ+1NVokVluIBEEtYbXLgG6ZilMT8xIg1+DWw15Y/moB5QfCkFE
	DXI01zSwdGQNVC11EB5cwVA7jy8n9X4/KOrohLv2QMUnKWJ+rYGSNXFeeCkEZjqUgJT3fC
	8LgR+O/8nlgs5hW2e6gjpq6UwfQXoFzOQdQDDzsjs48ZcrSvkz4rNou3vMJsQU7x+iMGm1
	fxwjZb6kE44Trd1EygtVCR+TDTnnmz4E72jv6fTb645QWq3MbOOybQZjND88iw==
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
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>
Subject: [PATCH net-next v3 6/7] net: dsa: mv88e6xxx: pass mv88e6xxx_chip structure to port_max_speed_mode
Date: Wed, 24 May 2023 15:01:26 +0200
Message-Id: <20230524130127.268201-7-alexis.lothore@bootlin.com>
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
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Some switches families have minor differences on supported link speed for
ports. Instead of redefining a new port_max_speed_mode for each different
configuration, allow to pass mv88e6xxx_chip structure to allow
differentiating those chips by known chip id

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

---
Changes since v2:
- add reviewed-by tag

Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c |  2 +-
 drivers/net/dsa/mv88e6xxx/chip.h |  3 ++-
 drivers/net/dsa/mv88e6xxx/port.c | 12 ++++++++----
 drivers/net/dsa/mv88e6xxx/port.h | 12 ++++++++----
 4 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index f15ca17bf9e2..0e6267193ac1 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3311,7 +3311,7 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 		caps = pl_config.mac_capabilities;
 
 		if (chip->info->ops->port_max_speed_mode)
-			mode = chip->info->ops->port_max_speed_mode(port);
+			mode = chip->info->ops->port_max_speed_mode(chip, port);
 		else
 			mode = PHY_INTERFACE_MODE_NA;
 
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index eca51946c100..dd7c8880e987 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -518,7 +518,8 @@ struct mv88e6xxx_ops {
 				     int speed, int duplex);
 
 	/* What interface mode should be used for maximum speed? */
-	phy_interface_t (*port_max_speed_mode)(int port);
+	phy_interface_t (*port_max_speed_mode)(struct mv88e6xxx_chip *chip,
+					       int port);
 
 	int (*port_tag_remap)(struct mv88e6xxx_chip *chip, int port);
 
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index f79cf716c541..66f1b40b4e96 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -342,7 +342,8 @@ int mv88e6341_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 					       duplex);
 }
 
-phy_interface_t mv88e6341_port_max_speed_mode(int port)
+phy_interface_t mv88e6341_port_max_speed_mode(struct mv88e6xxx_chip *chip,
+					      int port)
 {
 	if (port == 5)
 		return PHY_INTERFACE_MODE_2500BASEX;
@@ -381,7 +382,8 @@ int mv88e6390_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 					       duplex);
 }
 
-phy_interface_t mv88e6390_port_max_speed_mode(int port)
+phy_interface_t mv88e6390_port_max_speed_mode(struct mv88e6xxx_chip *chip,
+					      int port)
 {
 	if (port == 9 || port == 10)
 		return PHY_INTERFACE_MODE_2500BASEX;
@@ -403,7 +405,8 @@ int mv88e6390x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 					       duplex);
 }
 
-phy_interface_t mv88e6390x_port_max_speed_mode(int port)
+phy_interface_t mv88e6390x_port_max_speed_mode(struct mv88e6xxx_chip *chip,
+					       int port)
 {
 	if (port == 9 || port == 10)
 		return PHY_INTERFACE_MODE_XAUI;
@@ -500,7 +503,8 @@ int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 	return 0;
 }
 
-phy_interface_t mv88e6393x_port_max_speed_mode(int port)
+phy_interface_t mv88e6393x_port_max_speed_mode(struct mv88e6xxx_chip *chip,
+					       int port)
 {
 	if (port == 0 || port == 9 || port == 10)
 		return PHY_INTERFACE_MODE_10GBASER;
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index aec9d4fd20e3..3c9fc17abdd2 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -359,10 +359,14 @@ int mv88e6390x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 				     int speed, int duplex);
 
-phy_interface_t mv88e6341_port_max_speed_mode(int port);
-phy_interface_t mv88e6390_port_max_speed_mode(int port);
-phy_interface_t mv88e6390x_port_max_speed_mode(int port);
-phy_interface_t mv88e6393x_port_max_speed_mode(int port);
+phy_interface_t mv88e6341_port_max_speed_mode(struct mv88e6xxx_chip *chip,
+					      int port);
+phy_interface_t mv88e6390_port_max_speed_mode(struct mv88e6xxx_chip *chip,
+					      int port);
+phy_interface_t mv88e6390x_port_max_speed_mode(struct mv88e6xxx_chip *chip,
+					       int port);
+phy_interface_t mv88e6393x_port_max_speed_mode(struct mv88e6xxx_chip *chip,
+					       int port);
 
 int mv88e6xxx_port_set_state(struct mv88e6xxx_chip *chip, int port, u8 state);
 
-- 
2.40.1


