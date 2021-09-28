Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5BA141A426
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 02:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238331AbhI1AYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 20:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238285AbhI1AYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 20:24:09 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1F1C061604;
        Mon, 27 Sep 2021 17:22:30 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id m26so6884606qtn.1;
        Mon, 27 Sep 2021 17:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7aHTllO+4GQE/ab4vnYXQ8VX+caQ6dzLbRRdC+Fk314=;
        b=oeu9Hi6PJUL4H0ZM5p1Sg97SUS0BAUzawkPj0QPTiHNXX22hw5LOa2ZnE0PBIk0typ
         Ak4NLhYN/ws9A5O+gpN9bhysJGab+4TAJw+V3KGttkAmkF3DxbMtIgRARTy4CufyEMHu
         1eZ3NBgHaoQQvUZK3dZqspK/uzcB2eply7KGdpfKYjyMdf2aVb3xmYYDYGrR7No77ZQF
         PqG/UfMfku7UHGB/dAHV1Zyv+o3zWq5h6tGLHFmuPQ2sDEbFcznE8MMKydivJQTIW8vT
         2AB1yq3wGf7OyRV0xiXVs3D8hVg3h8mPqJIdxg5ujOZFQfD2nKtElJikaQAC5uL3YGpZ
         z7ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7aHTllO+4GQE/ab4vnYXQ8VX+caQ6dzLbRRdC+Fk314=;
        b=mS0tc8s+45YBvO7J2MizRYrISjrqUbRaanXvZqnySNkXd8oawcEJqQJ3youkxCJZg6
         xmQp163r5ofHoOEiRlt5MWF+KudX5a5Wv0+Mi0K6Z1ILIe9e2UR53X55jS7zlgzeJj3Q
         AUPYhWvpX/28xnxdNt2cHvf/FhQudyDggkVSLBKKaCeBcftk5xtnq/1DdFhqSdh18gJ7
         luHPmyDqGy4SJOEqSP9TQwIVmA+lt5O6wFdNczHnzvGkpR2r5Xu98+C2kMm2JM0KynPq
         ToGjV+5Ax6Y99UhVfrdhHY+gdyu0+xXC1buskbPUvk/EBx+wCrPlJEFVtmI+hLLQcLOm
         h/sw==
X-Gm-Message-State: AOAM532I+gneHKN5dCuEIsfSv2ebSCA9M1XYeJ/GlhUH4QIe3PzAFKSQ
        OsuaKRLKKBjQOFtFVA7YW2mUz0bcX3o=
X-Google-Smtp-Source: ABdhPJzXLTYasYaUjU2yknE6Sz7sPnUnglDNB/P+jMp5FxnQtubwVV+IQnU81rwFnBZ4RwNeI2MR5A==
X-Received: by 2002:ac8:490c:: with SMTP id e12mr2922058qtq.200.1632788549451;
        Mon, 27 Sep 2021 17:22:29 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1ce2:35c5:917e:20d7])
        by smtp.gmail.com with ESMTPSA id 31sm5672308qtb.85.2021.09.27.17.22.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 17:22:29 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf v2 1/4] skmsg: introduce sk_psock_get_checked()
Date:   Mon, 27 Sep 2021 17:22:09 -0700
Message-Id: <20210928002212.14498-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210928002212.14498-1-xiyou.wangcong@gmail.com>
References: <20210928002212.14498-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Although we have sk_psock_get(), it assumes the psock
retrieved from sk_user_data is for sockmap, this is not
sufficient if we call it outside of sockmap, for example,
reuseport_array.

Fortunately sock_map_psock_get_checked() is more strict
and checks for sock_map_close before using psock. So we can
refactor it and rename it to sk_psock_get_checked(), which
can be safely called outside of sockmap.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h | 20 ++++++++++++++++++++
 net/core/sock_map.c   | 22 +---------------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 14ab0c0bc924..8f577739fc36 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -452,6 +452,26 @@ static inline struct sk_psock *sk_psock_get(struct sock *sk)
 	return psock;
 }
 
+static inline struct sk_psock *sk_psock_get_checked(struct sock *sk)
+{
+	struct sk_psock *psock;
+
+	rcu_read_lock();
+	psock = sk_psock(sk);
+	if (psock) {
+#if defined(CONFIG_BPF_SYSCALL)
+		if (sk->sk_prot->close != sock_map_close) {
+			rcu_read_unlock();
+			return ERR_PTR(-EBUSY);
+		}
+#endif
+		if (!refcount_inc_not_zero(&psock->refcnt))
+			psock = ERR_PTR(-EBUSY);
+	}
+	rcu_read_unlock();
+	return psock;
+}
+
 void sk_psock_drop(struct sock *sk, struct sk_psock *psock);
 
 static inline void sk_psock_put(struct sock *sk, struct sk_psock *psock)
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index e252b8ec2b85..6612bb0b95b5 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -191,26 +191,6 @@ static int sock_map_init_proto(struct sock *sk, struct sk_psock *psock)
 	return sk->sk_prot->psock_update_sk_prot(sk, psock, false);
 }
 
-static struct sk_psock *sock_map_psock_get_checked(struct sock *sk)
-{
-	struct sk_psock *psock;
-
-	rcu_read_lock();
-	psock = sk_psock(sk);
-	if (psock) {
-		if (sk->sk_prot->close != sock_map_close) {
-			psock = ERR_PTR(-EBUSY);
-			goto out;
-		}
-
-		if (!refcount_inc_not_zero(&psock->refcnt))
-			psock = ERR_PTR(-EBUSY);
-	}
-out:
-	rcu_read_unlock();
-	return psock;
-}
-
 static int sock_map_link(struct bpf_map *map, struct sock *sk)
 {
 	struct sk_psock_progs *progs = sock_map_progs(map);
@@ -255,7 +235,7 @@ static int sock_map_link(struct bpf_map *map, struct sock *sk)
 		}
 	}
 
-	psock = sock_map_psock_get_checked(sk);
+	psock = sk_psock_get_checked(sk);
 	if (IS_ERR(psock)) {
 		ret = PTR_ERR(psock);
 		goto out_progs;
-- 
2.30.2

