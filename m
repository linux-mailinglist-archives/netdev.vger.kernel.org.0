Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2AAB28913A
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732496AbgJIShQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgJISgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 14:36:32 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6A9C0613D2;
        Fri,  9 Oct 2020 11:36:31 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id n6so11050263ioc.12;
        Fri, 09 Oct 2020 11:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=lLa3hBZMn4NHFo7xwpT+WHTGtW+n4KL1Gv/kNX990nc=;
        b=sRL7lAoFzynAdYHdnMm8WglEKo8v4y1Q8zXpNKH3Thf+SHB6xNoP9uNnV05C50xb0A
         +nCyhlF77cF3OvrF6ZfqwRzxjNGoAuUdiKoQRnTkiro98h5AkjIGnXaAfHr3i8Uah6wv
         NXBM5t3EsH0G2fa/jPvOQfo1HWwQV28xugcBUfNPmF/lonIFerkT+HGTAyzP8/zRauZT
         LBZISk/IxqdsEj/tbT3w2GnkGZtslL+R/+ngdb56oCiJNbb4p46pHVbGlhKmk9fotlKN
         SSdxDje4ey1E442QE6+MgXu/7VghUAElcvOR+A4yTqWWdBut06SWpcnX0x/HT0cotUiv
         3R6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=lLa3hBZMn4NHFo7xwpT+WHTGtW+n4KL1Gv/kNX990nc=;
        b=BaJzIuIwOX+rOb/4mugG1NGe7tfFcRnjvxqkmy/4HYh99BJpfQrSrrEiePtJ61Jwf9
         XphbOfsTkwi1PIB9CH5VftANJOKY8IQGHZZ5wRJaueuol88irG3vu1LU4OggvX8d1e0Q
         9WRkvLqcpkbs4CyWIjc/jXHzd3jnUS9tV4FM3SrzTgidye6ifaf4TesbA64cCrdqsh+4
         7f8644mKW83MbFybVD0X5/UOGeNKOrIMC/W4Yjh7lNr4sTbX3RULKWBW6Kg7KW3EGzZz
         fzRCKqomk+SJDpcqzyIfE92zwb2KJO56/t+vdgCCF3MBACPCjeHTjUQvnGkAIAZpW94C
         JhWg==
X-Gm-Message-State: AOAM533aKMe4yJgCklNVCRWPKoSzL1ZP0WaN64eYo87Eg3gZlkC8tuOF
        yH3LtziPYvXWx7r9Db7Tszg=
X-Google-Smtp-Source: ABdhPJy6lGYejDeSVVOQX1Q6ItQNkph2z2JzgclDW2pgPOM2H2jAof8NKvRN5R+AM2aNtAaBP31Ieg==
X-Received: by 2002:a05:6602:2fc2:: with SMTP id v2mr1341210iow.19.1602268591014;
        Fri, 09 Oct 2020 11:36:31 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id t11sm4809886ill.61.2020.10.09.11.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 11:36:30 -0700 (PDT)
Subject: [bpf-next PATCH v3 1/6] bpf,
 sockmap: skb verdict SK_PASS to self already checked rmem limits
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Date:   Fri, 09 Oct 2020 11:36:16 -0700
Message-ID: <160226857664.5692.668205469388498375.stgit@john-Precision-5820-Tower>
In-Reply-To: <160226839426.5692.13107801574043388675.stgit@john-Precision-5820-Tower>
References: <160226839426.5692.13107801574043388675.stgit@john-Precision-5820-Tower>
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

