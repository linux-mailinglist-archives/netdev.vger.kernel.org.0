Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5A5123337
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 18:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbfLQRKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 12:10:06 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:60909 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfLQRKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 12:10:05 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 0E4E81C0010;
        Tue, 17 Dec 2019 17:10:03 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        alexandre.belloni@bootlin.com, nicolas.ferre@microchip.com,
        netdev@vger.kernel.org, thomas.petazzoni@bootlin.com
Subject: [PATCH net 0/2] net: macb: fix probing of PHY not described in the dt
Date:   Tue, 17 Dec 2019 18:07:40 +0100
Message-Id: <20191217170742.1166139-1-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

The macb Ethernet driver supports various ways of referencing its
network PHY. When a device tree is used the PHY can be referenced with
a phy-handle or, if connected to its internal MDIO bus, described in
a child node. Some platforms omitted the PHY description while
connecting the PHY to the internal MDIO bus and in such cases the MDIO
bus has to be scanned "manually" by the macb driver.

Prior to the phylink conversion the driver registered the MDIO bus with
of_mdiobus_register and then in case the PHY couldn't be retrieved
using dt or using phy_find_first (because registering an MDIO bus with
of_mdiobus_register masks all PHYs) the macb driver was "manually"
scanning the MDIO bus (like mdiobus_register does). The phylink
conversion did break this particular case but reimplementing the manual
scan of the bus in the macb driver wouldn't be very clean. The solution
seems to be registering the MDIO bus based on if the PHYs are described
in the device tree or not.

There are multiple ways to do this, none is perfect. I chose to check if
any of the child nodes of the macb node was a network PHY and based on
this to register the MDIO bus with the of_ helper or not. The drawback
is boards referencing the PHY through phy-handle, would scan the entire
MDIO bus of the macb at boot time (as the MDIO bus would be registered
with mdiobus_register). For this solution to work properly
of_mdiobus_child_is_phy has to be exported, which means the patch doing
so has to be backported to -stable as well.

Another possible solution could have been to simply check if the macb
node has a child node by counting its sub-nodes. This isn't techically
perfect, as there could be other sub-nodes (in practice this should be
fine, fixed-link being taken care of in the driver). We could also
simply s/of_mdiobus_register/mdiobus_register/ but that could break
boards using the PHY description in child node as a selector (which
really would be not a proper way to do this...).

The real issue here being having PHYs not described in the dt but we
have dt backward compatibility, so we have to live with that.

Thanks,
Antoine

Antoine Tenart (2):
  of: mdio: export of_mdiobus_child_is_phy
  net: macb: fix probing of PHY not described in the dt

 drivers/net/ethernet/cadence/macb_main.c | 27 ++++++++++++++++++++----
 drivers/of/of_mdio.c                     |  3 ++-
 include/linux/of_mdio.h                  |  6 ++++++
 3 files changed, 31 insertions(+), 5 deletions(-)

-- 
2.23.0

