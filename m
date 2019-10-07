Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84B4FCED63
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 22:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbfJGU07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 16:26:59 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39988 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728212AbfJGU07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 16:26:59 -0400
Received: by mail-pf1-f195.google.com with SMTP id x127so9365457pfb.7
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 13:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OZ03FqMB0SLdCjZ8MYMuyfUXEa4qgeTHP9Wr87lgkwM=;
        b=ZNbAhLkSJpMbekfhXZYNv6R11a9S3tCcktq6R3Tk9b92THHB7IVWdmrzEtnfd5rkzS
         n20M+jHn23V0TTQ/rW6VmWZMbo6cdtvh1R88e5+GPAqG4Wtj/Nmox4+43yiFJDfau5Ss
         0KPV4CuC/DsoGwrZk4VCefbhnEb/mGNFaMjT7zXJ5n1q6ckE2qO3LGa3Oaq8ecLfJaWF
         mZswU4WWd6B+Cr3WEyx1/kuvxE9JMYNxNKGdzP9wqMVg++fcGiHfeDYqSQY2v3Jkzbol
         Va8dt11a71h5iQ4fo3emI3eElmE74jnJQkjNR7+Mbq9KrLIdw8Uf/V7n/OHu6vYvA6SK
         OXgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OZ03FqMB0SLdCjZ8MYMuyfUXEa4qgeTHP9Wr87lgkwM=;
        b=o332JJ4noG68Kur5vB4P4w/VpXHELqKTWeehGj5edGKoagUZVhM1Z8swLyrDvae3LI
         pj/u3WT0M9JU1MlKm3yPdtOS3GX/OK2HBJBXkj36StM8mTJcntWE22K2hNwOn+o+XsLa
         bv3WcML5Mx+/XPIsC/QOvPCatiI7eNQhLzTJSVgKnnEY9dM2Qirqon8/kdUTAcg1jsH2
         NR2HPNd28r9knxowJ9N0xRJP9Ye7V6AYj5JHM4j8JJl0XYU/d7ssWm4aOUMjhU9d4q4q
         jrOWJoaOzKB5Y8vNvzR1jepFzz3ieH8Ax+sjWBGk5lFdaW5gfqwCA9YV07c2eeJtecMw
         abgA==
X-Gm-Message-State: APjAAAWXZ618o2G8OUXxGkDJR1fgja0IwoZmGKVMTnZJjTijyayobmvU
        3Roqw2dR703zjeQHzxiVeagvmOYI
X-Google-Smtp-Source: APXvYqzofW6mJRmSfxjkaXh3p84lgMOFsT9JBeGiXyOj83aGWYoknwMZRiPhGBAFcn4t5VhxtSJeSw==
X-Received: by 2002:a62:7d54:: with SMTP id y81mr118311pfc.86.1570480016770;
        Mon, 07 Oct 2019 13:26:56 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id k8sm12679602pgm.14.2019.10.07.13.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 13:26:56 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net] net_sched: fix backward compatibility for TCA_KIND
Date:   Mon,  7 Oct 2019 13:26:28 -0700
Message-Id: <20191007202629.32462-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marcelo noticed a backward compatibility issue of TCA_KIND
after we move from NLA_STRING to NLA_NUL_STRING, so it is probably
too late to change it.

Instead, to make everyone happy, we can just insert a NUL to
terminate the string with nla_strlcpy() like we do for TC actions.

Fixes: 62794fc4fbf5 ("net_sched: add max len check for TCA_KIND")
Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/cls_api.c | 36 +++++++++++++++++++++++++++++++++---
 net/sched/sch_api.c |  3 +--
 2 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 64584a1df425..8717c0b26c90 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -162,11 +162,22 @@ static inline u32 tcf_auto_prio(struct tcf_proto *tp)
 	return TC_H_MAJ(first);
 }
 
