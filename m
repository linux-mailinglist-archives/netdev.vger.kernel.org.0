Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A36C4B03A9
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 03:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbiBJC7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 21:59:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbiBJC7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 21:59:34 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234EE25DE5
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 18:59:37 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id x4so648155plb.4
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 18:59:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fDTKJLBL2nHQGA/1gjYFXK9c3PHQFqSUp/H4/PYY0ME=;
        b=R3HNmgASoR7jIqZbxik6cl673kQQqWbFXTMCuIy2f3HfXdVWyzck7Q/56TskbVb8rx
         1cp0ccb3Ft6nmb1H4uiqH4kaYQUIZTPykPHOX83Psm7X5J5xAWyQPdN/gZhcS7oFRPz3
         5FuFhJadSP4R1c7xkJHy92iHgc34xnTd6IO3fdGJHVRrMLob4coop+5ki9tD8xJA3H5H
         EGaV3OlUDSTg4GRzn90gyeruDdvH9g+N58P1J8f18TYwyd/t11Czk1P7pZr1J0WnpqlH
         MuZM7XiaAvQNEcGVQbFGBKqOpT4I2z7FpakY/19qGb0JiLp4oKDmtP738jluCHQuhhuy
         JqZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fDTKJLBL2nHQGA/1gjYFXK9c3PHQFqSUp/H4/PYY0ME=;
        b=xKlnoo7QzAClR2yy+ZfjTJkn1jIdI3tse6AHqjWw4zs36smLLvs1JSzeqNplGaWThA
         0OkhoRUgvmN5PKEeuscL852S6GXwb2GWFrv8rArvc+VujZlhqspkwY2U2hI35mkKzpFe
         HoGOnREgJA0Ql9l+j/9GHGweMsypuGyVrZQe89AzPjaquloBKtzs2unypq6wuhuv1Vfj
         MryR0tuiQ32M75y2w2i+0ohpGj+CmmAD4+vtkpD0En0vf6TTo6VxV3m6SgCN01KsEhwP
         5unOXOqt+UlTFSpUXmxlVxX5IOHrtSJHBlR96ZSMn8aoQgOfygFrfwgcuOgnc9+VZJgr
         e4/w==
X-Gm-Message-State: AOAM5326XT1sRphPIhmK8TrPi+9AqOU5D+GW0xKr3SHAk+zIh3/kkRMC
        JKppDaek+B+3j/ERJJJagf4=
X-Google-Smtp-Source: ABdhPJzAq0LJGMgRn/ljQFabup0v/k6Cpyi6lvijLmZys2tPv27A4oHbypsmArpPwT0Y47i91gUt4Q==
X-Received: by 2002:a17:903:31cd:: with SMTP id v13mr5368021ple.29.1644461976608;
        Wed, 09 Feb 2022 18:59:36 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c3d8:67ff:656a:cfd9])
        by smtp.gmail.com with ESMTPSA id s32sm8938369pga.83.2022.02.09.18.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 18:59:35 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] net: make net->dev_unreg_count atomic
Date:   Wed,  9 Feb 2022 18:59:32 -0800
Message-Id: <20220210025932.966618-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Having to acquire rtnl from netdev_run_todo() for every dismantled
device is not desirable when/if rtnl is under stress.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/net_namespace.h |  2 +-
 net/core/dev.c              | 11 ++++-------
 net/core/rtnetlink.c        |  2 +-
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 374cc7b260fcdf15a8fc2c709d0b0fc6d99e8c5c..c4f5601f6e32aff401dfb462fb4949ec7d37833a 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -63,7 +63,7 @@ struct net {
 						 */
 	spinlock_t		rules_mod_lock;
 
-	unsigned int		dev_unreg_count;
+	atomic_t		dev_unreg_count;
 
 	unsigned int		dev_base_seq;	/* protected by rtnl_mutex */
 	int			ifindex;
diff --git a/net/core/dev.c b/net/core/dev.c
index f5ef5160108131de8892555d2c73e4adaf98eeed..2c3b8744e00c01448e8882460760fdb3304f0476 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9143,7 +9143,7 @@ DECLARE_WAIT_QUEUE_HEAD(netdev_unregistering_wq);
 static void net_set_todo(struct net_device *dev)
 {
 	list_add_tail(&dev->todo_list, &net_todo_list);
-	dev_net(dev)->dev_unreg_count++;
+	atomic_inc(&dev_net(dev)->dev_unreg_count);
 }
 
 static netdev_features_t netdev_sync_upper_features(struct net_device *lower,
@@ -9965,11 +9965,8 @@ void netdev_run_todo(void)
 		if (dev->needs_free_netdev)
 			free_netdev(dev);
 
-		/* Report a network device has been unregistered */
-		rtnl_lock();
-		dev_net(dev)->dev_unreg_count--;
-		__rtnl_unlock();
-		wake_up(&netdev_unregistering_wq);
+		if (atomic_dec_and_test(&dev_net(dev)->dev_unreg_count))
+			wake_up(&netdev_unregistering_wq);
 
 		/* Free network device */
 		kobject_put(&dev->dev.kobj);
@@ -10898,7 +10895,7 @@ static void __net_exit rtnl_lock_unregistering(struct list_head *net_list)
 		unregistering = false;
 
 		list_for_each_entry(net, net_list, exit_list) {
-			if (net->dev_unreg_count > 0) {
+			if (atomic_read(&net->dev_unreg_count) > 0) {
 				unregistering = true;
 				break;
 			}
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 710da8a36729d6a9293b610b029bd33aa38d6514..a6fad3df42a800792ed362e7f75de20880c53726 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -459,7 +459,7 @@ static void rtnl_lock_unregistering_all(void)
 		 * setup_net() and cleanup_net() are not possible.
 		 */
 		for_each_net(net) {
-			if (net->dev_unreg_count > 0) {
+			if (atomic_read(&net->dev_unreg_count) > 0) {
 				unregistering = true;
 				break;
 			}
-- 
2.35.0.263.gb82422642f-goog

