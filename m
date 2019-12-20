Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C60301272CF
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 02:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfLTBck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 20:32:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44988 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbfLTBck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 20:32:40 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BD23A1540B58A;
        Thu, 19 Dec 2019 17:32:39 -0800 (PST)
Date:   Thu, 19 Dec 2019 17:32:39 -0800 (PST)
Message-Id: <20191219.173239.1547337917089603753.davem@davemloft.net>
To:     antoine.tenart@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        alexandre.belloni@bootlin.com, nicolas.ferre@microchip.com,
        netdev@vger.kernel.org, thomas.petazzoni@bootlin.com
Subject: Re: [PATCH net 0/2] net: macb: fix probing of PHY not described in
 the dt
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191217170742.1166139-1-antoine.tenart@bootlin.com>
References: <20191217170742.1166139-1-antoine.tenart@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Dec 2019 17:32:40 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antoine Tenart <antoine.tenart@bootlin.com>
Date: Tue, 17 Dec 2019 18:07:40 +0100

> The macb Ethernet driver supports various ways of referencing its
> network PHY. When a device tree is used the PHY can be referenced with
> a phy-handle or, if connected to its internal MDIO bus, described in
> a child node. Some platforms omitted the PHY description while
> connecting the PHY to the internal MDIO bus and in such cases the MDIO
> bus has to be scanned "manually" by the macb driver.
> 
> Prior to the phylink conversion the driver registered the MDIO bus with
> of_mdiobus_register and then in case the PHY couldn't be retrieved
> using dt or using phy_find_first (because registering an MDIO bus with
> of_mdiobus_register masks all PHYs) the macb driver was "manually"
> scanning the MDIO bus (like mdiobus_register does). The phylink
> conversion did break this particular case but reimplementing the manual
> scan of the bus in the macb driver wouldn't be very clean. The solution
> seems to be registering the MDIO bus based on if the PHYs are described
> in the device tree or not.
> 
> There are multiple ways to do this, none is perfect. I chose to check if
> any of the child nodes of the macb node was a network PHY and based on
> this to register the MDIO bus with the of_ helper or not. The drawback
> is boards referencing the PHY through phy-handle, would scan the entire
> MDIO bus of the macb at boot time (as the MDIO bus would be registered
> with mdiobus_register). For this solution to work properly
> of_mdiobus_child_is_phy has to be exported, which means the patch doing
> so has to be backported to -stable as well.
> 
> Another possible solution could have been to simply check if the macb
> node has a child node by counting its sub-nodes. This isn't techically
> perfect, as there could be other sub-nodes (in practice this should be
> fine, fixed-link being taken care of in the driver). We could also
> simply s/of_mdiobus_register/mdiobus_register/ but that could break
> boards using the PHY description in child node as a selector (which
> really would be not a proper way to do this...).
> 
> The real issue here being having PHYs not described in the dt but we
> have dt backward compatibility, so we have to live with that.

Series applied, thanks Antoine.
