Return-Path: <netdev+bounces-7425-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DA827203D7
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:58:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFC1D1C20F48
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 13:58:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87F541952E;
	Fri,  2 Jun 2023 13:58:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0AD8476
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 13:58:40 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D16213E
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 06:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=DGAvQdp2LnRecmbVngrFwSy3NEdlHGXRM8xYmshC0K4=; b=bkEqwHvT2DT5md7NEzg0AmVAMY
	YwxfPEQWu9v8rO66vr3HUhwwbqR+X8fpL729Z59cYP9y7aQ2FDJZtlOfbq0OtuIagl+VKX9OVWaNt
	Ca85tf1re3ceeeoNL9ASlDKOq//a8cGSkla2jQzCDZHqjxeJrrIS437dVgLFf/WDSIyC+aODRZZn8
	s7SGqjvxgnXli9jm0jGKIRVeYDkXRfRPOIPpW8cytvaz4yPKG2YMAIWVTqms/U8fSCCjeA08IyG7H
	d7FAcnIgH7N3OjtVhQeYZO+ODpPtWZDPOO6nbdQYTz6YCib7z5HuBKg0VnePQ1h6nJK/mU1Mf9yP4
	1UU06gPA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:36554 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q55IZ-00086T-Qo; Fri, 02 Jun 2023 14:58:35 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q55IZ-00Bp4w-6V; Fri, 02 Jun 2023 14:58:35 +0100
In-Reply-To: <ZHn1cTGFtEQ1Rv6E@shell.armlinux.org.uk>
References: <ZHn1cTGFtEQ1Rv6E@shell.armlinux.org.uk>
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jose Abreu <Jose.Abreu@synopsys.com>,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 1/3] net: dsa: sja1105: allow XPCS to handle mdiodev
 lifetime
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q55IZ-00Bp4w-6V@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 02 Jun 2023 14:58:35 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Put the mdiodev after xpcs_create() so that the XPCS driver can manage
the lifetime of the mdiodev its using.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/sja1105/sja1105_mdio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
index 01f1cb719042..166fe747f70a 100644
--- a/drivers/net/dsa/sja1105/sja1105_mdio.c
+++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
@@ -417,6 +417,7 @@ static int sja1105_mdiobus_pcs_register(struct sja1105_private *priv)
 		}
 
 		xpcs = xpcs_create(mdiodev, priv->phy_mode[port]);
+		mdio_device_put(mdiodev);
 		if (IS_ERR(xpcs)) {
 			rc = PTR_ERR(xpcs);
 			goto out_pcs_free;
@@ -434,7 +435,6 @@ static int sja1105_mdiobus_pcs_register(struct sja1105_private *priv)
 		if (!priv->xpcs[port])
 			continue;
 
-		mdio_device_free(priv->xpcs[port]->mdiodev);
 		xpcs_destroy(priv->xpcs[port]);
 		priv->xpcs[port] = NULL;
 	}
@@ -457,7 +457,6 @@ static void sja1105_mdiobus_pcs_unregister(struct sja1105_private *priv)
 		if (!priv->xpcs[port])
 			continue;
 
-		mdio_device_free(priv->xpcs[port]->mdiodev);
 		xpcs_destroy(priv->xpcs[port]);
 		priv->xpcs[port] = NULL;
 	}
-- 
2.30.2


