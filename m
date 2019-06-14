Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF79E46CCB
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 01:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbfFNXWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 19:22:31 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:34737 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfFNXWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 19:22:31 -0400
Received: by mail-pl1-f201.google.com with SMTP id d19so2465140pls.1
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 16:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ydEopugx+19UA1OI3lYmWdMWzfroaM/vpXteksdE9/o=;
        b=eSJhvqNV3UIQh5c5N1kekqoJg9sfMdf7ksjkSf52EfIx+C3ho4wqWVeHuCJHhWm1y5
         mYtf4aj1xBALhxkTptiJnsI1NBHFoJhKwqWWD+wTklExKPkkYy9opVc39KZ4z7A1qE3m
         9ItTADloNmstd6tq1qpx6Vap7Vl51uXFZiNBtkS6u8IcuGMUzMae5UBX1p5/3AoUd5LQ
         rxK4Zf1Aw7STtj03hvViYbUf4GLAk7URWJ/86NjhM6QtVfQWc1N67eqdOIeIsXvyfQfn
         GTq3QvWfyWm3bilL4lCcTfWRX0Iu+WlTCPwfoHM+TugA7Tlv/yd3tAbOH+pm3dHEQaDq
         VeGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ydEopugx+19UA1OI3lYmWdMWzfroaM/vpXteksdE9/o=;
        b=G/H0BWDAv2XTRrLfscapSc4fs+bDrxX4j1UICIPIagmpdPof6nQlHyCHHwOJxKU+8X
         AlvdIgb6LWjjA9/t/CG4CYxYincdp0cc2qGQ0hMD5qmoTeUL9sI04pQDWKEOJ3Gqp/2Z
         5BSZbzN1+CBcYQr6AOzC6HkmgNk73q3vraSfTak2Y5f1rF4atI04nXYIT8lPTTMwvz90
         Wbg84ST3TiEHtlMx+d4ex4VnXfTszRd68uUPR5DD6vi/wFOlSyqUAP1lT8IeRMKPTzdN
         eQjjTIpgJjrxLtfxuYuJ/2BqrrbHNTlbYcjUWK6Ya8mK8/ftv2/FlDQu+AQmz/zAky7a
         Ub0g==
X-Gm-Message-State: APjAAAW2osJAbcKRlMZ3N3XBr1k0MRJoHijTEY3U+9HEYnOugUm0El9E
        84BMhXHKIRt63y6PIu6ewh8BGK/G39Ft0w==
X-Google-Smtp-Source: APXvYqy+XYGGlsHmbzBPexS6ENm2gGAnf5EWEhLkHWy0VubSo4tH6CJ+AH8LQgbYzk+VoEAu1EOi1NWN7NR0iQ==
X-Received: by 2002:a63:81c6:: with SMTP id t189mr37369705pgd.293.1560554550340;
 Fri, 14 Jun 2019 16:22:30 -0700 (PDT)
Date:   Fri, 14 Jun 2019 16:22:18 -0700
In-Reply-To: <20190614232221.248392-1-edumazet@google.com>
Message-Id: <20190614232221.248392-2-edumazet@google.com>
Mime-Version: 1.0
References: <20190614232221.248392-1-edumazet@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net 1/4] sysctl: define proc_do_static_key()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert proc_dointvec_minmax_bpf_stats() into a more generic
helper, since we are going to use jump labels more often.

Note that sysctl_bpf_stats_enabled is removed, since
it is no longer needed/used.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/bpf.h    |  1 -
 include/linux/sysctl.h |  3 +++
 kernel/bpf/core.c      |  1 -
 kernel/sysctl.c        | 44 ++++++++++++++++++++++--------------------
 4 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5df8e9e2a3933949af17dda1d77a4daccd5df611..b92ef9f73e42f1bcf0141aa21d0e9c17c5c7f05b 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -600,7 +600,6 @@ void bpf_map_area_free(void *base);
 void bpf_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr);
 
 extern int sysctl_unprivileged_bpf_disabled;
