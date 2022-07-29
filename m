Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021E558544B
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 19:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237943AbiG2RQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 13:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238249AbiG2RQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 13:16:47 -0400
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8934981489
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 10:16:46 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id z23so9639927eju.8
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 10:16:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=26des9374/CzrFy5DJDpb080L+e4dcCl9s6cMrN4an4=;
        b=4nZtzGBtxfqqTfPULtzF/nNO1/F2QTeXtyFMH8NOvMH1xWq0z04C/AIz5jUEfhyj7c
         EtPCDyu9RXSLuQKus818F/7KP8ro7pZIppvEkJBKtS+6lCu1IOdUslNU3hvP3nv4rQEq
         FkwPiO2/NJj7Y7D7XX7QFsQNTs4a2GZZjwhuFxmPL/rSY52fDMsxQ9lwS4cu9AcL+RAE
         Ddj/uFhLxLeoVHsdfg1pDz9KMdsG9TJXjiyw3WfbLcKD5/yeqjvPsqcMdnT1MAYkOFdk
         /6EMt8SUPhgPxYc6LYA8mUQgPVFlpNM2CMVP+VII/apm4dS4KcwKa153GAlNbHDjr2lY
         tEDQ==
X-Gm-Message-State: AJIora+A3Y9M6CAREWEOzp2p9TaV3VPnpxGNOSB9ZvJoxZgwFjsybp4G
        /iO3AcTF5Q0WfLppMJmec40=
X-Google-Smtp-Source: AGRyM1tGZg2iH+RQ6qfQjIiJsDeKXP5gEid4DnnyUeANEQwfhOz6TXaWu6W1BkxFnoW/yon2reqkQA==
X-Received: by 2002:a17:907:7b87:b0:72e:d45a:17af with SMTP id ne7-20020a1709077b8700b0072ed45a17afmr3644213ejc.73.1659115004875;
        Fri, 29 Jul 2022 10:16:44 -0700 (PDT)
Received: from localhost (fwdproxy-cln-012.fbsv.net. [2a03:2880:31ff:c::face:b00c])
        by smtp.gmail.com with ESMTPSA id 20-20020a170906309400b0072b4e4cd346sm1936599ejv.188.2022.07.29.10.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 10:16:44 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     edumazet@google.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, leit@fb.com
Subject: [PATCH net-next] tcp: socket-specific version of WARN_ON_ONCE()
Date:   Fri, 29 Jul 2022 10:15:54 -0700
Message-Id: <20220729171554.3992869-1-leitao@debian.org>
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
index 071735e10872..eca7e58a3117 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -40,6 +40,7 @@
 #include <net/inet_ecn.h>
 #include <net/dst.h>
 #include <net/mptcp.h>
+#include <net/tcp_debug.h>
 
 #include <linux/seq_file.h>
 #include <linux/memcontrol.h>
@@ -1216,7 +1217,7 @@ static inline u32 tcp_snd_cwnd(const struct tcp_sock *tp)
 
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
index 2faaaaf540ac..7abd1634e876 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4556,6 +4556,36 @@ int tcp_abort(struct sock *sk, int err)
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

