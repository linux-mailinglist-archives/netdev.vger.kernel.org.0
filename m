Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB021B3A51
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 10:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgDVIkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 04:40:07 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52175 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725924AbgDVIkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 04:40:04 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Apr 2020 11:39:59 +0300
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 03M8dxge006118;
        Wed, 22 Apr 2020 11:39:59 +0300
From:   Maor Gottlieb <maorg@mellanox.com>
To:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org
Cc:     leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com, Maor Gottlieb <maorg@mellanox.com>
Subject: [PATCH V4 mlx5-next 02/15] bonding: Export skip slave logic to function
Date:   Wed, 22 Apr 2020 11:39:38 +0300
Message-Id: <20200422083951.17424-3-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200422083951.17424-1-maorg@mellanox.com>
References: <20200422083951.17424-1-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a preparation for following change that add array of
all slaves, extract code that skip slave to function.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Jay Vosburgh <jay.vosburgh@canonical.com>
---
 drivers/net/bonding/bond_main.c | 47 ++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 2e70e43c5df5..f7aded014f08 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4087,6 +4087,29 @@ static void bond_slave_arr_handler(struct work_struct *work)
 	bond_slave_arr_work_rearm(bond, 1);
 }
 
+static void bond_skip_slave(struct bond_up_slave *slaves,
+			    struct slave *skipslave)
+{
+	int idx;
+
+	/* Rare situation where caller has asked to skip a specific
+	 * slave but allocation failed (most likely!). BTW this is
+	 * only possible when the call is initiated from
+	 * __bond_release_one(). In this situation; overwrite the
+	 * skipslave entry in the array with the last entry from the
+	 * array to avoid a situation where the xmit path may choose
+	 * this to-be-skipped slave to send a packet out.
+	 */
+	for (idx = 0; slaves && idx < slaves->count; idx++) {
+		if (skipslave == slaves->arr[idx]) {
+			slaves->arr[idx] =
+				slaves->arr[slaves->count - 1];
+			slaves->count--;
+			break;
+		}
+	}
+}
+
 /* Build the usable slaves array in control path for modes that use xmit-hash
  * to determine the slave interface -
  * (a) BOND_MODE_8023AD
@@ -4156,27 +4179,9 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 	if (old_arr)
 		kfree_rcu(old_arr, rcu);
 out:
-	if (ret != 0 && skipslave) {
-		int idx;
-
-		/* Rare situation where caller has asked to skip a specific
-		 * slave but allocation failed (most likely!). BTW this is
-		 * only possible when the call is initiated from
-		 * __bond_release_one(). In this situation; overwrite the
-		 * skipslave entry in the array with the last entry from the
-		 * array to avoid a situation where the xmit path may choose
-		 * this to-be-skipped slave to send a packet out.
-		 */
-		old_arr = rtnl_dereference(bond->slave_arr);
-		for (idx = 0; old_arr != NULL && idx < old_arr->count; idx++) {
-			if (skipslave == old_arr->arr[idx]) {
-				old_arr->arr[idx] =
-				    old_arr->arr[old_arr->count-1];
-				old_arr->count--;
-				break;
-			}
-		}
-	}
+	if (ret != 0 && skipslave)
+		bond_skip_slave(rtnl_dereference(bond->slave_arr), skipslave);
+
 	return ret;
 }
 
-- 
2.17.2

