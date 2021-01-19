Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4024F2FBB78
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390765AbhASPm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390457AbhASPhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 10:37:24 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E25C0613D6
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 07:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xiUw7WPcQ49fQsnFrltCMsYbO37iQiMI564Mw+zru0I=; b=H/sOtaK+Aw1TVmzkAlmYyuX7ZF
        4Oo0aGMoOoQeuRVYHYzvGmsFA3bHSHDk57ZBDOv0VRRJsvi79UkuLVQHA9AGD7kczG3QJx16jgG2+
        me1OFbefIsi3b1fM7zSgX1s+rDRdWi2mls5ZMGhFl0jfmIDPzRPU9ndkNUPdlLBPQNE/7OhJv7XIf
        CEt7yplm34O1MPNj6wKlNem3ZEA8CnmNbUnil+gtGaygs7svXzPdbyaQvQs4dkSU+QLFf2Z7NRffR
        1sc3NH5WJE9gdVO+qn+Xyy3rXAEcLoRDyoRoAmCaHHLHgRD9Tukc1nqSSCdvCunZmwxDI//a27dx8
        qkyS3AQw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:38346 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1l1t3B-0007cg-8z; Tue, 19 Jan 2021 15:36:09 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1l1t3B-0005Vn-2N; Tue, 19 Jan 2021 15:36:09 +0000
In-Reply-To: <20210119153545.GK1551@shell.armlinux.org.uk>
References: <20210119153545.GK1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 3/3] net: dpaa2-mac: add backplane link mode support
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1l1t3B-0005Vn-2N@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 19 Jan 2021 15:36:09 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for backplane link mode, which is, according to discussions
with NXP earlier in the year, is a mode where the OS (Linux) is able to
manage the PCS and Serdes itself.

This commit prepares the ground work for allowing 1G fiber connections
to be used with DPAA2 on the SolidRun CEX7 platforms.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 3ddfb40eb5e4..ccaf7e35abeb 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -315,8 +315,9 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 		goto err_put_node;
 	}
 
-	if (mac->attr.link_type == DPMAC_LINK_TYPE_PHY &&
-	    mac->attr.eth_if != DPMAC_ETH_IF_RGMII) {
+	if ((mac->attr.link_type == DPMAC_LINK_TYPE_PHY &&
+	     mac->attr.eth_if != DPMAC_ETH_IF_RGMII) ||
+	    mac->attr.link_type == DPMAC_LINK_TYPE_BACKPLANE) {
 		err = dpaa2_pcs_create(mac, dpmac_node, mac->attr.id);
 		if (err)
 			goto err_put_node;
-- 
2.20.1

