Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4926647380
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 16:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbiLHPrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 10:47:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiLHPra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 10:47:30 -0500
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4C75BD5A;
        Thu,  8 Dec 2022 07:47:28 -0800 (PST)
Received: by mail-ej1-f46.google.com with SMTP id gh17so5014964ejb.6;
        Thu, 08 Dec 2022 07:47:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VhgZCo6c+hsVZq5QVJKJQrJlxaKlhskVBf5ljnXV7/s=;
        b=6XBh6yYtxgCM9R8i+LCjXfkjIvtFYFGnWwJ272ha4EKrLmmW2wMMADqoKCSfqhj1EE
         qkpDO34TIKqjnorbZiuHOvTNtAnjZtg/87NHll8S7C/s3pRTsmmaAhREllP2Y++qPNE8
         XhbV6RwRwXr5oqK7GFw0luhHdl9UmnvpXsFbfLOjUex/a7eSOvfgstNoUU99VyDMHivw
         Abv84Gfp2E1PH08wSjhDCc32ETojNdPVyd9ViFHyvGfuliDJmHwV+ve8P4QhbNyh8XB4
         7R8h6V5JUq0PSDND+kkJr7YmoLfO3CB/SuSv0X/0Z6s8XZu1YyeMA7/I/rn+Ae+Pp44X
         USPg==
X-Gm-Message-State: ANoB5pmF/ndPTdrme8/kXUzOtCIotT4i6umP3dVgCC4ZBsWb2JveCNTu
        EgwtQ0+b8/yA4+wQtpsl57Vt0H/s7Mt9Zg==
X-Google-Smtp-Source: AA0mqf5eMyMKDzm/jFfHdbUAF4mOs6k8K/3PS/3Esz5HRuKK1cmwrZ8CYtLMZE0P0OEAsRzoQJzqXg==
X-Received: by 2002:a17:907:3e14:b0:7c0:f719:838d with SMTP id hp20-20020a1709073e1400b007c0f719838dmr2931457ejc.36.1670514446979;
        Thu, 08 Dec 2022 07:47:26 -0800 (PST)
Received: from localhost (fwdproxy-cln-118.fbsv.net. [2a03:2880:31ff:76::face:b00c])
        by smtp.gmail.com with ESMTPSA id 22-20020a170906329600b007add28659b0sm9902685ejw.140.2022.12.08.07.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 07:47:26 -0800 (PST)
From:   Breno Leitao <leitao@debian.org>
To:     edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, kuniyu@amazon.com
Cc:     netdev@vger.kernel.org, leit@fb.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next] tcp: socket-specific version of WARN_ON_ONCE()
Date:   Thu,  8 Dec 2022 07:46:56 -0800
Message-Id: <20221208154656.60623-1-leitao@debian.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are cases where we need relevant information about the socket
during a warning, so, it could help us to find bugs that happens and do
not have an easy repro.

This patch creates a TCP-socket specific version of WARN_ON_ONCE(), which
dumps revelant information about the TCP socket when it hits rare
warnings, which is super useful for debugging purposes.

Hooking this warning tcp_snd_cwnd_set() for now, but, the intent is to
convert more TCP warnings to this helper later.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/net/tcp.h       |  3 ++-
 include/net/tcp_debug.h | 10 ++++++++++
 net/ipv4/tcp.c          | 30 ++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 1 deletion(-)
 create mode 100644 include/net/tcp_debug.h

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 14d45661a84d..e490af8e6fdc 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -40,6 +40,7 @@
 #include <net/inet_ecn.h>
 #include <net/dst.h>
 #include <net/mptcp.h>
+#include <net/tcp_debug.h>
 
 #include <linux/seq_file.h>
 #include <linux/memcontrol.h>
@@ -1229,7 +1230,7 @@ static inline u32 tcp_snd_cwnd(const struct tcp_sock *tp)
 
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
index 54836a6b81d6..5985ba9c4231 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4705,6 +4705,36 @@ int tcp_abort(struct sock *sk, int err)
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
+	pr_warn("Socket Info: family=%u state=%d ccname=%s cwnd=%u",
+		sk->sk_family, sk->sk_state, icsk->icsk_ca_ops->name,
+		tcp_snd_cwnd(tp));
+
+	switch (sk->sk_family) {
+	case AF_INET:
+		pr_warn("saddr=%pI4:%u daddr=%pI4:%u", &inet->inet_saddr,
+			ntohs(inet->inet_sport), &inet->inet_daddr,
+			ntohs(inet->inet_dport));
+
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+		pr_warn("saddr=[%pI6]:%u daddr=[%pI6]:%u", &sk->sk_v6_rcv_saddr,
+			ntohs(inet->inet_sport), &sk->sk_v6_daddr,
+			ntohs(inet->inet_dport));
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

