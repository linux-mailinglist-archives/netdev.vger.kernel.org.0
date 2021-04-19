Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D8C36457A
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 15:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233749AbhDSN53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 09:57:29 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:17377 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbhDSN52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 09:57:28 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FP7c434ndzlYv5;
        Mon, 19 Apr 2021 21:55:00 +0800 (CST)
Received: from DESKTOP-9883QJJ.china.huawei.com (10.136.114.155) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Mon, 19 Apr 2021 21:56:47 +0800
From:   zhudi <zhudi21@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <linyunsheng@huawei.com>
CC:     <netdev@vger.kernel.org>, <zhudi21@huawei.com>,
        <rose.chen@huawei.com>
Subject: [PATCH v2] net: fix a data race when get vlan device
Date:   Mon, 19 Apr 2021 21:56:41 +0800
Message-ID: <20210419135641.27077-1-zhudi21@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.136.114.155]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Di Zhu <zhudi21@huawei.com>

We encountered a crash: in the packet receiving process, we got an
illegal VLAN device address, but the VLAN device address saved in vmcore
is correct. After checking the code, we found a possible data
competition:
CPU 0:                             CPU 1:
    (RCU read lock)                  (RTNL lock)
    vlan_do_receive()		       register_vlan_dev()
      vlan_find_dev()

        ->__vlan_group_get_device()	 ->vlan_group_prealloc_vid()

In vlan_group_prealloc_vid(), We need to make sure that memset()
in kzalloc() is executed before assigning  value to vlan devices array:
=================================
kzalloc()
    ->memset(object, 0, size)

smp_wmb()

vg->vlan_devices_arrays[pidx][vidx] = array;
==================================

Because __vlan_group_get_device() function depends on this order.
otherwise we may get a wrong address from the hardware cache on
another cpu.

So fix it by adding memory barrier instruction to ensure the order
of memory operations.

Signed-off-by: Di Zhu <zhudi21@huawei.com>
---
/* v1 */
Link: https://lore.kernel.org/netdev/0d7c26f933eb4a95a170f021020e722e@huawei.com/

/* v2 */
-linyunsheng <linyunsheng@huawei.com>
  -update commit message
-add code comments
---
 net/8021q/vlan.c | 3 +++
 net/8021q/vlan.h | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 8b644113715e..fb3d3262dc1a 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -71,6 +71,9 @@ static int vlan_group_prealloc_vid(struct vlan_group *vg,
 	if (array == NULL)
 		return -ENOBUFS;
 
+	/* paired with smp_rmb() in __vlan_group_get_device() */
+	smp_wmb();
+
 	vg->vlan_devices_arrays[pidx][vidx] = array;
 	return 0;
 }
diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index 953405362795..fa3ad3d4d58c 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -57,6 +57,10 @@ static inline struct net_device *__vlan_group_get_device(struct vlan_group *vg,
 
 	array = vg->vlan_devices_arrays[pidx]
 				       [vlan_id / VLAN_GROUP_ARRAY_PART_LEN];
+
+	/* paired with smp_wmb() in vlan_group_prealloc_vid() */
+	smp_rmb();
+
 	return array ? array[vlan_id % VLAN_GROUP_ARRAY_PART_LEN] : NULL;
 }
 
-- 
2.23.0

