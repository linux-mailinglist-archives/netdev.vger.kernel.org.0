Return-Path: <netdev+bounces-8821-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7662D725DE9
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:01:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D3D491C20E80
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CCBA33CAC;
	Wed,  7 Jun 2023 11:59:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FCF33CAA
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:59:14 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0961BF0
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 04:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=cagB9HkYNCjDvU0Ds67MN7diWiRA2eRFcBXfjV/Krrw=; b=p8S/MuGQ7CjkfeV0qcB0yVKlLf
	uPgokmiSl1lLiU8ENlUHahh03d3bV6I1p3he3Tbst8aL7NdVPm3mO0UyjFww4u6Xyl2xs0lZ8MLyV
	bQs1TlqIF5pIkWLVB6o5PZDJh1ld6Q47yNHqgI47SjrLPAnuaGyHOgJA3kcez+8qKOuTnTZDQs4hx
	3KdWjrbTh1nEXNuKmkUk24wLhToMTJkH+O9HSAIveFBj6JxbJextKtb++TBWF5peiRqtm38DXNLG/
	66cQYXfNBchs0wOxGPlIg9JIPUhAQJX0FUUxG3wXUgZhvwrwJk26VpXK2iTs96UlQ2AI/jhbTVqjR
	1eaAbazA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:47176 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q6roa-0007ND-Cw; Wed, 07 Jun 2023 12:59:00 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q6roZ-00Cfb0-QA; Wed, 07 Jun 2023 12:58:59 +0100
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
Subject: [PATCH net-next v2 10/11] net: dpaa2: use pcs-lynx's check for fwnode
 availability
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q6roZ-00Cfb0-QA@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Wed, 07 Jun 2023 12:58:59 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use pcs-lynx's check rather than our own when determining if the device
is available.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 38e6208f9e1a..d860d9fe73af 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -257,12 +257,6 @@ static int dpaa2_pcs_create(struct dpaa2_mac *mac,
 		return 0;
 	}
 
-	if (!fwnode_device_is_available(node)) {
-		netdev_err(mac->net_dev, "pcs-handle node not available\n");
-		fwnode_handle_put(node);
-		return -ENODEV;
-	}
-
 	pcs = lynx_pcs_create_fwnode(node);
 	fwnode_handle_put(node);
 
@@ -271,6 +265,11 @@ static int dpaa2_pcs_create(struct dpaa2_mac *mac,
 		return -EPROBE_DEFER;
 	}
 
+	if (pcs == ERR_PTR(-ENODEV)) {
+		netdev_err(mac->net_dev, "pcs-handle node not available\n");
+		return PTR_ERR(pcs);
+	}
+
 	if (IS_ERR(pcs)) {
 		netdev_err(mac->net_dev,
 			   "lynx_pcs_create_fwnode() failed: %pe\n", pcs);
-- 
2.30.2


