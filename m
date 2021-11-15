Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B2C451D8B
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349808AbhKPAbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:31:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345815AbhKOT3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:29:24 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F3AC06EDC5
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:24 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so64709pja.1
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=prto76o5NaUG7Oy5ZXSTMOw0etNhHLG6g7CRl2GWtBU=;
        b=Z0ZceQzqvbbgYPPV8/5fI6Vk/9g6ViMIMLfMK68iUT2mmGkZKa/QYlMXmCF3mKPJDA
         LbQQmv1dG88LtuVSEO36048wFnQ1OeM9piMm59oFHh9pv+4fLQudPqdrVgHBkM4iU4Ht
         KEEpIqpXOMKITAdx0s1A1yILKgOtIklHSf4XZDTB2ruyE0LsZEwyn3JKKYVdCTz5C/my
         NPT9nyOyKi5Rgy8qR6wkURKeCxc7i5YpxFjGBtZkuzHGmVXAQfnuVZLnAhmokQ/TL5AV
         SLgzNmIv4ahQIg4Mkf0eeuJwLaw5oEJ8zoMHPLf4J0Y9B7ruRpAAXFXfnu8sCIJSUPgW
         nsQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=prto76o5NaUG7Oy5ZXSTMOw0etNhHLG6g7CRl2GWtBU=;
        b=7kKjNJYDrLwg7TiWRs+ECaXfqJkxschL+Qr2wRi1/ZfI0n4L8YPfTuYaoLLkHLcST1
         BiwJPYo0nVWlIzBs5pvdn21Oa8wZiU8BncZnfIr2Ua4N18MlPilBqnSLi1cbrA+/tkGY
         icXpAoLUfrMauBSh+7prj0vkLk2iaKFiAMadbTN/1JCT61wOo70ybnuWhJqwidrG6cD/
         kDusUVXIzdkGmW0NT2383GzQLbKL9ovJdx3UeCvfDQ1Pf7PZ/Lry234yYK+RQTnywmP7
         NrlwyppD/LaFR9i5KHYT6ZKwpd3bK+WCX5SEvVp0rv/HPTzqKnhmXtx9XoMdKatql/qQ
         rnWg==
X-Gm-Message-State: AOAM532Fk3zrYnbV4oHlscxBAVDFRcEcoLJVlEXsNSVJAM8w7yMETAm3
        99W1+0xIy2qhO4ddf+kvySk=
X-Google-Smtp-Source: ABdhPJx9EAjjvuWPNVJX0gD0uhnObu+2FH8XsbZrauUdwt+HJMTboyC23yUzHGNcjAJNzDp2lq+MhA==
X-Received: by 2002:a17:90a:a083:: with SMTP id r3mr66481366pjp.55.1637003004353;
        Mon, 15 Nov 2021 11:03:24 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id f21sm11850834pfe.69.2021.11.15.11.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 11:03:24 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Subject: [PATCH net-next 18/20] tcp: check local var (timeo) before socket fields in one test
Date:   Mon, 15 Nov 2021 11:02:47 -0800
Message-Id: <20211115190249.3936899-19-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115190249.3936899-1-eric.dumazet@gmail.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Testing timeo before sk_err/sk_state/sk_shutdown makes more sense.

Modern applications use non-blocking IO, while a socket is terminated
only once during its life time.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 33cd9a1c199cef9822ec0ddb3aec91c1111754c7..7b1886103556e1295d84378d5bcb0f0346651de0 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2399,10 +2399,10 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 			break;
 
 		if (copied) {
-			if (sk->sk_err ||
+			if (!timeo ||
+			    sk->sk_err ||
 			    sk->sk_state == TCP_CLOSE ||
 			    (sk->sk_shutdown & RCV_SHUTDOWN) ||
-			    !timeo ||
 			    signal_pending(current))
 				break;
 		} else {
-- 
2.34.0.rc1.387.gb447b232ab-goog

