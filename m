Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF6446D275
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 12:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbhLHLmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 06:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbhLHLl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 06:41:57 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC60C061B38;
        Wed,  8 Dec 2021 03:38:11 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id g14so7309798edb.8;
        Wed, 08 Dec 2021 03:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/nKtrVl1ulxtM0X5OR++FSx2yZEXv1NekgqTYAyFFhY=;
        b=ILngOXr0KdkP7LyAG3WEg39yGNt/nULfis1G4xzdFE7tFqTBgBD0Y+OoZ1kDYZmQjm
         WFTxQS4IZ99RXC6xjFYAX06lbEf1PSHtgBrn614xFA3YTKF6Wla/lvW9OY90FDmwp6jv
         7YH9j45ZkYEkVbFnOv0+8VHM6TJSXzB4gESGRMq6dyG7jV5++luImRvVD+xYFA+EkoIt
         ZckbW6qlHU9AZmNobgWWJ87hmnwQTvrsL9OYCjgwoDoeBnEgvkqHaQ3kRQtN81JjrkUO
         k5hcwgvtt4+SwNJpZeY2zZb4WjNiYFuPAHKQWlREEqQeDZ4RHLcqLYfE8865AaX8pZqf
         ZzuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/nKtrVl1ulxtM0X5OR++FSx2yZEXv1NekgqTYAyFFhY=;
        b=hR83xZQi6L2W2c04axMYJBuAjeZkjl0vKJAYML1PKlK26vd8ui0fiZ/DyVfNoHsH5v
         9tcKkP/m4G4HmrS+7iN/zQu0IjKBkkmdCUkh9nAtEloT9ZT14MvSqP8zwTbro95YqVqd
         0ivPdIbCbxJbuqKEIDxS4nUmIyDCsriI5SgWlhO6zvd91DmaF8iJwp5V+K/cJpFA9k8y
         w5bSNgu3P1pa8U8/ZDkUqPb5pd82X+IOGAjUnDxEFSdDjQhfgaOvYJbSrbgS2gN6qf8V
         x+3YA8F85nNzK+4umcnbfVr8tRCJbLpHRhxN4TRyI3opVY1gr9eSio1OpOk6JpNr3mwW
         nCaQ==
X-Gm-Message-State: AOAM531c4WNW+/2/oI3bzaje8dZ4kvSZtoUy+IUtuSUxdfptik58rmOQ
        aBbgpOGBR167FOnE5DpHnds=
X-Google-Smtp-Source: ABdhPJxWCXjRfdIb7v0Axle9f9T77b39WBPK5r3AYcnFU9McnjCmb+0QqRPRcLCXlzlFIo8Bu9U9Wg==
X-Received: by 2002:a17:906:81cb:: with SMTP id e11mr6651123ejx.186.1638963489694;
        Wed, 08 Dec 2021 03:38:09 -0800 (PST)
Received: from ponky.lan ([2a04:241e:501:3870:3c9f:e05b:4dff:43ba])
        by smtp.gmail.com with ESMTPSA id g11sm1883810edz.53.2021.12.08.03.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 03:38:09 -0800 (PST)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 07/18] tcp: authopt: Disable via sysctl by default
Date:   Wed,  8 Dec 2021 13:37:22 +0200
Message-Id: <e2697ddd7e14863026a288112c23b62e8747f83c.1638962992.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1638962992.git.cdleonard@gmail.com>
References: <cover.1638962992.git.cdleonard@gmail.com>
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
index c04431144f7a..2fa992ef4e02 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -987,10 +987,16 @@ tcp_limit_output_bytes - INTEGER
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
index fb07394de261..4e872af7b180 100644
--- a/include/net/tcp_authopt.h
+++ b/include/net/tcp_authopt.h
@@ -76,10 +76,11 @@ struct tcphdr_authopt {
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
index dd9b89b1f137..85de430d3326 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -3,10 +3,15 @@
 #include <linux/kernel.h>
 #include <net/tcp.h>
 #include <net/tcp_authopt.h>
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
@@ -377,17 +382,30 @@ static int _copy_from_sockptr_tolerant(u8 *dst,
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
 
@@ -405,14 +423,18 @@ int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
 
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
@@ -475,10 +497,13 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
 	struct tcp_authopt_key_info *key_info, *old_key_info;
 	struct tcp_authopt_alg_imp *alg;
 	int err;
 
 	sock_owned_by_me(sk);
+	err = check_sysctl_tcp_authopt();
+	if (err)
+		return err;
 
 	err = _copy_from_sockptr_tolerant((u8 *)&opt, sizeof(opt), optval, optlen);
 	if (err)
 		return err;
 
-- 
2.25.1

