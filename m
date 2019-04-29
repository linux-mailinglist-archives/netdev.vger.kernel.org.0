Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEBFDE06
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 10:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbfD2IgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 04:36:19 -0400
Received: from first.geanix.com ([116.203.34.67]:49994 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727835AbfD2IfF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 04:35:05 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id 786F4308E8D;
        Mon, 29 Apr 2019 08:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1556526820; bh=GUNaGmlTbAw02jGE5nx/29moxwD7xAZSrJPPjP7Ycjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=HqE7ctEg9hIcYdMsERNM0DeaGm5yDZRTnrO7viYqkAyccKnFR36AUwEDcB/Tq8XKF
         jswPw5gNuzXtNJGN4L7totYOyim3IgvKjgE1FVe8WKweG8kkIe5T4kAlu/iDOZ+xpE
         cXwjhPOnX43yPPGKe9riOJjDFJrvxlqN6Keqassz6uUS1xqeEzQIR5Yni3pxCA2EG6
         5pV6c75SWZACp4025po4k+57zq+17NnrstuWgTbuEqaRvJvMmA0T76KEQTJWcZIVWh
         JxcZMEwmFNClK9mKELo57NPguCCpCpYD+AdqlOmHc94RHuHcW/bnVCMfCDBFr4Tp0p
         lheUSBXtMMFLw==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Yang Wei <yang.wei9@zte.com.cn>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/12] net: ll_temac: Fix bug causing buffer descriptor overrun
Date:   Mon, 29 Apr 2019 10:34:19 +0200
Message-Id: <20190429083422.4356-10-esben@geanix.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190429083422.4356-1-esben@geanix.com>
References: <20190426073231.4008-1-esben@geanix.com>
 <20190429083422.4356-1-esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 3e0c63300934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As we are actually using a BD for both the skb and each frag contained in
it, the oldest TX BD would be overwritten when there was exactly one BD
less than needed.

Signed-off-by: Esben Haabendal <esben@geanix.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 72ec338..2d50646 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -745,7 +745,7 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	start_p = lp->tx_bd_p + sizeof(*lp->tx_bd_v) * lp->tx_bd_tail;
 	cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
 
-	if (temac_check_tx_bd_space(lp, num_frag)) {
+	if (temac_check_tx_bd_space(lp, num_frag + 1)) {
 		if (!netif_queue_stopped(ndev))
 			netif_stop_queue(ndev);
 		return NETDEV_TX_BUSY;
-- 
2.4.11

