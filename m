Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB17A620B10
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 09:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbiKHIYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 03:24:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233764AbiKHIXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 03:23:55 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B391327B20
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 00:23:52 -0800 (PST)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id A521884FD1;
        Tue,  8 Nov 2022 09:23:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1667895830;
        bh=hLXrhRTurbcSSZsbXU8locKJgnsGkDQF25HkMYQuNwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WSwFG18mGgU388Pq0u+O3gPcPD9YeG2pG2wKkaDyvQFzly39tHbeDPUtBsZhEyU8s
         uUHbQbyNqteCWbVcqHoZQC53z4Z+5grCSxEIn0p2RTMQ9mLPOeJqaIpq0Tzx1ZYfjj
         3w69F/2VEKo9RL6shqQF14aBQu0FLOuWOLfJeKybNZMJYXl20u3u8H3F1NdhL3cPzr
         I1USqCtc8SkjvNe9k+Wu4yWVlYe2Bf5W8IcFeENVwzRkGHMMertWC2ibnnNe26hCuy
         NIDS198FL0D4CAhuFg7Z+vuAZ/rodlw++yfOvwPeRuxUTRM0d3lY2aF3jOq0XfiqKM
         WBRs5xlugiaRw==
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Lukasz Majewski <lukma@denx.de>
Subject: [PATCH 8/9] net: dsa: mv88e6071: Provide struct mv88e6xxx_ops
Date:   Tue,  8 Nov 2022 09:23:29 +0100
Message-Id: <20221108082330.2086671-9-lukma@denx.de>
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

This structure is the same as the one for mv88e6250 and is supposed
to ease further development of mv88e6071 (to put functions not present
on the mv88e6250 device).

Signed-off-by: Lukasz Majewski <lukma@denx.de>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 43 ++++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index e0224fc92ddf..1aba9d15a5e0 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4961,6 +4961,45 @@ static const struct mv88e6xxx_ops mv88e6250_ops = {
 	.phylink_get_caps = mv88e6250_phylink_get_caps,
 };
 
+static const struct mv88e6xxx_ops mv88e6071_ops = {
+	/* MV88E6XXX_FAMILY_6071 */
+	.ieee_pri_map = mv88e6250_g1_ieee_pri_map,
+	.ip_pri_map = mv88e6085_g1_ip_pri_map,
+	.irl_init_all = mv88e6352_g2_irl_init_all,
+	.get_eeprom = mv88e6xxx_g2_get_eeprom16,
+	.set_eeprom = mv88e6xxx_g2_set_eeprom16,
+	.set_switch_mac = mv88e6xxx_g2_set_switch_mac,
+	.phy_read = mv88e6xxx_g2_smi_phy_read,
+	.phy_write = mv88e6xxx_g2_smi_phy_write,
+	.port_set_link = mv88e6xxx_port_set_link,
+	.port_sync_link = mv88e6xxx_port_sync_link,
+	.port_set_rgmii_delay = mv88e6352_port_set_rgmii_delay,
+	.port_set_speed_duplex = mv88e6250_port_set_speed_duplex,
+	.port_tag_remap = mv88e6095_port_tag_remap,
+	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
+	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
+	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
+	.port_set_ether_type = mv88e6351_port_set_ether_type,
+	.port_egress_rate_limiting = mv88e6097_port_egress_rate_limiting,
+	.port_pause_limit = mv88e6097_port_pause_limit,
+	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
+	.stats_snapshot = mv88e6320_g1_stats_snapshot,
+	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
+	.stats_get_sset_count = mv88e6250_stats_get_sset_count,
+	.stats_get_strings = mv88e6250_stats_get_strings,
+	.stats_get_stats = mv88e6250_stats_get_stats,
+	.set_cpu_port = mv88e6095_g1_set_cpu_port,
+	.set_egress_port = mv88e6095_g1_set_egress_port,
+	.watchdog_ops = &mv88e6250_watchdog_ops,
+	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
+	.pot_clear = mv88e6xxx_g2_pot_clear,
+	.reset = mv88e6250_g1_reset,
+	.vtu_getnext = mv88e6185_g1_vtu_getnext,
+	.vtu_loadpurge = mv88e6185_g1_vtu_loadpurge,
+	.avb_ops = &mv88e6352_avb_ops,
+	.ptp_ops = &mv88e6250_ptp_ops,
+};
+
 static const struct mv88e6xxx_ops mv88e6290_ops = {
 	/* MV88E6XXX_FAMILY_6390 */
 	.setup_errata = mv88e6390_setup_errata,
@@ -5552,7 +5591,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.g2_irqs = 5,
 		.atu_move_port_mask = 0xf,
 		.dual_chip = true,
-		.ops = &mv88e6250_ops,
+		.ops = &mv88e6071_ops,
 	},
 
 	[MV88E6071] = {
@@ -5574,7 +5613,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0xf,
 		.dual_chip = true,
 		.ptp_support = true,
-		.ops = &mv88e6250_ops,
+		.ops = &mv88e6071_ops,
 	},
 
 	[MV88E6085] = {
-- 
2.37.2

