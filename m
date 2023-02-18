Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED4C69BB6D
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 19:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjBRSi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 13:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjBRSi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 13:38:56 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0FA12BE3
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 10:38:54 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id p15so502108pgm.1
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 10:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iTKepua2kscIuNx6W8BDWIkKKvbZQVVeOdAhbCfO3SE=;
        b=Qr1HSZdE5f37YaHkVPA3tyWNxnLYtwoHRGIrYCxG0ZpB9c/gk2gOp4/kWGR2xhedzD
         o3h/1htLKKVe6YmdGl9eXPNgzXTr6WsV9jYr4L6koLUCC3TpOmTYQwYhfGrQB5dZmN+J
         S/cmEbce17loFmkRuhZSKRwSV44Kee71UcC54=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iTKepua2kscIuNx6W8BDWIkKKvbZQVVeOdAhbCfO3SE=;
        b=CTJxcbI6n4a4fm26c7dEsRRJrFQDVVEltoleQQvx0kJtZR9/szIueYFWAKq5hV1Adj
         9h5McUliSZPURGPmaRuUjEoUHpB+vIr+Yf+aUU0Bbj4cnBRExJbGeM9zhLzp6f2pecBD
         +7q7jF2vJo79fIeRLPgLXIrjPbPoo1cEC/LnBbnK/Ytm/9/jXEuifA4p1gK3fUhWpzsD
         4Yl0hHkhEL2VtHkPpg3eopFcIyM8ccULY6jfs9up2F2lmwckTsH4fIEC01F5F3L2h8p3
         AfzXf7SDFqzw9oN5p2bG/DK8QGtKI9F04cd9TPNjYKPt4ff1hbarBw6mWgbw8KR6WL7M
         MQnw==
X-Gm-Message-State: AO0yUKX7AZiw631fsiaHqKJkZMdWu6wYO5Kym4Z49ebhzbbn997ZOcWN
        tpH0LJ8mvbyIXGUZ65O2dcC1Mw==
X-Google-Smtp-Source: AK7set+Gcx6ssrL1CUCt4P4+IZA7KQVyN/WF/pbSuKZGBRUq406XL4EeLCrbyHjWeAeUhK45htmQXg==
X-Received: by 2002:a62:1753:0:b0:5a8:d364:62ab with SMTP id 80-20020a621753000000b005a8d36462abmr4793539pfx.17.1676745534045;
        Sat, 18 Feb 2023 10:38:54 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id h5-20020a62b405000000b005ae8e94b0d5sm1402624pfn.107.2023.02.18.10.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Feb 2023 10:38:53 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Josef Oskera <joskera@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] net/mlx4_en: Introduce flexible array to silence overflow warning
Date:   Sat, 18 Feb 2023 10:38:50 -0800
Message-Id: <20230218183842.never.954-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=4923; h=from:subject:message-id; bh=L+7mU/t7sXYwZ0oG57R81et2rDvNWl61qF2TMIxSz1g=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBj8Rs6xlqKlp/Ege1Wry6d43MG23RfmhUBBkucpD8j FHxqogeJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY/EbOgAKCRCJcvTf3G3AJk/bD/ 4zEc1/cSH6OhQfMpSJnszACML9ZMpDTAHpqhLxshfcauGOHxH8Mbbny9Hfk1GbiSs3VNuiLLibJ9Ea MNQMf03saSs6SUHdtpKnjT9pBQe0Mn346nS1bH7/JCPjFDgmG/0sgf7eEN/v8Idpbj7bji81Jnguae jSUGZbNky0J43bqynylqQ4z/GOrYx/RWtyTRPQw7MKc+sHM+rYELvYs33Z8c/19OZpFzs5BfJXnPaB pHgNkYlYc1mYktPxe8SYFw4c3kadZ3cwx8WohmAffJ1gcTSipH2xA0Qcz11+ij1m2kbfQPw2NzJXt3 cOvOHe4CVgwLR4s0OxyRf6L9A+eDqsuzMJFPbxJcokgaJV580FBIQxz8Al8AGV4kvDVD5KbxgXmgui 8lMrCSq704uA4vzlZRc1rizoAb72tZlVSBnvkbLgYHp20p3Q/9oLuMEzu3rUKFf4koq23WKlSsdrQ+ XwTxMuY9mRzwKSn+ja0wgoNsiP7vBGEx7ZGmVLnfJqodpRJ8T8qlW4FtvWLPoGylzWu5OhbUgNWVIT ZZTgGovPPx19taMVvE/LNSlf/IhL45K5IpQT3nUvouQ97ikCHni/2VJ2zm60Fg7PPD6OxkdzLoJORP TqLU9ifrO+z7nnoT31HBKCmgw7hnlnETPzunGXGBsOZC120Z4xIudTk/A3mA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The call "skb_copy_from_linear_data(skb, inl + 1, spc)" triggers a FORTIFY
memcpy() warning on ppc64 platform:

