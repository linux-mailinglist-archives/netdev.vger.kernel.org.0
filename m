Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929E940C433
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 13:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237483AbhIOLOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 07:14:04 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:48895 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237347AbhIOLOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 07:14:04 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UoU9AUO_1631704362;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UoU9AUO_1631704362)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 15 Sep 2021 19:12:42 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>,
        "YiLin . Li" <YiLin.Li@linux.alibaba.com>
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH] net/tls: support SM4 GCM/CCM algorithm
Date:   Wed, 15 Sep 2021 19:12:42 +0800
Message-Id: <20210915111242.32413-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RFC8998 specification defines the use of the ShangMi algorithm
cipher suites in TLS 1.3, and also supports the GCM/CCM mode using
the SM4 algorithm.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 include/uapi/linux/tls.h | 30 ++++++++++++++++++++++++++
 net/tls/tls_main.c       | 46 ++++++++++++++++++++++++++++++++++++++++
 net/tls/tls_sw.c         | 34 +++++++++++++++++++++++++++++
 3 files changed, 110 insertions(+)

diff --git a/include/uapi/linux/tls.h b/include/uapi/linux/tls.h
index 0d54baea1d8d..5f38be0ec0f3 100644
--- a/include/uapi/linux/tls.h
+++ b/include/uapi/linux/tls.h
@@ -84,6 +84,20 @@
 #define TLS_CIPHER_CHACHA20_POLY1305_TAG_SIZE	16
 #define TLS_CIPHER_CHACHA20_POLY1305_REC_SEQ_SIZE	8
 
+#define TLS_CIPHER_SM4_GCM				55
+#define TLS_CIPHER_SM4_GCM_IV_SIZE			8
+#define TLS_CIPHER_SM4_GCM_KEY_SIZE		16
+#define TLS_CIPHER_SM4_GCM_SALT_SIZE		4
+#define TLS_CIPHER_SM4_GCM_TAG_SIZE		16
+#define TLS_CIPHER_SM4_GCM_REC_SEQ_SIZE		8
+
+#define TLS_CIPHER_SM4_CCM				56
+#define TLS_CIPHER_SM4_CCM_IV_SIZE			8
+#define TLS_CIPHER_SM4_CCM_KEY_SIZE		16
+#define TLS_CIPHER_SM4_CCM_SALT_SIZE		4
+#define TLS_CIPHER_SM4_CCM_TAG_SIZE		16
+#define TLS_CIPHER_SM4_CCM_REC_SEQ_SIZE		8
+
 #define TLS_SET_RECORD_TYPE	1
 #define TLS_GET_RECORD_TYPE	2
 
@@ -124,6 +138,22 @@ struct tls12_crypto_info_chacha20_poly1305 {
 	unsigned char rec_seq[TLS_CIPHER_CHACHA20_POLY1305_REC_SEQ_SIZE];
 };
 
+struct tls12_crypto_info_sm4_gcm {
+	struct tls_crypto_info info;
+	unsigned char iv[TLS_CIPHER_SM4_GCM_IV_SIZE];
+	unsigned char key[TLS_CIPHER_SM4_GCM_KEY_SIZE];
+	unsigned char salt[TLS_CIPHER_SM4_GCM_SALT_SIZE];
+	unsigned char rec_seq[TLS_CIPHER_SM4_GCM_REC_SEQ_SIZE];
+};
+
+struct tls12_crypto_info_sm4_ccm {
+	struct tls_crypto_info info;
+	unsigned char iv[TLS_CIPHER_SM4_CCM_IV_SIZE];
+	unsigned char key[TLS_CIPHER_SM4_CCM_KEY_SIZE];
+	unsigned char salt[TLS_CIPHER_SM4_CCM_SALT_SIZE];
+	unsigned char rec_seq[TLS_CIPHER_SM4_CCM_REC_SEQ_SIZE];
+};
+
 enum {
 	TLS_INFO_UNSPEC,
 	TLS_INFO_VERSION,
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index fde56ff49163..f140a6594e9c 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -421,6 +421,46 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EFAULT;
 		break;
 	}
