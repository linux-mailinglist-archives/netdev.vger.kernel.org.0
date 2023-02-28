Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD86D6A5158
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 03:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjB1CmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 21:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjB1CmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 21:42:09 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47F623C46;
        Mon, 27 Feb 2023 18:42:07 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id d6so4807257pgu.2;
        Mon, 27 Feb 2023 18:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677552127;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BgryrYamMwlxpkvf8yGe0sAXedFk3mfXqOUNrIFOlb4=;
        b=Fdc5/BevwEK5n7ZVVIU4DC5bKwqeTIVLDgKc8KHF0oQb4JA1BmpLXnrNZBjdxpa3DT
         R75CEq+lfBvuF2St/RUIvNNUqvpWETFZ0peIXRFnxfgPlwawQZbyqiY09W2wiyXgFmUv
         P1FgbdjP+3Tq6nGh+DIQfwNvF//J+ZmtPI+pWJmc4zm6gGBbGRn8k6WVqGrrhMaMoAIc
         jG9kccKhZeDqdiMdLGXNL99hsUBqkBVEXeHb6MCzM4Y9ZFBCSTsmWF1c1eOlQhuT/Q0y
         /EK5dsSS9WaUzC/VeVykSm+vcljQRf1Z0SPZimGUby0kU9FLIyWxDHkHzKTHQHoR08G7
         X9bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677552127;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BgryrYamMwlxpkvf8yGe0sAXedFk3mfXqOUNrIFOlb4=;
        b=Ag68Q8oyQl/advQMvy7Lwa4JRR4m2O37CABE04DEAHFQY1W4ewVnMwJJg6wmLG6H9k
         gfgkbMYh4hzV557DVsOXpg/8TjC5Dr42wcthzGhtJrQD+463XthnKjZZK/+0DRJ/j0Jv
         yMCISqyy4YKJVxUxl22hs43MVf64k+VrJeSJK3Ev0m6J0ANiJb+I/Jblrv84MVf988Vg
         8wKm9HSxOnyhf3tcuf3W0CLV2MtH3kG+mo/GP+dnuh4uCjLeAL7djsDjAXNLI1OanUXr
         VByhuKTEl392EMEYwYQ2UuJC2xK/BXxGghfpHwe5+U+0KqGcSCsmqPzVzf2PykP7EY7p
         VOjQ==
X-Gm-Message-State: AO0yUKVWeNYmLc7kH4yJPCnO2SNK4CWtVeUzCCoOAIbAehxm4Tfsyem0
        D6W6tMabJQq0qhTlJFUA3z0=
X-Google-Smtp-Source: AK7set9YBBeYz4tG0Q+mfnvolUul/Kfodkw/PseCWcUd/4LN738nBqvprr4a3gturr/CBogzoqaeqQ==
X-Received: by 2002:aa7:8c4d:0:b0:5d9:bfc9:a4f with SMTP id e13-20020aa78c4d000000b005d9bfc90a4fmr1208878pfd.3.1677552127054;
        Mon, 27 Feb 2023 18:42:07 -0800 (PST)
Received: from hbh25y.. ([129.227.150.140])
        by smtp.gmail.com with ESMTPSA id m3-20020aa78a03000000b005e06234e70esm4852108pfa.59.2023.02.27.18.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 18:42:06 -0800 (PST)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     borisp@nvidia.com, john.fastabend@gmail.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        davejwatson@fb.com, aviadye@mellanox.com, ilyal@mellanox.com,
        fw@strlen.de, sd@queasysnail.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH v2] net: tls: fix possible race condition between do_tls_getsockopt_conf() and do_tls_setsockopt_conf()
Date:   Tue, 28 Feb 2023 10:33:44 +0800
Message-Id: <20230228023344.9623-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ctx->crypto_send.info is not protected by lock_sock in
do_tls_getsockopt_conf(). A race condition between do_tls_getsockopt_conf()
and do_tls_setsockopt_conf() can cause a NULL point dereference or
use-after-free read when memcpy.

Please check the following link for pre-information:
 https://lore.kernel.org/all/Y/ht6gQL+u6fj3dG@hog/

Fixes: 3c4d7559159b ("tls: kernel TLS support")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---

	v2: Follow the advice of Jakub and lock do_tls_getsockopt()

 net/tls/tls_main.c | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 3735cb00905d..b32c112984dd 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -405,13 +405,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(crypto_info_aes_gcm_128->iv,
 		       cctx->iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
 		       TLS_CIPHER_AES_GCM_128_IV_SIZE);
 		memcpy(crypto_info_aes_gcm_128->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval,
 				 crypto_info_aes_gcm_128,
 				 sizeof(*crypto_info_aes_gcm_128)))
