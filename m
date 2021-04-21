Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C9E366717
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 10:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236593AbhDUIkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 04:40:12 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17021 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235997AbhDUIkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 04:40:11 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FQDRm303QzPsHZ;
        Wed, 21 Apr 2021 16:36:36 +0800 (CST)
Received: from huawei.com (10.175.112.154) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.498.0; Wed, 21 Apr 2021
 16:39:30 +0800
From:   jinyiting <jinyiting@huawei.com>
To:     <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <andy@greyhouse.net>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <security@kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <xuhanbing@huawei.com>, <wangxiaogang3@huawei.com>
Subject: [PATCH] bonding: 3ad: Fix the conflict between bond_update_slave_arr and the state machine
Date:   Wed, 21 Apr 2021 16:38:21 +0800
Message-ID: <1618994301-1186-1-git-send-email-jinyiting@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.112.154]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bond works in mode 4, and performs down/up operations on the bond
that is normally negotiated. The probability of bond-> slave_arr is NULL

Test commands:
   ifconfig bond1 down
   ifconfig bond1 up

The conflict occurs in the following process：

__dev_open (CPU A)
--bond_open
  --queue_delayed_work(bond->wq,&bond->ad_work,0);
  --bond_update_slave_arr
    --bond_3ad_get_active_agg_info

ad_work(CPU B)
--bond_3ad_state_machine_handler
  --ad_agg_selection_logic

ad_work runs on cpu B. In the function ad_agg_selection_logic, all
agg->is_active will be cleared. Before the new active aggregator is
selected on CPU B, bond_3ad_get_active_agg_info failed on CPU A,
bond->slave_arr will be set to NULL. The best aggregator in
ad_agg_selection_logic has not changed, no need to update slave arr.

The conflict occurred in that ad_agg_selection_logic clears
agg->is_active under mode_lock, but bond_open -> bond_update_slave_arr
is inspecting agg->is_active outside the lock.

Also, bond_update_slave_arr is normal for potential sleep when
allocating memory, so replace the WARN_ON with a call to might_sleep.

Signed-off-by: jinyiting <jinyiting@huawei.com>
---

Previous versions:
 * https://lore.kernel.org/netdev/612b5e32-ea11-428e-0c17-e2977185f045@huawei.com/

 drivers/net/bonding/bond_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 74cbbb2..83ef62d 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4391,9 +4391,7 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 	int agg_id = 0;
 	int ret = 0;
 
-#ifdef CONFIG_LOCKDEP
-	WARN_ON(lockdep_is_held(&bond->mode_lock));
-#endif
+	might_sleep();
 
 	usable_slaves = kzalloc(struct_size(usable_slaves, arr,
 					    bond->slave_cnt), GFP_KERNEL);
@@ -4406,7 +4404,9 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
 		struct ad_info ad_info;
 
+		spin_lock_bh(&bond->mode_lock);
 		if (bond_3ad_get_active_agg_info(bond, &ad_info)) {
+			spin_unlock_bh(&bond->mode_lock);
 			pr_debug("bond_3ad_get_active_agg_info failed\n");
 			/* No active aggragator means it's not safe to use
 			 * the previous array.
@@ -4414,6 +4414,7 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 			bond_reset_slave_arr(bond);
 			goto out;
 		}
+		spin_unlock_bh(&bond->mode_lock);
 		agg_id = ad_info.aggregator_id;
 	}
 	bond_for_each_slave(bond, slave, iter) {
-- 
1.7.12.4

