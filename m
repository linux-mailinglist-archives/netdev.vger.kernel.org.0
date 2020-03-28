Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 431F91968DF
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 20:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgC1TNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 15:13:35 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38347 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgC1TNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 15:13:35 -0400
Received: by mail-pf1-f196.google.com with SMTP id c21so5702030pfo.5
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 12:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j0aYT803mELMEQ3C9LJF+n/tvGfXRtpfMzENUrgsOGk=;
        b=uToi9uDOrUynFInyWNGy0MYx6UaU1cb7F4C8uX9Al796M11mal0wqFsn6cbgoi0t/S
         DhoR4DkETkiG8g1LIn4wY0Bea09Tr7uqU5K6mR9JSKVx3ObSU3x213NxEa6qDM8u8GcN
         1AglFtx2ZXxrCVcp0lQnvK0gPfxtaWQQMiAn+kbxubqKoR8O3JfOcNX/o+gUoc+wgF3X
         /fJm2OUeRCoQwO+N7dKCLQNgJf8pl/mc+AI2PUX703RHdWbrs6Ya3IZNTHxnE+NTFOfQ
         M0srfLnbDeAtX+TUJrqF/iTjWjgfWQE2QXMec93RE5Vla0Xi/c6dZ0r0uR7sSJz07E3q
         vCRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j0aYT803mELMEQ3C9LJF+n/tvGfXRtpfMzENUrgsOGk=;
        b=pA4EX3mGqj6B1YBZYjMhfc1+pqOrO3dhaLcGrrDf/ikvLWPojRdAwjK863tRM60GuE
         Eh/XB+iR+Wy9ox6bk7mN68s3UgRLdIKW1qlMQzmM8km+GueriTCyerqFcRmzNrRjXWR/
         IcN5fGK2o+JhHrKE9hoTyetEqV2iIEq7DSok8F173M/nv0zGDeKA4ojBu6vK1AN1iPmu
         4a5mcz78T8KtwuP1XNp/4lBsjA6xIP4/hqS/ljifAsjFMXUBZnSIh1rGC6R4A28K7I1C
         i6aq5ZT5gwk7uiEroHsW7Pedndl+OOL3ZoG+62Y3Dgl4jLN+BxN7Xf+tX5EXzEzHpuxW
         WO8w==
X-Gm-Message-State: ANhLgQ14fdga9bJGmtzqIl80srl0bSf8w41U277pXzywuO9gmunRX7zG
        IOfH66RGUfA0vGZQRsy4p0YtwfWoOnE=
X-Google-Smtp-Source: ADFU+vvIfR8nRzjjJjJyuz8MGnYLruW4TabaSnsplmvnt1aYNTS2PraqseBaA4DhoBAAuhH+F9IoOQ==
X-Received: by 2002:a63:1517:: with SMTP id v23mr5361397pgl.89.1585422811831;
        Sat, 28 Mar 2020 12:13:31 -0700 (PDT)
Received: from tw-172-25-31-169.office.twttr.net ([8.25.197.25])
        by smtp.gmail.com with ESMTPSA id b133sm5270824pfb.180.2020.03.28.12.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2020 12:13:31 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net] net_sched: add a temporary refcnt for struct tcindex_data
Date:   Sat, 28 Mar 2020 12:12:59 -0700
Message-Id: <20200328191259.17145-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although we intentionally use an ordered workqueue for all tc
filter works, the ordering is not guaranteed by RCU work,
given that tcf_queue_work() is esstenially a call_rcu().

This problem is demostrated by Thomas:

  CPU 0:
    tcf_queue_work()
      tcf_queue_work(&r->rwork, tcindex_destroy_rexts_work);

  -> Migration to CPU 1

  CPU 1:
     tcf_queue_work(&p->rwork, tcindex_destroy_work);

so the 2nd work could be queued before the 1st one, which leads
to a free-after-free.

Enforcing this order in RCU work is hard as it requires to change
RCU code too. Fortunately we can workaround this problem in tcindex
filter by taking a temporary refcnt, we only refcnt it right before
we begin to destroy it. This simplifies the code a lot as a full
refcnt requires much more changes in tcindex_set_parms().

Reported-by: syzbot+46f513c3033d592409d2@syzkaller.appspotmail.com
Fixes: 3d210534cc93 ("net_sched: fix a race condition in tcindex_destroy()")
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/cls_tcindex.c | 44 +++++++++++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 6 deletions(-)

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 9904299424a1..065345832a69 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -11,6 +11,7 @@
 #include <linux/skbuff.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
+#include <linux/refcount.h>
 #include <net/act_api.h>
 #include <net/netlink.h>
 #include <net/pkt_cls.h>
@@ -26,9 +27,12 @@
 #define DEFAULT_HASH_SIZE	64	/* optimized for diffserv */
 
 
+struct tcindex_data;
+
 struct tcindex_filter_result {
 	struct tcf_exts		exts;
 	struct tcf_result	res;
+	struct tcindex_data	*p;
 	struct rcu_work		rwork;
 };
 
