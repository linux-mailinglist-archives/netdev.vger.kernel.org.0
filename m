Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C3448D4ED
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 10:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbiAMJWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 04:22:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbiAMJWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 04:22:34 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DE5C06173F
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 01:22:33 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id m13so9922284pji.3
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 01:22:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ufHTp4TO5+xEDfXeGT0tdei/uX7auWoH306bW8y6nHs=;
        b=DJdFTRWFJNQ69LqanD+D+G65LVOe1e9Q/US4098cbL/T1Rs1PAjZP4oASOJWDdLg8W
         o9dhHwI5Q0jcgFsGwvrFC4rAzTqWEwTCYDlSXC8hafRw3uT42gXaCMfJEGrFU1Mf2CgS
         MQ2KV6my8Pf0erE8yEGN/siirc9/QS6q2kQ4w4+QGz9nLmi20gXZj0ql7iyiQO/XsITX
         MIBcHhPs5BXyzfpfUq1VU9QweDQUBcQXeYIY5U6Cb0EID7YP2pbevDgkQ7QLSdU42DwF
         LrINuZ115viMQ4oSaEbSE+h6W6l8UWkTgBX3vn1nMGlhC1lcxlpOi27wS+WOJt6RggNT
         4++Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ufHTp4TO5+xEDfXeGT0tdei/uX7auWoH306bW8y6nHs=;
        b=0AtK8B4WmvoKS2GLLnSGMtE9sy6xY2zTribEmpfIf3n6M1S97UkEBdvVFF61CUGhmm
         DX2DAfoX0Z1u/YesrshOFXubFqaX9AlzEQX/zU8n3ib8xY8h68j4zrbimolCOpT1sM+A
         MZ3EvqXDESNgiRZ5UqrbUh8k2GZrn7cCoG/gWFP6S6kJkLI8LNqFJiHTCIUr5Z+Vhnud
         IpVLBTMH3G14m6VH8XRuZSgV+j9j/1dvgOe2nNT3Q+kyxRQwgL/0iP8VKZ8gleU1iIaa
         Nr8tARr6pB7EJrYrSMJEaUmoLggIKC/xOHXMjjfDvxAiqnr7+87rc60FcG+F5NhZMKCG
         M4VQ==
X-Gm-Message-State: AOAM531P61DMCJcAC09XGhA9Bax6hT16dUT3XFTCpTMFFCX0yMFTkxLm
        iQDBwEc1zfcDpU05mqGwWU4=
X-Google-Smtp-Source: ABdhPJytwdjpDueskiDawp+5GkTKguYV2MNf0NR4PKMM6uryPFPYO/yYHCjB8SHCe9JOWPWGrUIJhA==
X-Received: by 2002:a63:5752:: with SMTP id h18mr3226352pgm.520.1642065753310;
        Thu, 13 Jan 2022 01:22:33 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:71fb:8fb9:9e73:fb22])
        by smtp.gmail.com with ESMTPSA id q2sm2366478pfu.66.2022.01.13.01.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 01:22:32 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net] inet: frags: annotate races around fqdir->dead and fqdir->high_thresh
Date:   Thu, 13 Jan 2022 01:22:29 -0800
Message-Id: <20220113092229.1231267-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Both fields can be read/written without synchronization,
add proper accessors and documentation.

Fixes: d5dd88794a13 ("inet: fix various use-after-free in defrags units")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/inet_frag.h  | 11 +++++++++--
 include/net/ipv6_frag.h  |  3 ++-
 net/ipv4/inet_fragment.c |  8 +++++---
 net/ipv4/ip_fragment.c   |  3 ++-
 4 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 48cc5795ceda6bef86178fc1db0e1d6ee1dfd46d..63540be0fc34ac0f5270dd474bec96c65a5bdcbe 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -117,8 +117,15 @@ int fqdir_init(struct fqdir **fqdirp, struct inet_frags *f, struct net *net);
 
 static inline void fqdir_pre_exit(struct fqdir *fqdir)
 {
-	fqdir->high_thresh = 0; /* prevent creation of new frags */
-	fqdir->dead = true;
+	/* Prevent creation of new frags.
+	 * Pairs with READ_ONCE() in inet_frag_find().
+	 */
+	WRITE_ONCE(fqdir->high_thresh, 0);
+
+	/* Pairs with READ_ONCE() in inet_frag_kill(), ip_expire()
+	 * and ip6frag_expire_frag_queue().
+	 */
+	WRITE_ONCE(fqdir->dead, true);
 }
 void fqdir_exit(struct fqdir *fqdir);
 
diff --git a/include/net/ipv6_frag.h b/include/net/ipv6_frag.h
index 851029ecff13cb617d41b4043f039ae59e832b82..0a4779175a5238d8989a777ef8417223b6157679 100644
--- a/include/net/ipv6_frag.h
+++ b/include/net/ipv6_frag.h
@@ -67,7 +67,8 @@ ip6frag_expire_frag_queue(struct net *net, struct frag_queue *fq)
 	struct sk_buff *head;
 
 	rcu_read_lock();
-	if (fq->q.fqdir->dead)
+	/* Paired with the WRITE_ONCE() in fqdir_pre_exit(). */
+	if (READ_ONCE(fq->q.fqdir->dead))
 		goto out_rcu_unlock;
 	spin_lock(&fq->q.lock);
 
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index 05cd198d7a6ba89ab9d12caf55108aba36c11fa0..341096807100cd65c4667031384ef59622771dac 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -235,9 +235,9 @@ void inet_frag_kill(struct inet_frag_queue *fq)
 		/* The RCU read lock provides a memory barrier
 		 * guaranteeing that if fqdir->dead is false then
 		 * the hash table destruction will not start until
-		 * after we unlock.  Paired with inet_frags_exit_net().
+		 * after we unlock.  Paired with fqdir_pre_exit().
 		 */
-		if (!fqdir->dead) {
+		if (!READ_ONCE(fqdir->dead)) {
 			rhashtable_remove_fast(&fqdir->rhashtable, &fq->node,
 					       fqdir->f->rhash_params);
 			refcount_dec(&fq->refcnt);
@@ -352,9 +352,11 @@ static struct inet_frag_queue *inet_frag_create(struct fqdir *fqdir,
 /* TODO : call from rcu_read_lock() and no longer use refcount_inc_not_zero() */
 struct inet_frag_queue *inet_frag_find(struct fqdir *fqdir, void *key)
 {
+	/* This pairs with WRITE_ONCE() in fqdir_pre_exit(). */
+	long high_thresh = READ_ONCE(fqdir->high_thresh);
 	struct inet_frag_queue *fq = NULL, *prev;
 
-	if (!fqdir->high_thresh || frag_mem_limit(fqdir) > fqdir->high_thresh)
+	if (!high_thresh || frag_mem_limit(fqdir) > high_thresh)
 		return NULL;
 
 	rcu_read_lock();
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index cfeb8890f94ee95b2246ba98beb338a33fc45d1d..fad803d2d711ef0d97f7150f0f710a35ac822946 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -144,7 +144,8 @@ static void ip_expire(struct timer_list *t)
 
 	rcu_read_lock();
 
-	if (qp->q.fqdir->dead)
+	/* Paired with WRITE_ONCE() in fqdir_pre_exit(). */
+	if (READ_ONCE(qp->q.fqdir->dead))
 		goto out_rcu_unlock;
 
 	spin_lock(&qp->q.lock);
-- 
2.34.1.575.g55b058a8bb-goog

