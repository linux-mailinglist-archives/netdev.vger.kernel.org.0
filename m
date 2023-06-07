Return-Path: <netdev+bounces-8819-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 971A6725DE6
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:00:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0208B1C20898
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:00:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 588C534D9D;
	Wed,  7 Jun 2023 11:59:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F14C3445A
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:59:09 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F011BD9
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 04:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=2yNodawdrBoK9j42w1NAjw0rxU0GUGNTc4kJukpmkmw=; b=IM6BwlxUVtOPGdM5E2I2XrELb5
	HXcZ6+VbO6SV1vqK753ZORUqkmcwcX//k6pCnQ3XwFSCiUOMkajWxFIp6gg5SEgCQW95LeRt6TOh4
	6lbibufi8Asb/U0U/qfRd2Hz0/mWcPcygDRJ5UNiIm35BuXKmrdyzl3gAKyBNefQS4+X1bTpvxJXb
	gyIT8b9NrgCcC64vbRcOoF5XeSTM6NowFeO3H7y7lH2AcBTq3KJf4GeC7LJPVIBBJd7FfHkn+ovc/
	ORupryCH6TtHq4PnEdnMy2OOaI9IqrXdXB41jnZX/SZh3G1NjCHUT7O5EuqQR+CjUKG9rW12MT+Ns
	sBcaf04A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:44396 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q6roQ-0007Mi-6n; Wed, 07 Jun 2023 12:58:50 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q6roP-00Cfao-KJ; Wed, 07 Jun 2023 12:58:49 +0100
In-Reply-To: <ZIBwuw+IuGQo5yV8@shell.armlinux.org.uk>
References: <ZIBwuw+IuGQo5yV8@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Madalin Bucur <madalin.bucur@nxp.com>,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v2 08/11] net: pcs: lynx: change lynx_pcs_create() to
 return error-pointers
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q6roP-00Cfao-KJ@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 07 Jun 2023 12:58:49 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Change lynx_pcs_create() to return an error-pointer on failure to
allocate memory, rather than returning NULL. This allows the removal
of the conversion in lynx_pcs_create_fwnode() and
lynx_pcs_create_mdiodev().

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-lynx.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index b8c66137e28d..c2d01da40430 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -313,7 +313,7 @@ static struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio)
 
 	lynx = kzalloc(sizeof(*lynx), GFP_KERNEL);
 	if (!lynx)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	mdio_device_get(mdio);
 	lynx->mdio = mdio;
@@ -334,12 +334,6 @@ struct phylink_pcs *lynx_pcs_create_mdiodev(struct mii_bus *bus, int addr)
 
 	pcs = lynx_pcs_create(mdio);
 
-	/* Convert failure to create the PCS to an error pointer, so this
-	 * function has a consistent return value strategy.
-	 */
-	if (!pcs)
-		pcs = ERR_PTR(-ENOMEM);
-
 	/* lynx_create() has taken a refcount on the mdiodev if it was
 	 * successful. If lynx_create() fails, this will free the mdio
 	 * device here. In any case, we don't need to hold our reference
@@ -363,12 +357,6 @@ struct phylink_pcs *lynx_pcs_create_fwnode(struct fwnode_handle *node)
 
 	pcs = lynx_pcs_create(mdio);
 
-	/* Convert failure to create the PCS to an error pointer, so this
-	 * function has a consistent return value strategy.
-	 */
-	if (!pcs)
-		pcs = ERR_PTR(-ENOMEM);
-
 	/* lynx_create() has taken a refcount on the mdiodev if it was
 	 * successful. If lynx_create() fails, this will free the mdio
 	 * device here. In any case, we don't need to hold our reference
-- 
2.30.2


