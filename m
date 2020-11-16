Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1922B544D
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 23:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbgKPW2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 17:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728982AbgKPW2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 17:28:21 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BD5C0613CF;
        Mon, 16 Nov 2020 14:28:21 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id q206so20459537oif.13;
        Mon, 16 Nov 2020 14:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=zxfG9WgRQhGfLjPd4ehiW5C8xK9vjl0mxXHi2eGmpCE=;
        b=n5wtqRNDdnJISGdYJk5SoWlMtxKDrfyweQODBAp/QYBoNYUyfdq/v2caaXZKEdz28M
         6v3FN4EI3ZgJML/VBxK87WjnecJWTtF8CI4Fwf7RSFWSoaRB1mqz/MPRy4Ynk+MWlzHv
         5NGDnPEblw6DLw5aHLnMcJJfqCk/JpNY6RASt8zme9XLBE93DZStbBWR1/i3UCeVe6sk
         Uu7BHojxjR0ZwiERJMHDSJgdCCFCpczVHZQq71SPvGZD1Ms/TZv/cbcaPUWqN+EWLF00
         JhqB4nkv5rvlEdAwnxOe/+7m8sBjIV4tcXqaGXNi9uq/axdznOuuNEPgDcxD059Eig2v
         8Pdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=zxfG9WgRQhGfLjPd4ehiW5C8xK9vjl0mxXHi2eGmpCE=;
        b=c54El/hdXKZ5QUY3lQAU5Dkvy2YnMG7uDVs2bn4864rRp4lL/Jc7XTvXkd9hFsbD8P
         eKiwBaCetO3gGAQPMCv0xFdVcYh1vRWf/PcpIYBPoayM0+1rrkl6ldRseLJ15Gv5twOe
         QS4hFqjhdjcQPs+Hai/2udFInXzGRGXE5U5PtLsbupMAo/mkmSoSNR1NZRjf/hTvVspc
         DhqdaekO7TWNgZF9jPrIt2+bbhr+XGlQjhVl+wouzRSvH/XJZIJm/cY1jxEDSwZ8e49f
         qwUlTjDmN0sr4AxgUTYDKBvnhXn0NvSHE0u0jQhrUaIaE3sYzOrzQX42dhjBimFjAF1H
         w3AA==
X-Gm-Message-State: AOAM533lRnsWzgR0DTDP4FR53GUTrKb/voqIUynvSeDPpiVFVPIUg/+E
        IXGafJU89tXMuhYl9vy+KkVLNc7CMTJCgg==
X-Google-Smtp-Source: ABdhPJwClpPMOo9d48fo8RXeG5bvDhDE+XSEHTNUqaia9jEslACyQm/xuSKP7UG0G6QPoxt80rQI8g==
X-Received: by 2002:aca:c4d7:: with SMTP id u206mr572669oif.150.1605565700186;
        Mon, 16 Nov 2020 14:28:20 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b13sm5147660otp.28.2020.11.16.14.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 14:28:19 -0800 (PST)
Subject: [bpf PATCH v3 2/6] bpf,
 sockmap: Ensure SO_RCVBUF memory is observed on ingress redirect
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, ast@kernel.org, daniel@iogearbox.net
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Mon, 16 Nov 2020 14:28:06 -0800
Message-ID: <160556568657.73229.8404601585878439060.stgit@john-XPS-13-9370>
In-Reply-To: <160556562395.73229.12161576665124541961.stgit@john-XPS-13-9370>
References: <160556562395.73229.12161576665124541961.stgit@john-XPS-13-9370>
User-Agent: StGit/0.23-36-gc01b
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sockmap sk_skb programs so that they observe sk_rcvbuf limits. This
allows users to tune SO_RCVBUF and sockmap will honor them.

We can refactor the if(charge) case out in later patches. But, keep this
fix to the point.

Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c   |   20 ++++++++++++++++----
 net/ipv4/tcp_bpf.c |    3 ++-
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 654182ecf87b..fe44280c033e 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -170,10 +170,12 @@ static int sk_msg_free_elem(struct sock *sk, struct sk_msg *msg, u32 i,
 	struct scatterlist *sge = sk_msg_elem(msg, i);
 	u32 len = sge->length;
 
-	if (charge)
-		sk_mem_uncharge(sk, len);
-	if (!msg->skb)
+	/* When the skb owns the memory we free it from consume_skb path. */
+	if (!msg->skb) {
+		if (charge)
+			sk_mem_uncharge(sk, len);
 		put_page(sg_page(sge));
+	}
 	memset(sge, 0, sizeof(*sge));
 	return len;
 }
@@ -403,6 +405,9 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 	int copied = 0, num_sge;
 	struct sk_msg *msg;
 
+	if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf)
+		return -EAGAIN;
+
 	msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_ATOMIC);
 	if (unlikely(!msg))
 		return -EAGAIN;
@@ -418,7 +423,14 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
 		return num_sge;
 	}
 
-	sk_mem_charge(sk, skb->len);
+	/* This will transition ownership of the data from the socket where
+	 * the BPF program was run initiating the redirect to the socket
+	 * we will eventually receive this data on. The data will be released
+	 * from skb_consume found in __tcp_bpf_recvmsg() after its been copied
+	 * into user buffers.
+	 */
+	skb_set_owner_r(skb, sk);
+
 	copied = skb->len;
 	msg->sg.start = 0;
 	msg->sg.size = copied;
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 8e950b0bfabc..bc7d2a586e18 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -45,7 +45,8 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 			if (likely(!peek)) {
 				sge->offset += copy;
 				sge->length -= copy;
-				sk_mem_uncharge(sk, copy);
+				if (!msg_rx->skb)
+					sk_mem_uncharge(sk, copy);
 				msg_rx->sg.size -= copy;
 
 				if (!sge->length) {


