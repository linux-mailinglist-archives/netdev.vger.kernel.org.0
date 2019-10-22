Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 485C8E063D
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 16:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbfJVOTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 10:19:00 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:33631 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727303AbfJVOS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 10:18:58 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Oct 2019 16:18:53 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9MEIqb2023677;
        Tue, 22 Oct 2019 17:18:53 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, mleitner@redhat.com, dcaratti@redhat.com,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 12/13] net: sched: act_ct: support fast init flag to skip pcpu allocation
Date:   Tue, 22 Oct 2019 17:18:03 +0300
Message-Id: <20191022141804.27639-13-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191022141804.27639-1-vladbu@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend ct action with u32 netlink TCA_CT_FLAGS field. Use it to pass fast
initialization flag defined by previous patch in this series and don't
allocate percpu counters in init code when flag is set. Extend action dump
callback to also dump flags, if field is set.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/uapi/linux/tc_act/tc_ct.h |  1 +
 net/sched/act_ct.c                | 17 +++++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/tc_act/tc_ct.h b/include/uapi/linux/tc_act/tc_ct.h
index 5fb1d7ac1027..82ea92b59d3d 100644
--- a/include/uapi/linux/tc_act/tc_ct.h
+++ b/include/uapi/linux/tc_act/tc_ct.h
@@ -22,6 +22,7 @@ enum {
 	TCA_CT_NAT_PORT_MIN,	/* be16 */
 	TCA_CT_NAT_PORT_MAX,	/* be16 */
 	TCA_CT_PAD,
+	TCA_CT_FLAGS,
 	__TCA_CT_MAX
 };
 
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 5dc8de42e1d4..04968dad328a 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -492,6 +492,8 @@ static const struct nla_policy ct_policy[TCA_CT_MAX + 1] = {
 				   .len = sizeof(struct in6_addr) },
 	[TCA_CT_NAT_PORT_MIN] = { .type = NLA_U16 },
 	[TCA_CT_NAT_PORT_MAX] = { .type = NLA_U16 },
+	[TCA_CT_FLAGS] = { .type = NLA_BITFIELD32,
+			   .validation_data = &tca_flags_allowed },
 };
 
 static int tcf_ct_fill_params_nat(struct tcf_ct_params *p,
@@ -663,10 +665,10 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 	struct tcf_ct_params *params = NULL;
 	struct nlattr *tb[TCA_CT_MAX + 1];
 	struct tcf_chain *goto_ch = NULL;
+	u32 index, flags = 0;
 	struct tc_ct *parm;
 	struct tcf_ct *c;
 	int err, res = 0;
-	u32 index;
 
 	if (!nla) {
 		NL_SET_ERR_MSG_MOD(extack, "Ct requires attributes to be passed");
@@ -687,9 +689,12 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 	if (err < 0)
 		return err;
 
+	if (tb[TCA_CT_FLAGS])
+		flags = nla_get_bitfield32(tb[TCA_CT_FLAGS]).value;
+
 	if (!err) {
 		err = tcf_idr_create(tn, index, est, a,
-				     &act_ct_ops, bind, 0);
+				     &act_ct_ops, bind, flags);
 		if (err) {
 			tcf_idr_cleanup(tn, index);
 			return err;
@@ -870,6 +875,14 @@ static inline int tcf_ct_dump(struct sk_buff *skb, struct tc_action *a,
 skip_dump:
 	if (nla_put(skb, TCA_CT_PARMS, sizeof(opt), &opt))
 		goto nla_put_failure;
+	if (c->tcf_flags) {
+		struct nla_bitfield32 flags = { c->tcf_flags,
+						c->tcf_flags };
+
+		if (nla_put(skb, TCA_CT_FLAGS, sizeof(struct nla_bitfield32),
+			    &flags))
+			goto nla_put_failure;
+	}
 
 	tcf_tm_dump(&t, &c->tcf_tm);
 	if (nla_put_64bit(skb, TCA_CT_TM, sizeof(t), &t, TCA_CT_PAD))
-- 
2.21.0

