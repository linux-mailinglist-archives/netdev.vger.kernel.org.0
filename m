Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048F25A7F0B
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 15:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiHaNig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 09:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiHaNif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 09:38:35 -0400
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40503D86;
        Wed, 31 Aug 2022 06:38:33 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id b16so18442464edd.4;
        Wed, 31 Aug 2022 06:38:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=WL2hbn3gfMbnUVzI30rf1ujjncBseT3Kr/X668qXOD8=;
        b=u0jCH4Jr45szhFmu55fKEwLVufybx2TaKBMdrvFHc7WNsNt59kfZqWd5jeU5UFDYpJ
         jWjnefXPOx59JtAUhCxiIggpTU5bHodTXX37DCiXad1oK4iN6x0RVZBvyZ6VE1Tuuzqk
         j5Ejz/OOWltFctL0F6UCGigcYoPuR9ptlkfdW6aC/fG1ocMlYrR3PzTh7StzFJthblNp
         MSR4tMCgp9iJx65iKUtat41fwPkndzygSWzAcglYcx/0waui+kH1dFWgdjM94XUxaC4y
         43X7hLVaQyPq4OJM/Zxj5DKlFnYQveVyJ9zWvO5sgLs9KGAuejRmidUTi2RouG1yeW9O
         J/kw==
X-Gm-Message-State: ACgBeo25AF5epQ4jCRfmjZkVUX9KLav4fiU7/IihpSqTtI1jeKLzM3Wk
        ng65w8jQElj2dA4TOX+7trg=
X-Google-Smtp-Source: AA6agR4fNjZjLwyUTiFXetuPEZLVxhWBVl6a0DVs1VB18bCt1Abom97rGIBjpLWGl0+2PXb1d0WtiQ==
X-Received: by 2002:aa7:c611:0:b0:447:844d:e5a2 with SMTP id h17-20020aa7c611000000b00447844de5a2mr5761820edq.10.1661953111717;
        Wed, 31 Aug 2022 06:38:31 -0700 (PDT)
Received: from localhost (fwdproxy-cln-005.fbsv.net. [2a03:2880:31ff:5::face:b00c])
        by smtp.gmail.com with ESMTPSA id uo39-20020a170907cc2700b0073da32b7db0sm2346384ejc.199.2022.08.31.06.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 06:38:31 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     edumazet@google.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, leit@fb.com, yoshfuji@linux-ipv6.org,
        pabeni@redhat.com, dsahern@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND net-next] tcp: socket-specific version of WARN_ON_ONCE()
Date:   Wed, 31 Aug 2022 06:37:58 -0700
Message-Id: <20220831133758.3741187-1-leitao@debian.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are cases where we need information about the socket during a
warning, so, it could help us to find bugs that happens that do not have
a easily repro.

BPF congestion control algorithms can change socket state in unexpected
ways, leading to WARNings. Additional information about the socket state
is useful to identify the culprit.

This diff creates a TCP socket-specific version of WARN_ON_ONCE(), and
attaches it to tcp_snd_cwnd_set().

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/net/tcp.h       |  3 ++-
 include/net/tcp_debug.h | 10 ++++++++++
 net/ipv4/tcp.c          | 30 ++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 1 deletion(-)
 create mode 100644 include/net/tcp_debug.h

diff --git a/include/net/tcp.h b/include/net/tcp.h
index d10962b9f0d0..73c3970d8839 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -40,6 +40,7 @@
 #include <net/inet_ecn.h>
 #include <net/dst.h>
 #include <net/mptcp.h>
+#include <net/tcp_debug.h>
 
 #include <linux/seq_file.h>
 #include <linux/memcontrol.h>
@@ -1222,7 +1223,7 @@ static inline u32 tcp_snd_cwnd(const struct tcp_sock *tp)
 
 static inline void tcp_snd_cwnd_set(struct tcp_sock *tp, u32 val)
 {
-	WARN_ON_ONCE((int)val <= 0);
+	TCP_SOCK_WARN_ON_ONCE(tp, (int)val <= 0);
 	tp->snd_cwnd = val;
 }
 
diff --git a/include/net/tcp_debug.h b/include/net/tcp_debug.h
new file mode 100644
index 000000000000..50e96d87d335
--- /dev/null
+++ b/include/net/tcp_debug.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_TCP_DEBUG_H
+#define _LINUX_TCP_DEBUG_H
+
+void tcp_sock_warn(const struct tcp_sock *tp);
+
+#define TCP_SOCK_WARN_ON_ONCE(tcp_sock, condition) \
+		DO_ONCE_LITE_IF(condition, tcp_sock_warn, tcp_sock)
+
+#endif  /* _LINUX_TCP_DEBUG_H */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index bbe218753662..71771fee72f7 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4684,6 +4684,36 @@ int tcp_abort(struct sock *sk, int err)
 }
 EXPORT_SYMBOL_GPL(tcp_abort);
 
+void tcp_sock_warn(const struct tcp_sock *tp)
+{
+	const struct sock *sk = (const struct sock *)tp;
+	struct inet_sock *inet = inet_sk(sk);
+	struct inet_connection_sock *icsk = inet_csk(sk);
+
+	WARN_ON(1);
+
+	if (!tp)
+		return;
+
+	pr_warn("Socket Info: family=%u state=%d sport=%u dport=%u ccname=%s cwnd=%u",
+		sk->sk_family, sk->sk_state, ntohs(inet->inet_sport),
+		ntohs(inet->inet_dport), icsk->icsk_ca_ops->name, tcp_snd_cwnd(tp));
+
+	switch (sk->sk_family) {
+	case AF_INET:
+		pr_warn("saddr=%pI4 daddr=%pI4", &inet->inet_saddr,
+			&inet->inet_daddr);
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+		pr_warn("saddr=%pI6 daddr=%pI6", &sk->sk_v6_rcv_saddr,
+			&sk->sk_v6_daddr);
+		break;
+#endif
+	}
+}
+EXPORT_SYMBOL_GPL(tcp_sock_warn);
+
 extern struct tcp_congestion_ops tcp_reno;
 
 static __initdata unsigned long thash_entries;
-- 
2.30.2

