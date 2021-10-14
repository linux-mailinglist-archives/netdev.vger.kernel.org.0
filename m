Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C65E42D834
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 13:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhJNLdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 07:33:15 -0400
Received: from mx1.tq-group.com ([93.104.207.81]:12537 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230431AbhJNLdM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 07:33:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1634211067; x=1665747067;
  h=from:to:cc:subject:date:message-id;
  bh=e/k33b5iviI3LCxGlOyGY6873RDXdxSoyCGTS6Pf+wg=;
  b=Sfq1jL/KbMQf99atXFdscWTy6blTDx/eNnilm2fnZ6N0zSUFx72DsZ4J
   +4JS2kHYkPfMCEdZOqnfAT4Bjoizkx73WmrzfdQ5dB6e5ZzP2I8zAzMJq
   k/N2+SZ2jwextqm4kApL+uXwCKq/ZGJB+JhULWVUkLtmPSDGOz5QM514R
   0iOMO/3XR57ZTy8JP3lQH8rFnguoaRaoc0AkscHqdhYZVO90nPnZUhBuK
   XvnpYqjGev7DiXOi1pccu4/YlUl5bWvlqqaFqe3nPo8exrQUouVEWIOEz
   zE2fCHAVNxHZ1HbwJAUtuQfQrMYobBz//U8RW04nkCaLDp3uQMM5Yeigt
   A==;
X-IronPort-AV: E=Sophos;i="5.85,372,1624312800"; 
   d="scan'208";a="20047202"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 14 Oct 2021 13:31:03 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Thu, 14 Oct 2021 13:31:03 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Thu, 14 Oct 2021 13:31:03 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1634211063; x=1665747063;
  h=from:to:cc:subject:date:message-id;
  bh=e/k33b5iviI3LCxGlOyGY6873RDXdxSoyCGTS6Pf+wg=;
  b=B9ldJckA5MTNgesBU2w/aka80Q3SNxjgiLqp6wTCIrprMU3Ure6TnNm8
   oCOgKOU/IrTr+AFdThIOm3D/0TvSaJLpR9JdqjBSDwsm246hXBqTOzi7B
   cEItQ2akCcVrE1Cqg98kq4ybmeAaiAAX/5beG0ko5tm2oAyvWeo7rkSHD
   X0JB0P6NTdmBlh21X5yDTRkxPVlCOqKwFSoON/bf9FU2ulBkHWXEgpFMk
   LrCcaHdKk+kVRrKU7mCliL3zQ6Y+2CMCvasv50KwvAX3ln+fTPNXfMxvm
   Gc1X4VDM4USZx4EMAHlPoMayUgX0+199h08nywYNqCCF45tN2Q0eJU10I
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,372,1624312800"; 
   d="scan'208";a="20047198"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 14 Oct 2021 13:31:03 +0200
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.121.48.12])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 97C73280065;
        Thu, 14 Oct 2021 13:31:01 +0200 (CEST)
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [PATCH] net: fec: defer probe if PHY on external MDIO bus is not available
Date:   Thu, 14 Oct 2021 13:30:43 +0200
Message-Id: <20211014113043.3518-1-matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some SoCs like i.MX6UL it is common to use the same MDIO bus for PHYs
on both Ethernet controllers. Currently device trees for such setups
have to make assumptions regarding the probe order of the controllers:

For example in imx6ul-14x14-evk.dtsi, the MDIO bus of fec2 is used for
the PHYs of both fec1 and fec2. The reason is that fec2 has a lower
address than fec1 and is thus loaded first, so the bus is already
available when fec1 is probed.

Besides being confusing, this limitation also makes it impossible to use
the same device tree for variants of the i.MX6UL with one Ethernet
controller (which have to use the MDIO of fec1, as fec2 does not exist)
and variants with two controllers (which have to use fec2 because of the
load order).

To fix this, defer the probe of the Ethernet controller when the PHY is
not on our own MDIO bus and not available.

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 47a6fc702ac7..dc070dd216e8 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3820,7 +3820,28 @@ fec_probe(struct platform_device *pdev)
 		goto failed_stop_mode;
 
 	phy_node = of_parse_phandle(np, "phy-handle", 0);
-	if (!phy_node && of_phy_is_fixed_link(np)) {
+	if (phy_node) {
+		struct device_node *mdio_parent =
+			of_get_next_parent(of_get_parent(phy_node));
+
+		ret = 0;
+
+		/* Skip PHY availability check for our own MDIO bus to avoid
+		 * cyclic dependency
+		 */
+		if (mdio_parent != np) {
+			struct phy_device *phy = of_phy_find_device(phy_node);
+
+			if (phy)
+				put_device(&phy->mdio.dev);
+			else
+				ret = -EPROBE_DEFER;
+		}
+
+		of_node_put(mdio_parent);
+		if (ret)
+			goto failed_phy;
+	} else if (of_phy_is_fixed_link(np)) {
 		ret = of_phy_register_fixed_link(np);
 		if (ret < 0) {
 			dev_err(&pdev->dev,
-- 
2.17.1

