Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C778851767B
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 20:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386851AbiEBS1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 14:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386854AbiEBS1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 14:27:32 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078F0767D;
        Mon,  2 May 2022 11:24:02 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id m11so15984240oib.11;
        Mon, 02 May 2022 11:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3krU9qzD3sAu/Akj2KCT7vAhjMYIV/YGWxHztC1aoj0=;
        b=UTdc+l77Ix0qbAdFJK9F9V8JfkMqlVRYOt1TkF4gZlc7xMQl2vsBVGej9IyqGQSgpK
         4hpG5+PsS7GUD9wwMGfYisVAXwfK/y6hlARo19Fb5YPTEnbFaS5jM4OX5j/AJnuwUzTy
         OCwayddK+Z28khr+3oK4N9CI2Fw/RQtAtj1aC8qSrXsja6rHcQZzfqbcOmg6DZSL5HBf
         cN/jmqqjPP79Oc1U4FjIbjf/3aIq64UFlFmtobJRuH1vWCWYHH/x9sLsAzYiuqZOw66+
         Q+p1HEHu/ivIPEQP1hArZOBwSsRkw8NTP3EsYYvrSG0YQWL0Y4FF+UbQBSuaqDD8v9P+
         rMCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3krU9qzD3sAu/Akj2KCT7vAhjMYIV/YGWxHztC1aoj0=;
        b=nica1ifAMcaNkNRd1Im1glUI/4foO5lygAgIzwoWBu30Xf3Hm+RekN0CqeFu9p/q8p
         oCbkdrNTJ+DS4yU3O0UOgFKAG9kyJh3eWFfDTrsYbkSpLzTK8rDEfKCLHkOpdHxNvau4
         7qd7UGsB7iQGEqwhxFCn3wkXdaglFVzhVOYLUd9cLHxf6oNlEa6yG0m5C1QV6O4Q54IJ
         coQUaDAPcSZYBPYUsU9oE3wbp4pt/s3XPwhBukLNwPqtLkNSAHSZDVY869NvWEQKCjLW
         nR0D6ohe03L4QjB/RtJWeOqyuVk/IWBOKen42GbazXY8rIkKesRtO1Y9/+f77HAGXAq8
         2Ltw==
X-Gm-Message-State: AOAM531cA7PwQ9BvX9N39mJDLaZyUidYrqjMaS/zdebHa4jNEdPjEJQf
        AjwHkGfQj5VRKffuLtRY47m8U47nUm4=
X-Google-Smtp-Source: ABdhPJxv0QiWgwj59XXLxWxSoaeOHFbOi1Qop3CqhbkjW5/9UXUCG2+N8YKtFFaM1lr7iNiT2Xsdzg==
X-Received: by 2002:a05:6808:17a6:b0:325:b364:4e2f with SMTP id bg38-20020a05680817a600b00325b3644e2fmr227723oib.74.1651515842271;
        Mon, 02 May 2022 11:24:02 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:7340:5d9f:8575:d25d])
        by smtp.gmail.com with ESMTPSA id t13-20020a05683014cd00b0060603221245sm3129915otq.21.2022.05.02.11.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 11:24:01 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: [Patch bpf-next v2 3/4] skmsg: get rid of skb_clone()
Date:   Mon,  2 May 2022 11:23:44 -0700
Message-Id: <20220502182345.306970-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220502182345.306970-1-xiyou.wangcong@gmail.com>
References: <20220502182345.306970-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

With ->read_skb() now we have an entire skb dequeued from
receive queue, now we just need to grab an addtional refcnt
before passing its ownership to recv actors.

And we should not touch them any more, particularly for
skb->sk. Fortunately, skb->sk is already set for most of
the protocols except UDP where skb->sk has been stolen,
so we have to fix it up for UDP case.

Cc: Eric Dumazet <edumazet@google.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/core/skmsg.c | 7 +------
 net/ipv4/udp.c   | 1 +
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 50405e3eda88..3ff86d73672c 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -1166,10 +1166,7 @@ static int sk_psock_verdict_recv(struct sock *sk, struct sk_buff *skb)
 	int ret = __SK_DROP;
 	int len = skb->len;
 
-	/* clone here so sk_eat_skb() in tcp_read_sock does not drop our data */
-	skb = skb_clone(skb, GFP_ATOMIC);
-	if (!skb)
-		return 0;
+	skb_get(skb);
 
 	rcu_read_lock();
 	psock = sk_psock(sk);
@@ -1182,12 +1179,10 @@ static int sk_psock_verdict_recv(struct sock *sk, struct sk_buff *skb)
 	if (!prog)
 		prog = READ_ONCE(psock->progs.skb_verdict);
 	if (likely(prog)) {
-		skb->sk = sk;
 		skb_dst_drop(skb);
 		skb_bpf_redirect_clear(skb);
 		ret = bpf_prog_run_pin_on_cpu(prog, skb);
 		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
-		skb->sk = NULL;
 	}
 	if (sk_psock_verdict_apply(psock, skb, ret) < 0)
 		len = 0;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index b8cfa0c3de59..71c2c147f2d0 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1817,6 +1817,7 @@ int udp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 			continue;
 		}
 
+		WARN_ON(!skb_set_owner_sk_safe(skb, sk));
 		used = recv_actor(sk, skb);
 		if (used <= 0) {
 			if (!copied)
-- 
2.32.0

