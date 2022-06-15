Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E8C54BF68
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 03:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344695AbiFOBtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 21:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbiFOBtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 21:49:36 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6CA48320;
        Tue, 14 Jun 2022 18:49:35 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LN7W057bWzjY7G;
        Wed, 15 Jun 2022 09:48:28 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 15 Jun
 2022 09:49:32 +0800
From:   Zhengchao Shao <shaozhengchao@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
        <shaozhengchao@huawei.com>
Subject: [PATCH ipsec-next] xfrm: change the type of xfrm_register_km and xfrm_unregister_km
Date:   Wed, 15 Jun 2022 09:55:19 +0800
Message-ID: <20220615015519.96975-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Functions xfrm_register_km and xfrm_unregister_km do always return 0,
change the type of functions to void.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 include/net/xfrm.h    | 4 ++--
 net/key/af_key.c      | 6 +-----
 net/xfrm/xfrm_state.c | 6 ++----
 net/xfrm/xfrm_user.c  | 6 ++----
 4 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index c39d910d4b45..2b2d93aaae78 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -583,8 +583,8 @@ struct xfrm_mgr {
 	bool			(*is_alive)(const struct km_event *c);
 };
 
-int xfrm_register_km(struct xfrm_mgr *km);
-int xfrm_unregister_km(struct xfrm_mgr *km);
+void xfrm_register_km(struct xfrm_mgr *km);
+void xfrm_unregister_km(struct xfrm_mgr *km);
 
 struct xfrm_tunnel_skb_cb {
 	union {
diff --git a/net/key/af_key.c b/net/key/af_key.c
index fb16d7c4e1b8..fda2dcc8a383 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -3894,14 +3894,10 @@ static int __init ipsec_pfkey_init(void)
 	err = sock_register(&pfkey_family_ops);
 	if (err != 0)
 		goto out_unregister_pernet;
-	err = xfrm_register_km(&pfkeyv2_mgr);
-	if (err != 0)
-		goto out_sock_unregister;
+	xfrm_register_km(&pfkeyv2_mgr);
 out:
 	return err;
 
-out_sock_unregister:
-	sock_unregister(PF_KEY);
 out_unregister_pernet:
 	unregister_pernet_subsys(&pfkey_net_ops);
 out_unregister_key_proto:
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 08564e0eef20..03b180878e61 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2481,22 +2481,20 @@ EXPORT_SYMBOL(xfrm_user_policy);
 
 static DEFINE_SPINLOCK(xfrm_km_lock);
 
-int xfrm_register_km(struct xfrm_mgr *km)
+void xfrm_register_km(struct xfrm_mgr *km)
 {
 	spin_lock_bh(&xfrm_km_lock);
 	list_add_tail_rcu(&km->list, &xfrm_km_list);
 	spin_unlock_bh(&xfrm_km_lock);
-	return 0;
 }
 EXPORT_SYMBOL(xfrm_register_km);
 
-int xfrm_unregister_km(struct xfrm_mgr *km)
+void xfrm_unregister_km(struct xfrm_mgr *km)
 {
 	spin_lock_bh(&xfrm_km_lock);
 	list_del_rcu(&km->list);
 	spin_unlock_bh(&xfrm_km_lock);
 	synchronize_rcu();
-	return 0;
 }
 EXPORT_SYMBOL(xfrm_unregister_km);
 
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 6a58fec6a1fb..2ff017117730 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -3633,10 +3633,8 @@ static int __init xfrm_user_init(void)
 	rv = register_pernet_subsys(&xfrm_user_net_ops);
 	if (rv < 0)
 		return rv;
-	rv = xfrm_register_km(&netlink_mgr);
-	if (rv < 0)
-		unregister_pernet_subsys(&xfrm_user_net_ops);
-	return rv;
+	xfrm_register_km(&netlink_mgr);
+	return 0;
 }
 
 static void __exit xfrm_user_exit(void)
-- 
2.17.1

