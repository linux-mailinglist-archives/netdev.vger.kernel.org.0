Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B91F270EA
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730080AbfEVUlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 16:41:07 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:60590 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729528AbfEVUlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 16:41:06 -0400
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.16.0.27/8.16.0.27) with SMTP id x4MKauSH004214;
        Wed, 22 May 2019 21:41:00 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : in-reply-to :
 references; s=jan2016.eng;
 bh=K6v4ivrVlubyaosTP3Wr6DCZzqlny+GkTb2jPL5kW+E=;
 b=lk8dfK46Opk6MBqX/oTvFuD9w4BTAroZGP3SCFiZA/K02RvVxqFhnfjn4ZQgMDWBc3cL
 iklpBs6BD+dpfrhAHUiKKtcCm0k+8wh6HgVuu0ZO2zpGQJ24oRVji1853jsiUfXyuy0q
 3iAn9Wap0SiDRnDl71/Kaa+t6rBcd19gf6+AMyCkSNFmc50ndVVbcGFT+CkhRqrlwFZv
 HPxPCeUhiibCa11F2dhiYkMV0cHMnz5jXMNYbkyXjHDs4QLh1Xf4xG1rI5NyQO8bdcFW
 cKdPKdgF3aCX5Ahed73qGQ/2+WABy7etF0uaw6PmvyL3emHB1Po+VyiPpIRnCmo7FioF NA== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by m0050096.ppops.net-00190b01. with ESMTP id 2smxegwvg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 May 2019 21:41:00 +0100
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x4MKX5oB011403;
        Wed, 22 May 2019 16:40:59 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint1.akamai.com with ESMTP id 2sjdcvsjuf-3;
        Wed, 22 May 2019 16:40:58 -0400
Received: from bos-lpjec.kendall.corp.akamai.com (bos-lpjec.kendall.corp.akamai.com [172.29.170.83])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id 0E0EE1FC75;
        Wed, 22 May 2019 20:40:29 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     davem@davemloft.net, edumazet@google.com
Cc:     ycheng@google.com, ilubashe@akamai.com, netdev@vger.kernel.org,
        Christoph Paasch <cpaasch@apple.com>
Subject: [PATCH net-next 2/6] tcp: add backup TFO key infrastructure
Date:   Wed, 22 May 2019 16:39:34 -0400
Message-Id: <e65dbeeb149bab90966ff9f621e741d46d5e7a10.1558557001.git.jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1558557001.git.jbaron@akamai.com>
References: <cover.1558557001.git.jbaron@akamai.com>
In-Reply-To: <cover.1558557001.git.jbaron@akamai.com>
References: <cover.1558557001.git.jbaron@akamai.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905220143
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905220144
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We would like to be able to rotate TFO keys while minimizing the number of
client cookies that are rejected. Currently, we have only one key which can
be used to generate and validate cookies, thus if we simply replace this
key clients can easily have cookies rejected upon rotation.

We propose having the ability to have both a primary key and a backup key.
The primary key is used to generate as well as to validate cookies.
The backup is only used to validate cookies. Thus, keys can be rotated as:

1) generate new key
2) add new key as the backup key
3) swap the primary and backup key, thus setting the new key as the primary

We don't simply set the new key as the primary key and move the old key to
the backup slot because the ip may be behind a load balancer and we further
allow for the fact that all machines behind the load balancer will not be
updated simultaneously.

We make use of this infrastructure in subsequent patches.

