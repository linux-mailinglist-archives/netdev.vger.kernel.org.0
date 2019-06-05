Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC033606D
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 17:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbfFEPkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 11:40:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41470 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728200AbfFEPkC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 11:40:02 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0200A300C230;
        Wed,  5 Jun 2019 15:40:02 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A51717D53;
        Wed,  5 Jun 2019 15:40:00 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Dave Watson <davejwatson@fb.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
Subject: [RFC PATCH net-next 2/2] net: tls: export protocol version and cipher to socket diag
Date:   Wed,  5 Jun 2019 17:39:23 +0200
Message-Id: <4262dd2617a24b66f24ec5ddc73f817e683e14e0.1559747691.git.dcaratti@redhat.com>
In-Reply-To: <cover.1559747691.git.dcaratti@redhat.com>
References: <cover.1559747691.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Wed, 05 Jun 2019 15:40:02 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an application configures kernel TLS on top of a TCP socket, it's
now possible for inet_diag_handler to collect information regarding the
protocol version and the cipher, in case INET_DIAG_INFO is requested.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 include/uapi/linux/inet_diag.h |  1 +
 include/uapi/linux/tls.h       |  8 +++++++
 net/tls/tls_main.c             | 43 ++++++++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+)

diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_diag.h
index 844133de3212..92208535c096 100644
--- a/include/uapi/linux/inet_diag.h
+++ b/include/uapi/linux/inet_diag.h
@@ -161,6 +161,7 @@ enum {
 
 enum {
 	ULP_INFO_NAME,
+	ULP_INFO_TLS,
 	__ULP_INFO_MAX,
 };
 
diff --git a/include/uapi/linux/tls.h b/include/uapi/linux/tls.h
index 5b9c26753e46..442348bd2e54 100644
--- a/include/uapi/linux/tls.h
+++ b/include/uapi/linux/tls.h
@@ -109,4 +109,12 @@ struct tls12_crypto_info_aes_ccm_128 {
 	unsigned char rec_seq[TLS_CIPHER_AES_CCM_128_REC_SEQ_SIZE];
 };
 
+enum {
+	TLS_INFO_VERSION,
+	TLS_INFO_CIPHER,
+	__TLS_INFO_MAX,
+};
+
+#define TLS_INFO_MAX (__TLS_INFO_MAX - 1)
+
 #endif /* _UAPI_LINUX_TLS_H */
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index fc81ae18cc44..14597526981c 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -39,6 +39,7 @@
 #include <linux/netdevice.h>
 #include <linux/sched/signal.h>
 #include <linux/inetdevice.h>
+#include <linux/inet_diag.h>
 
 #include <net/tls.h>
 
@@ -798,6 +799,46 @@ static int tls_init(struct sock *sk)
 	return rc;
 }
 
+static int tls_get_info(struct sock *sk, struct sk_buff *skb)
+{
+	struct tls_context *ctx = tls_get_ctx(sk);
+	struct nlattr *start = 0;
+	int err = 0;
+
+	if (sk->sk_state != TCP_ESTABLISHED)
+		goto end;
+	start = nla_nest_start_noflag(skb, ULP_INFO_TLS);
+	if (!start) {
+		err = -EMSGSIZE;
+		goto nla_failure;
+	}
+	err = nla_put_u16(skb, TLS_INFO_VERSION, ctx->prot_info.version);
+	if (err < 0)
+		goto nla_failure;
+	err = nla_put_u16(skb, TLS_INFO_CIPHER, ctx->prot_info.cipher_type);
+	if (err < 0)
+		goto nla_failure;
+	nla_nest_end(skb, start);
+end:
+	return err;
+nla_failure:
+	nla_nest_cancel(skb, start);
+	goto end;
+}
+
+static size_t tls_get_info_size(struct sock *sk)
+{
+	size_t size = 0;
+
+	if (sk->sk_state != TCP_ESTABLISHED)
+		return size;
+
+	size +=   nla_total_size(0) /* ULP_INFO_TLS */
+		+ nla_total_size(sizeof(__u16))	/* TLS_INFO_VERSION */
+		+ nla_total_size(sizeof(__u16)); /* TLS_INFO_CIPHER */
+	return size;
+}
+
 void tls_register_device(struct tls_device *device)
 {
 	spin_lock_bh(&device_spinlock);
@@ -818,6 +859,8 @@ static struct tcp_ulp_ops tcp_tls_ulp_ops __read_mostly = {
 	.name			= "tls",
 	.owner			= THIS_MODULE,
 	.init			= tls_init,
+	.get_info		= tls_get_info,
+	.get_info_size		= tls_get_info_size,
 };
 
 static int __init tls_register(void)
-- 
2.20.1

