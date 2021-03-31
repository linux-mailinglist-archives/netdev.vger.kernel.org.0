Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6F334F6C7
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 04:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbhCaCdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 22:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233405AbhCaCcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 22:32:54 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AB5C061574;
        Tue, 30 Mar 2021 19:32:53 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id q127-20020a4a33850000b02901b646aa81b1so4264062ooq.8;
        Tue, 30 Mar 2021 19:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Kfpkxqp/EUWiWSJanqZp6gALxArnEJLF0PtroKlsYNQ=;
        b=vIIamue+OQ9cGDphEwlAth5HdRXxcUlBTfO4m4I1cO9XkM4MtwR362RLkmorblIaw3
         qzl+8Un7kIi5SAfLMlBduHTlxAlNZecLmGvLxMlgGi3gdjREyJo2EN94NBzfx3LqLZJX
         a2qtcrE2aFDEdwaSa/cmNWDe8LhpiFDUNW5xdJ62l2MA1T+UkVHGWVHKG7fx5Rp38Hoh
         EfhUKdxc3BY+IgdRygvVQtflCpZT+IOI0FQ6wnqo/pUmFfqqytqUL580YeJdFsUI4hkh
         8MuMNGx0LskV8VGDvFOkWoAsIzx8zSwicZY1x5O0lUm3o6vHc29F1WtKdoqaU2MnVWvf
         CXvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Kfpkxqp/EUWiWSJanqZp6gALxArnEJLF0PtroKlsYNQ=;
        b=F7F5sBkab4MHVWkF8tVqGQe1ss2rz/qwIigNyx0MrNzOBGel0YU+uDE262AIxTX2UY
         CZcjiVz6Czpe/VNd6nnTbtDCDkCJ/D94VIKmM7ua8XKrkN84dfkTTPLCV79Yx1QKAV92
         whs2x1GQyjbuU6JmY4noZI1pdACOW4qiZMUhqvre6GpBByXHFLnZecCM3Wa9xVU+qX6V
         QsIqNe+TqYopjuSp4OfpxNgE4KZNtNsYkcOqwEKRME/8iSLIXjatJzxO4lewG3EKHgDt
         kVnnJD/MWd88P+uX6BUWxLGi+q0NtjB4mHcmc5XURcG+d4/UYVgdnSR8uAE6pUvZPoJY
         2aMQ==
X-Gm-Message-State: AOAM533QspZXaIYuEOroN+EAcoK6P4eRCVn3D2XpNmoC3qTia/8OaKWc
        YWUBJemunYYWjULCXb0OcUIoA10Lej5tNg==
X-Google-Smtp-Source: ABdhPJwxh7ZblC/BaL7L6K2MbnGsfT3ln1LiUA6GZFaDnBGnJpQDAWSD9XpiZTJQMdXG6SWbY63xkw==
X-Received: by 2002:a4a:4cd6:: with SMTP id a205mr877860oob.4.1617157973148;
        Tue, 30 Mar 2021 19:32:53 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:a099:767b:2b62:48df])
        by smtp.gmail.com with ESMTPSA id 7sm188125ois.20.2021.03.30.19.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 19:32:52 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [Patch bpf-next v8 05/16] skmsg: use rcu work for destroying psock
Date:   Tue, 30 Mar 2021 19:32:26 -0700
Message-Id: <20210331023237.41094-6-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

The RCU callback sk_psock_destroy() only queues work psock->gc,
so we can just switch to rcu work to simplify the code.

Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h |  5 +----
 net/core/skmsg.c      | 17 +++++------------
 2 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 7382c4b518d7..e7aba150539d 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -102,10 +102,7 @@ struct sk_psock {
 	struct mutex			work_mutex;
 	struct sk_psock_work_state	work_state;
 	struct work_struct		work;
-	union {
-		struct rcu_head		rcu;
-		struct work_struct	gc;
-	};
+	struct rcu_work			rwork;
 };
 
 int sk_msg_alloc(struct sock *sk, struct sk_msg *msg, int len,
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 9c25020086a9..d43d43905d2c 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -666,10 +666,10 @@ void sk_psock_stop(struct sk_psock *psock, bool wait)
 
 static void sk_psock_done_strp(struct sk_psock *psock);
 
-static void sk_psock_destroy_deferred(struct work_struct *gc)
+static void sk_psock_destroy(struct work_struct *work)
 {
-	struct sk_psock *psock = container_of(gc, struct sk_psock, gc);
-
+	struct sk_psock *psock = container_of(to_rcu_work(work),
+					      struct sk_psock, rwork);
 	/* No sk_callback_lock since already detached. */
 
 	sk_psock_done_strp(psock);
@@ -688,14 +688,6 @@ static void sk_psock_destroy_deferred(struct work_struct *gc)
 	kfree(psock);
 }
 
-static void sk_psock_destroy(struct rcu_head *rcu)
-{
-	struct sk_psock *psock = container_of(rcu, struct sk_psock, rcu);
-
-	INIT_WORK(&psock->gc, sk_psock_destroy_deferred);
-	schedule_work(&psock->gc);
-}
-
 void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 {
 	sk_psock_stop(psock, false);
@@ -709,7 +701,8 @@ void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 		sk_psock_stop_verdict(sk, psock);
 	write_unlock_bh(&sk->sk_callback_lock);
 
-	call_rcu(&psock->rcu, sk_psock_destroy);
+	INIT_RCU_WORK(&psock->rwork, sk_psock_destroy);
+	queue_rcu_work(system_wq, &psock->rwork);
 }
 EXPORT_SYMBOL_GPL(sk_psock_drop);
 
-- 
2.25.1

