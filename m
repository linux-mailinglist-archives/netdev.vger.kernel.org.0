Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E81654049B
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 19:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344627AbiFGRRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 13:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345494AbiFGRRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 13:17:47 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558F44E3BF
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 10:17:46 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id cx11so16206211pjb.1
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 10:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LCo1XE9x3JPvz7KT7k6B+icHFHtfZ+pjZYOXW3MVAf8=;
        b=jk/f/OqBxwMmQVJZEfocRrRJuvFRSBp13RmLR6vGeun6q+ne4NGJSicVebtSdNs8xF
         xzjmMpbAkeA9rFKc5wwOlaMWOKSmwO2YtHpH0zv5EFwZuQ2aut1Ne33GwxIi811frCq+
         BvMi5RJ/8/7EIYiHEGUka4cQhHJXZUHo1rHdJtZeD6I3qk6czvEE0EgkV9sO31Jwl3bT
         jBR8fsMlfIZ6BKKYEE2b+9iWAuxsjovwSdCyXwa7KIT+5FfYRTIgtkkqZN2utMotzvvG
         2U5ZZyQ1rJXUJiINpwc6dwWqIrydxrOwULP4zRk+wx4b2LuFoxi7955R28euFFhbiCUh
         drIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LCo1XE9x3JPvz7KT7k6B+icHFHtfZ+pjZYOXW3MVAf8=;
        b=x6+StwClqBg6Zexwh5GDsZs/BTTGuoBvkZxNxHlhWNMQnqCNJdnzfUhZbQjFEBzVkj
         NMeT2DD1d3D74zHpUe4f7nXiVVhdtRfyHmCJwTbXpjFBpiHjca8ciRnCKDff3jiTIlSm
         M+/spLRx90cYFCJo+TdOrtUDkwS35Y9xVbWhy/tDYE7E4XEDv81xVyNOrlRhIsQUlHr3
         JIGrMvqk1vI6LyzpgFzqpR1qofEEknYUXMQCDHlu+C+RV/sLD3LFD5ODhYrqw/zaIXUH
         AK/McwBsmpOq/QZN4MHNgaBpSjClV8F9Xj0U3LGjjGxh1rlYMCIiB7q6meXA5Rr4aAHB
         cunw==
X-Gm-Message-State: AOAM533bDLmtfPoA6ZJafW0aOljZBRwRpdpoCA2ll8zteGJ4tRM6qGVI
        mgY84VATZYKsh/oA8c9nPB8=
X-Google-Smtp-Source: ABdhPJxkxMSzg1anFMSp4YvrjgxHZX/H9qpbdNXMhWjAdCVZJXz7eBKzwRn0iD8UnQbP6y2zXxId+w==
X-Received: by 2002:a17:902:e78f:b0:163:7572:f83f with SMTP id cp15-20020a170902e78f00b001637572f83fmr30725239plb.60.1654622265876;
        Tue, 07 Jun 2022 10:17:45 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:191a:13a7:b80a:f36e])
        by smtp.gmail.com with ESMTPSA id d4-20020a621d04000000b0051b930b7bbesm13001616pfd.135.2022.06.07.10.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 10:17:45 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 3/8] net: use DEBUG_NET_WARN_ON_ONCE() in inet_sock_destruct()
Date:   Tue,  7 Jun 2022 10:17:27 -0700
Message-Id: <20220607171732.21191-4-eric.dumazet@gmail.com>
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

inet_sock_destruct() has four warnings which have been
useful to point to kernel bugs in the past.

However they are potentially a problem because they
could flood the syslog, and really only a developper
can make sense of them.

Keep the checks for CONFIG_DEBUG_NET=y builds,
and issue them once only.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/af_inet.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 93da9f783bec52e4bda6213dc78ef3820e180cc4..5ec85ffe1e13afb333e40819b2a5e60b003d44a7 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -148,10 +148,10 @@ void inet_sock_destruct(struct sock *sk)
 		return;
 	}
 
-	WARN_ON(atomic_read(&sk->sk_rmem_alloc));
-	WARN_ON(refcount_read(&sk->sk_wmem_alloc));
-	WARN_ON(sk->sk_wmem_queued);
-	WARN_ON(sk_forward_alloc_get(sk));
+	DEBUG_NET_WARN_ON_ONCE(atomic_read(&sk->sk_rmem_alloc));
+	DEBUG_NET_WARN_ON_ONCE(refcount_read(&sk->sk_wmem_alloc));
+	DEBUG_NET_WARN_ON_ONCE(sk->sk_wmem_queued);
+	DEBUG_NET_WARN_ON_ONCE(sk_forward_alloc_get(sk));
 
 	kfree(rcu_dereference_protected(inet->inet_opt, 1));
 	dst_release(rcu_dereference_protected(sk->sk_dst_cache, 1));
-- 
2.36.1.255.ge46751e96f-goog

