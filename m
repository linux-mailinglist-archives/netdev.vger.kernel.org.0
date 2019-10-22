Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 775A9E0636
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 16:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbfJVOTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 10:19:01 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:33593 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727140AbfJVOS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 10:18:58 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Oct 2019 16:18:53 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9MEIqav023677;
        Tue, 22 Oct 2019 17:18:53 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, mleitner@redhat.com, dcaratti@redhat.com,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 07/13] net: sched: act_gact: support fast init flag to skip pcpu allocation
Date:   Tue, 22 Oct 2019 17:17:58 +0300
Message-Id: <20191022141804.27639-8-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191022141804.27639-1-vladbu@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend gact action with u32 netlink TCA_GACT_FLAGS field. Use it to pass
fast initialization flag defined by previous patch in this series and don't
allocate percpu counters in init code when flag is set. Extend action dump
callback to also dump flags, if field is set.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/uapi/linux/tc_act/tc_gact.h |  1 +
 net/sched/act_gact.c                | 18 ++++++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/tc_act/tc_gact.h b/include/uapi/linux/tc_act/tc_gact.h
index 37e5392e02c7..b621b7df9919 100644
--- a/include/uapi/linux/tc_act/tc_gact.h
+++ b/include/uapi/linux/tc_act/tc_gact.h
@@ -26,6 +26,7 @@ enum {
 	TCA_GACT_PARMS,
 	TCA_GACT_PROB,
 	TCA_GACT_PAD,
+	TCA_GACT_FLAGS,
 	__TCA_GACT_MAX
 };
 #define TCA_GACT_MAX (__TCA_GACT_MAX - 1)
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index 67654aaa37a3..9d052ade336a 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -48,6 +48,8 @@ static g_rand gact_rand[MAX_RAND] = { NULL, gact_net_rand, gact_determ };
 static const struct nla_policy gact_policy[TCA_GACT_MAX + 1] = {
 	[TCA_GACT_PARMS]	= { .len = sizeof(struct tc_gact) },
 	[TCA_GACT_PROB]		= { .len = sizeof(struct tc_gact_p) },
+	[TCA_GACT_FLAGS]	= { .type = NLA_BITFIELD32,
+				    .validation_data = &tca_flags_allowed },
 };
 
 static int tcf_gact_init(struct net *net, struct nlattr *nla,
@@ -60,8 +62,8 @@ static int tcf_gact_init(struct net *net, struct nlattr *nla,
 	struct tcf_chain *goto_ch = NULL;
 	struct tc_gact *parm;
 	struct tcf_gact *gact;
+	u32 index, flags = 0;
 	int ret = 0;
-	u32 index;
 	int err;
 #ifdef CONFIG_GACT_PROB
 	struct tc_gact_p *p_parm = NULL;
@@ -96,10 +98,13 @@ static int tcf_gact_init(struct net *net, struct nlattr *nla,
 	}
 #endif
 
+	if (tb[TCA_GACT_FLAGS])
+		flags = nla_get_bitfield32(tb[TCA_GACT_FLAGS]).value;
+
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_gact_ops, bind, 0);
+				     &act_gact_ops, bind, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
@@ -209,6 +214,15 @@ static int tcf_gact_dump(struct sk_buff *skb, struct tc_action *a,
 			goto nla_put_failure;
 	}
 #endif
+	if (gact->tcf_flags) {
+		struct nla_bitfield32 flags = { gact->tcf_flags,
+						gact->tcf_flags };
+
+		if (nla_put(skb, TCA_GACT_FLAGS, sizeof(struct nla_bitfield32),
+			    &flags))
+			goto nla_put_failure;
+	}
+
 	tcf_tm_dump(&t, &gact->tcf_tm);
 	if (nla_put_64bit(skb, TCA_GACT_TM, sizeof(t), &t, TCA_GACT_PAD))
 		goto nla_put_failure;
-- 
2.21.0

