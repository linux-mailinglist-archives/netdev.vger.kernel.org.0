Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9FF2F125
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 09:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfD3HTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 03:19:13 -0400
Received: from first.geanix.com ([116.203.34.67]:43740 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726622AbfD3HSk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 03:18:40 -0400
Received: from localhost (unknown [193.163.1.7])
        by first.geanix.com (Postfix) with ESMTPSA id E72C5308E9E;
        Tue, 30 Apr 2019 07:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1556608713; bh=qpf2haf0uskUuWVyjS1tnigmbJbmXAOP/MifuPOymYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=cf/RXeX4VymrAq05Ny3WfKYAgQ6t1XOqpjKqB1rUWFyAn9T3j3iQITY811authpkT
         RVpWXBX1PU8JRDHzhhsXupLvyA6Qbgmmum9mXXQedMfcxX2BtfLKIqZZETRGOStQ81
         RoYmUn3GdzTiumYT62Aqj2bT8bbHlcXj336s1Lpdgp1OzT2XQ1+HT6l2egXlaZxzQz
         opX0eaEbPokwMCQdNSGN40Jlflq1ZNW2nkJEXDL+a/1G25NDuPfgigPpltq21TLUzg
         /nNa8VmnK21pmrqhZepIjSGLXPWzq3BYOfe6LLLfqnqTs+o07qbqFU6BMI+FUudDnm
         SAf0MdyRL6RTA==
From:   Esben Haabendal <esben@geanix.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        YueHaibing <yuehaibing@huawei.com>,
        Yang Wei <yang.wei9@zte.com.cn>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 09/12] net: ll_temac: Fix bug causing buffer descriptor overrun
Date:   Tue, 30 Apr 2019 09:17:56 +0200
Message-Id: <20190430071759.2481-10-esben@geanix.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430071759.2481-1-esben@geanix.com>
References: <20190429083422.4356-1-esben@geanix.com>
 <20190430071759.2481-1-esben@geanix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on b7bf6291adac
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
index 7e42746..6837565 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -743,7 +743,7 @@ temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	start_p = lp->tx_bd_p + sizeof(*lp->tx_bd_v) * lp->tx_bd_tail;
 	cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
 
-	if (temac_check_tx_bd_space(lp, num_frag)) {
+	if (temac_check_tx_bd_space(lp, num_frag + 1)) {
 		if (!netif_queue_stopped(ndev))
 			netif_stop_queue(ndev);
 		return NETDEV_TX_BUSY;
-- 
2.4.11

