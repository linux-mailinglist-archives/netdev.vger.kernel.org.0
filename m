Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72F6E2E257
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 18:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbfE2Qfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 12:35:34 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:51162 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726694AbfE2Qfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 12:35:32 -0400
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4TGW6g9031091;
        Wed, 29 May 2019 17:35:25 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : in-reply-to :
 references; s=jan2016.eng;
 bh=3FKtjRPPqPCLSvAuDII56+Z4IHQuH+1aomNKbq7EQsk=;
 b=ETv9ZEp0LYrYC6PFbTWFC88+4QR/4zaEzdFscLp15A/VC28AF+3KDkJqIP+kog5frL17
 Us/rGSnahfvFBvzwI/6NBU73fevRfUlSZZ55AIpE5vo0+zyg9/ILEpcctAWtWa9DUFRi
 OKkFCQaMl2P+/UJIkcaKad+b+xbdBzmAfT9anYAPNE8i2xIQWS79cxYn1F4f7SlFx73V
 ZsRkD1YP+c5bpwNW0G3bzXt0c5YgtDEb6DZHt/fk5qf1kC4/qDS9qK93sbfSrQIXEeCu
 eraNA/evfInC+nUH85CyU96y9dwSlA/L+kHq6EfEDxTPhjtqAaaSPMKflb5+kgV7pLiZ bQ== 
Received: from prod-mail-ppoint3 (prod-mail-ppoint3.akamai.com [96.6.114.86] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 2ssvj00ada-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 May 2019 17:35:25 +0100
Received: from pps.filterd (prod-mail-ppoint3.akamai.com [127.0.0.1])
        by prod-mail-ppoint3.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x4TGVxUB028623;
        Wed, 29 May 2019 12:35:24 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint3.akamai.com with ESMTP id 2sq11ys52u-1;
        Wed, 29 May 2019 12:35:18 -0400
Received: from bos-lpjec.kendall.corp.akamai.com (bos-lpjec.kendall.corp.akamai.com [172.29.170.83])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id 142621FC6B;
        Wed, 29 May 2019 16:35:15 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     davem@davemloft.net, edumazet@google.com, ycheng@google.com
Cc:     cpaasch@apple.com, ilubashe@akamai.com, netdev@vger.kernel.org
Subject: [PATCH net-next v2 1/6] tcp: introduce __tcp_fastopen_cookie_gen_cipher()
Date:   Wed, 29 May 2019 12:33:56 -0400
Message-Id: <4242cff4591fb707104eb88caea22c2d916b423d.1559146812.git.jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1559146812.git.jbaron@akamai.com>
References: <cover.1559146812.git.jbaron@akamai.com>
In-Reply-To: <cover.1559146812.git.jbaron@akamai.com>
References: <cover.1559146812.git.jbaron@akamai.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-29_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905290108
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-29_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905290108
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Paasch <cpaasch@apple.com>

Restructure __tcp_fastopen_cookie_gen() to take a 'struct crypto_cipher'
argument and rename it as __tcp_fastopen_cookie_gen_cipher(). Subsequent
patches will provide different ciphers based on which key is being used for
the cookie generation.

Signed-off-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Jason Baron <jbaron@akamai.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
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

