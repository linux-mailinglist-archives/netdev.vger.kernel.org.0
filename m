Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B65692EF1
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 07:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjBKGwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 01:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjBKGwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 01:52:00 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4C5303F9;
        Fri, 10 Feb 2023 22:51:59 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id pj3so7540662pjb.1;
        Fri, 10 Feb 2023 22:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OIJb0r8t3n2Yk0XQfpoH27yVjCpWtLB6DeuY/Wb6quo=;
        b=Z7IzasDHo9swANAoqL5CiUU5IyZy2IsZkDhHJqWn3NIRleyTHOykxtZO45sBo2RJkN
         bXNsFhXfAKhqWHp/B0zOYDULNlIsHSgWQU42f2Z8WM4k49U1uuFEcBHmhyyAgD1OrE5s
         Jw0lb29GoNC2pMI2jly4BI7xCmYVjMG6jDs0fECPtZteEdlkXWtviJRdpPT8mfkQPDX6
         bsKgwYCbtznZ3V/exAD4c4f4ZB9NZpg1pLEpOiWz9vV5w9DpsRLVAil9gz4YUlhcrVwE
         zqi8RnTrC924P7RZMDu5LUBZ8+c+bBM3hjZ1o/rkhXBNn/svbMNATH4fclZwCRd/+jTe
         6emQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OIJb0r8t3n2Yk0XQfpoH27yVjCpWtLB6DeuY/Wb6quo=;
        b=ifnSDiHk2OL3x/Ao1qTGd7CATdSo5y/7BsfKSxzz3iyeN6iEXiK45wYWP3wzEYYTa2
         Vi2P73lOP0dnRIe6cfg+XcUAwpR2qEyT+rGE0rMOQxsJwt05QvalGDDuu8cL8VY5yRHS
         00i2UvieLmpT4EJv6vLWw4FPBmelIOs+YRyFBZfg/8ptISF27mmXrAQQ1svwePgl12Yb
         ziNWMNZt25eaHAR7TdZuL0zHRctoCuiI9drUxRvQxnmgD+pd6HWHgw6Wasqb18xzn6KD
         i5Qq6p8BayjR4W5H9uMYmgVOwg51/+MjY/jhPXVZsv24XdZVH4Wi3lEIWQjB2J7PSXqK
         pobg==
X-Gm-Message-State: AO0yUKU2ZqbL6hB+oTBdc5nkshtBWRjGXlmwPHxwXH8gxvWJ8xc+rjgQ
        wclcx6WONh3Ll+cmLSimt4I=
X-Google-Smtp-Source: AK7set9D/VYWvWqPx2jqG7EvlW3NF3CIUMlLuKCdWAbri3HAZ2aa3TKnXtlOTGB2Oax1s+MelNKYuw==
X-Received: by 2002:a17:903:182:b0:198:c4ff:1c6 with SMTP id z2-20020a170903018200b00198c4ff01c6mr20585323plg.4.1676098318868;
        Fri, 10 Feb 2023 22:51:58 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([114.253.32.213])
        by smtp.gmail.com with ESMTPSA id f22-20020a170902ab9600b0019a7385079esm2219705plr.123.2023.02.10.22.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 22:51:58 -0800 (PST)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kerneljasonxing@gmail.com,
        Jason Xing <kernelxing@tencent.com>
Subject: [PATCH net-next] net: Kconfig.debug: wrap socket refcnt debug into an option
Date:   Sat, 11 Feb 2023 14:51:53 +0800
Message-Id: <20230211065153.54116-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
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

From: Jason Xing <kernelxing@tencent.com>

Since commit 463c84b97f24 ("[NET]: Introduce inet_connection_sock")
commented out the definition of SOCK_REFCNT_DEBUG and later another
patch deleted it, we need to enable it through defining it manually
somewhere. Wrapping it into an option in Kconfig.debug could make
it much clearer and easier for some developers to do things based
on this change.

Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
 include/net/sock.h            | 8 ++++----
 net/Kconfig.debug             | 8 ++++++++
 net/ipv4/inet_timewait_sock.c | 2 +-
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index dcd72e6285b2..1b001efeb9b5 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1349,7 +1349,7 @@ struct proto {
 	char			name[32];
 
 	struct list_head	node;
-#ifdef SOCK_REFCNT_DEBUG
+#ifdef CONFIG_SOCK_REFCNT_DEBUG
 	atomic_t		socks;
 #endif
 	int			(*diag_destroy)(struct sock *sk, int err);
@@ -1359,7 +1359,7 @@ int proto_register(struct proto *prot, int alloc_slab);
 void proto_unregister(struct proto *prot);
 int sock_load_diag_module(int family, int protocol);
 
-#ifdef SOCK_REFCNT_DEBUG
+#ifdef CONFIG_SOCK_REFCNT_DEBUG
 static inline void sk_refcnt_debug_inc(struct sock *sk)
 {
 	atomic_inc(&sk->sk_prot->socks);
@@ -1378,11 +1378,11 @@ static inline void sk_refcnt_debug_release(const struct sock *sk)
 		printk(KERN_DEBUG "Destruction of the %s socket %p delayed, refcnt=%d\n",
 		       sk->sk_prot->name, sk, refcount_read(&sk->sk_refcnt));
 }
-#else /* SOCK_REFCNT_DEBUG */
+#else /* CONFIG_SOCK_REFCNT_DEBUG */
 #define sk_refcnt_debug_inc(sk) do { } while (0)
 #define sk_refcnt_debug_dec(sk) do { } while (0)
 #define sk_refcnt_debug_release(sk) do { } while (0)
-#endif /* SOCK_REFCNT_DEBUG */
+#endif /* CONFIG_SOCK_REFCNT_DEBUG */
 
 INDIRECT_CALLABLE_DECLARE(bool tcp_stream_memory_free(const struct sock *sk, int wake));
 
diff --git a/net/Kconfig.debug b/net/Kconfig.debug
index 5e3fffe707dd..667396d70e10 100644
--- a/net/Kconfig.debug
+++ b/net/Kconfig.debug
@@ -18,6 +18,14 @@ config NET_NS_REFCNT_TRACKER
 	  Enable debugging feature to track netns references.
 	  This adds memory and cpu costs.
 
+config SOCK_REFCNT_DEBUG
+	bool "Enable socket refcount debug"
+	depends on DEBUG_KERNEL && NET
+	default n
+	help
+	  Enable debugging feature to track socket references.
+	  This adds memory and cpu costs.
+
 config DEBUG_NET
 	bool "Add generic networking debug"
 	depends on DEBUG_KERNEL && NET
diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index beed32fff484..e313516b64ce 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -77,7 +77,7 @@ void inet_twsk_free(struct inet_timewait_sock *tw)
 {
 	struct module *owner = tw->tw_prot->owner;
 	twsk_destructor((struct sock *)tw);
-#ifdef SOCK_REFCNT_DEBUG
+#ifdef CONFIG_SOCK_REFCNT_DEBUG
 	pr_debug("%s timewait_sock %p released\n", tw->tw_prot->name, tw);
 #endif
 	kmem_cache_free(tw->tw_prot->twsk_prot->twsk_slab, tw);
-- 
2.37.3

