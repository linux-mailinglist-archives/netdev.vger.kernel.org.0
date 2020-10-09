Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5657228913F
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731754AbgJISiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730763AbgJISiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 14:38:08 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFD3C0613D2;
        Fri,  9 Oct 2020 11:38:08 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id u19so11118631ion.3;
        Fri, 09 Oct 2020 11:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=PWLTwN4CpghStBRl2aJ9sg/Q1cHv19C1w9Szy0Ser+Y=;
        b=nfOwx/p1otqgvR3E+N6H79n2XaOfuKt4BFtIqs8dJW/Vjcv48EAz1lQm33rCRxAHt3
         C9BCIchvyj/Folr2/UIyyciPrPAXAPe0vsvYgwDvzlZWo4MDBTPtcHLnKnhCeJOGVY/H
         WmxsB+b/3e1gnXiJbYrgWwiH2KwqlvGigkXKvG/wN6Q9ZQ1MwW0t+1WX0UhwAyp5ZC1x
         Ank+lbKhrQjswp8dgoaKhTUmzYqoXdXFRuqfOWcBdsNFnbgj9ac6ungGaCjm0950D03m
         VLlKOiq5N7tlQxM3/z/JFy2S3sH1hPRQPs4Gm2Xu4B6p/MCx76mEeZGN7Xhv2I09yk94
         +10g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=PWLTwN4CpghStBRl2aJ9sg/Q1cHv19C1w9Szy0Ser+Y=;
        b=D7/ynt7sAOuSDE4t54fd4klm6ktvLUGvFBCaCa/oj9kKoMI7e0NllOw1fYTHdC0yFo
         fRukBsGsh/vswHZr5P1IOEXfCtuEOBqt4dFfrmR5Grygel2MFbazfArChoAwMWFZ5SQ9
         22vDZm6wDIW6hwZRNyLC4ggrRdAUUKlwBCQV8UVU3nqzPHofHWeR9bP4lgbdgXT2/9ZY
         ycG3PYOeoxhE1Z2dtcRIpiHXJlth9nNw1voM3T1FJJLepIlj/UPLU+bGFGoZNIq4wPZq
         g1GqGamRVvTGfdALdaQ5B8isISFbolGHQlAKgF0s+Q4BA79Ev6h9CQqT/CfaYNm/3/yk
         qWsw==
X-Gm-Message-State: AOAM5334/Pwe7+cGlOoe/w/TnqOd4MtbeU6mqILm+wChCFWuxV2tI7P1
        QvoGs/1dMXmbl91HBkGILoI=
X-Google-Smtp-Source: ABdhPJzarwCdy4BwQzuRsBCYFGhbe6xbH9MY2oQwyf6TV+5QGsImzcC9UYYnFzWf7oipbFMHKgxtDg==
X-Received: by 2002:a05:6638:1508:: with SMTP id b8mr11627467jat.25.1602268687698;
        Fri, 09 Oct 2020 11:38:07 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id g8sm1624916ilc.39.2020.10.09.11.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 11:38:07 -0700 (PDT)
Subject: [bpf-next PATCH v3 6/6] bpf,
 sockmap: Add memory accounting so skbs on ingress lists are visible
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Date:   Fri, 09 Oct 2020 11:37:55 -0700
Message-ID: <160226867513.5692.10579573214635925960.stgit@john-Precision-5820-Tower>
In-Reply-To: <160226839426.5692.13107801574043388675.stgit@john-Precision-5820-Tower>
References: <160226839426.5692.13107801574043388675.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move skb->sk assignment out of sk_psock_bpf_run() and into individual
callers. Then we can use proper skb_set_owner_r() call to assign a
sk to a skb. This improves things by also charging the truesize against
the sockets sk_rmem_alloc counter. With this done we get some accounting
in place to ensure the memory associated with skbs on the workqueue are
still being accounted for somewhere. Finally, by using skb_set_owner_r
the destructor is setup so we can just let the normal skb_kfree logic
recover the memory. Combined with previous patch dropping skb_orphan()
we now can recover from memory pressure and maintain accounting.

