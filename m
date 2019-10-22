Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9824BE0632
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 16:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbfJVOS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 10:18:59 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:33627 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727309AbfJVOS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 10:18:58 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Oct 2019 16:18:53 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9MEIqb1023677;
        Tue, 22 Oct 2019 17:18:53 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, mleitner@redhat.com, dcaratti@redhat.com,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 11/13] net: sched: act_vlan: support fast init flag to skip pcpu allocation
Date:   Tue, 22 Oct 2019 17:18:02 +0300
Message-Id: <20191022141804.27639-12-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191022141804.27639-1-vladbu@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend vlan action with u32 netlink TCA_VLAN_FLAGS field. Use it to pass
fast initialization flag defined by previous patch in this series and don't
allocate percpu counters in init code when flag is set. Extend action dump
callback to also dump flags, if field is set.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/uapi/linux/tc_act/tc_vlan.h |  1 +
 net/sched/act_vlan.c                | 17 +++++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/tc_act/tc_vlan.h b/include/uapi/linux/tc_act/tc_vlan.h
index 168995b54a70..b2847ed14f08 100644
--- a/include/uapi/linux/tc_act/tc_vlan.h
+++ b/include/uapi/linux/tc_act/tc_vlan.h
@@ -30,6 +30,7 @@ enum {
 	TCA_VLAN_PUSH_VLAN_PROTOCOL,
 	TCA_VLAN_PAD,
 	TCA_VLAN_PUSH_VLAN_PRIORITY,
+	TCA_VLAN_FLAGS,
 	__TCA_VLAN_MAX,
 };
 #define TCA_VLAN_MAX (__TCA_VLAN_MAX - 1)
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index f7aff66e5026..063c6afd51c4 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -97,6 +97,8 @@ static const struct nla_policy vlan_policy[TCA_VLAN_MAX + 1] = {
 	[TCA_VLAN_PUSH_VLAN_ID]		= { .type = NLA_U16 },
 	[TCA_VLAN_PUSH_VLAN_PROTOCOL]	= { .type = NLA_U16 },
 	[TCA_VLAN_PUSH_VLAN_PRIORITY]	= { .type = NLA_U8 },
+	[TCA_VLAN_FLAGS]	= { .type = NLA_BITFIELD32,
+				    .validation_data = &tca_flags_allowed },
 };
 
 static int tcf_vlan_init(struct net *net, struct nlattr *nla,
@@ -109,6 +111,7 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 	struct tcf_chain *goto_ch = NULL;
 	struct tcf_vlan_params *p;
 	struct tc_vlan *parm;
+	u32 index, flags = 0;
 	struct tcf_vlan *v;
 	int action;
 	u16 push_vid = 0;
@@ -116,7 +119,6 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 	u8 push_prio = 0;
 	bool exists = false;
 	int ret = 0, err;
-	u32 index;
 
 	if (!nla)
 		return -EINVAL;
@@ -187,9 +189,12 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 	}
 	action = parm->v_action;
 
+	if (tb[TCA_VLAN_FLAGS])
+		flags = nla_get_bitfield32(tb[TCA_VLAN_FLAGS]).value;
+
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_vlan_ops, bind, 0);
+				     &act_vlan_ops, bind, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
@@ -277,6 +282,14 @@ static int tcf_vlan_dump(struct sk_buff *skb, struct tc_action *a,
 	     (nla_put_u8(skb, TCA_VLAN_PUSH_VLAN_PRIORITY,
 					      p->tcfv_push_prio))))
 		goto nla_put_failure;
+	if (v->tcf_flags) {
+		struct nla_bitfield32 flags = { v->tcf_flags,
+						v->tcf_flags };
+
+		if (nla_put(skb, TCA_VLAN_FLAGS, sizeof(struct nla_bitfield32),
+			    &flags))
+			goto nla_put_failure;
+	}
 
 	tcf_tm_dump(&t, &v->tcf_tm);
 	if (nla_put_64bit(skb, TCA_VLAN_TM, sizeof(t), &t, TCA_VLAN_PAD))
-- 
2.21.0

