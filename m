Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A75B3597D64
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 06:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243053AbiHREZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 00:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243403AbiHREZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 00:25:50 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA07F31207;
        Wed, 17 Aug 2022 21:25:48 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4M7Wv51R4Pz1N7Jr;
        Thu, 18 Aug 2022 12:22:25 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 18 Aug 2022 12:25:46 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 18 Aug
 2022 12:25:46 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>
CC:     <johannes@sipsolutions.net>
Subject: [PATCH -next] wifi: mac80211: fix missing dev_kfree_skb() in error path in ieee80211_tx_control_port()
Date:   Thu, 18 Aug 2022 12:33:49 +0800
Message-ID: <20220818043349.4168835-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing dev_kfree_skb() in error path in ieee80211_tx_control_port()
to avoid memory leak.

Fixes: dd820ed6336a ("wifi: mac80211: return error from control port TX for drops")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 net/mac80211/tx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 45df9932d0ba..594bd70ee641 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -5885,6 +5885,7 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	rcu_read_lock();
 	err = ieee80211_lookup_ra_sta(sdata, skb, &sta);
 	if (err) {
+		dev_kfree_skb(skb);
 		rcu_read_unlock();
 		return err;
 	}
-- 
2.25.1

