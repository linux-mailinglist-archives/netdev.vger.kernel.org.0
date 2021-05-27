Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89FA439242E
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 03:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234485AbhE0BOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 21:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234216AbhE0BNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 21:13:49 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCF0C061760;
        Wed, 26 May 2021 18:12:15 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d20so1495471pls.13;
        Wed, 26 May 2021 18:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zc+SAKDfiUE8ujVoPqGDWH3VJtOwCIGiCCnmCpsCpfc=;
        b=S+R/4ft70zd4wBuAiO1dzxXtuUspKkBd8P7IRZDU7hZ0XsrCWWqS+0FipF6GZc8Yj7
         qb/Hxf48L/fvnC0nmlu0CCCgMuAroVSaOTPpfocJHsfK2utJsWtcLpIY5wPD9bBPHfEp
         1/5aCZx4L2KyKrzTGht1bq1K68TzHhn0tKzcy8fMgZmEIzOp0/XlA47Ez8+qNgEqb7ie
         ldP3/ljQ51UVbEKNX+riVAI0f4TPh47ZnksS+S1BWbEFwy8jpNlr6sV85EUos3UqF0g1
         K+mtkTSIciXfknURsiaSz7GmZIsadqCvvvoinY2UjKnKx5K8tFTnZuYYzR0nMT0lWGJc
         Xukw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zc+SAKDfiUE8ujVoPqGDWH3VJtOwCIGiCCnmCpsCpfc=;
        b=dRnfxc0bguwNCl/d8zkQWj1x/8U338b0DK7kbtKb2nFaANkZY2sydjyFO8NYywhCDq
         3vcwzXfXRPzS09zktPzOK0Y+w9aVjeLLQFC4hhNVrGq1FP0ftt65Qt0DinANsk502f31
         GMpevkhiHYAr3MjLB5+PGvt3yoRBQIA0TY8oMp29pTq6wRrbx8ItbmOpbfwY/vk1jysb
         2BURa4QsNQtBZqgToqKj/hl19zEU+KGMvOa7yeJYX6EQeqSbvgqNYnFRWDkcx+X4bBLT
         Rs4bznpf3UWD8j4n2SP8PCAESVHf3RTEZoQGHyoxToQ6/rwDfJUdl5vxEv6L1Idqxfrq
         CGoQ==
X-Gm-Message-State: AOAM531FQWi4pIZ9ZziKwWHxU9kdWDnnvmrgLlvJCrdmUkW519sFTC0v
        pQKcELIoO+inAJr91ectLaGFmjsMB1VN6Q==
X-Google-Smtp-Source: ABdhPJw6sS7kZPq+asZ31q+X1TFfeOa4408F2ZM1AN/+Fkgkxyz0DtwM0jRItc2KDfM8FjRq2PTsBQ==
X-Received: by 2002:a17:902:7787:b029:f0:a7c0:f9e5 with SMTP id o7-20020a1709027787b02900f0a7c0f9e5mr873540pll.5.1622077935307;
        Wed, 26 May 2021 18:12:15 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:991:63cd:5e03:9e3a])
        by smtp.gmail.com with ESMTPSA id n21sm360282pfu.99.2021.05.26.18.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 18:12:15 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf v3 6/8] skmsg: teach sk_psock_verdict_apply() to return errors
Date:   Wed, 26 May 2021 18:11:53 -0700
Message-Id: <20210527011155.10097-7-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210527011155.10097-1-xiyou.wangcong@gmail.com>
References: <20210527011155.10097-1-xiyou.wangcong@gmail.com>
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
index 5464477e2d3d..e3d210811db4 100644
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
@@ -845,19 +845,20 @@ static void sk_psock_skb_redirect(struct sk_buff *skb)
 	if (!psock_other || sock_flag(sk_other, SOCK_DEAD)) {
 		skb_bpf_redirect_clear(skb);
 		kfree_skb(skb);
-		return;
+		return -EIO;
 	}
 	spin_lock_bh(&psock_other->ingress_lock);
 	if (!sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
 		spin_unlock_bh(&psock_other->ingress_lock);
 		skb_bpf_redirect_clear(skb);
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
@@ -894,14 +895,15 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
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
@@ -934,13 +936,15 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
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
@@ -1107,7 +1111,8 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
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

