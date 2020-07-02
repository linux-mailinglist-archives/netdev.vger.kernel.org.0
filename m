Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CABB212C8D
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 20:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbgGBSxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 14:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbgGBSxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 14:53:06 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8967C08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 11:53:05 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id h22so12906335pjf.1
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 11:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=URd915rQSgqAfDLKyjrPsB58MLy827wyrlr6KMAyZXQ=;
        b=a0ZAZ77nVFnJEFPgPGeZrzjaITBubxP0ADvb/MwF0MhpzXwCE+yp4qDcLzkQA23f2m
         bgAU5LTcmc4ePPfp8beuTEqHTiJThBbUi9HjYv6xm6A9OiAurNdTlyKvV8jBSuiBME6x
         cDjcqrhDiNv0mcrX499UhJ4rx6NVRbmyiVbfz1LHJmnZWYVH57l/or/p/Cmek1KA8H1I
         5r++kdYx2B0V7K/UKfvL+XZpuMgDOuef+UE4iBR0k5PlwE1tiOpylaza4lm4s5xhJRKc
         BdfCJ/60jKTYdstgnPRX4GLiRuJYhoTKMfuO6wA5OotF5ufl0n6eaXzkyerdgkeHQIhr
         qeWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=URd915rQSgqAfDLKyjrPsB58MLy827wyrlr6KMAyZXQ=;
        b=n5dqJeA3X7Hz9Z4t2pZendgDqcsQl+BIWZW2zdY97DluOyqeFoCoqSTbwpd24QllPO
         z9RJkIetEi+rxhYhyAz6ecgboYKFFQjeZjSkVAA25ZnlSatHtiM0V+MTqsXOtt//fQGh
         0W9eqS8sAF5wAn9SB4mZBMCfkw7kbNyI+yvmrSEksVumrun8yI1tViy8Sp/X8fU5VG7+
         2LOjVzBPGx6Ne9t594SL79JBCUj9Lhj/2qcVPauOHU9s4CU/tqxZFIMWMmsxiAg3SbmB
         tY5VD/VpuqJykjWHbaA8HIrdU177xR13r8nnahM3EJl/SlpwINUxDYitiYBCzBLhQOZc
         3kNg==
X-Gm-Message-State: AOAM531vcvwnxX9J101yfPn+pNzP1XzXbgflfOoifc6TJ6Hdc2eVgTmb
        moBa3uo+kNd9trvjTVFd1f1nTrqRzCI=
X-Google-Smtp-Source: ABdhPJwro06a7fy1o9vIU2yt5G85sDC2JW9B7OBuo1M3uv2K+PqmmkdcOIjQbKCvJKj49N+C7LgMmw==
X-Received: by 2002:a17:90b:30d0:: with SMTP id hi16mr35759023pjb.65.1593715985169;
        Thu, 02 Jul 2020 11:53:05 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site ([2600:1700:727f::e])
        by smtp.gmail.com with ESMTPSA id i128sm9823341pfe.74.2020.07.02.11.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 11:53:04 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Cameron Berkenpas <cam@neo-zeon.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?UTF-8?q?Dani=C3=ABl=20Sonck?= <dsonck92@gmail.com>,
        Zhang Qiang <qiang.zhang@windriver.com>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Zefan Li <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Roman Gushchin <guro@fb.com>
Subject: [Patch net v2] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
Date:   Thu,  2 Jul 2020 11:52:56 -0700
Message-Id: <20200702185256.17917-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we clone a socket in sk_clone_lock(), its sk_cgrp_data is
copied, so the cgroup refcnt must be taken too. And, unlike the
sk_alloc() path, sock_update_netprioidx() is not called here.
Therefore, it is safe and necessary to grab the cgroup refcnt
even when cgroup_sk_alloc is disabled.

sk_clone_lock() is in BH context anyway, the in_interrupt()
would terminate this function if called there. And for sk_alloc()
skcd->val is always zero. So it's safe to factor out the code
to make it more readable.

The global variable 'cgroup_sk_alloc_disabled' is used to determine
whether to take these reference counts. It is impossible to make
the reference counting correct unless we save this bit of information
in skcd->val. So, add a new bit there to record whether the socket
has already taken the reference counts. This obviously relies on
kmalloc() to align cgroup pointers to at least 4 bytes,
ARCH_KMALLOC_MINALIGN is certainly larger than that.

This bug seems to be introduced since the beginning, commit
d979a39d7242 ("cgroup: duplicate cgroup reference when cloning sockets")
tried to fix it but not compeletely. It seems not easy to trigger until
the recent commit 090e28b229af
("netprio_cgroup: Fix unlimited memory leak of v2 cgroups") was merged.

