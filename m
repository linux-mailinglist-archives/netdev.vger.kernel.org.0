Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2DA4ACDB3
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 02:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343520AbiBHBGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 20:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241985AbiBHAtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 19:49:00 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2755BC061355
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 16:49:00 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id t4-20020a17090a510400b001b8c4a6cd5dso989475pjh.5
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 16:49:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Es5eothVtg4+JU6ZY8H8xvFk8eWtTIOnkarfBU4qpDM=;
        b=Ew03kcAcLY3QqTT/FscPfzyV64MiTcCJkBfuyen5iC+xT/gqvTbIuA7aYbaGO6f8uC
         ItAWDsPPkohcFAIYe/S1X/pu1KA+8vSPeVIjbwvTPJ4u8ZJpvPki3mV6bwq6ft/ZWqQP
         PngnF9Hq/y123KV7xAa62zJyrhuabCSkpSQWgUOxSg1mRpepKFlTySocc+hGwGN6dItV
         o3RYyR4yqihJpGHw/lLGV92+yRrzlymfSqR5UEpeR7EOqpp2pizUgRomhKU4qrQtCu/i
         46No5F44PRB8V4DVRif1gqJo2iQMyR98J+TWKbbKzCWuJ9ic9MlE72uZOhlc49xascn9
         ufgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Es5eothVtg4+JU6ZY8H8xvFk8eWtTIOnkarfBU4qpDM=;
        b=NAEX2imfi4b2c5t4L3Xf43qxGhTG/mt12c5d2YP3ubkVNvz2dSiheh3dr/6WjENxA6
         PeLUPH3rIsWceytZpNORQxlKnZf+eORO2/4qKKHsi8X/LwcpYzBu299VGbh3P2p6hg7t
         GyIE0v3XGvyVllKaJiAT/6mtPtmi/VH+zKA9tL3nZcebMXqjBxcG7soRNTq2E+U+DW5z
         /BSqYsjN6ciF0pKqwSNmHmUCD2XAl/HlpZvV+VLAJgSrR9bB7Nob1WHaFZnrh1BVW4B+
         iUolF+8vAsynsv6pO023YCV6Y8TjECPMfNqMge2MYwBMNa5neoFBRi5xGkjFU0Mb1FhR
         H2CA==
X-Gm-Message-State: AOAM5337x+v9J1GJD8vV9lmFSyqutcFEazhV50Z9tIVkTzzOAt5Mxxex
        sy01tXBR3LiQn5jyZbfqQ6w=
X-Google-Smtp-Source: ABdhPJxzig+9yYq57rq75zQeSDRtW2qrARvkGgAvf/vgFaNNBID5NYz9qUWrptVx67k+RtJ2AgAtHg==
X-Received: by 2002:a17:902:714a:: with SMTP id u10mr2294843plm.21.1644281339617;
        Mon, 07 Feb 2022 16:48:59 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8f56:515b:a442:2bd5])
        by smtp.gmail.com with ESMTPSA id p17sm13443490pfh.59.2022.02.07.16.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 16:48:59 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] et131x: support arbitrary MAX_SKB_FRAGS
Date:   Mon,  7 Feb 2022 16:48:55 -0800
Message-Id: <20220208004855.1887345-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
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

From: Eric Dumazet <edumazet@google.com>

This NIC does not support TSO, it is very unlikely it would
have to send packets with many fragments.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/ethernet/agere/et131x.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/agere/et131x.c b/drivers/net/ethernet/agere/et131x.c
index 537e6a85e18da7f42bb6ff6d4efe3dbdaf0248d4..fbf4588994ac55c5799bf7c375368144fba8d46a 100644
--- a/drivers/net/ethernet/agere/et131x.c
+++ b/drivers/net/ethernet/agere/et131x.c
@@ -2413,11 +2413,13 @@ static void et131x_tx_dma_memory_free(struct et131x_adapter *adapter)
 	kfree(tx_ring->tcb_ring);
 }
 
+#define MAX_TX_DESC_PER_PKT 24
+
 /* nic_send_packet - NIC specific send handler for version B silicon. */
 static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 {
 	u32 i;
-	struct tx_desc desc[24];
+	struct tx_desc desc[MAX_TX_DESC_PER_PKT];
 	u32 frag = 0;
 	u32 thiscopy, remainder;
 	struct sk_buff *skb = tcb->skb;
@@ -2432,9 +2434,6 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 	 * more than 5 fragments.
 	 */
 
-	/* nr_frags should be no more than 18. */
-	BUILD_BUG_ON(MAX_SKB_FRAGS + 1 > 23);
-
 	memset(desc, 0, sizeof(struct tx_desc) * (nr_frags + 1));
 
 	for (i = 0; i < nr_frags; i++) {
@@ -3762,6 +3761,13 @@ static netdev_tx_t et131x_tx(struct sk_buff *skb, struct net_device *netdev)
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 	struct tx_ring *tx_ring = &adapter->tx_ring;
 
+	/* This driver does not support TSO, it is very unlikely
+	 * this condition is true.
+	 */
+	if (unlikely(skb_shinfo(skb)->nr_frags > MAX_TX_DESC_PER_PKT - 2)) {
+		if (skb_linearize(skb))
+			goto drop_err;
+	}
 	/* stop the queue if it's getting full */
 	if (tx_ring->used >= NUM_TCB - 1 && !netif_queue_stopped(netdev))
 		netif_stop_queue(netdev);
-- 
2.35.0.263.gb82422642f-goog

