Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E4E6C9E0A
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbjC0Ihv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233016AbjC0Ih3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:37:29 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3EAF76BC
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 01:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=k1; bh=YNOkyiQLi6rsjmLS4oe/+s1BKco
        sbWSDxtO/1EqJKJs=; b=e965lDlKU7sfdRCqt6zCCT1Mm6Hkmm444GuAhEYxWRW
        8ErrG+r95/YWnY0YsQ/RqI+IY0ZsfZNdL5G+Gu+Av4EvpxVkQRYfFzyy8mULqO64
        1ZHsSX4lf/pDKg5o6mRiSzkogGDzhnIUdh/v1d/0iQ0RD2hTvKERHd71+jxgbj88
        =
Received: (qmail 3064193 invoked from network); 27 Mar 2023 10:31:40 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 27 Mar 2023 10:31:40 +0200
X-UD-Smtp-Session: l3s3148p1@8TNskt33wpsujnv6
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Simon Horman <simon.horman@corigine.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v4] smsc911x: avoid PHY being resumed when interface is not up
Date:   Mon, 27 Mar 2023 10:31:38 +0200
Message-Id: <20230327083138.6044-1-wsa+renesas@sang-engineering.com>
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

SMSC911x doesn't need mdiobus suspend/resume, that's why it sets
'mac_managed_pm'. However, setting it needs to be moved from init to
probe, so mdiobus PM functions will really never be called (e.g. when
the interface is not up yet during suspend/resume).

Fixes: 3ce9f2bef755 ("net: smsc911x: Stop and start PHY during suspend and resume")
Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---

Changes since v3:
* broken out of a patch series. The other patch needs bigger rework and
  a seperate series
* add Simon's tag (thanks!)

 drivers/net/ethernet/smsc/smsc911x.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index a2e511912e6a..a690d139e177 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -1037,8 +1037,6 @@ static int smsc911x_mii_probe(struct net_device *dev)
 		return ret;
 	}
 
-	/* Indicate that the MAC is responsible for managing PHY PM */
-	phydev->mac_managed_pm = true;
 	phy_attached_info(phydev);
 
 	phy_set_max_speed(phydev, SPEED_100);
@@ -1066,6 +1064,7 @@ static int smsc911x_mii_init(struct platform_device *pdev,
 			     struct net_device *dev)
 {
 	struct smsc911x_data *pdata = netdev_priv(dev);
+	struct phy_device *phydev;
 	int err = -ENXIO;
 
 	pdata->mii_bus = mdiobus_alloc();
@@ -1108,6 +1107,10 @@ static int smsc911x_mii_init(struct platform_device *pdev,
 		goto err_out_free_bus_2;
 	}
 
+	phydev = phy_find_first(pdata->mii_bus);
+	if (phydev)
+		phydev->mac_managed_pm = true;
+
 	return 0;
 
 err_out_free_bus_2:
-- 
2.30.2

