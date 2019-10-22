Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA6C3E063A
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 16:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbfJVOS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 10:18:59 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:33609 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727154AbfJVOS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 10:18:58 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Oct 2019 16:18:53 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9MEIqax023677;
        Tue, 22 Oct 2019 17:18:53 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, mleitner@redhat.com, dcaratti@redhat.com,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 09/13] net: sched: act_mirred: support fast init flag to skip pcpu alloc
Date:   Tue, 22 Oct 2019 17:18:00 +0300
Message-Id: <20191022141804.27639-10-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191022141804.27639-1-vladbu@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend mirred action with u32 netlink TCA_MIRRED_FLAGS field. Use it to
pass fast initialization flag defined by previous patch in this series and
don't allocate percpu counters in init code when flag is set. Extend action
dump callback to also dump flags, if field is set.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/uapi/linux/tc_act/tc_mirred.h |  1 +
 net/sched/act_mirred.c                | 17 +++++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/tc_act/tc_mirred.h b/include/uapi/linux/tc_act/tc_mirred.h
index 2500a0005d05..322108890807 100644
--- a/include/uapi/linux/tc_act/tc_mirred.h
+++ b/include/uapi/linux/tc_act/tc_mirred.h
@@ -21,6 +21,7 @@ enum {
 	TCA_MIRRED_TM,
 	TCA_MIRRED_PARMS,
 	TCA_MIRRED_PAD,
+	TCA_MIRRED_FLAGS,
 	__TCA_MIRRED_MAX
 };
 #define TCA_MIRRED_MAX (__TCA_MIRRED_MAX - 1)
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index f5582236bcee..2a56ddbacff4 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -84,6 +84,8 @@ static void tcf_mirred_release(struct tc_action *a)
 
 static const struct nla_policy mirred_policy[TCA_MIRRED_MAX + 1] = {
 	[TCA_MIRRED_PARMS]	= { .len = sizeof(struct tc_mirred) },
+	[TCA_MIRRED_FLAGS]	= { .type = NLA_BITFIELD32,
+				    .validation_data = &tca_flags_allowed },
 };
 
 static unsigned int mirred_net_id;
@@ -102,9 +104,9 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 	struct tc_mirred *parm;
 	struct tcf_mirred *m;
 	struct net_device *dev;
+	u32 index, flags = 0;
 	bool exists = false;
 	int ret, err;
-	u32 index;
 
 	if (!nla) {
 		NL_SET_ERR_MSG_MOD(extack, "Mirred requires attributes to be passed");
@@ -142,6 +144,9 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 		return -EINVAL;
 	}
 
+	if (tb[TCA_MIRRED_FLAGS])
+		flags = nla_get_bitfield32(tb[TCA_MIRRED_FLAGS]).value;
+
 	if (!exists) {
 		if (!parm->ifindex) {
 			tcf_idr_cleanup(tn, index);
@@ -149,7 +154,7 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 			return -EINVAL;
 		}
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_mirred_ops, bind, 0);
+				     &act_mirred_ops, bind, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
@@ -344,6 +349,14 @@ static int tcf_mirred_dump(struct sk_buff *skb, struct tc_action *a, int bind,
 
 	if (nla_put(skb, TCA_MIRRED_PARMS, sizeof(opt), &opt))
 		goto nla_put_failure;
+	if (m->tcf_flags) {
+		struct nla_bitfield32 flags = { m->tcf_flags,
+						m->tcf_flags };
+
+		if (nla_put(skb, TCA_MIRRED_FLAGS,
+			    sizeof(struct nla_bitfield32), &flags))
+			goto nla_put_failure;
+	}
 
 	tcf_tm_dump(&t, &m->tcf_tm);
 	if (nla_put_64bit(skb, TCA_MIRRED_TM, sizeof(t), &t, TCA_MIRRED_PAD))
-- 
2.21.0

