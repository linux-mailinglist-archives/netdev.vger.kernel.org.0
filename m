Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229A123F4DE
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 00:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgHGW2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 18:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgHGW2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 18:28:32 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9267EC061756
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 15:28:32 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id v22so2481805qtq.8
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 15:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XjQ5+ec5MYtlLJLt3USEKI0cC6g/e5jslemIh/CkmWA=;
        b=Iqfb+PR/8N0LzASwekj8K2Y1BX1Bd4TplqqDECdQBx7n2itbA2vcj6QNczKeFFY/Os
         wvMMvkNscIDY+5WxwDrteXkjYv8JyoO1iS42XZF0IzuVokzmdsKDagBwC0zUsQaJ3HoC
         6pdQJ4R886aFgCXr0jxO4h8WpnmQ8HEM5e784o+MxwptdkDJsaqdZzjreUsEWSTogq5b
         QSqfv9o0GLwT8cURgx8zaCbb3Xsoj6zlgRnX3qHenxp28CfC4U00+48oa9GtTuK7sxB3
         2Bt5aXQq4nAQl9OechUInNBG1glgEmNDEeGdqq9Ni1n/c/rU21uSlxW5U6iu05GmmkSp
         yHOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XjQ5+ec5MYtlLJLt3USEKI0cC6g/e5jslemIh/CkmWA=;
        b=mFp1+4CiMEYdWAh8QlA+nY8isyQL2vZJj6UBy+LZxyOfxm+ND+SA35/1j2PYu0LaOQ
         iszkDlYSXzy/kvDVbtPEN7DCHADfRHQs3HzfYaHZD4wgvJXnWZB5ppc1Fic94S6Lp5ji
         siBZ5FYCWAmh8WlmN82e627gBGaNIp5wT0Tu6oe+k7ji7tbNKdI974HnRxMuAOFtxG4y
         KMLwTcaOX70jFBROC6zRSvbEuryv5zEuyoVphVbXyr3DZVcGjIYRomBscDOvrar7xeNU
         +0afmJYwdz6w2pY8Ld13p1PZIhKBVkHdkjrXAnR7g/eYWVI0zFB73g+CJB6DvMH0CqwN
         656Q==
X-Gm-Message-State: AOAM532tJG7fqsAuqEESEDZqqtvKWGFaHiLcWlU9KmeeJtq5WKfuQTmf
        FRPOwMXEWZVL5WWbwOP8KWXeM6DJy4Y=
X-Google-Smtp-Source: ABdhPJzzQHQexL74yK0sULozx8E60/bVZSlUGTS5O/o4NiaPz91pyR0MsehIzbOcePzaMS6vjb0G+A==
X-Received: by 2002:aed:2986:: with SMTP id o6mr16480298qtd.105.1596839311538;
        Fri, 07 Aug 2020 15:28:31 -0700 (PDT)
Received: from localhost.localdomain (bras-base-kntaon1617w-grc-06-184-148-45-213.dsl.bell.ca. [184.148.45.213])
        by smtp.gmail.com with ESMTPSA id 15sm7619903qkm.112.2020.08.07.15.28.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Aug 2020 15:28:30 -0700 (PDT)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
X-Google-Original-From: Jamal Hadi Salim <jhs@emojatatu.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        lariel@mellanox.com, Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net-next 1/1] net/sched: Introduce skb hash classifier
Date:   Fri,  7 Aug 2020 18:28:16 -0400
Message-Id: <20200807222816.18026-1-jhs@emojatatu.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jamal Hadi Salim <jhs@mojatatu.com>

his classifier, in the same spirit as the tc skb mark classifier,
provides a generic (fast lookup) approach to filter on the hash value
and optional mask.

like skb->mark, skb->hash could be set by multiple entities in the
datapath including but not limited to hardware offloaded classification
policies, hardware RSS (which already sets it today), XDP, ebpf programs
and even by other tc actions like skbedit and IFE.

Example use:

$TC qdisc add  dev $DEV1 ingress
... offloaded to hardware using flower ...
$TC filter add dev $DEV1 ingress protocol ip prio 1 flower hash 0x1f/0xff skip_sw flowid 1:1 \
action ok
... and when it shows up in s/w tagged from hardware...
$TC filter add dev $DEV1 parent ffff: protocol ip prio 2 handle 0x11/0xff skbhash flowid 1:11 \
action mirred egress redirect dev $DEV2
$TC filter add dev $DEV1 parent ffff: protocol ip prio 3 handle 0x12 skbhash flowid 1:12 \
action mirred egress redirect dev $DEV3

Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/uapi/linux/pkt_cls.h |  13 ++
 net/sched/Kconfig            |  10 +
 net/sched/Makefile           |   1 +
 net/sched/cls_skbhash.c      | 441 +++++++++++++++++++++++++++++++++++
 4 files changed, 465 insertions(+)
 create mode 100644 net/sched/cls_skbhash.c

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index ee95f42fb0ec..804cc326c2ce 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -770,4 +770,17 @@ enum {
 	TCF_EM_OPND_LT
 };
 
+/* skbhash filter */
+
+enum {
+	TCA_SKBHASH_UNSPEC,
+	TCA_SKBHASH_CLASSID,
+	TCA_SKBHASH_POLICE,
+	TCA_SKBHASH_ACT,
+	TCA_SKBHASH_MASK,
+	__TCA_SKBHASH_MAX
+};
+
+#define TCA_SKBHASH_MAX (__TCA_SKBHASH_MAX - 1)
+
 #endif
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index a3b37d88800e..aed2c74466e6 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -640,6 +640,16 @@ config NET_CLS_MATCHALL
 	  To compile this code as a module, choose M here: the module will
 	  be called cls_matchall.
 
+config NET_CLS_SKBHASH
+	tristate "skb->hash classifier"
+	select NET_CLS
+	---help---
+	  If you say Y here, you will be able to classify packets
+	  according to the skb->hash value
+
+	  To compile this code as a module, choose M here: the
+	  module will be called cls_skbhash.
+
 config NET_EMATCH
 	bool "Extended Matches"
 	select NET_CLS
diff --git a/net/sched/Makefile b/net/sched/Makefile
index 66bbf9a98f9e..cbffba3b1fa1 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -68,6 +68,7 @@ obj-$(CONFIG_NET_SCH_TAPRIO)	+= sch_taprio.o
 obj-$(CONFIG_NET_CLS_U32)	+= cls_u32.o
 obj-$(CONFIG_NET_CLS_ROUTE4)	+= cls_route.o
 obj-$(CONFIG_NET_CLS_FW)	+= cls_fw.o
+obj-$(CONFIG_NET_CLS_SKBHASH)	+= cls_skbhash.o
 obj-$(CONFIG_NET_CLS_RSVP)	+= cls_rsvp.o
 obj-$(CONFIG_NET_CLS_TCINDEX)	+= cls_tcindex.o
 obj-$(CONFIG_NET_CLS_RSVP6)	+= cls_rsvp6.o
