Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C69289138
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732914AbgJIShP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732545AbgJISgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 14:36:51 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38AFC0613D2;
        Fri,  9 Oct 2020 11:36:51 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id b1so6307079iot.4;
        Fri, 09 Oct 2020 11:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=x8XH6zeeutGP4rEQeNvbvrwh5BP+FcwqMZ4vlu9DuVE=;
        b=g9OTkdCuYdmmnzICRmmjnIaotRU+ekIoPyb4kW2X3OpP1ySdxO3rG5Hza5MUX+oqRe
         2xjXek8E0eRNeTacOf2g820cM1y43EuJ6gxzNLQwrKPlxKVzT6LMYYB/MD+ePIpGB3PU
         Q4E5MaR7cxipWA2MhkbieSgb+zlFChESXPVC3FZH+aT4c1tkMQxnH7Z+EHzSsXheJflQ
         Nu0okgzIk7OUcIB1JC0DTi1HzgQ+g9Zhr8OlQLWNoss2+6FgN/XMkjxf1SXbwPg8gnfD
         DsO0rlQKPzoRSu0sehWq3/atWf/jGYTCltH/ZJAChAw3jpq6Qecjh/C09fM6+2Da6X9O
         gpkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=x8XH6zeeutGP4rEQeNvbvrwh5BP+FcwqMZ4vlu9DuVE=;
        b=pcydZ0/4SBuhFEjDsqSkOX3gXTCEpbrvTaea88v/tvh3aLfnBEBnuMbv0e4tSrVmZX
         +nbYRw3YAfYLsAJf8EOTVALaFlLvRTTBDdJr1bw9Pa+VI5JgtussdCU+shr01moPzGp4
         /50IAlbkjtt2fMdY2/b92YMjQBJjn2AcWgb2sn/glRtwN399Kp+16faep3xsbhRWNGeg
         mjoiMK8V/AUt7HxUjI83aFYU2nS8Tm3vEfVQXncBrukOt3p0ar3AC/zUvb/hrbxWeY9L
         QmS+sepDlcDsT905aN5Af7L9rxO29Dvzj4gSk+WRjeXl9PnlqEzoZvOQ4yFne37Xki2D
         6yMg==
X-Gm-Message-State: AOAM531QlCffX4AyE9CyGMJtVF0rbnyprMBpivGqYy2BnJ7jUjItO++K
        +J9QM7a61CwFuNl/oGoxUwE=
X-Google-Smtp-Source: ABdhPJxdfto63uivW5rjDHcsOrcA9vIOvsVRnSOLsM9bbWrXJObHl1un/55AKDxltQ6bP6W7D8NWZg==
X-Received: by 2002:a5d:9d15:: with SMTP id j21mr9991392ioj.100.1602268611082;
        Fri, 09 Oct 2020 11:36:51 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id v17sm4595887ilm.48.2020.10.09.11.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 11:36:50 -0700 (PDT)
Subject: [bpf-next PATCH v3 2/6] bpf,
 sockmap: On receive programs try to fast track SK_PASS ingress
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jakub@cloudflare.com,
        lmb@cloudflare.com
Date:   Fri, 09 Oct 2020 11:36:37 -0700
Message-ID: <160226859704.5692.12929678876744977669.stgit@john-Precision-5820-Tower>
In-Reply-To: <160226839426.5692.13107801574043388675.stgit@john-Precision-5820-Tower>
References: <160226839426.5692.13107801574043388675.stgit@john-Precision-5820-Tower>
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
index 040ae1d75b65..4b160d97b7f9 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -773,6 +773,7 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
 {
 	struct tcp_skb_cb *tcp;
 	struct sock *sk_other;
+	int err = -EIO;
 
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

