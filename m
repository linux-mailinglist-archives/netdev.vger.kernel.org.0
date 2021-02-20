Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E00320408
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 06:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhBTFbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 00:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbhBTFay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Feb 2021 00:30:54 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C56C0617A7;
        Fri, 19 Feb 2021 21:29:39 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id 105so734158otd.3;
        Fri, 19 Feb 2021 21:29:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6qLL1pD8eAIF22astLsGTIt6XsSRTHADcChvDI82gwA=;
        b=gIYzanohDRE8gMwXQrZE14ePq0SQeXVPvj5vB+XO9a2sIR7nfZ2qjXT6ph6KHgwf+N
         eeExVLsFQgaKYcomBfTcLh7qz3rtPKSZe7nln/3HaK8bllvKCpqBAPhzNQ1UnkmxN4cd
         CqCoUwAxuRXb5HIwGFy5PCkYqk2zMSEXbUBgezZNDRIDmUd0qtzjY/dnBXD8yuZLJ1vi
         OTZ4deVS5LJBRIVj57o05ZcqE1TqAr4h7kIfbobTQnI8ATo3lNyaFSIAfXpC2MoJqO3P
         7C4JwNwDJnjV5UDWM8ce188tcx35vge6vON2sdfzSeUrU2Jcr5WSXlkLDie7IThmp3yu
         pelA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6qLL1pD8eAIF22astLsGTIt6XsSRTHADcChvDI82gwA=;
        b=EP6cKorEgnuUAzhYUeKag7ecbH058Fv0QR3pU9GheEZHahXglSRgCEeYPJ5rlRp6jS
         jGjxAX9WbZ+nJPXZkgCWWdADlRBIry3Q4kMzGzSqe0De0sg9Lmc2dSdhP12A9Aq9Ds6m
         0RZYWwoFJo+TC4Lb1rDs9WyR5Yz6Q7UWq95382/WrEmhR/MPg5hExrgpTDBBHxTKTPXb
         lYlvRrB42FhKYNmx8zX+IDYYTDmdxKxEL53vY2vuzDMgRtUxpUzU2SZD1gh8Wl9oKlcW
         PK1hLlGsPTa04sqNZtp6FglWHzRWZbJzUKJVr56vEEW87xWAbFMKbwAUSdCy4URGOmIM
         QlVw==
X-Gm-Message-State: AOAM533tp2uU6YiOvcjJf6ztleXCJ+C2DX0frA0gFGvp+zz2g3yImjaT
        xCm6enM1sjK7uo2WR6Uifi6QVrc5zRbB1A==
X-Google-Smtp-Source: ABdhPJxPYAJoJQxRcl87iM2fg/uvkuCQyruZ4RUORQY3muV3Wr7+pCURehEG5SjmYDfuUcIHvhIOsg==
X-Received: by 2002:a9d:7699:: with SMTP id j25mr9554279otl.202.1613798978884;
        Fri, 19 Feb 2021 21:29:38 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1d72:18:7c76:92e4])
        by smtp.gmail.com with ESMTPSA id v20sm945955oie.2.2021.02.19.21.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 21:29:38 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [Patch bpf-next v6 8/8] skmsg: get rid of sk_psock_bpf_run()
Date:   Fri, 19 Feb 2021 21:29:24 -0800
Message-Id: <20210220052924.106599-9-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210220052924.106599-1-xiyou.wangcong@gmail.com>
References: <20210220052924.106599-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

It is now nearly identical to bpf_prog_run_pin_on_cpu() and
it has an unused parameter 'psock', so we can just get rid
of it and call bpf_prog_run_pin_on_cpu() directly.

Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/skmsg.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 286a95304e03..b240be71f21f 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -748,12 +748,6 @@ int sk_psock_msg_verdict(struct sock *sk, struct sk_psock *psock,
 }
 EXPORT_SYMBOL_GPL(sk_psock_msg_verdict);
 
-static int sk_psock_bpf_run(struct sk_psock *psock, struct bpf_prog *prog,
-			    struct sk_buff *skb)
-{
-	return bpf_prog_run_pin_on_cpu(prog, skb);
-}
-
 static void sk_psock_skb_redirect(struct sk_buff *skb)
 {
 	struct sk_psock *psock_other;
@@ -811,7 +805,7 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
 		skb->sk = psock->sk;
 		skb_dst_drop(skb);
 		skb_bpf_redirect_clear(skb);
-		ret = sk_psock_bpf_run(psock, prog, skb);
+		ret = bpf_prog_run_pin_on_cpu(prog, skb);
 		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
 		skb->sk = NULL;
 	}
@@ -898,7 +892,7 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 	if (likely(prog)) {
 		skb_dst_drop(skb);
 		skb_bpf_redirect_clear(skb);
-		ret = sk_psock_bpf_run(psock, prog, skb);
+		ret = bpf_prog_run_pin_on_cpu(prog, skb);
 		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
 	}
 	sk_psock_verdict_apply(psock, skb, ret);
@@ -921,7 +915,7 @@ static int sk_psock_strp_parse(struct strparser *strp, struct sk_buff *skb)
 	prog = READ_ONCE(psock->progs.stream_parser);
 	if (likely(prog)) {
 		skb->sk = psock->sk;
-		ret = sk_psock_bpf_run(psock, prog, skb);
+		ret = bpf_prog_run_pin_on_cpu(prog, skb);
 		skb->sk = NULL;
 	}
 	rcu_read_unlock();
@@ -1014,7 +1008,7 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
 	if (likely(prog)) {
 		skb_dst_drop(skb);
 		skb_bpf_redirect_clear(skb);
-		ret = sk_psock_bpf_run(psock, prog, skb);
+		ret = bpf_prog_run_pin_on_cpu(prog, skb);
 		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
 	}
 	sk_psock_verdict_apply(psock, skb, ret);
-- 
2.25.1

