Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C792ABEEE
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 15:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731284AbgKIOli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 09:41:38 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7620 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731276AbgKIOli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 09:41:38 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CVDFx45B3zLqrn;
        Mon,  9 Nov 2020 22:41:25 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Mon, 9 Nov 2020 22:41:25 +0800
From:   zhangxiaoxu <zhangxiaoxu5@huawei.com>
To:     <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <zhangxiaoxu5@huawei.com>, <f.fainelli@gmail.com>,
        <olteanv@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH] net: dsa: mv88e6xxx: Fix memleak in mv88e6xxx_region_atu_snapshot
Date:   Mon, 9 Nov 2020 09:44:16 -0500
Message-ID: <20201109144416.1540867-1-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When mv88e6xxx_fid_map return error, we lost free the table.

Fix it.

Fixes: bfb255428966 ("net: dsa: mv88e6xxx: Add devlink regions")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhangxiaoxu <zhangxiaoxu5@huawei.com>
---
 drivers/net/dsa/mv88e6xxx/devlink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/devlink.c b/drivers/net/dsa/mv88e6xxx/devlink.c
index 10cd1bfd81a0..ade04c036fd9 100644
--- a/drivers/net/dsa/mv88e6xxx/devlink.c
+++ b/drivers/net/dsa/mv88e6xxx/devlink.c
@@ -393,8 +393,10 @@ static int mv88e6xxx_region_atu_snapshot(struct devlink *dl,
 	mv88e6xxx_reg_lock(chip);
 
 	err = mv88e6xxx_fid_map(chip, fid_bitmap);
-	if (err)
+	if (err) {
+		kfree(table);
 		goto out;
+	}
 
 	while (1) {
 		fid = find_next_bit(fid_bitmap, MV88E6XXX_N_FID, fid + 1);
-- 
2.25.4

