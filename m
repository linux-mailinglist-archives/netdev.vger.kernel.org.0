Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C334F0994
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358416AbiDCNKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358401AbiDCNKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:10:11 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E4C26AF9
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:15 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id k124-20020a1ca182000000b0038c9cf6e2a6so4117054wme.0
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m586UMPc+B3np9B42WYPK+e0b7Q4+XzQ7XMprCZx6c4=;
        b=gDyP2tsYut+gj8ph5dlR5+2PAPLSInI0FO0UXCj19rfbn0VwwxyxPAgWx7t71Ty1qg
         v14wEgNM0DP7WyUpUpvc48nZAegn2HddwCwy3SzSwrHib0rB2FNecwz3U8d1w1IXNYY/
         KH3NDkB9V9sLx5JyZZq7R/hsKm94I+XmMYf2gsXjU/CgFrA8oA2cT0174t1TTItmwmvo
         Q9+ox0TtyCPhrchjuNCVYnRcOyc5TDxDHP/Au3bmmIKr+F88WlXyLP0pJTcnget2jRh6
         qurlSOMCAjn+89nsuRW9igN88F/fc3o6eSC1euamGwKwukqdQl0nBJmsHd6oDL/3Ad7s
         HJSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m586UMPc+B3np9B42WYPK+e0b7Q4+XzQ7XMprCZx6c4=;
        b=PPtWzWBb64XvIrBFZ3VeW6yBgrUVrMak4SBvGFjwIkh+DRh78gwqIrPj+CY5Stedn5
         1MrPkVBICAfvXyzsjjQm3yj0JIGpOqGvDVNXE1I+qa0FFHw/9bbHoZcm/9VMLRnroKv6
         N2ojRVtCtmHCYKjyZM+bBxNqMCCK3o9GYfCSieYv8VSp6w88+0TqeByNiuRLBY0Jy8a8
         FOLbjZEvBkDgQwNmDZprSfBppeqOAeozPIgRA6zKT+BKrjM+GflUctOidznQdnZMkBvV
         Zv+G3Fn3sg1fukYNYx+x5EvfW+HHI2JauRtfMs2mwQpwpN6njpUMjTS0A/Um7+7ILOiu
         gE1w==
X-Gm-Message-State: AOAM532l0Jt5/7kBDABKM951+QPlKCauz1U1Vi3ycqhoDjjwQ5VSGk0v
        b95OZH/lozwByOAmefUBoGGDG9sBu8g=
X-Google-Smtp-Source: ABdhPJzQb2V2Hn4VNMmmWA7C44O1+TfB2Wtnw38HEpwIczxMJF+8SGQDeEaYwt57fMq6Nq/S3oZepA==
X-Received: by 2002:a05:600c:4ed2:b0:38c:93ad:4825 with SMTP id g18-20020a05600c4ed200b0038c93ad4825mr15554453wmq.181.1648991293951;
        Sun, 03 Apr 2022 06:08:13 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 03/27] sock: optimise sock_def_write_space barriers
Date:   Sun,  3 Apr 2022 14:06:15 +0100
Message-Id: <488b0ee4247ae055503be8c01c6a96427c226f56.1648981571.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648981570.git.asml.silence@gmail.com>
References: <cover.1648981570.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now we have a separate path for sock_def_write_space() and can go one
step further. When it's called from sock_wfree() we know that there is a
preceding atomic for putting down ->sk_wmem_alloc. We can use it to
replace to replace smb_mb() with a less expensive
smp_mb__after_atomic(). It also removes an extra RCU read lock/unlock as
a small bonus.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/sock.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 9389bb602c64..b1a8f47fda55 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -144,6 +144,7 @@
 static DEFINE_MUTEX(proto_list_mutex);
 static LIST_HEAD(proto_list);
 
+static void sock_def_write_space_wfree(struct sock *sk);
 static void sock_def_write_space(struct sock *sk);
 
 /**
@@ -2309,7 +2310,7 @@ void sock_wfree(struct sk_buff *skb)
 		    sk->sk_write_space == sock_def_write_space) {
 			rcu_read_lock();
 			free = refcount_sub_and_test(len, &sk->sk_wmem_alloc);
-			sock_def_write_space(sk);
+			sock_def_write_space_wfree(sk);
 			rcu_read_unlock();
 			if (unlikely(free))
 				__sk_free(sk);
@@ -3201,6 +3202,29 @@ static void sock_def_write_space(struct sock *sk)
 	rcu_read_unlock();
 }
 
+/* An optimised version of sock_def_write_space(), should only be called
+ * for SOCK_RCU_FREE sockets under RCU read section and after putting
+ * ->sk_wmem_alloc.
+ */
+static void sock_def_write_space_wfree(struct sock *sk)
+{
+	/* Do not wake up a writer until he can make "significant"
+	 * progress.  --DaveM
+	 */
+	if (sock_writeable(sk)) {
+		struct socket_wq *wq = rcu_dereference(sk->sk_wq);
+
+		/* rely on refcount_sub from sock_wfree() */
+		smp_mb__after_atomic();
+		if (wq && waitqueue_active(&wq->wait))
+			wake_up_interruptible_sync_poll(&wq->wait, EPOLLOUT |
+						EPOLLWRNORM | EPOLLWRBAND);
+
+		/* Should agree with poll, otherwise some programs break */
+		sk_wake_async(sk, SOCK_WAKE_SPACE, POLL_OUT);
+	}
+}
+
 static void sock_def_destruct(struct sock *sk)
 {
 }
-- 
2.35.1

