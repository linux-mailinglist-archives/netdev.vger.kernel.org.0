Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDC5597772
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 22:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241531AbiHQUKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 16:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238004AbiHQUJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 16:09:56 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0B8A61DF;
        Wed, 17 Aug 2022 13:09:51 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id x63-20020a17090a6c4500b001fabbf8debfso2071625pjj.4;
        Wed, 17 Aug 2022 13:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=9SZOaLCkmHABJIK671+rjjHeQCigI0RhOJxzHs7v3AU=;
        b=o9va5aQumnE9gPYJz270KBrnMweicmu1McKhwFGCS+9vDU2J/y6IQyW/7w0Z/Myih6
         /CeyPGfkND3ZOX09m/+ElvkB4wGaR9a+PHPWGjpOXsJF4wmBYkgonGCKF6k93dvlf4Rb
         C9bnxFiXvIX+v7ufZqg87+BV4Rvb6slGcCLzoQ2ygMz0gA2FitBscD19at+kC+eRA+p+
         mtFiZTyoH/qktPTG1UwXaoKbv5oN0EAYHMJ/KERfiH523G6Ri8etCkT9Rrqzy5K7XTLU
         EBtXPNrARccszBM94DwUWXDTKTNITJ/nZ4lct4nkygE8jKq65fTQsyw1E+3X5dKV5fTv
         i1bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=9SZOaLCkmHABJIK671+rjjHeQCigI0RhOJxzHs7v3AU=;
        b=7CxpR88yBiuC3XEFir0qwJiOH7sM4W8Fb9JpUyMN+KytO8gJ5i4R0xaWDUT64tpHAF
         tXvHzUQP2cu2Uxs8pXCBOHWlPTwmsZzMbpbYDvb1UE8Qda4NZCGrYyZ2/ptmGLPWvQA+
         1poF+AxCgXztwBdn7sBtenZP+IvqXZT6VwFchyvz/z5UzDavH7+v24a/XcMO7xB1uuUp
         1+rjAJCD9VuDOCT4MSFiRFd/otzerB3jrgApZ34k64Npc4y4f1N8Qaf2alO6KrSZjb3D
         kHX36D2rXBcwVkUhXvV9Y+momJPW4KR/6IqJEcFYrD7KVB9NHSP8HdAuaf/N6Ga6zWAW
         UKGw==
X-Gm-Message-State: ACgBeo2YQ1X66p2GLEXOP3EPTM8FGk0keaLIlTSMgda5nqOCHWk22DsT
        eilLpxmOILr8JYYb27qUIpI=
X-Google-Smtp-Source: AA6agR45t+F2LPeYGqx6kofdVmidbYdEKFk5zljuWbtsWY4B8xc9uXdLcFdb+mDH0Rxs4+p94cBi4Q==
X-Received: by 2002:a17:902:ca0b:b0:172:9916:695c with SMTP id w11-20020a170902ca0b00b001729916695cmr4728216pld.5.1660766990541;
        Wed, 17 Aug 2022 13:09:50 -0700 (PDT)
Received: from localhost (fwdproxy-prn-007.fbsv.net. [2a03:2880:ff:7::face:b00c])
        by smtp.gmail.com with ESMTPSA id y16-20020aa793d0000000b0052aaf7fe731sm10888264pff.45.2022.08.17.13.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 13:09:50 -0700 (PDT)
From:   Adel Abouchaev <adel.abushaev@gmail.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, dsahern@kernel.org, shuah@kernel.org,
        imagedong@tencent.com, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [net-next v2 4/6] Implement QUIC offload functions
Date:   Wed, 17 Aug 2022 13:09:38 -0700
Message-Id: <20220817200940.1656747-5-adel.abushaev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220817200940.1656747-1-adel.abushaev@gmail.com>
References: <Adel Abouchaev <adel.abushaev@gmail.com>
 <20220817200940.1656747-1-adel.abushaev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add connection hash to the context do support add, remove operations
on QUIC connections for the control plane and lookup for the data
plane. Implement setsockopt and add placeholders to add and delete Tx
connections.

Signed-off-by: Adel Abouchaev <adel.abushaev@gmail.com>

---

Added net/quic/Kconfig reference to net/Kconfig in this commit.

Initialized pointers with NULL vs 0. Restricted AES counter to __le32
Added address space qualifiers to user space addresses. Removed empty
lines. Updated code alignment. Removed inlines.

v3: removed ITER_KVEC flag from iov_iter_kvec call.
v3: fixed Chacha20 encryption bug.
---
 include/net/quic.h   |   53 ++
 net/Kconfig          |    1 +
 net/ipv4/udp.c       |    9 +
 net/quic/Kconfig     |   16 +
 net/quic/Makefile    |    8 +
 net/quic/quic_main.c | 1371 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 1458 insertions(+)
 create mode 100644 include/net/quic.h
 create mode 100644 net/quic/Kconfig
 create mode 100644 net/quic/Makefile
 create mode 100644 net/quic/quic_main.c

diff --git a/include/net/quic.h b/include/net/quic.h
new file mode 100644
index 000000000000..cafe01174e60
--- /dev/null
+++ b/include/net/quic.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef INCLUDE_NET_QUIC_H
+#define INCLUDE_NET_QUIC_H
+
+#include <linux/mutex.h>
+#include <linux/rhashtable.h>
+#include <linux/skmsg.h>
+#include <uapi/linux/quic.h>
+
+#define QUIC_MAX_SHORT_HEADER_SIZE      25
+#define QUIC_MAX_CONNECTION_ID_SIZE     20
+#define QUIC_HDR_MASK_SIZE              16
+#define QUIC_MAX_GSO_FRAGS              16
+
+// Maximum IV and nonce sizes should be in sync with supported ciphers.
+#define QUIC_CIPHER_MAX_IV_SIZE		12
+#define QUIC_CIPHER_MAX_NONCE_SIZE	16
+
+/* Side by side data for QUIC egress operations */
+#define QUIC_ANCILLARY_FLAGS    (QUIC_BYPASS_ENCRYPTION)
+
+#define QUIC_MAX_IOVEC_SEGMENTS		8
+#define QUIC_MAX_SG_ALLOC_ELEMENTS	32
+#define QUIC_MAX_PLAIN_PAGES		16
+#define QUIC_MAX_CIPHER_PAGES_ORDER	4
+
+struct quic_internal_crypto_context {
+	struct quic_connection_info	conn_info;
+	struct crypto_skcipher		*header_tfm;
+	struct crypto_aead		*packet_aead;
+};
+
+struct quic_connection_rhash {
+	struct rhash_head			node;
+	struct quic_internal_crypto_context	crypto_ctx;
+	struct rcu_head				rcu;
+};
+
+struct quic_context {
+	struct proto		*sk_proto;
+	struct rhashtable	tx_connections;
+	struct scatterlist	sg_alloc[QUIC_MAX_SG_ALLOC_ELEMENTS];
+	struct page		*cipher_page;
+	/**
+	 * To synchronize concurrent sendmsg() requests through the same socket
+	 * and protect preallocated per-context memory.
+	 **/
+	struct mutex		sendmsg_mux;
+	struct rcu_head		rcu;
+};
+
+#endif
diff --git a/net/Kconfig b/net/Kconfig
index 6b78f695caa6..93e3b1308aec 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -63,6 +63,7 @@ menu "Networking options"
 source "net/packet/Kconfig"
 source "net/unix/Kconfig"
 source "net/tls/Kconfig"
