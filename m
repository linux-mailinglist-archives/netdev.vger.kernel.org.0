Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7722D0075
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 05:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgLFEPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 23:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbgLFEPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 23:15:09 -0500
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8438CC0613D4;
        Sat,  5 Dec 2020 20:14:29 -0800 (PST)
Received: by mail-qt1-x841.google.com with SMTP id a6so4686644qtw.6;
        Sat, 05 Dec 2020 20:14:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ao+xFb0yC7DiD3o1YFIVKpIIu1IkYoSj63p4lHpWOH0=;
        b=VNs/msRIjF+trubJiGmRCg2tSUbvPM6srfhbduYLLe/3dfmeiRGRMqUGgBtMxgAsAo
         G1pyrA4UiSy1iAvmciDlr4uwtX1ruKYxlOzHMEQ4h6L3mcIvaZwBq8Z/44Y/u7jZhv/i
         xGoNNZI12CddIUZ4vYOqIFLst1beD7gBu9MRkPlQabZVWdCtnqaqlu+ONRNnzV/8rZ5i
         ssOyBW6zxT1piWBqIsGOZuc1VaqL055/Kco9Bjs+xMAIn01+uQSl8z3YklF8KRAuEdlo
         zcm0cja/R52kSMMEJUuD6vQeNFbFTxQrVkt+M4kWtKaVPhCapmbE4XsEvbo7hd6N70+x
         Ze3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ao+xFb0yC7DiD3o1YFIVKpIIu1IkYoSj63p4lHpWOH0=;
        b=QBa/q88j+wNt1so0PuCs9oGewH5tCFexi9a7ySEeQeT1C1RdUWHurh2Fa2JSwj84u2
         INwb+aiBcI8tGqRree4ZPlmirAdkhlA3l3FLX/tdhItT9dszaVgFhKOLaVob3GXEML84
         w7R2Kd4wd6F64cfz3WUPXovr4mktO7cw3oHrhbcygQRugelV5If4lJovBDD9e9vN91tb
         T1jIZSXaKTR4ecfxmLnza6TXL6q6qGj8SD7ua4xm4RU+9DTIwgeCBXr3WRECoNT8yZV5
         tBm/SpxGEa+KJCQOSHChnltlhPeTrjk5U5Rvx3hw+KifD4z9JQdfZ2qD37jB1OPKpVu4
         aqsQ==
X-Gm-Message-State: AOAM532OLdKCz731/dCEn2PogI0MGDJZv1ot1DWLpvQU8/J6XcrNzZ2Y
        5st1TJTw7v16zh5T9bR1JV0Ol3sabS3Lig==
X-Google-Smtp-Source: ABdhPJz95/B80Hu9vhoVPEoqWUGRbtzHme07LbE7QYHt8YF5mOlsibi9QNfQB6wnWaIzGRp3HI6HWA==
X-Received: by 2002:ae9:f816:: with SMTP id x22mr17217785qkh.291.1607226252096;
        Sat, 05 Dec 2020 19:44:12 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id z186sm9364566qke.100.2020.12.05.19.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Dec 2020 19:44:11 -0800 (PST)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v1 1/2] lan743x: improve performance: fix rx_napi_poll/interrupt ping-pong
Date:   Sat,  5 Dec 2020 22:44:07 -0500
Message-Id: <20201206034408.31492-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

Even if the rx ring is completely full, and there is more rx data
waiting on the chip, the rx napi poll fn will never run more than
once - it will always immediately bail out and re-enable interrupts.
Which results in ping-pong between napi and interrupt.

This defeats the purpose of napi, and is bad for performance.

Fix by addressing two separate issues:

1. Ensure the rx napi poll fn always updates the rx ring tail
   when returning, even when not re-enabling interrupts.

2. Up to half of elements in a full rx ring are extension
   frames, which do not generate any skbs. Limit the default
   napi weight to the smallest no. of skbs that can be generated
   by a full rx ring.

Tested-by: Sven Van Asbroeck <thesven73@gmail.com> # lan7430
Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
---

Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git # 905b2032fa42

To: Bryan Whitehead <bryan.whitehead@microchip.com>
To: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
To: "David S. Miller" <davem@davemloft.net>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

 drivers/net/ethernet/microchip/lan743x_main.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 87b6c59a1e03..ebb5e0bc516b 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2260,10 +2260,11 @@ static int lan743x_rx_napi_poll(struct napi_struct *napi, int weight)
 				  INT_BIT_DMA_RX_(rx->channel_number));
 	}
 
+done:
 	/* update RX_TAIL */
 	lan743x_csr_write(adapter, RX_TAIL(rx->channel_number),
 			  rx_tail_flags | rx->last_tail);
-done:
+
 	return count;
 }
 
@@ -2405,9 +2406,15 @@ static int lan743x_rx_open(struct lan743x_rx *rx)
 	if (ret)
 		goto return_error;
 
+	/* up to half of elements in a full rx ring are
+	 * extension frames. these do not generate skbs.
+	 * to prevent napi/interrupt ping-pong, limit default
+	 * weight to the smallest no. of skbs that can be
+	 * generated by a full rx ring.
+	 */
 	netif_napi_add(adapter->netdev,
 		       &rx->napi, lan743x_rx_napi_poll,
-		       rx->ring_size - 1);
+		       (rx->ring_size - 1) / 2);
 
 	lan743x_csr_write(adapter, DMAC_CMD,
 			  DMAC_CMD_RX_SWR_(rx->channel_number));
-- 
2.17.1

