Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89EAC28905F
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390247AbgJIR5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731500AbgJIR5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 13:57:51 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA24C0613D2;
        Fri,  9 Oct 2020 10:57:51 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id 67so10943628iob.8;
        Fri, 09 Oct 2020 10:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=lLa3hBZMn4NHFo7xwpT+WHTGtW+n4KL1Gv/kNX990nc=;
        b=EIu+vUuT+dgns6VFfvuJxLybqgckEgpiMe44xRuPcfv9E8FwrbpPOP31OBviWDZk6p
         1s5sbvQZGlP1GVBcpqDin08xUWK/7OxSjhcIKxzfI29T0I3DS7mcoISXx1hDJZ6bH+Yb
         uVThWIIDUAvTT//TeRuIUSPvWA3LHx2a4L/0lz3+Uf/CCyHPgk6BzRGOm6vO5lx38J4w
         5TsIHrtD5fF/bggq1HEdRGsnGVoxRudm8KYmV5IAnufu6MDMuUwFlqIcOQT134MEzqTt
         e9DjQp8po3zTtmRp7iSqP8q8ZcvIA3OtcHucn88ffj26jATO9S6FfznrDl2hVf1oPi3R
         RwQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=lLa3hBZMn4NHFo7xwpT+WHTGtW+n4KL1Gv/kNX990nc=;
        b=URLcmg3nMxj2d24s79RmZtFLkn5c6LyEJny0AnaA9RVOzQPUTGTtnpI+4BwiuneKin
         6dc5krNd337Gb52yNzyTIYFDRwQ8mIiCMVFO810kbUIc/eprMWZ2Rla+yOwo4nEk/G5w
         wklDs+3AmWhKFhGBaLhjLOc6rm1JhDXBnzVg32A/tb5uQUs/m7rRxLwPQa1squct0RcK
         Ta8Xg3O/4MR2zG+okyHJr2dqQlspvXUdJ5VDgBlyDJu2H+0zVzK+S8JfXsugiVo9M6Q5
         pxtMytUC8WhYjC6BoEXNzniFAsYBCXbIT3DP5hw2AjS4QmOL1HzM75ThQ/9JrMfRAuvV
         BgoQ==
X-Gm-Message-State: AOAM530eKzX3EZlI/qPzVgeLUrYSOi9w6yJtR5TYm5yGCxZPuPkqAlob
        /DD+l5Qy7kYU1UVs49Rlr2s=
X-Google-Smtp-Source: ABdhPJy0jlrRUjmIuft5WYSv7pEYPax0idrIQzPwVyoFzpb0BkYNu70XRIXDtSnUxM2AvQsBtSwz7w==
X-Received: by 2002:a5d:8352:: with SMTP id q18mr10493822ior.31.1602266270513;
        Fri, 09 Oct 2020 10:57:50 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a86sm4675034ill.11.2020.10.09.10.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 10:57:49 -0700 (PDT)
Subject: [bpf-next PATCH v2 1/6] bpf,
 sockmap: skb verdict SK_PASS to self already checked rmem limits
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Date:   Fri, 09 Oct 2020 10:57:38 -0700
Message-ID: <160226625788.4390.13364451138430478477.stgit@john-Precision-5820-Tower>
In-Reply-To: <160226618411.4390.8167055952618723738.stgit@john-Precision-5820-Tower>
References: <160226618411.4390.8167055952618723738.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For sk_skb case where skb_verdict program returns SK_PASS to continue to
pass packet up the stack, the memory limits were already checked before
enqueuing in skb_queue_tail from TCP side. So, lets remove the extra checks
here. The theory is if the TCP stack believes we have memory to receive
the packet then lets trust the stack and not double check the limits.

In fact the accounting here can cause a drop if sk_rmem_alloc has increased
after the stack accepted this packet, but before the duplicate check here.
And worse if this happens because TCP stack already believes the data has
been received there is no retransmit.

Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 4b5f7c8fecd1..040ae1d75b65 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -771,6 +771,7 @@ EXPORT_SYMBOL_GPL(sk_psock_tls_strp_read);
 static void sk_psock_verdict_apply(struct sk_psock *psock,
 				   struct sk_buff *skb, int verdict)
 {
+	struct tcp_skb_cb *tcp;
 	struct sock *sk_other;
 
 	switch (verdict) {
@@ -780,16 +781,12 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 		    !sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
 			goto out_free;
 		}
-		if (atomic_read(&sk_other->sk_rmem_alloc) <=
-		    sk_other->sk_rcvbuf) {
-			struct tcp_skb_cb *tcp = TCP_SKB_CB(skb);
 
-			tcp->bpf.flags |= BPF_F_INGRESS;
-			skb_queue_tail(&psock->ingress_skb, skb);
-			schedule_work(&psock->work);
-			break;
-		}
-		goto out_free;
+		tcp = TCP_SKB_CB(skb);
+		tcp->bpf.flags |= BPF_F_INGRESS;
+		skb_queue_tail(&psock->ingress_skb, skb);
+		schedule_work(&psock->work);
+		break;
 	case __SK_REDIRECT:
 		sk_psock_skb_redirect(skb);
 		break;

