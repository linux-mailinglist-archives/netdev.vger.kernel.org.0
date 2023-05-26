Return-Path: <netdev+bounces-5623-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 381C771245D
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:16:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7C3B1C20FA2
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:16:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C98CB168C4;
	Fri, 26 May 2023 10:15:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9C9171A2
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:15:01 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8399E
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=x6uGNiJfgElAZ2H2dEKkmaGIzVNMg8n9RtVk/s1En74=; b=THZJ0O8IHobwRJ/MDtw3dk1i/a
	VelsAdnIzfSHxyX2X3UHVG2uFI0195fkWTuvEQQSIEC0awj5RC/35bzcZc/2i5FC8hsboO0unz0XD
	rdBGObKyldfBEhT2xl5P+bxg4q5mPPYAbn2xoRf/PkOPTmy3NK+TFuktSgPiLca0KWPv9IBtHDaWR
	pHAeW0z6FM8yzpPmlP1vT9X5DwkLHJUZYUZM+H6+kUGzI1IXjkCi8tZ+/02mUeDfv6MBP9Y/yb2wf
	D6EPiA9l9poCVamdSmBx2Sr4aPTpwk3m0EbHOO7KpFHxLpDua2VDIoHs1+TSCGYrHcsqz5wxRUUJc
	dkFTMm9Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:44102 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q2UTC-0005QU-LW; Fri, 26 May 2023 11:14:50 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q2UTC-008PAx-1m; Fri, 26 May 2023 11:14:50 +0100
In-Reply-To: <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk>
References: <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: Jiawen Wu <jiawenwu@trustnetic.com>,
	 Maxime Chevallier <maxime.chevallier@bootlin.com>,
	 Simon Horman <simon.horman@corigine.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: [PATCH net-next 6/6] net: enetc: use lynx_pcs_create_mdiodev()
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q2UTC-008PAx-1m@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 26 May 2023 11:14:50 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use the newly introduced lynx_pcs_create_mdiodev() which simplifies the
creation and destruction of the lynx PCS.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 22 ++++---------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 7cd22d370caa..1416262d4296 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -863,7 +863,6 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 	struct device *dev = &pf->si->pdev->dev;
 	struct enetc_mdio_priv *mdio_priv;
 	struct phylink_pcs *phylink_pcs;
-	struct mdio_device *mdio_device;
 	struct mii_bus *bus;
 	int err;
 
@@ -889,17 +888,9 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 		goto free_mdio_bus;
 	}
 
-	mdio_device = mdio_device_create(bus, 0);
-	if (IS_ERR(mdio_device)) {
-		err = PTR_ERR(mdio_device);
-		dev_err(dev, "cannot create mdio device (%d)\n", err);
-		goto unregister_mdiobus;
-	}
-
-	phylink_pcs = lynx_pcs_create(mdio_device);
-	if (!phylink_pcs) {
-		mdio_device_free(mdio_device);
-		err = -ENOMEM;
+	phylink_pcs = lynx_pcs_create_mdiodev(bus, 0);
+	if (IS_ERR(phylink_pcs)) {
+		err = PTR_ERR(phylink_pcs);
 		dev_err(dev, "cannot create lynx pcs (%d)\n", err);
 		goto unregister_mdiobus;
 	}
@@ -918,13 +909,8 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 
 static void enetc_imdio_remove(struct enetc_pf *pf)
 {
-	struct mdio_device *mdio_device;
-
-	if (pf->pcs) {
-		mdio_device = lynx_get_mdio_device(pf->pcs);
-		mdio_device_free(mdio_device);
+	if (pf->pcs)
 		lynx_pcs_destroy(pf->pcs);
-	}
 	if (pf->imdio) {
 		mdiobus_unregister(pf->imdio);
 		mdiobus_free(pf->imdio);
-- 
2.30.2


