Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1CE71BE7A0
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbgD2Tqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726871AbgD2Tql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:46:41 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097D8C03C1AE;
        Wed, 29 Apr 2020 12:46:40 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id u22so1210686plq.12;
        Wed, 29 Apr 2020 12:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CevivX0aGr8AmmZvoR5A9jtsq4aH4kUQzZm/M7FIZ5A=;
        b=OvnLVLo7JsmafyOP56LiVZlXjvz/UCsktk492j7PZzhvCZvqkP/JZcbYJjN4mZdZUw
         5ScQfQzl/6qw9Aj/01sTwpQj3liXvx24C1bvkUvxHXdgNsc/UlwrYFWHkGptq7zxE6A8
         3sO82bsxCimlqD9x3o+vfbayrNh1jUgcZMCFeGfpQtopZqyjqNDL7S5+1GldiE42yS5u
         Sra/CIoRPBm7+lu0JGnYILP0JZy41uMpJcikFJ1OgTW0GNbLyIvKxV7ArCRPu8g1Duf9
         hn3aR2AVUvWXt7g9j7zsVv7nG5ebUiC5Y+cL9SBSSAGib8tA6TtGNo9gtqQJmLGttvhU
         LqBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CevivX0aGr8AmmZvoR5A9jtsq4aH4kUQzZm/M7FIZ5A=;
        b=CUFCi+IcOPFrg+V2w8UQeFeNs0R5cH62tuFLQ+z7HUyBfjBrYWupR093AuziNRloGt
         El8Y8VRi2bkEDF1FYSXkE2/+7hxsuX9tAXHTquSgA+WaTtWVZESnVsx88HDWGw3OnGhk
         EmSMndtQS6UyVqEZgJUFR8c+bWMdFnyC80vTIkgddn/WAlXgn6IYy9j3dmvEMF4Sj41t
         ksKnewVOrrZ9dfc5FSj2ibtE1EXjlfKyWCyP+4QNxZ0Ta0BaEazGbeHH/mEi+IfMBF2T
         cSI/7iIGg/fyKRzGUr8SA+HvLEdDyMUrc18ilsGuBCYYzeJKhBTR4gthpx+u/0Ax44a8
         R/yw==
X-Gm-Message-State: AGi0PuZ90u3cWdG7iNFqtZRXgnQFJYYxE6H0yFAzpRJCwIe3qdKrQAlv
        O/lalK45b/PYfKAj82Qs11uJ2O5w
X-Google-Smtp-Source: APiQypISUd7EZlfcLZvZMvRhh0ePXs1/HnWwKnFI/ESk/kaSRzH78Jo1DyMSqiuAZ21xeOgGiB7E3g==
X-Received: by 2002:a17:90a:e28f:: with SMTP id d15mr52503pjz.79.1588189595828;
        Wed, 29 Apr 2020 12:46:35 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z15sm87956pjt.20.2020.04.29.12.46.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Apr 2020 12:46:35 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next 1/7] net: bcmgenet: set Rx mode before starting netif
Date:   Wed, 29 Apr 2020 12:45:46 -0700
Message-Id: <1588189552-899-2-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588189552-899-1-git-send-email-opendmb@gmail.com>
References: <1588189552-899-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit explicitly calls the bcmgenet_set_rx_mode() function when
the network interface is started. This function is normally called by
ndo_set_rx_mode when the flags are changed, but apparently not when
the driver is suspended and resumed.

This change ensures that address filtering or promiscuous mode are
properly restored by the driver after the MAC may have been reset.

Fixes: b6e978e50444 ("net: bcmgenet: add suspend/resume callbacks")
Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 351d0282f199..eb0dd4d4800c 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -65,6 +65,9 @@
 #define GENET_RDMA_REG_OFF	(priv->hw_params->rdma_offset + \
 				TOTAL_DESC * DMA_DESC_SIZE)
 
+/* Forward declarations */
+static void bcmgenet_set_rx_mode(struct net_device *dev);
+
 static inline void bcmgenet_writel(u32 value, void __iomem *offset)
 {
 	/* MIPS chips strapped for BE will automagically configure the
@@ -2793,6 +2796,7 @@ static void bcmgenet_netif_start(struct net_device *dev)
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 
 	/* Start the network engine */
+	bcmgenet_set_rx_mode(dev);
 	bcmgenet_enable_rx_napi(priv);
 
 	umac_enable_set(priv, CMD_TX_EN | CMD_RX_EN, true);
-- 
2.7.4

