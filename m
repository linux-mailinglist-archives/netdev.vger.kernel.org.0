Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7104D5DAF
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 09:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239715AbiCKIqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 03:46:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233411AbiCKIqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 03:46:43 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713B71BA91F;
        Fri, 11 Mar 2022 00:45:40 -0800 (PST)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KFKC31TJRzcZyn;
        Fri, 11 Mar 2022 16:40:47 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 11 Mar 2022 16:45:38 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 1/2] net: macvlan: fix potential UAF problem for lowerdev
Date:   Fri, 11 Mar 2022 17:03:26 +0800
Message-ID: <5e4fa8717da38025cd353085d5733d1928b11b25.1646989143.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646989143.git.william.xuanziyang@huawei.com>
References: <cover.1646989143.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

Add the reference operation to lowerdev of macvlan to avoid
the potential UAF problem under the following known scenario:

Someone module puts the NETDEV_UNREGISTER event handler to a
work, and lowerdev is accessed in the work handler. But when
the work is excuted, lowerdev has been destroyed because upper
macvlan did not get reference to lowerdev correctly.

That likes as the scenario occurred by
commit 563bcbae3ba2 ("net: vlan: fix a UAF in vlan_dev_real_dev()").

Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 drivers/net/macvlan.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 33753a2fde29..d36af413e372 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -889,7 +889,7 @@ static void macvlan_set_lockdep_class(struct net_device *dev)
 static int macvlan_init(struct net_device *dev)
 {
 	struct macvlan_dev *vlan = netdev_priv(dev);
-	const struct net_device *lowerdev = vlan->lowerdev;
+	struct net_device *lowerdev = vlan->lowerdev;
 	struct macvlan_port *port = vlan->port;
 
 	dev->state		= (dev->state & ~MACVLAN_STATE_MASK) |
@@ -911,6 +911,9 @@ static int macvlan_init(struct net_device *dev)
 
 	port->count += 1;
 
+	/* Get macvlan's reference to lowerdev */
+	dev_hold(lowerdev);
+
 	return 0;
 }
 
@@ -1173,6 +1176,14 @@ static const struct net_device_ops macvlan_netdev_ops = {
 	.ndo_features_check	= passthru_features_check,
 };
 
+static void macvlan_dev_free(struct net_device *dev)
+{
+	struct macvlan_dev *vlan = netdev_priv(dev);
+
+	/* Get rid of the macvlan's reference to lowerdev */
+	dev_put(vlan->lowerdev);
+}
+
 void macvlan_common_setup(struct net_device *dev)
 {
 	ether_setup(dev);
@@ -1184,6 +1195,7 @@ void macvlan_common_setup(struct net_device *dev)
 	dev->priv_flags	       |= IFF_UNICAST_FLT | IFF_CHANGE_PROTO_DOWN;
 	dev->netdev_ops		= &macvlan_netdev_ops;
 	dev->needs_free_netdev	= true;
+	dev->priv_destructor	= macvlan_dev_free;
 	dev->header_ops		= &macvlan_hard_header_ops;
 	dev->ethtool_ops	= &macvlan_ethtool_ops;
 }
-- 
2.25.1

