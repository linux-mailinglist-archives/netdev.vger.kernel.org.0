Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E53643CCB
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 06:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233169AbiLFFvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 00:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbiLFFvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 00:51:09 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699B724F28
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 21:51:08 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3b4eb124be5so145253487b3.19
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 21:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8Eaz0b8Ne/t46erZUnPI8xk8Al1zhW7z2bfzwuvD1jY=;
        b=KhjtyohXRm4vmy41VKIyr/YjitqwVUnmF3QosxPzbadppjUKBHMKCYhXZxy6USf9Ey
         miAu1W+4JI+hCa9FEbcapNo7Y9NI4scRQppi/bT+5iyzfGtpRTVW03SWvKLiI7gsB83S
         wBAGt2Ba9iZQ5BXyaBXlszKAR4R8IG4qJCCLqHnSt5M3SaEy1xSfJGuqQdXD7snLuBMA
         SW6ggdHbIyjfev6E29Q4Drv7NoWnaTWvVkdYCHtLJF5jsR1pQQcmwnr8S44R/IqieO5X
         3nI6CcFKDVfgh9eBlcJtAbGMNGSv7+PqWhaMZDHPH6WMNlMW2wJiFRFJRRBDKaOwPrsH
         5zMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Eaz0b8Ne/t46erZUnPI8xk8Al1zhW7z2bfzwuvD1jY=;
        b=GIWUwMTYesOurL7frrxvvcHe4+3qERgY1V/6y36B4yekmIaVSelAltHYfkfhRXKeFs
         6mZjohawCdyH1316L4lE1oa0m1Eib0q/BWdRnn6yvNq23QVtFUFRG+nI2ZNhyQ3l6/rZ
         ad29pgGwx68FU6Hgza3vwzjTT1akwQtpdsNfWUDE4xCzJBQHN56QnUVY+4VMf3mqX05+
         SJDvOCuXfmITiQkpUev+3PyVkkZuXaJLiWQSc7sZeJbWVmR6XydF99cQ5YpWJxIoy4JT
         FwnRv6WhAwcCfZ+J1EHst1Pvzbau1H481jZuwqCz2opNU3Een3JHie0IW0Bp4gkk8w0L
         Tbcw==
X-Gm-Message-State: ANoB5pna4ijfvkjSCSDCCLFUXLCKFzS8XQgfGQXx0WxCDmQNfoD+5S1c
        NTDtzJlPv14GYymwZIaSjgWo1qzbWCvnSg==
X-Google-Smtp-Source: AA0mqf5I+gsHsK4CnZpBBmKOljcn2UeG7pPHmJc7knAZeFZkV2nqe28vANEQ4IWC1ujh+/crozJj3ZAPMSDTrg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:c6c2:0:b0:6f0:b351:c300 with SMTP id
 k185-20020a25c6c2000000b006f0b351c300mr54518270ybf.102.1670305867764; Mon, 05
 Dec 2022 21:51:07 -0800 (PST)
Date:   Tue,  6 Dec 2022 05:50:59 +0000
In-Reply-To: <20221206055059.1877471-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221206055059.1877471-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221206055059.1877471-4-edumazet@google.com>
Subject: [PATCH net-next 3/3] net/mlx4: small optimization in mlx4_en_xmit()
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

