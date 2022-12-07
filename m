Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05147645C24
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiLGOM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:12:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiLGOMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:12:48 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859B263EC
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 06:12:45 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id a5-20020a25af05000000b006e450a5e507so19397336ybh.22
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 06:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8Eaz0b8Ne/t46erZUnPI8xk8Al1zhW7z2bfzwuvD1jY=;
        b=WwJxzjqqYg6HHycnbCc816IYY7sNB0rMdITmc8Y0UcJXZcixK+Rou6hc+/d5DS8nw0
         6sLIe7ZhnIjmwnS2oXnjGZ0BO5T7dm5HHLreK5ER+OIzqr9Xeyz3vsmIM7MUh+QpNVNC
         1lDxp+Bpn13Ad6lg8jyEYIJQVXCqTNV5Zt9nHbn5d3eeABeqNVjdd9x+8hW80nMEGbXh
         MKh7a+ptOQilhBJ6e/GXelkiRfi/3am9Zz13qUHJib/+UGzB0LjW9VFLiIWTuPj5PxUc
         d2eW0LRZv5G8RzFiHCf6OEVlkdYHwKvtlALvlzYHlEvl52rpip0aQLj06F+F9KwrjYcL
         13hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Eaz0b8Ne/t46erZUnPI8xk8Al1zhW7z2bfzwuvD1jY=;
        b=O+DrzZ0a3BL8GGxmn7VDMVYi11Dp6pZKGT+vmmWns3O/WqntMgDjTavjlooHUM9/kk
         WVXWrsYrN2Tb9NWkU88FOoneiqlBiKRq6+KuAUjmGDBIg4ZA09/XZSmBeQ5Mz6oVuQgQ
         HTdDrW1lMQ4xHQopxxCX0C0OqQKEtRVzp9LE4OAyx3kjDQH/HYbUBk0APUmWnIWv8u9B
         OxEFIJCJA12oKpEqndzZ8pRHUO6kqo9OqvPLXaOD5gqA3S8EQPqH1XNMbRVXo27mzDGB
         u65VScH+f1M13nVbM79UEhDV/IGluWCV3fZAv2IfjrplLaSNsovcsy+puKDjn4ARksfJ
         /uHQ==
X-Gm-Message-State: ANoB5pnoqKZ6NBWDrj0vbeGItee9QYyDycM0roqZUo1sSC6610d15QQN
        V2M0Pb127cL+09sOP1R8nrYz87l6PDPOrg==
X-Google-Smtp-Source: AA0mqf7oksI4o807wH9li3eh//UygXtCs8Vqu7doXqm2N3k+9Y3LNQEefGBHfF+8WOhCbA7U8iXq6uosnKdeSA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:505:0:b0:6e6:6f6e:95ff with SMTP id
 o5-20020a5b0505000000b006e66f6e95ffmr66411202ybp.582.1670422365018; Wed, 07
 Dec 2022 06:12:45 -0800 (PST)
Date:   Wed,  7 Dec 2022 14:12:37 +0000
In-Reply-To: <20221207141237.2575012-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221207141237.2575012-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221207141237.2575012-4-edumazet@google.com>
Subject: [PATCH v2 net-next 3/3] net/mlx4: small optimization in mlx4_en_xmit()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>
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

Test against MLX4_MAX_DESC_TXBBS only matters if the TX
bounce buffer is going to be used.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Tariq Toukan <tariqt@nvidia.com>
Cc: Wei Wang <weiwan@google.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 8372aeb392a28cf36a454e1b8a4783bc2b2056eb..c5758637b7bed67021a9f3e9c5283033f68639a3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -911,11 +911,6 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* Align descriptor to TXBB size */
 	desc_size = ALIGN(real_size, TXBB_SIZE);
 	nr_txbb = desc_size >> LOG_TXBB_SIZE;
-	if (unlikely(nr_txbb > MLX4_MAX_DESC_TXBBS)) {
-		if (netif_msg_tx_err(priv))
-			en_warn(priv, "Oversized header or SG list\n");
-		goto tx_drop_count;
-	}
 
 	bf_ok = ring->bf_enabled;
 	if (skb_vlan_tag_present(skb)) {
@@ -943,6 +938,11 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (likely(index + nr_txbb <= ring->size))
 		tx_desc = ring->buf + (index << LOG_TXBB_SIZE);
 	else {
+		if (unlikely(nr_txbb > MLX4_MAX_DESC_TXBBS)) {
+			if (netif_msg_tx_err(priv))
+				en_warn(priv, "Oversized header or SG list\n");
+			goto tx_drop_count;
+		}
 		tx_desc = (struct mlx4_en_tx_desc *) ring->bounce_buf;
 		bounce = true;
 		bf_ok = false;
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

