Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 867DE64025
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 06:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbfGJEvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 00:51:09 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37903 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfGJEvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 00:51:09 -0400
Received: by mail-wr1-f66.google.com with SMTP id g17so1008849wrr.5;
        Tue, 09 Jul 2019 21:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VkPnMs3HmAmmFrAKLUEfzR7Ay2skJ2U8keJBE/Qc5gc=;
        b=ZVAM8eQhqUuizwqHSBQuOgH1OkLYxNqvUltyPNUAEGcfAS0dNh8dcKfMi6t5ehqHgX
         Dtjcg2khRwUXnoIe9RKcUCi5PgVfcXDq82k4oIaZXOx2bQfQToucJCoV1V6MoRtth+jw
         XCc0/q3GhF2yP6iVlSyZKH39KFcPuHH2HSqRH25F3InA1PCf5L/J50ZZDJrc/Wz9I1QT
         GgR3DQXaMre1UyLmECjPN8/ySA3M6xKPjvrTDEEW6XPLV7ULIsNC9+5bEufHZ+FVCLWD
         L4t8/ooJWbmNgSQ/J7iUxr81CIXJtycQY/aKLdR9xn6iWptuURv4UbeDcjpNy6/Joisl
         vt4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VkPnMs3HmAmmFrAKLUEfzR7Ay2skJ2U8keJBE/Qc5gc=;
        b=OhuRCttSx61nvNcOzTPH7bE0vv77xewc+RQUruFXJ4dbaORA8CwTleFpOrI0xL54dH
         Ahr1yGI/NS/3AlG8+II7/V5WYPRiRVBh5VXu7Twvwu/DzDp72QBvQoFSDRWTLWsNhTlA
         oJ3MT8kk0Pb5CtMHbXr02UoqrjxQ3Y1cwSZnfQa0XNuVLv03RCCSG+VfAfQ352ydH6F3
         7b5Ub4UaQzVlKTWoIfJwn9nhQ0zSI9tEmbhOLZx9yVT1WtGjSGyUZ3BZ7XmeHbM0v12h
         DrbImFi9kA/1K2QNtDqTvOiQYl+0N+dRDQqqsC57I/JlWrcnV9JU23/eJ1sIxvc2Le36
         PzyQ==
X-Gm-Message-State: APjAAAXKuN6c1KnmwrpZItgET1RXoxVL9UKKUYN8ciMu1044y68NCHo9
        /KwBZvLhzAZTcLTuT2HNg7E=
X-Google-Smtp-Source: APXvYqw9neJXKOJhEamkL4lzRwIS2ZsVUqHUfADty6RTIqN83DdJZbVmvqur2ZWevdiGtP9XpKjQ8g==
X-Received: by 2002:adf:eccd:: with SMTP id s13mr19990585wro.193.1562734266991;
        Tue, 09 Jul 2019 21:51:06 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f8:222:2f1b::2])
        by smtp.gmail.com with ESMTPSA id q193sm762542wme.8.2019.07.09.21.51.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 21:51:05 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Boris Pismenny <borisp@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH v2] net/mlx5e: Refactor switch statements to avoid using uninitialized variables
Date:   Tue,  9 Jul 2019 21:47:49 -0700
Message-Id: <20190710044748.3924-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708231154.89969-1-natechancellor@gmail.com>
References: <20190708231154.89969-1-natechancellor@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang warns:

drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c:251:2:
warning: variable 'rec_seq_sz' is used uninitialized whenever switch
default is taken [-Wsometimes-uninitialized]
        default:
        ^~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c:255:46: note:
uninitialized use occurs here
        skip_static_post = !memcmp(rec_seq, &rn_be, rec_seq_sz);
                                                    ^~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c:239:16: note:
initialize the variable 'rec_seq_sz' to silence this warning
        u16 rec_seq_sz;
                      ^
                       = 0
1 warning generated.

The default case statement should return in tx_post_resync_params like
in fill_static_params_ctx. However, as Nick and Leon point out, the
switch statements converted into if statements to clean up the code a
bit since there is only one cipher supported. Do that to clear up the
code.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Link: https://github.com/ClangBuiltLinux/linux/issues/590
Suggested-by: Leon Romanovsky <leon@kernel.org>
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

v1 -> v2:

* Refactor switch statements into if statements

 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 33 +++++++------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 3f5f4317a22b..ea032f54197e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -25,23 +25,17 @@ static void
 fill_static_params_ctx(void *ctx, struct mlx5e_ktls_offload_context_tx *priv_tx)
 {
 	struct tls_crypto_info *crypto_info = priv_tx->crypto_info;
+	struct tls12_crypto_info_aes_gcm_128 *info;
 	char *initial_rn, *gcm_iv;
 	u16 salt_sz, rec_seq_sz;
 	char *salt, *rec_seq;
 	u8 tls_version;
 
-	switch (crypto_info->cipher_type) {
-	case TLS_CIPHER_AES_GCM_128: {
-		struct tls12_crypto_info_aes_gcm_128 *info =
-			(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
-
-		EXTRACT_INFO_FIELDS;
-		break;
-	}
-	default:
-		WARN_ON(1);
+	if (WARN_ON(crypto_info->cipher_type != TLS_CIPHER_AES_GCM_128))
 		return;
-	}
+
+	info = (struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
+	EXTRACT_INFO_FIELDS;
 
 	gcm_iv      = MLX5_ADDR_OF(tls_static_params, ctx, gcm_iv);
 	initial_rn  = MLX5_ADDR_OF(tls_static_params, ctx, initial_record_number);
@@ -234,23 +228,18 @@ tx_post_resync_params(struct mlx5e_txqsq *sq,
 		      u64 rcd_sn)
 {
 	struct tls_crypto_info *crypto_info = priv_tx->crypto_info;
+	struct tls12_crypto_info_aes_gcm_128 *info;
 	__be64 rn_be = cpu_to_be64(rcd_sn);
 	bool skip_static_post;
 	u16 rec_seq_sz;
 	char *rec_seq;
 
-	switch (crypto_info->cipher_type) {
-	case TLS_CIPHER_AES_GCM_128: {
-		struct tls12_crypto_info_aes_gcm_128 *info =
-			(struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
+	if (WARN_ON(crypto_info->cipher_type != TLS_CIPHER_AES_GCM_128))
+		return;
 
-		rec_seq = info->rec_seq;
-		rec_seq_sz = sizeof(info->rec_seq);
-		break;
-	}
-	default:
-		WARN_ON(1);
-	}
+	info = (struct tls12_crypto_info_aes_gcm_128 *)crypto_info;
+	rec_seq = info->rec_seq;
+	rec_seq_sz = sizeof(info->rec_seq);
 
 	skip_static_post = !memcmp(rec_seq, &rn_be, rec_seq_sz);
 	if (!skip_static_post)
-- 
2.22.0

