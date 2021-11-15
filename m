Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49D6451D94
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344645AbhKPAbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345780AbhKOT3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:29:21 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB72CC0BC9A1
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:04 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so647181pjb.1
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xA3mbQCzAKWlSuH0DmW+A1gaMDFMbAKmKwd+iWxzBC0=;
        b=GW0HSdcghBGKTtSHZ3iQvlPc1s8tHjwG4PO9nDsrrG6c9S1MLOMmdZHb6MuGuxR5Wz
         WGVEpsGzc+0+blqJQdFsvQshAvVoivF7W+QzMdvdj+xYtxZvVGZWUEdx1195vb4Atqv5
         HCgouz/SvhTSyR0Fjr1qmZ5avgkIRziDzmbC1hxcTDcTq2G1jngFCtN88sLXL3dP41lt
         A1/LxWdjKQtMgoHRZjetqr4vazQWqmBzv7obuvbCkX+kVxlYWtixeO65eGTGeIxkbWj8
         tYhLJdl2NYSCnXlvk1YC7lQ9c9vQfnIZEYht/lx58Tr0/hC8rtKqFxcvyDKAhvrpurQV
         VVMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xA3mbQCzAKWlSuH0DmW+A1gaMDFMbAKmKwd+iWxzBC0=;
        b=ueuJxSD7+ceHGdAANgcyUzQULBtljZaTNsp9RkbHFF1CxpX41FtbfkWwCuxH8Bf7fT
         5CV+PbiYqsXiACs900w9BJupOa0tqTpI06ZM+ctbnLx5R0Zv935RS/QSlMMj8pqmWrn8
         IqKk/ZJAZfZbh6BVXJrwZnMQKkG4Ed4RjAZdfI7D7OI/ePjsxi9cbC3aJdaVVu2sygtS
         e1XUZV6WFhnKyC1btP5pWB+KL21yKYPU7Vdhq9DzdFkuym8/XdV2M/Gefd3kR/ATB7ZM
         E9P85Poev6fUL/v6aq5LyaAJCZr+YqCicHO5RijbUy6CvV7tUtmum4eKuyzTqWMJ5nCM
         x5qA==
X-Gm-Message-State: AOAM533UU6IVyKgYbmLSTdtg96gk38UB8Lc1d64vFN+raasuZye6d4K5
        I3OsLzxf40J52VkSTHpDTlQ=
X-Google-Smtp-Source: ABdhPJzinRl9TuuR6kgew6FuPs0MoctCWRKcPX5He5k70HrUZD+YvYF+k2uTp1PZJEFne4D12eONlQ==
X-Received: by 2002:a17:90b:3b8d:: with SMTP id pc13mr1031531pjb.112.1637002984345;
        Mon, 15 Nov 2021 11:03:04 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id f21sm11850834pfe.69.2021.11.15.11.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 11:03:03 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Subject: [PATCH net-next 03/20] tcp: small optimization in tcp_v6_send_check()
Date:   Mon, 15 Nov 2021 11:02:32 -0800
Message-Id: <20211115190249.3936899-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115190249.3936899-1-eric.dumazet@gmail.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

For TCP flows, inet6_sk(sk)->saddr has the same value
than sk->sk_v6_rcv_saddr.

Using sk->sk_v6_rcv_saddr increases data locality.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/tcp_ipv6.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 551fce49841d7f53a111b0435855634cece2b40a..1f1a89f096de9f77ab1bd2d871eb90a3f12e91e0 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1893,9 +1893,7 @@ static struct timewait_sock_ops tcp6_timewait_sock_ops = {
 
 INDIRECT_CALLABLE_SCOPE void tcp_v6_send_check(struct sock *sk, struct sk_buff *skb)
 {
-	struct ipv6_pinfo *np = inet6_sk(sk);
-
-	__tcp_v6_send_check(skb, &np->saddr, &sk->sk_v6_daddr);
+	__tcp_v6_send_check(skb, &sk->sk_v6_rcv_saddr, &sk->sk_v6_daddr);
 }
 
 const struct inet_connection_sock_af_ops ipv6_specific = {
-- 
2.34.0.rc1.387.gb447b232ab-goog

