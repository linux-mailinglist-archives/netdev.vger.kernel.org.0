Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82496E0634
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 16:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbfJVOTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 10:19:01 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:33594 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727152AbfJVOS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 10:18:58 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Oct 2019 16:18:53 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9MEIqaw023677;
        Tue, 22 Oct 2019 17:18:53 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, mleitner@redhat.com, dcaratti@redhat.com,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 08/13] net: sched: act_csum: support fast init flag to skip pcpu allocation
Date:   Tue, 22 Oct 2019 17:17:59 +0300
Message-Id: <20191022141804.27639-9-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191022141804.27639-1-vladbu@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend csum action with u32 netlink TCA_CSUM_FLAGS field. Use it to pass
fast initialization flag defined by previous patch in this series and don't
allocate percpu counters in init code when flag is set. Extend action dump
callback to also dump flags, if field is set.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/uapi/linux/tc_act/tc_csum.h |  1 +
 net/sched/act_csum.c                | 18 ++++++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/tc_act/tc_csum.h b/include/uapi/linux/tc_act/tc_csum.h
index 94b2044929de..14eddaca85f8 100644
--- a/include/uapi/linux/tc_act/tc_csum.h
+++ b/include/uapi/linux/tc_act/tc_csum.h
@@ -10,6 +10,7 @@ enum {
 	TCA_CSUM_PARMS,
 	TCA_CSUM_TM,
 	TCA_CSUM_PAD,
+	TCA_CSUM_FLAGS,
 	__TCA_CSUM_MAX
 };
 #define TCA_CSUM_MAX (__TCA_CSUM_MAX - 1)
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index d2e6d8d77d9a..655d80ccbac2 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -35,6 +35,8 @@
 
 static const struct nla_policy csum_policy[TCA_CSUM_MAX + 1] = {
 	[TCA_CSUM_PARMS] = { .len = sizeof(struct tc_csum), },
+	[TCA_CSUM_FLAGS] = { .type = NLA_BITFIELD32,
+			     .validation_data = &tca_flags_allowed },
 };
 
 static unsigned int csum_net_id;
@@ -50,9 +52,9 @@ static int tcf_csum_init(struct net *net, struct nlattr *nla,
 	struct nlattr *tb[TCA_CSUM_MAX + 1];
 	struct tcf_chain *goto_ch = NULL;
 	struct tc_csum *parm;
+	u32 index, flags = 0;
 	struct tcf_csum *p;
 	int ret = 0, err;
-	u32 index;
 
 	if (nla == NULL)
 		return -EINVAL;
@@ -66,10 +68,14 @@ static int tcf_csum_init(struct net *net, struct nlattr *nla,
 		return -EINVAL;
 	parm = nla_data(tb[TCA_CSUM_PARMS]);
 	index = parm->index;
+
+	if (tb[TCA_CSUM_FLAGS])
+		flags = nla_get_bitfield32(tb[TCA_CSUM_FLAGS]).value;
+
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_csum_ops, bind, 0);
+				     &act_csum_ops, bind, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
@@ -650,6 +656,14 @@ static int tcf_csum_dump(struct sk_buff *skb, struct tc_action *a, int bind,
 
 	if (nla_put(skb, TCA_CSUM_PARMS, sizeof(opt), &opt))
 		goto nla_put_failure;
+	if (p->tcf_flags) {
+		struct nla_bitfield32 flags = { p->tcf_flags,
+						p->tcf_flags };
+
+		if (nla_put(skb, TCA_CSUM_FLAGS, sizeof(struct nla_bitfield32),
+			    &flags))
+			goto nla_put_failure;
+	}
 
 	tcf_tm_dump(&t, &p->tcf_tm);
 	if (nla_put_64bit(skb, TCA_CSUM_TM, sizeof(t), &t, TCA_CSUM_PAD))
-- 
2.21.0

