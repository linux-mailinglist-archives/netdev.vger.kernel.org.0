Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDDD27602
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 08:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbfEWGcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 02:32:46 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52846 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725873AbfEWGcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 02:32:45 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 May 2019 09:32:39 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.213.18.180])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x4N6Wdsp008441;
        Thu, 23 May 2019 09:32:39 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     xiyou.wangcong@gmail.com, netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, ecree@solarflare.com, jiri@resnulli.us,
        pablo@netfilter.org, davem@davemloft.net, andy@greyhouse.net,
        jakub.kicinski@netronome.com, michael.chan@broadcom.com,
        vishal@chelsio.com, lucasb@mojatatu.com, roid@mellanox.com,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net] net: sched: don't use tc_action->order during action dump
Date:   Thu, 23 May 2019 09:32:31 +0300
Message-Id: <20190523063231.11581-1-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function tcf_action_dump() relies on tc_action->order field when starting
nested nla to send action data to userspace. This approach breaks in
several cases:

- When multiple filters point to same shared action, tc_action->order field
  is overwritten each time it is attached to filter. This causes filter
  dump to output action with incorrect attribute for all filters that have
  the action in different position (different order) from the last set
  tc_action->order value.

- When action data is displayed using tc action API (RTM_GETACTION), action
  order is overwritten by tca_action_gd() according to its position in
  resulting array of nl attributes, which will break filter dump for all
  filters attached to that shared action that expect it to have different
  order value.

Don't rely on tc_action->order when dumping actions. Set nla according to
action position in resulting array of actions instead.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 net/sched/act_api.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 683fcc00da49..c42ecf4b3c10 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -800,7 +800,7 @@ int tcf_action_dump(struct sk_buff *skb, struct tc_action *actions[],
 
 	for (i = 0; i < TCA_ACT_MAX_PRIO && actions[i]; i++) {
 		a = actions[i];
-		nest = nla_nest_start_noflag(skb, a->order);
+		nest = nla_nest_start_noflag(skb, i + 1);
 		if (nest == NULL)
 			goto nla_put_failure;
 		err = tcf_action_dump_1(skb, a, bind, ref);
@@ -1303,7 +1303,6 @@ tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
 			ret = PTR_ERR(act);
 			goto err;
 		}
-		act->order = i;
 		attr_size += tcf_action_fill_size(act);
 		actions[i - 1] = act;
 	}
-- 
2.21.0

