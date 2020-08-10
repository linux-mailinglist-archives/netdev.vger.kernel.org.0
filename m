Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61E1240C2B
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 19:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgHJRjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 13:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbgHJRjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 13:39:52 -0400
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E63EC061756
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 10:39:51 -0700 (PDT)
Received: from pps.filterd (m0122330.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07AHbV3v007627;
        Mon, 10 Aug 2020 18:39:38 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id; s=jan2016.eng;
 bh=iNVemm9ukajg+4aCSNMm24OSvdF4un5QsiYhpFKWAVg=;
 b=P5M6Y02HcmEC7TOL3uBknrkHh/Rvtyy4Qn2cdUn1fAaLpMF5zgsZPqh0TON60fr+E3qC
 IXlL7p2zxj689u7IQsgi1R+gIKpzASgpMkeL2lwUYZU7ab6vvys3wQmDqNAj/SL/CKql
 m9yCT8wajfvw2215m/ZPBVC3iPaRlUxmhIUSEDPUk1Wqnz0O/ajRFB5kR7D/xTRTvkgi
 RClVUdt7x0cnKJ85VzZqG3Ke8U1xv4JrH1ow2kmLq2jSIbxaJ1D9yuemUWhjZVvmJAFW
 8JE2WGv2aJCVwslKDKdgmj2SRZooIlP5fCSD91WJrC4t5FW5bf5/+waVq0MazLnL+w1+ Gg== 
Received: from prod-mail-ppoint3 (a72-247-45-31.deploy.static.akamaitechnologies.com [72.247.45.31] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 32sm6x10bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Aug 2020 18:39:38 +0100
Received: from pps.filterd (prod-mail-ppoint3.akamai.com [127.0.0.1])
        by prod-mail-ppoint3.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 07AHZ7bG001964;
        Mon, 10 Aug 2020 13:39:37 -0400
Received: from prod-mail-relay18.dfw02.corp.akamai.com ([172.27.165.172])
        by prod-mail-ppoint3.akamai.com with ESMTP id 32sqcxbmnb-1;
        Mon, 10 Aug 2020 13:39:37 -0400
Received: from bos-lpjec.145bw.corp.akamai.com (unknown [172.28.3.71])
        by prod-mail-relay18.dfw02.corp.akamai.com (Postfix) with ESMTP id D0FCC27A;
        Mon, 10 Aug 2020 17:39:36 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, colin.king@canonical.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net] tcp: correct read of TFO keys on big endian systems
Date:   Mon, 10 Aug 2020 13:38:39 -0400
Message-Id: <1597081119-22280-1-git-send-email-jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-10_14:2020-08-06,2020-08-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008100124
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-10_14:2020-08-06,2020-08-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 clxscore=1011
 mlxlogscore=999 adultscore=0 spamscore=0 mlxscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008100124
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When TFO keys are read back on big endian systems either via the global
sysctl interface or via getsockopt() using TCP_FASTOPEN_KEY, the values
don't match what was written.

For example, on s390x:

# echo "1-2-3-4" > /proc/sys/net/ipv4/tcp_fastopen_key
# cat /proc/sys/net/ipv4/tcp_fastopen_key
02000000-01000000-04000000-03000000

Instead of:

# cat /proc/sys/net/ipv4/tcp_fastopen_key
00000001-00000002-00000003-00000004

Fix this by converting to the correct endianness on read. This was
reported by Colin Ian King when running the 'tcp_fastopen_backup_key' net
selftest on s390x, which depends on the read value matching what was
written. I've confirmed that the test now passes on big and little endian
systems.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Fixes: 438ac88009bc ("net: fastopen: robustness and endianness fixes for SipHash")
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Eric Dumazet <edumazet@google.com>
Reported-and-tested-by: Colin Ian King <colin.king@canonical.com>
---
 include/net/tcp.h          |  2 ++
 net/ipv4/sysctl_net_ipv4.c | 16 ++++------------
 net/ipv4/tcp.c             | 16 ++++------------
 net/ipv4/tcp_fastopen.c    | 23 +++++++++++++++++++++++
 4 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 4de9485f73d9..0c1d2843a6d7 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1664,6 +1664,8 @@ void tcp_fastopen_destroy_cipher(struct sock *sk);
 void tcp_fastopen_ctx_destroy(struct net *net);
 int tcp_fastopen_reset_cipher(struct net *net, struct sock *sk,
 			      void *primary_key, void *backup_key);
+int tcp_fastopen_get_cipher(struct net *net, struct inet_connection_sock *icsk,
+			    u64 *key);
 void tcp_fastopen_add_skb(struct sock *sk, struct sk_buff *skb);
 struct sock *tcp_try_fastopen(struct sock *sk, struct sk_buff *skb,
 			      struct request_sock *req,
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 5653e3b011bf..54023a46db04 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -301,24 +301,16 @@ static int proc_tcp_fastopen_key(struct ctl_table *table, int write,
 	struct ctl_table tbl = { .maxlen = ((TCP_FASTOPEN_KEY_LENGTH *
 					    2 * TCP_FASTOPEN_KEY_MAX) +
 					    (TCP_FASTOPEN_KEY_MAX * 5)) };
-	struct tcp_fastopen_context *ctx;
-	u32 user_key[TCP_FASTOPEN_KEY_MAX * 4];
-	__le32 key[TCP_FASTOPEN_KEY_MAX * 4];
+	u32 user_key[TCP_FASTOPEN_KEY_BUF_LENGTH / sizeof(u32)];
+	__le32 key[TCP_FASTOPEN_KEY_BUF_LENGTH / sizeof(__le32)];
 	char *backup_data;
-	int ret, i = 0, off = 0, n_keys = 0;
+	int ret, i = 0, off = 0, n_keys;
 
 	tbl.data = kmalloc(tbl.maxlen, GFP_KERNEL);
 	if (!tbl.data)
 		return -ENOMEM;
 
-	rcu_read_lock();
-	ctx = rcu_dereference(net->ipv4.tcp_fastopen_ctx);
-	if (ctx) {
-		n_keys = tcp_fastopen_context_len(ctx);
-		memcpy(&key[0], &ctx->key[0], TCP_FASTOPEN_KEY_LENGTH * n_keys);
-	}
-	rcu_read_unlock();
-
+	n_keys = tcp_fastopen_get_cipher(net, NULL, (u64 *)key);
 	if (!n_keys) {
 		memset(&key[0], 0, TCP_FASTOPEN_KEY_LENGTH);
 		n_keys = 1;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6f0caf9a866d..30c1142584b1 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3694,22 +3694,14 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 		return 0;
 
 	case TCP_FASTOPEN_KEY: {
-		__u8 key[TCP_FASTOPEN_KEY_BUF_LENGTH];
-		struct tcp_fastopen_context *ctx;
-		unsigned int key_len = 0;
+		u64 key[TCP_FASTOPEN_KEY_BUF_LENGTH / sizeof(u64)];
+		unsigned int key_len;
 
 		if (get_user(len, optlen))
 			return -EFAULT;
 
-		rcu_read_lock();
-		ctx = rcu_dereference(icsk->icsk_accept_queue.fastopenq.ctx);
-		if (ctx) {
-			key_len = tcp_fastopen_context_len(ctx) *
-					TCP_FASTOPEN_KEY_LENGTH;
-			memcpy(&key[0], &ctx->key[0], key_len);
-		}
-		rcu_read_unlock();
-
+		key_len = tcp_fastopen_get_cipher(net, icsk, key) *
+				TCP_FASTOPEN_KEY_LENGTH;
 		len = min_t(unsigned int, len, key_len);
 		if (put_user(len, optlen))
 			return -EFAULT;
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 19ad9586c720..1bb85821f1e6 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -108,6 +108,29 @@ int tcp_fastopen_reset_cipher(struct net *net, struct sock *sk,
 	return err;
 }
 
+int tcp_fastopen_get_cipher(struct net *net, struct inet_connection_sock *icsk,
+			    u64 *key)
+{
+	struct tcp_fastopen_context *ctx;
+	int n_keys = 0, i;
+
+	rcu_read_lock();
+	if (icsk)
+		ctx = rcu_dereference(icsk->icsk_accept_queue.fastopenq.ctx);
+	else
+		ctx = rcu_dereference(net->ipv4.tcp_fastopen_ctx);
+	if (ctx) {
+		n_keys = tcp_fastopen_context_len(ctx);
+		for (i = 0; i < n_keys; i++) {
+			put_unaligned_le64(ctx->key[i].key[0], key + (i * 2));
+			put_unaligned_le64(ctx->key[i].key[1], key + (i * 2) + 1);
+		}
+	}
+	rcu_read_unlock();
+
+	return n_keys;
+}
+
 static bool __tcp_fastopen_cookie_gen_cipher(struct request_sock *req,
 					     struct sk_buff *syn,
 					     const siphash_key_t *key,
-- 
2.7.4

