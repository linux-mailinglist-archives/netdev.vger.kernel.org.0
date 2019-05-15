Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59ABE1E802
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 07:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfEOFlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 01:41:20 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:3467 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725781AbfEOFlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 01:41:20 -0400
X-IronPort-AV: E=Sophos;i="5.60,471,1549897200"; 
   d="scan'208";a="15775841"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 15 May 2019 14:41:18 +0900
Received: from localhost.localdomain (unknown [10.166.17.210])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 82E76401070B;
        Wed, 15 May 2019 14:41:18 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     sergei.shtylyov@cogentembedded.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH] net: sh_eth: fix mdio access in sh_eth_close() for some SoCs
Date:   Wed, 15 May 2019 14:36:41 +0900
Message-Id: <1557898601-26231-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sh_eth_close() resets the MAC and then calls phy_stop()
so that mdio read access result is incorrect without any error
according to kernel trace like below:

ifconfig-216   [003] .n..   109.133124: mdio_access: ee700000.ethernet-ffffffff read  phy:0x01 reg:0x00 val:0xffff

To fix the issue, this patch adds a condition and set the RMII mode
regiseter in sh_eth_dev_exit() for some SoCs.

Note that when I have tried to move the sh_eth_dev_exit() calling
after phy_stop() on sh_eth_close(), but it gets worse.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/sh_eth.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index e33af37..106ae90 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -1596,6 +1596,10 @@ static void sh_eth_dev_exit(struct net_device *ndev)
 
 	/* Set MAC address again */
 	update_mac_address(ndev);
+
+	/* Set the mode again if required */
+	if (mdp->cd->rmiimode)
+		sh_eth_write(ndev, 0x1, RMIIMODE);
 }
 
 static void sh_eth_rx_csum(struct sk_buff *skb)
-- 
2.7.4

