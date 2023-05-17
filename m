Return-Path: <netdev+bounces-3455-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 03481707323
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 22:36:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBE0B1C21059
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 20:36:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7193101FF;
	Wed, 17 May 2023 20:35:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC62101F2
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 20:35:59 +0000 (UTC)
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5413BA1;
	Wed, 17 May 2023 13:35:57 -0700 (PDT)
Received: (Authenticated sender: alexis.lothore@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id 233D240007;
	Wed, 17 May 2023 20:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1684355755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RagYd6eCVPXftbaoMDiEGbDgJT7b4I7PTt7SjICCemQ=;
	b=MVuaYei4Wfrlidypw0sqHOmlqYtDR9q5mvT49YVQUSWSAaeibBBI6BlFbuhy1RONbmfPJw
	wokbeNzjFKWaDxi+DbbV4jcXIICTEZW86fpzh+y8o354o8hY58INBTRC3lCFBak7lF2OvF
	JV12TQpgsK2fGILCLFn3vTter73nWqz+tXrL1pPcKpOR90vfOO0jlTZtoI888s+0iqQNo2
	kPPixTA8fpedhKBEaZH4BGYhSe5vs/bt3J7XSWXk+c8P4uptEjIuY7BnQfOyEX8mru067Q
	tlq2MtRKV5bPiI6UQRIPYguuCFILJwVCAWLeCJRypjX5fu1RsT/o1A5IIFW43Q==
From: alexis.lothore@bootlin.com
To: Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Richard Cochran <richardcochran@gmail.com>
Cc: netdev@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	thomas.petazzoni@bootlin.com,
	paul.arola@telus.com,
	scott.roberts@telus.com,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>
Subject: [PATCH net-next 2/2] net: dsa: mv88e6xxx: enable support for 88E6361 switch
Date: Wed, 17 May 2023 22:34:30 +0200
Message-Id: <20230517203430.448705-3-alexis.lothore@bootlin.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230517203430.448705-1-alexis.lothore@bootlin.com>
References: <20230517203430.448705-1-alexis.lothore@bootlin.com>
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
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alexis Lothoré <alexis.lothore@bootlin.com>

Marvell 88E6361 is an 8-port switch derived from the
88E6393X/88E9193X/88E6191X switches family. It can benefit from the
existing mv88e6xxx driver by simply adding the proper switch description in
the driver. Main differences with other switches from this
family are:
- 8 ports exposed (instead of 11): ports 1, 2 and 8 not available
- No 5GBase-x nor SFI/USXGMII support

Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 25 +++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h |  3 ++-
 drivers/net/dsa/mv88e6xxx/port.h |  1 +
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 64a2f2f83735..0be7135fa39d 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6309,6 +6309,31 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.ptp_support = true,
 		.ops = &mv88e6352_ops,
 	},
+	[MV88E6361] = {
+		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6361,
+		.family = MV88E6XXX_FAMILY_6393,
+		.name = "Marvell 88E6361",
+		.num_databases = 4096,
+		.num_macs = 16384,
+		.num_ports = 11,
+		/* Ports 1, 2 and 8 are not routed */
+		.invalid_port_mask = BIT(1) | BIT(2) | BIT(8),
+		.num_internal_phys = 5,
+		.max_vid = 4095,
+		.max_sid = 63,
+		.port_base_addr = 0x0,
+		.phy_base_addr = 0x0,
+		.global1_addr = 0x1b,
+		.global2_addr = 0x1c,
+		.age_time_coeff = 3750,
+		.g1_irqs = 10,
+		.g2_irqs = 14,
+		.atu_move_port_mask = 0x1f,
+		.pvt = true,
+		.multi_chip = true,
+		.ptp_support = true,
+		.ops = &mv88e6393x_ops,
+	},
 	[MV88E6390] = {
 		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6390,
 		.family = MV88E6XXX_FAMILY_6390,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index da6e1339f809..c88e52e355a5 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -82,6 +82,7 @@ enum mv88e6xxx_model {
 	MV88E6350,
 	MV88E6351,
 	MV88E6352,
+	MV88E6361,
 	MV88E6390,
 	MV88E6390X,
 	MV88E6393X,
@@ -100,7 +101,7 @@ enum mv88e6xxx_family {
 	MV88E6XXX_FAMILY_6351,	/* 6171 6175 6350 6351 */
 	MV88E6XXX_FAMILY_6352,	/* 6172 6176 6240 6352 */
 	MV88E6XXX_FAMILY_6390,  /* 6190 6190X 6191 6290 6390 6390X */
-	MV88E6XXX_FAMILY_6393,	/* 6191X 6193X 6393X */
+	MV88E6XXX_FAMILY_6393,	/* 6191X 6193X 6361 6393X */
 };
 
 /**
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index aec9d4fd20e3..22e2147c29a7 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -138,6 +138,7 @@
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6141	0x3400
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6341	0x3410
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6352	0x3520
+#define MV88E6XXX_PORT_SWITCH_ID_PROD_6361	0x2610
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6350	0x3710
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6351	0x3750
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6390	0x3900
-- 
2.40.1


