Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E74466C3273
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 14:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjCUNSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 09:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbjCUNSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 09:18:20 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA13ECA39
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 06:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=k1; bh=H1ucjAMQLkSzYguyczH2BGhbA/9
        UDmcQVc9BKIjCwuw=; b=jPUEt5QlAevlma/eYBPCc9a3ocpV8WiRxDNHm74EILG
        NrJTjKpnFbZch3eM0icHyDaqdsp1iKCUsaRdgQwUo2VjNQ8Ib6wmg6x3MTtkQ5UC
        wixNZJ8QCJVCSmOoqnzIphoS9/d19MswNPzw4VvFzKYZ0tsKK/0jn1w9vdQ1CVc4
        =
Received: (qmail 1292985 invoked from network); 21 Mar 2023 14:18:01 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 21 Mar 2023 14:18:01 +0100
X-UD-Smtp-Session: l3s3148p1@lnp532j36KMujnv6
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Wells Lu <wellslutw@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] ethernet: remove superfluous clearing of phydev
Date:   Tue, 21 Mar 2023 14:17:45 +0100
Message-Id: <20230321131745.27688-1-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phy_disconnect() calls phy_detach() which already clears 'phydev' if it
is attached to a struct net_device.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---

Tested with an Renesas APE6-EK (SMSC911x). Because this is more of a
mechanical change, I opted to put all occurences into one patch. I can
break out, of course, if this is preferred.

 drivers/net/ethernet/engleder/tsnep_main.c    | 1 -
 drivers/net/ethernet/microchip/lan743x_main.c | 1 -
 drivers/net/ethernet/renesas/rswitch.c        | 4 +---
 drivers/net/ethernet/smsc/smsc911x.c          | 2 --
 drivers/net/ethernet/sunplus/spl2sw_phy.c     | 4 +---
 5 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 6982aaa928b5..ed1b6102cfeb 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -246,7 +246,6 @@ static void tsnep_phy_close(struct tsnep_adapter *adapter)
 {
 	phy_stop(adapter->netdev->phydev);
 	phy_disconnect(adapter->netdev->phydev);
-	adapter->netdev->phydev = NULL;
 }
 
 static void tsnep_tx_ring_cleanup(struct tsnep_tx *tx)
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 7e0871b631e4..957d96a91a8a 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1466,7 +1466,6 @@ static void lan743x_phy_close(struct lan743x_adapter *adapter)
 
 	phy_stop(netdev->phydev);
 	phy_disconnect(netdev->phydev);
-	netdev->phydev = NULL;
 }
 
 static void lan743x_phy_interface_select(struct lan743x_adapter *adapter)
diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index c4f93d24c6a4..29afaddb598d 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1324,10 +1324,8 @@ static int rswitch_phy_device_init(struct rswitch_device *rdev)
 
 static void rswitch_phy_device_deinit(struct rswitch_device *rdev)
 {
-	if (rdev->ndev->phydev) {
+	if (rdev->ndev->phydev)
 		phy_disconnect(rdev->ndev->phydev);
-		rdev->ndev->phydev = NULL;
-	}
 }
 
 static int rswitch_serdes_set_params(struct rswitch_device *rdev)
diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 3a9e587f7452..037a2b6b89d7 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -1744,7 +1744,6 @@ static int smsc911x_open(struct net_device *dev)
 	free_irq(dev->irq, dev);
 mii_free_out:
 	phy_disconnect(dev->phydev);
-	dev->phydev = NULL;
 out:
 	pm_runtime_put(dev->dev.parent);
 	return retval;
@@ -1775,7 +1774,6 @@ static int smsc911x_stop(struct net_device *dev)
 	if (dev->phydev) {
 		phy_stop(dev->phydev);
 		phy_disconnect(dev->phydev);
-		dev->phydev = NULL;
 	}
 	netif_carrier_off(dev);
 	pm_runtime_put(dev->dev.parent);
diff --git a/drivers/net/ethernet/sunplus/spl2sw_phy.c b/drivers/net/ethernet/sunplus/spl2sw_phy.c
index 404f508a54d4..6f899e48f51d 100644
--- a/drivers/net/ethernet/sunplus/spl2sw_phy.c
+++ b/drivers/net/ethernet/sunplus/spl2sw_phy.c
@@ -84,9 +84,7 @@ void spl2sw_phy_remove(struct spl2sw_common *comm)
 	for (i = 0; i < MAX_NETDEV_NUM; i++)
 		if (comm->ndev[i]) {
 			ndev = comm->ndev[i];
-			if (ndev) {
+			if (ndev)
 				phy_disconnect(ndev->phydev);
-				ndev->phydev = NULL;
-			}
 		}
 }
-- 
2.30.2

