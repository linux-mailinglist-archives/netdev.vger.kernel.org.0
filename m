Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CA31FBD82
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 20:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731370AbgFPSEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 14:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbgFPSEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 14:04:04 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B54BC061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 11:04:04 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id n9so8739948plk.1
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 11:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sE5tk4DyHC1wtZTWO9Af7YqdSvi/8ycJjxBdwheg7pc=;
        b=rNPlUMPgfUuA90ot1COk9fVbtUbo3x3X/V+fQiAk63DdeyTXDJB7sHxYEG9O/1kNaT
         WmiFMW15hbF+enicMKjyx582iUWLE+nEBoEao4LKz2c1X62exxI7AvaBeq1vdzzOmXj7
         kudXPS8mDFWymT05Mkmcpr+DkiM+hpwf1Jn6ZV/fHqNcQ1B09F04dOw+wdiCMv2AApKk
         UPPa1aZTGzD4hd19V/OHVxbhBnLnzBPaFtnDydztY/WuO8S4I5E3jBl9gKUptrEKMtvY
         UkPisyruCSxxgKJUmm40gl4MDoBfLrsllrUKxrQm1bRKOmmX+pwLxDsWZGtw827R3HKh
         /E3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sE5tk4DyHC1wtZTWO9Af7YqdSvi/8ycJjxBdwheg7pc=;
        b=pGXCBflLzbTTDzjtR3nxMZrWnpxbM0cGLBPyiJlOvGs31NYIX1JTmfrCXiAPKwPIj0
         hWErBh+Vc+W1cCbQ1ezKDLyDmjq4u+kcjwgfitJ+VnXj0icK4ows4DJjeeqRIdNm/jrC
         Woy5xaFnwLiOmi7S0uMNm76uVusVDNPdKujhigPH/7FvSq+OJY4SdJwLNkJRVo78KHhD
         dyiy0Adv8ktxnlp5xy9HRKJQZJi6gIkoo2EQMmEJg+wgF2bf/0YD0jn9OijwVahNvGWO
         YUGhSnY1CktH19/I9xhXjDoksvTT2oxQMUfa7EbkF1wTl/JqNGRFTXQ3Mnwn1gpqVbKu
         CpYA==
X-Gm-Message-State: AOAM531t/inUMzHpq+EZeaAnxESEoMjM0RoviM2YRPLsW7NOVCqBD883
        KT9iLknUGqR+ImbIKWlG8oEvDiuu
X-Google-Smtp-Source: ABdhPJy6AOJFAAaCDO5QtqEROLI/XqQWwO62Sn6NUUyUxbvmdDIJBUvjA74Rgq/6v05z5O//JnHqiQ==
X-Received: by 2002:a17:90a:8083:: with SMTP id c3mr4169569pjn.83.1592330643601;
        Tue, 16 Jun 2020 11:04:03 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site (99-174-169-255.lightspeed.sntcca.sbcglobal.net. [99.174.169.255])
        by smtp.gmail.com with ESMTPSA id mw5sm3605888pjb.27.2020.06.16.11.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 11:04:03 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Cameron Berkenpas <cam@neo-zeon.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?UTF-8?q?Dani=C3=ABl=20Sonck?= <dsonck92@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Zefan Li <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>
Subject: [Patch net] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
Date:   Tue, 16 Jun 2020 11:03:52 -0700
Message-Id: <20200616180352.18602-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.26.2
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

Fixes: 090e28b229af92dc5b ("netprio_cgroup: Fix unlimited memory leak of v2 cgroups")
Reported-by: Cameron Berkenpas <cam@neo-zeon.de>
Reported-by: Peter Geis <pgwipeout@gmail.com>
Reported-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Reported-by: Daniël Sonck <dsonck92@gmail.com>
Tested-by: Cameron Berkenpas <cam@neo-zeon.de>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Zefan Li <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 include/linux/cgroup.h |  2 ++
 kernel/cgroup/cgroup.c | 26 ++++++++++++++------------
 net/core/sock.c        |  2 +-
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 4598e4da6b1b..818dc7b3ed6c 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -822,6 +822,7 @@ extern spinlock_t cgroup_sk_update_lock;
 
 void cgroup_sk_alloc_disable(void);
 void cgroup_sk_alloc(struct sock_cgroup_data *skcd);
+void cgroup_sk_clone(struct sock_cgroup_data *skcd);
 void cgroup_sk_free(struct sock_cgroup_data *skcd);
 
 static inline struct cgroup *sock_cgroup_ptr(struct sock_cgroup_data *skcd)
@@ -847,6 +848,7 @@ static inline struct cgroup *sock_cgroup_ptr(struct sock_cgroup_data *skcd)
 #else	/* CONFIG_CGROUP_DATA */
 
 static inline void cgroup_sk_alloc(struct sock_cgroup_data *skcd) {}
+static inline void cgroup_sk_clone(struct sock_cgroup_data *skcd) {}
 static inline void cgroup_sk_free(struct sock_cgroup_data *skcd) {}
 
 #endif	/* CONFIG_CGROUP_DATA */
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 1ea181a58465..6377045b7096 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6442,18 +6442,6 @@ void cgroup_sk_alloc(struct sock_cgroup_data *skcd)
 	if (cgroup_sk_alloc_disabled)
 		return;
 
-	/* Socket clone path */
-	if (skcd->val) {
-		/*
-		 * We might be cloning a socket which is left in an empty
-		 * cgroup and the cgroup might have already been rmdir'd.
-		 * Don't use cgroup_get_live().
-		 */
-		cgroup_get(sock_cgroup_ptr(skcd));
-		cgroup_bpf_get(sock_cgroup_ptr(skcd));
-		return;
-	}
-
 	/* Don't associate the sock with unrelated interrupted task's cgroup. */
 	if (in_interrupt())
 		return;
@@ -6475,6 +6463,20 @@ void cgroup_sk_alloc(struct sock_cgroup_data *skcd)
 	rcu_read_unlock();
 }
 
+void cgroup_sk_clone(struct sock_cgroup_data *skcd)
+{
+	/* Socket clone path */
+	if (skcd->val) {
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
diff --git a/net/core/sock.c b/net/core/sock.c
index 6c4acf1f0220..b62f06fa5e37 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1925,7 +1925,7 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 		/* sk->sk_memcg will be populated at accept() time */
 		newsk->sk_memcg = NULL;
 
-		cgroup_sk_alloc(&newsk->sk_cgrp_data);
+		cgroup_sk_clone(&newsk->sk_cgrp_data);
 
 		rcu_read_lock();
 		filter = rcu_dereference(sk->sk_filter);
-- 
2.26.2

