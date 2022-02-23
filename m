Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2053D4C0A11
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 04:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237868AbiBWDPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 22:15:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237860AbiBWDPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 22:15:42 -0500
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A6658E6A;
        Tue, 22 Feb 2022 19:15:15 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=guoheyi@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V5FxgGA_1645586109;
Received: from fdadf40dcbca.tbsite.net(mailfrom:guoheyi@linux.alibaba.com fp:SMTPD_---0V5FxgGA_1645586109)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 23 Feb 2022 11:15:12 +0800
From:   Heyi Guo <guoheyi@linux.alibaba.com>
To:     linux-kernel@vger.kernel.org
Cc:     Heyi Guo <guoheyi@linux.alibaba.com>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Stanley <joel@jms.id.au>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dylan Hung <dylan_hung@aspeedtech.com>, netdev@vger.kernel.org
Subject: [PATCH 3/3] drivers/net/ftgmac100: fix DHCP potential failure with systemd
Date:   Wed, 23 Feb 2022 11:14:36 +0800
Message-Id: <20220223031436.124858-4-guoheyi@linux.alibaba.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220223031436.124858-1-guoheyi@linux.alibaba.com>
References: <20220223031436.124858-1-guoheyi@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DHCP failures were observed with systemd 247.6. The issue could be
reproduced by rebooting Aspeed 2600 and then running ifconfig ethX
down/up.

It is caused by below procedures in the driver:

1. ftgmac100_open() enables net interface and call phy_start()
2. When PHY is link up, it calls netif_carrier_on() and then
adjust_link callback
3. ftgmac100_adjust_link() will schedule the reset task
4. ftgmac100_reset_task() will then reset the MAC in another schedule

After step 2, systemd will be notified to send DHCP discover packet,
while the packet might be corrupted by MAC reset operation in step 4.

Call ftgmac100_reset() directly instead of scheduling task to fix the
issue.

Signed-off-by: Heyi Guo <guoheyi@linux.alibaba.com>
---
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Guangbin Huang <huangguangbin2@huawei.com>
Cc: Hao Chen <chenhao288@hisilicon.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dylan Hung <dylan_hung@aspeedtech.com>
Cc: netdev@vger.kernel.org


---
 drivers/net/ethernet/faraday/ftgmac100.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index c1deb6e5d26c5..d5356db7539a4 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1402,8 +1402,17 @@ static void ftgmac100_adjust_link(struct net_device *netdev)
 	/* Disable all interrupts */
 	iowrite32(0, priv->base + FTGMAC100_OFFSET_IER);
 
-	/* Reset the adapter asynchronously */
-	schedule_work(&priv->reset_task);
+	/* Release phy lock to allow ftgmac100_reset to aquire it, keeping lock
+	 * order consistent to prevent dead lock.
+	 */
+	if (netdev->phydev)
+		mutex_unlock(&netdev->phydev->lock);
+
+	ftgmac100_reset(priv);
+
+	if (netdev->phydev)
+		mutex_lock(&netdev->phydev->lock);
+
 }
 
 static int ftgmac100_mii_probe(struct net_device *netdev)
-- 
2.17.1