@@ -49,6 +53,7 @@ struct tcindex_data {
 	u32 hash;		/* hash table size; 0 if undefined */
 	u32 alloc_hash;		/* allocated size */
 	u32 fall_through;	/* 0: only classify if explicit match */
+	refcount_t refcnt;	/* a temporary refcnt for perfect hash */
 	struct rcu_work rwork;
 };
 
@@ -57,6 +62,20 @@ static inline int tcindex_filter_is_set(struct tcindex_filter_result *r)
 	return tcf_exts_has_actions(&r->exts) || r->res.classid;
 }
 
+static void tcindex_data_get(struct tcindex_data *p)
+{
+	refcount_inc(&p->refcnt);
+}
+
+static void tcindex_data_put(struct tcindex_data *p)
+{
+	if (refcount_dec_and_test(&p->refcnt)) {
+		kfree(p->perfect);
+		kfree(p->h);
+		kfree(p);
+	}
+}
+
 static struct tcindex_filter_result *tcindex_lookup(struct tcindex_data *p,
 						    u16 key)
 {
@@ -141,6 +160,7 @@ static void __tcindex_destroy_rexts(struct tcindex_filter_result *r)
 {
 	tcf_exts_destroy(&r->exts);
 	tcf_exts_put_net(&r->exts);
+	tcindex_data_put(r->p);
 }
 
 static void tcindex_destroy_rexts_work(struct work_struct *work)
@@ -212,6 +232,8 @@ static int tcindex_delete(struct tcf_proto *tp, void *arg, bool *last,
 		else
 			__tcindex_destroy_fexts(f);
 	} else {
+		tcindex_data_get(p);
+
 		if (tcf_exts_get_net(&r->exts))
 			tcf_queue_work(&r->rwork, tcindex_destroy_rexts_work);
 		else
@@ -228,9 +250,7 @@ static void tcindex_destroy_work(struct work_struct *work)
 					      struct tcindex_data,
 					      rwork);
 
-	kfree(p->perfect);
-	kfree(p->h);
-	kfree(p);
+	tcindex_data_put(p);
 }
 
 static inline int
@@ -248,9 +268,11 @@ static const struct nla_policy tcindex_policy[TCA_TCINDEX_MAX + 1] = {
 };
 
 static int tcindex_filter_result_init(struct tcindex_filter_result *r,
+				      struct tcindex_data *p,
 				      struct net *net)
 {
 	memset(r, 0, sizeof(*r));
+	r->p = p;
 	return tcf_exts_init(&r->exts, net, TCA_TCINDEX_ACT,
 			     TCA_TCINDEX_POLICE);
 }
@@ -290,6 +312,7 @@ static int tcindex_alloc_perfect_hash(struct net *net, struct tcindex_data *cp)
 				    TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);
 		if (err < 0)
 			goto errout;
+		cp->perfect[i].p = cp;
 	}
 
 	return 0;
@@ -334,6 +357,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	cp->alloc_hash = p->alloc_hash;
 	cp->fall_through = p->fall_through;
 	cp->tp = tp;
+	refcount_set(&cp->refcnt, 1); /* Paired with tcindex_destroy_work() */
 
 	if (tb[TCA_TCINDEX_HASH])
 		cp->hash = nla_get_u32(tb[TCA_TCINDEX_HASH]);
@@ -366,7 +390,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	}
 	cp->h = p->h;
 
-	err = tcindex_filter_result_init(&new_filter_result, net);
+	err = tcindex_filter_result_init(&new_filter_result, cp, net);
 	if (err < 0)
 		goto errout_alloc;
 	if (old_r)
@@ -434,7 +458,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 			goto errout_alloc;
 		f->key = handle;
 		f->next = NULL;
-		err = tcindex_filter_result_init(&f->result, net);
+		err = tcindex_filter_result_init(&f->result, cp, net);
 		if (err < 0) {
 			kfree(f);
 			goto errout_alloc;
@@ -447,7 +471,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	}
 
 	if (old_r && old_r != r) {
-		err = tcindex_filter_result_init(old_r, net);
+		err = tcindex_filter_result_init(old_r, cp, net);
 		if (err < 0) {
 			kfree(f);
 			goto errout_alloc;
@@ -571,6 +595,14 @@ static void tcindex_destroy(struct tcf_proto *tp, bool rtnl_held,
 		for (i = 0; i < p->hash; i++) {
 			struct tcindex_filter_result *r = p->perfect + i;
 
+			/* tcf_queue_work() does not guarantee the ordering we
+			 * want, so we have to take this refcnt temporarily to
+			 * ensure 'p' is freed after all tcindex_filter_result
+			 * here. Imperfect hash does not need this, because it
+			 * uses linked lists rather than an array.
+			 */
+			tcindex_data_get(p);
+
 			tcf_unbind_filter(tp, &r->res);
 			if (tcf_exts_get_net(&r->exts))
 				tcf_queue_work(&r->rwork,
-- 
2.21.1

