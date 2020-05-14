Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28F41D2E89
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 13:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgENLkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 07:40:40 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:34146 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726073AbgENLkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 07:40:39 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 14 May 2020 14:40:36 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04EBeZKd031451;
        Thu, 14 May 2020 14:40:36 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, dcaratti@redhat.com, marcelo.leitner@gmail.com,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next 3/4] net: sched: cls_flower: implement terse dump support
Date:   Thu, 14 May 2020 14:40:25 +0300
Message-Id: <20200514114026.27047-4-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200514114026.27047-1-vladbu@mellanox.com>
References: <20200514114026.27047-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement tcf_proto_ops->terse_dump() callback for flower classifier. Only
dump handle, flags and action data in terse mode.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 net/sched/cls_flower.c | 43 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 74a0febcafb8..0c574700da75 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2768,6 +2768,48 @@ static int fl_dump(struct net *net, struct tcf_proto *tp, void *fh,
 	return -1;
 }
 
+static int fl_terse_dump(struct net *net, struct tcf_proto *tp, void *fh,
+			 struct sk_buff *skb, struct tcmsg *t, bool rtnl_held)
+{
+	struct cls_fl_filter *f = fh;
+	struct nlattr *nest;
+	bool skip_hw;
+
+	if (!f)
+		return skb->len;
+
+	t->tcm_handle = f->handle;
+
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
+	if (!nest)
+		goto nla_put_failure;
+
+	spin_lock(&tp->lock);
+
+	skip_hw = tc_skip_hw(f->flags);
+
+	if (f->flags && nla_put_u32(skb, TCA_FLOWER_FLAGS, f->flags))
+		goto nla_put_failure_locked;
+
+	spin_unlock(&tp->lock);
+
+	if (!skip_hw)
+		fl_hw_update_stats(tp, f, rtnl_held);
+
+	if (tcf_exts_terse_dump(skb, &f->exts))
+		goto nla_put_failure;
+
+	nla_nest_end(skb, nest);
+
+	return skb->len;
+
+nla_put_failure_locked:
+	spin_unlock(&tp->lock);
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -1;
+}
+
 static int fl_tmplt_dump(struct sk_buff *skb, struct net *net, void *tmplt_priv)
 {
 	struct fl_flow_tmplt *tmplt = tmplt_priv;
@@ -2832,6 +2874,7 @@ static struct tcf_proto_ops cls_fl_ops __read_mostly = {
 	.hw_add		= fl_hw_add,
 	.hw_del		= fl_hw_del,
 	.dump		= fl_dump,
+	.terse_dump	= fl_terse_dump,
 	.bind_class	= fl_bind_class,
 	.tmplt_create	= fl_tmplt_create,
 	.tmplt_destroy	= fl_tmplt_destroy,
-- 
2.21.0

