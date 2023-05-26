Return-Path: <netdev+bounces-5617-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADDF571244F
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:14:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E7AF1C20F9C
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:14:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6C57156CD;
	Fri, 26 May 2023 10:14:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD25E156CB
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:14:29 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B474A9
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=DFrgZQtuq/addgnoY8bA/wOUr0tSaPz0rjOzKFCgWpU=; b=0ppcPxR9SzELLjhQ22fNBEzt3c
	nDxMZ9c4chkMzcUYUZmkXb28mSB8mwoTuU+HtDPWJPZM1BdjgKtyWdeoWyrnJuqVjQwKwNhtR7QYN
	v1s4rvD868xiCs5ZKuTxTkXapyCXRn+MEqrqC02TXT0JFVRPlLoBstD6A1QJTlz+bKFqs6w/mTNRt
	2vCtLd64bP3LyAmZGm+FPkfninV3S4rXHLPiaxcKTLZYLh9kRrt9/UGdWBSYD2FxGW1Jn2YBaBNUN
	/+/iorLM+oe8+m+CpOPTy2Ug2zeJO94x+PueAXVFHK8Ipy04RLu/2zpylcGpcsEwSDg7T+H95LEBm
	YNIVrA2w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:41656 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q2USn-0005Os-4x; Fri, 26 May 2023 11:14:25 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q2USm-008PAO-Gx; Fri, 26 May 2023 11:14:24 +0100
In-Reply-To: <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk>
References: <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: Jiawen Wu <jiawenwu@trustnetic.com>,
	 Maxime Chevallier <maxime.chevallier@bootlin.com>,
	 Simon Horman <simon.horman@corigine.com>,
	netdev@vger.kernel.org
Subject: [PATCH net-next 1/6] net: mdio: add mdio_device_get() and
 mdio_device_put()
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q2USm-008PAO-Gx@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 26 May 2023 11:14:24 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add two new operations for a mdio device to manage the refcount on the
underlying struct device. This will be used by mdio PCS drivers to
simplify the creation and destruction handling, making it easier for
users to get it correct.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 include/linux/mdio.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 0670cc6e067c..c1b7008826e5 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -106,6 +106,16 @@ int mdio_driver_register(struct mdio_driver *drv);
 void mdio_driver_unregister(struct mdio_driver *drv);
 int mdio_device_bus_match(struct device *dev, struct device_driver *drv);
 
+static inline void mdio_device_get(struct mdio_device *mdiodev)
+{
+	get_device(&mdiodev->dev);
+}
+
+static inline void mdio_device_put(struct mdio_device *mdiodev)
+{
+	mdio_device_free(mdiodev);
+}
+
 static inline bool mdio_phy_id_is_c45(int phy_id)
 {
 	return (phy_id & MDIO_PHY_ID_C45) && !(phy_id & ~MDIO_PHY_ID_C45_MASK);
-- 
2.30.2


