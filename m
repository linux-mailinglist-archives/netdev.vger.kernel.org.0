Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29D662A3E6
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 22:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbiKOVUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 16:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbiKOVTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 16:19:55 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA842315D
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 13:19:46 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id m7-20020a05600c090700b003cf8a105d9eso49072wmp.5
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 13:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O4voqyqcbC1mGHkdqsComHC8t7xgb7NXhy1RVgGBazg=;
        b=YwulyWQxFTlK3VttrI24bnCHMwwrAe/1KahE3WGjJJ8WL+Mn6T6KYdNtBFYzBrXVNe
         oixrbUxkVsQ8hKzZKAfCUR8e2gU1/zZh4Znnn/m6JVn16jMs4aHIKoN5e+ItM+O/QD5q
         nwnw6L5a838kRS4xWLMxlqGhgJdX+okXu9G8UHEhOiJP+qOfM6byfBjbj5ON47N2Mb9h
         OAcL8RGAxgWeGT+AJ2stN7SFs2h1oZIDkT2R0PRD11+TMig1X6O7XBR3fBk2Voggbsa+
         uS5HQKa+C2PmcW5c7nbn/q/qnwb2RescA5UjxaKRR3PwsrIxhda1rrCRZpUtpX01nn7+
         Bb0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O4voqyqcbC1mGHkdqsComHC8t7xgb7NXhy1RVgGBazg=;
        b=jg2D1U1IHuTbH3a30GAShhuZ9CFJ+LeeKKL+MnKGWtEzd+rubpiCC/ZIWg7/udEvr9
         pLA3ke4YZTxYe/XTtHIbSNERHkWIyFrZlnjfsBkZk3MglTcCdag+FHgvwa1Gtrx8DXpL
         F/xSHD/O0T1wCnZj8GniqBBI05UMHHswJrWWkWavmO+NwX+wqJtXOFSE3OgsRSabb5Km
         gNI4IlBlxSHFTb78Lp3TrrmxCbrqD9522ZJj6yxrQLMqS23UKaCfoVS0aio83snG0OI8
         kScher/NFXYfFle+WgVjlgVWpdruom2NcJcA0gTceG6jvqzwfakyn+6aSuDUwOJX9h9S
         zrGg==
X-Gm-Message-State: ANoB5pkqobFwdTiGn450vFJ5GyakOmAq4Z4UJUbQBODAdVnR0srA/SQ9
        YtQOb2gOd6hnXmCFGYk4YLKoYQ==
X-Google-Smtp-Source: AA0mqf7aA0CcV03VaLTA+Oml/BIjII7CGjdUTmxKQVmCFUrp5XXH63ryVWRQy3gyvMj0WyCKfRYNzQ==
X-Received: by 2002:a05:600c:188a:b0:3cf:8e62:f769 with SMTP id x10-20020a05600c188a00b003cf8e62f769mr147561wmp.52.1668547158791;
        Tue, 15 Nov 2022 13:19:18 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n41-20020a05600c502900b003c65c9a36dfsm17201487wmr.48.2022.11.15.13.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 13:19:18 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Dmitry Safonov <dima@arista.com>, Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org
Subject: [PATCH v4 4/5] net/tcp: Do cleanup on tcp_md5_key_copy() failure
Date:   Tue, 15 Nov 2022 21:19:04 +0000
Message-Id: <20221115211905.1685426-5-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221115211905.1685426-1-dima@arista.com>
References: <20221115211905.1685426-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the kernel was short on (atomic) memory and failed to allocate it -
don't proceed to creation of request socket. Otherwise the socket would
be unsigned and userspace likely doesn't expect that the TCP is not
MD5-signed anymore.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 net/ipv4/tcp_ipv4.c |  9 ++-------
 net/ipv6/tcp_ipv6.c | 15 ++++++++-------
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 4bdb6e1ecaf3..deabf3309865 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1628,13 +1628,8 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 	addr = (union tcp_md5_addr *)&newinet->inet_daddr;
 	key = tcp_md5_do_lookup(sk, l3index, addr, AF_INET);
 	if (key) {
-		/*
-		 * We're using one, so create a matching key
-		 * on the newsk structure. If we fail to get
-		 * memory, then we end up not copying the key
-		 * across. Shucks.
-		 */
-		tcp_md5_key_copy(newsk, addr, AF_INET, 32, l3index, key);
+		if (tcp_md5_key_copy(newsk, addr, AF_INET, 32, l3index, key))
+			goto put_and_exit;
 		sk_gso_disable(newsk);
 	}
 #endif
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 3e3bdc120fc8..64788cfbefc7 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1376,13 +1376,14 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 	/* Copy over the MD5 key from the original socket */
 	key = tcp_v6_md5_do_lookup(sk, &newsk->sk_v6_daddr, l3index);
 	if (key) {
-		/* We're using one, so create a matching key
-		 * on the newsk structure. If we fail to get
-		 * memory, then we end up not copying the key
-		 * across. Shucks.
-		 */
-		tcp_md5_key_copy(newsk, (union tcp_md5_addr *)&newsk->sk_v6_daddr,
-				 AF_INET6, 128, l3index, key);
+		const union tcp_md5_addr *addr;
+
+		addr = (union tcp_md5_addr *)&newsk->sk_v6_daddr;
+		if (tcp_md5_key_copy(newsk, addr, AF_INET6, 128, l3index, key)) {
+			inet_csk_prepare_forced_close(newsk);
+			tcp_done(newsk);
+			goto out;
+		}
 	}
 #endif
 
-- 
2.38.1