+source "net/quic/Kconfig"
 source "net/xfrm/Kconfig"
 source "net/iucv/Kconfig"
 source "net/smc/Kconfig"
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 027c4513a9cd..e7cbbea9d8d9 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -113,6 +113,7 @@
 #include <net/sock_reuseport.h>
 #include <net/addrconf.h>
 #include <net/udp_tunnel.h>
+#include <uapi/linux/quic.h>
 #if IS_ENABLED(CONFIG_IPV6)
 #include <net/ipv6_stubs.h>
 #endif
@@ -1011,6 +1012,14 @@ static int __udp_cmsg_send(struct cmsghdr *cmsg, u16 *gso_size)
 			return -EINVAL;
 		*gso_size = *(__u16 *)CMSG_DATA(cmsg);
 		return 0;
+	case UDP_QUIC_ENCRYPT:
+		/* This option is handled in UDP_ULP and is only checked
+		 * here for the bypass bit
+		 */
+		if (cmsg->cmsg_len !=
+		    CMSG_LEN(sizeof(struct quic_tx_ancillary_data)))
+			return -EINVAL;
+		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/net/quic/Kconfig b/net/quic/Kconfig
new file mode 100644
index 000000000000..661cb989508a
--- /dev/null
+++ b/net/quic/Kconfig
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# QUIC configuration
+#
+config QUIC
+	tristate "QUIC encryption offload"
+	depends on INET
+	select CRYPTO
+	select CRYPTO_AES
+	select CRYPTO_GCM
+	help
+	Enable kernel support for QUIC crypto offload. Currently only TX
+	encryption offload is supported. The kernel will perform
+	copy-during-encryption.
+
+	If unsure, say N.
diff --git a/net/quic/Makefile b/net/quic/Makefile
new file mode 100644
index 000000000000..928239c4d08c
--- /dev/null
+++ b/net/quic/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Makefile for the QUIC subsystem
+#
+
+obj-$(CONFIG_QUIC) += quic.o
+
+quic-y := quic_main.o
diff --git a/net/quic/quic_main.c b/net/quic/quic_main.c
new file mode 100644
index 000000000000..95de3a961479
--- /dev/null
+++ b/net/quic/quic_main.c
@@ -0,0 +1,1371 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <crypto/skcipher.h>
+#include <linux/bug.h>
+#include <linux/module.h>
+#include <linux/rhashtable.h>
+// Include header to use TLS constants for AEAD cipher.
+#include <net/tls.h>
+#include <net/quic.h>
+#include <net/udp.h>
+#include <uapi/linux/quic.h>
+
+static unsigned long af_init_done;
+static struct proto quic_v4_proto;
+static struct proto quic_v6_proto;
+static DEFINE_SPINLOCK(quic_proto_lock);
+
+static u32 quic_tx_connection_hash(const void *data, u32 len, u32 seed)
+{
+	return jhash(data, len, seed);
+}
+
+static u32 quic_tx_connection_hash_obj(const void *data, u32 len, u32 seed)
+{
+	const struct quic_connection_rhash *connhash = data;
+
+	return jhash(&connhash->crypto_ctx.conn_info.key,
+		     sizeof(struct quic_connection_info_key), seed);
+}
+
+static int quic_tx_connection_hash_cmp(struct rhashtable_compare_arg *arg,
+				       const void *ptr)
+{
+	const struct quic_connection_info_key *key = arg->key;
+	const struct quic_connection_rhash *x = ptr;
+
+	return !!memcmp(&x->crypto_ctx.conn_info.key,
+			key,
+			sizeof(struct quic_connection_info_key));
+}
+
+static const struct rhashtable_params quic_tx_connection_params = {
+	.key_len		= sizeof(struct quic_connection_info_key),
+	.head_offset		= offsetof(struct quic_connection_rhash, node),
+	.hashfn			= quic_tx_connection_hash,
+	.obj_hashfn		= quic_tx_connection_hash_obj,
+	.obj_cmpfn		= quic_tx_connection_hash_cmp,
+	.automatic_shrinking	= true,
+};
+
+static size_t quic_crypto_key_size(u16 cipher_type)
+{
+	switch (cipher_type) {
+	case TLS_CIPHER_AES_GCM_128:
+		return TLS_CIPHER_AES_GCM_128_KEY_SIZE;
+	case TLS_CIPHER_AES_GCM_256:
+		return TLS_CIPHER_AES_GCM_256_KEY_SIZE;
+	case TLS_CIPHER_AES_CCM_128:
+		return TLS_CIPHER_AES_CCM_128_KEY_SIZE;
+	case TLS_CIPHER_CHACHA20_POLY1305:
+		return TLS_CIPHER_CHACHA20_POLY1305_KEY_SIZE;
+	default:
+		break;
+	}
+	WARN_ON("Unsupported cipher type");
+	return 0;
+}
+
+static size_t quic_crypto_tag_size(u16 cipher_type)
+{
+	switch (cipher_type) {
+	case TLS_CIPHER_AES_GCM_128:
+		return TLS_CIPHER_AES_GCM_128_TAG_SIZE;
+	case TLS_CIPHER_AES_GCM_256:
+		return TLS_CIPHER_AES_GCM_256_TAG_SIZE;
+	case TLS_CIPHER_AES_CCM_128:
+		return TLS_CIPHER_AES_CCM_128_TAG_SIZE;
+	case TLS_CIPHER_CHACHA20_POLY1305:
+		return TLS_CIPHER_CHACHA20_POLY1305_TAG_SIZE;
+	default:
+		break;
+	}
+	WARN_ON("Unsupported cipher type");
+	return 0;
+}
+
+static size_t quic_crypto_nonce_size(u16 cipher_type)
+{
+	switch (cipher_type) {
+	case TLS_CIPHER_AES_GCM_128:
+		BUILD_BUG_ON(TLS_CIPHER_AES_GCM_128_IV_SIZE +
+			     TLS_CIPHER_AES_GCM_128_SALT_SIZE >
+			     QUIC_CIPHER_MAX_NONCE_SIZE);
+		return TLS_CIPHER_AES_GCM_128_IV_SIZE +
+		       TLS_CIPHER_AES_GCM_128_SALT_SIZE;
+	case TLS_CIPHER_AES_GCM_256:
+		BUILD_BUG_ON(TLS_CIPHER_AES_GCM_256_IV_SIZE +
+			     TLS_CIPHER_AES_GCM_256_SALT_SIZE >
+			     QUIC_CIPHER_MAX_NONCE_SIZE);
+		return TLS_CIPHER_AES_GCM_256_IV_SIZE +
+		       TLS_CIPHER_AES_GCM_256_SALT_SIZE;
+	case TLS_CIPHER_AES_CCM_128:
+		BUILD_BUG_ON(TLS_CIPHER_AES_CCM_128_IV_SIZE +
+			     TLS_CIPHER_AES_CCM_128_SALT_SIZE >
+			     QUIC_CIPHER_MAX_NONCE_SIZE);
+		return TLS_CIPHER_AES_CCM_128_IV_SIZE +
+		       TLS_CIPHER_AES_CCM_128_SALT_SIZE;
+	case TLS_CIPHER_CHACHA20_POLY1305:
+		BUILD_BUG_ON(TLS_CIPHER_CHACHA20_POLY1305_IV_SIZE +
+			     TLS_CIPHER_CHACHA20_POLY1305_SALT_SIZE >
+			     QUIC_CIPHER_MAX_NONCE_SIZE);
+		return TLS_CIPHER_CHACHA20_POLY1305_IV_SIZE +
+		       TLS_CIPHER_CHACHA20_POLY1305_SALT_SIZE;
+	default:
+		break;
+	}
+	WARN_ON("Unsupported cipher type");
+	return 0;
+}
+
+static u8 *quic_payload_iv(struct quic_internal_crypto_context *crypto_ctx)
+{
+	switch (crypto_ctx->conn_info.cipher_type) {
+	case TLS_CIPHER_AES_GCM_128:
+		return crypto_ctx->conn_info.aes_gcm_128.payload_iv;
+	case TLS_CIPHER_AES_GCM_256:
+		return crypto_ctx->conn_info.aes_gcm_256.payload_iv;
+	case TLS_CIPHER_AES_CCM_128:
+		return crypto_ctx->conn_info.aes_ccm_128.payload_iv;
+	case TLS_CIPHER_CHACHA20_POLY1305:
+		return crypto_ctx->conn_info.chacha20_poly1305.payload_iv;
+	default:
+		break;
+	}
+	WARN_ON("Unsupported cipher type");
+	return NULL;
+}
+
+static int
+quic_config_header_crypto(struct quic_internal_crypto_context *crypto_ctx)
+{
+	struct crypto_skcipher *tfm;
+	char *header_cipher;
+	int rc = 0;
+	char *key;
+
+	switch (crypto_ctx->conn_info.cipher_type) {
+	case TLS_CIPHER_AES_GCM_128:
+		header_cipher = "ecb(aes)";
+		key = crypto_ctx->conn_info.aes_gcm_128.header_key;
+		break;
+	case TLS_CIPHER_AES_GCM_256:
+		header_cipher = "ecb(aes)";
+		key = crypto_ctx->conn_info.aes_gcm_256.header_key;
+		break;
+	case TLS_CIPHER_AES_CCM_128:
+		header_cipher = "ecb(aes)";
+		key = crypto_ctx->conn_info.aes_ccm_128.header_key;
+		break;
+	case TLS_CIPHER_CHACHA20_POLY1305:
+		header_cipher = "chacha20";
+		key = crypto_ctx->conn_info.chacha20_poly1305.header_key;
+		break;
+	default:
+		rc = -EINVAL;
+		goto out;
+	}
+
+	tfm = crypto_alloc_skcipher(header_cipher, 0, 0);
+	if (IS_ERR(tfm)) {
+		rc = PTR_ERR(tfm);
+		goto out;
+	}
+
+	rc = crypto_skcipher_setkey(tfm, key,
+				    quic_crypto_key_size(crypto_ctx->conn_info
+							 .cipher_type));
+	if (rc) {
+		crypto_free_skcipher(tfm);
+		goto out;
+	}
+
+	crypto_ctx->header_tfm = tfm;
+
+out:
+	return rc;
+}
+
+static int
+quic_config_packet_crypto(struct quic_internal_crypto_context *crypto_ctx)
+{
+	struct crypto_aead *aead;
+	char *cipher_name;
+	int rc = 0;
+	char *key;
+
+	switch (crypto_ctx->conn_info.cipher_type) {
+	case TLS_CIPHER_AES_GCM_128: {
+		key = crypto_ctx->conn_info.aes_gcm_128.payload_key;
+		cipher_name = "gcm(aes)";
+		break;
+	}
+	case TLS_CIPHER_AES_GCM_256: {
+		key = crypto_ctx->conn_info.aes_gcm_256.payload_key;
+		cipher_name = "gcm(aes)";
+		break;
+	}
+	case TLS_CIPHER_AES_CCM_128: {
+		key = crypto_ctx->conn_info.aes_ccm_128.payload_key;
+		cipher_name = "ccm(aes)";
+		break;
+	}
+	case TLS_CIPHER_CHACHA20_POLY1305: {
+		key = crypto_ctx->conn_info.chacha20_poly1305.payload_key;
+		cipher_name = "rfc7539(chacha20,poly1305)";
+		break;
+	}
+	default:
+		rc = -EINVAL;
+		goto out;
+	}
+
+	aead = crypto_alloc_aead(cipher_name, 0, 0);
+	if (IS_ERR(aead)) {
+		rc = PTR_ERR(aead);
+		goto out;
+	}
+
+	rc = crypto_aead_setkey(aead, key,
+				quic_crypto_key_size(crypto_ctx->conn_info
+						     .cipher_type));
+	if (rc)
+		goto free_aead;
+
+	rc = crypto_aead_setauthsize(aead,
+				     quic_crypto_tag_size(crypto_ctx->conn_info
+							  .cipher_type));
+	if (rc)
+		goto free_aead;
+
+	crypto_ctx->packet_aead = aead;
+	goto out;
+
+free_aead:
+	crypto_free_aead(aead);
+
+out:
+	return rc;
+}
+
+static inline struct quic_context *quic_get_ctx(struct sock *sk)
+{
+	struct inet_sock *inet = inet_sk(sk);
+
+	return (__force void *)rcu_access_pointer(inet->ulp_data);
+}
+
+static void quic_free_cipher_page(struct page *page)
+{
+	__free_pages(page, QUIC_MAX_CIPHER_PAGES_ORDER);
+}
+
+static struct quic_context *quic_ctx_create(void)
+{
+	struct quic_context *ctx;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return NULL;
+
+	mutex_init(&ctx->sendmsg_mux);
+	ctx->cipher_page = alloc_pages(GFP_KERNEL, QUIC_MAX_CIPHER_PAGES_ORDER);
+	if (!ctx->cipher_page)
+		goto out_err;
+
+	if (rhashtable_init(&ctx->tx_connections,
+			    &quic_tx_connection_params) < 0) {
+		quic_free_cipher_page(ctx->cipher_page);
+		goto out_err;
+	}
+
+	return ctx;
+
+out_err:
+	kfree(ctx);
+	return NULL;
+}
+
+static int quic_getsockopt(struct sock *sk, int level, int optname,
+			   char __user *optval, int __user *optlen)
+{
+	struct quic_context *ctx = quic_get_ctx(sk);
+
+	return ctx->sk_proto->getsockopt(sk, level, optname, optval, optlen);
+}
+
+static int do_quic_conn_add_tx(struct sock *sk, sockptr_t optval,
+			       unsigned int optlen)
+{
+	struct quic_internal_crypto_context *crypto_ctx;
+	struct quic_context *ctx = quic_get_ctx(sk);
+	struct quic_connection_rhash *connhash;
+	int rc = 0;
+
+	if (sockptr_is_null(optval))
+		return -EINVAL;
+
+	if (optlen != sizeof(struct quic_connection_info))
+		return -EINVAL;
+
+	connhash = kzalloc(sizeof(*connhash), GFP_KERNEL);
+	if (!connhash)
+		return -EFAULT;
+
+	crypto_ctx = &connhash->crypto_ctx;
+	rc = copy_from_sockptr(&crypto_ctx->conn_info, optval,
+			       sizeof(crypto_ctx->conn_info));
+	if (rc) {
+		rc = -EFAULT;
+		goto err_crypto_info;
+	}
+
+	// create all TLS materials for packet and header decryption
+	rc = quic_config_header_crypto(crypto_ctx);
+	if (rc)
+		goto err_crypto_info;
+
+	rc = quic_config_packet_crypto(crypto_ctx);
+	if (rc)
+		goto err_free_skcipher;
+
+	// insert crypto data into hash per connection ID
+	rc = rhashtable_insert_fast(&ctx->tx_connections, &connhash->node,
+				    quic_tx_connection_params);
+	if (rc < 0)
+		goto err_free_ciphers;
+
+	return 0;
+
+err_free_ciphers:
+	crypto_free_aead(crypto_ctx->packet_aead);
+
+err_free_skcipher:
+	crypto_free_skcipher(crypto_ctx->header_tfm);
+
+err_crypto_info:
+	// wipeout all crypto materials;
+	memzero_explicit(&connhash->crypto_ctx, sizeof(connhash->crypto_ctx));
+	kfree(connhash);
+	return rc;
+}
+
+static int do_quic_conn_del_tx(struct sock *sk, sockptr_t optval,
+			       unsigned int optlen)
+{
+	struct quic_internal_crypto_context *crypto_ctx;
+	struct quic_context *ctx = quic_get_ctx(sk);
+	struct quic_connection_rhash *connhash;
+	struct quic_connection_info conn_info;
+
+	if (sockptr_is_null(optval))
+		return -EINVAL;
+
+	if (optlen != sizeof(struct quic_connection_info))
+		return -EINVAL;
+
+	if (copy_from_sockptr(&conn_info, optval, optlen))
+		return -EFAULT;
+
+	connhash = rhashtable_lookup_fast(&ctx->tx_connections,
+					  &conn_info.key,
+					  quic_tx_connection_params);
+	if (!connhash)
+		return -EINVAL;
+
+	rhashtable_remove_fast(&ctx->tx_connections,
+			       &connhash->node,
+			       quic_tx_connection_params);
+
+	crypto_ctx = &connhash->crypto_ctx;
+
+	crypto_free_skcipher(crypto_ctx->header_tfm);
+	crypto_free_aead(crypto_ctx->packet_aead);
+	memzero_explicit(crypto_ctx, sizeof(*crypto_ctx));
+	kfree(connhash);
+
+	return 0;
+}
+
+static int do_quic_setsockopt(struct sock *sk, int optname, sockptr_t optval,
+			      unsigned int optlen)
+{
+	int rc = 0;
+
+	switch (optname) {
+	case UDP_QUIC_ADD_TX_CONNECTION:
+		lock_sock(sk);
+		rc = do_quic_conn_add_tx(sk, optval, optlen);
+		release_sock(sk);
+		break;
+	case UDP_QUIC_DEL_TX_CONNECTION:
+		lock_sock(sk);
+		rc = do_quic_conn_del_tx(sk, optval, optlen);
+		release_sock(sk);
+		break;
+	default:
+		rc = -ENOPROTOOPT;
+		break;
+	}
+
+	return rc;
+}
+
+static int quic_setsockopt(struct sock *sk, int level, int optname,
+			   sockptr_t optval, unsigned int optlen)
+{
+	struct quic_context *ctx;
+	struct proto *sk_proto;
+
+	rcu_read_lock();
+	ctx = quic_get_ctx(sk);
+	sk_proto = ctx->sk_proto;
+	rcu_read_unlock();
+
+	if (level == SOL_UDP &&
+	    (optname == UDP_QUIC_ADD_TX_CONNECTION ||
+	     optname == UDP_QUIC_DEL_TX_CONNECTION))
+		return do_quic_setsockopt(sk, optname, optval, optlen);
+
+	return sk_proto->setsockopt(sk, level, optname, optval, optlen);
+}
+
+static int
+quic_extract_ancillary_data(struct msghdr *msg,
+			    struct quic_tx_ancillary_data *ancillary_data,
+			    u16 *udp_pkt_size)
+{
+	struct cmsghdr *cmsg_hdr = NULL;
+	void *ancillary_data_ptr = NULL;
+
+	if (!msg->msg_controllen)
+		return -EINVAL;
+
+	for_each_cmsghdr(cmsg_hdr, msg) {
+		if (!CMSG_OK(msg, cmsg_hdr))
+			return -EINVAL;
+
+		if (cmsg_hdr->cmsg_level != IPPROTO_UDP)
+			continue;
+
+		if (cmsg_hdr->cmsg_type == UDP_QUIC_ENCRYPT) {
+			if (cmsg_hdr->cmsg_len !=
+			    CMSG_LEN(sizeof(struct quic_tx_ancillary_data)))
+				return -EINVAL;
+			memcpy((void *)ancillary_data, CMSG_DATA(cmsg_hdr),
+			       sizeof(struct quic_tx_ancillary_data));
+			ancillary_data_ptr = cmsg_hdr;
+		} else if (cmsg_hdr->cmsg_type == UDP_SEGMENT) {
+			if (cmsg_hdr->cmsg_len != CMSG_LEN(sizeof(u16)))
+				return -EINVAL;
+			memcpy((void *)udp_pkt_size, CMSG_DATA(cmsg_hdr),
+			       sizeof(u16));
+		}
+	}
+
+	if (!ancillary_data_ptr)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int quic_sendmsg_validate(struct msghdr *msg)
+{
+	if (!iter_is_iovec(&msg->msg_iter))
+		return -EINVAL;
+
+	if (!msg->msg_controllen)
+		return -EINVAL;
+
+	return 0;
+}
+
+static struct quic_connection_rhash
+*quic_lookup_connection(struct quic_context *ctx,
+			u8 *conn_id,
+			struct quic_tx_ancillary_data *ancillary_data)
+{
+	struct quic_connection_info_key conn_key;
+
+	// Lookup connection information by the connection key.
+	memset(&conn_key, 0, sizeof(struct quic_connection_info_key));
+	// fill the connection id up to the max connection ID length
+	if (ancillary_data->conn_id_length > QUIC_MAX_CONNECTION_ID_SIZE)
+		return NULL;
+
+	conn_key.conn_id_length = ancillary_data->conn_id_length;
+	if (ancillary_data->conn_id_length)
+		memcpy(conn_key.conn_id,
+		       conn_id,
+		       ancillary_data->conn_id_length);
+	return rhashtable_lookup_fast(&ctx->tx_connections,
+				      &conn_key,
+				      quic_tx_connection_params);
+}
+
+static int quic_sg_capacity_from_msg(const size_t pkt_size,
+				     const off_t offset,
+				     const size_t length)
+{
+	size_t	pages = 0;
+	size_t	pkts = 0;
+
+	pages = DIV_ROUND_UP(offset + length, PAGE_SIZE);
+	pkts = DIV_ROUND_UP(length, pkt_size);
+	return pages + pkts + 1;
+}
+
+static void quic_put_plain_user_pages(struct page **pages, size_t nr_pages)
+{
+	int i;
+
+	for (i = 0; i < nr_pages; ++i)
+		if (i == 0 || pages[i] != pages[i - 1])
+			put_page(pages[i]);
+}
+
+static int quic_get_plain_user_pages(struct msghdr * const msg,
+				     struct page **pages,
+				     int *page_indices)
+{
+	size_t	nr_mapped = 0;
+	size_t	nr_pages = 0;
+	void __user	*data_addr;
+	void	*page_addr;
+	size_t	count = 0;
+	off_t	data_off;
+	int	ret = 0;
+	int	i;
+
+	for (i = 0; i < msg->msg_iter.nr_segs; ++i) {
+		data_addr = msg->msg_iter.iov[i].iov_base;
+		if (!i)
+			data_addr += msg->msg_iter.iov_offset;
+		page_addr =
+			(void *)((unsigned long)data_addr & PAGE_MASK);
+
+		data_off = (unsigned long)data_addr & ~PAGE_MASK;
+		nr_pages =
+			DIV_ROUND_UP(data_off + msg->msg_iter.iov[i].iov_len,
+				     PAGE_SIZE);
+		if (nr_mapped + nr_pages > QUIC_MAX_PLAIN_PAGES) {
+			quic_put_plain_user_pages(pages, nr_mapped);
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		count = get_user_pages((unsigned long)page_addr, nr_pages, 1,
+				       pages, NULL);
+		if (count < nr_pages) {
+			quic_put_plain_user_pages(pages, nr_mapped + count);
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		page_indices[i] = nr_mapped;
+		nr_mapped += count;
+		pages += count;
+	}
+	ret = nr_mapped;
+
+out:
+	return ret;
+}
+
+static int quic_sg_plain_from_mapped_msg(struct msghdr * const msg,
+					 struct page **plain_pages,
+					 void **iov_base_ptrs,
+					 void **iov_data_ptrs,
+					 const size_t plain_size,
+					 const size_t pkt_size,
+					 struct scatterlist * const sg_alloc,
+					 const size_t max_sg_alloc,
+					 struct scatterlist ** const sg_pkts,
+					 size_t *nr_plain_pages)
+{
+	int iov_page_indices[QUIC_MAX_IOVEC_SEGMENTS];
+	struct scatterlist *sg;
+	unsigned int pkt_i = 0;
+	ssize_t left_on_page;
+	size_t pkt_left;
+	unsigned int i;
+	size_t seg_len;
+	off_t page_ofs;
+	off_t seg_ofs;
+	int ret = 0;
+	int page_i;
+
+	if (msg->msg_iter.nr_segs >= QUIC_MAX_IOVEC_SEGMENTS) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = quic_get_plain_user_pages(msg, plain_pages, iov_page_indices);
+	if (ret < 0)
+		goto out;
+
+	*nr_plain_pages = ret;
+	sg = sg_alloc;
+	sg_pkts[pkt_i] = sg;
+	sg_unmark_end(sg);
+	pkt_left = pkt_size;
+	for (i = 0; i < msg->msg_iter.nr_segs; ++i) {
+		page_ofs = ((unsigned long)msg->msg_iter.iov[i].iov_base
+			   & (PAGE_SIZE - 1));
+		page_i = 0;
+		if (!i) {
+			page_ofs += msg->msg_iter.iov_offset;
+			while (page_ofs >= PAGE_SIZE) {
+				page_ofs -= PAGE_SIZE;
+				page_i++;
+			}
+		}
+
+		seg_len = msg->msg_iter.iov[i].iov_len;
+		page_i += iov_page_indices[i];
+
+		if (page_i >= QUIC_MAX_PLAIN_PAGES)
+			return -EFAULT;
+
+		seg_ofs = 0;
+		while (seg_ofs < seg_len) {
+			if (sg - sg_alloc > max_sg_alloc)
+				return -EFAULT;
+
+			sg_unmark_end(sg);
+			left_on_page = min_t(size_t, PAGE_SIZE - page_ofs,
+					     seg_len - seg_ofs);
+			if (left_on_page <= 0)
+				return -EFAULT;
+
+			if (left_on_page > pkt_left) {
+				sg_set_page(sg, plain_pages[page_i], pkt_left,
+					    page_ofs);
+				pkt_i++;
+				seg_ofs += pkt_left;
+				page_ofs += pkt_left;
+				sg_mark_end(sg);
+				sg++;
+				sg_pkts[pkt_i] = sg;
+				pkt_left = pkt_size;
+				continue;
+			}
+			sg_set_page(sg, plain_pages[page_i], left_on_page,
+				    page_ofs);
+			page_i++;
+			page_ofs = 0;
+			seg_ofs += left_on_page;
+			pkt_left -= left_on_page;
+			if (pkt_left == 0 ||
+			    (seg_ofs == seg_len &&
+			     i == msg->msg_iter.nr_segs - 1)) {
+				sg_mark_end(sg);
+				pkt_i++;
+				sg++;
+				sg_pkts[pkt_i] = sg;
+				pkt_left = pkt_size;
+			} else {
+				sg++;
+			}
+		}
+	}
+
+	if (pkt_left && pkt_left != pkt_size) {
+		pkt_i++;
+		sg_mark_end(sg);
+	}
+	ret = pkt_i;
+
+out:
+	return ret;
+}
+
+/* sg_alloc: allocated zeroed array of scatterlists
+ * cipher_page: preallocated compound page
+ */
+static int quic_sg_cipher_from_pkts(const size_t cipher_tag_size,
+				    const size_t plain_pkt_size,
+				    const size_t plain_size,
+				    struct page * const cipher_page,
+				    struct scatterlist * const sg_alloc,
+				    const size_t nr_sg_alloc,
+				    struct scatterlist ** const sg_cipher)
+{
+	const size_t cipher_pkt_size = plain_pkt_size + cipher_tag_size;
+	size_t pkts = DIV_ROUND_UP(plain_size, plain_pkt_size);
+	struct scatterlist *sg = sg_alloc;
+	int pkt_i;
+	void *ptr;
+
+	if (pkts > nr_sg_alloc)
+		return -EINVAL;
+
+	ptr = page_address(cipher_page);
+	for (pkt_i = 0; pkt_i < pkts;
+		++pkt_i, ptr += cipher_pkt_size, ++sg) {
+		sg_set_buf(sg, ptr, cipher_pkt_size);
+		sg_mark_end(sg);
+		sg_cipher[pkt_i] = sg;
+	}
+	return pkts;
+}
+
+/* fast copy from scatterlist to a buffer assuming that all pages are
+ * available in kernel memory.
+ */
+static int quic_sg_pcopy_to_buffer_kernel(struct scatterlist *sg,
+					  u8 *buffer,
+					  size_t bytes_to_copy,
+					  off_t offset_to_read)
+{
+	off_t sg_remain = sg->length;
+	size_t to_copy;
+
+	if (!bytes_to_copy)
+		return 0;
+
+	// skip to offset first
+	while (offset_to_read > 0) {
+		if (!sg_remain)
+			return -EINVAL;
+		if (offset_to_read < sg_remain) {
+			sg_remain -= offset_to_read;
+			break;
+		}
+		offset_to_read -= sg_remain;
+		sg = sg_next(sg);
+		if (!sg)
+			return -EINVAL;
+		sg_remain = sg->length;
+	}
+
+	// traverse sg list from offset to offset + bytes_to_copy
+	while (bytes_to_copy) {
+		to_copy = min_t(size_t, bytes_to_copy, sg_remain);
+		if (!to_copy)
+			return -EINVAL;
+		memcpy(buffer, sg_virt(sg) + (sg->length - sg_remain), to_copy);
+		buffer += to_copy;
+		bytes_to_copy -= to_copy;
+		if (bytes_to_copy) {
+			sg = sg_next(sg);
+			if (!sg)
+				return -EINVAL;
+			sg_remain = sg->length;
+		}
+	}
+
+	return 0;
+}
+
+static int quic_copy_header(struct scatterlist *sg_plain,
+			    u8 *buf, const size_t buf_len,
+			    const size_t conn_id_len)
+{
+	u8 *pkt = sg_virt(sg_plain);
+	size_t hdr_len;
+
+	hdr_len = 1 + conn_id_len + ((*pkt & 0x03) + 1);
+	if (hdr_len > QUIC_MAX_SHORT_HEADER_SIZE || hdr_len > buf_len)
+		return -EINVAL;
+
+	WARN_ON_ONCE(quic_sg_pcopy_to_buffer_kernel(sg_plain, buf, hdr_len, 0));
+	return hdr_len;
+}
+
+static u64 quic_unpack_pkt_num(struct quic_tx_ancillary_data * const control,
+			       const u8 * const hdr,
+			       const off_t payload_crypto_off)
+{
+	u64 truncated_pn = 0;
+	u64 candidate_pn;
+	u64 expected_pn;
+	u64 pn_hwin;
+	u64 pn_mask;
+	u64 pn_len;
+	u64 pn_win;
+	int i;
+
+	pn_len = (hdr[0] & 0x03) + 1;
+	expected_pn = control->next_pkt_num;
+
+	for (i = 1 + control->conn_id_length; i < payload_crypto_off; ++i) {
+		truncated_pn <<= 8;
+		truncated_pn |= hdr[i];
+	}
+
+	pn_win = 1ULL << (pn_len << 3);
+	pn_hwin = pn_win >> 1;
+	pn_mask = pn_win - 1;
+	candidate_pn = (expected_pn & ~pn_mask) | truncated_pn;
+
+	if (expected_pn > pn_hwin &&
+	    candidate_pn <= expected_pn - pn_hwin &&
+	    candidate_pn < (1ULL << 62) - pn_win)
+		return candidate_pn + pn_win;
+
+	if (candidate_pn > expected_pn + pn_hwin &&
+	    candidate_pn >= pn_win)
+		return candidate_pn - pn_win;
+
+	return candidate_pn;
+}
+
+static int
+quic_construct_header_prot_mask(struct quic_internal_crypto_context *crypto_ctx,
+				struct skcipher_request *hdr_mask_req,
+				struct scatterlist *sg_cipher_pkt,
+				off_t sample_offset,
+				u8 *hdr_mask)
+{
+	u8 *sample = sg_virt(sg_cipher_pkt) + sample_offset;
+	u8 hdr_ctr[sizeof(u32) + QUIC_CIPHER_MAX_IV_SIZE];
+	u8 chacha20_zeros[5] = {0, 0, 0, 0, 0};
+	struct scatterlist sg_cipher_sample;
+	struct scatterlist sg_hdr_mask;
+	struct crypto_wait wait_header;
+	__le32	counter;
+
+	BUILD_BUG_ON(QUIC_HDR_MASK_SIZE
+		     < sizeof(u32) + QUIC_CIPHER_MAX_IV_SIZE);
+
+	sg_init_one(&sg_hdr_mask, hdr_mask, QUIC_HDR_MASK_SIZE);
+	skcipher_request_set_callback(hdr_mask_req, 0, crypto_req_done,
+				      &wait_header);
+
+	if (crypto_ctx->conn_info.cipher_type == TLS_CIPHER_CHACHA20_POLY1305) {
+		sg_init_one(&sg_cipher_sample, (u8 *)chacha20_zeros,
+			    sizeof(chacha20_zeros));
+		counter = cpu_to_le32(*((u32 *)sample));
+		memset(hdr_ctr, 0, sizeof(hdr_ctr));
+		memcpy((u8 *)hdr_ctr, (u8 *)&counter, sizeof(u32));
+		memcpy((u8 *)hdr_ctr + sizeof(u32),
+		       (sample + sizeof(u32)),
+		       QUIC_CIPHER_MAX_IV_SIZE);
+		skcipher_request_set_crypt(hdr_mask_req, &sg_cipher_sample,
+					   &sg_hdr_mask, 5, hdr_ctr);
+	} else {
+		// cipher pages are continuous, get the pointer to the sg data
+		// directly, pages are allocated in kernel
+		sg_init_one(&sg_cipher_sample, sample, QUIC_HDR_MASK_SIZE);
+		skcipher_request_set_crypt(hdr_mask_req, &sg_cipher_sample,
+					   &sg_hdr_mask, QUIC_HDR_MASK_SIZE,
+					   NULL);
+	}
+
+	return crypto_wait_req(crypto_skcipher_encrypt(hdr_mask_req),
+			       &wait_header);
+}
+
+static int quic_protect_header(struct quic_internal_crypto_context *crypto_ctx,
+			       struct quic_tx_ancillary_data *control,
+			       struct skcipher_request *hdr_mask_req,
+			       struct scatterlist *sg_cipher_pkt,
+			       int payload_crypto_off)
+{
+	u8 hdr_mask[QUIC_HDR_MASK_SIZE];
+	off_t quic_pkt_num_off;
+	u8 quic_pkt_num_len;
+	u8 *cipher_hdr;
+	int err;
+	int i;
+
+	quic_pkt_num_off = 1 + control->conn_id_length;
+	quic_pkt_num_len = payload_crypto_off - quic_pkt_num_off;
+
+	if (quic_pkt_num_len > 4)
+		return -EPERM;
+
+	err = quic_construct_header_prot_mask(crypto_ctx, hdr_mask_req,
+					      sg_cipher_pkt,
+					      payload_crypto_off +
+					      (4 - quic_pkt_num_len),
+					      hdr_mask);
+	if (unlikely(err))
+		return err;
+
+	cipher_hdr = sg_virt(sg_cipher_pkt);
+	// protect the public flags
+	cipher_hdr[0] ^= (hdr_mask[0] & 0x1f);
+
+	for (i = 0; i < quic_pkt_num_len; ++i)
+		cipher_hdr[quic_pkt_num_off + i] ^= hdr_mask[1 + i];
+
+	return 0;
+}
+
+static
+void quic_construct_ietf_nonce(u8 *nonce,
+			       struct quic_internal_crypto_context *crypto_ctx,
+			       u64 quic_pkt_num)
+{
+	u8 *iv = quic_payload_iv(crypto_ctx);
+	int i;
+
+	for (i = quic_crypto_nonce_size(crypto_ctx->conn_info.cipher_type) - 1;
+	     i >= 0 && quic_pkt_num;
+	     --i, quic_pkt_num >>= 8)
+		nonce[i] = iv[i] ^ (u8)quic_pkt_num;
+
+	for (; i >= 0; --i)
+		nonce[i] = iv[i];
+}
+
+static ssize_t quic_sendpage(struct quic_context *ctx,
+			     struct sock *sk,
+			     struct msghdr *msg,
+			     const size_t cipher_size,
+			     struct page * const cipher_page)
+{
+	struct kvec iov;
+	ssize_t ret;
+
+	iov.iov_base = page_address(cipher_page);
+	iov.iov_len = cipher_size;
+	iov_iter_kvec(&msg->msg_iter, WRITE, &iov, 1, cipher_size);
+	ret = security_socket_sendmsg(sk->sk_socket, msg, msg_data_left(msg));
+	if (ret)
+		return ret;
+
+	ret = ctx->sk_proto->sendmsg(sk, msg, msg_data_left(msg));
+	WARN_ON(ret == -EIOCBQUEUED);
+	return ret;
+}
+
+static int quic_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
+{
+	struct quic_internal_crypto_context *crypto_ctx = NULL;
+	struct scatterlist *sg_cipher_pkts[QUIC_MAX_GSO_FRAGS];
+	struct scatterlist *sg_plain_pkts[QUIC_MAX_GSO_FRAGS];
+	struct page *plain_pages[QUIC_MAX_PLAIN_PAGES];
+	void *plain_base_ptrs[QUIC_MAX_IOVEC_SEGMENTS];
+	void *plain_data_ptrs[QUIC_MAX_IOVEC_SEGMENTS];
+	struct msghdr msg_cipher = {
+		.msg_name = msg->msg_name,
+		.msg_namelen = msg->msg_namelen,
+		.msg_flags = msg->msg_flags,
+		.msg_control = msg->msg_control,
+		.msg_controllen = msg->msg_controllen,
+	};
+	struct quic_connection_rhash *connhash = NULL;
+	struct quic_context *ctx = quic_get_ctx(sk);
+	u8 hdr_buf[QUIC_MAX_SHORT_HEADER_SIZE];
+	struct skcipher_request *hdr_mask_req;
+	struct quic_tx_ancillary_data control;
+	u8 nonce[QUIC_CIPHER_MAX_NONCE_SIZE];
+	struct	aead_request *aead_req = NULL;
+	struct scatterlist *sg_cipher = NULL;
+	struct udp_sock *up = udp_sk(sk);
+	struct scatterlist *sg_plain = NULL;
+	u16 gso_pkt_size = up->gso_size;
+	size_t last_plain_pkt_size = 0;
+	off_t	payload_crypto_offset;
+	struct crypto_aead *tfm = NULL;
+	size_t nr_plain_pages = 0;
+	struct crypto_wait waiter;
+	size_t nr_sg_cipher_pkts;
+	size_t nr_sg_plain_pkts;
+	ssize_t hdr_buf_len = 0;
+	size_t nr_sg_alloc = 0;
+	size_t plain_pkt_size;
+	u64	full_pkt_num;
+	size_t cipher_size;
+	size_t plain_size;
+	size_t pkt_size;
+	size_t tag_size;
+	int ret = 0;
+	int pkt_i;
+	int err;
+
+	memset(&hdr_buf[0], 0, QUIC_MAX_SHORT_HEADER_SIZE);
+	hdr_buf_len = copy_from_iter(hdr_buf, QUIC_MAX_SHORT_HEADER_SIZE,
+				     &msg->msg_iter);
+	if (hdr_buf_len <= 0) {
+		ret = -EINVAL;
+		goto out;
+	}
+	iov_iter_revert(&msg->msg_iter, hdr_buf_len);
+
+	ctx = quic_get_ctx(sk);
+
+	// Bypass for anything that is guaranteed not QUIC.
+	plain_size = len;
+
+	if (plain_size < 2)
+		return ctx->sk_proto->sendmsg(sk, msg, len);
+
+	// Bypass for other than short header.
+	if ((hdr_buf[0] & 0xc0) != 0x40)
+		return ctx->sk_proto->sendmsg(sk, msg, len);
+
+	// Crypto adds a tag after the packet. Corking a payload would produce
+	// a crypto tag after each portion. Use GSO instead.
+	if ((msg->msg_flags & MSG_MORE) || up->pending) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = quic_sendmsg_validate(msg);
+	if (ret)
+		goto out;
+
+	ret = quic_extract_ancillary_data(msg, &control, &gso_pkt_size);
+	if (ret)
+		goto out;
+
+	// Reserved bits with ancillary data present are an error.
+	if (control.flags & ~QUIC_ANCILLARY_FLAGS) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	// Bypass offload on request. First packet bypass applies to all
+	// packets in the GSO pack.
+	if (control.flags & QUIC_BYPASS_ENCRYPTION)
+		return ctx->sk_proto->sendmsg(sk, msg, len);
+
+	if (hdr_buf_len < 1 + control.conn_id_length) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	// Fetch the flow
+	connhash = quic_lookup_connection(ctx, &hdr_buf[1], &control);
+	if (!connhash) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	crypto_ctx = &connhash->crypto_ctx;
+
+	tag_size = quic_crypto_tag_size(crypto_ctx->conn_info.cipher_type);
+
+	// For GSO, use the GSO size minus cipher tag size as the packet size;
+	// for non-GSO, use the size of the whole plaintext.
+	// Reduce the packet size by tag size to keep the original packet size
+	// for the rest of the UDP path in the stack.
+	if (!gso_pkt_size) {
+		plain_pkt_size = plain_size;
+	} else {
+		if (gso_pkt_size < tag_size)
+			goto out;
+
+		plain_pkt_size = gso_pkt_size - tag_size;
+	}
+
+	// Build scatterlist from the input data, split by GSO minus the
+	// crypto tag size.
+	nr_sg_alloc = quic_sg_capacity_from_msg(plain_pkt_size,
+						msg->msg_iter.iov_offset,
+						plain_size);
+	if ((nr_sg_alloc * 2) >= QUIC_MAX_SG_ALLOC_ELEMENTS) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	sg_plain = ctx->sg_alloc;
+	sg_cipher = sg_plain + nr_sg_alloc;
+
+	ret = quic_sg_plain_from_mapped_msg(msg, plain_pages,
+					    plain_base_ptrs,
+					    plain_data_ptrs, plain_size,
+					    plain_pkt_size, sg_plain,
+					    nr_sg_alloc, sg_plain_pkts,
+					    &nr_plain_pages);
+
+	if (ret < 0)
+		goto out;
+
+	nr_sg_plain_pkts = ret;
+	last_plain_pkt_size = plain_size % plain_pkt_size;
+	if (!last_plain_pkt_size)
+		last_plain_pkt_size = plain_pkt_size;
+
+	// Build scatterlist for the ciphertext, split by GSO.
+	cipher_size = plain_size + nr_sg_plain_pkts * tag_size;
+
+	if (DIV_ROUND_UP(cipher_size, PAGE_SIZE)
+	    >= (1 << QUIC_MAX_CIPHER_PAGES_ORDER)) {
+		ret = -ENOMEM;
+		goto out_put_pages;
+	}
+
+	ret = quic_sg_cipher_from_pkts(tag_size, plain_pkt_size, plain_size,
+				       ctx->cipher_page, sg_cipher, nr_sg_alloc,
+				       sg_cipher_pkts);
+	if (ret < 0)
+		goto out_put_pages;
+
+	nr_sg_cipher_pkts = ret;
+
+	if (nr_sg_plain_pkts != nr_sg_cipher_pkts) {
+		ret = -EPERM;
+		goto out_put_pages;
+	}
+
+	// Encrypt and protect header for each packet individually.
+	tfm = crypto_ctx->packet_aead;
+	crypto_aead_clear_flags(tfm, ~0);
+	aead_req = aead_request_alloc(tfm, GFP_KERNEL);
+	if (!aead_req) {
+		aead_request_free(aead_req);
+		ret = -ENOMEM;
+		goto out_put_pages;
+	}
+
+	hdr_mask_req = skcipher_request_alloc(crypto_ctx->header_tfm,
+					      GFP_KERNEL);
+	if (!hdr_mask_req) {
+		aead_request_free(aead_req);
+		ret = -ENOMEM;
+		goto out_put_pages;
+	}
+
+	for (pkt_i = 0; pkt_i < nr_sg_plain_pkts; ++pkt_i) {
+		payload_crypto_offset =
+			quic_copy_header(sg_plain_pkts[pkt_i],
+					 hdr_buf,
+					 sizeof(hdr_buf),
+					 control.conn_id_length);
+
+		full_pkt_num = quic_unpack_pkt_num(&control, hdr_buf,
+						   payload_crypto_offset);
+
+		pkt_size = (pkt_i + 1 < nr_sg_plain_pkts
+				? plain_pkt_size
+				: last_plain_pkt_size)
+			    - payload_crypto_offset;
+		if (pkt_size < 0) {
+			aead_request_free(aead_req);
+			skcipher_request_free(hdr_mask_req);
+			ret = -EINVAL;
+			goto out_put_pages;
+		}
+
+		/* Construct nonce and initialize request */
+		quic_construct_ietf_nonce(nonce, crypto_ctx, full_pkt_num);
+
+		/* Encrypt the body */
+		aead_request_set_callback(aead_req,
+					  CRYPTO_TFM_REQ_MAY_BACKLOG
+					  | CRYPTO_TFM_REQ_MAY_SLEEP,
+					  crypto_req_done, &waiter);
+		aead_request_set_crypt(aead_req, sg_plain_pkts[pkt_i],
+				       sg_cipher_pkts[pkt_i],
+				       pkt_size,
+				       nonce);
+		aead_request_set_ad(aead_req, payload_crypto_offset);
+		err = crypto_wait_req(crypto_aead_encrypt(aead_req), &waiter);
+		if (unlikely(err)) {
+			ret = err;
+			aead_request_free(aead_req);
+			skcipher_request_free(hdr_mask_req);
+			goto out_put_pages;
+		}
+
+		/* Protect the header */
+		memcpy(sg_virt(sg_cipher_pkts[pkt_i]), hdr_buf,
+		       payload_crypto_offset);
+
+		err = quic_protect_header(crypto_ctx, &control,
+					  hdr_mask_req,
+					  sg_cipher_pkts[pkt_i],
+					  payload_crypto_offset);
+		if (unlikely(err)) {
+			ret = err;
+			aead_request_free(aead_req);
+			skcipher_request_free(hdr_mask_req);
+			goto out_put_pages;
+		}
+	}
+	skcipher_request_free(hdr_mask_req);
+	aead_request_free(aead_req);
+
+	// Deliver to the next layer.
+	if (ctx->sk_proto->sendpage) {
+		msg_cipher.msg_flags |= MSG_MORE;
+		err = ctx->sk_proto->sendmsg(sk, &msg_cipher, 0);
+		if (err < 0) {
+			ret = err;
+			goto out_put_pages;
+		}
+
+		err = ctx->sk_proto->sendpage(sk, ctx->cipher_page, 0,
+					      cipher_size, 0);
+		if (err < 0) {
+			ret = err;
+			goto out_put_pages;
+		}
+		if (err != cipher_size) {
+			ret = -EINVAL;
+			goto out_put_pages;
+		}
+		ret = plain_size;
+	} else {
+		ret = quic_sendpage(ctx, sk, &msg_cipher, cipher_size,
+				    ctx->cipher_page);
+		// indicate full plaintext transmission to the caller.
+		if (ret > 0)
+			ret = plain_size;
+	}
+
+out_put_pages:
+	quic_put_plain_user_pages(plain_pages, nr_plain_pages);
+
+out:
+	return ret;
+}
+
+static int quic_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t len)
+{
+	struct quic_context *ctx;
+	int ret;
+
+	rcu_read_lock();
+	ctx = quic_get_ctx(sk);
+	rcu_read_unlock();
+	if (!ctx)
+		return -EINVAL;
+
+	mutex_lock(&ctx->sendmsg_mux);
+	ret = quic_sendmsg(sk, msg, len);
+	mutex_unlock(&ctx->sendmsg_mux);
+	return ret;
+}
+
+static void quic_release_resources(struct sock *sk)
+{
+	struct quic_internal_crypto_context *crypto_ctx;
+	struct quic_connection_rhash *connhash;
+	struct inet_sock *inet = inet_sk(sk);
+	struct rhashtable_iter hti;
+	struct quic_context *ctx;
+	struct proto *sk_proto;
+
+	rcu_read_lock();
+	ctx = quic_get_ctx(sk);
+	if (!ctx) {
+		rcu_read_unlock();
+		return;
+	}
+
+	sk_proto = ctx->sk_proto;
+
+	rhashtable_walk_enter(&ctx->tx_connections, &hti);
+	rhashtable_walk_start(&hti);
+
+	while ((connhash = rhashtable_walk_next(&hti))) {
+		if (IS_ERR(connhash)) {
+			if (PTR_ERR(connhash) == -EAGAIN)
+				continue;
+			break;
+		}
+
+		crypto_ctx = &connhash->crypto_ctx;
+		crypto_free_aead(crypto_ctx->packet_aead);
+		crypto_free_skcipher(crypto_ctx->header_tfm);
+		memzero_explicit(crypto_ctx, sizeof(*crypto_ctx));
+	}
+
+	rhashtable_walk_stop(&hti);
+	rhashtable_walk_exit(&hti);
+	rhashtable_destroy(&ctx->tx_connections);
+
+	if (ctx->cipher_page) {
+		quic_free_cipher_page(ctx->cipher_page);
+		ctx->cipher_page = NULL;
+	}
+
+	rcu_read_unlock();
+
+	write_lock_bh(&sk->sk_callback_lock);
+	rcu_assign_pointer(inet->ulp_data, NULL);
+	WRITE_ONCE(sk->sk_prot, sk_proto);
+	write_unlock_bh(&sk->sk_callback_lock);
+
+	kfree_rcu(ctx, rcu);
+}
+
+static void
+quic_prep_protos(unsigned int af, struct proto *proto, const struct proto *base)
+{
+	if (likely(test_bit(af, &af_init_done)))
+		return;
+
+	spin_lock(&quic_proto_lock);
+	if (test_bit(af, &af_init_done))
+		goto out_unlock;
+
+	*proto			= *base;
+	proto->setsockopt	= quic_setsockopt;
+	proto->getsockopt	= quic_getsockopt;
+	proto->sendmsg		= quic_sendmsg_locked;
+
+	smp_mb__before_atomic(); /* proto calls should be visible first */
+	set_bit(af, &af_init_done);
+
+out_unlock:
+	spin_unlock(&quic_proto_lock);
+}
+
+static void quic_update_proto(struct sock *sk, struct quic_context *ctx)
+{
+	struct proto *udp_proto, *quic_proto;
+	struct inet_sock *inet = inet_sk(sk);
+
+	udp_proto = READ_ONCE(sk->sk_prot);
+	ctx->sk_proto = udp_proto;
+	quic_proto = sk->sk_family == AF_INET ? &quic_v4_proto : &quic_v6_proto;
+
+	quic_prep_protos(sk->sk_family, quic_proto, udp_proto);
+
+	write_lock_bh(&sk->sk_callback_lock);
+	rcu_assign_pointer(inet->ulp_data, ctx);
+	WRITE_ONCE(sk->sk_prot, quic_proto);
+	write_unlock_bh(&sk->sk_callback_lock);
+}
+
+static int quic_init(struct sock *sk)
+{
+	struct quic_context *ctx;
+
+	ctx = quic_ctx_create();
+	if (!ctx)
+		return -ENOMEM;
+
+	quic_update_proto(sk, ctx);
+
+	return 0;
+}
+
+static void quic_release(struct sock *sk)
+{
+	lock_sock(sk);
+	quic_release_resources(sk);
+	release_sock(sk);
+}
+
+static struct udp_ulp_ops quic_ulp_ops __read_mostly = {
+	.name		= "quic-crypto",
+	.owner		= THIS_MODULE,
+	.init		= quic_init,
+	.release	= quic_release,
+};
+
+static int __init quic_register(void)
+{
+	udp_register_ulp(&quic_ulp_ops);
+	return 0;
+}
+
+static void __exit quic_unregister(void)
+{
+	udp_unregister_ulp(&quic_ulp_ops);
+}
+
+module_init(quic_register);
+module_exit(quic_unregister);
+
+MODULE_DESCRIPTION("QUIC crypto ULP");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_UDP_ULP("quic-crypto");
-- 
2.30.2