Fixes: bd1060a1d671 ("sock, cgroup: add sock->sk_cgroup")
Reported-by: Cameron Berkenpas <cam@neo-zeon.de>
Reported-by: Peter Geis <pgwipeout@gmail.com>
Reported-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Reported-by: Daniël Sonck <dsonck92@gmail.com>
Reported-by: Zhang Qiang <qiang.zhang@windriver.com>
Tested-by: Cameron Berkenpas <cam@neo-zeon.de>
Tested-by: Peter Geis <pgwipeout@gmail.com>
Tested-by: Thomas Lamprecht <t.lamprecht@proxmox.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Zefan Li <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 include/linux/cgroup-defs.h |  6 ++++--
 include/linux/cgroup.h      |  4 +++-
 kernel/cgroup/cgroup.c      | 31 +++++++++++++++++++------------
 net/core/sock.c             |  2 +-
 4 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 52661155f85f..4f1cd0edc57d 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -790,7 +790,8 @@ struct sock_cgroup_data {
 	union {
 #ifdef __LITTLE_ENDIAN
 		struct {
-			u8	is_data;
+			u8	is_data : 1;
+			u8	no_refcnt : 1;
 			u8	padding;
 			u16	prioidx;
 			u32	classid;
@@ -800,7 +801,8 @@ struct sock_cgroup_data {
 			u32	classid;
 			u16	prioidx;
 			u8	padding;
-			u8	is_data;
+			u8	no_refcnt : 1;
+			u8	is_data : 1;
 		} __packed;
 #endif
 		u64		val;
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 4598e4da6b1b..618838c48313 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -822,6 +822,7 @@ extern spinlock_t cgroup_sk_update_lock;
 
 void cgroup_sk_alloc_disable(void);
 void cgroup_sk_alloc(struct sock_cgroup_data *skcd);
+void cgroup_sk_clone(struct sock_cgroup_data *skcd);
 void cgroup_sk_free(struct sock_cgroup_data *skcd);
 
 static inline struct cgroup *sock_cgroup_ptr(struct sock_cgroup_data *skcd)
@@ -835,7 +836,7 @@ static inline struct cgroup *sock_cgroup_ptr(struct sock_cgroup_data *skcd)
 	 */
 	v = READ_ONCE(skcd->val);
 
-	if (v & 1)
+	if (v & 3)
 		return &cgrp_dfl_root.cgrp;
 
 	return (struct cgroup *)(unsigned long)v ?: &cgrp_dfl_root.cgrp;
@@ -847,6 +848,7 @@ static inline struct cgroup *sock_cgroup_ptr(struct sock_cgroup_data *skcd)
 #else	/* CONFIG_CGROUP_DATA */
 
 static inline void cgroup_sk_alloc(struct sock_cgroup_data *skcd) {}
+static inline void cgroup_sk_clone(struct sock_cgroup_data *skcd) {}
 static inline void cgroup_sk_free(struct sock_cgroup_data *skcd) {}
 
 #endif	/* CONFIG_CGROUP_DATA */
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 1ea181a58465..dd247747ec14 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6439,18 +6439,8 @@ void cgroup_sk_alloc_disable(void)
 
 void cgroup_sk_alloc(struct sock_cgroup_data *skcd)
 {
-	if (cgroup_sk_alloc_disabled)
-		return;
-
-	/* Socket clone path */
-	if (skcd->val) {
-		/*
-		 * We might be cloning a socket which is left in an empty
-		 * cgroup and the cgroup might have already been rmdir'd.
-		 * Don't use cgroup_get_live().
-		 */
-		cgroup_get(sock_cgroup_ptr(skcd));
-		cgroup_bpf_get(sock_cgroup_ptr(skcd));
+	if (cgroup_sk_alloc_disabled) {
+		skcd->no_refcnt = 1;
 		return;
 	}
 
@@ -6475,10 +6465,27 @@ void cgroup_sk_alloc(struct sock_cgroup_data *skcd)
 	rcu_read_unlock();
 }
 
+void cgroup_sk_clone(struct sock_cgroup_data *skcd)
+{
+	if (skcd->val) {
+		if (skcd->no_refcnt)
+			return;
+		/*
+		 * We might be cloning a socket which is left in an empty
+		 * cgroup and the cgroup might have already been rmdir'd.
+		 * Don't use cgroup_get_live().
+		 */
+		cgroup_get(sock_cgroup_ptr(skcd));
+		cgroup_bpf_get(sock_cgroup_ptr(skcd));
+	}
+}
+
 void cgroup_sk_free(struct sock_cgroup_data *skcd)
 {
 	struct cgroup *cgrp = sock_cgroup_ptr(skcd);
 
+	if (skcd->no_refcnt)
+		return;
 	cgroup_bpf_put(cgrp);
 	cgroup_put(cgrp);
 }
diff --git a/net/core/sock.c b/net/core/sock.c
index d832c650287c..2e5b7870e5d3 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1926,7 +1926,7 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 		/* sk->sk_memcg will be populated at accept() time */
 		newsk->sk_memcg = NULL;
 
-		cgroup_sk_alloc(&newsk->sk_cgrp_data);
+		cgroup_sk_clone(&newsk->sk_cgrp_data);
 
 		rcu_read_lock();
 		filter = rcu_dereference(sk->sk_filter);
-- 
2.27.0

