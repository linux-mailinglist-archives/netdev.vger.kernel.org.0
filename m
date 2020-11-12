Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8759C2B12C1
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 00:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgKLX1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 18:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgKLX1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 18:27:21 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3712FC0613D1;
        Thu, 12 Nov 2020 15:27:14 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id m13so8379799oih.8;
        Thu, 12 Nov 2020 15:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=aDYZN5a9ApiLd0vCcv7Ak0sWbHY6Cv/Dsk+GGWN7dZY=;
        b=ssfR/SeHY8IajLr+WRrLV5giu1JLsh/YUgrkL/2Z98FZvu2TW9rR6o24iUtBRwF6gD
         B5+3uZ54Pro2UVPfccOuTnxxu1sYi7i/EBlt3S0nUzRNarWiswrqhh00VLsvOIE9FXMS
         BycrD36NlbzXSH4dKCEJOfT+i81Lp58usGnDkhKrmcX+CnCuww3MTZRwSOFzA/8eOr1M
         MlAH4Lcv3jJvdwvkPJBRrZg6ikt1CBvoLMzo90arQf3xZKVNzHb7oBwWtG5nVbAqms8K
         G6QUFO+YK4T8I6trbWaZ0rXp7tPEVyKVvRENG2qBQGQngqmDuxEMDKw4AGLXpigIFJKA
         vSYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=aDYZN5a9ApiLd0vCcv7Ak0sWbHY6Cv/Dsk+GGWN7dZY=;
        b=ISN/4NGOxoje5h6DXpUuZQCckYbf/dPSb4H6ErpI3R2jwjEA27VQATPuoiVcVxHgiN
         PsdosbTKCFnnMOKtd7JzB5VJeJIGIbzjrH9dS8PRnyfLc2+Sb+fXsoKqOi2WKTeET1N7
         Q6DiEVIu+I/rUOOI8BxCurwGBd9yDTwSuW2aUjo8ThxEW0VEm3Q+yUgieBMM4X9mj6t/
         9c5MrVuHAPfG/cOwH9oj/1E8H45YHvP2WMz4hxscR6ov4LJSi7lS0zmNjTDdJ+zohl+C
         cVZFIS0CElsMP2tQcLcyaTb6pkxp/06ahZfLLc4a8xa/RFDeocxRi1k3QGw6oBABkScs
         VuEw==
X-Gm-Message-State: AOAM532TBdIiMI87niQ4OL1Dy/4+1IQnTFhtqQuE4YFpDFaV1n7/HCWi
        GTg34gmu8EPI+oDPeQ5a+jk=
X-Google-Smtp-Source: ABdhPJzFmr6ML7janfPb9nfjNhd4UkN/3Naqd5a/WNgxj/RpQGeT+00c44A4YqKMuxygLMxM/YD4Cw==
X-Received: by 2002:aca:d48c:: with SMTP id l134mr127430oig.129.1605223633688;
        Thu, 12 Nov 2020 15:27:13 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id s14sm1475480oij.4.2020.11.12.15.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 15:27:13 -0800 (PST)
Subject: [bpf PATCH v2 2/6] bpf,
 sockmap: Ensure SO_RCVBUF memory is observed on ingress redirect
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, jakub@cloudflare.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Thu, 12 Nov 2020 15:27:01 -0800
Message-ID: <160522362100.135009.18395216656832785566.stgit@john-XPS-13-9370>
In-Reply-To: <160522352433.135009.15329422887113794062.stgit@john-XPS-13-9370>
References: <160522352433.135009.15329422887113794062.stgit@john-XPS-13-9370>
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


