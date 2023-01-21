Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6A4D67663E
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 13:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjAUMmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Jan 2023 07:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjAUMmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Jan 2023 07:42:09 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5D83018C
        for <netdev@vger.kernel.org>; Sat, 21 Jan 2023 04:42:08 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id v6so20194187ejg.6
        for <netdev@vger.kernel.org>; Sat, 21 Jan 2023 04:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DzAk1hM5Xemoilux239qO1nWkzVAhmDMy2SZ2xgHu5o=;
        b=uT7lAB+aL86kEHv0s+LmLgIYZpLbXZUqj5V7MbpxzmSRnWCBV+db+D6R379BNExc9q
         MQYunRZwdswlxyadSqiUBkLArc8OqA0kRDW1Rmidb7KxyhJD0HP4i2C4+NlOQcom2u5Q
         6vdgjp/lzqsgpviYHBrBmdNo6t5u4ADi98Cpc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DzAk1hM5Xemoilux239qO1nWkzVAhmDMy2SZ2xgHu5o=;
        b=rdTTpHHXOSJ762oeN2I9InNC274WLvRkYFchUx7LvNF2XrbK4DWaf/BKr5mPIPriGt
         HaYqxKzOatfCCpfIVwb+eno8yDQPciKAMWx429+2BUmJ3Zaea1AmLLgLgyD6iWXvLs/9
         tbCfO37uPdvhpIK2IQCr0gJa2M5M8HzFaxKBA/GRX4Z8zhuMaLdxVhk6KoWweUA3M2TY
         P4mF0KswneBYOTgcVGLXDs1mGxSCck/RpHJtzxYCa/LIXQ33ijsPselqx5QBPAA67oF2
         Ka/1r7KVCb/KvXEU8CYjvCXXb/D695Y7TG2IgTSyiEIniS4j4PVDUTSZN192WXMaQ1TL
         0oJA==
X-Gm-Message-State: AFqh2kqRi4c4tuE90Le15TRBu/hz076T2QTrIxgMqZs5nJ5e57D0EQQi
        cFfESHNbxDoj5lrJ3/pPPicx1A==
X-Google-Smtp-Source: AMrXdXvguFqGKPDaY185mTalNvA/K8c28JMrLUJxZ6J/+MjFMwdjhA6xQRs+FeG1xwZ8/4IIvVFn2g==
X-Received: by 2002:a17:907:a585:b0:872:ec40:65e9 with SMTP id vs5-20020a170907a58500b00872ec4065e9mr18078853ejc.18.1674304926658;
        Sat, 21 Jan 2023 04:42:06 -0800 (PST)
Received: from cloudflare.com (79.191.179.97.ipv4.supernova.orange.pl. [79.191.179.97])
        by smtp.gmail.com with ESMTPSA id d26-20020a056402401a00b0046c7c3755a7sm5223801eda.17.2023.01.21.04.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Jan 2023 04:42:06 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
Date:   Sat, 21 Jan 2023 13:41:43 +0100
Subject: [PATCH bpf v2 1/4] bpf, sockmap: Don't let
 sock_map_{close,destroy,unhash} call itself
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230113-sockmap-fix-v2-1-1e0ee7ac2f90@cloudflare.com>
References: <20230113-sockmap-fix-v2-0-1e0ee7ac2f90@cloudflare.com>
In-Reply-To: <20230113-sockmap-fix-v2-0-1e0ee7ac2f90@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, kernel-team@cloudflare.com
X-Mailer: b4 0.12.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sock_map proto callbacks should never call themselves by design. Protect
against bugs like [1] and break out of the recursive loop to avoid a stack
overflow in favor of a resource leak.

[1] https://lore.kernel.org/all/00000000000073b14905ef2e7401@google.com/

Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/core/sock_map.c | 61 +++++++++++++++++++++++++++++------------------------
 1 file changed, 34 insertions(+), 27 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 22fa2c5bc6ec..a68a7290a3b2 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1569,15 +1569,16 @@ void sock_map_unhash(struct sock *sk)
 	psock = sk_psock(sk);
 	if (unlikely(!psock)) {
 		rcu_read_unlock();
-		if (sk->sk_prot->unhash)
-			sk->sk_prot->unhash(sk);
-		return;
+		saved_unhash = READ_ONCE(sk->sk_prot)->unhash;
+	} else {
+		saved_unhash = psock->saved_unhash;
+		sock_map_remove_links(sk, psock);
+		rcu_read_unlock();
 	}
-
-	saved_unhash = psock->saved_unhash;
-	sock_map_remove_links(sk, psock);
-	rcu_read_unlock();
-	saved_unhash(sk);
+	if (WARN_ON_ONCE(saved_unhash == sock_map_unhash))
+		return;
+	if (saved_unhash)
+		saved_unhash(sk);
 }
 EXPORT_SYMBOL_GPL(sock_map_unhash);
 
@@ -1590,17 +1591,18 @@ void sock_map_destroy(struct sock *sk)
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock)) {
 		rcu_read_unlock();
-		if (sk->sk_prot->destroy)
-			sk->sk_prot->destroy(sk);
-		return;
+		saved_destroy = READ_ONCE(sk->sk_prot)->destroy;
+	} else {
+		saved_destroy = psock->saved_destroy;
+		sock_map_remove_links(sk, psock);
+		rcu_read_unlock();
+		sk_psock_stop(psock);
+		sk_psock_put(sk, psock);
 	}
-
-	saved_destroy = psock->saved_destroy;
-	sock_map_remove_links(sk, psock);
-	rcu_read_unlock();
-	sk_psock_stop(psock);
-	sk_psock_put(sk, psock);
-	saved_destroy(sk);
+	if (WARN_ON_ONCE(saved_destroy == sock_map_destroy))
+		return;
+	if (saved_destroy)
+		saved_destroy(sk);
 }
 EXPORT_SYMBOL_GPL(sock_map_destroy);
 
@@ -1615,16 +1617,21 @@ void sock_map_close(struct sock *sk, long timeout)
 	if (unlikely(!psock)) {
 		rcu_read_unlock();
 		release_sock(sk);
-		return sk->sk_prot->close(sk, timeout);
+		saved_close = READ_ONCE(sk->sk_prot)->close;
+	} else {
+		saved_close = psock->saved_close;
+		sock_map_remove_links(sk, psock);
+		rcu_read_unlock();
+		sk_psock_stop(psock);
+		release_sock(sk);
+		cancel_work_sync(&psock->work);
+		sk_psock_put(sk, psock);
 	}
-
-	saved_close = psock->saved_close;
-	sock_map_remove_links(sk, psock);
-	rcu_read_unlock();
-	sk_psock_stop(psock);
-	release_sock(sk);
-	cancel_work_sync(&psock->work);
-	sk_psock_put(sk, psock);
+	/* Make sure we do not recurse. This is a bug.
+	 * Leak the socket instead of crashing on a stack overflow.
+	 */
+	if (WARN_ON_ONCE(saved_close == sock_map_close))
+		return;
 	saved_close(sk, timeout);
 }
 EXPORT_SYMBOL_GPL(sock_map_close);

-- 
2.39.0

