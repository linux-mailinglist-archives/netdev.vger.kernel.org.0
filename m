Return-Path: <netdev+bounces-5621-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 919F1712458
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:15:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E4211C20F98
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14A18156DA;
	Fri, 26 May 2023 10:14:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3EE168C4
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:14:53 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C809E
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=SqHP3kqKew2Lk6pLLFi1gT4h/yw8ZDGHXZ5SZTsZHN0=; b=AakMHeQkvxufJmIzdjE4PULOp7
	9wyVVrzpHRLm7rtzsxyTfDNP4bHte6IWawF8+9Zkth7UBuwwv20BIYLVha2VoEdZduK3I/lWTT3GK
	cfyuMgSodsuMQVj581ZxVIyJJq8RR5VEousqRNq/SkxnLyLOHba1Xj8cHWeUaF+ifSzM9YdZg7aly
	MKE0VcZ4kitbaf5zQ9s/LdjCeNU8IQKQo1kFgte9KSlHB4SvJAPg/Nh1KaLQNIwPdEHbOICvJZJkJ
	qRyRxuNSvaLo80k+lhWM9VWCyPFaIoEDOX6M68IOts4bkidlYnub3G2fHz/EDb3Y5p454MbN5egV2
	VImbly6Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:41914 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q2UT2-0005Pm-FA; Fri, 26 May 2023 11:14:40 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q2UT1-008PAg-RS; Fri, 26 May 2023 11:14:39 +0100
In-Reply-To: <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk>
References: <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: Jiawen Wu <jiawenwu@trustnetic.com>,
	 Maxime Chevallier <maxime.chevallier@bootlin.com>,
	 Simon Horman <simon.horman@corigine.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: [PATCH net-next 4/6] net: pcs: lynx: add lynx_pcs_create_mdiodev()
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q2UT1-008PAg-RS@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 26 May 2023 11:14:39 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add lynx_pcs_create_mdiodev() to simplify the creation of the mdio
device associated with lynx PCS. In order to allow lynx_pcs_destroy()
to clean this up, we need to arrange for lynx_pcs_create() to take a
refcount on the mdiodev, and lynx_pcs_destroy() to put it.

Adding the refcounting to lynx_pcs_create()..lynx_pcs_destroy() will
be transparent to existing users of these interfaces.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/pcs/pcs-lynx.c | 31 +++++++++++++++++++++++++++++++
 include/linux/pcs-lynx.h   |  1 +
 2 files changed, 32 insertions(+)

diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index 622c3de3f3a8..f04dc580ffb8 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -323,6 +323,7 @@ struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio)
 	if (!lynx)
 		return NULL;
 
+	mdio_device_get(mdio);
 	lynx->mdio = mdio;
 	lynx->pcs.ops = &lynx_pcs_phylink_ops;
 	lynx->pcs.poll = true;
@@ -331,10 +332,40 @@ struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio)
 }
 EXPORT_SYMBOL(lynx_pcs_create);
 
+struct phylink_pcs *lynx_pcs_create_mdiodev(struct mii_bus *bus, int addr)
+{
+	struct mdio_device *mdio;
+	struct phylink_pcs *pcs;
+
+	mdio = mdio_device_create(bus, addr);
+	if (IS_ERR(mdio))
+		return ERR_CAST(mdio);
+
+	pcs = lynx_pcs_create(mdio);
+
+	/* Convert failure to create the PCS to an error pointer, so this
+	 * function has a consistent return value strategy.
+	 */
+	if (!pcs)
+		pcs = ERR_PTR(-ENOMEM);
+
+	/* lynx_create() has taken a refcount on the mdiodev if it was
+	 * successful. If lynx_create() fails, this will free the mdio
+	 * device here. In any case, we don't need to hold our reference
+	 * anymore, and putting it here will allow mdio_device_put() in
+	 * lynx_destroy() to automatically free the mdio device.
+	 */
+	mdio_device_put(mdio);
+
+	return pcs;
+}
+EXPORT_SYMBOL(lynx_pcs_create_mdiodev);
+
 void lynx_pcs_destroy(struct phylink_pcs *pcs)
 {
 	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
 
+	mdio_device_put(lynx->mdio);
 	kfree(lynx);
 }
 EXPORT_SYMBOL(lynx_pcs_destroy);
diff --git a/include/linux/pcs-lynx.h b/include/linux/pcs-lynx.h
index 5712cc2ce775..885b59d10581 100644
--- a/include/linux/pcs-lynx.h
+++ b/include/linux/pcs-lynx.h
@@ -12,6 +12,7 @@
 struct mdio_device *lynx_get_mdio_device(struct phylink_pcs *pcs);
 
 struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio);
+struct phylink_pcs *lynx_pcs_create_mdiodev(struct mii_bus *bus, int addr);
 
 void lynx_pcs_destroy(struct phylink_pcs *pcs);
 
-- 
2.30.2


