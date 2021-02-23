Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81042323109
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 19:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbhBWSvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 13:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233982AbhBWSvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 13:51:12 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D50C061797;
        Tue, 23 Feb 2021 10:49:56 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id e45so7384224ote.9;
        Tue, 23 Feb 2021 10:49:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6T3AWG4LjtRLRkHZfzuCh9HwXL4OsFKSPyQsAuIA2VE=;
        b=PvqBcee89Q2rR7qxg8xwHmCRv31OhF+Hp2Oy4T+QxPlzfYo6ayS8Rsr165G9lUt5e8
         8SsG7Fz+H0UipUtxPmXq0MpUL09NEgFF5Wi5f307GqekPwsRKBRE2XsbwuA3eO9xY1Xi
         dI6E2PIyt98zeuBnQKevxaH83cvdeS7A1dSMbcupQ3M1gkgXTG7z65c6DVO9GyKg46wO
         R/56d7J1ZX+e/OAd+1f9JIYc2dqR0ZiPvM9PI6mlCQrZbPkqkI9Spik+ue/9SWQ2I+hZ
         mEVdfNc68q3r1NUbDp4PE3iGR+tEXVQsDGMq+xVjQ0jzmf+pacPf6b72qWob0mient85
         Aosw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6T3AWG4LjtRLRkHZfzuCh9HwXL4OsFKSPyQsAuIA2VE=;
        b=gLfM6ghLmKZhdEw7Kbgmn8pPQVhzKPWnV7SftDLF3ktdle/X1oYQQr0+LkvnIa0CBK
         4unzsmIA2DVXCCctxdJz10j4KOp/KTW/g/TDz7+wMsZKdzxTTLMCPF9SDIJGJBeOfuMp
         X1kArAyQ1x417A+sOxqGMjree5Yxr+eqhKXhlvI5cqE6B53FtFmHAYx/GBcL3cY/FSs7
         d3YdeombVI26u83RDVrPtj1QeQOwCDiOzAdUIDSbVHwVaRsy+XxtotE7i7BtPc3X+Kdn
         RNNUX6a0Ae5EeZKwwNI+5l1jd1unlBpcKQQLgkMLpHnK0yraxKCv/tnDfm602D4Xb8zU
         B9BQ==
X-Gm-Message-State: AOAM532mVEgKVrCIYhPOjHxhkN+HZo23QKeuma/Ab/0OLMa14qshz4kh
        tQbdKyG9x1MCqWRzel7edeWKFTWjudrMUQ==
X-Google-Smtp-Source: ABdhPJzVaOS9YwibmhHMg8SX1Pr5hyWPhPijClkcoDaEIGjd/aFnedVpjovtfDxFasuX4wx7oL+XvA==
X-Received: by 2002:a05:6830:1682:: with SMTP id k2mr21295954otr.154.1614106195823;
        Tue, 23 Feb 2021 10:49:55 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:4543:ab2:3bf6:ce41])
        by smtp.gmail.com with ESMTPSA id p12sm4387094oon.12.2021.02.23.10.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 10:49:55 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v7 8/9] skmsg: get rid of sk_psock_bpf_run()
Date:   Tue, 23 Feb 2021 10:49:33 -0800
Message-Id: <20210223184934.6054-9-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223184934.6054-1-xiyou.wangcong@gmail.com>
References: <20210223184934.6054-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

It is now nearly identical to bpf_prog_run_pin_on_cpu() and
it has an unused parameter 'psock', so we can just get rid
of it and call bpf_prog_run_pin_on_cpu() directly.

Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/skmsg.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 46e29d2c0c48..07f54015238a 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -749,12 +749,6 @@ int sk_psock_msg_verdict(struct sock *sk, struct sk_psock *psock,
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
@@ -812,7 +806,7 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
 		skb->sk = psock->sk;
 		skb_dst_drop(skb);
 		skb_bpf_redirect_clear(skb);
-		ret = sk_psock_bpf_run(psock, prog, skb);
+		ret = bpf_prog_run_pin_on_cpu(prog, skb);
 		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
 		skb->sk = NULL;
 	}
@@ -899,7 +893,7 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
 	if (likely(prog)) {
 		skb_dst_drop(skb);
 		skb_bpf_redirect_clear(skb);
-		ret = sk_psock_bpf_run(psock, prog, skb);
+		ret = bpf_prog_run_pin_on_cpu(prog, skb);
 		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
 	}
 	sk_psock_verdict_apply(psock, skb, ret);
@@ -922,7 +916,7 @@ static int sk_psock_strp_parse(struct strparser *strp, struct sk_buff *skb)
 	prog = READ_ONCE(psock->progs.stream_parser);
 	if (likely(prog)) {
 		skb->sk = psock->sk;
-		ret = sk_psock_bpf_run(psock, prog, skb);
+		ret = bpf_prog_run_pin_on_cpu(prog, skb);
 		skb->sk = NULL;
 	}
 	rcu_read_unlock();
@@ -1019,7 +1013,7 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
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

