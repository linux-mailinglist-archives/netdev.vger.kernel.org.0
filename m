Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCBAF9C4FA
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 19:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbfHYRCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Aug 2019 13:02:00 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44400 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728422AbfHYRB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Aug 2019 13:01:59 -0400
Received: by mail-pl1-f194.google.com with SMTP id t14so8628573plr.11
        for <netdev@vger.kernel.org>; Sun, 25 Aug 2019 10:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/2BL5vb3YnlD3J95bTs4bRYmzOmvzETqNVWk2C6fCwE=;
        b=KeR+ggQz9IwTFKxH4Wh3xSJfPiVtqbX3uR471CA88+tq2/kIFg9EGmJ+Uif+hRaNIn
         LffVi744O3qOCLTjVfKo5MwNj6AL/UioJM0oe5UuVzNGwX14uevI/HfPVGvmTyyLIsQ3
         TcwsrRtHELm74nQYvEh86/dUZ0E+74mHf4e+Mw56FZ+lRoNZExumVW9i1IusEAIXZISN
         ymXI88pirzzMq945jvp7ooCvl9W/xeViXdMbrGqavqW1QSTnbdH66LqstzuZ3ecP6m5j
         loP8e0GiTviRcgdk1h+ZaGjPBUfe1GZf2UzESiN2ZyJpmtZySzKAUaUd3J5jQqN8rhVt
         Joyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/2BL5vb3YnlD3J95bTs4bRYmzOmvzETqNVWk2C6fCwE=;
        b=CzHOtCZIXn9LzGHJ+8Vhv0L+fz60rJEMFYLegiCJ7qC6FJIgj6AKWKaUmOzIowY7YT
         kjMlp6CdyZmMNMtaMu+R8OOOvNQcQiemb8unQViyrBfj6rbGhUxOFWekHIwdCsNj8AXN
         HPmC0aLCQYd4guF+/zXOP3x+ukOnogufvxYR8o+dniujLdF8MrOKyQoKpWnfMoA9Wihi
         wbC8mkw3YpLZzQkRj2ACIhHO6WiVKzGZxbkD+T7aAC7DAwrI2X455UU4KCAr80GucsF0
         JOkD0LjVoDWW4SdgQSViwKc9ttuENwPgVZpUYm7ITPlPry3KSiSQImDMU0ic0pZowceD
         XY9g==
X-Gm-Message-State: APjAAAVodtJTk6OWOwiWd6E8UOZ8huAVW4yGrUG/xzFtwfWTD2u/EDYV
        QYn+QL+B6V6QlRA+S9vbSurCrSv+
X-Google-Smtp-Source: APXvYqx0KhmXIGwNwBTeDC4WfJmq6KCybJYc1Kq4Yxl1R5nzNO4+JsmZl+2wi/6w6tvJfa/wttzS0w==
X-Received: by 2002:a17:902:b106:: with SMTP id q6mr2824267plr.333.1566752518650;
        Sun, 25 Aug 2019 10:01:58 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id s3sm10134155pgq.17.2019.08.25.10.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 10:01:57 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, itugrok@yahoo.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net] net_sched: fix a NULL pointer deref in ipt action
Date:   Sun, 25 Aug 2019 10:01:32 -0700
Message-Id: <20190825170132.31174-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The net pointer in struct xt_tgdtor_param is not explicitly
initialized therefore is still NULL when dereferencing it.
So we have to find a way to pass the correct net pointer to
ipt_destroy_target().

The best way I find is just saving the net pointer inside the per
netns struct tcf_idrinfo, which could make this patch smaller.

