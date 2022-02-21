Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0585E4BDE7F
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357942AbiBUM3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 07:29:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357937AbiBUM3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 07:29:16 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3554B13E2B;
        Mon, 21 Feb 2022 04:28:53 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4K2M1L4bV6zVfmC;
        Mon, 21 Feb 2022 20:24:22 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 21 Feb 2022 20:28:50 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <edumazet@google.com>, <vvs@virtuozzo.com>,
        <keescook@chromium.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: vlan: allow vlan device MTU change follow real device from smaller to bigger
Date:   Mon, 21 Feb 2022 20:46:44 +0800
Message-ID: <20220221124644.1146105-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vlan device MTU can only follow real device change from bigger to smaller
but from smaller to bigger under the premise of vlan device MTU not exceed
the real device MTU.

This issue can be seen using the following commands:

ip link add link eth1 dev eth1.100 type vlan id 100
ip link set eth1 mtu 256
ip link set eth1 mtu 1500
ip link show

Modify to allow vlan device follow real device MTU change from smaller
to bigger when user has not configured vlan device MTU which is not
equal to real device MTU. That also ensure user configuration has higher
priority.

Fixes: 2e477c9bd2bb ("vlan: Propagate physical MTU changes")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/8021q/vlan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 788076b002b3..7de4f462525a 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -361,6 +361,7 @@ static int __vlan_device_event(struct net_device *dev, unsigned long event)
 static int vlan_device_event(struct notifier_block *unused, unsigned long event,
 			     void *ptr)
 {
+	unsigned int orig_mtu = ((struct netdev_notifier_info_ext *)ptr)->ext.mtu;
 	struct netlink_ext_ack *extack = netdev_notifier_info_to_extack(ptr);
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct vlan_group *grp;
@@ -419,7 +420,7 @@ static int vlan_device_event(struct notifier_block *unused, unsigned long event,
 
 	case NETDEV_CHANGEMTU:
 		vlan_group_for_each_dev(grp, i, vlandev) {
-			if (vlandev->mtu <= dev->mtu)
+			if (vlandev->mtu <= dev->mtu && vlandev->mtu != orig_mtu)
 				continue;
 
 			dev_set_mtu(vlandev, dev->mtu);
-- 
2.25.1