+static bool tcf_proto_check_kind(struct nlattr *kind, char *name)
+{
+	if (kind)
+		return nla_strlcpy(name, kind, IFNAMSIZ) >= IFNAMSIZ;
+	memset(name, 0, IFNAMSIZ);
+	return false;
+}
+
 static bool tcf_proto_is_unlocked(const char *kind)
 {
 	const struct tcf_proto_ops *ops;
 	bool ret;
 
+	if (strlen(kind) == 0)
+		return false;
+
 	ops = tcf_proto_lookup_ops(kind, false, NULL);
 	/* On error return false to take rtnl lock. Proto lookup/create
 	 * functions will perform lookup again and properly handle errors.
@@ -1843,6 +1854,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 {
 	struct net *net = sock_net(skb->sk);
 	struct nlattr *tca[TCA_MAX + 1];
+	char name[IFNAMSIZ];
 	struct tcmsg *t;
 	u32 protocol;
 	u32 prio;
@@ -1899,13 +1911,19 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	if (err)
 		return err;
 
+	if (tcf_proto_check_kind(tca[TCA_KIND], name)) {
+		NL_SET_ERR_MSG(extack, "Specified TC filter name too long");
+		err = -EINVAL;
+		goto errout;
+	}
+
 	/* Take rtnl mutex if rtnl_held was set to true on previous iteration,
 	 * block is shared (no qdisc found), qdisc is not unlocked, classifier
 	 * type is not specified, classifier is not unlocked.
 	 */
 	if (rtnl_held ||
 	    (q && !(q->ops->cl_ops->flags & QDISC_CLASS_OPS_DOIT_UNLOCKED)) ||
-	    !tca[TCA_KIND] || !tcf_proto_is_unlocked(nla_data(tca[TCA_KIND]))) {
+	    !tcf_proto_is_unlocked(name)) {
 		rtnl_held = true;
 		rtnl_lock();
 	}
@@ -2063,6 +2081,7 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 {
 	struct net *net = sock_net(skb->sk);
 	struct nlattr *tca[TCA_MAX + 1];
+	char name[IFNAMSIZ];
 	struct tcmsg *t;
 	u32 protocol;
 	u32 prio;
@@ -2102,13 +2121,18 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	if (err)
 		return err;
 
+	if (tcf_proto_check_kind(tca[TCA_KIND], name)) {
+		NL_SET_ERR_MSG(extack, "Specified TC filter name too long");
+		err = -EINVAL;
+		goto errout;
+	}
 	/* Take rtnl mutex if flushing whole chain, block is shared (no qdisc
 	 * found), qdisc is not unlocked, classifier type is not specified,
 	 * classifier is not unlocked.
 	 */
 	if (!prio ||
 	    (q && !(q->ops->cl_ops->flags & QDISC_CLASS_OPS_DOIT_UNLOCKED)) ||
-	    !tca[TCA_KIND] || !tcf_proto_is_unlocked(nla_data(tca[TCA_KIND]))) {
+	    !tcf_proto_is_unlocked(name)) {
 		rtnl_held = true;
 		rtnl_lock();
 	}
@@ -2216,6 +2240,7 @@ static int tc_get_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 {
 	struct net *net = sock_net(skb->sk);
 	struct nlattr *tca[TCA_MAX + 1];
+	char name[IFNAMSIZ];
 	struct tcmsg *t;
 	u32 protocol;
 	u32 prio;
@@ -2252,12 +2277,17 @@ static int tc_get_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	if (err)
 		return err;
 
+	if (tcf_proto_check_kind(tca[TCA_KIND], name)) {
+		NL_SET_ERR_MSG(extack, "Specified TC filter name too long");
+		err = -EINVAL;
+		goto errout;
+	}
 	/* Take rtnl mutex if block is shared (no qdisc found), qdisc is not
 	 * unlocked, classifier type is not specified, classifier is not
 	 * unlocked.
 	 */
 	if ((q && !(q->ops->cl_ops->flags & QDISC_CLASS_OPS_DOIT_UNLOCKED)) ||
-	    !tca[TCA_KIND] || !tcf_proto_is_unlocked(nla_data(tca[TCA_KIND]))) {
+	    !tcf_proto_is_unlocked(name)) {
 		rtnl_held = true;
 		rtnl_lock();
 	}
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 81d58b280612..1047825d9f48 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1390,8 +1390,7 @@ check_loop_fn(struct Qdisc *q, unsigned long cl, struct qdisc_walker *w)
 }
 
 const struct nla_policy rtm_tca_policy[TCA_MAX + 1] = {
-	[TCA_KIND]		= { .type = NLA_NUL_STRING,
-				    .len = IFNAMSIZ - 1 },
+	[TCA_KIND]		= { .type = NLA_STRING },
 	[TCA_RATE]		= { .type = NLA_BINARY,
 				    .len = sizeof(struct tc_estimator) },
 	[TCA_STAB]		= { .type = NLA_NESTED },
-- 
2.21.0

