Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF9C26BC796
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 08:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjCPHqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 03:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjCPHqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 03:46:16 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C844AA3B7C
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 00:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=k1; bh=+IR8pE4hi1ZLE+
        2LyqKA5kfPq/hBxxEmeX0MnGUKI4c=; b=DnI16kGJNgx0M25sW+BCIGFKwh401d
        5QyHNd7ALoXBfFpWQEsmiJWv7f2BwI7oQqgTVwYA5GmSS3wVbZYbGtcIa9QtXdh/
        TmDQJL8MhOjnh2gCF6s/k+htUsVVeVzDW6TwrrzVQkmAwxrJuFXH52voGidWYp4S
        3TxDslnkw9Qf0=
Received: (qmail 3694226 invoked from network); 16 Mar 2023 08:46:09 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 16 Mar 2023 08:46:09 +0100
X-UD-Smtp-Session: l3s3148p1@ybFtp//2WJwujnvb
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Revert "net: smsc911x: Make Runtime PM handling more fine-grained"
Date:   Thu, 16 Mar 2023 08:45:57 +0100
Message-Id: <20230316074558.15268-2-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230316074558.15268-1-wsa+renesas@sang-engineering.com>
References: <20230316074558.15268-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 1e30b8d755b81b0d1585cb22bc753e9f2124fe87. Running
'ifconfig' with the interface down BUGs. This is the culprit:

	smsc911x_get_stats from dev_get_stats+0xe4/0xf4

The above function is called with the clocks off, so register read
fails. Enabling clocks in the above functions does not work, because it
is called in atomic context. So, let's return to the simple and working
PM we had before.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 drivers/net/ethernet/smsc/smsc911x.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index a2e511912e6a..9d12fd54281a 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -557,7 +557,6 @@ static int smsc911x_mii_read(struct mii_bus *bus, int phyaddr, int regidx)
 	unsigned int addr;
 	int i, reg;
 
-	pm_runtime_get_sync(bus->parent);
 	spin_lock_irqsave(&pdata->mac_lock, flags);
 
 	/* Confirm MII not busy */
@@ -583,7 +582,6 @@ static int smsc911x_mii_read(struct mii_bus *bus, int phyaddr, int regidx)
 
 out:
 	spin_unlock_irqrestore(&pdata->mac_lock, flags);
-	pm_runtime_put(bus->parent);
 	return reg;
 }
 
@@ -596,7 +594,6 @@ static int smsc911x_mii_write(struct mii_bus *bus, int phyaddr, int regidx,
 	unsigned int addr;
 	int i, reg;
 
-	pm_runtime_get_sync(bus->parent);
 	spin_lock_irqsave(&pdata->mac_lock, flags);
 
 	/* Confirm MII not busy */
@@ -626,7 +623,6 @@ static int smsc911x_mii_write(struct mii_bus *bus, int phyaddr, int regidx,
 
 out:
 	spin_unlock_irqrestore(&pdata->mac_lock, flags);
-	pm_runtime_put(bus->parent);
 	return reg;
 }
 
@@ -1595,8 +1591,6 @@ static int smsc911x_open(struct net_device *dev)
 	int retval;
 	int irq_flags;
 
-	pm_runtime_get_sync(dev->dev.parent);
-
 	/* find and start the given phy */
 	if (!dev->phydev) {
 		retval = smsc911x_mii_probe(dev);
@@ -1743,7 +1737,6 @@ static int smsc911x_open(struct net_device *dev)
 	phy_disconnect(dev->phydev);
 	dev->phydev = NULL;
 out:
-	pm_runtime_put(dev->dev.parent);
 	return retval;
 }
 
@@ -1775,7 +1768,6 @@ static int smsc911x_stop(struct net_device *dev)
 		dev->phydev = NULL;
 	}
 	netif_carrier_off(dev);
-	pm_runtime_put(dev->dev.parent);
 
 	SMSC_TRACE(pdata, ifdown, "Interface stopped");
 	return 0;
@@ -2347,6 +2339,7 @@ static int smsc911x_drv_remove(struct platform_device *pdev)
 
 	free_netdev(dev);
 
+	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	return 0;
@@ -2552,7 +2545,6 @@ static int smsc911x_drv_probe(struct platform_device *pdev)
 	}
 
 	spin_unlock_irq(&pdata->mac_lock);
-	pm_runtime_put(&pdev->dev);
 
 	netdev_info(dev, "MAC Address: %pM\n", dev->dev_addr);
 
-- 
2.30.2

