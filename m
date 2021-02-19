Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBF1320214
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 01:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhBTAAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 19:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbhBTAAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 19:00:05 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01D8C0617A7;
        Fri, 19 Feb 2021 15:58:51 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id s3so3517011otg.5;
        Fri, 19 Feb 2021 15:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6qLL1pD8eAIF22astLsGTIt6XsSRTHADcChvDI82gwA=;
        b=LeUyFuFD4ty+oMYXkqqiWVXUOmgbhhcE3rSv8uLcwvw0uwtx6LhcwB8CvBu2ielckE
         pxCXgdOGeov/JQaHCHPTm1j9oGHiqkCUJKD0kd+Z4M+OlW/ZAHZibivvI6E2uFC1d/qK
         YJNYdKXI6ws8GvRvJzBe+bVzPslol7U7ItzD+Uru1bfNs6m3TPdGgInpnvNJw560zWGp
         m90+X4VoQRnRYJBwNFe8xYOHCDn2aYCu/H3GDsd/dM3QGM75Vio3W9QUH1/mv/4tsgFA
         DTvjpFZ/YxbhPymybNHGiGVDB6hOr4KJ772q9jlMsSNWlfmBbBmRlFpiad5DQti3YdLC
         Gm7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6qLL1pD8eAIF22astLsGTIt6XsSRTHADcChvDI82gwA=;
        b=fcllUZVPdaEIfMfXETE3vjEPBkPqzkZ+r96iJOnuXTrtts828bCbf2/eDugILDdFgB
         z1yLKrZrSQKK5CIdZ7Qm5qVuactGJoF7CeCgQDtiPQMJChCr2AXFMGOsaZSmo5weIq1B
         3l/5PUyfoGmS68ZYb7qEi/P2sSsAxaM+41QSao6Vvp0GNdFYTQ5dH2p01M66sc5ZdGB7
         o/aZnTi8Pit7t+TRohD2QgNLZXIcs+wvhgMFuL52WUpuN4Hl6y4WTktFx+1+6Q7ViztU
         gIzpKEwxcLmydfRA4rziEC6AoIZ7eKn7uIqaNnKAIY0WoyWtCEKoitOToqBGVFBpeWvZ
         UdSg==
X-Gm-Message-State: AOAM533Jx1NBywcDLcGlbC+T28xzl636Pa1KA6ASFiVyHrsIGgeh0/3N
        ze6Orpb/2WJCyDz0vqkKkgybLZVfZG8s+w==
X-Google-Smtp-Source: ABdhPJw7ymcPBoBnL18tl3Uk8LhnxEbMeU1HRO2aIhyLA0LBiMxqxgwJyipeHnDuOsPVTb8Z029cyA==
X-Received: by 2002:a05:6830:3482:: with SMTP id c2mr8771537otu.59.1613779131098;
        Fri, 19 Feb 2021 15:58:51 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1d72:18:7c76:92e4])
        by smtp.gmail.com with ESMTPSA id h11sm2064186ooj.36.2021.02.19.15.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 15:58:50 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [Patch bpf-next v5 8/8] skmsg: get rid of sk_psock_bpf_run()
Date:   Fri, 19 Feb 2021 15:58:36 -0800
Message-Id: <20210219235836.100416-9-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210219235836.100416-1-xiyou.wangcong@gmail.com>
References: <20210219235836.100416-1-xiyou.wangcong@gmail.com>
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

