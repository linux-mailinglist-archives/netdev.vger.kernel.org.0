Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723121F831A
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 13:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgFMLbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 07:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgFMLbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jun 2020 07:31:37 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE0EC03E96F;
        Sat, 13 Jun 2020 04:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2i9hfgGNeitd7hYzWmJeqbpBgVgM1F/BZAahxCgFTeY=; b=IpELI3FfbNtHLseeTGv6y2epuB
        +iUSCoO2Q4VtWg0Miqfi06FN5SFybtWDv5YW+EJy21EsHhWEB6psWCLuOLZWr5cYIahHvNdIQqDHH
        IL9UkvoYT4EW6c6EVMP/dKsyJ6qwjYp4/Hib5wUf09Fia9IigX2QW9FkPkqhZmp7m532nJDzGDkZD
        3sFO3MAQNGnkCjG57O4LQwE4IEq5tNMKbVnVupjHhKMh0UnrAqxdrz8IDd3uMX8tIaC3w+67lJ9y/
        DFg0WzFQ4I7JdSCsSLTGLpInMrF6idgMjtVrWijgYlIEMfeFRaB3AXwnBDt7x2qaiJKrwHC9JAfzU
        uEZzu1hA==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jk4Nk-0000Zr-LO; Sat, 13 Jun 2020 12:31:28 +0100
Date:   Sat, 13 Jun 2020 12:31:28 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 0/2] net: dsa: qca8k: Improve SGMII interface handling
Message-ID: <cover.1592047530.git.noodles@earth.li>
References: <cover.1591380105.git.noodles@earth.li>
 <8ddd76e484e1bedd12c87ea0810826b60e004a65.1591380105.git.noodles@earth.li>
 <20200605183843.GB1006885@lunn.ch>
 <20200606074916.GM311@earth.li>
 <20200606083741.GK1551@shell.armlinux.org.uk>
 <20200606105909.GN311@earth.li>
 <20200608183953.GR311@earth.li>
 <cover.1591816172.git.noodles@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1591816172.git.noodles@earth.li>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hopefully getting there, thanks for all the review comments.

This 2 patch series migrates the qca8k switch driver over to PHYLINK,
and then adds the SGMII clean-ups (i.e. the missing initialisation) on
top of that as a second patch.

As before, tested with a device where the CPU connection is RGMII (i.e.
the common current use case) + one where the CPU connection is SGMII. I
don't have any devices where the SGMII interface is brought out to
something other than the CPU.

v4:
- Enable pcs_poll so we keep phylink updated when doing in-band
  negotiation
- Explicitly check for PHY_INTERFACE_MODE_1000BASEX when setting SGMII
  port mode.
- Address Vladimir's review comments
v3:
- Move phylink changes to separate patch
- Address rmk review comments
v2:
- Switch to phylink
- Avoid need for device tree configuration options

Jonathan McDowell (2):
  net: dsa: qca8k: Switch to PHYLINK instead of PHYLIB
  net: dsa: qca8k: Improve SGMII interface handling

 drivers/net/dsa/qca8k.c | 341 ++++++++++++++++++++++++++++------------
 drivers/net/dsa/qca8k.h |  13 ++
 2 files changed, 256 insertions(+), 98 deletions(-)

-- 
2.20.1

