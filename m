Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580D943C90D
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 13:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbhJ0MAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 08:00:46 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14868 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236185AbhJ0MAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 08:00:45 -0400
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HfRz82jdBz90Lv;
        Wed, 27 Oct 2021 19:58:12 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.15; Wed, 27 Oct 2021 19:58:15 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <jgg@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: vlan: fix a UAF in vlan_dev_real_dev()
Date:   Wed, 27 Oct 2021 20:16:06 +0800
Message-ID: <20211027121606.3300860-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

Set vlan->real_dev to NULL after dev_put(real_dev) in
unregister_vlan_dev(). Check real_dev is not NULL before
access it in vlan_dev_real_dev().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+e4df4e1389e28972e955@syzkaller.appspotmail.com
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/8021q/vlan.c      | 1 +
 net/8021q/vlan_core.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 55275ef9a31a..1106da84e725 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -126,6 +126,7 @@ void unregister_vlan_dev(struct net_device *dev, struct list_head *head)
 
 	/* Get rid of the vlan's reference to real_dev */
 	dev_put(real_dev);
+	vlan->real_dev = NULL;
 }
 
 int vlan_check_real_dev(struct net_device *real_dev,
diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index 59bc13b5f14f..343f34479d8b 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -103,7 +103,7 @@ struct net_device *vlan_dev_real_dev(const struct net_device *dev)
 {
 	struct net_device *ret = vlan_dev_priv(dev)->real_dev;
 
-	while (is_vlan_dev(ret))
+	while (ret && is_vlan_dev(ret))
 		ret = vlan_dev_priv(ret)->real_dev;
 
 	return ret;
-- 
2.25.1

