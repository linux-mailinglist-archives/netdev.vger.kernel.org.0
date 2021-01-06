Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779052EBFC3
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 15:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbhAFOoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 09:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbhAFOob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 09:44:31 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6234CC06134D;
        Wed,  6 Jan 2021 06:43:27 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id m6so1824706pfm.6;
        Wed, 06 Jan 2021 06:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vZbmDTb0LxwuuPGyUB5ba2z6ziLQcYOI0K/25hO2Dx0=;
        b=TMMOJGKDAEV2jGJkqOX+5Rt1Zi+fJkf/XKL7dYcMgkDy9ZFH+5JoGHKmqdej30REEv
         7gcogGi33Cq2mYRFJowHB2lNDtzi6AbyPuvdWr1I8ToBfZ2Pu0hmbMMt123YY1l1tSGe
         d6P7HCiYRXtQx2NJ4YBsElIxTGMgAWe/aXwNx8+723/XJMjiIyFcoZzl/bkEamqugp8O
         P1h+bK2g5uujntQpHMjdBDI/wC+u9mAdgGRo5gscPbxnscfQp/3esjDmoOtbqRvBuO4b
         R+zmoIqKH5oeqZbXx0F3cfM4lIlGQfmh28HoZnArDWrGIupKwQCPeaAa25e1UtLnbWtO
         8zwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vZbmDTb0LxwuuPGyUB5ba2z6ziLQcYOI0K/25hO2Dx0=;
        b=iaX8ja7WDaDsloWqNFb+5dMyUENnMUUfv62UhUUhiI+SNrqia5HOhgipA1HdXkC/Gz
         dIwn1LMUitSwaQa92Yr0qb19rhLZBX6y5cdo3xEwBmq467ElO1TWqGeZN5b+WIiXNDrQ
         fB24uU5AMuV72ocibTVt9q8+EQCNEATlyRH/+oDpDOkPA40T05Kt8DSg8IjxgKNokkmf
         NwXtqSIw2FDbRYihIW48asutFvyABuXQD16qafyDFtopIsbMqbJhh59eTY5U8PKBWB6F
         pviXwtJ8scQcdd5m1Hi+Z8Zsa3RCkap+YzbHA7n17CpU4EuzYKnCWZuP0AeTCe+9ivFk
         5FQQ==
X-Gm-Message-State: AOAM530xKKo6BSCrAcIDvXXxpspoFdiCA/wg/3BX8IiyLxOt2gZDBOL8
        pT5woPJtGmQVIbQo4PVtZMM7bXMVzOk=
X-Google-Smtp-Source: ABdhPJxEchh+BCJzCpA0Qbvipmo23B3PLsu7S5X1UJRT/vlffhz3vdgqLGZKUJwZAIotOpcUp1qfgw==
X-Received: by 2002:aa7:81d6:0:b029:19e:2987:7465 with SMTP id c22-20020aa781d60000b029019e29877465mr4204058pfn.29.1609944206977;
        Wed, 06 Jan 2021 06:43:26 -0800 (PST)
Received: from DESKTOP-8REGVGF.localdomain ([124.13.157.5])
        by smtp.gmail.com with ESMTPSA id h8sm3076774pjc.2.2021.01.06.06.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 06:43:26 -0800 (PST)
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 7/7] bcm63xx_enet: improve rx loop
Date:   Wed,  6 Jan 2021 22:42:08 +0800
Message-Id: <20210106144208.1935-8-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210106144208.1935-1-liew.s.piaw@gmail.com>
References: <20210106144208.1935-1-liew.s.piaw@gmail.com>
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
index c11491429ed2..fd8767213165 100644
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

