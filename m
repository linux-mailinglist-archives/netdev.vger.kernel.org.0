Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603FF677122
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 18:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjAVRkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 12:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjAVRkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 12:40:03 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E00313D61
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 09:40:02 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id g23so9371488plq.12
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 09:40:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=theori.io; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O8QRkaT+jS8t0WyBt+vyX9selrndOVTAxVjn71JvR9U=;
        b=aT5NJknYYW7elr2s7nX9hvxv3SnWrgZu4LzJxEAB4Wy6kAcKE+oWJqHWo1FRGbjMWH
         1rD0AcXfUUEKFUuzITJUA5hmqE9P766lR02d+LV83ClQOtvED5wFovqtqObFLd7AcPYb
         jWd0X6MUc25JhtBRKrPer8016ElQLVwVTVL94=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O8QRkaT+jS8t0WyBt+vyX9selrndOVTAxVjn71JvR9U=;
        b=CR9rq9eRmjIeyaDJgzRih4GVS8xfGlKUu9dpiENACvoqnX+6V2aSySO6l5aAyMmODA
         8y/G0ujtFl2LY7/Xgt4V5q6upHgBxMeK7sNfza2E99jPx7UPdfKKJ6nRvi+8cDTLtnTg
         gcJbWMdmgc0CfU95hpfDz4Jfk9upNJqwCLj2GhOvrKJjEMDIrU6tDxAMwF6G8uxGLrAU
         VjZcl16+QkQ5w3nu/Y4b40zW5T/sLSRreX6rBRTBPuNJ0mbtlRh/OelgEkOiOn2bkqgz
         eUvtuYNeINPDrdCc+YafVZAlaA2pUWzkaddhOxu3cZ8F9m/++K2X0YiNWCKg2cOvzlDV
         x8Gg==
X-Gm-Message-State: AFqh2koAU5p+qa978NbnvXCjV7bWPNIE5ayCjzaVWqS9kNQtvpEf+K7N
        TmxG0zAIzM2IoY/ETVsZG15saw==
X-Google-Smtp-Source: AMrXdXtzwcxeOgEU3o2GcqeMFGHcTsLJVmmv42synwKal4IkO+Ghu9zDhF9thKlhoOb47L0HeQlyxQ==
X-Received: by 2002:a17:902:d718:b0:194:a529:9984 with SMTP id w24-20020a170902d71800b00194a5299984mr20681506ply.58.1674409201752;
        Sun, 22 Jan 2023 09:40:01 -0800 (PST)
Received: from ubuntu ([39.115.108.115])
        by smtp.gmail.com with ESMTPSA id q2-20020a170902a3c200b00189bf5dc96dsm30390834plb.230.2023.01.22.09.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 09:40:01 -0800 (PST)
Date:   Sun, 22 Jan 2023 09:39:57 -0800
From:   Hyunwoo Kim <v4bel@theori.io>
To:     ralf@linux-mips.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     v4bel@theori.io, imv4bel@gmail.com, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] net/rose: Fix to not accept on connected socket
Message-ID: <20230122173957.GA99728@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If listen() and accept() are called on a rose socket
that connect() is successful, accept() succeeds immediately.
This is because rose_connect() queues the skb to
sk->sk_receive_queue, and rose_accept() dequeues it.

This creates a child socket with the sk of the parent
rose socket, which can cause confusion.

Fix rose_listen() to return -EINVAL if the socket has
already been successfully connected, and add lock_sock
to prevent this issue.

Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
---
 net/rose/af_rose.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 36fefc3957d7..fa28c7e1805c 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -488,6 +488,12 @@ static int rose_listen(struct socket *sock, int backlog)
 {
 	struct sock *sk = sock->sk;
 
+	lock_sock(sk);
+	if (sock->state == SS_CONNECTED) {
+		release_sock(sk);
+		return -EINVAL;
+	}
+
 	if (sk->sk_state != TCP_LISTEN) {
 		struct rose_sock *rose = rose_sk(sk);
 
@@ -497,8 +503,10 @@ static int rose_listen(struct socket *sock, int backlog)
 		memset(rose->dest_digis, 0, AX25_ADDR_LEN * ROSE_MAX_DIGIS);
 		sk->sk_max_ack_backlog = backlog;
 		sk->sk_state           = TCP_LISTEN;
+		release_sock(sk);
 		return 0;
 	}
+	release_sock(sk);
 
 	return -EOPNOTSUPP;
 }
-- 
2.25.1

