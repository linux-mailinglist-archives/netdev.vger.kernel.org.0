Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0466D2AA7B5
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 20:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbgKGTi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 14:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgKGTi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 14:38:28 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62B1C0613CF;
        Sat,  7 Nov 2020 11:38:28 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id t16so5389391oie.11;
        Sat, 07 Nov 2020 11:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=lu8xFLzKq5EcwF/rmpzYgaF3GRt/mG2wCMUgnyFW2F4=;
        b=g5J8Dz/HsGZtjd0AFilkNvenRhKE/uv0CLpDugjcbQKLK8o3WKw5ow7SpIhN6lvu3C
         ZuUcxmqC0D7k7vPpEGQsSn3axH2mnycVFxW+29tIAkeH1UWLTsxTUwseVLXunKqUM5AK
         bdUng6sV/8hwrFTGB4eV6knoOmU6YwLDQdtYgq0SNOInPO5hTC4FfK7I8sKKvHvdvTLT
         9ncFd1C6rM718vYKb5SfvZnDtUc3pQAJBrAn3wjtgr7Q7mX26VxW+49ie+gGxQr6kos+
         UKzbrASiDVCDdDWXnmJDOE7LwL0XvnIKd4cQ0e5rzGhHQtS+UI7jdt6NMsPioNIOWOqE
         K64A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=lu8xFLzKq5EcwF/rmpzYgaF3GRt/mG2wCMUgnyFW2F4=;
        b=D72o1ApxNLrpkxV6S7w2NKGyAoIBKpMqvA0/Xbl0/RjFcgmtzSMCED6PKW7PoOIZLv
         Oj5y7XMh7xUrhvesti3sPjkrEuIK8ZjAZfvlj/WiOWCqjY12RsxcUndGMzjJSR/uYbdb
         AhDC8p5JbYv7k+znvYmx11kSGgA2q7aeCnvjr2VJlwi03DWMfCIcWIFOqHUU4bZ5j5Xr
         joNmjiIjhoSSoBJ+i0n26EMCuGyqnA3JSYHgX4070x501w89PG/qgvStZVHcKQaMS3mx
         R0b5Rswap12qnG4FWo4ZAPvwAsNye05+HVjnAleh5Hmi+RGN1tsZ12CP1uS83uhhlI6N
         DS9Q==
X-Gm-Message-State: AOAM53237m42zgRiffH3zwzh1NxQGn5Ei2FNCr+uCSViKicdWiHxUzrj
        EwcJGkN0MXx1Vao5BGFLoj4=
X-Google-Smtp-Source: ABdhPJy7qPlnp5/EvqHFs1UtAVy5avBgFP1x8B47wxkipA/CHg7aiTtRnKD53ItrFJAaUZOT/0FQ6A==
X-Received: by 2002:aca:c70b:: with SMTP id x11mr4979894oif.58.1604777908240;
        Sat, 07 Nov 2020 11:38:28 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id w70sm1235588oiw.29.2020.11.07.11.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 11:38:27 -0800 (PST)
Subject: [bpf PATCH 2/5] bpf,
 sockmap: Ensure SO_RCVBUF memory is observed on ingress redirect
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, jakub@cloudflare.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Sat, 07 Nov 2020 11:38:15 -0800
Message-ID: <160477789531.608263.11406385279476664711.stgit@john-XPS-13-9370>
In-Reply-To: <160477770483.608263.6057216691957042088.stgit@john-XPS-13-9370>
References: <160477770483.608263.6057216691957042088.stgit@john-XPS-13-9370>
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
index 3709d679436e..30802fa99aa1 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -46,7 +46,8 @@ int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
 			if (likely(!peek)) {
 				sge->offset += copy;
 				sge->length -= copy;
-				sk_mem_uncharge(sk, copy);
+				if (!msg_rx->skb)
+					sk_mem_uncharge(sk, copy);
 				msg_rx->sg.size -= copy;
 
 				if (!sge->length) {