Fixes: 0c66dc1ea3f0 ("netfilter: conntrack: register hooks in netns when needed by ruleset")
Reported-and-tested-by: itugrok@yahoo.com
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 include/net/act_api.h      |  4 +++-
 net/sched/act_bpf.c        |  2 +-
 net/sched/act_connmark.c   |  2 +-
 net/sched/act_csum.c       |  2 +-
 net/sched/act_ct.c         |  2 +-
 net/sched/act_ctinfo.c     |  2 +-
 net/sched/act_gact.c       |  2 +-
 net/sched/act_ife.c        |  2 +-
 net/sched/act_ipt.c        | 11 ++++++-----
 net/sched/act_mirred.c     |  2 +-
 net/sched/act_mpls.c       |  2 +-
 net/sched/act_nat.c        |  2 +-
 net/sched/act_pedit.c      |  2 +-
 net/sched/act_police.c     |  2 +-
 net/sched/act_sample.c     |  2 +-
 net/sched/act_simple.c     |  2 +-
 net/sched/act_skbedit.c    |  2 +-
 net/sched/act_skbmod.c     |  2 +-
 net/sched/act_tunnel_key.c |  2 +-
 net/sched/act_vlan.c       |  2 +-
 20 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index c61a1bf4e3de..3a1a72990fce 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -15,6 +15,7 @@
 struct tcf_idrinfo {
 	struct mutex	lock;
 	struct idr	action_idr;
+	struct net	*net;
 };
 
 struct tc_action_ops;
@@ -108,7 +109,7 @@ struct tc_action_net {
 };
 
 static inline
