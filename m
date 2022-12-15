Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6305664DD11
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 15:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiLOOp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 09:45:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiLOOpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 09:45:55 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB56DB7;
        Thu, 15 Dec 2022 06:45:54 -0800 (PST)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id CCDA684EC2;
        Thu, 15 Dec 2022 15:45:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1671115552;
        bh=D6p/BoRStqcnYa2Wb2pX3TOnQiiewV652kz213LodFw=;
        h=From:To:Cc:Subject:Date:From;
        b=t1PLd21w/M31Q7JwTcARq2C0azSKCcIypJ7fO89oRB/KxMygNa3zorGmSoZFWmowT
         ja5T1UuDwLVjf5kgSWxIpJghyBvA67nLS0IOxIv9QHN3dlOCHUPh0GbTKrVQ3PnzrX
         8rk75nbegTRW3MyCktlzF50ALdQKujkdE5CltPdxuL8CCxR3T2Pvpp0HSS1QEWQNsl
         xEnvzjBNvWXE8ozR37dzy8cCN5K/ehL7c5q2TWKulLscUKfgai2WiMYdR0CyTLlDLw
         EfSHe8lO0aINZwHMQtdYD7SwerczYmqEBm0A5Zn+Cg2Ce52vAf3tEQbnOZrybo3fUS
         n99ayP1PFsDgw==
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lukasz Majewski <lukma@denx.de>
Subject: [PATCH v2 1/3] dsa: marvell: Provide per device information about max frame size
Date:   Thu, 15 Dec 2022 15:45:34 +0100
Message-Id: <20221215144536.3810578-1-lukma@denx.de>
X-Mailer: git-send-email 2.30.2
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

Different Marvell DSA switches support different size of max frame
bytes to be sent.

For example mv88e6185 supports max 1632 bytes, which is now in-driver
standard value. On the other hand - mv88e6250 supports 2048 bytes.

As this value is internal and may be different for each switch IC,
new entry in struct mv88e6xxx_info has been added to store it.

Signed-off-by: Lukasz Majewski <lukma@denx.de>
---
Changes for v2:
- Define max_frame_size with default value of 1632 bytes,
- Set proper value for the mv88e6250 switch SoC (linkstreet) family
---
 drivers/net/dsa/mv88e6xxx/chip.c | 13 ++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h |  1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 2ca3cbba5764..7ae4c389ce50 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3093,7 +3093,9 @@ static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
 	if (chip->info->ops->port_set_jumbo_size)
 		return 10240 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
 	else if (chip->info->ops->set_max_frame_size)
-		return 1632 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
+		return (chip->info->max_frame_size  - VLAN_ETH_HLEN
+			- EDSA_HLEN - ETH_FCS_LEN);
+
 	return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
 }
 
@@ -4461,6 +4463,7 @@ static const struct mv88e6xxx_ops mv88e6250_ops = {
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6250_ptp_ops,
 	.phylink_validate = mv88e6065_phylink_validate,
+	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
 
 static const struct mv88e6xxx_ops mv88e6290_ops = {
@@ -5060,6 +5063,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0xf,
 		.multi_chip = true,
 		.ops = &mv88e6095_ops,
+		.max_frame_size = 1632,
 	},
 
 	[MV88E6097] = {
@@ -5083,6 +5087,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.multi_chip = true,
 		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ops = &mv88e6097_ops,
+		.max_frame_size = 1632,
 	},
 
 	[MV88E6123] = {
@@ -5106,6 +5111,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.multi_chip = true,
 		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ops = &mv88e6123_ops,
+		.max_frame_size = 1632,
 	},
 
 	[MV88E6131] = {
@@ -5174,6 +5180,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ptp_support = true,
 		.ops = &mv88e6161_ops,
+		.max_frame_size = 1632,
 	},
 
 	[MV88E6165] = {
@@ -5197,6 +5204,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.multi_chip = true,
 		.ptp_support = true,
 		.ops = &mv88e6165_ops,
+		.max_frame_size = 1632,
 	},
 
 	[MV88E6171] = {
@@ -5312,6 +5320,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.multi_chip = true,
 		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ops = &mv88e6185_ops,
+		.max_frame_size = 1632,
 	},
 
 	[MV88E6190] = {
@@ -5440,6 +5449,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 2,
 		.invalid_port_mask = BIT(2) | BIT(3) | BIT(4),
 		.max_vid = 4095,
+		.max_frame_size = 2048,
 		.port_base_addr = 0x08,
 		.phy_base_addr = 0x00,
 		.global1_addr = 0x0f,
@@ -5486,6 +5496,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
+		.max_frame_size = 2048,
 		.port_base_addr = 0x08,
 		.phy_base_addr = 0x00,
 		.global1_addr = 0x0f,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 80dc7b549e81..9712b10fc4ed 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -130,6 +130,7 @@ struct mv88e6xxx_info {
 	unsigned int num_internal_phys;
 	unsigned int num_gpio;
 	unsigned int max_vid;
+	unsigned int max_frame_size;
 	unsigned int port_base_addr;
 	unsigned int phy_base_addr;
 	unsigned int global1_addr;
-- 
2.37.3

