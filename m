Return-Path: <netdev+bounces-610-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 793976F88B8
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 20:39:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C35DB28109A
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 18:39:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63C3A4C99;
	Fri,  5 May 2023 18:39:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D4D156EF
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 18:39:44 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp-25.smtpout.orange.fr [80.12.242.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A6E1E984
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 11:39:41 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
	by smtp.orange.fr with ESMTPA
	id v0L9pk2E0Gtqgv0L9pZwJH; Fri, 05 May 2023 20:39:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1683311979;
	bh=mnw6geelSaRq346Pzls6ofHvmuoLhwJOFudxBY6bbI8=;
	h=From:To:Cc:Subject:Date;
	b=HNyqmFrTormmtYO1mKS6qptrkzhC39BrHqC9jF3blBVbhK2TbhTTgNuCo94rx0J9K
	 6hBRWsiD/e+zisqWN/uxReWAtn5HDIS/M7SWxq85LhDBdwnDX6vVahdn179f9WAD9M
	 j7pUd4x1S+Q4sxpvtlY/ubPb4OTkig2uv+jzXREk1pJJ+cgEFAiVJkb5e1zX4h3+iC
	 ydc2TMMhmSvhdSFwgDsfuD+Htn1OwaE4iIPK0B8U2Al6bio7FHcn9V/6Cwu3ejoyRr
	 e51zKNApddwBEw95Net0SVx8JMDxA/7IpZkUpM/lnnoPBAnk2yj6wsCET6lSrvcOQ+
	 Kngrr0jYJCexg==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 05 May 2023 20:39:39 +0200
X-ME-IP: 86.243.2.178
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Tobias Waldekranz <tobias@waldekranz.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	netdev@vger.kernel.org
Subject: [PATCH net] net: mdio: mvusb: Fix an error handling path in mvusb_mdio_probe()
Date: Fri,  5 May 2023 20:39:33 +0200
Message-Id: <bd2244d44b914dec1aeccee4eba2e7e8135b585b.1683311885.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Should of_mdiobus_register() fail, a previous usb_get_dev() call should be
undone as in the .disconnect function.

Fixes: 04e37d92fbed ("net: phy: add marvell usb to mdio controller")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/mdio/mdio-mvusb.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mdio/mdio-mvusb.c b/drivers/net/mdio/mdio-mvusb.c
index 68fc55906e78..554837c21e73 100644
--- a/drivers/net/mdio/mdio-mvusb.c
+++ b/drivers/net/mdio/mdio-mvusb.c
@@ -67,6 +67,7 @@ static int mvusb_mdio_probe(struct usb_interface *interface,
 	struct device *dev = &interface->dev;
 	struct mvusb_mdio *mvusb;
 	struct mii_bus *mdio;
+	int ret;
 
 	mdio = devm_mdiobus_alloc_size(dev, sizeof(*mvusb));
 	if (!mdio)
@@ -87,7 +88,15 @@ static int mvusb_mdio_probe(struct usb_interface *interface,
 	mdio->write = mvusb_mdio_write;
 
 	usb_set_intfdata(interface, mvusb);
-	return of_mdiobus_register(mdio, dev->of_node);
+	ret = of_mdiobus_register(mdio, dev->of_node);
+	if (ret)
+		goto put_dev;
+
+	return 0;
+
+put_dev:
+	usb_put_dev(mvusb->udev);
+	return ret;
 }
 
 static void mvusb_mdio_disconnect(struct usb_interface *interface)
-- 
2.34.1