+	case TLS_CIPHER_SM4_GCM: {
+		struct tls12_crypto_info_sm4_gcm *sm4_gcm_info =
+			container_of(crypto_info,
+				struct tls12_crypto_info_sm4_gcm, info);
+
+		if (len != sizeof(*sm4_gcm_info)) {
+			rc = -EINVAL;
+			goto out;
+		}
+		lock_sock(sk);
+		memcpy(sm4_gcm_info->iv,
+		       cctx->iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
+		       TLS_CIPHER_AES_GCM_128_IV_SIZE);
+		memcpy(sm4_gcm_info->rec_seq, cctx->rec_seq,
+		       TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
+		release_sock(sk);
+		if (copy_to_user(optval, sm4_gcm_info, sizeof(*sm4_gcm_info)))
+			rc = -EFAULT;
+		break;
+	}
+	case TLS_CIPHER_SM4_CCM: {
+		struct tls12_crypto_info_sm4_ccm *sm4_ccm_info =
+			container_of(crypto_info,
+				struct tls12_crypto_info_sm4_ccm, info);
+
+		if (len != sizeof(*sm4_ccm_info)) {
+			rc = -EINVAL;
+			goto out;
+		}
+		lock_sock(sk);
+		memcpy(sm4_ccm_info->iv,
+		       cctx->iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
+		       TLS_CIPHER_AES_GCM_128_IV_SIZE);
+		memcpy(sm4_ccm_info->rec_seq, cctx->rec_seq,
+		       TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
+		release_sock(sk);
+		if (copy_to_user(optval, sm4_ccm_info, sizeof(*sm4_ccm_info)))
+			rc = -EFAULT;
+		break;
+	}
 	default:
 		rc = -EINVAL;
 	}
@@ -524,6 +564,12 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
 	case TLS_CIPHER_CHACHA20_POLY1305:
 		optsize = sizeof(struct tls12_crypto_info_chacha20_poly1305);
 		break;
+	case TLS_CIPHER_SM4_GCM:
+		optsize = sizeof(struct tls12_crypto_info_sm4_gcm);
+		break;
+	case TLS_CIPHER_SM4_CCM:
+		optsize = sizeof(struct tls12_crypto_info_sm4_ccm);
+		break;
 	default:
 		rc = -EINVAL;
 		goto err_crypto_info;
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 4feb95e34b64..989d1423a245 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2424,6 +2424,40 @@ int tls_set_sw_offload(struct sock *sk, struct tls_context *ctx, int tx)
 		cipher_name = "rfc7539(chacha20,poly1305)";
 		break;
 	}
+	case TLS_CIPHER_SM4_GCM: {
+		struct tls12_crypto_info_sm4_gcm *sm4_gcm_info;
+
+		sm4_gcm_info = (void *)crypto_info;
+		nonce_size = TLS_CIPHER_SM4_GCM_IV_SIZE;
+		tag_size = TLS_CIPHER_SM4_GCM_TAG_SIZE;
+		iv_size = TLS_CIPHER_SM4_GCM_IV_SIZE;
+		iv = sm4_gcm_info->iv;
+		rec_seq_size = TLS_CIPHER_SM4_GCM_REC_SEQ_SIZE;
+		rec_seq = sm4_gcm_info->rec_seq;
+		keysize = TLS_CIPHER_SM4_GCM_KEY_SIZE;
+		key = sm4_gcm_info->key;
+		salt = sm4_gcm_info->salt;
+		salt_size = TLS_CIPHER_SM4_GCM_SALT_SIZE;
+		cipher_name = "gcm(sm4)";
+		break;
+	}
+	case TLS_CIPHER_SM4_CCM: {
+		struct tls12_crypto_info_sm4_ccm *sm4_ccm_info;
+
+		sm4_ccm_info = (void *)crypto_info;
+		nonce_size = TLS_CIPHER_SM4_CCM_IV_SIZE;
+		tag_size = TLS_CIPHER_SM4_CCM_TAG_SIZE;
+		iv_size = TLS_CIPHER_SM4_CCM_IV_SIZE;
+		iv = sm4_ccm_info->iv;
+		rec_seq_size = TLS_CIPHER_SM4_CCM_REC_SEQ_SIZE;
+		rec_seq = sm4_ccm_info->rec_seq;
+		keysize = TLS_CIPHER_SM4_CCM_KEY_SIZE;
+		key = sm4_ccm_info->key;
+		salt = sm4_ccm_info->salt;
+		salt_size = TLS_CIPHER_SM4_CCM_SALT_SIZE;
+		cipher_name = "ccm(sm4)";
+		break;
+	}
 	default:
 		rc = -EINVAL;
 		goto free_priv;
-- 
2.19.1.3.ge56e4f7

