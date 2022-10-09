Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA145F9283
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbiJIWtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233171AbiJIWrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:47:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B393F64;
        Sun,  9 Oct 2022 15:24:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF88B60C19;
        Sun,  9 Oct 2022 22:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0332C43470;
        Sun,  9 Oct 2022 22:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354157;
        bh=luY0azZv8cvOxQJDnUdYH2ZEc90x8GEWhYFzr1Sap24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mScMQSwe3gSm47ekE+PSYs25fKmeTh8ifRq1dwFmAdOFAckV0jelJLeKvGGkYhV2i
         e/OX/UeZbLBKB/qS2vthjmu88K0T4c/R68Ep84sH/O6AH/7Ukwl82pajG7YtRRmfVG
         u1zUxAEKPnyDJkr5SIZMsq9PEFkS1TrkcVegdxKhU1cIFUUT5pIsEil0+Mo4UY3oVz
         eY7gA0TXjWwk81amkBDfy4Z+FUjfLvjZCNCP1HdcK5AEOloa6PW1o8n6o2sdHVXpQm
         XmitZbDYNY6U7V66r0kvfbGogzB55RH5d880wQyMZocuFSfBgw1mh3foXnbYTaC5WX
         rNaEnaCzIYVJg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, vinicius.gomes@intel.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 22/34] net/sched: taprio: taprio_dump and taprio_change are protected by rtnl_mutex
Date:   Sun,  9 Oct 2022 18:21:16 -0400
Message-Id: <20221009222129.1218277-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222129.1218277-1-sashal@kernel.org>
References: <20221009222129.1218277-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 18cdd2f0998a4967b1fff4c43ed9aef049e42c39 ]

Since the writer-side lock is taken here, we do not need to open an RCU
read-side critical section, instead we can use rtnl_dereference() to
tell lockdep we are serialized with concurrent writes.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index ab8835a72cee..d70a5c4aafe5 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1480,10 +1480,8 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	}
 	INIT_LIST_HEAD(&new_admin->entries);
 
-	rcu_read_lock();
-	oper = rcu_dereference(q->oper_sched);
-	admin = rcu_dereference(q->admin_sched);
-	rcu_read_unlock();
+	oper = rtnl_dereference(q->oper_sched);
+	admin = rtnl_dereference(q->admin_sched);
 
 	/* no changes - no new mqprio settings */
 	if (!taprio_mqprio_cmp(dev, mqprio))
@@ -1843,9 +1841,8 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct nlattr *nest, *sched_nest;
 	unsigned int i;
 
-	rcu_read_lock();
-	oper = rcu_dereference(q->oper_sched);
-	admin = rcu_dereference(q->admin_sched);
+	oper = rtnl_dereference(q->oper_sched);
+	admin = rtnl_dereference(q->admin_sched);
 
 	opt.num_tc = netdev_get_num_tc(dev);
 	memcpy(opt.prio_tc_map, dev->prio_tc_map, sizeof(opt.prio_tc_map));
@@ -1889,8 +1886,6 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	nla_nest_end(skb, sched_nest);
 
 done:
-	rcu_read_unlock();
-
 	return nla_nest_end(skb, nest);
 
 admin_error:
@@ -1900,7 +1895,6 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	nla_nest_cancel(skb, nest);
 
 start_error:
-	rcu_read_unlock();
 	return -ENOSPC;
 }
 
-- 
2.35.1

