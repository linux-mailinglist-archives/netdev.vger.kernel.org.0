Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B678D64DD12
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 15:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiLOOp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 09:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiLOOpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 09:45:55 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B232F035;
        Thu, 15 Dec 2022 06:45:54 -0800 (PST)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 5BA7785279;
        Thu, 15 Dec 2022 15:45:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1671115552;
        bh=E6rHdNP6loGV0pu2y0B8t57336Ikxnzk70xYlCqRycA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EzIXY4rkvE3j3Y+/2tD2Ld8gunsO/fFAcKK5K5gEqI6yKbJ03G91oQj7nF6oGQiYb
         8DD8xWoHu68GTf6c82duur86I1KP6JLUyScGfA5uLQpMmshahNsIl8XwLvZjSyZGSq
         D34AhzXaOHkzBseaFpSiKZsEQB0AKY55jBkwBGTjIqlRyX4gEvICgYrvm91yPd7VXk
         7w8JPmbO/jdN3Nym6cRkXw66AZyJcAE5jB9SO8ljwAlot8E+xatF9V2RFPUUu7k7lg
         MNhb3DxdrOd2KhlYCePCHee/VOBxEdJmnHb4aJDpo2Zn1IK/lld8slhe0VxciIksAJ
         IYTz3sHrXlmJg==
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Lukasz Majewski <lukma@denx.de>
Subject: [PATCH v2 2/3] net: dsa: mv88e6xxx: add support for MV88E6020 switch
Date:   Thu, 15 Dec 2022 15:45:35 +0100
Message-Id: <20221215144536.3810578-2-lukma@denx.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221215144536.3810578-1-lukma@denx.de>
References: <20221215144536.3810578-1-lukma@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

A mv88e6250 family (i.e. LinkStreet) switch with 2 PHY and RMII ports
and no PTP support.

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Signed-off-by: Lukasz Majewski <lukma@denx.de>
---
Changes for v2:
- Add S-o-B
- Update commit message
- Add information about max packet size (2048 B)
---
 drivers/net/dsa/mv88e6xxx/chip.c | 21 +++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h |  1 +
 drivers/net/dsa/mv88e6xxx/port.h |  1 +
 3 files changed, 23 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7ae4c389ce50..ac0794e405bd 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5023,6 +5023,27 @@ static const struct mv88e6xxx_ops mv88e6393x_ops = {
 };
 
 static const struct mv88e6xxx_info mv88e6xxx_table[] = {
+	[MV88E6020] = {
+		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6020,
+		.family = MV88E6XXX_FAMILY_6250,
+		.name = "Marvell 88E6020",
+		.num_databases = 64,
+		.num_ports = 7,
+		.num_internal_phys = 5,
+		.max_vid = 4095,
+		.max_frame_size = 2048,
+		.port_base_addr = 0x8,
+		.phy_base_addr = 0x0,
+		.global1_addr = 0xf,
+		.global2_addr = 0x7,
+		.age_time_coeff = 15000,
+		.g1_irqs = 9,
+		.g2_irqs = 5,
+		.atu_move_port_mask = 0xf,
+		.dual_chip = true,
+		.ops = &mv88e6250_ops,
+	},
+
 	[MV88E6085] = {
 		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6085,
 		.family = MV88E6XXX_FAMILY_6097,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 9712b10fc4ed..58cf1e633ce3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -53,6 +53,7 @@ enum mv88e6xxx_frame_mode {
 
 /* List of supported models */
 enum mv88e6xxx_model {
+	MV88E6020,
 	MV88E6085,
 	MV88E6095,
 	MV88E6097,
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 5c347cc58baf..862d1fe1aa15 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -106,6 +106,7 @@
 /* Offset 0x03: Switch Identifier Register */
 #define MV88E6XXX_PORT_SWITCH_ID		0x03
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_MASK	0xfff0
+#define MV88E6XXX_PORT_SWITCH_ID_PROD_6020	0x0200
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6085	0x04a0
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6095	0x0950
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6097	0x0990
-- 
2.37.3

