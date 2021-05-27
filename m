Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EE4392430
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 03:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234508AbhE0BOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 21:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234386AbhE0BN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 21:13:57 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85B5C06138A;
        Wed, 26 May 2021 18:12:17 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id ep16-20020a17090ae650b029015d00f578a8so1379734pjb.2;
        Wed, 26 May 2021 18:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kTfpOex7Ud8CUqQBaXyyvSHgbNeSLa/1/bU7Yfg6MDw=;
        b=l/E8E1jfripvAONH0TLh+lG5aHnEgwoD/AXUzXfkydmDEwo5o+gQ1oXqcnXzOga+O9
         2RtZZ/Yxb9sKPFpVToYavwpe7N3Omfl1WpDpH6hkO8P8j4UXEezCbPwg41mj4/UlZTaa
         DycC5HkRoOad5ABUn1u37VUjiBPSc2kJLWjaIqIhilfvRdo2EMor8BEhpkCUjHWxYzLs
         zZPGuWcRXnWjYnI/dfJlpnkCjMjDlIFQ0FOZp0RkNnthDl5XveY/vpq7ia2LNPMACgEL
         Ww5VwnN8EjL15tJJobiEs10zjcwYGmy70EB0zKlqo1Byrb/7vKCK4xE7YMUGp1v1g6jg
         x2/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kTfpOex7Ud8CUqQBaXyyvSHgbNeSLa/1/bU7Yfg6MDw=;
        b=Toke64HNHnbsDbkTbKO7g9xdjkKdOYpEZaOAFRIOCwTbdPmrYnwZlVFEYw+VnHJlEe
         UpLxNOIUd2AhbEUHYrqLrwoAgM7QvbncvxUToC1HrucpcnDvEvfhYMxOjTd1/yPphQX+
         KP7Nv/XqQyqeGUKjbQq/molu25Vk7sk2vt25kUgOsctFQ3/2Pnf0KdQKY9AufoJHtra9
         LUIRoXwOO3yy/1W0LIOd3tGjSAfX4zSJxNsz43fGsUgSFHup+daNv34L7msJQXpXx9tb
         wE6ADlwvYLcIBmgotzvBWGj4dq7T0Ee4Xj+vrQaBZOQCOk05vXz52f6WOGyK02tMmP89
         k9Dg==
X-Gm-Message-State: AOAM531daB42lFL0Hvvc0RgnjRvZu0wKs20c4TH47AbYTGLDWPKoOpI+
        ZOhT0HFoT9iZS9wZzbyo0Gz1HOyh55/E9w==
X-Google-Smtp-Source: ABdhPJxN5XGTE2jJdVH562cuW/dVyLgJ98k4X/sn8aPHL7WA8Yq1HxiYPJ048WP8IJPsha1FkFctfQ==
X-Received: by 2002:a17:90a:e501:: with SMTP id t1mr6796475pjy.32.1622077937233;
        Wed, 26 May 2021 18:12:17 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:991:63cd:5e03:9e3a])
        by smtp.gmail.com with ESMTPSA id n21sm360282pfu.99.2021.05.26.18.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 18:12:16 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf v3 8/8] skmsg: increase sk->sk_drops when dropping packets
Date:   Wed, 26 May 2021 18:11:55 -0700
Message-Id: <20210527011155.10097-9-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210527011155.10097-1-xiyou.wangcong@gmail.com>
References: <20210527011155.10097-1-xiyou.wangcong@gmail.com>
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

