Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02120543856
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245076AbiFHQEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244799AbiFHQEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:04:48 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9244327CD6A
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 09:04:46 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id z17so18705727pff.7
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 09:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3qmIlwzFDR6fdFmAUyrSAM3P3hLoEa2XcvXoRMhOA5Y=;
        b=DtUhv3nZZG1hiufCai0WOO4f6QTDVj0gx8ZyoXMfMP/GhqQHK/nBp8CdH1LNr40cdh
         LcgWTcrjQE5CFZ9cvvwdER8Ggip0pgWsiLFlmls5oMk1A4KyQEmdCRHnFO1pFnAPd5zk
         /7rAmT9hzQMsEp4Q0YgQCikLkQxDlXg5/jlk/MNrKPSTmRMeHqZJi5qhj9g3d7bi68Sz
         0R90Gnd3aiZVEtDuhfixil04jsGqEGGt6nxdasJM8uL4x3X1IpuGi7S/eL3rnaK2DGE7
         s6YwnmVpa+hIJeMuC/Cfko/dVM0Sbu6DZY2F4CQ9UWsRNxIgOD4gCQmAVM44fR/X6UcT
         rr5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3qmIlwzFDR6fdFmAUyrSAM3P3hLoEa2XcvXoRMhOA5Y=;
        b=7YI3xFGUjEIeHYo5gf7j4quL+gqr858jHGf5Juodg6zPnztDC0lG0IEqxiN2DbMu8Y
         5UwvMnQF3uYSr9GsgVlnHfI6o8COJY3qkZVVu+QmwAqcZV7C5O2aMXEx2t7XydAe9ZKT
         RjY/wiUca/A0TwgLZHP+UQndVtmeoxOvo7z4QrMkuFsxfxO9OKfvov45RW4WqF1DUccT
         ujcyiQJEEzQ0Ks6WHL5RiS2iYuEJOgmn2yoxcQRU5A1Z7hNJXaNay6raFBk0PifhgUs6
         ++Vp0nEJxH81p4blCEw8vJxApSydQcyd6mvexZWVitf/JPOCSEQ3s4E38S5LvwsY7E6t
         AKQw==
X-Gm-Message-State: AOAM532VH8r02qqTj+jZYbbSiTAPP8juJ1NoiQHPgVBGcUMmxBSNnDuf
        +s2LI3T/niZfkn7WuFpj23oWOZqexr4=
X-Google-Smtp-Source: ABdhPJwCK+kIJbvZCk4DI6oEFrgZEqCrt80MPCBSMJ5VJVMLS+RgxiIJ2uWdCWjWa815BlnfG0Ud1w==
X-Received: by 2002:a63:5610:0:b0:3f2:7e19:1697 with SMTP id k16-20020a635610000000b003f27e191697mr30232043pgb.74.1654704285588;
        Wed, 08 Jun 2022 09:04:45 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id ju10-20020a17090b20ca00b001df264610c4sm18622019pjb.0.2022.06.08.09.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 09:04:45 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 3/8] net: use WARN_ON_ONCE() in inet_sock_destruct()
Date:   Wed,  8 Jun 2022 09:04:33 -0700
Message-Id: <20220608160438.1342569-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220608160438.1342569-1-eric.dumazet@gmail.com>
References: <20220608160438.1342569-1-eric.dumazet@gmail.com>
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
could flood the syslog.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/af_inet.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 93da9f783bec52e4bda6213dc78ef3820e180cc4..30e0e8992085d5d4ac5941b5f3a101f798588be9 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -148,10 +148,10 @@ void inet_sock_destruct(struct sock *sk)
 		return;
 	}
 
-	WARN_ON(atomic_read(&sk->sk_rmem_alloc));
-	WARN_ON(refcount_read(&sk->sk_wmem_alloc));
-	WARN_ON(sk->sk_wmem_queued);
-	WARN_ON(sk_forward_alloc_get(sk));
+	WARN_ON_ONCE(atomic_read(&sk->sk_rmem_alloc));
+	WARN_ON_ONCE(refcount_read(&sk->sk_wmem_alloc));
+	WARN_ON_ONCE(sk->sk_wmem_queued);
+	WARN_ON_ONCE(sk_forward_alloc_get(sk));
 
 	kfree(rcu_dereference_protected(inet->inet_opt, 1));
 	dst_release(rcu_dereference_protected(sk->sk_dst_cache, 1));
-- 
2.36.1.255.ge46751e96f-goog

