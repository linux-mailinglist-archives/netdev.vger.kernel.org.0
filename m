Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45F7289067
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390266AbgJIR6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731500AbgJIR6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 13:58:44 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14DAC0613D2;
        Fri,  9 Oct 2020 10:58:44 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id q7so9912740ile.8;
        Fri, 09 Oct 2020 10:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=AsNMLHaVACEddokEf1W40M3DcEqsPBOzxmz+X7AsbdU=;
        b=F11hvveY7jVSJuW7sQ4KeWArIa9hubQ8fYtgWbL3Jb6J8zbyj5hqWV9xa2H6ooV+jc
         jdZeO49whpQL3EYjg7dQUC/zs1yQpy8RFPSrlvpXh9T3FgeMRa5XWvxqeiUWIitBdOT+
         Yi7CwdZ2TCyq9VuxC2243H4HYbjOm4X7CknnYLuUSK82mYZJIfBLhaa6iHIsU93O9ZUV
         eJi3vVlhDT3gSW7N7h1XRHfmrHrxVLKdfXh3ophG+S4A3ulJbl10N571hvZGQeCzGLDm
         9Ogb8hPPrdBKYvg3RXWGoSN37UDpgJzKpwRrUzfOUno8wb2h+3SGEeusLxg1JU1q/jv8
         f1GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=AsNMLHaVACEddokEf1W40M3DcEqsPBOzxmz+X7AsbdU=;
        b=Q5IbbM/Ra1bmwiKtIsBPlgB4JK/tqbft84NiXWVH4Eu/ew++qeBuaQULufnvjkQqr1
         EsTBvMo93IaSR4fUAMsZoC+ggfHc8TMOavNAyPI5mGLSTBeqjGb/Ksa8aTuAGL3vZ+RZ
         pawBqDm8DJnYUM4kqCU78kvkfFZ89Ax1eV2AtVut0hLWJbLFPa4a52rIAzSjoO5mDvZT
         YoZk/mUNX2EGdMbZO6SbSo728ELiKW7S6efh1lvtKZx/2G//pX80yQkW80JdkLZqXiGf
         i3uKN4m6FDUyvDapURwxes/mxUq+wOiub5f+hIj3pEl+CCusVlZ/4JXlpWOLOKRO74j6
         ZPHA==
X-Gm-Message-State: AOAM530UwJen0a/m0i43Hood0QtGiHmkS4i3hGlwBnyywQ0dBTMblMS7
        4m+pGn8UdEa1/ANkfweOFkri+5FzQ/HpAA==
X-Google-Smtp-Source: ABdhPJyo8vTDxzi/EazCG0Cv59QOudDejSJlYzpVJkwuYFzTLQ53DDhvjJqlQutEpPMzx4XU4JAJAA==
X-Received: by 2002:a05:6e02:1105:: with SMTP id u5mr5071288ilk.286.1602266323959;
        Fri, 09 Oct 2020 10:58:43 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id m18sm4505791iln.30.2020.10.09.10.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 10:58:43 -0700 (PDT)
Subject: [bpf-next PATCH v2 4/6] bpf,
 sockmap: remove dropped data on errors in redirect case
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Date:   Fri, 09 Oct 2020 10:58:32 -0700
Message-ID: <160226631218.4390.10523182655030600867.stgit@john-Precision-5820-Tower>
In-Reply-To: <160226618411.4390.8167055952618723738.stgit@john-Precision-5820-Tower>
References: <160226618411.4390.8167055952618723738.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the sk_skb redirect case we didn't handle the case where we overrun
the sk_rmem_alloc entry on ingress redirect or sk_wmem_alloc on egress.
Because we didn't have anything implemented we simply dropped the skb.
This meant data could be dropped if socket memory accounting was in
place.

This fixes the above dropped data case by moving the memory checks
later in the code where we actually do the send or recv. This pushes
those checks into the workqueue and allows us to return an EAGAIN error
which in turn allows us to try again later from the workqueue.

Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index cab596c02412..9804ef0354a2 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -433,10 +433,12 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
 			       u32 off, u32 len, bool ingress)
 {
-	if (ingress)
-		return sk_psock_skb_ingress(psock, skb);
-	else
+	if (!ingress) {
+		if (!sock_writeable(psock->sk))
+			return -EAGAIN;
 		return skb_send_sock_locked(psock->sk, skb, off, len);
+	}
+	return sk_psock_skb_ingress(psock, skb);
 }
 
 static void sk_psock_backlog(struct work_struct *work)
@@ -709,30 +711,28 @@ static void sk_psock_skb_redirect(struct sk_buff *skb)
 {
 	struct sk_psock *psock_other;
 	struct sock *sk_other;
-	bool ingress;
 
 	sk_other = tcp_skb_bpf_redirect_fetch(skb);
+	/* This error is a buggy BPF program, it returned a redirect
+	 * return code, but then didn't set a redirect interface.
+	 */
 	if (unlikely(!sk_other)) {
 		kfree_skb(skb);
 		return;
 	}
 	psock_other = sk_psock(sk_other);
+	/* This error indicates the socket is being torn down or had another
+	 * error that caused the pipe to break. We can't send a packet on
+	 * a socket that is in this state so we drop the skb.
+	 */
 	if (!psock_other || sock_flag(sk_other, SOCK_DEAD) ||
 	    !sk_psock_test_state(psock_other, SK_PSOCK_TX_ENABLED)) {
 		kfree_skb(skb);
 		return;
 	}
 
-	ingress = tcp_skb_bpf_ingress(skb);
-	if ((!ingress && sock_writeable(sk_other)) ||
-	    (ingress &&
-	     atomic_read(&sk_other->sk_rmem_alloc) <=
-	     sk_other->sk_rcvbuf)) {
-		skb_queue_tail(&psock_other->ingress_skb, skb);
-		schedule_work(&psock_other->work);
-	} else {
-		kfree_skb(skb);
-	}
+	skb_queue_tail(&psock_other->ingress_skb, skb);
+	schedule_work(&psock_other->work);
 }
 
 static void sk_psock_tls_verdict_apply(struct sk_buff *skb, int verdict)

