Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F80A6BB4E6
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbjCONl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbjCONlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:41:25 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB226B5DD;
        Wed, 15 Mar 2023 06:41:24 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 6E2E8218EE;
        Wed, 15 Mar 2023 13:41:23 +0000 (UTC)
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 4A1312C141;
        Wed, 15 Mar 2023 13:41:23 +0000 (UTC)
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] i825xx: sni_82596: use eth_hw_addr_set()
Date:   Wed, 15 Mar 2023 14:41:17 +0100
Message-Id: <20230315134117.79511-1-tsbogend@alpha.franken.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_FAIL,SPF_HELO_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Copy scrambled mac address octects into an array then eth_hw_addr_set().

Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 drivers/net/ethernet/i825xx/sni_82596.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/i825xx/sni_82596.c b/drivers/net/ethernet/i825xx/sni_82596.c
index daec9ce04531..54bb4d9a0d1e 100644
--- a/drivers/net/ethernet/i825xx/sni_82596.c
+++ b/drivers/net/ethernet/i825xx/sni_82596.c
@@ -78,6 +78,7 @@ static int sni_82596_probe(struct platform_device *dev)
 	void __iomem *mpu_addr;
 	void __iomem *ca_addr;
 	u8 __iomem *eth_addr;
+	u8 mac[ETH_ALEN];
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	ca = platform_get_resource(dev, IORESOURCE_MEM, 1);
@@ -109,12 +110,13 @@ static int sni_82596_probe(struct platform_device *dev)
 		goto probe_failed;
 
 	/* someone seems to like messed up stuff */
-	netdevice->dev_addr[0] = readb(eth_addr + 0x0b);
-	netdevice->dev_addr[1] = readb(eth_addr + 0x0a);
-	netdevice->dev_addr[2] = readb(eth_addr + 0x09);
-	netdevice->dev_addr[3] = readb(eth_addr + 0x08);
-	netdevice->dev_addr[4] = readb(eth_addr + 0x07);
-	netdevice->dev_addr[5] = readb(eth_addr + 0x06);
+	mac[0] = readb(eth_addr + 0x0b);
+	mac[1] = readb(eth_addr + 0x0a);
+	mac[2] = readb(eth_addr + 0x09);
+	mac[3] = readb(eth_addr + 0x08);
+	mac[4] = readb(eth_addr + 0x07);
+	mac[5] = readb(eth_addr + 0x06);
+	eth_hw_addr_set(netdevice, mac);
 	iounmap(eth_addr);
 
 	if (netdevice->irq < 0) {
-- 
2.35.3