Note, we will charge the skbs against their originating socket even
if being redirected into another socket. Once the skb completes the
redirect op the kfree_skb will give the memory back. This is important
because if we charged the socket we are redirecting to (like it was
done before this series) the sock_writeable() test could fail because
of the skb trying to be sent is already charged against the socket.

Also TLS case is special. Here we wait until we have decided not to
simply PASS the packet up the stack. In the case where we PASS the
packet up the stack we already have an skb which is accounted for on
the TLS socket context.

For the parser case we continue to just set/clear skb->sk this is
because the skb being used here may be combined with other skbs or
turned into multiple skbs depending on the parser logic. For example
the parser could request a payload length greater than skb->len so
that the strparser needs to collect multiple skbs. At any rate
the final result will be handled in the strparser recv callback.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 3e78f2a80747..881a5b290946 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -684,20 +684,8 @@ EXPORT_SYMBOL_GPL(sk_psock_msg_verdict);
 static int sk_psock_bpf_run(struct sk_psock *psock, struct bpf_prog *prog,
 			    struct sk_buff *skb)
 {
-	int ret;
-
-	/* strparser clones the skb before handing it to a upper layer,
-	 * meaning we have the same data, but sk is NULL. We do want an
-	 * sk pointer though when we run the BPF program. So we set it
-	 * here and then NULL it to ensure we don't trigger a BUG_ON()
-	 * in skb/sk operations later if kfree_skb is called with a
-	 * valid skb->sk pointer and no destructor assigned.
-	 */
-	skb->sk = psock->sk;
 	bpf_compute_data_end_sk_skb(skb);
-	ret = bpf_prog_run_pin_on_cpu(prog, skb);
-	skb->sk = NULL;
-	return ret;
+	return bpf_prog_run_pin_on_cpu(prog, skb);
 }
 
 static struct sk_psock *sk_psock_from_strp(struct strparser *strp)
@@ -736,10 +724,11 @@ static void sk_psock_skb_redirect(struct sk_buff *skb)
 	schedule_work(&psock_other->work);
 }
 
-static void sk_psock_tls_verdict_apply(struct sk_buff *skb, int verdict)
+static void sk_psock_tls_verdict_apply(struct sk_buff *skb, struct sock *sk, int verdict)
 {
 	switch (verdict) {
 	case __SK_REDIRECT:
+		skb_set_owner_r(skb, sk);
 		sk_psock_skb_redirect(skb);
 		break;
 	case __SK_PASS:
@@ -757,11 +746,17 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
 	rcu_read_lock();
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
+		/* We skip full set_owner_r here because if we do a SK_PASS
+		 * or SK_DROP we can skip skb memory accounting and use the
+		 * TLS context.
+		 */
+		skb->sk = psock->sk;
 		tcp_skb_bpf_redirect_clear(skb);
 		ret = sk_psock_bpf_run(psock, prog, skb);
 		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
+		skb->sk = NULL;
 	}
-	sk_psock_tls_verdict_apply(skb, ret);
+	sk_psock_tls_verdict_apply(skb, psock->sk, ret);
 	rcu_read_unlock();
 	return ret;
 }
@@ -823,6 +818,7 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 		kfree_skb(skb);
 		goto out;
 	}
+	skb_set_owner_r(skb, sk);
 	prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
 		tcp_skb_bpf_redirect_clear(skb);
@@ -847,8 +843,11 @@ static int sk_psock_strp_parse(struct strparser *strp, struct sk_buff *skb)
 
 	rcu_read_lock();
 	prog = READ_ONCE(psock->progs.skb_parser);
-	if (likely(prog))
+	if (likely(prog)) {
+		skb->sk = psock->sk;
 		ret = sk_psock_bpf_run(psock, prog, skb);
+		skb->sk = NULL;
+	}
 	rcu_read_unlock();
 	return ret;
 }

