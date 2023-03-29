Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22EBC6CD22B
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 08:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjC2Gko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 02:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjC2Gkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 02:40:43 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69666171E
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 23:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=k1; bh=bp2oMfQvdpfgL+bw/t6/ET9O4Xp
        sb1NY92VJliw+S7w=; b=RxyhuWsXKrtXlpT7D0AKfoJiQQumEatJPpXrayV7Vf+
        SCkiCDDZB8zpK0N05igqaRd0fX9FWLw1puxMWJLd52CvBeCeWPxThyiIWuhuBPN0
        QjrCOC2SHErx/onZzzCedM3UYU3OHHz9QWNibNRK6YjTbCvv6ure8uZMmJEXsOsU
        =
Received: (qmail 456570 invoked from network); 29 Mar 2023 08:40:30 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 29 Mar 2023 08:40:30 +0200
X-UD-Smtp-Session: l3s3148p1@IB9oQAT4vKsujnv6
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v4] smsc911x: only update stats when interface is up
Date:   Wed, 29 Mar 2023 08:40:10 +0200
Message-Id: <20230329064010.24657-1-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Otherwise the clocks are not enabled and reading registers will OOPS.
Copy the behaviour from Renesas SH_ETH and use a custom flag because
using netif_running() is racy. A generic solution still needs to be
implemented. Tested on a Renesas APE6-EK.

Fixes: 1e30b8d755b8 ("net: smsc911x: Make Runtime PM handling more fine-grained")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---

Changes since v3:
* broken out of a patch series
* don't use netif_running() but a custom flag

 drivers/net/ethernet/smsc/smsc911x.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index a690d139e177..af96986cbc88 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -140,6 +140,8 @@ struct smsc911x_data {
 
 	/* clock */
 	struct clk *clk;
+
+	bool is_open;
 };
 
 /* Easy access to information */
@@ -1738,6 +1740,8 @@ static int smsc911x_open(struct net_device *dev)
 	smsc911x_reg_write(pdata, TX_CFG, TX_CFG_TX_ON_);
 
 	netif_start_queue(dev);
+	pdata->is_open = true;
+
 	return 0;
 
 irq_stop_out:
@@ -1778,6 +1782,8 @@ static int smsc911x_stop(struct net_device *dev)
 		dev->phydev = NULL;
 	}
 	netif_carrier_off(dev);
+	pdata->is_open = false;
+
 	pm_runtime_put(dev->dev.parent);
 
 	SMSC_TRACE(pdata, ifdown, "Interface stopped");
@@ -1841,8 +1847,12 @@ smsc911x_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 static struct net_device_stats *smsc911x_get_stats(struct net_device *dev)
 {
 	struct smsc911x_data *pdata = netdev_priv(dev);
-	smsc911x_tx_update_txcounters(dev);
-	dev->stats.rx_dropped += smsc911x_reg_read(pdata, RX_DROP);
+
+	if (pdata->is_open) {
+		smsc911x_tx_update_txcounters(dev);
+		dev->stats.rx_dropped += smsc911x_reg_read(pdata, RX_DROP);
+	}
+
 	return &dev->stats;
 }
 
-- 
2.30.2

