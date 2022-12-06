Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE0D643CCA
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 06:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbiLFFvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 00:51:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbiLFFvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 00:51:08 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8086C1BE86
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 21:51:06 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3b0af5bcbd3so144349637b3.0
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 21:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yhKQ0tJxGEWIlA44fnQ1gEcdOhETqpVQAxs5YblPxEU=;
        b=C+R8/zr0XC8Sy7Xh3BahNx86YGafdgh8REpEe9l/ms9B57Gyyq1zSOprpd2TofRJkL
         AzmV989Z4UxE19kpn/bdRbccoCe1wmIsLIyJpEPWC+oeH433+L6g/Sw++Wu79OlMm3hQ
         IauVWz6vJGv+yFc8IGnTr4/v98iEI5J4n1aalS+Mbk77yGL071p4sK13RLbhEqq9t6gL
         mQadlFXtVEiwFCltwkrmeRkVQTci+cCNaMKl1cO+n/Ff1iCLm3wHuCsux/3ltWK/6ruu
         zrVr154AQ3/RmEC1SUz/ooAEHl5NwvgJnT/iOqECyFRSmuufQ6nQ5oipnUUhnH7dYzVy
         vAXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yhKQ0tJxGEWIlA44fnQ1gEcdOhETqpVQAxs5YblPxEU=;
        b=V+mGESJdQjVkrXwpMztA1bOpNT3Xm9+z3krMHSWpFzi528H4abWGoNmrs+huHKDeUF
         SPNjEkDZfs1izkKk9Xb64xfLuRpY8s54duyRZsFgsrEv3phdsNxoy/Y/m4+NgpptspWP
         jcr+LCr5zPfdxPFuxKYzbhaG1wQOXZNH9zsXlrx9m/o/dl6z2tj7WVM29kJeISksOJ+Y
         cTDhd+99lNCtGbCE3Ij/MrC1tJ/zoG1e1dWfPWOIAqwtVKfQuHtmzp2HBhccvJXpH21K
         1YFfEpul4rIi3SxoXGhY69SH/UtXt7ANAYa/sroGt1GAHx6cIMzAhz4KstfBflkEcV06
         QwvQ==
X-Gm-Message-State: ANoB5pk5HF66tpQWvSwXCy5CGoHzC7qJrttKA9FsAR5yRc9nLW+vWraK
        LvAF1Ci25Dz1cg9ERK/EyZmyJqLrNEMFVQ==
X-Google-Smtp-Source: AA0mqf51PLM8MQo60nNjP5Y2mrOLJjt5pR6z14XA30zMyrTLn0YF55NxjK9OIirbsJ9APJ+LMotu0ZBm4B8g1A==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:29c2:0:b0:6f8:bc8c:445f with SMTP id
 p185-20020a2529c2000000b006f8bc8c445fmr30592262ybp.142.1670305865845; Mon, 05
 Dec 2022 21:51:05 -0800 (PST)
Date:   Tue,  6 Dec 2022 05:50:58 +0000
In-Reply-To: <20221206055059.1877471-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221206055059.1877471-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221206055059.1877471-3-edumazet@google.com>
Subject: [PATCH net-next 2/3] net/mlx4: MLX4_TX_BOUNCE_BUFFER_SIZE depends on MAX_SKB_FRAGS
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Tariq Toukan <tariqt@nvidia.com>, Wei Wang <weiwan@google.com>,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Google production kernel has increased MAX_SKB_FRAGS to 45
for BIG-TCP rollout.

Unfortunately mlx4 TX bounce buffer is not big enough whenever
an skb has up to 45 page fragments.

This can happen often with TCP TX zero copy, as one frag usually
holds 4096 bytes of payload (order-0 page).

Tested:
 Kernel built with MAX_SKB_FRAGS=45
 ip link set dev eth0 gso_max_size 185000
 netperf -t TCP_SENDFILE

I made sure that "ethtool -G eth0 tx 64" was properly working,
ring->full_size being set to 16.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Wei Wang <weiwan@google.com>
Cc: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index 7cc288db2a64f75ffe64882e3c25b90715e68855..120b8c361e91d443f83f100a1afabcabc776a92a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -89,8 +89,18 @@
 #define MLX4_EN_FILTER_HASH_SHIFT 4
 #define MLX4_EN_FILTER_EXPIRY_QUOTA 60
 
-/* Typical TSO descriptor with 16 gather entries is 352 bytes... */
-#define MLX4_TX_BOUNCE_BUFFER_SIZE 512
+#define CTRL_SIZE	sizeof(struct mlx4_wqe_ctrl_seg)
+#define DS_SIZE		sizeof(struct mlx4_wqe_data_seg)
+
+/* Maximal size of the bounce buffer:
+ * 256 bytes for LSO headers.
+ * CTRL_SIZE for control desc.
+ * DS_SIZE if skb->head contains some payload.
+ * MAX_SKB_FRAGS frags.
+ */
+#define MLX4_TX_BOUNCE_BUFFER_SIZE (256 + CTRL_SIZE + DS_SIZE +		\
+				    MAX_SKB_FRAGS * DS_SIZE)
+
 #define MLX4_MAX_DESC_TXBBS	   (MLX4_TX_BOUNCE_BUFFER_SIZE / TXBB_SIZE)
 
 /*
@@ -217,9 +227,7 @@ struct mlx4_en_tx_info {
 
 
 #define MLX4_EN_BIT_DESC_OWN	0x80000000
-#define CTRL_SIZE	sizeof(struct mlx4_wqe_ctrl_seg)
 #define MLX4_EN_MEMTYPE_PAD	0x100
-#define DS_SIZE		sizeof(struct mlx4_wqe_data_seg)
 
 
 struct mlx4_en_tx_desc {
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

