Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8331FAA8C
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 09:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgFPH4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 03:56:12 -0400
Received: from mail.intenta.de ([178.249.25.132]:38630 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726747AbgFPH4D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 03:56:03 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jun 2020 03:56:02 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date; bh=PNZ7NtMf3xXLQ+yBO/wjiY8ZQUlLRCVcwPbjOsCsmPA=;
        b=hK5N1ZZREg5On5XBnl+L87sUsehslutzEMPeEZ8892vhizcG0DlPNerdI0cmyEly2gLcTjDshEkTK0DNC1EKz/SZzxXBfsDXwqBH1+MGfexFseUOEWdipiap3AWPGta4X/kxB4aOSLLxDtWSAImQu0QXeQs2/v7TNdX5qGK+hJ8vKw88pkqWZK8bfUGSLZvTR6W6oiqTf8/7FDu7tfbs2hkq9wHuJGfIW6pkuL+hoN3pL+XpURK9OtIz1Q2o8r+yvZqfkRce7ty+K/GmIXHzATKhlh1CK0Ba1d0THt4ccf+xSnybAh1QCN+iJDfpd+vJ8txxWQr+JuF6eoHSxFuflQ==;
Date:   Tue, 16 Jun 2020 09:49:56 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH] net: macb: reject unsupported rgmii delays
Message-ID: <20200616074955.GA9092@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The macb driver does not support configuring rgmii delays. At least for
the Zynq GEM, delays are not supported by the hardware at all. However,
the driver happily accepts and ignores any such delays.

When operating in a mac to phy connection, the delay setting applies to
the phy. Since the MAC does not support delays, the phy must provide
them and the only supported mode is rgmii-id.  However, in a fixed mac
to mac connection, the delay applies to the mac itself. Therefore the
only supported rgmii mode is rgmii.

Link: https://lore.kernel.org/netdev/20200610081236.GA31659@laureti-dev/
Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>
---
 drivers/net/ethernet/cadence/macb_main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 5b9d7c60eebc..bee5bf65e8b3 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -514,7 +514,7 @@ static void macb_validate(struct phylink_config *config,
 	    state->interface != PHY_INTERFACE_MODE_RMII &&
 	    state->interface != PHY_INTERFACE_MODE_GMII &&
 	    state->interface != PHY_INTERFACE_MODE_SGMII &&
-	    !phy_interface_mode_is_rgmii(state->interface)) {
+	    state->interface != PHY_INTERFACE_MODE_RGMII_ID) {
 		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
 		return;
 	}
@@ -694,6 +694,13 @@ static int macb_phylink_connect(struct macb *bp)
 	struct phy_device *phydev;
 	int ret;
 
+	if (of_phy_is_fixed_link(dn) &&
+	    phy_interface_mode_is_rgmii(bp->phy_interface) &&
+	    bp->phy_interface != PHY_INTERFACE_MODE_RGMII) {
+		netdev_err(dev, "RGMII delays are not supported\n");
+		return -EINVAL;
+	}
+
 	if (dn)
 		ret = phylink_of_phy_connect(bp->phylink, dn, 0);
 
-- 
2.20.1

