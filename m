Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A520245E420
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 02:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349802AbhKZBsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 20:48:00 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:15870 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351614AbhKZBqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 20:46:00 -0500
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J0ctf4YQbz91NH;
        Fri, 26 Nov 2021 09:42:18 +0800 (CST)
Received: from ubuntu-82.huawei.com (10.175.104.82) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Fri, 26 Nov 2021 09:42:46 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: vlan: fix underflow for the real_dev refcnt
Date:   Fri, 26 Nov 2021 09:59:42 +0800
Message-ID: <20211126015942.2918542-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeml757-chm.china.huawei.com (10.1.199.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Inject error before dev_hold(real_dev) in register_vlan_dev(),
and execute the following testcase:

ip link add dev dummy1 type dummy
ip link add name dummy1.100 link dummy1 type vlan id 100
ip link del dev dummy1

When the dummy netdevice is removed, we will get a WARNING as following:

=======================================================================
refcount_t: decrement hit 0; leaking memory.
WARNING: CPU: 2 PID: 0 at lib/refcount.c:31 refcount_warn_saturate+0xbf/0x1e0

and an endless loop of:

=======================================================================
unregister_netdevice: waiting for dummy1 to become free. Usage count = -1073741824

That is because dev_put(real_dev) in vlan_dev_free() be called without
dev_hold(real_dev) in register_vlan_dev(). It makes the refcnt of real_dev
underflow.

Move the dev_hold(real_dev) to vlan_dev_init() which is the call-back of
ndo_init(). That makes dev_hold() and dev_put() for vlan's real_dev
symmetrical.

Fixes: 563bcbae3ba2 ("net: vlan: fix a UAF in vlan_dev_real_dev()")
Reported-by: Petr Machata <petrm@nvidia.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/8021q/vlan.c     | 3 ---
 net/8021q/vlan_dev.c | 3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index a3a0a5e994f5..abaa5d96ded2 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -184,9 +184,6 @@ int register_vlan_dev(struct net_device *dev, struct netlink_ext_ack *extack)
 	if (err)
 		goto out_unregister_netdev;
 
-	/* Account for reference in struct vlan_dev_priv */
-	dev_hold(real_dev);
-
 	vlan_stacked_transfer_operstate(real_dev, dev, vlan);
 	linkwatch_fire_event(dev); /* _MUST_ call rfc2863_policy() */
 
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index ab6dee28536d..a54535cbcf4c 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -615,6 +615,9 @@ static int vlan_dev_init(struct net_device *dev)
 	if (!vlan->vlan_pcpu_stats)
 		return -ENOMEM;
 
+	/* Get vlan's reference to real_dev */
+	dev_hold(real_dev);
+
 	return 0;
 }
 
-- 
2.25.1

