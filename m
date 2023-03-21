Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA276C28FC
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 05:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbjCUEGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 00:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbjCUEGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 00:06:18 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1811C39BB0
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 21:02:36 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-544d2dc2649so96152847b3.15
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 21:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679371279;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iMdu42Da8Jl4TnzUtLkNk12BTB7xjmL0L+mihWZ8vHE=;
        b=ORFkifj2sYChgxp7IYYUXHrEEBMak/ocabL7o/UFf/MKDABi74pwo04DwZhPmsH0/S
         ED8jTeApv4ja34vZN3eK7CpX5n/qo82peA5piFy6wvOc6ntn050VACmi92PhtnhC4a5h
         6G6mogHrsXUHJGqdG0veu+GVgh7UkZN+3mUliLma/S009R6DSGYUv3ufpS8w3kDaL/ha
         SGbtpO0iwzAM4cgPhHepe0eHnXBrQgFrx88tfxQGEIv7vYBU/Ku/qSsik5HpbxsXg2/j
         +9M971dxFS9ZLp/DLVmrJKSW36N6TtboADNtIkXshH6yMvM+QKyU9HQbUdfBEiZbBhAH
         DPtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679371279;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iMdu42Da8Jl4TnzUtLkNk12BTB7xjmL0L+mihWZ8vHE=;
        b=UG7yhm21RRV769J1wG/ZoGXfCleVgIyQkzN0HU1uJlZLL4Bg3ii9P+U06idC2ua5E4
         NSGgi3QvPtjcS17M4zGKhX1ttHf31QVK5uR7K51yMY4f53SPE4Fj4/jz965Sk9YrE7+R
         jZjiCap/4A6ihfybayuPXE91SE7l/Adl20ai9WRAWew0jIA6/lrQAxM8HhRPsIaGUMnY
         t64aFpqgPuysYeU/9OWzNxnpzMZtXC1FXkI1bCpfSFBWzAuoNByHuQU54at1xarvyfR6
         xFJquML1kUS+Ozm722Tzggr0rVygCthWwiUYEtTgNdrFXhCmb91oOfEpYa0zsKtOEW/I
         9qEw==
X-Gm-Message-State: AAQBX9eSLHyDAD22cOCGd7autVYOxxHdjutT7rbUMcQOGumx7kUkSSVL
        1heH/pzrWJMTPOL9+H7LH54vzHt4ntGHJg==
X-Google-Smtp-Source: AKy350YKYfHF8PchLIuFrFKnQ44yM7rJtYT6HQUMZG1+/XLOYN9hYB441xbnAixgKTJTpqqXD9TyQSSsChY2ug==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:34a:0:b0:a99:de9d:d504 with SMTP id
 q10-20020a5b034a000000b00a99de9dd504mr527135ybp.12.1679371279001; Mon, 20 Mar
 2023 21:01:19 -0700 (PDT)
Date:   Tue, 21 Mar 2023 04:01:13 +0000
In-Reply-To: <20230321040115.787497-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230321040115.787497-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230321040115.787497-2-edumazet@google.com>
Subject: [PATCH net-next 1/3] ipv6: flowlabel: do not disable BH where not needed
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct ip6_flowlabel are rcu managed, and call_rcu() is used
to delay fl_free_rcu() after RCU grace period.

There is no point disabling BH for pure RCU lookups.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ip6_flowlabel.c | 51 +++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 24 deletions(-)

diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index 18481eb76a0a4a0e79924f4c657412d09bf914fe..b3ca4beb4405aa9dc4ce610abda9a46ac3ceb5fb 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -58,18 +58,18 @@ DEFINE_STATIC_KEY_DEFERRED_FALSE(ipv6_flowlabel_exclusive, HZ);
 EXPORT_SYMBOL(ipv6_flowlabel_exclusive);
 
 #define for_each_fl_rcu(hash, fl)				\
-	for (fl = rcu_dereference_bh(fl_ht[(hash)]);		\
+	for (fl = rcu_dereference(fl_ht[(hash)]);		\
 	     fl != NULL;					\
-	     fl = rcu_dereference_bh(fl->next))
+	     fl = rcu_dereference(fl->next))
 #define for_each_fl_continue_rcu(fl)				\
-	for (fl = rcu_dereference_bh(fl->next);			\
+	for (fl = rcu_dereference(fl->next);			\
 	     fl != NULL;					\
-	     fl = rcu_dereference_bh(fl->next))
+	     fl = rcu_dereference(fl->next))
 
 #define for_each_sk_fl_rcu(np, sfl)				\
