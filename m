Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8795A74AF
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 06:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbiHaEKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 00:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiHaEKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 00:10:10 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937AA28E24;
        Tue, 30 Aug 2022 21:10:04 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MHVwt4c5nzlWZk;
        Wed, 31 Aug 2022 12:06:38 +0800 (CST)
Received: from ubuntu-82.huawei.com (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 31 Aug 2022 12:10:02 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <morbo@google.com>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>
Subject: [PATCH next-next 2/2] net: vlan: reduce indentation level in __vlan_find_dev_deep_rcu()
Date:   Wed, 31 Aug 2022 12:09:57 +0800
Message-ID: <917c41381e1155eefe84c610585c487d8073166f.1661916732.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1661916732.git.william.xuanziyang@huawei.com>
References: <cover.1661916732.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If vlan_info is NULL in __vlan_find_dev_deep_rcu(), else { ... } is
unnecessary. Remove it to reduce indentation level.

Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/8021q/vlan_core.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index 5aa8144101dc..027d4ebed9c0 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -77,23 +77,19 @@ struct net_device *__vlan_find_dev_deep_rcu(struct net_device *dev,
 					__be16 vlan_proto, u16 vlan_id)
 {
 	struct vlan_info *vlan_info = rcu_dereference(dev->vlan_info);
+	struct net_device *upper_dev;
 
-	if (vlan_info) {
+	if (vlan_info)
 		return vlan_group_get_device(&vlan_info->grp,
 					     vlan_proto, vlan_id);
-	} else {
-		/*
-		 * Lower devices of master uppers (bonding, team) do not have
-		 * grp assigned to themselves. Grp is assigned to upper device
-		 * instead.
-		 */
-		struct net_device *upper_dev;
 
-		upper_dev = netdev_master_upper_dev_get_rcu(dev);
-		if (upper_dev)
-			return __vlan_find_dev_deep_rcu(upper_dev,
-						    vlan_proto, vlan_id);
-	}
+	/* Lower devices of master uppers (bonding, team) do not have
+	 * grp assigned to themselves. Grp is assigned to upper device
+	 * instead.
+	 */
+	upper_dev = netdev_master_upper_dev_get_rcu(dev);
+	if (upper_dev)
+		return __vlan_find_dev_deep_rcu(upper_dev, vlan_proto, vlan_id);
 
 	return NULL;
 }
-- 
2.25.1

