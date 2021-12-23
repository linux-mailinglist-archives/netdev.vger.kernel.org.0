Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E83D47E5BB
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 16:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349285AbhLWPl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 10:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349080AbhLWPk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 10:40:57 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2D6C061763;
        Thu, 23 Dec 2021 07:40:50 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id o6so22974342edc.4;
        Thu, 23 Dec 2021 07:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D9NCFWuovE5/gne38khmJwHLjO1KbxvtMh1bmnt68Y8=;
        b=p092mNJqUcXIERjF1bU0yMXrGueKvKfHmiFQ+kpFtp+kEInGvyYy6jk3Vfnkimowu2
         qFXyHxML4DT9+d5NxS7Xh3Cx//7Hi/8V1Fesfux5CdenO9J6ICXes2VvuaTrpHGoSGwi
         68Ucvp1dQdzoMr4EcmWTYewoNi8KVo5GJo1JGt0Npjy4zBvFHN2+bld076Kbp6NTObiK
         vQXOtFqVaafRbgyHfORwuRjMDIs1cTO2N4/qeZqH3k23jPKUans5Mx+xyjD3rfZirZGX
         yQS1FWJwZZeoUaAGxUVxbLzQScCMZRDOZiAf3XMsXYBVsurdb0Pmif+QC3Ru/8ajFM2x
         0jrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D9NCFWuovE5/gne38khmJwHLjO1KbxvtMh1bmnt68Y8=;
        b=jhoumE3M0s6818otvN6BcG3TTjdw54a9KlygQJmtc82pctPybSo0dO6y+MNA4puYLA
         9VlKjyvPAEcV5MHMMfdiZfiW+7XUsON+JNZFhB0zqHJtJYGiuj9YvNrianqnree7Sso6
         3m11NM1KXM5PN9PX4pwWMe5gyb2spCZRrKcumMK1x825IftTzighSh2w9T8kV6lalgyb
         1kOM/qnHjktySKhjyBR+s+zbaYWUnKnrQ/wH8LPP94mak9oarRIpFfNzMHmWjxc7TnGb
         2pQ3TM2a2QhTadsEi88Ghhv3h+LF46YKrv+uuQrNoAbBVBEqwi6CCADvk0Kjseo/LmTP
         Gm2Q==
X-Gm-Message-State: AOAM530DFC/1Qh+OLoXw7qS8iXRwY+rOJKWTExkoJ1DNtJ8RzwChFp4D
        WF6435Qyg+9uPxHREIYOsnw=
X-Google-Smtp-Source: ABdhPJyTCjyZ/as3+omHCjOhOt7qp4EcKlC6BQjiLKryJvs57IpQZCPF+NvfGVRvcupgZNpglKZU2Q==
X-Received: by 2002:aa7:cfd5:: with SMTP id r21mr2464790edy.98.1640274049264;
        Thu, 23 Dec 2021 07:40:49 -0800 (PST)
Received: from ponky.lan ([2a04:241e:501:3870:7c02:dfc6:b554:ab10])
        by smtp.gmail.com with ESMTPSA id bx6sm2088617edb.78.2021.12.23.07.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 07:40:48 -0800 (PST)
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
Subject: [PATCH v4 07/19] tcp: authopt: Disable via sysctl by default
Date:   Thu, 23 Dec 2021 17:40:02 +0200
Message-Id: <c76311e735fa98af72280a3ef89d22ace28af0e9.1640273966.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1640273966.git.cdleonard@gmail.com>
References: <cover.1640273966.git.cdleonard@gmail.com>
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
index ba20a70359ee..6be5dbcd530e 100644
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
@@ -425,17 +430,30 @@ static int _copy_from_sockptr_tolerant(u8 *dst,
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
 
@@ -453,14 +471,18 @@ int tcp_set_authopt(struct sock *sk, sockptr_t optval, unsigned int optlen)
 
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
@@ -481,10 +503,13 @@ int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
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

