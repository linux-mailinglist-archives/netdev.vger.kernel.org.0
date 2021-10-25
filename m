Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43441439710
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 15:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbhJYNH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 09:07:27 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:60607 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233435AbhJYNHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 09:07:25 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UterkeI_1635167100;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UterkeI_1635167100)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 Oct 2021 21:05:01 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH] net/tls: getsockopt supports complete algorithm list
Date:   Mon, 25 Oct 2021 21:05:00 +0800
Message-Id: <20211025130500.93077-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

AES_CCM_128 and CHACHA20_POLY1305 are already supported by tls,
similar to setsockopt, getsockopt also needs to support these
two algorithms.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 net/tls/tls_main.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index d44399efeac6..278192ee133e 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -421,6 +421,48 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EFAULT;
 		break;
 	}
+	case TLS_CIPHER_AES_CCM_128: {
+		struct tls12_crypto_info_aes_ccm_128 *aes_ccm_128 =
+			container_of(crypto_info,
+				struct tls12_crypto_info_aes_ccm_128, info);
+
+		if (len != sizeof(*aes_ccm_128)) {
+			rc = -EINVAL;
+			goto out;
+		}
+		lock_sock(sk);
+		memcpy(aes_ccm_128->iv,
+		       cctx->iv + TLS_CIPHER_AES_CCM_128_SALT_SIZE,
+		       TLS_CIPHER_AES_CCM_128_IV_SIZE);
+		memcpy(aes_ccm_128->rec_seq, cctx->rec_seq,
+		       TLS_CIPHER_AES_CCM_128_REC_SEQ_SIZE);
+		release_sock(sk);
+		if (copy_to_user(optval, aes_ccm_128, sizeof(*aes_ccm_128)))
+			rc = -EFAULT;
+		break;
+	}
+	case TLS_CIPHER_CHACHA20_POLY1305: {
+		struct tls12_crypto_info_chacha20_poly1305 *chacha20_poly1305 =
+			container_of(crypto_info,
+				struct tls12_crypto_info_chacha20_poly1305,
+				info);
+
+		if (len != sizeof(*chacha20_poly1305)) {
+			rc = -EINVAL;
+			goto out;
+		}
+		lock_sock(sk);
+		memcpy(chacha20_poly1305->iv,
+		       cctx->iv + TLS_CIPHER_CHACHA20_POLY1305_SALT_SIZE,
+		       TLS_CIPHER_CHACHA20_POLY1305_IV_SIZE);
+		memcpy(chacha20_poly1305->rec_seq, cctx->rec_seq,
+		       TLS_CIPHER_CHACHA20_POLY1305_REC_SEQ_SIZE);
+		release_sock(sk);
+		if (copy_to_user(optval, chacha20_poly1305,
+				sizeof(*chacha20_poly1305)))
+			rc = -EFAULT;
+		break;
+	}
 	case TLS_CIPHER_SM4_GCM: {
 		struct tls12_crypto_info_sm4_gcm *sm4_gcm_info =
 			container_of(crypto_info,
-- 
2.19.1.3.ge56e4f7