Suggested-by: Igor Lubashev <ilubashe@akamai.com>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 include/net/tcp.h          |  41 ++++++++++-
 include/uapi/linux/snmp.h  |   1 +
 net/ipv4/proc.c            |   1 +
 net/ipv4/sysctl_net_ipv4.c |   2 +-
 net/ipv4/tcp.c             |   3 +-
 net/ipv4/tcp_fastopen.c    | 172 +++++++++++++++++++++++++++++++--------------
 6 files changed, 162 insertions(+), 58 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 985aa5d..0083a14 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1614,7 +1614,8 @@ void tcp_free_fastopen_req(struct tcp_sock *tp);
 void tcp_fastopen_destroy_cipher(struct sock *sk);
 void tcp_fastopen_ctx_destroy(struct net *net);
 int tcp_fastopen_reset_cipher(struct net *net, struct sock *sk,
-			      void *key, unsigned int len);
+			      void *primary_key, void *backup_key,
+			      unsigned int len);
 void tcp_fastopen_add_skb(struct sock *sk, struct sk_buff *skb);
 struct sock *tcp_try_fastopen(struct sock *sk, struct sk_buff *skb,
 			      struct request_sock *req,
@@ -1625,11 +1626,14 @@ bool tcp_fastopen_cookie_check(struct sock *sk, u16 *mss,
 			     struct tcp_fastopen_cookie *cookie);
 bool tcp_fastopen_defer_connect(struct sock *sk, int *err);
 #define TCP_FASTOPEN_KEY_LENGTH 16
+#define TCP_FASTOPEN_KEY_MAX 2
+#define TCP_FASTOPEN_KEY_BUF_LENGTH \
+	(TCP_FASTOPEN_KEY_LENGTH * TCP_FASTOPEN_KEY_MAX)
 
 /* Fastopen key context */
 struct tcp_fastopen_context {
-	struct crypto_cipher	*tfm;
-	__u8			key[TCP_FASTOPEN_KEY_LENGTH];
+	struct crypto_cipher	*tfm[TCP_FASTOPEN_KEY_MAX];
+	__u8			key[TCP_FASTOPEN_KEY_BUF_LENGTH];
 	struct rcu_head		rcu;
 };
 
@@ -1639,6 +1643,37 @@ bool tcp_fastopen_active_should_disable(struct sock *sk);
 void tcp_fastopen_active_disable_ofo_check(struct sock *sk);
 void tcp_fastopen_active_detect_blackhole(struct sock *sk, bool expired);
 
+/* Caller needs to wrap with rcu_read_(un)lock() */
+static inline
+struct tcp_fastopen_context *tcp_fastopen_get_ctx(const struct sock *sk)
+{
+	struct tcp_fastopen_context *ctx;
+
+	ctx = rcu_dereference(inet_csk(sk)->icsk_accept_queue.fastopenq.ctx);
+	if (!ctx)
+		ctx = rcu_dereference(sock_net(sk)->ipv4.tcp_fastopen_ctx);
+	return ctx;
+}
+
+static inline
+bool tcp_fastopen_cookie_match(const struct tcp_fastopen_cookie *foc,
+			       const struct tcp_fastopen_cookie *orig)
+{
+	if (orig->len == TCP_FASTOPEN_COOKIE_SIZE &&
+	    orig->len == foc->len &&
+	    !memcmp(orig->val, foc->val, foc->len))
+		return true;
+	return false;
+}
+
+static inline
+int tcp_fastopen_context_len(const struct tcp_fastopen_context *ctx)
+{
+	if (ctx->tfm[1])
+		return 2;
+	return 1;
+}
+
 /* Latencies incurred by various limits for a sender. They are
  * chronograph-like stats that are mutually exclusive.
  */
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 86dc24a..74904e9 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -283,6 +283,7 @@ enum
 	LINUX_MIB_TCPACKCOMPRESSED,		/* TCPAckCompressed */
 	LINUX_MIB_TCPZEROWINDOWDROP,		/* TCPZeroWindowDrop */
 	LINUX_MIB_TCPRCVQDROP,			/* TCPRcvQDrop */
+	LINUX_MIB_TCPFASTOPENPASSIVEALTKEY,	/* TCPFastOpenPassiveAltKey */
 	__LINUX_MIB_MAX
 };
 
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index c3610b3..58daef2 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -291,6 +291,7 @@ static const struct snmp_mib snmp4_net_list[] = {
 	SNMP_MIB_ITEM("TCPAckCompressed", LINUX_MIB_TCPACKCOMPRESSED),
 	SNMP_MIB_ITEM("TCPZeroWindowDrop", LINUX_MIB_TCPZEROWINDOWDROP),
 	SNMP_MIB_ITEM("TCPRcvQDrop", LINUX_MIB_TCPRCVQDROP),
+	SNMP_MIB_ITEM("TCPFastOpenPassiveAltKey", LINUX_MIB_TCPFASTOPENPASSIVEALTKEY),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 875867b..72dc8ca 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -318,7 +318,7 @@ static int proc_tcp_fastopen_key(struct ctl_table *table, int write,
 		for (i = 0; i < ARRAY_SIZE(user_key); i++)
 			key[i] = cpu_to_le32(user_key[i]);
 
-		tcp_fastopen_reset_cipher(net, NULL, key,
+		tcp_fastopen_reset_cipher(net, NULL, key, NULL,
 					  TCP_FASTOPEN_KEY_LENGTH);
 	}
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 53d61ca..bca51a3 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2798,7 +2798,8 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		if (copy_from_user(key, optval, optlen))
 			return -EFAULT;
 
-		return tcp_fastopen_reset_cipher(net, sk, key, sizeof(key));
+		return tcp_fastopen_reset_cipher(net, sk, key, NULL,
+						 sizeof(key));
 	}
 	default:
 		/* fallthru */
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 3889ad2..8e15804 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -30,14 +30,20 @@ void tcp_fastopen_init_key_once(struct net *net)
 	 * for a valid cookie, so this is an acceptable risk.
 	 */
 	get_random_bytes(key, sizeof(key));
-	tcp_fastopen_reset_cipher(net, NULL, key, sizeof(key));
+	tcp_fastopen_reset_cipher(net, NULL, key, NULL, sizeof(key));
 }
 
 static void tcp_fastopen_ctx_free(struct rcu_head *head)
 {
 	struct tcp_fastopen_context *ctx =
 	    container_of(head, struct tcp_fastopen_context, rcu);
-	crypto_free_cipher(ctx->tfm);
+	int i;
+
+	/* We own ctx, thus no need to hold the Fastopen-lock */
+	for (i = 0; i < TCP_FASTOPEN_KEY_MAX; i++) {
+		if (ctx->tfm[i])
+			crypto_free_cipher(ctx->tfm[i]);
+	}
 	kfree(ctx);
 }
 
