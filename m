Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 596804DD281
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 02:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbiCRBmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 21:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiCRBmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 21:42:49 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A90C2EE962;
        Thu, 17 Mar 2022 18:41:31 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KKRZ02Y1Yzcb3x;
        Fri, 18 Mar 2022 09:41:28 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Mar 2022 09:41:29 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <edumazet@google.com>, <sakiwit@gmail.com>,
        <sainath.grandhi@intel.com>, <maheshb@google.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v2 2/3] net: ipvlan: add net device refcount tracker
Date:   Fri, 18 Mar 2022 09:59:13 +0800
Message-ID: <e3e05793cbfe0ef491e27e7a865fa644c64522ea.1647568181.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1647568181.git.william.xuanziyang@huawei.com>
References: <cover.1647568181.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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

Add net device refcount tracker to ipvlan.

Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 drivers/net/ipvlan/ipvlan.h      | 1 +
 drivers/net/ipvlan/ipvlan_main.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan.h b/drivers/net/ipvlan/ipvlan.h
index 3837c897832e..6605199305b7 100644
--- a/drivers/net/ipvlan/ipvlan.h
+++ b/drivers/net/ipvlan/ipvlan.h
@@ -64,6 +64,7 @@ struct ipvl_dev {
 	struct list_head	pnode;
 	struct ipvl_port	*port;
 	struct net_device	*phy_dev;
+	netdevice_tracker	dev_tracker;
 	struct list_head	addrs;
 	struct ipvl_pcpu_stats	__percpu *pcpu_stats;
 	DECLARE_BITMAP(mac_filters, IPVLAN_MAC_FILTER_SIZE);
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index dcdc01403f22..be06f122092e 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -160,7 +160,7 @@ static int ipvlan_init(struct net_device *dev)
 	port->count += 1;
 
 	/* Get ipvlan's reference to phy_dev */
-	dev_hold(phy_dev);
+	dev_hold_track(phy_dev, &ipvlan->dev_tracker, GFP_KERNEL);
 
 	return 0;
 }
@@ -674,7 +674,7 @@ static void ipvlan_dev_free(struct net_device *dev)
 	struct ipvl_dev *ipvlan = netdev_priv(dev);
 
 	/* Get rid of the ipvlan's reference to phy_dev */
-	dev_put(ipvlan->phy_dev);
+	dev_put_track(ipvlan->phy_dev, &ipvlan->dev_tracker);
 }
 
 void ipvlan_link_setup(struct net_device *dev)
-- 
2.25.1

