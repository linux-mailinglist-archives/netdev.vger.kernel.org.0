Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5939E38D729
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 21:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhEVTP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 15:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbhEVTPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 15:15:54 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2386C0613ED;
        Sat, 22 May 2021 12:14:29 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id e15so6009054plh.1;
        Sat, 22 May 2021 12:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DV0T/Qr/nJx8jfvW3ukFjANC4TKgQt+cqMliLspYgy0=;
        b=ZE1N44WA4KPSr0Vi0rHkh0It84dEXbFFoW8rskLDxjORPbjDfvUT71qtgrQcQQj+5s
         pRNDdw2EdjqajmvFexzct+5igNBSPNQC9EUZZjvlhaqi+t9WQUDcNzXz77vJRZZCn01A
         5fnNf6UH4TVIbzjwAhMKI3uGePVbe8uiuKfAIKIsKatEuzdU8K9zC8TK+8U7fElXriSs
         Bi4/HOIcdmv7iPDeLVh7rCE3rhYgVbdMHrtSkc9lZox4FLHmQ4GRb3pKi5Q5lUGge43g
         m/UQIOrl0TYHHxx9vxnfuSiB0vNw9ocYA87pJ2wN7Tv+t6b2sAV7NrdVqR1XgEyusP6x
         O+Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DV0T/Qr/nJx8jfvW3ukFjANC4TKgQt+cqMliLspYgy0=;
        b=BjhCxSUGQ89pUgFsImxaPSM0/9+/SN16ztd0cNnULlmm3c3EF77GnX39/Uo4qED1iQ
         rsWe1Dydyt44Dn0dSr5ja6uWxbq6nnLKKIp2VtjYZC8w7Oap6VAm2WvvUHO2Z5n2WITE
         Sy70ExeWIR6I6WFfNlhy2ki8sw9l5+vGZyFeWs0GinBMFNojg8f2W0hmJt1wEfg0VkLq
         XIyEMjjSueX0LqEJa3N8/6VQHDAjgvXM52U9AyMl1cTbuq5gDH4BL5pKJefXMk2x2Gcx
         rfgkq8WDKWhN5K0i0k42UcMV3ZWy4ejmhg/ls9kUjWJAwSJY2DnxrVAPUDffVZDJFs77
         RnEA==
X-Gm-Message-State: AOAM531moFcb7th9+kmfhgGswZAWZrqa2czKNKV5wG0a/qn+KAw+eM9x
        gpOy5zTsgVF9YAN0s5jUwXKyMYcT+xNq/g==
X-Google-Smtp-Source: ABdhPJy7PKe6Msqh0+RN81iuU8fe0VxxYtUjCZz6JweSulFHGqMRrkIQPzViGZ6qJkNCYHsli2j+Tw==
X-Received: by 2002:a17:90a:17a6:: with SMTP id q35mr17017410pja.118.1621710869228;
        Sat, 22 May 2021 12:14:29 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:14cd:343f:4e27:51d7])
        by smtp.gmail.com with ESMTPSA id 5sm6677531pfe.32.2021.05.22.12.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 May 2021 12:14:28 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf v2 3/7] udp: fix a memory leak in udp_read_sock()
Date:   Sat, 22 May 2021 12:14:07 -0700
Message-Id: <20210522191411.21446-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210522191411.21446-1-xiyou.wangcong@gmail.com>
References: <20210522191411.21446-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

sk_psock_verdict_recv() clones the skb and uses the clone
afterward, so udp_read_sock() should free the skb after using
it, regardless of error or not.

This fixes a real kmemleak.

Fixes: d7f571188ecf ("udp: Implement ->read_sock() for sockmap")
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/ipv4/udp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 15f5504adf5b..e31d67fd5183 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1798,11 +1798,13 @@ int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
 		if (used <= 0) {
 			if (!copied)
 				copied = used;
+			kfree_skb(skb);
 			break;
 		} else if (used <= skb->len) {
 			copied += used;
 		}
 
+		kfree_skb(skb);
 		if (!desc->count)
 			break;
 	}
-- 
2.25.1

