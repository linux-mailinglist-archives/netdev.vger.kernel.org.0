Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438C0345403
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 01:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbhCWAjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 20:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbhCWAi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 20:38:27 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C63C061756;
        Mon, 22 Mar 2021 17:38:24 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id dc12so8755971qvb.4;
        Mon, 22 Mar 2021 17:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xTEo6ohvKEl4pyLEeJ/PD6TxOMrhoqIZ3qvxpT6J8wU=;
        b=pHUoaoL5k6QdcZ84NSRgU8WiOMvK6XeHaGMOkUlAcQn0GYu8Tck5UPrBdDPdJRUmHP
         TX0VWFnzKVUkNE0ji/4WvkFS+cLD25LehANrX3YljWs9D8r0ZDzCIpJWk4GZ7RNisDp4
         gbOo/m9bnfJICGYBeA7wd06RlsiIg3qZ3DOQYCjyCPRd1QuG/rRlKyz9WBKnFD1HPgCv
         O4vk9H7eD8IGOjQ81eunkh1OvFgNdu3fiLvnrmtnuq5mxKLfZAE6hVOql5FZcHon9OA5
         9a4+u1Ld0bPM6njqjodhxrjrhOwe0mdAWT7oUvcEl9JT8Kz5x0GW9mBooiJ4yXChl6Xf
         ay5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xTEo6ohvKEl4pyLEeJ/PD6TxOMrhoqIZ3qvxpT6J8wU=;
        b=KMAHrTPv+NC3EL3Ko4rnPbUVunv9JkGTSH2IRVpbf/L6hG0zX6OZPHjlzMCe8Ur6QH
         O1hNVSm7M0PFgGn+Xp3JRkDlqRjrCLC0wlTXevsvZZb6Hfgj9kew/9W/us8riuoMy3Ua
         HRcsfq2743EJ1QpdNaqhR/gcKVe9pXZF7GrR+L/28Oihvub+vQ9WQIGAL4Bu+TMgtLEr
         tmWqvAAd3V0FFf2Cvpt1vCITcQhohuIkupV1U3F3o0DmlNghIcpEz/BfpvBZDdCo/beN
         UQ0xf9tE9Pk0tWMa3s4uH2Q9Y1ecQlHXuKgBpbQYXu3ugdu6i7AY5HNdNYvRfgV0WPL0
         uUxQ==
X-Gm-Message-State: AOAM532VKvuCsOhwja/bBlEIoo4twMAEFXmM0VDnUHw77m0BmOJVA6mA
        09d6s8uLRphVpofgEkx1Umrdq8axn1LvEg==
X-Google-Smtp-Source: ABdhPJxSgO3k2FjoYu9IiX3zjTbLHao4zMTHYrH/UDkl5kZehrq4HVxgI1WIFE3iMj4cxb23Y1X2Ug==
X-Received: by 2002:ad4:4ae9:: with SMTP id cp9mr2351336qvb.20.1616459903486;
        Mon, 22 Mar 2021 17:38:23 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:fda6:6522:f108:7bd8])
        by smtp.gmail.com with ESMTPSA id 184sm12356403qki.97.2021.03.22.17.38.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 17:38:23 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v6 05/12] skmsg: use rcu work for destroying psock
Date:   Mon, 22 Mar 2021 17:38:01 -0700
Message-Id: <20210323003808.16074-6-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210323003808.16074-1-xiyou.wangcong@gmail.com>
References: <20210323003808.16074-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

The RCU callback sk_psock_destroy() only queues work psock->gc,
so we can just switch to rcu work to simplify the code.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h |  5 +----
 net/core/skmsg.c      | 17 +++++------------
 2 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index cf23e6e2cf54..d75c3936ab91 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -101,10 +101,7 @@ struct sk_psock {
 	struct proto			*sk_proto;
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
index 9176add87643..a9ee26aebfbd 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -662,10 +662,10 @@ void sk_psock_stop(struct sk_psock *psock, bool wait)
 
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
@@ -683,14 +683,6 @@ static void sk_psock_destroy_deferred(struct work_struct *gc)
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
@@ -704,7 +696,8 @@ void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 		sk_psock_stop_verdict(sk, psock);
 	write_unlock_bh(&sk->sk_callback_lock);
 
-	call_rcu(&psock->rcu, sk_psock_destroy);
+	INIT_RCU_WORK(&psock->rwork, sk_psock_destroy);
+	queue_rcu_work(system_wq, &psock->rwork);
 }
 EXPORT_SYMBOL_GPL(sk_psock_drop);
 
-- 
2.25.1

