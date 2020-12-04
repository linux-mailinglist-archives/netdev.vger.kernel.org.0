Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467612CE7CC
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 06:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbgLDFs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 00:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgLDFs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 00:48:56 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E5AC061A52
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 21:48:15 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id s21so2933969pfu.13
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 21:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1jYNLvaZPXWnnMKmqFijAtk3wCJypCnIEErPxeILOoQ=;
        b=sIi27tgXDmYKeF/ZT5dn9XiqPIm04UB3gN/owMLmxQ9Y+FDQfv+TSUVdAWbF8gypXG
         4QGMQ4Zl87D1BH/1UqDTONk8lBHMmeVfsOnH588H0NNRT4eO/IHxIMmJ/yG5M5WAkIoY
         UzYJB1IE31yRgt/Lj7LSwCD3ANvF0fJRG0FwuvdrptshcDiHIruI6FO5q4iVZMWKTBiO
         Mxe0HQAitt8Ooxcrjt4xG4GT93JNXT1I2V/w0qZBWUvH4xuTTH2Cl09crFmiVWuBCuXh
         T6eAwujsBs9QGTTkCOgeQW8rOba93yaA2x+js9zDY+15wzTixKJBde1F5+cdvoST4/X7
         gGGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1jYNLvaZPXWnnMKmqFijAtk3wCJypCnIEErPxeILOoQ=;
        b=Qdqqz+OlFkCmWdvc1EK9HDFeMDdwNOkPF1fbNYld6xhu5nARtvpf+2IHz6+s8DO7kK
         3JHbT+9gaHj4za3fgrX+x37bMRfFCZ2RqmMEcoUO1vJaQUy2ADc1MPHS1dBsiyAcGbgj
         IhP4nf7opssGhRTJpQPhCt5Zw9ZYxmKcdCqr5SnXBfwudTZ38uZPRdl4JMjpseeEtAQg
         nX7M+IdaTYYerQ1ikbnuIsORzHtVo8ZBhr2LJj3/GiXb6E4760jYkJonClYrTRAL+KwH
         VrqhybPvboG9LvEzkmtf4+I5sFPca2p2/FguJzVst6zfAD27WWUTb/kmDO0LwoPtNOqt
         tTiQ==
X-Gm-Message-State: AOAM533wxdvZo5vTGOvaGHtoOiaBrNemumOrZKD/wXlcFkNBW3kDoA3G
        t2c/p6fjMv2b/b9meSmOYbM=
X-Google-Smtp-Source: ABdhPJxQOr/Pnder1nHDw+on8KWEGcIGKYR9EiBqZf+cBa8v5mCTiDeL2Te4XWsYX8ezZly83TM0nA==
X-Received: by 2002:a62:8388:0:b029:19b:816e:9cca with SMTP id h130-20020a6283880000b029019b816e9ccamr2522504pfe.31.1607060894536;
        Thu, 03 Dec 2020 21:48:14 -0800 (PST)
Received: from DESKTOP-8REGVGF.localdomain ([211.25.125.254])
        by smtp.gmail.com with ESMTPSA id u205sm3542134pfc.146.2020.12.03.21.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 21:48:14 -0800 (PST)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next] bcm63xx_enet: batch process rx path
Date:   Fri,  4 Dec 2020 13:46:13 +0800
Message-Id: <20201204054616.26876-1-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netif_receive_skb_list to batch process rx skb.
Tested on BCM6328 320 MHz using iperf3 -M 512, increasing performance
by 12.5%.

Before:
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-30.00  sec   120 MBytes  33.7 Mbits/sec  277         sender
[  4]   0.00-30.00  sec   120 MBytes  33.5 Mbits/sec            receiver

After:
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-30.00  sec   136 MBytes  37.9 Mbits/sec  203         sender
[  4]   0.00-30.00  sec   135 MBytes  37.7 Mbits/sec            receiver

Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index 916824cca3fd..b82b7805c36a 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -297,10 +297,12 @@ static void bcm_enet_refill_rx_timer(struct timer_list *t)
 static int bcm_enet_receive_queue(struct net_device *dev, int budget)
 {
 	struct bcm_enet_priv *priv;
+	struct list_head rx_list;
 	struct device *kdev;
 	int processed;
 
 	priv = netdev_priv(dev);
+	INIT_LIST_HEAD(&rx_list);
 	kdev = &priv->pdev->dev;
 	processed = 0;
 
@@ -391,10 +393,12 @@ static int bcm_enet_receive_queue(struct net_device *dev, int budget)
 		skb->protocol = eth_type_trans(skb, dev);
 		dev->stats.rx_packets++;
 		dev->stats.rx_bytes += len;
-		netif_receive_skb(skb);
+		list_add_tail(&skb->list, &rx_list);
 
 	} while (--budget > 0);
 
+	netif_receive_skb_list(&rx_list);
+
 	if (processed || !priv->rx_desc_count) {
 		bcm_enet_refill_rx(dev);
 
-- 
2.17.1

