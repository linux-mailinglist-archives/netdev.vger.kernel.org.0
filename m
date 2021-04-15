Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2263036008B
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 05:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbhDODgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 23:36:09 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16465 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhDODgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 23:36:08 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FLQ0l3cMLzwS3r;
        Thu, 15 Apr 2021 11:33:27 +0800 (CST)
Received: from DESKTOP-9883QJJ.china.huawei.com (10.136.114.155) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Thu, 15 Apr 2021 11:35:34 +0800
From:   zhudi <zhudi21@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <zhudi21@huawei.com>,
        <rose.chen@huawei.com>
Subject: [PATCH] net: fix a data race when get vlan device
Date:   Thu, 15 Apr 2021 11:35:27 +0800
Message-ID: <20210415033527.26877-1-zhudi21@huawei.com>
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

In vlan_group_prealloc_vid(), We need to make sure that kzalloc is
executed before assigning a value to vlan devices array, otherwise we
may get a wrong address from the hardware cache on another cpu.

So fix it by adding memory barrier instruction to ensure the order
of memory operations.

Signed-off-by: Di Zhu <zhudi21@huawei.com>
---
 net/8021q/vlan.c | 2 ++
 net/8021q/vlan.h | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 8b644113715e..4f541e05cd3f 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -71,6 +71,8 @@ static int vlan_group_prealloc_vid(struct vlan_group *vg,
 	if (array == NULL)
 		return -ENOBUFS;
 
+	smp_wmb();
+
 	vg->vlan_devices_arrays[pidx][vidx] = array;
 	return 0;
 }
diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index 953405362795..7408fda084d3 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -57,6 +57,9 @@ static inline struct net_device *__vlan_group_get_device(struct vlan_group *vg,
 
 	array = vg->vlan_devices_arrays[pidx]
 				       [vlan_id / VLAN_GROUP_ARRAY_PART_LEN];
+
+	smp_rmb();
+
 	return array ? array[vlan_id % VLAN_GROUP_ARRAY_PART_LEN] : NULL;
 }
 
-- 
2.23.0

