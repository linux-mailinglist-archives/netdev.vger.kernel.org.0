Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D034B7ABB
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 23:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243471AbiBOWxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 17:53:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbiBOWx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 17:53:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CF190FCD
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 14:53:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8AB2B81AEA
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 22:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3C8C340EB;
        Tue, 15 Feb 2022 22:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644965595;
        bh=rWGXoXCWwEqhGlsLzBAeG8RngZXYWA46qiGVDyTsfNw=;
        h=From:To:Cc:Subject:Date:From;
        b=X16YRA9ED64BQS70y6pf6sXzeZgrzxNOZldW64my8quXCSGNv9piw4q6f/19M1r/V
         qUStdHJdx/wlQ0x6HmiHgjsvEz24rKtC58iYrBG1P4SBydARBIv4nlr/pMuwOWwDh1
         LmQLH6RUoqNUNplWstb1k8GLbX04A4ZVtib/o9juHLUFAck9/38sXgBAqbSRDnom/d
         SXUyhPmusOPFZCxOFXCLzdEGvCH9zXITFx74ZZNt0BZX0Nhpfw6FKYH56QrI7T4hd4
         L/q6BVaRZvJnknvxp7VCvK0c7D3GS/4vq0s1J521PjLciFptmqZq/LdSAurId4RhvE
         uGdutXDvjLxJQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, lucien.xin@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/2] net: transition netdev reg state earlier in run_todo
Date:   Tue, 15 Feb 2022 14:53:09 -0800
Message-Id: <20220215225310.3679266-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In prep for unregistering netdevs out of order move the netdev
state validation and change outside of the loop.

While at it modernize this code and use WARN() instead of
pr_err() + dump_stack().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/dev.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 909fb3815910..2749776e2dd2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9906,6 +9906,7 @@ static void netdev_wait_allrefs(struct net_device *dev)
  */
 void netdev_run_todo(void)
 {
+	struct net_device *dev, *tmp;
 	struct list_head list;
 #ifdef CONFIG_LOCKDEP
 	struct list_head unlink_list;
@@ -9926,24 +9927,23 @@ void netdev_run_todo(void)
 
 	__rtnl_unlock();
 
-
 	/* Wait for rcu callbacks to finish before next phase */
 	if (!list_empty(&list))
 		rcu_barrier();
 
-	while (!list_empty(&list)) {
-		struct net_device *dev
-			= list_first_entry(&list, struct net_device, todo_list);
-		list_del(&dev->todo_list);
-
+	list_for_each_entry_safe(dev, tmp, &list, todo_list) {
 		if (unlikely(dev->reg_state != NETREG_UNREGISTERING)) {
-			pr_err("network todo '%s' but state %d\n",
-			       dev->name, dev->reg_state);
-			dump_stack();
+			netdev_WARN(dev, "run_todo but not unregistering\n");
+			list_del(&dev->todo_list);
 			continue;
 		}
 
 		dev->reg_state = NETREG_UNREGISTERED;
+	}
+
+	while (!list_empty(&list)) {
+		dev = list_first_entry(&list, struct net_device, todo_list);
+		list_del(&dev->todo_list);
 
 		netdev_wait_allrefs(dev);
 
-- 
2.34.1

