Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCC6C94AE
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbfJBXPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:15:05 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42612 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728072AbfJBXPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 19:15:04 -0400
Received: by mail-wr1-f67.google.com with SMTP id n14so777453wrw.9
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 16:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oRf/Gae629dew0s2u7c7W581DKh0vhy3EfR5nJ5I3Fs=;
        b=Y/dw60mCljp/h2Cmbr7kXIMcNxGtjnu1kuorczRSwyMjV9UrjSovBpeiG5q9iWCvok
         ZsWvFeDdL2aiXBRykkzgonYM06rCz0wchM+//fOAMgBjyCoWPZ0Jn4ywQsmvkJdLSaw6
         WCNPeMj6XjPdWVpMyWSAU7yO9HGk4Y3/XfaoaAaJ2CrsBE7aGohWY/vWVWkiwLQxHtFD
         4YtC3BT1dpEBlydsoS2giaqcTs0GnChSdVBkH2MK8lL+StNDBEvmp+48CBtNEVrg1Ea1
         If9tG2yoTJCgEtAZlshwJkTONxPFwSYXyVzXDffEB3FLKFkeBv95FjVu363Jkvq9CF4R
         VfaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oRf/Gae629dew0s2u7c7W581DKh0vhy3EfR5nJ5I3Fs=;
        b=DFtERw8tXh2C9fQ2/FQZS41SQ/nBBsdhk/AZyNx8y1a2JnO7i3PcBjOFvpSxH9KQkt
         Z9Pg8sL6FfqGrKIJSuPWwYwZGF5yy6gjQi91dvfXGxGB66PQeys66Pfs+I/El3e3/kyM
         lWPPCoMvadVN5kIMQGzp1vzu5PiiXOGErW2lScq/FFiOi7/wtozB/ebWg6g528U2KOMS
         ZadBgcmqPbuVu/k/gV0MR31shZi7mCnqjSitULz21INXKkwyuaeUNmGbSCQFsBPNxDHu
         b8XLRegpheUb/DApg+7/bFJD+wbZ4KsPFBi1P5yJ+e9hfxqIL6S61x2ZIpjJfxa9pw43
         ljDg==
X-Gm-Message-State: APjAAAWQiR4ca32P7TGrSUFSiVZW1Gc11trOMBOr53e0nVWNTTYkzXPS
        GBeLGk41HD8LdOdyyOxJdYuu7w==
X-Google-Smtp-Source: APXvYqxPiMkfU4g3BF9lseMsCAkGFj7QeNXvYL7dfNaZCjkccCrKztVA0gvL/7dUN+3aWlVLR5dPbQ==
X-Received: by 2002:adf:fcc7:: with SMTP id f7mr4449226wrs.319.1570058102300;
        Wed, 02 Oct 2019 16:15:02 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id l11sm643895wmh.34.2019.10.02.16.15.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 02 Oct 2019 16:15:01 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     vladbu@mellanox.com
Cc:     jiri@mellanox.com, netdev@vger.kernel.org,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [RFC net-next 1/2] net: sched: add tp_op for pre_destroy
Date:   Thu,  3 Oct 2019 00:14:31 +0100
Message-Id: <1570058072-12004-2-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1570058072-12004-1-git-send-email-john.hurley@netronome.com>
References: <1570058072-12004-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible that a race condition may exist when a tcf_proto is
destroyed. Several actions occur before the destroy() tcf_proto_op is
called so if no higher level locking (e.g. RTNL) is in use then other
rules may be received and processed in parallel before the classifier's
specific destroy functions are completed.

Add a new tcf_proto_op called pre_destroy that is triggered when a
tcf_proto is signalled to be destroyed. This allows classifiers the
option of implementing tasks at this hook.

Fixes: 1d965c4def07 ("Refactor flower classifier to remove dependency on rtnl lock")
Signed-off-by: John Hurley <john.hurley@netronome.com>
Reported-by: Louis Peens <louis.peens@netronome.com>
---
 include/net/sch_generic.h |  3 +++
 net/sched/cls_api.c       | 29 ++++++++++++++++++++++++++++-
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 637548d..e458d6f 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -294,6 +294,9 @@ struct tcf_proto_ops {
 					    const struct tcf_proto *,
 					    struct tcf_result *);
 	int			(*init)(struct tcf_proto*);
+	void			(*pre_destroy)(struct tcf_proto *tp,
+					       bool rtnl_held,
+					       struct netlink_ext_ack *extack);
 	void			(*destroy)(struct tcf_proto *tp, bool rtnl_held,
 					   struct netlink_ext_ack *extack);
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 64584a1..aecf716 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -222,6 +222,13 @@ static void tcf_proto_get(struct tcf_proto *tp)
 
 static void tcf_chain_put(struct tcf_chain *chain);
 
+static void tcf_proto_pre_destroy(struct tcf_proto *tp, bool rtnl_held,
+				  struct netlink_ext_ack *extack)
+{
+	if (tp->ops->pre_destroy)
+		tp->ops->pre_destroy(tp, rtnl_held, extack);
+}
+
 static void tcf_proto_destroy(struct tcf_proto *tp, bool rtnl_held,
 			      struct netlink_ext_ack *extack)
 {
@@ -534,9 +541,18 @@ static void tcf_chain_flush(struct tcf_chain *chain, bool rtnl_held)
 
 	mutex_lock(&chain->filter_chain_lock);
 	tp = tcf_chain_dereference(chain->filter_chain, chain);
+	chain->flushing = true;
+	mutex_unlock(&chain->filter_chain_lock);
+
+	while (tp) {
+		tcf_proto_pre_destroy(tp, rtnl_held, NULL);
+		tp = rcu_dereference_protected(tp->next, 1);
+	}
+
+	mutex_lock(&chain->filter_chain_lock);
+	tp = tcf_chain_dereference(chain->filter_chain, chain);
 	RCU_INIT_POINTER(chain->filter_chain, NULL);
 	tcf_chain0_head_change(chain, NULL);
-	chain->flushing = true;
 	mutex_unlock(&chain->filter_chain_lock);
 
 	while (tp) {
@@ -1636,6 +1652,8 @@ static void tcf_chain_tp_delete_empty(struct tcf_chain *chain,
 	struct tcf_proto **pprev;
 	struct tcf_proto *next;
 
+	tcf_proto_pre_destroy(tp, rtnl_held, extack);
+
 	mutex_lock(&chain->filter_chain_lock);
 
 	/* Atomically find and remove tp from chain. */
@@ -2164,6 +2182,15 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 		err = -EINVAL;
 		goto errout_locked;
 	} else if (t->tcm_handle == 0) {
+		mutex_unlock(&chain->filter_chain_lock);
+
+		tcf_proto_pre_destroy(tp, rtnl_held, extack);
+		tcf_proto_put(tp, rtnl_held, NULL);
+
+		mutex_lock(&chain->filter_chain_lock);
+		/* Lookup again and take new ref incase of parallel update. */
+		tp = tcf_chain_tp_find(chain, &chain_info, protocol, prio,
+				       false);
 		tcf_chain_tp_remove(chain, &chain_info, tp);
 		mutex_unlock(&chain->filter_chain_lock);
 
-- 
2.7.4

