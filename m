Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F055612B7F8
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfL0Rwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:52:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:40378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728033AbfL0RnF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:43:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE35D20CC7;
        Fri, 27 Dec 2019 17:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468584;
        bh=f3gR39sLaLTGQDkCZwgsZ/tN21puVRuwxWc555VPQDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Axaf4ipGU++Ua5fj37MjQGSt3NuTbSj/aR3SCH8n8feSlpwpbRV7BgWpbENcf5a1L
         pjH2FssSujzsd+NZzE2LYzSK/R+7g5RZnkUGqr12UMaEop4z/ZnDZ21Kea/pVeGesY
         o/7L5mswj2LU1SV/ZP3wSuQVeY8MQFlcbSNUYtwA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 107/187] net: marvell: mvpp2: phylink requires the link interrupt
Date:   Fri, 27 Dec 2019 12:39:35 -0500
Message-Id: <20191227174055.4923-107-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit f3f2364ea14d1cf6bf966542f31eadcf178f1577 ]

phylink requires the MAC to report when its link status changes when
operating in inband modes.  Failure to report link status changes
means that phylink has no idea when the link events happen, which
results in either the network interface's carrier remaining up or
remaining permanently down.

For example, with a fiber module, if the interface is brought up and
link is initially established, taking the link down at the far end
will cut the optical power.  The SFP module's LOS asserts, we
deactivate the link, and the network interface reports no carrier.

When the far end is brought back up, the SFP module's LOS deasserts,
but the MAC may be slower to establish link.  If this happens (which
in my tests is a certainty) then phylink never hears that the MAC
has established link with the far end, and the network interface is
stuck reporting no carrier.  This means the interface is
non-functional.

Avoiding the link interrupt when we have phylink is basically not
an option, so remove the !port->phylink from the test.

Fixes: 4bb043262878 ("net: mvpp2: phylink support")
Tested-by: Sven Auhagen <sven.auhagen@voleatech.de>
Tested-by: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 111b3b8239e1..ef44c6979a31 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3674,7 +3674,7 @@ static int mvpp2_open(struct net_device *dev)
 		valid = true;
 	}
 
-	if (priv->hw_version == MVPP22 && port->link_irq && !port->phylink) {
+	if (priv->hw_version == MVPP22 && port->link_irq) {
 		err = request_irq(port->link_irq, mvpp2_link_status_isr, 0,
 				  dev->name, port);
 		if (err) {
-- 
2.20.1

