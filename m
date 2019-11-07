Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A6FF2E0E
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 13:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388554AbfKGMTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 07:19:06 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:5742 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388319AbfKGMTF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 07:19:05 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8DCB73B4000C330688B5;
        Thu,  7 Nov 2019 20:19:02 +0800 (CST)
Received: from localhost.localdomain (10.90.53.225) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Thu, 7 Nov 2019 20:18:55 +0800
From:   Chen Wandun <chenwandun@huawei.com>
To:     <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <chenwandun@huawei.com>
Subject: [PATCH] net: dsa: mv88e6xxx: global2: Fix gcc compile error
Date:   Thu, 7 Nov 2019 20:26:07 +0800
Message-ID: <1573129568-94008-1-git-send-email-chenwandun@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit c5f299d59261 ("net: dsa: mv88e6xxx: global1_atu: Add helper for
get next"), it add a parameter in mv88e6xxx_g2_atu_stats_get only when
CONFIG_NET_DSA_MV88E6XXX_GLOBAL2 enabled, it also should make the same
change when CONFIG_NET_DSA_MV88E6XXX_GLOBAL2 disabled.

drivers/net/dsa/mv88e6xxx/chip.c: In function mv88e6xxx_devlink_atu_bin_get:
drivers/net/dsa/mv88e6xxx/chip.c:2752:8: error: too many arguments to function mv88e6xxx_g2_atu_stats_get
  err = mv88e6xxx_g2_atu_stats_get(chip, &occupancy);
        ^~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from drivers/net/dsa/mv88e6xxx/chip.c:36:0:
drivers/net/dsa/mv88e6xxx/global2.h:535:19: note: declared here
 static inline int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip)
                   ^~~~~~~~~~~~~~~~~~~~~~~~~~
make[4]: *** [drivers/net/dsa/mv88e6xxx/chip.o] Error 1

Fixes: c5f299d59261 ("net: dsa: mv88e6xxx: global1_atu: Add helper for get next")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
---
 drivers/net/dsa/mv88e6xxx/global2.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
index d80ad20..1f42ee6 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -532,7 +532,8 @@ static inline int mv88e6xxx_g2_atu_stats_set(struct mv88e6xxx_chip *chip,
 	return -EOPNOTSUPP;
 }
 
-static inline int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip)
+static inline int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip,
+					     u16 *stats)
 {
 	return -EOPNOTSUPP;
 }
-- 
2.7.4

