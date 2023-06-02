Return-Path: <netdev+bounces-7467-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DBAA2720673
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:45:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87B6B2818BB
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 15:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEA141B904;
	Fri,  2 Jun 2023 15:45:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B384D1B8FF
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 15:45:24 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800B318C
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 08:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
	In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=6XT/c6RL/Um314yTeMdsQ9hJbpiyUNgu45sdtdubkbk=; b=xhfWlmZI+/kWn9sd5VeFUN8xC5
	Z2Ha4/gdYxyBJodEM5MmXiDMxU+iL1Qm1JnIRJL+8hT4/HY7+yf5qHLpQpjW07sSZ/7B3PL1rDWIH
	E2MRE/Gs1N3uokw6KgaWAHGSiEOo+nmIksixZlzeUJiLrujUKcVN4IC61Lvl52O4defn9Y/QuGqjI
	Ku1tRUD0JdbiJKAt1iL4sOrhZr1nZKlYOK45ADk7vxRZmhfLj/xCp4JaH5JybCHSRdpLvheWZobd3
	RTaHKbybOrqgsTNfeV73T+wjmEd6P1cwtqDGgm0MyTHlkkQI3piydp0ZrRlveEH2lyZ5XurfDoO/K
	rDfrM/cw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52442 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q56xr-0008DO-UC; Fri, 02 Jun 2023 16:45:19 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q56xr-00Bsua-Bg; Fri, 02 Jun 2023 16:45:19 +0100
In-Reply-To: <ZHoOe9K/dZuW2pOe@shell.armlinux.org.uk>
References: <ZHoOe9K/dZuW2pOe@shell.armlinux.org.uk>
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
Subject: [PATCH net-next 2/8] net: fman_memac: allow lynx PCS to handle
 mdiodev lifetime
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q56xr-00Bsua-Bg@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Fri, 02 Jun 2023 16:45:19 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Put the mdiodev after lynx_pcs_create() so that the Lynx PCS driver
can manage the lifetime of the mdiodev its using.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/freescale/fman/fman_memac.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 625c79d5636f..8f45caf4af12 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -976,14 +976,10 @@ static int memac_init(struct fman_mac *memac)
 
 static void pcs_put(struct phylink_pcs *pcs)
 {
-	struct mdio_device *mdiodev;
-
 	if (IS_ERR_OR_NULL(pcs))
 		return;
 
-	mdiodev = lynx_get_mdio_device(pcs);
 	lynx_pcs_destroy(pcs);
-	mdio_device_free(mdiodev);
 }
 
 static int memac_free(struct fman_mac *memac)
@@ -1055,8 +1051,7 @@ static struct phylink_pcs *memac_pcs_create(struct device_node *mac_node,
 		return ERR_PTR(-EPROBE_DEFER);
 
 	pcs = lynx_pcs_create(mdiodev);
-	if (!pcs)
-		mdio_device_free(mdiodev);
+	mdio_device_put(mdiodev);
 
 	return pcs;
 }
-- 
2.30.2


