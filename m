Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA08525150B
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 11:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbgHYJJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 05:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgHYJJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 05:09:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D798C061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 02:09:37 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1kAUxS-0006Nd-47; Tue, 25 Aug 2020 11:09:34 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1kAUxR-0003yd-J3; Tue, 25 Aug 2020 11:09:33 +0200
Date:   Tue, 25 Aug 2020 11:09:33 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de
Subject: ethernet-phy-ieee802.3-c22 binding and reset-gpios
Message-ID: <20200825090933.GN13023@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:07:21 up 187 days, 16:37, 152 users,  load average: 0.21, 0.34,
 0.27
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

I am using the ethernet phy binding here that looks like:

ethphy1: ethernet-phy@1 {
	compatible = "ethernet-phy-ieee802.3-c22";
	reg = <1>;
	eee-broken-1000t;
	reset-gpios = <&gpio4 2 GPIO_ACTIVE_LOW>;
};

It seems the "reset-gpios" is inherently broken in Linux. With the above
in one way or the other we end up in of_mdiobus_register_phy() where we
have:

        if (!is_c45 && !of_get_phy_id(child, &phy_id))
                phy = phy_device_create(mdio, addr, phy_id, 0, NULL);
        else
                phy = get_phy_device(mdio, addr, is_c45);

get_phy_device() tries to read the phy_id from the MDIO bus.
Unfortunately the "reset-gpios" property is only handled later in
phy_device_register(), so it can only work when the bootloader has left
the reset GPIO deasserted.  Note it works when of_get_phy_id() returns
the phy_id, which is the case when the phy_id is explicitly given with
"ethernet-phy-idxxxx.yyyy", but giving the exact phy_id shouldn't be
mandatory, right?

I think the phy_id is unknown at phy_device_create() time, so I looked
into removing the phy_id argument there and specifying it elsewhere,
maybe by adding a phy_device_set_id() function. Another point is that
phy_device_create() currently calls phy_request_driver_module() to get
the driver modules for a given phy_id. That would have to be called
later as well. Is this the path to go or are there any other ideas how
to solve this issue?

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
