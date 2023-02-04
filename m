Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D03968ABAB
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 18:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbjBDRjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 12:39:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbjBDRji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 12:39:38 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193AB22018
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 09:39:36 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id gr7so23531245ejb.5
        for <netdev@vger.kernel.org>; Sat, 04 Feb 2023 09:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=diag.uniroma1.it; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W/eOodguwW0STRp0sOylYiqIEzEkDsRJryvWVBj7Tj0=;
        b=V2mUDq13aAExtvc8b5Fn1aerouoj1TDWrw6MWGWKI36CiAjmYpwPX1v5ua9F+COX/o
         oUbGOdGAzGvOaIIv+P9KgA7fKVskKfk+Ov2VYv04DLXSpxNGYP1h4QXxOEWq5QAlIc7q
         SUQbPV59TYD9pg8OEEDd1cM9bPQPSThnltpUo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W/eOodguwW0STRp0sOylYiqIEzEkDsRJryvWVBj7Tj0=;
        b=3BRnXLerN6nsxTWs2tmZ9yXZj55siW5E4UjFlCR2u/t2dsAJu3RaAgZmB688pECwge
         cXY5L0doifCLU319s5qJyM1lu67Rj/5Paae0FeXd8nwBRv8DoPa8IHNIOrvCb7DHGv1t
         vBI7ldXyA5NMmfYYN2Y0LhDMcy4CgNV5Tq7mArZQUre8+YH6KlCUSNZTEKaWw1cs8PD0
         JMCGhaBM5KXHU4LcBGIBQOjOp2RwxfdKyDtUBNlnFIdco+2NDRAkmMOHsf9ecuo8J+Kh
         GkyqdrgL9XbsW8Y+5yVReXcnRUan2yBZpztCN6nKCa3tK5nxXhcn18yRxm3nT9fJrAzb
         jzGg==
X-Gm-Message-State: AO0yUKX9OIO9OcQrK0Z+cncoBhQda0AM0jEKp9K2UeW8kONlPDI//ebM
        cERqFfAZysbZvHU8CRjxOjDyaw==
X-Google-Smtp-Source: AK7set/7vJsPrtgT1EsZ9QiuN+7qj2SltvrccgvnMIL5zDXawx96JnGrdfeOYjmqR/2dvG5S+GUGnA==
X-Received: by 2002:a17:906:b4b:b0:878:71fe:2f12 with SMTP id v11-20020a1709060b4b00b0087871fe2f12mr15495013ejg.50.1675532374624;
        Sat, 04 Feb 2023 09:39:34 -0800 (PST)
Received: from [192.168.17.2] (wolkje-127.labs.vu.nl. [130.37.198.127])
        by smtp.gmail.com with ESMTPSA id ot1-20020a170906ccc100b008897858bb06sm3039321ejb.119.2023.02.04.09.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 09:39:34 -0800 (PST)
From:   Pietro Borrello <borrello@diag.uniroma1.it>
Date:   Sat, 04 Feb 2023 17:39:20 +0000
Subject: [PATCH net-next v3 1/3] net: add sock_init_data_uid()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230131-tuntap-sk-uid-v3-1-81188b909685@diag.uniroma1.it>
References: <20230131-tuntap-sk-uid-v3-0-81188b909685@diag.uniroma1.it>
In-Reply-To: <20230131-tuntap-sk-uid-v3-0-81188b909685@diag.uniroma1.it>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Colitti <lorenzo@google.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pietro Borrello <borrello@diag.uniroma1.it>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1675532373; l=2607;
 i=borrello@diag.uniroma1.it; s=20221223; h=from:subject:message-id;
 bh=kN6b+mn+Xy5aGO+SctMF63Je9JkYLzu955YoGSa6qrQ=;
 b=EuajB2ZiGsi241Dg3sGGmG4MCz4SeW5nITQRJ92iQkELJ9FbqSNvModUMQy8iEN3cCVa7bedsfH4
 d3G9tlRhBSWpW8JAXyGi9i0oHzvgvyzaSx6eoi8j3vIPK6MCooLC
X-Developer-Key: i=borrello@diag.uniroma1.it; a=ed25519;
 pk=4xRQbiJKehl7dFvrG33o2HpveMrwQiUPKtIlObzKmdY=
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add sock_init_data_uid() to explicitly initialize the socket uid.
To initialise the socket uid, sock_init_data() assumes a the struct
socket* sock is always embedded in a struct socket_alloc, used to
access the corresponding inode uid. This may not be true.
Examples are sockets created in tun_chr_open() and tap_open().

Fixes: 86741ec25462 ("net: core: Add a UID field to struct sock.")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
---
 include/net/sock.h |  7 ++++++-
 net/core/sock.c    | 15 ++++++++++++---
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index dcd72e6285b2..937e842dc930 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1956,7 +1956,12 @@ void sk_common_release(struct sock *sk);
  *	Default socket callbacks and setup code
  */
 
-/* Initialise core socket variables */
+/* Initialise core socket variables using an explicit uid. */
+void sock_init_data_uid(struct socket *sock, struct sock *sk, kuid_t uid);
+
+/* Initialise core socket variables.
+ * Assumes struct socket *sock is embedded in a struct socket_alloc.
+ */
 void sock_init_data(struct socket *sock, struct sock *sk);
 
 /*
diff --git a/net/core/sock.c b/net/core/sock.c
index f954d5893e79..9f51ee851a85 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3379,7 +3379,7 @@ void sk_stop_timer_sync(struct sock *sk, struct timer_list *timer)
 }
 EXPORT_SYMBOL(sk_stop_timer_sync);
 
-void sock_init_data(struct socket *sock, struct sock *sk)
+void sock_init_data_uid(struct socket *sock, struct sock *sk, kuid_t uid)
 {
 	sk_init_common(sk);
 	sk->sk_send_head	=	NULL;
@@ -3399,11 +3399,10 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 		sk->sk_type	=	sock->type;
 		RCU_INIT_POINTER(sk->sk_wq, &sock->wq);
 		sock->sk	=	sk;
-		sk->sk_uid	=	SOCK_INODE(sock)->i_uid;
 	} else {
 		RCU_INIT_POINTER(sk->sk_wq, NULL);
-		sk->sk_uid	=	make_kuid(sock_net(sk)->user_ns, 0);
 	}
+	sk->sk_uid	=	uid;
 
 	rwlock_init(&sk->sk_callback_lock);
 	if (sk->sk_kern_sock)
@@ -3462,6 +3461,16 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	refcount_set(&sk->sk_refcnt, 1);
 	atomic_set(&sk->sk_drops, 0);
 }
+EXPORT_SYMBOL(sock_init_data_uid);
+
+void sock_init_data(struct socket *sock, struct sock *sk)
+{
+	kuid_t uid = sock ?
+		SOCK_INODE(sock)->i_uid :
+		make_kuid(sock_net(sk)->user_ns, 0);
+
+	sock_init_data_uid(sock, sk, uid);
+}
 EXPORT_SYMBOL(sock_init_data);
 
 void lock_sock_nested(struct sock *sk, int subclass)

-- 
2.25.1

