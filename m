Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35F986B249A
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 13:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjCIMzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 07:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbjCIMzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 07:55:09 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946FC88EE9;
        Thu,  9 Mar 2023 04:55:06 -0800 (PST)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id DA4AA85E8E;
        Thu,  9 Mar 2023 13:55:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1678366504;
        bh=qWoHPsIf3pfANgKKB9K27q7gnFPLk3JK9JRFYW0OpbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TebVQ/GmPCLNbhZqZALCY8CfnkTaG2mcPXipRBlACsmBeaDBWuTcUOnzcw5clfxOe
         mkla6dAXJ8UwRszYR+uhjllKi6YgxmoezUzXurXJ/2LOTTMnqp4obFQ/W2qgzouj83
         AlSw7CYoDLfYQnCVcWEKImZHS0T9Wj0yP5z31i5tToZxNfhROx4EwTIoKP/Nf+eLAK
         ov/ocmZKcGzKQTZ7vWf1/P70Jnqt7u+MldwO6Tpaa3kLp2ySbz7ol2RFZhLOyJti4q
         6Imit/BOr2TfozSoDy5vOpU7j1UYfvqgzFl7JvKTjs4an2v2LRlflw3yHYI3f4COWy
         H5c9rX3MzC3kQ==
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
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Lukasz Majewski <lukma@denx.de>
Subject: [PATCH 2/7] net: dsa: mv88e6xxx: add support for MV88E6020 switch
Date:   Thu,  9 Mar 2023 13:54:16 +0100
Message-Id: <20230309125421.3900962-3-lukma@denx.de>
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

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

A mv88e6250 family (i.e. "LinkStreet") switch with 2 PHY and RMII
ports and no PTP support.

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Signed-off-by: Lukasz Majewski <lukma@denx.de>
---
Changes for v2:
- Add S-o-B
- Update commit message
- Add information about max packet size (2048 B)

Changes for v3:
- None

Changes for v4:
- Update the num_ports and num_internal_phys to be in sync with
  88e6020 documentation

Changes for v5:
- None
---
 drivers/net/dsa/mv88e6xxx/chip.c | 21 +++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h |  1 +
 drivers/net/dsa/mv88e6xxx/port.h |  1 +
 3 files changed, 23 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c097a0b19ba6..721bae2e579c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5616,6 +5616,27 @@ static const struct mv88e6xxx_ops mv88e6393x_ops = {
 };
 
 static const struct mv88e6xxx_info mv88e6xxx_table[] = {
+	[MV88E6020] = {
+		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6020,
+		.family = MV88E6XXX_FAMILY_6250,
+		.name = "Marvell 88E6020",
+		.num_databases = 64,
+		.num_ports = 4,
+		.num_internal_phys = 2,
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
index e2b88f1f8376..1690b1a0f2e7 100644
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
index aec9d4fd20e3..169ce5b6fa31 100644
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
2.20.1

