Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54A5AE063B
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 16:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbfJVOS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 10:18:59 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:33610 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727194AbfJVOS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 10:18:58 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Oct 2019 16:18:53 +0200
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9MEIqb0023677;
        Tue, 22 Oct 2019 17:18:53 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, mleitner@redhat.com, dcaratti@redhat.com,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 10/13] net: sched: tunnel_key: support fast init flag to skip pcpu alloc
Date:   Tue, 22 Oct 2019 17:18:01 +0300
Message-Id: <20191022141804.27639-11-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191022141804.27639-1-vladbu@mellanox.com>
References: <20191022141804.27639-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend tunnel_key action with u32 netlink TCA_TUNNEL_KEY_FLAGS field. Use
it to pass fast initialization flag defined by previous patch in this
series and don't allocate percpu counters in init code when flag is set.
Extend action dump callback to also dump flags, if field is set.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/uapi/linux/tc_act/tc_tunnel_key.h |  1 +
 net/sched/act_tunnel_key.c                | 18 ++++++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/tc_act/tc_tunnel_key.h b/include/uapi/linux/tc_act/tc_tunnel_key.h
index 41c8b462c177..f572101f6adc 100644
--- a/include/uapi/linux/tc_act/tc_tunnel_key.h
+++ b/include/uapi/linux/tc_act/tc_tunnel_key.h
@@ -39,6 +39,7 @@ enum {
 					 */
 	TCA_TUNNEL_KEY_ENC_TOS,		/* u8 */
 	TCA_TUNNEL_KEY_ENC_TTL,		/* u8 */
+	TCA_TUNNEL_KEY_FLAGS,
 	__TCA_TUNNEL_KEY_MAX,
 };
 
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index b517bcf9152c..965912b1cc74 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -193,6 +193,8 @@ static const struct nla_policy tunnel_key_policy[TCA_TUNNEL_KEY_MAX + 1] = {
 	[TCA_TUNNEL_KEY_ENC_OPTS]     = { .type = NLA_NESTED },
 	[TCA_TUNNEL_KEY_ENC_TOS]      = { .type = NLA_U8 },
 	[TCA_TUNNEL_KEY_ENC_TTL]      = { .type = NLA_U8 },
+	[TCA_TUNNEL_KEY_FLAGS]	= { .type = NLA_BITFIELD32,
+				    .validation_data = &tca_flags_allowed },
 };
 
 static void tunnel_key_release_params(struct tcf_tunnel_key_params *p)
@@ -218,6 +220,7 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 	struct tcf_chain *goto_ch = NULL;
 	struct tc_tunnel_key *parm;
 	struct tcf_tunnel_key *t;
+	u32 index, act_flags = 0;
 	bool exists = false;
 	__be16 dst_port = 0;
 	__be64 key_id = 0;
@@ -225,7 +228,6 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 	__be16 flags = 0;
 	u8 tos, ttl;
 	int ret = 0;
-	u32 index;
 	int err;
 
 	if (!nla) {
@@ -346,9 +348,12 @@ static int tunnel_key_init(struct net *net, struct nlattr *nla,
 		goto err_out;
 	}
 
+	if (tb[TCA_TUNNEL_KEY_FLAGS])
+		act_flags = nla_get_bitfield32(tb[TCA_TUNNEL_KEY_FLAGS]).value;
+
 	if (!exists) {
 		ret = tcf_idr_create(tn, index, est, a,
-				     &act_tunnel_key_ops, bind, 0);
+				     &act_tunnel_key_ops, bind, act_flags);
 		if (ret) {
 			NL_SET_ERR_MSG(extack, "Cannot create TC IDR");
 			goto release_tun_meta;
@@ -552,6 +557,15 @@ static int tunnel_key_dump(struct sk_buff *skb, struct tc_action *a,
 			goto nla_put_failure;
 	}
 
+	if (t->tcf_flags) {
+		struct nla_bitfield32 flags = { t->tcf_flags,
+						t->tcf_flags };
+
+		if (nla_put(skb, TCA_TUNNEL_KEY_FLAGS,
+			    sizeof(struct nla_bitfield32), &flags))
+			goto nla_put_failure;
+	}
+
 	tcf_tm_dump(&tm, &t->tcf_tm);
 	if (nla_put_64bit(skb, TCA_TUNNEL_KEY_TM, sizeof(tm),
 			  &tm, TCA_TUNNEL_KEY_PAD))
-- 
2.21.0

