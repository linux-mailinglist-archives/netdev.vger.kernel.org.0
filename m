Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4797A5F8FE9
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbiJIWSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbiJIWSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:18:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A202F019;
        Sun,  9 Oct 2022 15:15:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2F6160D17;
        Sun,  9 Oct 2022 22:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5228C433D6;
        Sun,  9 Oct 2022 22:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353537;
        bh=XwHKS7e8GthxQUR4oQfDVgwh4JKJsT8M94kHeLGQLys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBK3+JU+Ba0NrroQG7mPn+fVxpJR+ngG/8Y0nYxLayPV3VUu3zOOugXmcRQJ7HUoA
         gb39+FoJvdCXJOuN75TTVNBxUe6pmbnhQYkxixzLOObtoDapvzoD2PYS4BzARTzcQP
         I1VQHCUVhnGENU4c+v83lIAb/LF595Gcb+1YDSQOrjszFipUQcExwYZ+gH/3+lAxbp
         gSG3hF8jJwkpH3IznKCfg7ZSTOf6kTKyevp14tRUXvIsbSSb3Mx3CCIypbiFK9Qwhe
         LNUOZe/fialliWlk+VB0mO0F429LmVJhZ10Ii4Et6Grss+NlkQJh4IupNZHbvcXxwQ
         6Msyyk6tH+emA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, vinicius.gomes@intel.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 55/77] net/sched: taprio: taprio_dump and taprio_change are protected by rtnl_mutex
Date:   Sun,  9 Oct 2022 18:07:32 -0400
Message-Id: <20221009220754.1214186-55-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009220754.1214186-1-sashal@kernel.org>
References: <20221009220754.1214186-1-sashal@kernel.org>
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
index 86675a79da1e..71408136d4a0 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1492,10 +1492,8 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
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
@@ -1888,9 +1886,8 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	struct nlattr *nest, *sched_nest;
 	unsigned int i;
 
-	rcu_read_lock();
-	oper = rcu_dereference(q->oper_sched);
-	admin = rcu_dereference(q->admin_sched);
+	oper = rtnl_dereference(q->oper_sched);
+	admin = rtnl_dereference(q->admin_sched);
 
 	opt.num_tc = netdev_get_num_tc(dev);
 	memcpy(opt.prio_tc_map, dev->prio_tc_map, sizeof(opt.prio_tc_map));
@@ -1934,8 +1931,6 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	nla_nest_end(skb, sched_nest);
 
 done:
-	rcu_read_unlock();
-
 	return nla_nest_end(skb, nest);
 
 admin_error:
@@ -1945,7 +1940,6 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	nla_nest_cancel(skb, nest);
 
 start_error:
-	rcu_read_unlock();
 	return -ENOSPC;
 }
 
-- 
2.35.1

