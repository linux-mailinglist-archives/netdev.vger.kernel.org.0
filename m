Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4DE497EE1
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239126AbiAXMOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:14:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239337AbiAXMNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 07:13:53 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB8CC06175B;
        Mon, 24 Jan 2022 04:13:34 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id a18so56083203edj.7;
        Mon, 24 Jan 2022 04:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BT0N+mBdL9R3phVhARFj9DJx7yeK/bOu1MSb5TcmPCI=;
        b=iuCoTNHG7dG7srRO7V3jovl1cw/MwnjZ5OP1FZ+3bk81s7ZDQxSKzjaX1kSm/ZCxSD
         g0nay9blXuATdQdBOL3v7qlsxa59ghMYcqEuJ2jze52M05tUXYqik4gkRlMQvf91U35C
         mjYzMH8hcHqgSi5Ho6Fjl4GkdYQgBuRodnzN6QZYgzt3Q4KTrIZ3ulhW1Vf+AEwfPk9z
         qUmfWayzHdpNJ4jo40Ovhd3Z5GrDMcauwQP1pr2ntyYmu4bk2U93iNhD9U20SjrZSR2F
         nLEJPYlq2dot1igqSq/pRC6GwpNFSsuCFg4gBlOMOAltpcQ8wNtxB3hFwoOmp+toHHL/
         k7jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BT0N+mBdL9R3phVhARFj9DJx7yeK/bOu1MSb5TcmPCI=;
        b=NekMtwUg9aI5Ee/zlHK4c3qvwSKM+ODfLVN8y0HRBgMRZQ4qdg5S5XRdddpxf99Z1g
         yoWOmXI5/rTO/Uxr8eYDML5E+9IOA1jD+RHnhLIG3LrBUM2qlnioZx8GrN0Vfj1mSu8M
         E7fhfHeoC6EabVSMMBKmgZJA1jcylqLQ6KvbgdyHTQ5H5JP6VC7pcFx/uCCR6MLFi945
         MxSooZ8qYZu9mTkToWsmXf9QLnbDMCjB3HOZ/Jm9Qfl4p2MJ+Ovx7jQCVr36L6IjYjNc
         UuT0mCkAUIMIXJ80na67hK/6dyStpvCD2GkqfiCJSyGgL1FDnY2P/MILGf3bN/8Hk3u0
         KWmw==
X-Gm-Message-State: AOAM533GhftMsNJsAhp1mKmKY2IOwL2FYssrD8UXlnIBu5bRgUAWgt4I
        VgGLXpH9+V4oARe6zt8Vbek=
X-Google-Smtp-Source: ABdhPJx70wonuqw38pu610pwgLLQM/T5YpBn/MMj0Ua19qCBC+ybS6sFSSGUYdHxsN8UGBro3wh1ew==
X-Received: by 2002:aa7:d547:: with SMTP id u7mr15472231edr.76.1643026413133;
        Mon, 24 Jan 2022 04:13:33 -0800 (PST)
Received: from ponky.lan ([2a04:241e:502:a09c:a21f:7a9f:9158:4a40])
        by smtp.gmail.com with ESMTPSA id b16sm4847517eja.211.2022.01.24.04.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 04:13:32 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Philip Paeps <philip@trouble.is>,
        Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 07/20] tcp: authopt: Disable via sysctl by default
Date:   Mon, 24 Jan 2022 14:12:53 +0200
Message-Id: <051b3a9bb5bc9e7776240a193f1b85836cead600.1643026076.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1643026076.git.cdleonard@gmail.com>
References: <cover.1643026076.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is mainly intended to protect against local privilege escalations
through a rarely used feature so it is deliberately not namespaced.

Enforcement is only at the setsockopt level, this should be enough to
ensure that the tcp_authopt_needed static key never turns on.

No effort is made to handle disabling when the feature is already in
use.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 Documentation/networking/ip-sysctl.rst |  6 ++++
 include/net/tcp_authopt.h              |  1 +
 net/ipv4/sysctl_net_ipv4.c             | 39 ++++++++++++++++++++++++++
 net/ipv4/tcp_authopt.c                 | 27 +++++++++++++++++-
 4 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 2572eecc3e86..fb732f134ddd 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -989,10 +989,16 @@ tcp_limit_output_bytes - INTEGER
 tcp_challenge_ack_limit - INTEGER
 	Limits number of Challenge ACK sent per second, as recommended
 	in RFC 5961 (Improving TCP's Robustness to Blind In-Window Attacks)
 	Default: 1000
 
+tcp_authopt - BOOLEAN
+	Enable the TCP Authentication Option (RFC5925), a replacement for TCP
+	MD5 Signatures (RFC2835).
+
+	Default: 0
+
 UDP variables
 =============
 
 udp_l3mdev_accept - BOOLEAN
 	Enabling this option allows a "global" bound socket to work
diff --git a/include/net/tcp_authopt.h b/include/net/tcp_authopt.h
index 7096e3ad59a6..4c9ec1f39932 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -80,10 +80,11 @@ struct tcphdr_authopt {
 };
 
 #ifdef CONFIG_TCP_AUTHOPT
 DECLARE_STATIC_KEY_FALSE(tcp_authopt_needed_key);
 #define tcp_authopt_needed (static_branch_unlikely(&tcp_authopt_needed_key))
+extern int sysctl_tcp_authopt;
 
 void tcp_authopt_free(struct sock *sk, struct tcp_authopt_info *info);
 void tcp_authopt_clear(struct sock *sk);
 int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen);
 int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *key);
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 97eb54774924..07de2666314c 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -17,10 +17,11 @@
 #include <net/udp.h>
 #include <net/cipso_ipv4.h>
 #include <net/ping.h>
 #include <net/protocol.h>
 #include <net/netevent.h>
