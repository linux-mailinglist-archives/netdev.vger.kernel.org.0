Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A99771B6763
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 01:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgDWXCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 19:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgDWXCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 19:02:23 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93589C09B042;
        Thu, 23 Apr 2020 16:02:23 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id w3so3005430plz.5;
        Thu, 23 Apr 2020 16:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JGxbVqXS9X2h4TzZ1w3vbs2rJWQVdBkMmQST4qkRksg=;
        b=QB23OuqQMqx722WHTzznuVUrIolsO9dALfi+383Bzccmu1nJxbwIBOggZUDILMXS+N
         dEXoeOPBza9ab9k8SLW4sg3Kn90NuM6vCdyStQldd7lOppZHFFZXDOyXWObDbOCtvw+C
         5GuD6oX8WU9R1/M01SbYW0XOPLVNNSC3YgkRKskPH4E7ImcUgHmMcjqM/jidCZ8Fn8Ar
         1qyCaU4U3if/SD7jTjao5ZIYf8hnMdLmjcd4vE6JpDNbmsBKdbrqPmdiYYawLDnDYSPT
         sedKOnBJlS5vvFkcFSBaWHWem3MzFTd5f0zL+PvbtIrhq5V9VXnrW0X0bF1ZN0/DvI2i
         VCEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JGxbVqXS9X2h4TzZ1w3vbs2rJWQVdBkMmQST4qkRksg=;
        b=P/YVYaH6iDvfUUC0xaW5Xo7Xe0vGrhA8kTs2Nmr13SedC4S/zT4bn3MBtupYIYBznx
         VC7qpzgwaCMQnfkl23hc6e7NO8H9mMjAD4UxD+XdB0Dy32KfXjS50UZyolyBdefCzZlO
         s2jVqsckGS96rZXqbILMRsuFUTxjc6GqwLpd2feVu64uK5wyX2pA85SSN7IFFiUXDLZl
         e7cMU9VgrKt8G8ZGhJN/6Hv8Re+se16FTVR+dSm/4a8pfkxf/U0f8ejTDvPCUkXTwVqS
         q1RDjS1PSXTZIuG438R8LsKsu9QkeiSJmi0NzNDaXgol5TFnYQt0dME4NDKPxiqOqSEZ
         hZfw==
X-Gm-Message-State: AGi0PuZnsPyvfIMhrWgmu+xpuwRfGG3UWC1ewW4VnW13gbi6NdSr2/Lw
        hp37Nb4JUN5pYguArS4ypiy1rkye
X-Google-Smtp-Source: APiQypJhiUK0tBdIYE7QpIVyEspwQeujaLucNyMDRNmEKpsyp38chkp9Ou/0s42zk5XZeDspJI14dA==
X-Received: by 2002:a17:902:8e8b:: with SMTP id bg11mr5783024plb.139.1587682943072;
        Thu, 23 Apr 2020 16:02:23 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p8sm3419414pjd.10.2020.04.23.16.02.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 16:02:21 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next] net: bcmgenet: suppress warnings on failed Rx SKB allocations
Date:   Thu, 23 Apr 2020 16:02:11 -0700
Message-Id: <1587682931-38636-1-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver is designed to drop Rx packets and reclaim the buffers
when an allocation fails, and the network interface needs to safely
handle this packet loss. Therefore, an allocation failure of Rx
SKBs is relatively benign.

However, the output of the warning message occurs with a high
scheduling priority that can cause excessive jitter/latency for
other high priority processing.

This commit suppresses the warning messages to prevent scheduling
problems while retaining the failure count in the statistics of
the network interface.

Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 20aba79becce..bfeff5585f4b 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1617,7 +1617,8 @@ static struct sk_buff *bcmgenet_rx_refill(struct bcmgenet_priv *priv,
 	dma_addr_t mapping;
 
 	/* Allocate a new Rx skb */
-	skb = netdev_alloc_skb(priv->dev, priv->rx_buf_len + SKB_ALIGNMENT);
+	skb = __netdev_alloc_skb(priv->dev, priv->rx_buf_len + SKB_ALIGNMENT,
+				 GFP_ATOMIC | __GFP_NOWARN);
 	if (!skb) {
 		priv->mib.alloc_rx_buff_failed++;
 		netif_err(priv, rx_err, priv->dev,
-- 
2.7.4

