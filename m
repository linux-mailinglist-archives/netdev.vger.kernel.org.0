Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1169338D730
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 21:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbhEVTQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 15:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbhEVTP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 15:15:59 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A7FC061574;
        Sat, 22 May 2021 12:14:33 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q15so16947076pgg.12;
        Sat, 22 May 2021 12:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0ExFCYsih7s7PdTmahlL0A+vWzuU6an/DuLev5Jw+4s=;
        b=JHYJx1UnCo418NP9GOf2tZxcIdzrw9W+qB4UwJr1SzVChrov3WK8VPknOuxwdHMRXi
         cBKEXhAXU/dMJIYlOZrDZGFCZZmbvlxsA995qq/QrEVc9AKsDXmIDh2Efpq6GVkPBDVV
         rmwBBnS8+15VDwdZ3OzAZj8bJgYQ3EsLF54DzAv1FSOuFaERdMi4gvwmi3eqK35GM5EZ
         3qq2RHrjQXPueLBb9U3RiFrkJlWNSbzClQGq/SVKbbPupZs5KykXx3Vg+T1cBF39EdFN
         WBq+4N19rYMK4IcON1qvV0upvZTUbLl8naf1ROqvO8ou1kOQkPnm8mav7oXquvFFO0XH
         Ov8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0ExFCYsih7s7PdTmahlL0A+vWzuU6an/DuLev5Jw+4s=;
        b=X2jHqC1yBaUbrYuK4KD7GP9ifphF4mZwvPDh3emkk7KR0t6nhdlQzKS8L95WJPmJBi
         uXL+Lk/8FwQwODjMe+otP72Vutb5r8b1acVu797FV76nhMPLthDXjYgLHjbTm3EOOTIq
         t0BpYJQ88QdG+/fZybUiu/0uLkllH41B1Q0M6C4qyz6qNWhxFNyzjUKgPzRPifeP6oBp
         rddkiDhrZP/hRQqP3aStglXhSYk4E+Pa8oZZV6PU5cLJireZhWd1535EimDV1h2fxYDg
         i9DxINwYy4T/cS2LPqnqYMCjn1Cg3xTVDdhPRM9DdN6fNeGyGk8lhRWSt/7xoVzpUEPk
         9LSw==
X-Gm-Message-State: AOAM533n+FxoNZvfn5vNDtP1YQNrKJ9uFVv8MB10pZrCAkgYvbCKjCmU
        HBUmzFxckLyyBx5myEXrC0OmEKUxg71EJA==
X-Google-Smtp-Source: ABdhPJzXQN+BbgDhpFggMreFL5FXJsZeEWMse6jtHlb72dNa33jcpKkbVyEj1e00P2yGPAiajYZ2Bw==
X-Received: by 2002:a65:50c5:: with SMTP id s5mr5429636pgp.138.1621710872920;
        Sat, 22 May 2021 12:14:32 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:14cd:343f:4e27:51d7])
        by smtp.gmail.com with ESMTPSA id 5sm6677531pfe.32.2021.05.22.12.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 May 2021 12:14:32 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf v2 7/7] skmsg: increase sk->sk_drops when dropping packets
Date:   Sat, 22 May 2021 12:14:11 -0700
Message-Id: <20210522191411.21446-8-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210522191411.21446-1-xiyou.wangcong@gmail.com>
References: <20210522191411.21446-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

It is hard to observe packet drops without increase relevant
drop counters, here we should increase sk->sk_drops which is
a protocol-independent counter. Fortunately psock is always
assocaited with a struct sock, we can just use psock->sk.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/skmsg.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 7b2c25038a48..de3af8152d07 100644
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
@@ -625,7 +631,7 @@ static void sk_psock_backlog(struct work_struct *work)
 		} while (len);
 
 		if (!ingress)
-			kfree_skb(skb);
+			sock_drop(psock->sk, skb);
 	}
 end:
 	mutex_unlock(&psock->work_mutex);
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
@@ -843,13 +849,13 @@ static int sk_psock_skb_redirect(struct sk_psock *from, struct sk_buff *skb)
 	 * a socket that is in this state so we drop the skb.
 	 */
 	if (!psock_other || sock_flag(sk_other, SOCK_DEAD)) {
-		kfree_skb(skb);
+		sock_drop(from->sk, skb);
 		return -EIO;
 	}
 	spin_lock_bh(&psock_other->ingress_lock);
 	if (!sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
 		spin_unlock_bh(&psock_other->ingress_lock);
-		kfree_skb(skb);
+		sock_drop(from->sk, skb);
 		return -EIO;
 	}
 
@@ -938,7 +944,7 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 	case __SK_DROP:
 	default:
 out_free:
-		kfree_skb(skb);
+		sock_drop(psock->sk, skb);
 	}
 
 	return err;
@@ -973,7 +979,7 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 	sk = strp->sk;
 	psock = sk_psock(sk);
 	if (unlikely(!psock)) {
-		kfree_skb(skb);
+		sock_drop(sk, skb);
 		goto out;
 	}
 	prog = READ_ONCE(psock->progs.stream_verdict);
@@ -1094,7 +1100,7 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
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

