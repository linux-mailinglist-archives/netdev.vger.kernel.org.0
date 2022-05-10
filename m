Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7304F520C16
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 05:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbiEJDge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 23:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235409AbiEJDgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 23:36:25 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FFC179097
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 20:32:29 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id s16so3506249pgs.3
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 20:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VfIc2hwKs3WKU/LwfhuXIfUteFdkMbyV5rtiOsdfl00=;
        b=dqxbfORdrZrW8R3m+x0Vla6YgJlrhm/MX8cVG6qraMvLnego4Y4GAe+QmgW52H6ckM
         WmOU7ZLyMIXgZZySH6LX39sHPQbbqMe7TlXpqx/KVi9CJmAeP6RH0EGTK/xHP+5KVi+5
         vRQDcQZB/aFYYxLfkftAE+b6Xqb685aq/jbZ/QbH56cg2967wZoyhJK1jDPWxZ68asdT
         xKbkNd/qHgPLqO+ytqXcjbutPNHpXzJklqbb1xOPTPdsWlpznCGkLvm19c2J4n/tvJ7I
         Ywu9jEB/5BpwBMYspaOw8Y285t0+2rylkL1r7ekzh86OPgmlnwxRr6JJXhk5ldGQxQ2n
         OFSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VfIc2hwKs3WKU/LwfhuXIfUteFdkMbyV5rtiOsdfl00=;
        b=HsgWnbf8oEzDTyY62nIE23mAmDFWXMezRIcaJZ9N/wqeEQU38KNDyd0wfs6Y02MuW1
         KMkzFyV1z9Rc/fEJEzzzpseQjJQq6GYGuyWTjh68j3zF9p1keGfXndLYFTbkkuQ+NHTE
         obtwyEDWMxeaUFSrhVvfTkPq6+Qufxo4DrtokbEjCw5svLT55XYVywuxgrWnAYAW7Sro
         kM5D4eP41fCxSE4QLjA5PjRENvVAA9WtGvWhI5UGK6zNRplDDaEZa9XU0/dc/XzVWTTm
         1fDX7S+dqMM152Su8T/FfgwNrr1qANUkJWQ1uQBa6JOPi8OGotNywbQ7QoqOEpqAhmDu
         /dRQ==
X-Gm-Message-State: AOAM533V7OVjJcDodBZYcVQqI+b1J3C8TBsXXEDUZBNskpIlbRhR9LOH
        YriMFnm9f+R3ye+22fr+Bxc=
X-Google-Smtp-Source: ABdhPJyEzFJyPjHOOyLxhRB+EpelutBTScvoErbCzdG+gb9wiJYa02BAbDqi6qvZaLFVQ/8jogYjLQ==
X-Received: by 2002:a65:4882:0:b0:3c2:8f35:5d1b with SMTP id n2-20020a654882000000b003c28f355d1bmr15460178pgs.80.1652153549465;
        Mon, 09 May 2022 20:32:29 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id me16-20020a17090b17d000b001d77f392280sm538185pjb.30.2022.05.09.20.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 20:32:29 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v6 net-next 04/13] tcp_cubic: make hystart_ack_delay() aware of BIG TCP
Date:   Mon,  9 May 2022 20:32:10 -0700
Message-Id: <20220510033219.2639364-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220510033219.2639364-1-eric.dumazet@gmail.com>
References: <20220510033219.2639364-1-eric.dumazet@gmail.com>
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

hystart_ack_delay() had the assumption that a TSO packet
would not be bigger than GSO_MAX_SIZE.

This will no longer be true.

We should use sk->sk_gso_max_size instead.

This reduces chances of spurious Hystart ACK train detections.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_cubic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index b0918839bee7cf0264ec3bbcdfc1417daa86d197..68178e7280ce24c26a48e48a51518d759e4d1718 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -372,7 +372,7 @@ static void cubictcp_state(struct sock *sk, u8 new_state)
  * We apply another 100% factor because @rate is doubled at this point.
  * We cap the cushion to 1ms.
  */
-static u32 hystart_ack_delay(struct sock *sk)
+static u32 hystart_ack_delay(const struct sock *sk)
 {
 	unsigned long rate;
 
@@ -380,7 +380,7 @@ static u32 hystart_ack_delay(struct sock *sk)
 	if (!rate)
 		return 0;
 	return min_t(u64, USEC_PER_MSEC,
-		     div64_ul((u64)GSO_MAX_SIZE * 4 * USEC_PER_SEC, rate));
+		     div64_ul((u64)sk->sk_gso_max_size * 4 * USEC_PER_SEC, rate));
 }
 
 static void hystart_update(struct sock *sk, u32 delay)
-- 
2.36.0.512.ge40c2bad7a-goog