-int tc_action_net_init(struct tc_action_net *tn,
+int tc_action_net_init(struct net *net, struct tc_action_net *tn,
 		       const struct tc_action_ops *ops)
 {
 	int err = 0;
@@ -117,6 +118,7 @@ int tc_action_net_init(struct tc_action_net *tn,
 	if (!tn->idrinfo)
 		return -ENOMEM;
 	tn->ops = ops;
+	tn->idrinfo->net = net;
 	mutex_init(&tn->idrinfo->lock);
 	idr_init(&tn->idrinfo->action_idr);
 	return err;
diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index fd1f7e799e23..04b7bd4ec751 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -422,7 +422,7 @@ static __net_init int bpf_init_net(struct net *net)
 {
 	struct tc_action_net *tn = net_generic(net, bpf_net_id);
 
-	return tc_action_net_init(tn, &act_bpf_ops);
+	return tc_action_net_init(net, tn, &act_bpf_ops);
 }
 
 static void __net_exit bpf_exit_net(struct list_head *net_list)
diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
index 32ac04d77a45..2b43cacf82af 100644
--- a/net/sched/act_connmark.c
+++ b/net/sched/act_connmark.c
@@ -231,7 +231,7 @@ static __net_init int connmark_init_net(struct net *net)
 {
 	struct tc_action_net *tn = net_generic(net, connmark_net_id);
 
-	return tc_action_net_init(tn, &act_connmark_ops);
+	return tc_action_net_init(net, tn, &act_connmark_ops);
 }
 
 static void __net_exit connmark_exit_net(struct list_head *net_list)
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index 9b9288267a54..d3cfad88dc3a 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -714,7 +714,7 @@ static __net_init int csum_init_net(struct net *net)
 {
 	struct tc_action_net *tn = net_generic(net, csum_net_id);
 
-	return tc_action_net_init(tn, &act_csum_ops);
+	return tc_action_net_init(net, tn, &act_csum_ops);
 }
 
 static void __net_exit csum_exit_net(struct list_head *net_list)
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 33a1a7406e87..cdd6f3818097 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -939,7 +939,7 @@ static __net_init int ct_init_net(struct net *net)
 		tn->labels = true;
 	}
 
-	return tc_action_net_init(&tn->tn, &act_ct_ops);
+	return tc_action_net_init(net, &tn->tn, &act_ct_ops);
 }
 
 static void __net_exit ct_exit_net(struct list_head *net_list)
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index 06ef74b74911..0dbcfd1dca7b 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -376,7 +376,7 @@ static __net_init int ctinfo_init_net(struct net *net)
 {
 	struct tc_action_net *tn = net_generic(net, ctinfo_net_id);
 
-	return tc_action_net_init(tn, &act_ctinfo_ops);
+	return tc_action_net_init(net, tn, &act_ctinfo_ops);
 }
 
 static void __net_exit ctinfo_exit_net(struct list_head *net_list)
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index 8f0140c6ca58..324f1d1f6d47 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -278,7 +278,7 @@ static __net_init int gact_init_net(struct net *net)
 {
 	struct tc_action_net *tn = net_generic(net, gact_net_id);
 
-	return tc_action_net_init(tn, &act_gact_ops);
+	return tc_action_net_init(net, tn, &act_gact_ops);
 }
 
 static void __net_exit gact_exit_net(struct list_head *net_list)
diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index 92ee853d43e6..3a31e241c647 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -890,7 +890,7 @@ static __net_init int ife_init_net(struct net *net)
 {
 	struct tc_action_net *tn = net_generic(net, ife_net_id);
 
-	return tc_action_net_init(tn, &act_ife_ops);
+	return tc_action_net_init(net, tn, &act_ife_ops);
 }
 
 static void __net_exit ife_exit_net(struct list_head *net_list)
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index ce2c30a591d2..214a03d405cf 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -61,12 +61,13 @@ static int ipt_init_target(struct net *net, struct xt_entry_target *t,
 	return 0;
 }
 
-static void ipt_destroy_target(struct xt_entry_target *t)
+static void ipt_destroy_target(struct xt_entry_target *t, struct net *net)
 {
 	struct xt_tgdtor_param par = {
 		.target   = t->u.kernel.target,
 		.targinfo = t->data,
 		.family   = NFPROTO_IPV4,
+		.net      = net,
 	};
 	if (par.target->destroy != NULL)
 		par.target->destroy(&par);
@@ -78,7 +79,7 @@ static void tcf_ipt_release(struct tc_action *a)
 	struct tcf_ipt *ipt = to_ipt(a);
 
 	if (ipt->tcfi_t) {
-		ipt_destroy_target(ipt->tcfi_t);
+		ipt_destroy_target(ipt->tcfi_t, a->idrinfo->net);
 		kfree(ipt->tcfi_t);
 	}
 	kfree(ipt->tcfi_tname);
@@ -180,7 +181,7 @@ static int __tcf_ipt_init(struct net *net, unsigned int id, struct nlattr *nla,
 
 	spin_lock_bh(&ipt->tcf_lock);
 	if (ret != ACT_P_CREATED) {
-		ipt_destroy_target(ipt->tcfi_t);
+		ipt_destroy_target(ipt->tcfi_t, net);
 		kfree(ipt->tcfi_tname);
 		kfree(ipt->tcfi_t);
 	}
@@ -350,7 +351,7 @@ static __net_init int ipt_init_net(struct net *net)
 {
 	struct tc_action_net *tn = net_generic(net, ipt_net_id);
 
-	return tc_action_net_init(tn, &act_ipt_ops);
+	return tc_action_net_init(net, tn, &act_ipt_ops);
 }
 
 static void __net_exit ipt_exit_net(struct list_head *net_list)
@@ -399,7 +400,7 @@ static __net_init int xt_init_net(struct net *net)
 {
 	struct tc_action_net *tn = net_generic(net, xt_net_id);
 
-	return tc_action_net_init(tn, &act_xt_ops);
+	return tc_action_net_init(net, tn, &act_xt_ops);
 }
 
 static void __net_exit xt_exit_net(struct list_head *net_list)
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index be3f88dfc37e..9d1bf508075a 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -453,7 +453,7 @@ static __net_init int mirred_init_net(struct net *net)
 {
 	struct tc_action_net *tn = net_generic(net, mirred_net_id);
 
-	return tc_action_net_init(tn, &act_mirred_ops);
+	return tc_action_net_init(net, tn, &act_mirred_ops);
 }
 
 static void __net_exit mirred_exit_net(struct list_head *net_list)
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 0f299e3b618c..e168df0e008a 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -375,7 +375,7 @@ static __net_init int mpls_init_net(struct net *net)
 {
 	struct tc_action_net *tn = net_generic(net, mpls_net_id);
 
-	return tc_action_net_init(tn, &act_mpls_ops);
+	return tc_action_net_init(net, tn, &act_mpls_ops);
 }
 
 static void __net_exit mpls_exit_net(struct list_head *net_list)
diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
index 7b858c11b1b5..ea4c5359e7df 100644
--- a/net/sched/act_nat.c
+++ b/net/sched/act_nat.c
@@ -327,7 +327,7 @@ static __net_init int nat_init_net(struct net *net)
 {
 	struct tc_action_net *tn = net_generic(net, nat_net_id);
 
-	return tc_action_net_init(tn, &act_nat_ops);
+	return tc_action_net_init(net, tn, &act_nat_ops);
 }
 
 static void __net_exit nat_exit_net(struct list_head *net_list)
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 17360c6faeaa..cdfaa79382a2 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -498,7 +498,7 @@ static __net_init int pedit_init_net(struct net *net)
 {
 	struct tc_action_net *tn = net_generic(net, pedit_net_id);
 
-	return tc_action_net_init(tn, &act_pedit_ops);
+	return tc_action_net_init(net, tn, &act_pedit_ops);
 }
 
 static void __net_exit pedit_exit_net(struct list_head *net_list)
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 49cec3e64a4d..6315e0f8d26e 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -371,7 +371,7 @@ static __net_init int police_init_net(struct net *net)
 {
 	struct tc_action_net *tn = net_generic(net, police_net_id);
 
-	return tc_action_net_init(tn, &act_police_ops);
+	return tc_action_net_init(net, tn, &act_police_ops);
 }
 
 static void __net_exit police_exit_net(struct list_head *net_list)
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 595308d60133..7eff363f9f03 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -265,7 +265,7 @@ static __net_init int sample_init_net(struct net *net)
 {
 	struct tc_action_net *tn = net_generic(net, sample_net_id);
 
-	return tc_action_net_init(tn, &act_sample_ops);
+	return tc_action_net_init(net, tn, &act_sample_ops);
 }
 
 static void __net_exit sample_exit_net(struct list_head *net_list)
diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
index 33aefa25b545..6120e56117ca 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -232,7 +232,7 @@ static __net_init int simp_init_net(struct net *net)
 {
 	struct tc_action_net *tn = net_generic(net, simp_net_id);
 
-	return tc_action_net_init(tn, &act_simp_ops);
+	return tc_action_net_init(net, tn, &act_simp_ops);
 }
 
 static void __net_exit simp_exit_net(struct list_head *net_list)
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 37dced00b63d..6a8d3337c577 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -336,7 +336,7 @@ static __net_init int skbedit_init_net(struct net *net)
 {
 	struct tc_action_net *tn = net_generic(net, skbedit_net_id);
 
-	return tc_action_net_init(tn, &act_skbedit_ops);
+	return tc_action_net_init(net, tn, &act_skbedit_ops);
 }
 
 static void __net_exit skbedit_exit_net(struct list_head *net_list)
diff --git a/net/sched/act_skbmod.c b/net/sched/act_skbmod.c
index 7da3518e18ef..888437f97ba6 100644
--- a/net/sched/act_skbmod.c
+++ b/net/sched/act_skbmod.c
@@ -287,7 +287,7 @@ static __net_init int skbmod_init_net(struct net *net)
 {
 	struct tc_action_net *tn = net_generic(net, skbmod_net_id);
 
-	return tc_action_net_init(tn, &act_skbmod_ops);
+	return tc_action_net_init(net, tn, &act_skbmod_ops);
 }
 
 static void __net_exit skbmod_exit_net(struct list_head *net_list)
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 6d0debdc9b97..2f83a79f76aa 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -600,7 +600,7 @@ static __net_init int tunnel_key_init_net(struct net *net)
 {
 	struct tc_action_net *tn = net_generic(net, tunnel_key_net_id);
 
-	return tc_action_net_init(tn, &act_tunnel_key_ops);
+	return tc_action_net_init(net, tn, &act_tunnel_key_ops);
 }
 
 static void __net_exit tunnel_key_exit_net(struct list_head *net_list)
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index a3c9eea1ee8a..287a30bf8930 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -334,7 +334,7 @@ static __net_init int vlan_init_net(struct net *net)
 {
 	struct tc_action_net *tn = net_generic(net, vlan_net_id);
 
-	return tc_action_net_init(tn, &act_vlan_ops);
+	return tc_action_net_init(net, tn, &act_vlan_ops);
 }
 
 static void __net_exit vlan_exit_net(struct list_head *net_list)
-- 
2.21.0