In function ‘fortify_memcpy_chk’,
    inlined from ‘skb_copy_from_linear_data’ at ./include/linux/skbuff.h:4029:2,
    inlined from ‘build_inline_wqe’ at drivers/net/ethernet/mellanox/mlx4/en_tx.c:722:4,
    inlined from ‘mlx4_en_xmit’ at drivers/net/ethernet/mellanox/mlx4/en_tx.c:1066:3:
./include/linux/fortify-string.h:513:25: error: call to ‘__write_overflow_field’ declared with
attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()?
[-Werror=attribute-warning]
  513 |                         __write_overflow_field(p_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Same behaviour on x86 you can get if you use "__always_inline" instead of
"inline" for skb_copy_from_linear_data() in skbuff.h

The call here copies data into inlined tx destricptor, which has 104
bytes (MAX_INLINE) space for data payload. In this case "spc" is known
in compile-time but the destination is used with hidden knowledge
(real structure of destination is different from that the compiler
can see). That cause the fortify warning because compiler can check
bounds, but the real bounds are different.  "spc" can't be bigger than
64 bytes (MLX4_INLINE_ALIGN), so the data can always fit into inlined
tx descriptor. The fact that "inl" points into inlined tx descriptor is
determined earlier in mlx4_en_xmit().

Avoid confusing the compiler with "inl + 1" constructions to get to past
the inl header by introducing a flexible array "data" to the struct so
that the compiler can see that we are not dealing with an array of inl
structs, but rather, arbitrary data following the structure. There are
no changes to the structure layout reported by pahole, and the resulting
machine code is actually smaller.

Reported-by: Josef Oskera <joskera@redhat.com>
Link: https://lore.kernel.org/lkml/20230217094541.2362873-1-joskera@redhat.com
Fixes: f68f2ff91512 ("fortify: Detect struct member overflows in memcpy() at compile-time")
Cc: Tariq Toukan <tariqt@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Yishai Hadas <yishaih@nvidia.com>
Cc: netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c | 22 +++++++++++-----------
 include/linux/mlx4/qp.h                    |  1 +
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index c5758637b7be..2f79378fbf6e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -699,32 +699,32 @@ static void build_inline_wqe(struct mlx4_en_tx_desc *tx_desc,
 			inl->byte_count = cpu_to_be32(1 << 31 | skb->len);
 		} else {
 			inl->byte_count = cpu_to_be32(1 << 31 | MIN_PKT_LEN);
-			memset(((void *)(inl + 1)) + skb->len, 0,
+			memset(inl->data + skb->len, 0,
 			       MIN_PKT_LEN - skb->len);
 		}
-		skb_copy_from_linear_data(skb, inl + 1, hlen);
+		skb_copy_from_linear_data(skb, inl->data, hlen);
 		if (shinfo->nr_frags)
-			memcpy(((void *)(inl + 1)) + hlen, fragptr,
+			memcpy(inl->data + hlen, fragptr,
 			       skb_frag_size(&shinfo->frags[0]));
 
 	} else {
 		inl->byte_count = cpu_to_be32(1 << 31 | spc);
 		if (hlen <= spc) {
-			skb_copy_from_linear_data(skb, inl + 1, hlen);
+			skb_copy_from_linear_data(skb, inl->data, hlen);
 			if (hlen < spc) {
-				memcpy(((void *)(inl + 1)) + hlen,
+				memcpy(inl->data + hlen,
 				       fragptr, spc - hlen);
 				fragptr +=  spc - hlen;
 			}
-			inl = (void *) (inl + 1) + spc;
-			memcpy(((void *)(inl + 1)), fragptr, skb->len - spc);
+			inl = (void *)inl->data + spc;
+			memcpy(inl->data, fragptr, skb->len - spc);
 		} else {
-			skb_copy_from_linear_data(skb, inl + 1, spc);
-			inl = (void *) (inl + 1) + spc;
-			skb_copy_from_linear_data_offset(skb, spc, inl + 1,
+			skb_copy_from_linear_data(skb, inl->data, spc);
+			inl = (void *)inl->data + spc;
+			skb_copy_from_linear_data_offset(skb, spc, inl->data,
 							 hlen - spc);
 			if (shinfo->nr_frags)
-				memcpy(((void *)(inl + 1)) + hlen - spc,
+				memcpy(inl->data + hlen - spc,
 				       fragptr,
 				       skb_frag_size(&shinfo->frags[0]));
 		}
diff --git a/include/linux/mlx4/qp.h b/include/linux/mlx4/qp.h
index c78b90f2e9a1..b9a7b1319f5d 100644
--- a/include/linux/mlx4/qp.h
+++ b/include/linux/mlx4/qp.h
@@ -446,6 +446,7 @@ enum {
 
 struct mlx4_wqe_inline_seg {
 	__be32			byte_count;
+	__u8			data[];
 };
 
 enum mlx4_update_qp_attr {
-- 
2.34.1