diff --git a/net/sched/cls_skbhash.c b/net/sched/cls_skbhash.c
new file mode 100644
index 000000000000..e523a1ce2fc5
--- /dev/null
+++ b/net/sched/cls_skbhash.c
@@ -0,0 +1,441 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * net/sched/cls_skbhash.c	TC Classifier for skb->hash
+ *
+ * Authors:	J Hadi Salim <jhs@mojatatu.com>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/skbuff.h>
+#include <net/netlink.h>
+#include <net/act_api.h>
+#include <net/pkt_cls.h>
+#include <net/sch_generic.h>
+
+#define SKBHASH_HTSIZE 256
+
+struct skbhash_head {
+	struct rcu_head		rcu;
+	u32			mask;
+	struct skbhash_filter __rcu	*ht[SKBHASH_HTSIZE];
+};
+
+struct skbhash_filter {
+	struct skbhash_filter __rcu	*next;
+	u32			id;
+	struct tcf_result	res;
+	struct tcf_exts		exts;
+	struct tcf_proto	*tp;
+	struct rcu_work		rwork;
+};
+
+static u32 skbhash_hash(u32 handle)
+{
+	handle ^= (handle >> 16);
+	handle ^= (handle >> 8);
+	return handle % SKBHASH_HTSIZE;
+}
+
+static int skbhash_classify(struct sk_buff *skb, const struct tcf_proto *tp,
+			    struct tcf_result *res)
+{
+	struct skbhash_head *head = rcu_dereference_bh(tp->root);
+	struct skbhash_filter *f;
+	int r;
+	u32 id = skb->hash;
+
+	if (head != NULL) {
+		id &= head->mask;
+
+		for (f = rcu_dereference_bh(head->ht[skbhash_hash(id)]); f;
+		     f = rcu_dereference_bh(f->next)) {
+			if (f->id == id) {
+				*res = f->res;
+				r = tcf_exts_exec(skb, &f->exts, res);
+				if (r < 0)
+					continue;
+
+				return r;
+			}
+		}
+	} else {
+		struct Qdisc *q = tcf_block_q(tp->chain->block);
+
+		/* Legacy method: classify the packet using its skb hash. */
+		if (id && (TC_H_MAJ(id) == 0 ||
+			   !(TC_H_MAJ(id ^ q->handle)))) {
+			res->classid = id;
+			res->class = 0;
+			return 0;
+		}
+	}
+
+	return -1;
+}
+
+static void *skbhash_get(struct tcf_proto *tp, u32 handle)
+{
+	struct skbhash_head *head = rtnl_dereference(tp->root);
+	struct skbhash_filter *f;
+
+	if (head == NULL)
+		return NULL;
+
+	f = rtnl_dereference(head->ht[skbhash_hash(handle)]);
+	for (; f; f = rtnl_dereference(f->next)) {
+		if (f->id == handle)
+			return f;
+	}
+	return NULL;
+}
+
+static int skbhash_init(struct tcf_proto *tp)
+{
+	/* We don't allocate skbhash_head here, because in the old method
+	 * we don't need it at all.
+	 */
+	return 0;
+}
+
+static void __skbhash_delete_filter(struct skbhash_filter *f)
+{
+	tcf_exts_destroy(&f->exts);
+	tcf_exts_put_net(&f->exts);
+	kfree(f);
+}
+
+static void skbhash_delete_filter_work(struct work_struct *work)
+{
+	struct skbhash_filter *f = container_of(to_rcu_work(work),
+					   struct skbhash_filter,
+					   rwork);
+	rtnl_lock();
+	__skbhash_delete_filter(f);
+	rtnl_unlock();
+}
+
+static void skbhash_destroy(struct tcf_proto *tp, bool rtnl_held,
+			    struct netlink_ext_ack *extack)
+{
+	struct skbhash_head *head = rtnl_dereference(tp->root);
+	struct skbhash_filter *f;
+	int h;
+
+	if (head == NULL)
+		return;
+
+	for (h = 0; h < SKBHASH_HTSIZE; h++) {
+		while ((f = rtnl_dereference(head->ht[h])) != NULL) {
+			RCU_INIT_POINTER(head->ht[h],
+					 rtnl_dereference(f->next));
+			tcf_unbind_filter(tp, &f->res);
+			if (tcf_exts_get_net(&f->exts))
+				tcf_queue_work(&f->rwork,
+					       skbhash_delete_filter_work);
+			else
+				__skbhash_delete_filter(f);
+		}
+	}
+	kfree_rcu(head, rcu);
+}
+
+static int skbhash_delete(struct tcf_proto *tp, void *arg, bool *last,
+			  bool rtnl_held, struct netlink_ext_ack *extack)
+{
+	struct skbhash_head *head = rtnl_dereference(tp->root);
+	struct skbhash_filter *f = arg;
+	struct skbhash_filter __rcu **fp;
+	struct skbhash_filter *pfp;
+	int ret = -EINVAL;
+	int h;
+
+	if (head == NULL || f == NULL)
+		goto out;
+
+	fp = &head->ht[skbhash_hash(f->id)];
+
+	for (pfp = rtnl_dereference(*fp); pfp;
+	     fp = &pfp->next, pfp = rtnl_dereference(*fp)) {
+		if (pfp == f) {
+			RCU_INIT_POINTER(*fp, rtnl_dereference(f->next));
+			tcf_unbind_filter(tp, &f->res);
+			tcf_exts_get_net(&f->exts);
+			tcf_queue_work(&f->rwork, skbhash_delete_filter_work);
+			ret = 0;
+			break;
+		}
+	}
+
+	*last = true;
+	for (h = 0; h < SKBHASH_HTSIZE; h++) {
+		if (rcu_access_pointer(head->ht[h])) {
+			*last = false;
+			break;
+		}
+	}
+
+out:
+	return ret;
+}
+
+static const struct nla_policy skbhash_policy[TCA_SKBHASH_MAX + 1] = {
+	[TCA_SKBHASH_CLASSID]	= { .type = NLA_U32 },
+	[TCA_SKBHASH_MASK]	= { .type = NLA_U32 },
+};
+
+static int skbhash_set_parms(struct net *net, struct tcf_proto *tp,
+			     struct skbhash_filter *f, struct nlattr **tb,
+			     struct nlattr **tca, unsigned long base,
+			     bool ovr, struct netlink_ext_ack *extack)
+{
+	struct skbhash_head *head = rtnl_dereference(tp->root);
+	u32 mask;
+	int err;
+
+	err = tcf_exts_validate(net, tp, tb, tca[TCA_RATE], &f->exts, ovr,
+				true, extack);
+	if (err < 0)
+		return err;
+
+	if (tb[TCA_SKBHASH_CLASSID]) {
+		f->res.classid = nla_get_u32(tb[TCA_SKBHASH_CLASSID]);
+		tcf_bind_filter(tp, &f->res, base);
+	}
+
+	err = -EINVAL;
+	if (tb[TCA_SKBHASH_MASK]) {
+		mask = nla_get_u32(tb[TCA_SKBHASH_MASK]);
+		if (mask != head->mask)
+			return err;
+	} else if (head->mask != 0xFFFFFFFF)
+		return err;
+
+	return 0;
+}
+
+static int skbhash_change(struct net *net, struct sk_buff *in_skb,
+			  struct tcf_proto *tp, unsigned long base, u32 handle,
+			  struct nlattr **tca, void **arg, bool ovr,
+			  bool rtnl_held, struct netlink_ext_ack *extack)
+{
+	struct skbhash_head *head = rtnl_dereference(tp->root);
+	struct skbhash_filter *f = *arg;
+	struct nlattr *opt = tca[TCA_OPTIONS];
+	struct nlattr *tb[TCA_SKBHASH_MAX + 1];
+	int err;
+
+	if (!opt)
+		return handle ? -EINVAL : 0; /* Succeed if it is old method. */
+
+	err = nla_parse_nested_deprecated(tb, TCA_SKBHASH_MAX, opt,
+					  skbhash_policy, NULL);
+	if (err < 0)
+		return err;
+
+	if (f) {
+		struct skbhash_filter *pfp, *fnew;
+		struct skbhash_filter __rcu **fp;
+
+		if (f->id != handle && handle)
+			return -EINVAL;
+
+		fnew = kzalloc(sizeof(struct skbhash_filter), GFP_KERNEL);
+		if (!fnew)
+			return -ENOBUFS;
+
+		fnew->id = f->id;
+		fnew->res = f->res;
+		fnew->tp = f->tp;
+
+		err = tcf_exts_init(&fnew->exts, net, TCA_SKBHASH_ACT,
+				    TCA_SKBHASH_POLICE);
+		if (err < 0) {
+			kfree(fnew);
+			return err;
+		}
+
+		err = skbhash_set_parms(net, tp, fnew, tb, tca, base, ovr,
+					extack);
+		if (err < 0) {
+			tcf_exts_destroy(&fnew->exts);
+			kfree(fnew);
+			return err;
+		}
+
+		fp = &head->ht[skbhash_hash(fnew->id)];
+		for (pfp = rtnl_dereference(*fp); pfp;
+		     fp = &pfp->next, pfp = rtnl_dereference(*fp))
+			if (pfp == f)
+				break;
+
+		RCU_INIT_POINTER(fnew->next, rtnl_dereference(pfp->next));
+		rcu_assign_pointer(*fp, fnew);
+		tcf_unbind_filter(tp, &f->res);
+		tcf_exts_get_net(&f->exts);
+		tcf_queue_work(&f->rwork, skbhash_delete_filter_work);
+
+		*arg = fnew;
+		return err;
+	}
+
+	if (!handle)
+		return -EINVAL;
+
+	if (!head) {
+		u32 mask = 0xFFFFFFFF;
+
+		if (tb[TCA_SKBHASH_MASK])
+			mask = nla_get_u32(tb[TCA_SKBHASH_MASK]);
+
+		head = kzalloc(sizeof(*head), GFP_KERNEL);
+		if (!head)
+			return -ENOBUFS;
+		head->mask = mask;
+
+		rcu_assign_pointer(tp->root, head);
+	}
+
+	f = kzalloc(sizeof(struct skbhash_filter), GFP_KERNEL);
+	if (f == NULL)
+		return -ENOBUFS;
+
+	err = tcf_exts_init(&f->exts, net, TCA_SKBHASH_ACT, TCA_SKBHASH_POLICE);
+	if (err < 0)
+		goto errout;
+	f->id = handle;
+	f->tp = tp;
+
+	err = skbhash_set_parms(net, tp, f, tb, tca, base, ovr, extack);
+	if (err < 0)
+		goto errout;
+
+	RCU_INIT_POINTER(f->next, head->ht[skbhash_hash(handle)]);
+	rcu_assign_pointer(head->ht[skbhash_hash(handle)], f);
+
+	*arg = f;
+	return 0;
+
+errout:
+	tcf_exts_destroy(&f->exts);
+	kfree(f);
+	return err;
+}
+
+static void skbhash_walk(struct tcf_proto *tp, struct tcf_walker *arg,
+			 bool rtnl_held)
+{
+	struct skbhash_head *head = rtnl_dereference(tp->root);
+	int h;
+
+	if (head == NULL)
+		arg->stop = 1;
+
+	if (arg->stop)
+		return;
+
+	for (h = 0; h < SKBHASH_HTSIZE; h++) {
+		struct skbhash_filter *f;
+
+		for (f = rtnl_dereference(head->ht[h]); f;
+		     f = rtnl_dereference(f->next)) {
+			if (arg->count < arg->skip) {
+				arg->count++;
+				continue;
+			}
+			if (arg->fn(tp, f, arg) < 0) {
+				arg->stop = 1;
+				return;
+			}
+			arg->count++;
+		}
+	}
+}
+
+static int skbhash_dump(struct net *net, struct tcf_proto *tp, void *fh,
+			struct sk_buff *skb, struct tcmsg *t, bool rtnl_held)
+{
+	struct skbhash_head *head = rtnl_dereference(tp->root);
+	struct skbhash_filter *f = fh;
+	struct nlattr *nest;
+
+	if (f == NULL)
+		return skb->len;
+
+	t->tcm_handle = f->id;
+
+	if (!f->res.classid && !tcf_exts_has_actions(&f->exts))
+		return skb->len;
+
+	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
+	if (nest == NULL)
+		goto nla_put_failure;
+
+	if (f->res.classid &&
+	    nla_put_u32(skb, TCA_SKBHASH_CLASSID, f->res.classid))
+		goto nla_put_failure;
+
+	if (head->mask != 0xFFFFFFFF &&
+	    nla_put_u32(skb, TCA_SKBHASH_MASK, head->mask))
+		goto nla_put_failure;
+
+	if (tcf_exts_dump(skb, &f->exts) < 0)
+		goto nla_put_failure;
+
+	nla_nest_end(skb, nest);
+
+	if (tcf_exts_dump_stats(skb, &f->exts) < 0)
+		goto nla_put_failure;
+
+	return skb->len;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -1;
+}
+
+static void skbhash_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
+			       unsigned long base)
+{
+	struct skbhash_filter *f = fh;
+
+	if (f && f->res.classid == classid) {
+		if (cl)
+			__tcf_bind_filter(q, &f->res, base);
+		else
+			__tcf_unbind_filter(q, &f->res);
+	}
+}
+
+static struct tcf_proto_ops cls_skbhash_ops __read_mostly = {
+	.kind		=	"skbhash",
+	.classify	=	skbhash_classify,
+	.init		=	skbhash_init,
+	.destroy	=	skbhash_destroy,
+	.get		=	skbhash_get,
+	.change		=	skbhash_change,
+	.delete		=	skbhash_delete,
+	.walk		=	skbhash_walk,
+	.dump		=	skbhash_dump,
+	.bind_class	=	skbhash_bind_class,
+	.owner		=	THIS_MODULE,
+};
+
+static int __init init_skbhash(void)
+{
+	return register_tcf_proto_ops(&cls_skbhash_ops);
+}
+
+static void __exit exit_skbhash(void)
+{
+	unregister_tcf_proto_ops(&cls_skbhash_ops);
+}
+
+module_init(init_skbhash)
+module_exit(exit_skbhash)
+MODULE_LICENSE("GPL");
-- 
2.20.1

