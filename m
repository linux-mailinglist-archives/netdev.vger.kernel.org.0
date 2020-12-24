Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675672E27AC
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 15:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbgLXO0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 09:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbgLXO0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 09:26:51 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA302C061285;
        Thu, 24 Dec 2020 06:26:11 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id i5so1660082pgo.1;
        Thu, 24 Dec 2020 06:26:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wInGYZW902haXHZAS7+jdP03lOS8ZfWDpKlc2Tn45Ao=;
        b=I8xmwus3SEPujM74SNuswxSxEoRpFhK/jDLHHWMqFyaaPztpMTc6zTfp4STG9OgEXm
         ZeuQd2oHIT07bwKHbcSnXWMa8M5g5sGAgI0uHglVNZxxNGsT5uESubAPgw4AaV+ErZ8r
         A7lni0GJ14LppPWthKkUC6dZoWzkOjxCPHnFz8/XoqdvzNQSxTpVItUWEpnswRoiIVxJ
         ZP/OaQopViNQEpElfxWPvjjRwGsYhkaNlb1TcO0UzePJVdSRnJrr3D0H33T5PflQLIvE
         seYKXOYTiWFs6/cI8J6TxYmqGMM82hkTUZmm4u5I5sn/HiK2vfvlr1F2mAY54nkS5XLY
         aS0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wInGYZW902haXHZAS7+jdP03lOS8ZfWDpKlc2Tn45Ao=;
        b=NfkjK0lz0ZamYJr3Ijz1NXp9uibsWlFN8NR3t0JOTN9ZX3xRFOBMnR06BrjRxDoi8y
         SqDLFWhQ/7u//LTG+BbQ9ZiQRJwy/zfb+bF7HS3xZN3S83QYSWHjEJ64XcVDnxivNGfO
         CwH8zyP+CjmbBWUiTCPliSJicOBbERhaS0WWPhIHoGzmjynvqEFNlOu7yMooLKRZWW2S
         Xrwysb94V2zvygPi21XddCShPCsFuNtmdnfbYVYWrS9US6LmvXbzUGXS8MiWJfXAFaVx
         B7Q965GidcbHRonfHBVa9+08noahGbY1hSTYz/J5B4Ey5l7iVnvPjmUCJn0Lyt/j4FA2
         zPzg==
X-Gm-Message-State: AOAM533VYjlHHe8vwfJ9O3zx+xpDt169Lh4Uq8qsj2OLOheF4OgvLOtQ
        3VmipWjmHEIm4c7MSBbOs98=
X-Google-Smtp-Source: ABdhPJzfgac7PKJRU95xB5cjnCwfgXMEfr4mk9P5ourOpELETk3+5iGbIKQVB3Bu1c63G6QeFBhnfw==
X-Received: by 2002:a62:2cc:0:b029:1a8:4d9b:8e8d with SMTP id 195-20020a6202cc0000b02901a84d9b8e8dmr5655649pfc.8.1608819971314;
        Thu, 24 Dec 2020 06:26:11 -0800 (PST)
Received: from DESKTOP-8REGVGF.localdomain ([124.13.157.5])
        by smtp.gmail.com with ESMTPSA id r185sm26936351pfc.53.2020.12.24.06.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Dec 2020 06:26:10 -0800 (PST)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 6/6] bcm63xx_enet: improve rx loop
Date:   Thu, 24 Dec 2020 22:24:21 +0800
Message-Id: <20201224142421.32350-7-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201224142421.32350-1-liew.s.piaw@gmail.com>
References: <20201224142421.32350-1-liew.s.piaw@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use existing rx processed count to track against budget, thereby making
budget decrement operation redundant.

rx_desc_count can be calculated outside the rx loop, making the loop a
bit smaller.

Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
---
 drivers/net/ethernet/broadcom/bcm63xx_enet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
index 8c2e97311a2c..5ff0d39be2b2 100644
--- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
@@ -339,7 +339,6 @@ static int bcm_enet_receive_queue(struct net_device *dev, int budget)
 		priv->rx_curr_desc++;
 		if (priv->rx_curr_desc == priv->rx_ring_size)
 			priv->rx_curr_desc = 0;
-		priv->rx_desc_count--;
 
 		/* if the packet does not have start of packet _and_
 		 * end of packet flag set, then just recycle it */
@@ -404,9 +403,10 @@ static int bcm_enet_receive_queue(struct net_device *dev, int budget)
 		dev->stats.rx_bytes += len;
 		list_add_tail(&skb->list, &rx_list);
 
-	} while (--budget > 0);
+	} while (processed < budget);
 
 	netif_receive_skb_list(&rx_list);
+	priv->rx_desc_count -= processed;
 
 	if (processed || !priv->rx_desc_count) {
 		bcm_enet_refill_rx(dev, true);
-- 
2.17.1

