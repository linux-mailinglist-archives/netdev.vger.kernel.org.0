Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8209F289062
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 19:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390253AbgJIR6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 13:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731500AbgJIR6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 13:58:09 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D6CC0613D2;
        Fri,  9 Oct 2020 10:58:09 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id n6so10917409ioc.12;
        Fri, 09 Oct 2020 10:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=CM32h5VxYUxOVKW+sj4z4wfLNFtEsf7TkwLYvQvIT2Q=;
        b=Z4uKpWSEFpCpRzBVq/Ckc+g+MUULVRZqQu9J0uj6ngmhtBw5eTLh4UVShNe6TntjAA
         2O4SzFVBQ41ZodKsX4VVu2f+VZqCNBHnio2oOAry9kIjIqMaO+36Rhn9RopcVC0B7Elf
         ROpS4IiMnmSmG5adbI91kuCpSE6v5MBX/6tYVvraf8dcMaVV9plQ1VMwCk/MLApvKJ4k
         f+kvD6eHz3xx6CJa3VrXa3vrhB/qY1Cl0UU0Eey1g3kq5zGFzHUHzGbSfAZXRklk/tda
         Cg0QgBIRP/cRatNqhBEdU9Ozv1a+JsTadPTnulrNEmooLLJUf0WPUJOFBH7s/T+2i9ZG
         hu0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=CM32h5VxYUxOVKW+sj4z4wfLNFtEsf7TkwLYvQvIT2Q=;
        b=Sy8RA/fq4MRGFrkcFZdcco5R3gW6JZ9bsjWUdGbG6TA1eBPK13kjXwJKY1GdqkyZsu
         bJqkkE55uajyHw7ZymK4YQeoocYOwZeJZlAx1Iloij9JA0xUQc0CtzgKgc2mjNRyApKf
         ZHTs33MFd1VJqJC1EHZmf0jbGalxAux8Mg19QvDxUutmryUMzfyKdJT+nsBLnM1zGtWX
         IEdSxQSMI0Abp7KQOM6GR2iN/iELGpr1Sjugy5eJM/T97lcHu4MWi0Op/EyWvY9PxuoK
         8J2dRUbaeab3gZ26e+sIfuGqp+37RVQdUhWGVu0VHgb3I1AyW6075asDDyXd1WG2WE8E
         7spw==
X-Gm-Message-State: AOAM531mlWoBozjS8y6l8PQbWmLE6kUK8Ccxz1vOUChlZaQKN30CT7O3
        5BGs7rz98hNaqXcDuihZpOrhPxl3lE3ZXQ==
X-Google-Smtp-Source: ABdhPJzYZvZU4dFi/b/XkAmb4XegiSDIfmxLKgCPY58N6xtV0GvkWkBN/fEFVGR/uiZ7ej/kIiEKrw==
X-Received: by 2002:a6b:8bd7:: with SMTP id n206mr9792005iod.13.1602266288495;
        Fri, 09 Oct 2020 10:58:08 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id k198sm4742686ilk.80.2020.10.09.10.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 10:58:07 -0700 (PDT)
Subject: [bpf-next PATCH v2 2/6] bpf,
 sockmap: On receive programs try to fast track SK_PASS ingress
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Date:   Fri, 09 Oct 2020 10:57:56 -0700
Message-ID: <160226627645.4390.11671193470778624910.stgit@john-Precision-5820-Tower>
In-Reply-To: <160226618411.4390.8167055952618723738.stgit@john-Precision-5820-Tower>
References: <160226618411.4390.8167055952618723738.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we receive an skb and the ingress skb verdict program returns
SK_PASS we currently set the ingress flag and put it on the workqueue
so it can be turned into a sk_msg and put on the sk_msg ingress queue.
Then finally telling userspace with data_ready hook.

Here we observe that if the workqueue is empty then we can try to
convert into a sk_msg type and call data_ready directly without
bouncing through a workqueue. Its a common pattern to have a recv
verdict program for visibility that always returns SK_PASS. In this
case unless there is an ENOMEM error or we overrun the socket we
can avoid the workqueue completely only using it when we fall back
to error cases caused by memory pressure.

By doing this we eliminate another case where data may be dropped
if errors occur on memory limits in workqueue.

Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 040ae1d75b65..455cf5fa0279 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -773,6 +773,7 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 {
 	struct tcp_skb_cb *tcp;
 	struct sock *sk_other;
+	int err = 0;
 
 	switch (verdict) {
 	case __SK_PASS:
@@ -784,8 +785,20 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 
 		tcp = TCP_SKB_CB(skb);
 		tcp->bpf.flags |= BPF_F_INGRESS;
-		skb_queue_tail(&psock->ingress_skb, skb);
-		schedule_work(&psock->work);
+
+		/* If the queue is empty then we can submit directly
+		 * into the msg queue. If its not empty we have to
+		 * queue work otherwise we may get OOO data. Otherwise,
+		 * if sk_psock_skb_ingress errors will be handled by
+		 * retrying later from workqueue.
+		 */
+		if (skb_queue_empty(&psock->ingress_skb)) {
+			err = sk_psock_skb_ingress(psock, skb);
+		}
+		if (err < 0) {
+			skb_queue_tail(&psock->ingress_skb, skb);
+			schedule_work(&psock->work);
+		}
 		break;
 	case __SK_REDIRECT:
 		sk_psock_skb_redirect(skb);

