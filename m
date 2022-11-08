Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27223620B0A
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 09:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbiKHIXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 03:23:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233472AbiKHIXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 03:23:51 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A1827B20
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 00:23:50 -0800 (PST)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 2A52084F84;
        Tue,  8 Nov 2022 09:23:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1667895829;
        bh=RLS+pi+x+DGj/QyOO6rDYnVOgDX2w+lzfFHtKBegPAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QYw57EY07IrBYVdPRxYbN4vyoZ49/GDUaLae9vnfr5HHLBSt1TxDllqlf4flejfuS
         1O6nBEm0hmzdfQQ7egwAwTGXnttTCt2MPZARVz6+S6iEAATSAN0On40kT1Sl93T9+E
         rLXhy3WdE4nHaxxuPCPb7iBK/cRveuttCyYfkjNdw4KJ7Y/5CD/fo2GqvzoWUGq2bE
         Ia1imfPSfc+lbbq7kvjXwdervIAM0eK9q7iiUNyoBIik6IFn6rX5L0pnTgedsgawXV
         rB/HHiufUlIZw2wGkbLj9aNWFGuad9VYCAUYfVXxp/86/LNhTOnac66Yh71/yHnJiw
         cm463C4ley/4g==
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Lukasz Majewski <lukma@denx.de>
Subject: [PATCH 4/9] net: dsa: mv88e6xxx: add support for MV88E6020 switch
Date:   Tue,  8 Nov 2022 09:23:25 +0100
Message-Id: <20221108082330.2086671-5-lukma@denx.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221108082330.2086671-1-lukma@denx.de>
References: <20221108082330.2086671-1-lukma@denx.de>
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

A 6250 family switch with 5 internal PHYs and no PTP support.

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Signed-off-by: Lukasz Majewski <lukma@denx.de>
[Adjustments for newest kernel upstreaming]
---
 drivers/net/dsa/mv88e6xxx/chip.c | 20 ++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h |  1 +
 drivers/net/dsa/mv88e6xxx/port.h |  1 +
 3 files changed, 22 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d51fd1966be9..cfb6df516e27 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5527,6 +5527,26 @@ static const struct mv88e6xxx_ops mv88e6393x_ops = {
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
index b03f279a673d..c7cbbecd7fe1 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -54,6 +54,7 @@ enum mv88e6xxx_frame_mode {
 
 /* List of supported models */
 enum mv88e6xxx_model {
+	MV88E6020,
 	MV88E6085,
 	MV88E6095,
 	MV88E6097,
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index cb04243f37c1..60a36a8bc131 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -111,6 +111,7 @@
 /* Offset 0x03: Switch Identifier Register */
 #define MV88E6XXX_PORT_SWITCH_ID		0x03
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_MASK	0xfff0
+#define MV88E6XXX_PORT_SWITCH_ID_PROD_6020	0x0200
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6085	0x04a0
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6095	0x0950
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6097	0x0990
-- 
2.37.2

