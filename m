Return-Path: <netdev+bounces-2340-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBAC8701571
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 10:57:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CEDCF1C210E3
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 08:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D85041377;
	Sat, 13 May 2023 08:57:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB311102
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 08:57:40 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0314C38
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 01:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
	:Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
	Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=DlKOhEFjiiGwqerZ6EMxE6XyFnrwS1JtEcY/NwrfCa0=; b=wVs9uYrGZonmGHDnjmUap1HfHQ
	52RVKOdIk7lcrUiZjga/Fo/6+H529/T6/wsOolvxOuZhRZ3LPR+qMRVapZk3LPJOYguyL9Imr9kU7
	5TJXV5/akdhDnnHcRDcYO1yPlB9LKH4Svad3wVVAWmrw4xarOwQ8zCnHYfPhF39yOEywHXugWgebw
	7MRDu4GY5optzO3+AY85i8mDTT61PzhjUOxtGDWu4AWN9vlM28PCiBen9Ky1ZaU70cQ9qRpd36h2A
	OWJEuYhc8zrC4GKwmQVI06dslRNkK3Qlw6gPk/jJDycJ7pZJpSTyva5yg3U1nu9MvSg8yY5MldfVY
	W3tIPjxA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:47026 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1pxl4C-00018c-E7; Sat, 13 May 2023 09:57:28 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1pxl4B-00324m-NP; Sat, 13 May 2023 09:57:27 +0100
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Michael Walle <michael@walle.cc>,
	netdev@vger.kernel.org
Subject: [PATCH net] net: mdio: i2c: fix rollball accessors
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pxl4B-00324m-NP@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Sat, 13 May 2023 09:57:27 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Commit 87e3bee0f247 ("net: mdio: i2c: Separate C22 and C45 transactions")
separated the non-rollball bus accessors, but left the rollball
accessors as is. As rollball accessors are clause 45, this results
in the rollball protocol being completely non-functional. Fix this.

Fixes: 87e3bee0f247 ("net: mdio: i2c: Separate C22 and C45 transactions")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/mdio/mdio-i2c.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/mdio/mdio-i2c.c b/drivers/net/mdio/mdio-i2c.c
index 1e0c206d0f2e..da2001ea1f99 100644
--- a/drivers/net/mdio/mdio-i2c.c
+++ b/drivers/net/mdio/mdio-i2c.c
@@ -291,7 +291,8 @@ static int i2c_rollball_mii_cmd(struct mii_bus *bus, int bus_addr, u8 cmd,
 	return i2c_transfer_rollball(i2c, msgs, ARRAY_SIZE(msgs));
 }
 
-static int i2c_mii_read_rollball(struct mii_bus *bus, int phy_id, int reg)
+static int i2c_mii_read_rollball(struct mii_bus *bus, int phy_id, int devad,
+				 int reg)
 {
 	u8 buf[4], res[6];
 	int bus_addr, ret;
@@ -302,7 +303,7 @@ static int i2c_mii_read_rollball(struct mii_bus *bus, int phy_id, int reg)
 		return 0xffff;
 
 	buf[0] = ROLLBALL_DATA_ADDR;
-	buf[1] = (reg >> 16) & 0x1f;
+	buf[1] = devad;
 	buf[2] = (reg >> 8) & 0xff;
 	buf[3] = reg & 0xff;
 
@@ -322,8 +323,8 @@ static int i2c_mii_read_rollball(struct mii_bus *bus, int phy_id, int reg)
 	return val;
 }
 
-static int i2c_mii_write_rollball(struct mii_bus *bus, int phy_id, int reg,
-				  u16 val)
+static int i2c_mii_write_rollball(struct mii_bus *bus, int phy_id, int devad,
+				  int reg, u16 val)
 {
 	int bus_addr, ret;
 	u8 buf[6];
@@ -333,7 +334,7 @@ static int i2c_mii_write_rollball(struct mii_bus *bus, int phy_id, int reg,
 		return 0;
 
 	buf[0] = ROLLBALL_DATA_ADDR;
-	buf[1] = (reg >> 16) & 0x1f;
+	buf[1] = devad;
 	buf[2] = (reg >> 8) & 0xff;
 	buf[3] = reg & 0xff;
 	buf[4] = val >> 8;
@@ -405,8 +406,8 @@ struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c,
 			return ERR_PTR(ret);
 		}
 
-		mii->read = i2c_mii_read_rollball;
-		mii->write = i2c_mii_write_rollball;
+		mii->read_c45 = i2c_mii_read_rollball;
+		mii->write_c45 = i2c_mii_write_rollball;
 		break;
 	default:
 		mii->read = i2c_mii_read_default_c22;
-- 
2.30.2


