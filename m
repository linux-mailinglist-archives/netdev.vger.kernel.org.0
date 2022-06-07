Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 124FB54049C
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 19:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345494AbiFGRR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 13:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345496AbiFGRRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 13:17:52 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D274A6F4BB
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 10:17:49 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id q18so15328291pln.12
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 10:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f6j9GBN0w5grHc+ifaZiPx7VIaBCMhY99fjc3Bz/5zI=;
        b=G6P0Xr0cF1NBYFa+klXp4PxxpBCPgLqM6JflQUvijurfXAZLwqsLfK0dBnayS19rfJ
         TZz6S3/GlHgZ6/toE1A2xOrdElV9Pzlulwau21bKa7dGkHuajaSr3W/hBdvRfIWfDS3K
         0axMkFipWmrg1ADwh6bm1Jv2bJfV11ZChL/r4+vxCR2rNmZMkpAkAHL1937Djzjz4la7
         509L7QGSjfmMEZAjWFr+lhIKTbbiOSMWww7K5lm98iSKLjSj2THcq1doGDh/vV01Idc4
         +0LiLcX1oaF2V8vDCrUPm3XuJrXI9bmxPlYdJ9iRLb1jWEKROGfMB8G/tnUvWMpIEHuy
         GEOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f6j9GBN0w5grHc+ifaZiPx7VIaBCMhY99fjc3Bz/5zI=;
        b=gGAG9dMpnASxODBQJ57P2wGcq1+hQopXTZTc9IH8PhFKuDeE1rM51qTq27vgvNTOwY
         EHXk6Cd9dqjMmmvttvDh27QlNp/aLMwd7OcVJwKsaoKvn1IetgyRW8u1MP7ilAmIPlWu
         Oxq9CVGy4MDCYRj4f3aFqunCjiGyNvvQMMQvmjv+dtUByvrJllEegojFibEYs+uI8KPt
         xINgNdoDOHBiytF3ntQPnrL9MXuSRPjLFJ9ErAXox4DwTH2rn8COTLFMM/IjF6wAfASt
         ZpAtrE2Ezkm7VXFTjn1mWbHxWs5Zq0P/1a2FFE4ylLB2Sj+iKgMZ2fHhR4/j7QR32EcT
         mspg==
X-Gm-Message-State: AOAM532ITXWlJng7LJRZRiwjKch66Tm40rXK3kT6BMaqzrb0fFmFa9fo
        A6mG514oqfqj5VHuN6E3KcCWJ8uqeDA=
X-Google-Smtp-Source: ABdhPJzLBHtpNQ1mGkbMQYMBWoZdj4RFgPr4nFiEvamkCEerwD6Lu34QI1eFLJ/50EfnwNaHB4DmYg==
X-Received: by 2002:a17:90a:d58d:b0:1e0:adde:a7f8 with SMTP id v13-20020a17090ad58d00b001e0addea7f8mr68312495pju.74.1654622269301;
        Tue, 07 Jun 2022 10:17:49 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:191a:13a7:b80a:f36e])
        by smtp.gmail.com with ESMTPSA id d4-20020a621d04000000b0051b930b7bbesm13001616pfd.135.2022.06.07.10.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 10:17:48 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 5/8] af_unix: use DEBUG_NET_WARN_ON_ONCE()
Date:   Tue,  7 Jun 2022 10:17:29 -0700
Message-Id: <20220607171732.21191-6-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220607171732.21191-1-eric.dumazet@gmail.com>
References: <20220607171732.21191-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

Replace four WARN_ON() that have not triggered recently
with DEBUG_NET_WARN_ON_ONCE().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/unix/af_unix.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 654dcef7cfb3849463be9d905ae625319fbae406..ae254195aac87f196a93853443048b40e332cc60 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -302,7 +302,7 @@ static void __unix_remove_socket(struct sock *sk)
 
 static void __unix_insert_socket(struct sock *sk)
 {
-	WARN_ON(!sk_unhashed(sk));
+	DEBUG_NET_WARN_ON_ONCE(!sk_unhashed(sk));
 	sk_add_node(sk, &unix_socket_table[sk->sk_hash]);
 }
 
@@ -554,9 +554,9 @@ static void unix_sock_destructor(struct sock *sk)
 		u->oob_skb = NULL;
 	}
 #endif
-	WARN_ON(refcount_read(&sk->sk_wmem_alloc));
-	WARN_ON(!sk_unhashed(sk));
-	WARN_ON(sk->sk_socket);
+	DEBUG_NET_WARN_ON_ONCE(refcount_read(&sk->sk_wmem_alloc));
+	DEBUG_NET_WARN_ON_ONCE(!sk_unhashed(sk));
+	DEBUG_NET_WARN_ON_ONCE(sk->sk_socket);
 	if (!sock_flag(sk, SOCK_DEAD)) {
 		pr_info("Attempt to release alive unix socket: %p\n", sk);
 		return;
-- 
2.36.1.255.ge46751e96f-goog

