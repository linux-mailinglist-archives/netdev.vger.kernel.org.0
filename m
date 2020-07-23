Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85BA22A780
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 08:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgGWGKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 02:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727808AbgGWGJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 02:09:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910CCC0619DC;
        Wed, 22 Jul 2020 23:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=UdgYuJlmWZokLcAOPnfw8PlZRvn7vjQf/6iOObq/cjM=; b=aIaMhclEEnD1ULwrKvn78xfvE4
        8LhP29U8BKD5dCx/PZ4xzwjJk056rLJlvUegZOy3Vu6Yef9on/jdjTYZDrYzfTZl8bVQbbTop0UWR
        M8Yx1TSJ9NA/9mJk31ud6h2bSkcvPf+C2+x6wKPLcYNdkFZ6us0Lb3ds14cqloxiLsw3vi7XqwMx5
        hpYczsqWiGeLGvsYypY38x3+nsPb17XruzF454E+faRyBokX2ig/VaOf+Jyic1oOFiasUFAxiY5zh
        h3Y5fDzIOIWdfMwKL7ZrXjv5DnfDd7AZWh3ZQ4AiSNMLsHjYpJvbeUT3B/4GZ+BqlGh21EpzBzSK+
        4fcp8kXw==;
Received: from [2001:4bb8:18c:2acc:91df:aae8:fa3b:de9c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jyUQJ-0003pG-7a; Thu, 23 Jul 2020 06:09:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: [PATCH 24/26] net/tcp: switch do_tcp_setsockopt to sockptr_t
Date:   Thu, 23 Jul 2020 08:09:06 +0200
Message-Id: <20200723060908.50081-25-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200723060908.50081-1-hch@lst.de>
References: <20200723060908.50081-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass a sockptr_t to prepare for set_fs-less handling of the kernel
pointer from bpf-cgroup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/ipv4/tcp.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 49bf15c27deac7..71cbc61c335f71 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2764,7 +2764,7 @@ static inline bool tcp_can_repair_sock(const struct sock *sk)
 		(sk->sk_state != TCP_LISTEN);
 }
 
-static int tcp_repair_set_window(struct tcp_sock *tp, char __user *optbuf, int len)
+static int tcp_repair_set_window(struct tcp_sock *tp, sockptr_t optbuf, int len)
 {
 	struct tcp_repair_window opt;
 
@@ -2774,7 +2774,7 @@ static int tcp_repair_set_window(struct tcp_sock *tp, char __user *optbuf, int l
 	if (len != sizeof(opt))
 		return -EINVAL;
 
-	if (copy_from_user(&opt, optbuf, sizeof(opt)))
+	if (copy_from_sockptr(&opt, optbuf, sizeof(opt)))
 		return -EFAULT;
 
 	if (opt.max_window < opt.snd_wnd)
@@ -2796,17 +2796,17 @@ static int tcp_repair_set_window(struct tcp_sock *tp, char __user *optbuf, int l
 	return 0;
 }
 
-static int tcp_repair_options_est(struct sock *sk,
-		struct tcp_repair_opt __user *optbuf, unsigned int len)
+static int tcp_repair_options_est(struct sock *sk, sockptr_t optbuf,
+		unsigned int len)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_repair_opt opt;
 
 	while (len >= sizeof(opt)) {
-		if (copy_from_user(&opt, optbuf, sizeof(opt)))
+		if (copy_from_sockptr(&opt, optbuf, sizeof(opt)))
 			return -EFAULT;
 
-		optbuf++;
+		sockptr_advance(optbuf, sizeof(opt));
 		len -= sizeof(opt);
 
 		switch (opt.opt_code) {
@@ -3020,8 +3020,8 @@ EXPORT_SYMBOL(tcp_sock_set_keepcnt);
 /*
  *	Socket option code for TCP.
  */
-static int do_tcp_setsockopt(struct sock *sk, int level,
-		int optname, char __user *optval, unsigned int optlen)
+static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
+		sockptr_t optval, unsigned int optlen)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
@@ -3037,7 +3037,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		if (optlen < 1)
 			return -EINVAL;
 
-		val = strncpy_from_user(name, optval,
+		val = strncpy_from_sockptr(name, optval,
 					min_t(long, TCP_CA_NAME_MAX-1, optlen));
 		if (val < 0)
 			return -EFAULT;
@@ -3056,7 +3056,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		if (optlen < 1)
 			return -EINVAL;
 
-		val = strncpy_from_user(name, optval,
+		val = strncpy_from_sockptr(name, optval,
 					min_t(long, TCP_ULP_NAME_MAX - 1,
 					      optlen));
 		if (val < 0)
@@ -3079,7 +3079,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		    optlen != TCP_FASTOPEN_KEY_BUF_LENGTH)
 			return -EINVAL;
 
-		if (copy_from_user(key, optval, optlen))
+		if (copy_from_sockptr(key, optval, optlen))
 			return -EFAULT;
 
 		if (optlen == TCP_FASTOPEN_KEY_BUF_LENGTH)
@@ -3095,7 +3095,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 	if (optlen < sizeof(int))
 		return -EINVAL;
 
-	if (get_user(val, (int __user *)optval))
+	if (copy_from_sockptr(&val, optval, sizeof(val)))
 		return -EFAULT;
 
 	lock_sock(sk);
@@ -3174,9 +3174,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		if (!tp->repair)
 			err = -EINVAL;
 		else if (sk->sk_state == TCP_ESTABLISHED)
-			err = tcp_repair_options_est(sk,
-					(struct tcp_repair_opt __user *)optval,
-					optlen);
+			err = tcp_repair_options_est(sk, optval, optlen);
 		else
 			err = -EPERM;
 		break;
@@ -3249,8 +3247,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 #ifdef CONFIG_TCP_MD5SIG
 	case TCP_MD5SIG:
 	case TCP_MD5SIG_EXT:
-		err = tp->af_specific->md5_parse(sk, optname,
-						 USER_SOCKPTR(optval), optlen);
+		err = tp->af_specific->md5_parse(sk, optname, optval, optlen);
 		break;
 #endif
 	case TCP_USER_TIMEOUT:
@@ -3334,7 +3331,8 @@ int tcp_setsockopt(struct sock *sk, int level, int optname, char __user *optval,
 	if (level != SOL_TCP)
 		return icsk->icsk_af_ops->setsockopt(sk, level, optname,
 						     optval, optlen);
-	return do_tcp_setsockopt(sk, level, optname, optval, optlen);
+	return do_tcp_setsockopt(sk, level, optname, USER_SOCKPTR(optval),
+				 optlen);
 }
 EXPORT_SYMBOL(tcp_setsockopt);
 
-- 
2.27.0

