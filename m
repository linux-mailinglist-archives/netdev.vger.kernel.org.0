Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A302536BC3
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 11:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbiE1JKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 05:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiE1JKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 05:10:16 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC8AF31;
        Sat, 28 May 2022 02:10:14 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4L9G7946B9zgY9h;
        Sat, 28 May 2022 17:08:37 +0800 (CST)
Received: from dggpemm500018.china.huawei.com (7.185.36.111) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 28 May 2022 17:10:12 +0800
Received: from localhost.localdomain (10.175.112.125) by
 dggpemm500018.china.huawei.com (7.185.36.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 28 May 2022 17:10:11 +0800
From:   Ke Liu <liuke94@huawei.com>
To:     <johannes@sipsolutions.net>
CC:     <kvalo@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Ke Liu <liuke94@huawei.com>
Subject: [PATCH v2] mac80211: Directly use ida_alloc()/free()
Date:   Sat, 28 May 2022 09:31:40 +0000
Message-ID: <20220528093140.1573816-1-liuke94@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500018.china.huawei.com (7.185.36.111)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use ida_alloc()/ida_free() instead of deprecated
ida_simple_get()/ida_simple_remove().

Signed-off-by: Ke Liu <liuke94@huawei.com>
---
v2 deal with alignment to fix
---
 drivers/net/wireless/mac80211_hwsim.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 2f746eb64507..bd408d260e9c 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -290,8 +290,7 @@ static inline int hwsim_net_set_netgroup(struct net *net)
 {
 	struct hwsim_net *hwsim_net = net_generic(net, hwsim_net_id);
 
-	hwsim_net->netgroup = ida_simple_get(&hwsim_netgroup_ida,
-					     0, 0, GFP_KERNEL);
+	hwsim_net->netgroup = ida_alloc(&hwsim_netgroup_ida, GFP_KERNEL);
 	return hwsim_net->netgroup >= 0 ? 0 : -ENOMEM;
 }
 
@@ -4733,7 +4732,7 @@ static void __net_exit hwsim_exit_net(struct net *net)
 					 NULL);
 	}
 
-	ida_simple_remove(&hwsim_netgroup_ida, hwsim_net_get_netgroup(net));
+	ida_free(&hwsim_netgroup_ida, hwsim_net_get_netgroup(net));
 }
 
 static struct pernet_operations hwsim_net_ops = {
-- 
2.25.1

