Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632BA34BED4
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 22:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhC1UUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 16:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbhC1UUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 16:20:25 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE01EC061756;
        Sun, 28 Mar 2021 13:20:24 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 31-20020a9d00220000b02901b64b9b50b1so10341162ota.9;
        Sun, 28 Mar 2021 13:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Kfpkxqp/EUWiWSJanqZp6gALxArnEJLF0PtroKlsYNQ=;
        b=USuYSB8Ud8CyG4glC78Z+vIyZ61cQoUDIsc5bbm8Jsf5ylubuHmwf/Ex201RKyEkPt
         k4hc8zyA6rNU7zt/3Pygcau8fh/iJjYPf83MZbOeENhnF0ipcOZTk4nxJIYK0Am/Biz6
         R0MsoMGqs+BPomA+Hn21Z7u5NalhgPGCTlHt9Nd3W0qcIJ9HfpghnALHU+6q9umCNrtf
         rY1b/OoYtvmBQBOeuKVZR/E7FndmaciDNGSzuZJbZGDpl+CfE1GyF+G8E59OLIh/gKFs
         j3Uo/TMBSG2whdDiRx75xcOB/Y/HP0vslAX+N4JlNrPkPAoh86EANYzrd4tnGJz/wA8h
         T5ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Kfpkxqp/EUWiWSJanqZp6gALxArnEJLF0PtroKlsYNQ=;
        b=iK7ZxI7n/x5z78Vq9/GT3C0rGwEwg83wTPaj4BfVMRslRaOVbBj0O36Z2mcPd6ozr2
         7pDxeE1EbWshK7S6jpggYcYaT3pXh2Wvky9bs1YGaJG52gQU11bbqBwPuYGsAerJF3kZ
         gQNdo4vm/P1KfxseZT0QDo2CALsFs8gBRUGpFCcvC8xOqpEkmubBOSdQDl9xlYpQOtw+
         q3oXAf8y3rWisriLzXdjyGgj/kkNeuDtF1JCH+A8kxMfB/Fs5Eueu+NDylPVOA77aYy0
         0GXVItj4g0XBjbW4d7+j1MtAvB/bHe8WnwlKItJKneKhL/5wNXp3PWsK1P3aTb6yla69
         YkjQ==
X-Gm-Message-State: AOAM530Kx/xz0216/zbuIyS1lJdDoG/HULkDLRcv0PH5IBgwWuqWrNTF
        UbqniH1xO9+YlymgSGK+icQvGspi8rmdbw==
X-Google-Smtp-Source: ABdhPJzKRDMtYw4kPNlYOsTlvicjiSt9LXr88PlrSwBSKmLbf3PYMESULyMSb1EdNAd+Z//8GKlKTg==
X-Received: by 2002:a05:6830:20c8:: with SMTP id z8mr20565626otq.14.1616962824198;
        Sun, 28 Mar 2021 13:20:24 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:bca7:4b69:be8f:21bb])
        by smtp.gmail.com with ESMTPSA id v30sm3898240otb.23.2021.03.28.13.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 13:20:23 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [Patch bpf-next v7 05/13] skmsg: use rcu work for destroying psock
Date:   Sun, 28 Mar 2021 13:20:05 -0700
Message-Id: <20210328202013.29223-6-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
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