@@ -66,33 +72,54 @@ void tcp_fastopen_ctx_destroy(struct net *net)
 		call_rcu(&ctxt->rcu, tcp_fastopen_ctx_free);
 }
 
+struct tcp_fastopen_context *tcp_fastopen_alloc_ctx(void *primary_key,
+						    void *backup_key,
+						    unsigned int len)
+{
+	struct tcp_fastopen_context *new_ctx;
+	void *key = primary_key;
+	int err, i;
+
+	new_ctx = kmalloc(sizeof(*new_ctx), GFP_KERNEL);
+	if (!new_ctx)
+		return ERR_PTR(-ENOMEM);
+	for (i = 0; i < TCP_FASTOPEN_KEY_MAX; i++)
+		new_ctx->tfm[i] = NULL;
+	for (i = 0; i < (backup_key ? 2 : 1); i++) {
+		new_ctx->tfm[i] = crypto_alloc_cipher("aes", 0, 0);
+		if (IS_ERR(new_ctx->tfm[i])) {
+			err = PTR_ERR(new_ctx->tfm[i]);
+			new_ctx->tfm[i] = NULL;
+			pr_err("TCP: TFO aes cipher alloc error: %d\n", err);
+			goto out;
+		}
+		err = crypto_cipher_setkey(new_ctx->tfm[i], key, len);
+		if (err) {
+			pr_err("TCP: TFO cipher key error: %d\n", err);
+			goto out;
+		}
+		memcpy(&new_ctx->key[i * TCP_FASTOPEN_KEY_LENGTH], key, len);
+		key = backup_key;
+	}
+	return new_ctx;
+out:
+	tcp_fastopen_ctx_free(&new_ctx->rcu);
+	return ERR_PTR(err);
+}
+
 int tcp_fastopen_reset_cipher(struct net *net, struct sock *sk,
-			      void *key, unsigned int len)
+			      void *primary_key, void *backup_key,
+			      unsigned int len)
 {
 	struct tcp_fastopen_context *ctx, *octx;
 	struct fastopen_queue *q;
-	int err;
+	int err = 0;
 
-	ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
-	if (!ctx)
-		return -ENOMEM;
-	ctx->tfm = crypto_alloc_cipher("aes", 0, 0);
-
-	if (IS_ERR(ctx->tfm)) {
-		err = PTR_ERR(ctx->tfm);
-error:		kfree(ctx);
-		pr_err("TCP: TFO aes cipher alloc error: %d\n", err);
-		return err;
-	}
-	err = crypto_cipher_setkey(ctx->tfm, key, len);
-	if (err) {
-		pr_err("TCP: TFO cipher key error: %d\n", err);
-		crypto_free_cipher(ctx->tfm);
-		goto error;
+	ctx = tcp_fastopen_alloc_ctx(primary_key, backup_key, len);
+	if (IS_ERR(ctx)) {
+		err = PTR_ERR(ctx);
+		goto out;
 	}
-	memcpy(ctx->key, key, len);
-
-
 	spin_lock(&net->ipv4.tcp_fastopen_ctx_lock);
 	if (sk) {
 		q = &inet_csk(sk)->icsk_accept_queue.fastopenq;
@@ -108,6 +135,7 @@ error:		kfree(ctx);
 
 	if (octx)
 		call_rcu(&octx->rcu, tcp_fastopen_ctx_free);
+out:
 	return err;
 }
 
@@ -151,25 +179,20 @@ static bool __tcp_fastopen_cookie_gen_cipher(struct request_sock *req,
  *
  * XXX (TFO) - refactor when TCP_FASTOPEN_COOKIE_SIZE != AES_BLOCK_SIZE.
  */
-static bool tcp_fastopen_cookie_gen(struct sock *sk,
+static void tcp_fastopen_cookie_gen(struct sock *sk,
 				    struct request_sock *req,
 				    struct sk_buff *syn,
 				    struct tcp_fastopen_cookie *foc)
 {
 	struct tcp_fastopen_context *ctx;
-	bool ok = false;
 
 	rcu_read_lock();
-	ctx = rcu_dereference(inet_csk(sk)->icsk_accept_queue.fastopenq.ctx);
-	if (!ctx)
-		ctx = rcu_dereference(sock_net(sk)->ipv4.tcp_fastopen_ctx);
+	ctx = tcp_fastopen_get_ctx(sk);
 	if (ctx)
-		ok = __tcp_fastopen_cookie_gen_cipher(req, syn, ctx->tfm, foc);
+		__tcp_fastopen_cookie_gen_cipher(req, syn, ctx->tfm[0], foc);
 	rcu_read_unlock();
-	return ok;
 }
 
-
 /* If an incoming SYN or SYNACK frame contains a payload and/or FIN,
  * queue this additional data / FIN.
  */
@@ -213,6 +236,35 @@ void tcp_fastopen_add_skb(struct sock *sk, struct sk_buff *skb)
 		tcp_fin(sk);
 }
 
+/* returns 0 - no key match, 1 for primary, 2 for backup */
+static int tcp_fastopen_cookie_gen_check(struct sock *sk,
+					 struct request_sock *req,
+					 struct sk_buff *syn,
+					 struct tcp_fastopen_cookie *orig,
+					 struct tcp_fastopen_cookie *valid_foc)
+{
+	struct tcp_fastopen_cookie search_foc = { .len = -1 };
+	struct tcp_fastopen_cookie *foc = valid_foc;
+	struct tcp_fastopen_context *ctx;
+	int i, ret = 0;
+
+	rcu_read_lock();
+	ctx = tcp_fastopen_get_ctx(sk);
+	if (!ctx)
+		goto out;
+	for (i = 0; i < tcp_fastopen_context_len(ctx); i++) {
+		__tcp_fastopen_cookie_gen_cipher(req, syn, ctx->tfm[i], foc);
+		if (tcp_fastopen_cookie_match(foc, orig)) {
+			ret = i + 1;
+			goto out;
+		}
+		foc = &search_foc;
+	}
+out:
+	rcu_read_unlock();
+	return ret;
+}
+
 static struct sock *tcp_fastopen_create_child(struct sock *sk,
 					      struct sk_buff *skb,
 					      struct request_sock *req)
@@ -332,6 +384,7 @@ struct sock *tcp_try_fastopen(struct sock *sk, struct sk_buff *skb,
 	int tcp_fastopen = sock_net(sk)->ipv4.sysctl_tcp_fastopen;
 	struct tcp_fastopen_cookie valid_foc = { .len = -1 };
 	struct sock *child;
+	int ret = 0;
 
 	if (foc->len == 0) /* Client requests a cookie */
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPFASTOPENCOOKIEREQD);
@@ -347,31 +400,44 @@ struct sock *tcp_try_fastopen(struct sock *sk, struct sk_buff *skb,
 	    tcp_fastopen_no_cookie(sk, dst, TFO_SERVER_COOKIE_NOT_REQD))
 		goto fastopen;
 
-	if (foc->len >= 0 &&  /* Client presents or requests a cookie */
-	    tcp_fastopen_cookie_gen(sk, req, skb, &valid_foc) &&
-	    foc->len == TCP_FASTOPEN_COOKIE_SIZE &&
-	    foc->len == valid_foc.len &&
-	    !memcmp(foc->val, valid_foc.val, foc->len)) {
-		/* Cookie is valid. Create a (full) child socket to accept
-		 * the data in SYN before returning a SYN-ACK to ack the
-		 * data. If we fail to create the socket, fall back and
-		 * ack the ISN only but includes the same cookie.
-		 *
-		 * Note: Data-less SYN with valid cookie is allowed to send
-		 * data in SYN_RECV state.
-		 */
+	if (foc->len == 0) {
+		/* Client requests a cookie. */
+		tcp_fastopen_cookie_gen(sk, req, skb, &valid_foc);
+	} else if (foc->len > 0) {
+		ret = tcp_fastopen_cookie_gen_check(sk, req, skb, foc,
+						    &valid_foc);
+		if (!ret) {
+			NET_INC_STATS(sock_net(sk),
+				      LINUX_MIB_TCPFASTOPENPASSIVEFAIL);
+		} else {
+			/* Cookie is valid. Create a (full) child socket to
+			 * accept the data in SYN before returning a SYN-ACK to
+			 * ack the data. If we fail to create the socket, fall
+			 * back and ack the ISN only but includes the same
+			 * cookie.
+			 *
+			 * Note: Data-less SYN with valid cookie is allowed to
+			 * send data in SYN_RECV state.
+			 */
 fastopen:
-		child = tcp_fastopen_create_child(sk, skb, req);
-		if (child) {
-			foc->len = -1;
+			child = tcp_fastopen_create_child(sk, skb, req);
+			if (child) {
+				if (ret == 2) {
+					valid_foc.exp = foc->exp;
+					*foc = valid_foc;
+					NET_INC_STATS(sock_net(sk),
+						      LINUX_MIB_TCPFASTOPENPASSIVEALTKEY);
+				} else {
+					foc->len = -1;
+				}
+				NET_INC_STATS(sock_net(sk),
+					      LINUX_MIB_TCPFASTOPENPASSIVE);
+				return child;
+			}
 			NET_INC_STATS(sock_net(sk),
-				      LINUX_MIB_TCPFASTOPENPASSIVE);
-			return child;
+				      LINUX_MIB_TCPFASTOPENPASSIVEFAIL);
 		}
-		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPFASTOPENPASSIVEFAIL);
-	} else if (foc->len > 0) /* Client presents an invalid cookie */
-		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPFASTOPENPASSIVEFAIL);
-
+	}
 	valid_foc.exp = foc->exp;
 	*foc = valid_foc;
 	return NULL;
-- 
2.7.4

