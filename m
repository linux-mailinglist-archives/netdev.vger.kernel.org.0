Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661F05131EB
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 13:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345164AbiD1LEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343930AbiD1LDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:03:07 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1121A9AE61;
        Thu, 28 Apr 2022 03:59:28 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id q23so6256678wra.1;
        Thu, 28 Apr 2022 03:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JJ/Jn2CaItPG2KrWE6z6rbp+t2EL7d23+IBwd5W6Kr8=;
        b=BTtmqWGCmABxPW53lwZmD/b/VAE84IqlAOJkfGCYrOQDB7rvCIti4hkbumbARY7ES6
         nwbMp4prigAlU5k7f/bhzLS4eM9dQplfPndwW9fBjV/FENYRYDcBU5KpjmPfFOgZB7sI
         6Jfu5492r8jqQ83K88JNvy3VjQRTa660KQ98gesnYPFtHJ/wzZK7JzLn0R9FNeHMndTH
         Ji6OKF16MkdxyTtImsBlElcq5s0KJYX9Cu5LzsAi0o3zE7akyA22VBYyLeQjeINg131f
         +ilEmO+xquKB3OLOvi1zdWlYXNaOIrlzZ6tW/FqWVRvDnFhdCXH8gtcj4e26Yhlr5z+Z
         MtJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JJ/Jn2CaItPG2KrWE6z6rbp+t2EL7d23+IBwd5W6Kr8=;
        b=brBadw7XtuxtfvWyqcXr51E20v6HU8wh5kfPLoR4NxhoejFGtYmPLH/5obk7yh89No
         qtVDZ5Inv147aZELjEWwXPE/KaJ+B26wmqezWqQrvj8pTZKGU+i4Tk4siKn0KDRStaxE
         UE01rWRAQK5im9lstKAuUucQ0BO3xVZHc5WxePy+j59CkuAARYYKJLIEIn1cjCoLMRi1
         cw7ZarrGjJGunCP3ChMyn0dqYPV3lOIMTAeCoKgEYyWzkjoLQAZpGGQm4jNmJM0zKZfQ
         0+wVZ9ADak+zlcy57Qp09kXnm6BBABvgpX06wNuPMiR0gQmBL1/KVT0430RjaihU7FWB
         rt/Q==
X-Gm-Message-State: AOAM531pLqcGESGOq6mevOX7ODRQq5EEdvWsum89608fqWHlANrLPNEE
        lKb55gParjRbOiVW19ftrEcQRVDbzX8=
X-Google-Smtp-Source: ABdhPJz8tngMyKNr78aheYziUbFINMy3fzZrKBXOBSG4c7opcdLd77kwyS2pdOJo43gK/lecZCf7Nw==
X-Received: by 2002:adf:f0c6:0:b0:20a:d31b:6 with SMTP id x6-20020adff0c6000000b0020ad31b0006mr20672965wro.162.1651143566470;
        Thu, 28 Apr 2022 03:59:26 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id n10-20020a5d588a000000b002052e4aaf89sm16028895wrf.80.2022.04.28.03.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:59:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 1/5] net: inline sock_alloc_send_skb
Date:   Thu, 28 Apr 2022 11:58:44 +0100
Message-Id: <589966747301e2f71377f288faf4f8db78d72405.1651141755.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1651141755.git.asml.silence@gmail.com>
References: <cover.1651141755.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sock_alloc_send_skb() is simple and just proxying to another function,
so we can inline it and cut associated overhead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/net/sock.h | 10 ++++++++--
 net/core/sock.c    |  7 -------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index a01d6c421aa2..df2e826f67ee 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1824,11 +1824,17 @@ int sock_getsockopt(struct socket *sock, int level, int op,
 		    char __user *optval, int __user *optlen);
 int sock_gettstamp(struct socket *sock, void __user *userstamp,
 		   bool timeval, bool time32);
-struct sk_buff *sock_alloc_send_skb(struct sock *sk, unsigned long size,
-				    int noblock, int *errcode);
 struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 				     unsigned long data_len, int noblock,
 				     int *errcode, int max_page_order);
+
+static inline struct sk_buff *sock_alloc_send_skb(struct sock *sk,
+						  unsigned long size,
+						  int noblock, int *errcode)
+{
+	return sock_alloc_send_pskb(sk, size, 0, noblock, errcode, 0);
+}
+
 void *sock_kmalloc(struct sock *sk, int size, gfp_t priority);
 void sock_kfree_s(struct sock *sk, void *mem, int size);
 void sock_kzfree_s(struct sock *sk, void *mem, int size);
diff --git a/net/core/sock.c b/net/core/sock.c
index 29abec3eabd8..fbca35d3749a 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2631,13 +2631,6 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
 }
 EXPORT_SYMBOL(sock_alloc_send_pskb);
 
-struct sk_buff *sock_alloc_send_skb(struct sock *sk, unsigned long size,
-				    int noblock, int *errcode)
-{
-	return sock_alloc_send_pskb(sk, size, 0, noblock, errcode, 0);
-}
-EXPORT_SYMBOL(sock_alloc_send_skb);
-
 int __sock_cmsg_send(struct sock *sk, struct msghdr *msg, struct cmsghdr *cmsg,
 		     struct sockcm_cookie *sockc)
 {
-- 
2.36.0

