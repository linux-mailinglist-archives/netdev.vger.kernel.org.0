Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FDB4514BD
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 21:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349309AbhKOUMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 15:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345811AbhKOT3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:29:24 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17782C0BC9B8
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:26 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id cq22-20020a17090af99600b001a9550a17a5so60422pjb.2
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 11:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AnNAUZppMhRZpSB2dP7oz0QMLOnCYASQg7WlLrqEU4E=;
        b=Np2WN3gujQUZufK82ijGoF2kREERe/STPXWL4kYZsMEZb0bnMGiWaf6BJfGOr6T83/
         H43oK0P6b+/Ui4/DHq2ThGrVNj4+vzDL58tdLnYf9ZUF3LaUt9+iCr1gErVBPzy/++lC
         nZl0/86jW65jGSe334YRFIH0u5DjTjkATvwEW3AVfB5VziYAgwVNfrpYjgkHoI8bSpjG
         zT3kSsigGKfGku8Sw0NuHiZ1tAlLvV5TaDFc0ZWRzhDrOO0wqi8F51XnAIwD1VAQPo9E
         q2R5ACGaBZul6lMURXJ/6S3tPw7ZZlikbUHJE4EivoU+CrY5zobCcdj0hYXL2Ia+cKtU
         ClKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AnNAUZppMhRZpSB2dP7oz0QMLOnCYASQg7WlLrqEU4E=;
        b=jIlpo10aI6GtDbyjCp94AYiVQ0CY/XtBO+wfSYozbdWqO+JLSeh1vlhY6N1/W2iHNs
         /GjA+iaYWjxtdBMpobiiVL7njM+2dLPv0E/lfTr+FgIhWhVh8KzytUqpJ0HuZHvgUr8m
         KtpUFEMTeQ8J3v73h6jt1cYtk1GwfLxbr5RgyDkS536rjNCzpOTN9ifL9XC0zHh8eOwJ
         FW8Im5MANHEKHNQhP45A1S/eLt/usXz8T0nnDDyfj0xcHBda4CCGKuWF7+huezzpPpJj
         M8CUOGVueSJk2xlTCA8uj2RrrnQ5Y3lXh30MWMUZvnDKm/c4+TnWod/0NF3wpqxW8PoM
         qFvw==
X-Gm-Message-State: AOAM532H/+AyEueI6Q4x5gxXOxMhMiv/RVFfGXGN6N23TkTplXQXHsg6
        r64/nW+aF/wjYD4UjuOq/m8=
X-Google-Smtp-Source: ABdhPJz4t5Z7MRu++nqT/IDyZRYswBRYFGwOP4QqvN9kG+Au30QnJOZtLxQ5z4lNgF5pVhVNuNDebQ==
X-Received: by 2002:a17:90b:3a89:: with SMTP id om9mr977855pjb.99.1637003005588;
        Mon, 15 Nov 2021 11:03:25 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4994:f3d6:2eb1:61cb])
        by smtp.gmail.com with ESMTPSA id f21sm11850834pfe.69.2021.11.15.11.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 11:03:25 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Subject: [PATCH net-next 19/20] tcp: do not call tcp_cleanup_rbuf() if we have a backlog
Date:   Mon, 15 Nov 2021 11:02:48 -0800
Message-Id: <20211115190249.3936899-20-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
In-Reply-To: <20211115190249.3936899-1-eric.dumazet@gmail.com>
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Under pressure, tcp recvmsg() has logic to process the socket backlog,
but calls tcp_cleanup_rbuf() right before.

Avoiding sending ACK right before processing new segments makes
a lot of sense, as this decrease the number of ACK packets,
with no impact on effective ACK clocking.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 7b1886103556e1295d84378d5bcb0f0346651de0..d1949fdb1462b97b87b99bc32ea132c574e9b647 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2436,12 +2436,11 @@ static int tcp_recvmsg_locked(struct sock *sk, struct msghdr *msg, size_t len,
 			}
 		}
 
-		tcp_cleanup_rbuf(sk, copied);
-
 		if (copied >= target) {
 			/* Do not sleep, just process backlog. */
 			__sk_flush_backlog(sk);
 		} else {
+			tcp_cleanup_rbuf(sk, copied);
 			sk_defer_free_flush(sk);
 			sk_wait_data(sk, &timeo, last);
 		}
-- 
2.34.0.rc1.387.gb447b232ab-goog

