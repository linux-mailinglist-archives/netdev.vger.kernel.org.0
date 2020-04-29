Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA4B1BE054
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 16:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbgD2OKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 10:10:45 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:37186 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726691AbgD2OKo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 10:10:44 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 79FA820E5DA8037B5AF0;
        Wed, 29 Apr 2020 22:10:43 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Wed, 29 Apr 2020
 22:10:36 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] net: dsa: mv88e6xxx: remove duplicate assignment of struct members
Date:   Wed, 29 Apr 2020 22:10:01 +0800
Message-ID: <20200429141001.8361-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These struct members named 'phylink_validate' was assigned twice:

static const struct mv88e6xxx_ops mv88e6190_ops = {
	......
	.phylink_validate = mv88e6390_phylink_validate,
	......
	.phylink_validate = mv88e6390_phylink_validate,
};

static const struct mv88e6xxx_ops mv88e6190x_ops = {
	......
	.phylink_validate = mv88e6390_phylink_validate,
	......
	.phylink_validate = mv88e6390x_phylink_validate,
};

static const struct mv88e6xxx_ops mv88e6191_ops = {
	......
	.phylink_validate = mv88e6390_phylink_validate,
	......
	.phylink_validate = mv88e6390_phylink_validate,
};

static const struct mv88e6xxx_ops mv88e6290_ops = {
	......
	.phylink_validate = mv88e6390_phylink_validate,
	......
	.phylink_validate = mv88e6390_phylink_validate,
};

Remove all the first one and leave the second one which are been used in
fact. Be aware that for 'mv88e6190x_ops' the assignment functions is
different while the others are all the same. This fixes the following
coccicheck warning:

drivers/net/dsa/mv88e6xxx/chip.c:3911:48-49: phylink_validate: first
occurrence line 3965, second occurrence line 3967
drivers/net/dsa/mv88e6xxx/chip.c:3970:49-50: phylink_validate: first
occurrence line 4024, second occurrence line 4026
drivers/net/dsa/mv88e6xxx/chip.c:4029:48-49: phylink_validate: first
occurrence line 4082, second occurrence line 4085
drivers/net/dsa/mv88e6xxx/chip.c:4184:48-49: phylink_validate: first
occurrence line 4238, second occurrence line 4242

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index dd8a5666a584..2b4a723c8306 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3962,7 +3962,6 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
-	.phylink_validate = mv88e6390_phylink_validate,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_validate = mv88e6390_phylink_validate,
 };
@@ -4021,7 +4020,6 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
-	.phylink_validate = mv88e6390_phylink_validate,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_validate = mv88e6390x_phylink_validate,
 };
@@ -4079,7 +4077,6 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
-	.phylink_validate = mv88e6390_phylink_validate,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
 	.phylink_validate = mv88e6390_phylink_validate,
@@ -4235,7 +4232,6 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
-	.phylink_validate = mv88e6390_phylink_validate,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
-- 
2.21.1

