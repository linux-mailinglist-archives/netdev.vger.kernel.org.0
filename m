Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00D0A65B3B3
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 16:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236027AbjABPCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 10:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233115AbjABPCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 10:02:39 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABF37659;
        Mon,  2 Jan 2023 07:02:37 -0800 (PST)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 240E985200;
        Mon,  2 Jan 2023 16:02:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1672671754;
        bh=NEiZVyMqOMDmBNSHqeJTKYpiyotNbeArYRPr0pWpGZE=;
        h=From:To:Cc:Subject:Date:From;
        b=AtIF/BGuYeCWuXJMBOf6aDeXE5YBQY8Pyox/303GJBR2YlzaAYAQ6JfdVnb6NQMEN
         iGqrNGrDAiqrPFjL188kuGGE3/JO2znSI3JQPYWLpCwG8lZ4JiPB47uEsTRcAFvt9T
         v6d0ue/71pR6V3VRiilK/2QSGqNz4AEcE8zhk0vu/PNoqDfNCWPq3jROJUoBIyie/7
         HfkUl8cbU3ELXcXgTN/1mY72Xc4q1FQ0T+0IqedNrtssoL0rG13Ir6GiLtJmAxc2tj
         ehU5WBBY5Q80K9tD8usIo0rugj9gII0/DUEnGVMdd0wHLcOXrjzGQsVPEdlZoqEZ4Q
         2MLSLJfeJJQNg==
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz Majewski <lukma@denx.de>
Subject: [PATCH v3 1/3] dsa: marvell: Provide per device information about max frame size
Date:   Mon,  2 Jan 2023 16:02:07 +0100
Message-Id: <20230102150209.985419-1-lukma@denx.de>
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

Changes for v3:
- Add default value for 1632B of the max frame size (to avoid problems
  with not defined values)
---
 drivers/net/dsa/mv88e6xxx/chip.c | 13 ++++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h |  1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 242b8b325504..19668e549391 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3548,7 +3548,9 @@ static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
 	if (chip->info->ops->port_set_jumbo_size)
 		return 10240 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
 	else if (chip->info->ops->set_max_frame_size)
-		return 1632 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
+		return (max_t(int, chip->info->max_frame_size, 1632)
+			- VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN);
+
 	return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
 }
 
@@ -4955,6 +4957,7 @@ static const struct mv88e6xxx_ops mv88e6250_ops = {
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6250_ptp_ops,
 	.phylink_get_caps = mv88e6250_phylink_get_caps,
+	.set_max_frame_size = mv88e6185_g1_set_max_frame_size,
 };
 
 static const struct mv88e6xxx_ops mv88e6290_ops = {
@@ -5574,6 +5577,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0xf,
 		.multi_chip = true,
 		.ops = &mv88e6095_ops,
+		.max_frame_size = 1632,
 	},
 
 	[MV88E6097] = {
@@ -5598,6 +5602,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.multi_chip = true,
 		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ops = &mv88e6097_ops,
+		.max_frame_size = 1632,
 	},
 
 	[MV88E6123] = {
@@ -5622,6 +5627,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.multi_chip = true,
 		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ops = &mv88e6123_ops,
+		.max_frame_size = 1632,
 	},
 
 	[MV88E6131] = {
@@ -5692,6 +5698,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ptp_support = true,
 		.ops = &mv88e6161_ops,
+		.max_frame_size = 1632,
 	},
 
 	[MV88E6165] = {
@@ -5716,6 +5723,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.multi_chip = true,
 		.ptp_support = true,
 		.ops = &mv88e6165_ops,
+		.max_frame_size = 1632,
 	},
 
 	[MV88E6171] = {
@@ -5835,6 +5843,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.multi_chip = true,
 		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ops = &mv88e6185_ops,
+		.max_frame_size = 1632,
 	},
 
 	[MV88E6190] = {
@@ -5968,6 +5977,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_internal_phys = 2,
 		.invalid_port_mask = BIT(2) | BIT(3) | BIT(4),
 		.max_vid = 4095,
+		.max_frame_size = 2048,
 		.port_base_addr = 0x08,
 		.phy_base_addr = 0x00,
 		.global1_addr = 0x0f,
@@ -6015,6 +6025,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
+		.max_frame_size = 2048,
 		.port_base_addr = 0x08,
 		.phy_base_addr = 0x00,
 		.global1_addr = 0x0f,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index e693154cf803..55948ef56cd0 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -132,6 +132,7 @@ struct mv88e6xxx_info {
 	unsigned int num_gpio;
 	unsigned int max_vid;
 	unsigned int max_sid;
+	unsigned int max_frame_size;
 	unsigned int port_base_addr;
 	unsigned int phy_base_addr;
 	unsigned int global1_addr;
-- 
2.20.1

