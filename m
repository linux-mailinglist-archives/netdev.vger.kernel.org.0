Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F85FA34EF
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 12:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbfH3K0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 06:26:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45264 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbfH3K0D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 06:26:03 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7DA377F76F;
        Fri, 30 Aug 2019 10:26:02 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C680D19C58;
        Fri, 30 Aug 2019 10:26:00 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     borisp@mellanox.com, jakub.kicinski@netronome.com,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     aviadye@mellanox.com, davejwatson@fb.com, davem@davemloft.net,
        john.fastabend@gmail.com,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev@vger.kernel.org
Subject: [PATCH net-next v3 3/3] net: tls: export protocol version, cipher, tx_conf/rx_conf to socket diag
Date:   Fri, 30 Aug 2019 12:25:49 +0200
Message-Id: <39ad297f2b1f129b26c4a3461a1ae443d836da52.1567158431.git.dcaratti@redhat.com>
In-Reply-To: <cover.1567158431.git.dcaratti@redhat.com>
References: <cover.1567158431.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Fri, 30 Aug 2019 10:26:02 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an application configures kernel TLS on top of a TCP socket, it's
now possible for inet_diag_handler() to collect information regarding the
protocol version, the cipher type and TX / RX configuration, in case
INET_DIAG_INFO is requested.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 include/net/tls.h              | 17 +++++++++
 include/uapi/linux/inet_diag.h |  1 +
 include/uapi/linux/tls.h       | 15 ++++++++
 net/tls/tls_main.c             | 64 ++++++++++++++++++++++++++++++++++
 4 files changed, 97 insertions(+)

diff --git a/include/net/tls.h b/include/net/tls.h
index 4997742475cd..ec3c3ed2c6c3 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -431,6 +431,23 @@ static inline bool is_tx_ready(struct tls_sw_context_tx *ctx)
 	return READ_ONCE(rec->tx_ready);
 }
 
+static inline u16 tls_user_config(struct tls_context *ctx, bool tx)
+{
+	u16 config = tx ? ctx->tx_conf : ctx->rx_conf;
+
+	switch (config) {
+	case TLS_BASE:
+		return TLS_CONF_BASE;
+	case TLS_SW:
+		return TLS_CONF_SW;
+	case TLS_HW:
+		return TLS_CONF_HW;
+	case TLS_HW_RECORD:
+		return TLS_CONF_HW_RECORD;
+	}
+	return 0;
+}
+
 struct sk_buff *
 tls_validate_xmit_skb(struct sock *sk, struct net_device *dev,
 		      struct sk_buff *skb);
diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_diag.h
index e2c6273274f3..a1ff345b3f33 100644
--- a/include/uapi/linux/inet_diag.h
+++ b/include/uapi/linux/inet_diag.h
@@ -162,6 +162,7 @@ enum {
 enum {
 	INET_ULP_INFO_UNSPEC,
 	INET_ULP_INFO_NAME,
+	INET_ULP_INFO_TLS,
 	__INET_ULP_INFO_MAX,
 };
 #define INET_ULP_INFO_MAX (__INET_ULP_INFO_MAX - 1)
diff --git a/include/uapi/linux/tls.h b/include/uapi/linux/tls.h
index 5b9c26753e46..bcd2869ed472 100644
--- a/include/uapi/linux/tls.h
+++ b/include/uapi/linux/tls.h
@@ -109,4 +109,19 @@ struct tls12_crypto_info_aes_ccm_128 {
 	unsigned char rec_seq[TLS_CIPHER_AES_CCM_128_REC_SEQ_SIZE];
 };
 
+enum {
+	TLS_INFO_UNSPEC,
+	TLS_INFO_VERSION,
+	TLS_INFO_CIPHER,
+	TLS_INFO_TXCONF,
+	TLS_INFO_RXCONF,
+	__TLS_INFO_MAX,
+};
+#define TLS_INFO_MAX (__TLS_INFO_MAX - 1)
+
+#define TLS_CONF_BASE 1
+#define TLS_CONF_SW 2
+#define TLS_CONF_HW 3
+#define TLS_CONF_HW_RECORD 4
+
 #endif /* _UAPI_LINUX_TLS_H */
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index f8f2d2c3d627..277f7c209fed 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -39,6 +39,7 @@
 #include <linux/netdevice.h>
 #include <linux/sched/signal.h>
 #include <linux/inetdevice.h>
+#include <linux/inet_diag.h>
 
 #include <net/tls.h>
 
@@ -835,6 +836,67 @@ static void tls_update(struct sock *sk, struct proto *p)
 	}
 }
 
+static int tls_get_info(const struct sock *sk, struct sk_buff *skb)
+{
+	u16 version, cipher_type;
+	struct tls_context *ctx;
+	struct nlattr *start;
+	int err;
+
+	start = nla_nest_start_noflag(skb, INET_ULP_INFO_TLS);
+	if (!start)
+		return -EMSGSIZE;
+
+	rcu_read_lock();
+	ctx = rcu_dereference(inet_csk(sk)->icsk_ulp_data);
+	if (!ctx) {
+		err = 0;
+		goto nla_failure;
+	}
+	version = ctx->prot_info.version;
+	if (version) {
+		err = nla_put_u16(skb, TLS_INFO_VERSION, version);
+		if (err)
+			goto nla_failure;
+	}
+	cipher_type = ctx->prot_info.cipher_type;
+	if (cipher_type) {
+		err = nla_put_u16(skb, TLS_INFO_CIPHER, cipher_type);
+		if (err)
+			goto nla_failure;
+	}
+	err = nla_put_u16(skb, TLS_INFO_TXCONF, tls_user_config(ctx, true));
+	if (err)
+		goto nla_failure;
+
+	err = nla_put_u16(skb, TLS_INFO_RXCONF, tls_user_config(ctx, false));
+	if (err)
+		goto nla_failure;
+
+	rcu_read_unlock();
+	nla_nest_end(skb, start);
+	return 0;
+
+nla_failure:
+	rcu_read_unlock();
+	nla_nest_cancel(skb, start);
+	return err;
+}
+
+static size_t tls_get_info_size(const struct sock *sk)
+{
+	size_t size = 0;
+
+	size += nla_total_size(0) +		/* INET_ULP_INFO_TLS */
+		nla_total_size(sizeof(u16)) +	/* TLS_INFO_VERSION */
+		nla_total_size(sizeof(u16)) +	/* TLS_INFO_CIPHER */
+		nla_total_size(sizeof(u16)) +	/* TLS_INFO_RXCONF */
+		nla_total_size(sizeof(u16)) +	/* TLS_INFO_TXCONF */
+		0;
+
+	return size;
+}
+
 void tls_register_device(struct tls_device *device)
 {
 	spin_lock_bh(&device_spinlock);
@@ -856,6 +918,8 @@ static struct tcp_ulp_ops tcp_tls_ulp_ops __read_mostly = {
 	.owner			= THIS_MODULE,
 	.init			= tls_init,
 	.update			= tls_update,
+	.get_info		= tls_get_info,
+	.get_info_size		= tls_get_info_size,
 };
 
 static int __init tls_register(void)
-- 
2.20.1

