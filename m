Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4CCC535A33
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 09:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345025AbiE0HUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 03:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345866AbiE0HUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 03:20:09 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EABAF68A2;
        Fri, 27 May 2022 00:20:06 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4L8bmG6NVPzDqMG;
        Fri, 27 May 2022 15:19:58 +0800 (CST)
Received: from dggpemm500018.china.huawei.com (7.185.36.111) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 27 May 2022 15:20:04 +0800
Received: from localhost.localdomain (10.175.112.125) by
 dggpemm500018.china.huawei.com (7.185.36.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 27 May 2022 15:20:03 +0800
From:   keliu <liuke94@huawei.com>
To:     <johannes@sipsolutions.net>, <kvalo@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     keliu <liuke94@huawei.com>
Subject: [PATCH] mac80211: Directly use ida_alloc()/free()
Date:   Fri, 27 May 2022 07:41:32 +0000
Message-ID: <20220527074132.2474867-1-liuke94@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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
ida_simple_get()/ida_simple_remove() .

Signed-off-by: keliu <liuke94@huawei.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index e9ec63e0e395..6ad884d9e9a4 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -290,8 +290,8 @@ static inline int hwsim_net_set_netgroup(struct net *net)
 {
 	struct hwsim_net *hwsim_net = net_generic(net, hwsim_net_id);
 
-	hwsim_net->netgroup = ida_simple_get(&hwsim_netgroup_ida,
-					     0, 0, GFP_KERNEL);
+	hwsim_net->netgroup = ida_alloc(&hwsim_netgroup_ida,
+					     GFP_KERNEL);
 	return hwsim_net->netgroup >= 0 ? 0 : -ENOMEM;
 }
 
@@ -4733,7 +4733,7 @@ static void __net_exit hwsim_exit_net(struct net *net)
 					 NULL);
 	}
 
-	ida_simple_remove(&hwsim_netgroup_ida, hwsim_net_get_netgroup(net));
+	ida_free(&hwsim_netgroup_ida, hwsim_net_get_netgroup(net));
 }
 
 static struct pernet_operations hwsim_net_ops = {
-- 
2.25.1

