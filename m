Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF31270E8
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729830AbfEVUlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 16:41:02 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:52700 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728761AbfEVUlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 16:41:02 -0400
Received: from pps.filterd (m0122331.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4MKbW0w014653;
        Wed, 22 May 2019 21:40:57 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : in-reply-to :
 references; s=jan2016.eng;
 bh=w3o6UDBZW5sIaAHSCFHSLi4ZpymISa/BQ7tBDlbblZ4=;
 b=io+6buc14Plg8bTLTMdS6v8zDzpbH9f8lriB2RMcAndrmIwXKt5RtdCPkhNDXN0/ZsbN
 0uCuKd+kayHyYeNdpkUSgMEo937GCCzQGBJZyRlEHZ/aeBL4rQ263o7hGDMMbMzWT5ak
 poYILp005RoknAw098otNEUCiQbIs9u5NfkTRjHOlSUENZWJ5odRM2XbmP/iAA/zJx/F
 JvYlE57H/tHltfAfdvucV3xCV19NU0DTYjuWsqh+g5QUXT3IJnbT+aV1LHG/pE+i4T6l
 3jmstg1a3XUR2hXuPELuPlX5NYRhFoXAM2cYDEI/jM7FK9GD9FYkAtecWoKGDNwmBeHJ KA== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 2snaqf0hxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 May 2019 21:40:57 +0100
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x4MKX5o5011403;
        Wed, 22 May 2019 16:40:56 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint1.akamai.com with ESMTP id 2sjdcvsjuf-2;
        Wed, 22 May 2019 16:40:56 -0400
Received: from bos-lpjec.kendall.corp.akamai.com (bos-lpjec.kendall.corp.akamai.com [172.29.170.83])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id 24BD71FC72;
        Wed, 22 May 2019 20:40:28 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     davem@davemloft.net, edumazet@google.com
Cc:     ycheng@google.com, ilubashe@akamai.com, netdev@vger.kernel.org,
        Christoph Paasch <cpaasch@apple.com>
Subject: [PATCH net-next 1/6] tcp: introduce __tcp_fastopen_cookie_gen_cipher()
Date:   Wed, 22 May 2019 16:39:33 -0400
Message-Id: <60c068635077623e588fc7f1c84d37ef4f86afbd.1558557001.git.jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1558557001.git.jbaron@akamai.com>
References: <cover.1558557001.git.jbaron@akamai.com>
In-Reply-To: <cover.1558557001.git.jbaron@akamai.com>
References: <cover.1558557001.git.jbaron@akamai.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905220143
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905220144
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Paasch <cpaasch@apple.com>

Restructure __tcp_fastopen_cookie_gen() to take a 'struct crypto_cipher'
argument and rename it as __tcp_fastopen_cookie_gen_cipher(). Subsequent
patches will provide different ciphers based on which key is being used for
the cookie generation.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
---
 net/ipv4/tcp_fastopen.c | 73 +++++++++++++++++++++++++------------------------
 1 file changed, 37 insertions(+), 36 deletions(-)

diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 018a484..3889ad2 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -111,25 +111,38 @@ error:		kfree(ctx);
 	return err;
 }
 
-static bool __tcp_fastopen_cookie_gen(struct sock *sk, const void *path,
-				      struct tcp_fastopen_cookie *foc)
+static bool __tcp_fastopen_cookie_gen_cipher(struct request_sock *req,
+					     struct sk_buff *syn,
+					     struct crypto_cipher *tfm,
+					     struct tcp_fastopen_cookie *foc)
 {
-	struct tcp_fastopen_context *ctx;
-	bool ok = false;
-
-	rcu_read_lock();
+	if (req->rsk_ops->family == AF_INET) {
+		const struct iphdr *iph = ip_hdr(syn);
+		__be32 path[4] = { iph->saddr, iph->daddr, 0, 0 };
 
-	ctx = rcu_dereference(inet_csk(sk)->icsk_accept_queue.fastopenq.ctx);
-	if (!ctx)
-		ctx = rcu_dereference(sock_net(sk)->ipv4.tcp_fastopen_ctx);
+		crypto_cipher_encrypt_one(tfm, foc->val, (void *)path);
+		foc->len = TCP_FASTOPEN_COOKIE_SIZE;
+		return true;
+	}
 
-	if (ctx) {
-		crypto_cipher_encrypt_one(ctx->tfm, foc->val, path);
+#if IS_ENABLED(CONFIG_IPV6)
+	if (req->rsk_ops->family == AF_INET6) {
+		const struct ipv6hdr *ip6h = ipv6_hdr(syn);
+		struct tcp_fastopen_cookie tmp;
+		struct in6_addr *buf;
+		int i;
+
+		crypto_cipher_encrypt_one(tfm, tmp.val,
+					  (void *)&ip6h->saddr);
+		buf = &tmp.addr;
+		for (i = 0; i < 4; i++)
+			buf->s6_addr32[i] ^= ip6h->daddr.s6_addr32[i];
+		crypto_cipher_encrypt_one(tfm, foc->val, (void *)buf);
 		foc->len = TCP_FASTOPEN_COOKIE_SIZE;
-		ok = true;
+		return true;
 	}
-	rcu_read_unlock();
-	return ok;
+#endif
+	return false;
 }
 
 /* Generate the fastopen cookie by doing aes128 encryption on both
@@ -143,29 +156,17 @@ static bool tcp_fastopen_cookie_gen(struct sock *sk,
 				    struct sk_buff *syn,
 				    struct tcp_fastopen_cookie *foc)
 {
-	if (req->rsk_ops->family == AF_INET) {
-		const struct iphdr *iph = ip_hdr(syn);
-
-		__be32 path[4] = { iph->saddr, iph->daddr, 0, 0 };
-		return __tcp_fastopen_cookie_gen(sk, path, foc);
-	}
-
-#if IS_ENABLED(CONFIG_IPV6)
-	if (req->rsk_ops->family == AF_INET6) {
-		const struct ipv6hdr *ip6h = ipv6_hdr(syn);
-		struct tcp_fastopen_cookie tmp;
-
-		if (__tcp_fastopen_cookie_gen(sk, &ip6h->saddr, &tmp)) {
-			struct in6_addr *buf = &tmp.addr;
-			int i;
+	struct tcp_fastopen_context *ctx;
+	bool ok = false;
 
-			for (i = 0; i < 4; i++)
-				buf->s6_addr32[i] ^= ip6h->daddr.s6_addr32[i];
-			return __tcp_fastopen_cookie_gen(sk, buf, foc);
-		}
-	}
-#endif
-	return false;
+	rcu_read_lock();
+	ctx = rcu_dereference(inet_csk(sk)->icsk_accept_queue.fastopenq.ctx);
+	if (!ctx)
+		ctx = rcu_dereference(sock_net(sk)->ipv4.tcp_fastopen_ctx);
+	if (ctx)
+		ok = __tcp_fastopen_cookie_gen_cipher(req, syn, ctx->tfm, foc);
+	rcu_read_unlock();
+	return ok;
 }
 
 
-- 
2.7.4

