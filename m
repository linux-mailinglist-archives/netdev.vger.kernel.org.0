Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E20D442556
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 02:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhKBB5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 21:57:05 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:15330 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbhKBB5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 21:57:03 -0400
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HjtHb0lKFz90SL;
        Tue,  2 Nov 2021 09:54:19 +0800 (CST)
Received: from ubuntu-82.huawei.com (10.175.104.82) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.15; Tue, 2 Nov 2021 09:54:26 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <jgg@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net v2] net: vlan: fix a UAF in vlan_dev_real_dev()
Date:   Tue, 2 Nov 2021 10:12:18 +0800
Message-ID: <20211102021218.955277-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeml757-chm.china.huawei.com (10.1.199.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The real_dev of a vlan net_device may be freed after
unregister_vlan_dev(). Access the real_dev continually by
vlan_dev_real_dev() will trigger the UAF problem for the
real_dev like following:

==================================================================
BUG: KASAN: use-after-free in vlan_dev_real_dev+0xf9/0x120
Call Trace:
 kasan_report.cold+0x83/0xdf
 vlan_dev_real_dev+0xf9/0x120
 is_eth_port_of_netdev_filter.part.0+0xb1/0x2c0
 is_eth_port_of_netdev_filter+0x28/0x40
 ib_enum_roce_netdev+0x1a3/0x300
 ib_enum_all_roce_netdevs+0xc7/0x140
 netdevice_event_work_handler+0x9d/0x210
...

Freed by task 9288:
 kasan_save_stack+0x1b/0x40
 kasan_set_track+0x1c/0x30
 kasan_set_free_info+0x20/0x30
 __kasan_slab_free+0xfc/0x130
 slab_free_freelist_hook+0xdd/0x240
 kfree+0xe4/0x690
 kvfree+0x42/0x50
 device_release+0x9f/0x240
 kobject_put+0x1c8/0x530
 put_device+0x1b/0x30
 free_netdev+0x370/0x540
 ppp_destroy_interface+0x313/0x3d0
...

Move the put_device(real_dev) to vlan_dev_free(). Ensure
real_dev not be freed before vlan_dev unregistered.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+e4df4e1389e28972e955@syzkaller.appspotmail.com
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/8021q/vlan.c     | 3 ---
 net/8021q/vlan_dev.c | 3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 55275ef9a31a..a3a0a5e994f5 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -123,9 +123,6 @@ void unregister_vlan_dev(struct net_device *dev, struct list_head *head)
 	}
 
 	vlan_vid_del(real_dev, vlan->vlan_proto, vlan_id);
-
-	/* Get rid of the vlan's reference to real_dev */
-	dev_put(real_dev);
 }
 
 int vlan_check_real_dev(struct net_device *real_dev,
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 0c21d1fec852..aeeb5f90417b 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -843,6 +843,9 @@ static void vlan_dev_free(struct net_device *dev)
 
 	free_percpu(vlan->vlan_pcpu_stats);
 	vlan->vlan_pcpu_stats = NULL;
+
+	/* Get rid of the vlan's reference to real_dev */
+	dev_put(vlan->real_dev);
 }
 
 void vlan_setup(struct net_device *dev)
-- 
2.25.1