+#include <net/tcp_authopt.h>
 
 static int two = 2;
 static int three __maybe_unused = 3;
 static int four = 4;
 static int thousand = 1000;
@@ -472,10 +473,37 @@ static int proc_fib_multipath_hash_fields(struct ctl_table *table, int write,
 
 	return ret;
 }
 #endif
 
+#ifdef CONFIG_TCP_AUTHOPT
+static int proc_tcp_authopt(struct ctl_table *ctl,
+			    int write, void *buffer, size_t *lenp,
+			    loff_t *ppos)
+{
+	int val = sysctl_tcp_authopt;
+	struct ctl_table tmp = {
+		.data = &val,
+		.mode = ctl->mode,
+		.maxlen = sizeof(val),
+		.extra1 = SYSCTL_ZERO,
+		.extra2 = SYSCTL_ONE,
+	};
+	int err;
+
+	err = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
+	if (err)
+		return err;
+	if (sysctl_tcp_authopt && !val) {
+		net_warn_ratelimited("Enabling TCP Authentication Option is permanent\n");
+		return -EINVAL;
+	}
+	sysctl_tcp_authopt = val;
+	return 0;
+}
+#endif
+
 static struct ctl_table ipv4_table[] = {
 	{
 		.procname	= "tcp_max_orphans",
 		.data		= &sysctl_tcp_max_orphans,
 		.maxlen		= sizeof(int),
@@ -583,10 +611,21 @@ static struct ctl_table ipv4_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_douintvec_minmax,
 		.extra1		= &sysctl_fib_sync_mem_min,
 		.extra2		= &sysctl_fib_sync_mem_max,
 	},
+#ifdef CONFIG_TCP_AUTHOPT
+	{
+		.procname	= "tcp_authopt",
+		.data		= &sysctl_tcp_authopt,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_tcp_authopt,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif
 	{ }
 };
 
 static struct ctl_table ipv4_net_table[] = {
 	{
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 694dbc9f3a94..939dfb4a6f12 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -4,10 +4,15 @@
 #include <net/ipv6.h>
 #include <net/tcp.h>
 #include <linux/kref.h>
 #include <crypto/hash.h>
 
+/* This is mainly intended to protect against local privilege escalations through
+ * a rarely used feature so it is deliberately not namespaced.
+ */
+int sysctl_tcp_authopt;
+
 /* This is enabled when first struct tcp_authopt_info is allocated and never released */
 DEFINE_STATIC_KEY_FALSE(tcp_authopt_needed_key);
 EXPORT_SYMBOL(tcp_authopt_needed_key);
 
 /* All current algorithms have a mac length of 12 but crypto API digestsize can be larger */
@@ -430,17 +435,30 @@ static int _copy_from_sockptr_tolerant(u8 *dst,
 		memset(dst + srclen, 0, dstlen - srclen);
 
 	return err;
 }
 
+static int check_sysctl_tcp_authopt(void)
+{
+	if (!sysctl_tcp_authopt) {
+		net_warn_ratelimited("TCP Authentication Option disabled by sysctl.\n");
+		return -EPERM;
+	}
+
+	return 0;
+}
+
 int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
 {
 	struct tcp_authopt opt;
 	struct tcp_authopt_info *info;
 	int err;
 
 	sock_owned_by_me(sk);
+	err = check_sysctl_tcp_authopt();
+	if (err)
+		return err;
 
 	err = _copy_from_sockptr_tolerant((u8 *)&opt, sizeof(opt), optval, optlen);
 	if (err)
 		return err;
 
@@ -458,14 +476,18 @@ int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
 
 int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_authopt_info *info;
+	int err;
 
+	memset(opt, 0, sizeof(*opt));
 	sock_owned_by_me(sk);
+	err = check_sysctl_tcp_authopt();
+	if (err)
+		return err;
 
-	memset(opt, 0, sizeof(*opt));
 	info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
 	if (!info)
 		return -ENOENT;
 
 	opt->flags = info->flags & TCP_AUTHOPT_KNOWN_FLAGS;
@@ -486,10 +508,13 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	struct netns_tcp_authopt *net = sock_net_tcp_authopt(sk);
 	struct tcp_authopt_alg_imp *alg;
 	int err;
 
 	sock_owned_by_me(sk);
+	err = check_sysctl_tcp_authopt();
+	if (err)
+		return err;
 	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	err = _copy_from_sockptr_tolerant((u8 *)&opt, sizeof(opt), optval, optlen);
 	if (err)
-- 
2.25.1

