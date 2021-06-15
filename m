Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C3F3A73A7
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 04:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbhFOCZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 22:25:29 -0400
Received: from mail-io1-f45.google.com ([209.85.166.45]:33712 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbhFOCZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 22:25:26 -0400
Received: by mail-io1-f45.google.com with SMTP id a6so41817328ioe.0;
        Mon, 14 Jun 2021 19:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zc+SAKDfiUE8ujVoPqGDWH3VJtOwCIGiCCnmCpsCpfc=;
        b=dVGM0bDLhrQqlEsU0Vvq9ZU/am7mJjIhmwt7cKtV2gs/gkIlIbZfMe1BgggrQSwwyR
         cE76D0xZhOE3YCRSFt+PXVDAPaY7sOh20pb4dKyablg3H4cBrQz10OwdaQjsdz4cKIws
         vCWekgqeeLvTNZUfkPZGfegCUAXLq6MQRXMOh2uRWhl5FeOwSiKR9CmjjoyidLQ55dEz
         Go0wpWC1f9uNyTV5NphlQrl8o1k/8C7qBesA8e7n7aINCMLe8JKdCSUMl1JmPkDO6U0q
         YsE5NavHTHmnVVM1svQV7grqPrcuZ2lIiB0qy3JsyLKFe3Q6XcG68SxxHXY9ly9II28r
         bLVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zc+SAKDfiUE8ujVoPqGDWH3VJtOwCIGiCCnmCpsCpfc=;
        b=SiSlKsXK4j40ed8jaFtIQ7eMO6qKIItG6Q+alpxESUEN15VVc5scVqJrKJYUugitDt
         Z+gH3tzwx9NBtzBopuGuBxVrzlw64OXNOdJ6B5qqN5AzkkjZ5gN4U/0/oQIEshfDkXCK
         1LLVclEiL6SFHsd8wdcPOxY+r3FNEqgShm3N13oyGjhgPzIGP8AwoJbwt+paNxYayHsp
         38Tsd6hantlQKb9l3Egz8iKkcyH9cDZ0Uq2ZTmtsQjnUGS0i2zYd8m4Y8prqWdcPak/g
         SIR8asTx9nPDnLr7hw1BpiwBydTYRTBtjOW8I2AX8P3lJOxYQ1CanWP57vfJ7SvRYsLX
         ZBQA==
X-Gm-Message-State: AOAM531bRwApUwFZL+2rT2EvtvMzYQ7zvKtDhFW9uNNrS0O3sG/Cu/D8
        K074FRqldYb/TZZ8BkU3GyFyWMHmOO97hA==
X-Google-Smtp-Source: ABdhPJyVA3km6pZC37OohV8kORsf3gk+TV/KSkokzOsVl14JwD9Hvl1v8PZFvZPI9T1IuwzjSWGjKg==
X-Received: by 2002:a37:468b:: with SMTP id t133mr3001938qka.244.1623723242905;
        Mon, 14 Jun 2021 19:14:02 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:e9a1:5f1d:df88:4f3c])
        by smtp.gmail.com with ESMTPSA id t15sm10774497qtr.35.2021.06.14.19.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 19:14:02 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH RESEND bpf v3 6/8] skmsg: teach sk_psock_verdict_apply() to return errors
Date:   Mon, 14 Jun 2021 19:13:40 -0700
Message-Id: <20210615021342.7416-7-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210615021342.7416-1-xiyou.wangcong@gmail.com>
References: <20210615021342.7416-1-xiyou.wangcong@gmail.com>
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

