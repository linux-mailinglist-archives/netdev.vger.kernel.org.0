Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1743438D72E
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 21:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbhEVTQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 15:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbhEVTP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 15:15:57 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB7EC061574;
        Sat, 22 May 2021 12:14:31 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id q6so12657273pjj.2;
        Sat, 22 May 2021 12:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qUzy5jKeZW77NKJ44yeMmAeQlr5TyXVRobrel27IuQw=;
        b=WdIEFLLzujUuZSeaRc6G11W+YBz9vNnRz28GGhaTIPUw2xEXBxBOEvRndIZrnBGFiC
         E4PCN1/xO7pHU8kHBZtsPSdx6lCBDqvWNSiSeYfWEdElSlB5XIYjnap+Wufx7EvJUJbs
         w8LEJCmS32BrI5Vc/uQw8Pyf8qlJgfT0HOUT+KPLQmYfFL03LcRyiw6VTVAnyoeoVD65
         ivc5q5fLEeO/B0uLFivCa8IhYtE06blZem5SM50NCMBKQnHlamWUAFv2kMlUQ/uOP7jj
         nM4f2cTBA3TGq9I/fNRjDNWff8mLQB0Icl5M14IKmEunW0rMBVN+BEiigFMRqqQbU2ee
         roIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qUzy5jKeZW77NKJ44yeMmAeQlr5TyXVRobrel27IuQw=;
        b=kxsSPx6K354wF7XCitwb40UZgzE0Pp/JUeWN/lo/fjMs0nLQVlTj5FXfT36nsEQegq
         5/yUChe54HfDks9yAlXjHkwroZPXkAFVlHd7VpOSoTwtC2HHduByCkOV8KjQOEXe/Jco
         nL/i9YueTgGqTUeZ1l/GZeXdXS5pUlKQnfniftqu553gm1m6xhbRaTUYuVLA/L2YKGe8
         rksWWKnSQ9MC6zs1EAwgBmeR1SGV+Kw+jz9Nm27nC5YWwSolp28p6XaKho557V0ktd+9
         vZSgIi1g5XEYO0TuJ57ZLZJLFFfedXzLBW6Uc6HHTxuzEli/rgUagiGNpMgnLH+xM98X
         8l7w==
X-Gm-Message-State: AOAM530r98ckaMJCUv8x5Ps1awirPQf+jvSQ7T+sstf6OpR/yqhnVp6B
        tJimN5A8nKT4MuFUTkqVjm4ntgu3gjXE5A==
X-Google-Smtp-Source: ABdhPJxLPbOLt9gT0paVc3/T3RxYK9QxmK1a/+DHV5zsS91kpbdDj0IHlndyD+0GHiw4Iq9SBocn5g==
X-Received: by 2002:a17:90a:8b8a:: with SMTP id z10mr16984010pjn.22.1621710871108;
        Sat, 22 May 2021 12:14:31 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:14cd:343f:4e27:51d7])
        by smtp.gmail.com with ESMTPSA id 5sm6677531pfe.32.2021.05.22.12.14.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 May 2021 12:14:30 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf v2 5/7] skmsg: teach sk_psock_verdict_apply() to return errors
Date:   Sat, 22 May 2021 12:14:09 -0700
Message-Id: <20210522191411.21446-6-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210522191411.21446-1-xiyou.wangcong@gmail.com>
References: <20210522191411.21446-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Currently sk_psock_verdict_apply() is void, but it handles some
error conditions too. Its caller is impossible to learn whether
it succeeds or fails, especially sk_psock_verdict_recv().

Make it return int to indicate error cases and propagate errors
to callers properly.

Fixes: ef5659280eb1 ("bpf, sockmap: Allow skipping sk_skb parser program")
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/skmsg.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index de68a3cd33f1..335fc60f5d22 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -824,7 +824,7 @@ int sk_psock_msg_verdict(struct sock *sk, struct sk_psock *psock,
 }
 EXPORT_SYMBOL_GPL(sk_psock_msg_verdict);
 
-static void sk_psock_skb_redirect(struct sk_buff *skb)
+static int sk_psock_skb_redirect(struct sk_buff *skb)
 {
 	struct sk_psock *psock_other;
 	struct sock *sk_other;
@@ -835,7 +835,7 @@ static void sk_psock_skb_redirect(struct sk_buff *skb)
 	 */
 	if (unlikely(!sk_other)) {
 		kfree_skb(skb);
-		return;
+		return -EIO;
 	}
 	psock_other = sk_psock(sk_other);
 	/* This error indicates the socket is being torn down or had another
@@ -844,18 +844,19 @@ static void sk_psock_skb_redirect(struct sk_buff *skb)
 	 */
 	if (!psock_other || sock_flag(sk_other, SOCK_DEAD)) {
 		kfree_skb(skb);
-		return;
+		return -EIO;
 	}
 	spin_lock_bh(&psock_other->ingress_lock);
 	if (!sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
 		spin_unlock_bh(&psock_other->ingress_lock);
 		kfree_skb(skb);
-		return;
+		return -EIO;
 	}
 
 	skb_queue_tail(&psock_other->ingress_skb, skb);
 	schedule_work(&psock_other->work);
 	spin_unlock_bh(&psock_other->ingress_lock);
+	return 0;
 }
 
 static void sk_psock_tls_verdict_apply(struct sk_buff *skb, struct sock *sk, int verdict)
@@ -892,14 +893,15 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(sk_psock_tls_strp_read);
 
-static void sk_psock_verdict_apply(struct sk_psock *psock,
-				   struct sk_buff *skb, int verdict)
+static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
+				  int verdict)
 {
 	struct sock *sk_other;
-	int err = -EIO;
+	int err = 0;
 
 	switch (verdict) {
 	case __SK_PASS:
+		err = -EIO;
 		sk_other = psock->sk;
 		if (sock_flag(sk_other, SOCK_DEAD) ||
 		    !sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
@@ -930,13 +932,15 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 		}
 		break;
 	case __SK_REDIRECT:
-		sk_psock_skb_redirect(skb);
+		err = sk_psock_skb_redirect(skb);
 		break;
 	case __SK_DROP:
 	default:
 out_free:
 		kfree_skb(skb);
 	}
+
+	return err;
 }
 
 static void sk_psock_write_space(struct sock *sk)
@@ -1103,7 +1107,8 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
 		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
 		skb->sk = NULL;
 	}
-	sk_psock_verdict_apply(psock, skb, ret);
+	if (sk_psock_verdict_apply(psock, skb, ret) < 0)
+		len = 0;
 out:
 	rcu_read_unlock();
 	return len;
-- 
2.25.1

