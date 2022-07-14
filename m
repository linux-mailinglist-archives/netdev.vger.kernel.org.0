Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F745751D3
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 17:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240182AbiGNPby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 11:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232403AbiGNPbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 11:31:53 -0400
Received: from m15112.mail.126.com (m15112.mail.126.com [220.181.15.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F0EC54E615
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 08:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=XyHQf
        4gCupYQ1ZCA0xcaV+FkchTEhxop6Dv8x78x1EA=; b=mIj0OKf8f8VASrG2OWPyg
        guB7Wqo0F0PXWqLxuhroRyJAjG04xfhiJZ0wTR+EOsLQeEMsOJAA9Iq0u1LhigOr
        rfWb2zWrLUEgz5g5srZKfIOSzRJ3Hm5o9SS8CK1OpwNhCfEYon9TxzGb4DYudX80
        35kgO7BggWAOaplLBFXfco=
Received: from localhost.localdomain (unknown [124.16.139.61])
        by smtp2 (Coremail) with SMTP id DMmowAAHC_3cNtBiP0JwEw--.51055S2;
        Thu, 14 Jul 2022 23:31:41 +0800 (CST)
From:   Liang He <windhl@126.com>
To:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, windhl@126.com, netdev@vger.kernel.org
Subject: [PATCH v2] net: dsa: microchip: ksz_common: Fix refcount leak bug
Date:   Thu, 14 Jul 2022 23:31:38 +0800
Message-Id: <20220714153138.375919-1-windhl@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DMmowAAHC_3cNtBiP0JwEw--.51055S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CryrXr4rZw4xGFy7KFW3ZFb_yoW8Xw4DpF
        W5CFy3ZrWjgF4fuw40yw48Zryjg3WDJr4jgFyxCa9xCrs8tF1kXF18uF9xWrn8AFWrC3yY
        qr45AFWavas8urJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0ziFksDUUUUU=
X-Originating-IP: [124.16.139.61]
X-CM-SenderInfo: hzlqvxbo6rjloofrz/xtbBGgc+F1-HZf5bDAAAsg
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

Fixes: 912aae27c6af ("net: dsa: microchip: really look for phy-mode in port nodes")
Signed-off-by: Liang He <windhl@126.com>
---
 changelog:
 
 v2: use correct fix tag advised by Vladimir Oltean
 v1: fix bug

 v1 link: https://lore.kernel.org/all/20220713115428.367840-1-windhl@126.com/

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