@@ -429,13 +427,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(crypto_info_aes_gcm_256->iv,
 		       cctx->iv + TLS_CIPHER_AES_GCM_256_SALT_SIZE,
 		       TLS_CIPHER_AES_GCM_256_IV_SIZE);
 		memcpy(crypto_info_aes_gcm_256->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_AES_GCM_256_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval,
 				 crypto_info_aes_gcm_256,
 				 sizeof(*crypto_info_aes_gcm_256)))
@@ -451,13 +447,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(aes_ccm_128->iv,
 		       cctx->iv + TLS_CIPHER_AES_CCM_128_SALT_SIZE,
 		       TLS_CIPHER_AES_CCM_128_IV_SIZE);
 		memcpy(aes_ccm_128->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_AES_CCM_128_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval, aes_ccm_128, sizeof(*aes_ccm_128)))
 			rc = -EFAULT;
 		break;
@@ -472,13 +466,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(chacha20_poly1305->iv,
 		       cctx->iv + TLS_CIPHER_CHACHA20_POLY1305_SALT_SIZE,
 		       TLS_CIPHER_CHACHA20_POLY1305_IV_SIZE);
 		memcpy(chacha20_poly1305->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_CHACHA20_POLY1305_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval, chacha20_poly1305,
 				sizeof(*chacha20_poly1305)))
 			rc = -EFAULT;
@@ -493,13 +485,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(sm4_gcm_info->iv,
 		       cctx->iv + TLS_CIPHER_SM4_GCM_SALT_SIZE,
 		       TLS_CIPHER_SM4_GCM_IV_SIZE);
 		memcpy(sm4_gcm_info->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_SM4_GCM_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval, sm4_gcm_info, sizeof(*sm4_gcm_info)))
 			rc = -EFAULT;
 		break;
@@ -513,13 +503,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(sm4_ccm_info->iv,
 		       cctx->iv + TLS_CIPHER_SM4_CCM_SALT_SIZE,
 		       TLS_CIPHER_SM4_CCM_IV_SIZE);
 		memcpy(sm4_ccm_info->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_SM4_CCM_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval, sm4_ccm_info, sizeof(*sm4_ccm_info)))
 			rc = -EFAULT;
 		break;
@@ -535,13 +523,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(crypto_info_aria_gcm_128->iv,
 		       cctx->iv + TLS_CIPHER_ARIA_GCM_128_SALT_SIZE,
 		       TLS_CIPHER_ARIA_GCM_128_IV_SIZE);
 		memcpy(crypto_info_aria_gcm_128->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_ARIA_GCM_128_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval,
 				 crypto_info_aria_gcm_128,
 				 sizeof(*crypto_info_aria_gcm_128)))
@@ -559,13 +545,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(crypto_info_aria_gcm_256->iv,
 		       cctx->iv + TLS_CIPHER_ARIA_GCM_256_SALT_SIZE,
 		       TLS_CIPHER_ARIA_GCM_256_IV_SIZE);
 		memcpy(crypto_info_aria_gcm_256->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_ARIA_GCM_256_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval,
 				 crypto_info_aria_gcm_256,
 				 sizeof(*crypto_info_aria_gcm_256)))
@@ -614,11 +598,9 @@ static int do_tls_getsockopt_no_pad(struct sock *sk, char __user *optval,
 	if (len < sizeof(value))
 		return -EINVAL;
 
-	lock_sock(sk);
 	value = -EINVAL;
 	if (ctx->rx_conf == TLS_SW || ctx->rx_conf == TLS_HW)
 		value = ctx->rx_no_pad;
-	release_sock(sk);
 	if (value < 0)
 		return value;
 
@@ -635,6 +617,8 @@ static int do_tls_getsockopt(struct sock *sk, int optname,
 {
 	int rc = 0;
 
+	lock_sock(sk);
+
 	switch (optname) {
 	case TLS_TX:
 	case TLS_RX:
@@ -651,6 +635,9 @@ static int do_tls_getsockopt(struct sock *sk, int optname,
 		rc = -ENOPROTOOPT;
 		break;
 	}
+
+	release_sock(sk);
+
 	return rc;
 }
 
-- 
2.34.1