-extern int sysctl_bpf_stats_enabled;
 
 int bpf_map_new_fd(struct bpf_map *map, int flags);
 int bpf_prog_new_fd(struct bpf_prog *prog);
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index b769ecfcc3bd41aad6fd339ba824c6bb622ac24d..aadd310769d080f1d45db14b2a72fc8ad36f1196 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -63,6 +63,9 @@ extern int proc_doulongvec_ms_jiffies_minmax(struct ctl_table *table, int,
 				      void __user *, size_t *, loff_t *);
 extern int proc_do_large_bitmap(struct ctl_table *, int,
 				void __user *, size_t *, loff_t *);
+extern int proc_do_static_key(struct ctl_table *table, int write,
+			      void __user *buffer, size_t *lenp,
+			      loff_t *ppos);
 
 /*
  * Register a set of sysctl names by calling register_sysctl_table
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 7c473f208a1058de97434a57a2d47e2360ae80a8..080e2bb644ccd761b3d54fbad9b58a881086231e 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2097,7 +2097,6 @@ int __weak skb_copy_bits(const struct sk_buff *skb, int offset, void *to,
 
 DEFINE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
 EXPORT_SYMBOL(bpf_stats_enabled_key);
-int sysctl_bpf_stats_enabled __read_mostly;
 
 /* All definitions of tracepoints related to BPF. */
 #define CREATE_TRACE_POINTS
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 7d1008be6173313c807b2abb23f3171ef05cddc8..1beca96fb6252ddc4af07b6292f9dd95c4f53afd 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -230,11 +230,6 @@ static int proc_dostring_coredump(struct ctl_table *table, int write,
 #endif
 static int proc_dopipe_max_size(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp, loff_t *ppos);
-#ifdef CONFIG_BPF_SYSCALL
-static int proc_dointvec_minmax_bpf_stats(struct ctl_table *table, int write,
-					  void __user *buffer, size_t *lenp,
-					  loff_t *ppos);
-#endif
 
 #ifdef CONFIG_MAGIC_SYSRQ
 /* Note: sysrq code uses its own private copy */
@@ -1253,12 +1248,10 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.procname	= "bpf_stats_enabled",
-		.data		= &sysctl_bpf_stats_enabled,
-		.maxlen		= sizeof(sysctl_bpf_stats_enabled),
+		.data		= &bpf_stats_enabled_key.key,
+		.maxlen		= sizeof(bpf_stats_enabled_key),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax_bpf_stats,
-		.extra1		= &zero,
-		.extra2		= &one,
+		.proc_handler	= proc_do_static_key,
 	},
 #endif
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_PREEMPT_RCU)
@@ -3374,26 +3367,35 @@ int proc_do_large_bitmap(struct ctl_table *table, int write,
 
 #endif /* CONFIG_PROC_SYSCTL */
 
-#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_SYSCTL)
-static int proc_dointvec_minmax_bpf_stats(struct ctl_table *table, int write,
-					  void __user *buffer, size_t *lenp,
-					  loff_t *ppos)
+#if defined(CONFIG_SYSCTL)
+int proc_do_static_key(struct ctl_table *table, int write,
+		       void __user *buffer, size_t *lenp,
+		       loff_t *ppos)
 {
-	int ret, bpf_stats = *(int *)table->data;
-	struct ctl_table tmp = *table;
+	struct static_key *key = (struct static_key *)table->data;
+	static DEFINE_MUTEX(static_key_mutex);
+	int val, ret;
+	struct ctl_table tmp = {
+		.data   = &val,
+		.maxlen = sizeof(val),
+		.mode   = table->mode,
+		.extra1 = &zero,
+		.extra2 = &one,
+	};
 
 	if (write && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	tmp.data = &bpf_stats;
+	mutex_lock(&static_key_mutex);
+	val = static_key_enabled(key);
 	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
 	if (write && !ret) {
-		*(int *)table->data = bpf_stats;
-		if (bpf_stats)
-			static_branch_enable(&bpf_stats_enabled_key);
+		if (val)
+			static_key_enable(key);
 		else
-			static_branch_disable(&bpf_stats_enabled_key);
+			static_key_disable(key);
 	}
+	mutex_unlock(&static_key_mutex);
 	return ret;
 }
 #endif
-- 
2.22.0.410.gd8fdbe21b5-goog

