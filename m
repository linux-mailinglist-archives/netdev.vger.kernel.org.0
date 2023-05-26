Return-Path: <netdev+bounces-5661-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A8A407125CC
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:44:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 241F11C2102C
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A862A883D;
	Fri, 26 May 2023 11:44:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D77A8476
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 11:44:51 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4921CA7
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 04:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
	:Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
	Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ViKYoK+ac+vQEyg0/T4n3gb0MwQDlLwS8Uix7Eaq9gQ=; b=z+LUcpvnCQMnlug51qsAywoW17
	TS0ehuCe1evi93v53z2lqW3Bn6kjoOYCZRjz7Ia9w8D1AOICxvDpHk6k9pSJnWR4sywcK1YLvnH1P
	/T/JtGlGRfmuIuNpFxCbn9EsygyGan4XuHGHd8s+x+qNmv+UNRpLE8snHIdnFwLB7axX0JeOMm31W
	slbHhtEc9/GuJOM3fNSvMAfhFSj7UtEDGrBRuPka19svgr8CKkaDDmgRWRo/AzDnawO5+HoNvjwve
	AogfnMmVOck6YrpWh53U14rWuxyVS3jv3dryY0ieqcZews/VlqLlx/BdKL5rqrwpMqWrBF08MN5AX
	8SQwFTpw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:35330 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q2VsC-0005Wz-1f; Fri, 26 May 2023 12:44:44 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q2VsB-008QlZ-El; Fri, 26 May 2023 12:44:43 +0100
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: Ioana Ciornei <ioana.ciornei@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: [PATCH net-next] net: dpaa2-mac: use correct interface to free
 mdiodev
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q2VsB-008QlZ-El@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 26 May 2023 12:44:43 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Rather than using put_device(&mdiodev->dev), use the proper interface
provided to dispose of the mdiodev - that being mdio_device_free().

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
This change is independent of the series I posted changing the lynx
PCS - since we're only subsituting an explicit put_device() for the
right interface in this driver, and this driver is not touched by
that series.

 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index b1871e6c4006..cb70855e2b9a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -273,7 +273,7 @@ static int dpaa2_pcs_create(struct dpaa2_mac *mac,
 	mac->pcs = lynx_pcs_create(mdiodev);
 	if (!mac->pcs) {
 		netdev_err(mac->net_dev, "lynx_pcs_create() failed\n");
-		put_device(&mdiodev->dev);
+		mdio_device_free(mdiodev);
 		return -ENOMEM;
 	}
 
@@ -286,10 +286,9 @@ static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
 
 	if (phylink_pcs) {
 		struct mdio_device *mdio = lynx_get_mdio_device(phylink_pcs);
-		struct device *dev = &mdio->dev;
 
 		lynx_pcs_destroy(phylink_pcs);
-		put_device(dev);
+		mdio_device_free(mdio);
 		mac->pcs = NULL;
 	}
 }
-- 
2.30.2


