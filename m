Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96AED4A97D
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730224AbfFRSJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:09:08 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:42350 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729491AbfFRSJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:09:08 -0400
Received: by mail-pg1-f201.google.com with SMTP id d3so10458561pgc.9
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 11:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fltJHv36HFm9n/ILzo0kGMiAooVVQe9cYH7csrg1MWE=;
        b=O/TEYhIolxrvt86tb6AQ87NeCS5LDvtu2s3DCLrCVVzNPmJRFaD3sPvhr4iCC5dFSz
         MSnhZiW5zKMYc1AZQlTwlXuMPpDRotpv3+gLCF18BV7arZHhPatqjf0oPUALXZtN8Em3
         e2f7QzFaMQIZ5+CZs9kvGhYQhPlBvSjLwqznz8N9//J8Y70gLCcJ1+yrCltylHThvDh/
         I6/9Dp5z0JiW8mb3c2TmXqdrntzalc74effzd3Ki5JgDoUqllpL1f/b7zHT4+6Foyriv
         YeDqN9bBsbpNqN/hRNcNGgvjTuLK82bTJhWWLIhEOHOqgedYHEO8PKY9Mt4B/p6JzeMw
         1u7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fltJHv36HFm9n/ILzo0kGMiAooVVQe9cYH7csrg1MWE=;
        b=nRZh7N1aTxW8jSiqEUs7UBGbPxhkISHlYzRJQsFZ+/vDwxHcwU59eugd6JoQdqVb6h
         P463pSCVwjn3x4n6d4LQ02AdGoDP0gJ36r93qRMUMFyuipvyk/g8hCsrAW3iSzGEYov5
         7UskypxXbxC8On4Eor7vhVuUiILw44bEjJLKsiA6I/e/sr59r1Zp9iFeDY5pkCa1Fisc
         fv9s7S7HQv2m1p6pFhM3ZLJ5RLoXc4R18+CEF9DpT2RC1NyzkFjTJDWi9AirnXCkEEZq
         /HFTPkqnoy9T14NKXIA9/ti/a8pIJ0yawz61DCC7fGC6VTTJCkU5RuVJnqzduMNiQD67
         +WlQ==
X-Gm-Message-State: APjAAAUSCpcAqbaB0cOWgJ+d6FCfUzMBkDVl9au9h60Z1wK65ad9B1ys
        ZYzl8Qyjjqzqa/8STwUyw4Qh/51PEBw55g==
X-Google-Smtp-Source: APXvYqwxM1wYBfYWC3Ws8teMyxivh/bnMHT2CknulK0RHwErzxYMw0pCsf0mLhexSe+Tz0jk+XKbAHFzE+u50w==
X-Received: by 2002:a17:902:6b02:: with SMTP id o2mr20574558plk.133.1560881346962;
 Tue, 18 Jun 2019 11:09:06 -0700 (PDT)
Date:   Tue, 18 Jun 2019 11:08:59 -0700
In-Reply-To: <20190618180900.88939-1-edumazet@google.com>
Message-Id: <20190618180900.88939-2-edumazet@google.com>
Mime-Version: 1.0
References: <20190618180900.88939-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net-next 1/2] netns: add pre_exit method to struct pernet_operations
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current struct pernet_operations exit() handlers are highly
discouraged to call synchronize_rcu().

There are cases where we need them, and exit_batch() does
not help the common case where a single netns is dismantled.

This patch leverages the existing synchronize_rcu() call
in cleanup_net()

Calling optional ->pre_exit() method before ->exit() or
->exit_batch() allows to benefit from a single synchronize_rcu()
call.

Note that the synchronize_rcu() calls added in this patch
are only in error paths or slow paths.

Tested:

$ time for i in {1..1000}; do unshare -n /bin/false;done

