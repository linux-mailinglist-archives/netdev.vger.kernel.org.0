Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E7E5735D8
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 13:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235972AbiGMLy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 07:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235679AbiGMLy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 07:54:56 -0400
Received: from m15114.mail.126.com (m15114.mail.126.com [220.181.15.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB5F4C04D0
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 04:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=z4F7U
        rsR4M0u368p/ZuwOaUCBWyfKpYbu5TaXutIPq0=; b=Q7M5N+Rktu963LUTZzJi+
        RhuxlCCfnfyv5lqiM558JT0kr8ZerN55WcaLZaRDxiHMSOIjtixLSEPycCFw9Lic
        hG630OC1FjqKXMpvxzepHHvA+GIIDuoBqGr5OzTl+Ry0dNt9dLy66+JkOVHaMJog
        cVob5jbNsolntziWqQcF5o=
Received: from localhost.localdomain (unknown [124.16.139.61])
        by smtp7 (Coremail) with SMTP id DsmowAC3hfF0ss5ioXFZEw--.46074S2;
        Wed, 13 Jul 2022 19:54:29 +0800 (CST)
From:   Liang He <windhl@126.com>
To:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, windhl@126.com, netdev@vger.kernel.org
Subject: [PATCH] net: dsa: microchip: ksz_common: Fix refcount leak bug
Date:   Wed, 13 Jul 2022 19:54:28 +0800
Message-Id: <20220713115428.367840-1-windhl@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsmowAC3hfF0ss5ioXFZEw--.46074S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CryUZF1DZw13tF15ArW5Jrb_yoW8GFy8pF
        W5CFy3ZrWUKr45uw40yw48ZFyjgF4Utr4jgFyxCa9xur95tF1kXF1UWFZxWr98AFWrA3yY
        qr4UAFWa9F98urJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRUfHbUUUUU=
X-Originating-IP: [124.16.139.61]
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbi2hY9F1uwMZZ3FwAAsK
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ksz_switch_register(), we should call of_node_put() for the
reference returned by of_get_child_by_name() which has increased
the refcount.

Fixes: 44e53c88828f ("net: dsa: microchip: support for "ethernet-ports" node")
Signed-off-by: Liang He <windhl@126.com>
---
 
 drivers/net/dsa/microchip/ksz_common.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 9ca8c8d7740f..92a500e1ccd2 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1038,18 +1038,21 @@ int ksz_switch_register(struct ksz_device *dev,
 		ports = of_get_child_by_name(dev->dev->of_node, "ethernet-ports");
 		if (!ports)
 			ports = of_get_child_by_name(dev->dev->of_node, "ports");
-		if (ports)
+		if (ports) {
 			for_each_available_child_of_node(ports, port) {
 				if (of_property_read_u32(port, "reg",
 							 &port_num))
 					continue;
 				if (!(dev->port_mask & BIT(port_num))) {
 					of_node_put(port);
+					of_node_put(ports);
 					return -EINVAL;
 				}
 				of_get_phy_mode(port,
 						&dev->ports[port_num].interface);
 			}
+			of_node_put(ports);
+		}
 		dev->synclko_125 = of_property_read_bool(dev->dev->of_node,
 							 "microchip,synclko-125");
 		dev->synclko_disable = of_property_read_bool(dev->dev->of_node,
-- 
2.25.1

