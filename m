Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564664DE74F
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 10:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242598AbiCSJgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 05:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234179AbiCSJgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 05:36:17 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538FC274296;
        Sat, 19 Mar 2022 02:34:56 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KLG036wLQzfYl1;
        Sat, 19 Mar 2022 17:33:23 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 19 Mar 2022 17:34:54 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
CC:     <edumazet@google.com>, <brianvv@google.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v3 1/3] net: ipvlan: fix potential UAF problem for phy_dev
Date:   Sat, 19 Mar 2022 17:52:37 +0800
Message-ID: <abef9f7ad2c6e6b8ae053225766d34f3fc930ddf.1647664114.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1647664114.git.william.xuanziyang@huawei.com>
References: <cover.1647664114.git.william.xuanziyang@huawei.com>
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

There is a known scenario can trigger UAF problem for lower
netdevice as following:

Someone module puts the NETDEV_UNREGISTER event handler to a
work, and lower netdevice is accessed in the work handler. But
when the work is excuted, lower netdevice has been destroyed
because upper netdevice did not get reference to lower netdevice
correctly.

Although it can not happen for ipvlan now because there is no
way to access phy_dev outside ipvlan. But it is necessary to
add the reference operation to phy_dev to avoid the potential
UAF problem in the future.

Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 drivers/net/ipvlan/ipvlan_main.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 696e245f6d00..dcdc01403f22 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -158,6 +158,10 @@ static int ipvlan_init(struct net_device *dev)
 	}
 	port = ipvlan_port_get_rtnl(phy_dev);
 	port->count += 1;
+
+	/* Get ipvlan's reference to phy_dev */
+	dev_hold(phy_dev);
+
 	return 0;
 }
 
@@ -665,6 +669,14 @@ void ipvlan_link_delete(struct net_device *dev, struct list_head *head)
 }
 EXPORT_SYMBOL_GPL(ipvlan_link_delete);
 
+static void ipvlan_dev_free(struct net_device *dev)
+{
+	struct ipvl_dev *ipvlan = netdev_priv(dev);
+
+	/* Get rid of the ipvlan's reference to phy_dev */
+	dev_put(ipvlan->phy_dev);
+}
+
 void ipvlan_link_setup(struct net_device *dev)
 {
 	ether_setup(dev);
@@ -674,6 +686,7 @@ void ipvlan_link_setup(struct net_device *dev)
 	dev->priv_flags |= IFF_UNICAST_FLT | IFF_NO_QUEUE;
 	dev->netdev_ops = &ipvlan_netdev_ops;
 	dev->needs_free_netdev = true;
+	dev->priv_destructor = ipvlan_dev_free;
 	dev->header_ops = &ipvlan_header_ops;
 	dev->ethtool_ops = &ipvlan_ethtool_ops;
 }
-- 
2.25.1

