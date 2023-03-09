Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1D36B249B
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 13:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjCIMzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 07:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbjCIMzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 07:55:09 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4E89F21D;
        Thu,  9 Mar 2023 04:55:07 -0800 (PST)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id AD90B85E8F;
        Thu,  9 Mar 2023 13:55:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1678366505;
        bh=CpIOKbE0Y5wx9ksqGQZuGZJ4lPgjM2I//28UAM2Yq7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/9xAC6xOhdc4VrCIAbi/bf9bE76WZK78E/3UQxZrWgXDFSTzZjdR8PViZ+VgwT20
         o4P8K0PUXXIMOQBZ4EZxk1SELi2sWdt6U5XtDdCLYNgKxOW5LO3RUeXGfJXJWS8X+t
         dxZluTGq0tBc9Ue7VqywMM6XRokE1zuuyLAF62WatDgCb5ybw1NvjoDVXsQocmlKCe
         cbItt1H5T1APDAzEmOohHmC/W0CKir9Z3KCTFTC21DvoEYbXbur6C6WaPDzcQ4/bml
         R6JcITLsUI4iFGpFLMxKC1bU9e6lTqCg3XJaC+eLfzy3wy6ipZChVlql5XranERmsb
         SG8F9VrM1LiuA==
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
Subject: [PATCH 3/7] net: dsa: mv88e6xxx: add support for MV88E6071 switch
Date:   Thu,  9 Mar 2023 13:54:17 +0100
Message-Id: <20230309125421.3900962-4-lukma@denx.de>
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

A mv88e6250 family (i.e. "LinkStreet") switch with 5 internal PHYs,
2 RMIIs and no PTP support.

Signed-off-by: Lukasz Majewski <lukma@denx.de>
---
Changes for v2:
- Update commit message
- Add information about max frame size

Changes for v3:
- None

Changes for v4:
- None

Changes for v5:
- None
---
 drivers/net/dsa/mv88e6xxx/chip.c | 21 +++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h |  1 +
 drivers/net/dsa/mv88e6xxx/port.h |  1 +
 3 files changed, 23 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 721bae2e579c..26ab4d676615 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5637,6 +5637,27 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.ops = &mv88e6250_ops,
 	},
 
+	[MV88E6071] = {
+		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6071,
+		.family = MV88E6XXX_FAMILY_6250,
+		.name = "Marvell 88E6071",
+		.num_databases = 64,
+		.num_ports = 7,
+		.num_internal_phys = 5,
+		.max_vid = 4095,
+		.max_frame_size = 2048,
+		.port_base_addr = 0x08,
+		.phy_base_addr = 0x00,
+		.global1_addr = 0x0f,
+		.global2_addr = 0x07,
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
index 1690b1a0f2e7..af42530da71e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -55,6 +55,7 @@ enum mv88e6xxx_frame_mode {
 /* List of supported models */
 enum mv88e6xxx_model {
 	MV88E6020,
+	MV88E6071,
 	MV88E6085,
 	MV88E6095,
 	MV88E6097,
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 169ce5b6fa31..494a221c9d9a 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -112,6 +112,7 @@
 #define MV88E6XXX_PORT_SWITCH_ID		0x03
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_MASK	0xfff0
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6020	0x0200
+#define MV88E6XXX_PORT_SWITCH_ID_PROD_6071	0x0710
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6085	0x04a0
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6095	0x0950
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6097	0x0990
-- 
2.20.1