real	0m2.612s
user	0m0.171s
sys	0m2.216s

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/net_namespace.h |  5 +++++
 net/core/net_namespace.c    | 28 ++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index abb4f92456e1b0a0eb59bba676295d202ac008e0..ad9243afac672d054b27b933a23a696232987b61 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -355,8 +355,13 @@ struct pernet_operations {
 	 * synchronize_rcu() related to these pernet_operations,
 	 * instead of separate synchronize_rcu() for every net.
 	 * Please, avoid synchronize_rcu() at all, where it's possible.
+	 *
+	 * Note that a combination of pre_exit() and exit() can
+	 * be used, since a synchronize_rcu() is guaranteed between
+	 * the calls.
 	 */
 	int (*init)(struct net *net);
+	void (*pre_exit)(struct net *net);
 	void (*exit)(struct net *net);
 	void (*exit_batch)(struct list_head *net_exit_list);
 	unsigned int *id;
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 15f68842ac6b4c32845d9550f2b2e89ca4406999..89dc99a28978f14f8227904013282212b15d513b 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -145,6 +145,17 @@ static void ops_free(const struct pernet_operations *ops, struct net *net)
 	}
 }
 
+static void ops_pre_exit_list(const struct pernet_operations *ops,
+			      struct list_head *net_exit_list)
+{
+	struct net *net;
+
+	if (ops->pre_exit) {
+		list_for_each_entry(net, net_exit_list, exit_list)
+			ops->pre_exit(net);
+	}
+}
+
 static void ops_exit_list(const struct pernet_operations *ops,
 			  struct list_head *net_exit_list)
 {
@@ -328,6 +339,12 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
 	 * for the pernet modules whose init functions did not fail.
 	 */
 	list_add(&net->exit_list, &net_exit_list);
+	saved_ops = ops;
+	list_for_each_entry_continue_reverse(ops, &pernet_list, list)
+		ops_pre_exit_list(ops, &net_exit_list);
+
+	synchronize_rcu();
+
 	saved_ops = ops;
 	list_for_each_entry_continue_reverse(ops, &pernet_list, list)
 		ops_exit_list(ops, &net_exit_list);
@@ -541,10 +558,15 @@ static void cleanup_net(struct work_struct *work)
 		list_add_tail(&net->exit_list, &net_exit_list);
 	}
 
+	/* Run all of the network namespace pre_exit methods */
+	list_for_each_entry_reverse(ops, &pernet_list, list)
+		ops_pre_exit_list(ops, &net_exit_list);
+
 	/*
 	 * Another CPU might be rcu-iterating the list, wait for it.
 	 * This needs to be before calling the exit() notifiers, so
 	 * the rcu_barrier() below isn't sufficient alone.
+	 * Also the pre_exit() and exit() methods need this barrier.
 	 */
 	synchronize_rcu();
 
@@ -1101,6 +1123,8 @@ static int __register_pernet_operations(struct list_head *list,
 out_undo:
 	/* If I have an error cleanup all namespaces I initialized */
 	list_del(&ops->list);
+	ops_pre_exit_list(ops, &net_exit_list);
+	synchronize_rcu();
 	ops_exit_list(ops, &net_exit_list);
 	ops_free_list(ops, &net_exit_list);
 	return error;
@@ -1115,6 +1139,8 @@ static void __unregister_pernet_operations(struct pernet_operations *ops)
 	/* See comment in __register_pernet_operations() */
 	for_each_net(net)
 		list_add_tail(&net->exit_list, &net_exit_list);
+	ops_pre_exit_list(ops, &net_exit_list);
+	synchronize_rcu();
 	ops_exit_list(ops, &net_exit_list);
 	ops_free_list(ops, &net_exit_list);
 }
@@ -1139,6 +1165,8 @@ static void __unregister_pernet_operations(struct pernet_operations *ops)
 	} else {
 		LIST_HEAD(net_exit_list);
 		list_add(&init_net.exit_list, &net_exit_list);
+		ops_pre_exit_list(ops, &net_exit_list);
+		synchronize_rcu();
 		ops_exit_list(ops, &net_exit_list);
 		ops_free_list(ops, &net_exit_list);
 	}
-- 
2.22.0.410.gd8fdbe21b5-goog

