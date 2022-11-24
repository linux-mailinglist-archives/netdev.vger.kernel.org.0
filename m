Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE88637784
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 12:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiKXLWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 06:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiKXLWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 06:22:44 -0500
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAA011478;
        Thu, 24 Nov 2022 03:22:42 -0800 (PST)
Received: by mail-ej1-f52.google.com with SMTP id e27so3416616ejc.12;
        Thu, 24 Nov 2022 03:22:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TQJAcBaQ4iWBQtMTkg02XF1PTNjJUIHH8kGGgI0Jy94=;
        b=I1mxj9FyD0I1zXVD4592+OKpvxOiaMFhOAkNCetf1ZXYlMEa1foyN2p/cDGypaacMM
         iXBoEjbGbDhE9g/65VJjxABVO94M2+vZ2kwhz96xnkBDlN/zvbTSNec/zQto7Aqdoa7i
         TDrinTWdc7JIEV07F1tfp9ZdER5w3XBmVPw22+eO1UGWnuzBHfsvOarD/8FQwTd67i+n
         yI+OifTARGIKWtV4/KC+2bE6p+3N78STIc2y9AKR0jT2CdepGd2pvJLP4LtY98ZZ7XK7
         4Z3+cYJ2V2nDzzyT6/7D0+0INBbZsEPizEFuNFLzyIRa8lbdvlTV7miprzwjTHwN4jpE
         8GSQ==
X-Gm-Message-State: ANoB5pm5THL5p6jd626az8yhCTZDsdFl1MKvgNLt+u3mOCNSPSKbaDm9
        WOofMyBtmnXwlQp91T1IFo8=
X-Google-Smtp-Source: AA0mqf6A3y6EKamNPmbP7DEbCyDPEnE34oMCCxkxUPu+0/nPEKln4QgRTaneT1bEOihsQTW//c8lFA==
X-Received: by 2002:a17:906:e2cb:b0:7ad:c35a:ad76 with SMTP id gr11-20020a170906e2cb00b007adc35aad76mr27578205ejb.705.1669288960912;
        Thu, 24 Nov 2022 03:22:40 -0800 (PST)
Received: from localhost (fwdproxy-cln-017.fbsv.net. [2a03:2880:31ff:11::face:b00c])
        by smtp.gmail.com with ESMTPSA id e19-20020a170906315300b007803083a36asm318771eje.115.2022.11.24.03.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 03:22:40 -0800 (PST)
From:   Breno Leitao <leitao@debian.org>
To:     edumazet@google.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, leit@fb.com, yoshfuji@linux-ipv6.org,
        pabeni@redhat.com, dsahern@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND net-next] tcp: socket-specific version of WARN_ON_ONCE()
Date:   Thu, 24 Nov 2022 03:22:29 -0800
Message-Id: <20221124112229.789975-1-leitao@debian.org>
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

There are cases where we need information about the socket during a
warning, so, it could help us to find bugs that happens and do not have
an easy repro.

This diff creates a TCP socket-specific version of WARN_ON_ONCE(), which
dumps more information about the TCP socket.

This new warning is not only useful to give more insight about kernel bugs, but,
it is also helpful to expose information that might be coming from buggy
BPF applications, such as BPF applications that sets invalid
tcp_sock->snd_cwnd values.

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
index 54836a6b81d6..dd682f60c7cb 100644
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