-	for (sfl = rcu_dereference_bh(np->ipv6_fl_list);	\
+	for (sfl = rcu_dereference(np->ipv6_fl_list);	\
 	     sfl != NULL;					\
-	     sfl = rcu_dereference_bh(sfl->next))
+	     sfl = rcu_dereference(sfl->next))
 
 static inline struct ip6_flowlabel *__fl_lookup(struct net *net, __be32 label)
 {
@@ -86,11 +86,11 @@ static struct ip6_flowlabel *fl_lookup(struct net *net, __be32 label)
 {
 	struct ip6_flowlabel *fl;
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	fl = __fl_lookup(net, label);
 	if (fl && !atomic_inc_not_zero(&fl->users))
 		fl = NULL;
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 	return fl;
 }
 
@@ -217,6 +217,7 @@ static struct ip6_flowlabel *fl_intern(struct net *net,
 
 	fl->label = label & IPV6_FLOWLABEL_MASK;
 
+	rcu_read_lock();
 	spin_lock_bh(&ip6_fl_lock);
 	if (label == 0) {
 		for (;;) {
@@ -240,6 +241,7 @@ static struct ip6_flowlabel *fl_intern(struct net *net,
 		if (lfl) {
 			atomic_inc(&lfl->users);
 			spin_unlock_bh(&ip6_fl_lock);
+			rcu_read_unlock();
 			return lfl;
 		}
 	}
@@ -249,6 +251,7 @@ static struct ip6_flowlabel *fl_intern(struct net *net,
 	rcu_assign_pointer(fl_ht[FL_HASH(fl->label)], fl);
 	atomic_inc(&fl_size);
 	spin_unlock_bh(&ip6_fl_lock);
+	rcu_read_unlock();
 	return NULL;
 }
 
@@ -263,17 +266,17 @@ struct ip6_flowlabel *__fl6_sock_lookup(struct sock *sk, __be32 label)
 
 	label &= IPV6_FLOWLABEL_MASK;
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	for_each_sk_fl_rcu(np, sfl) {
 		struct ip6_flowlabel *fl = sfl->fl;
 
 		if (fl->label == label && atomic_inc_not_zero(&fl->users)) {
 			fl->lastuse = jiffies;
-			rcu_read_unlock_bh();
+			rcu_read_unlock();
 			return fl;
 		}
 	}
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(__fl6_sock_lookup);
@@ -475,10 +478,10 @@ static int mem_check(struct sock *sk)
 	if (room > FL_MAX_SIZE - FL_MAX_PER_SOCK)
 		return 0;
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	for_each_sk_fl_rcu(np, sfl)
 		count++;
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 
 	if (room <= 0 ||
 	    ((count >= FL_MAX_PER_SOCK ||
@@ -515,7 +518,7 @@ int ipv6_flowlabel_opt_get(struct sock *sk, struct in6_flowlabel_req *freq,
 		return 0;
 	}
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 
 	for_each_sk_fl_rcu(np, sfl) {
 		if (sfl->fl->label == (np->flow_label & IPV6_FLOWLABEL_MASK)) {
@@ -527,11 +530,11 @@ int ipv6_flowlabel_opt_get(struct sock *sk, struct in6_flowlabel_req *freq,
 			freq->flr_linger = sfl->fl->linger / HZ;
 
 			spin_unlock_bh(&ip6_fl_lock);
-			rcu_read_unlock_bh();
+			rcu_read_unlock();
 			return 0;
 		}
 	}
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 
 	return -ENOENT;
 }
@@ -581,16 +584,16 @@ static int ipv6_flowlabel_renew(struct sock *sk, struct in6_flowlabel_req *freq)
 	struct ipv6_fl_socklist *sfl;
 	int err;
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	for_each_sk_fl_rcu(np, sfl) {
 		if (sfl->fl->label == freq->flr_label) {
 			err = fl6_renew(sfl->fl, freq->flr_linger,
 					freq->flr_expires);
-			rcu_read_unlock_bh();
+			rcu_read_unlock();
 			return err;
 		}
 	}
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 
 	if (freq->flr_share == IPV6_FL_S_NONE &&
 	    ns_capable(net->user_ns, CAP_NET_ADMIN)) {
@@ -641,11 +644,11 @@ static int ipv6_flowlabel_get(struct sock *sk, struct in6_flowlabel_req *freq,
 
 	if (freq->flr_label) {
 		err = -EEXIST;
-		rcu_read_lock_bh();
+		rcu_read_lock();
 		for_each_sk_fl_rcu(np, sfl) {
 			if (sfl->fl->label == freq->flr_label) {
 				if (freq->flr_flags & IPV6_FL_F_EXCL) {
-					rcu_read_unlock_bh();
+					rcu_read_unlock();
 					goto done;
 				}
 				fl1 = sfl->fl;
@@ -654,7 +657,7 @@ static int ipv6_flowlabel_get(struct sock *sk, struct in6_flowlabel_req *freq,
 				break;
 			}
 		}
-		rcu_read_unlock_bh();
+		rcu_read_unlock();
 
 		if (!fl1)
 			fl1 = fl_lookup(net, freq->flr_label);
@@ -809,7 +812,7 @@ static void *ip6fl_seq_start(struct seq_file *seq, loff_t *pos)
 
 	state->pid_ns = proc_pid_ns(file_inode(seq->file)->i_sb);
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	return *pos ? ip6fl_get_idx(seq, *pos - 1) : SEQ_START_TOKEN;
 }
 
@@ -828,7 +831,7 @@ static void *ip6fl_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 static void ip6fl_seq_stop(struct seq_file *seq, void *v)
 	__releases(RCU)
 {
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 }
 
 static int ip6fl_seq_show(struct seq_file *seq, void *v)
-- 
2.40.0.rc2.332.ga46443480c-goog

