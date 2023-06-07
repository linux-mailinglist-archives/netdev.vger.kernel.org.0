Return-Path: <netdev+bounces-8902-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4028C7263A3
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:03:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CFA11C20E33
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:03:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64B9E1ACCF;
	Wed,  7 Jun 2023 15:03:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8801ACCE
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 15:03:22 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAA61720
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:03:20 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1q6ugx-0001DD-GX; Wed, 07 Jun 2023 17:03:19 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: jhs@mojatatu.com,
	xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH net 1/3] net/sched: act_ipt: add sanity checks on table name and hook locations
Date: Wed,  7 Jun 2023 16:59:52 +0200
Message-Id: <20230607145954.19324-2-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230607145954.19324-1-fw@strlen.de>
References: <20230607145954.19324-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Looks like "tc" hard-codes "mangle" as the only supported table
name, but on kernel side there are no checks.

This is wrong.  Not all xtables targets are safe to call from tc.
E.g. "nat" targets assume skb has a conntrack object assigned to it.
Normally those get called from netfilter nat core which consults the
nat table to obtain the address mapping.

"tc" userspace either sets PRE or POSTROUTING as hook number, but there
is no validation of this on kernel side, so update netlink policy to
reject bogus numbers.  Some targets may assume skb_dst is set for
input/forward hooks, so prevent those from being used.

act_ipt uses the hook number in two places:
1. the state hook number, this is fine as-is
2. to set par.hook_mask

The latter is a bit mask, so update the assignment to make
xt_check_target() to the right thing.

Followup patch adds required checks for the skb/packet headers before
calling the targets evaluation function.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/sched/act_ipt.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 5d96ffebd40f..ea7f151e7dd2 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -48,7 +48,7 @@ static int ipt_init_target(struct net *net, struct xt_entry_target *t,
 	par.entryinfo = &e;
 	par.target    = target;
 	par.targinfo  = t->data;
-	par.hook_mask = hook;
+	par.hook_mask = 1 << hook;
 	par.family    = NFPROTO_IPV4;
 
 	ret = xt_check_target(&par, t->u.target_size - sizeof(*t), 0, false);
@@ -85,7 +85,8 @@ static void tcf_ipt_release(struct tc_action *a)
 
 static const struct nla_policy ipt_policy[TCA_IPT_MAX + 1] = {
 	[TCA_IPT_TABLE]	= { .type = NLA_STRING, .len = IFNAMSIZ },
-	[TCA_IPT_HOOK]	= { .type = NLA_U32 },
+	[TCA_IPT_HOOK]	= NLA_POLICY_RANGE(NLA_U32, NF_INET_PRE_ROUTING,
+					   NF_INET_NUMHOOKS),
 	[TCA_IPT_INDEX]	= { .type = NLA_U32 },
 	[TCA_IPT_TARG]	= { .len = sizeof(struct xt_entry_target) },
 };
@@ -158,15 +159,27 @@ static int __tcf_ipt_init(struct net *net, unsigned int id, struct nlattr *nla,
 			return -EEXIST;
 		}
 	}
+
+	err = -EINVAL;
 	hook = nla_get_u32(tb[TCA_IPT_HOOK]);
+	switch (hook) {
+	case NF_INET_PRE_ROUTING:
+		break;
+	case NF_INET_POST_ROUTING:
+		break;
+	default:
+		goto err1;
+	}
+
+	if (tb[TCA_IPT_TABLE]) {
+		/* mangle only for now */
+		if (nla_strcmp(tb[TCA_IPT_TABLE], "mangle"))
+			goto err1;
+	}
 
-	err = -ENOMEM;
-	tname = kmalloc(IFNAMSIZ, GFP_KERNEL);
+	tname = kstrdup("mangle", GFP_KERNEL);
 	if (unlikely(!tname))
 		goto err1;
-	if (tb[TCA_IPT_TABLE] == NULL ||
-	    nla_strscpy(tname, tb[TCA_IPT_TABLE], IFNAMSIZ) >= IFNAMSIZ)
-		strcpy(tname, "mangle");
 
 	t = kmemdup(td, td->u.target_size, GFP_KERNEL);
 	if (unlikely(!t))
-- 
2.39.3


