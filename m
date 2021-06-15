Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCA23A742B
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 04:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhFOCnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 22:43:33 -0400
Received: from mail-qk1-f171.google.com ([209.85.222.171]:45955 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhFOCnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 22:43:31 -0400
Received: by mail-qk1-f171.google.com with SMTP id d196so35436287qkg.12;
        Mon, 14 Jun 2021 19:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kTfpOex7Ud8CUqQBaXyyvSHgbNeSLa/1/bU7Yfg6MDw=;
        b=XVHXVwtMvRvvhhwv8D1iYj02uacoltqkFTFNfKPBRR9paEqKkFk7R0o/H4rB/1V42F
         wXGC8gveqbFVaGC1XrJpjFlo+dZ+a6vCw0VdkwdpgLn+QtUiGLgcVTnm/MXi56NGVJsl
         YdTOYX8fA523G6HNQAZhoJYoVEuiigx2R0N2fZe5jKY7le7cfNlz8XyZbUqFaGq/PjHV
         O95Gdg8gFIbkLPDz1p4Q+GsgUghYQUtC7XyOAGo/K+XwLA7HUV9p6PVBDTlq7GvTb+wc
         NDMKgbeWRHlw6AJTTDTBDmTnXN8bASsfOSSt4qGbIJSTxAXbOhqIjMYbjKO6yerimIb5
         sgnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kTfpOex7Ud8CUqQBaXyyvSHgbNeSLa/1/bU7Yfg6MDw=;
        b=p+aASJ08+kqufCRoQZBBAIe50ACy3leRod1osmOWEdrs5rtY9SU6RTRZGm9oS5nUfv
         g7d6wFZ/0pe4Tm1hlQNoEFDV6/PVVnlc0k19G6VYdCvbBNMs1/eY+AHOVPKwczJtTwSk
         X1oedVrmENl2gc6bwuiUPhq9es4hKCpo7fAXbqjPfuDN4yS1S3lGx6S890pG8B1ld3tQ
         O7SF/25nfuzylkQd/PdGEzoWBDNHIf/ae9ibcQtAZrBLntioW8lUIQWQaVK8YPTfaQKJ
         D+1Sh8TJeGbhrOjRHsypSbRdzJlLmmcGp7cR2wDNhLcp5FwZfTwtPxT2cgdDzcXhyaq7
         3c8A==
X-Gm-Message-State: AOAM5320Csc0Pr4IZfA0Uo6VSr6tacwPorDMhKH7xecanktN36T+XV8U
        JVixielST3RaY8yPmoGwmsgyEQOh0yKNxQ==
X-Google-Smtp-Source: ABdhPJxXTY2/UBWsccoEt5hq6ulqNrMPrH5lgFj8sKWKolyqsAXS/v7CZPsFZwwUfXAwK08fi9n7ew==
X-Received: by 2002:a05:620a:13f0:: with SMTP id h16mr19811842qkl.32.1623723245378;
        Mon, 14 Jun 2021 19:14:05 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:e9a1:5f1d:df88:4f3c])
        by smtp.gmail.com with ESMTPSA id t15sm10774497qtr.35.2021.06.14.19.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 19:14:05 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH RESEND bpf v3 8/8] skmsg: increase sk->sk_drops when dropping packets
Date:   Mon, 14 Jun 2021 19:13:42 -0700
Message-Id: <20210615021342.7416-9-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210615021342.7416-1-xiyou.wangcong@gmail.com>
References: <20210615021342.7416-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

It is hard to observe packet drops without increasing relevant
drop counters, here we should increase sk->sk_drops which is
a protocol-independent counter. Fortunately psock is always
associated with a struct sock, we can just use psock->sk.

Suggested-by: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/skmsg.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 3aa9065811ad..9b6160a191f8 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -578,6 +578,12 @@ static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
 	return sk_psock_skb_ingress(psock, skb);
 }
 
+static void sock_drop(struct sock *sk, struct sk_buff *skb)
+{
+	sk_drops_add(sk, skb);
+	kfree_skb(skb);
+}
+
 static void sk_psock_backlog(struct work_struct *work)
 {
 	struct sk_psock *psock = container_of(work, struct sk_psock, work);
@@ -617,7 +623,7 @@ static void sk_psock_backlog(struct work_struct *work)
 				/* Hard errors break pipe and stop xmit. */
 				sk_psock_report_error(psock, ret ? -ret : EPIPE);
 				sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
-				kfree_skb(skb);
+				sock_drop(psock->sk, skb);
 				goto end;
 			}
 			off += ret;
@@ -708,7 +714,7 @@ static void __sk_psock_zap_ingress(struct sk_psock *psock)
 
 	while ((skb = skb_dequeue(&psock->ingress_skb)) != NULL) {
 		skb_bpf_redirect_clear(skb);
-		kfree_skb(skb);
+		sock_drop(psock->sk, skb);
 	}
 	__sk_psock_purge_ingress_msg(psock);
 }
@@ -834,7 +840,7 @@ static int sk_psock_skb_redirect(struct sk_psock *from, struct sk_buff *skb)
 	 * return code, but then didn't set a redirect interface.
 	 */
 	if (unlikely(!sk_other)) {
-		kfree_skb(skb);
+		sock_drop(from->sk, skb);
 		return -EIO;
 	}
 	psock_other = sk_psock(sk_other);
@@ -844,14 +850,14 @@ static int sk_psock_skb_redirect(struct sk_psock *from, struct sk_buff *skb)
 	 */
 	if (!psock_other || sock_flag(sk_other, SOCK_DEAD)) {
 		skb_bpf_redirect_clear(skb);
-		kfree_skb(skb);
+		sock_drop(from->sk, skb);
 		return -EIO;
 	}
 	spin_lock_bh(&psock_other->ingress_lock);
 	if (!sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
 		spin_unlock_bh(&psock_other->ingress_lock);
 		skb_bpf_redirect_clear(skb);
-		kfree_skb(skb);
+		sock_drop(from->sk, skb);
 		return -EIO;
 	}
 
@@ -942,7 +948,7 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 	case __SK_DROP:
 	default:
 out_free:
-		kfree_skb(skb);
+		sock_drop(psock->sk, skb);
 	}
 
 	return err;
@@ -977,7 +983,7 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 	sk = strp->sk;
 	psock = sk_psock(sk);
 	if (unlikely(!psock)) {
-		kfree_skb(skb);
+		sock_drop(sk, skb);
 		goto out;
 	}
 	prog = READ_ONCE(psock->progs.stream_verdict);
@@ -1098,7 +1104,7 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
 	psock = sk_psock(sk);
 	if (unlikely(!psock)) {
 		len = 0;
-		kfree_skb(skb);
+		sock_drop(sk, skb);
 		goto out;
 	}
 	prog = READ_ONCE(psock->progs.stream_verdict);
-- 
2.25.1

