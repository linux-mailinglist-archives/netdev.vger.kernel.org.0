Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828CA1DFFCD
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 17:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387483AbgEXP2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 11:28:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46960 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729533AbgEXP2J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 May 2020 11:28:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vN7s7qS/vdEkIY/D3Q0MeoGAnxLr6aSqLVg8EE1JxC0=; b=BI5v4AIUbJZXGNWh5Dbmyk6fqw
        9goB8kcrTsmNFjeNF6bwVWYF4NmvmTnqwJE7Iq7VqM/bagatWOETveFd/9f689+UNWHqKwijo6kVv
        psUcyWYjIQ0pNAaIgXK45bMFAAn028w8YY2pxGtFfVCobs6J7F+VPHRAs1iLQlzh8J4M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jcsXk-00383H-Tm; Sun, 24 May 2020 17:28:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 net-next 0/6] Raw PHY TDR data
Date:   Sun, 24 May 2020 17:27:40 +0200
Message-Id: <20200524152747.745893-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some ethernet PHYs allow access to raw TDR data in addition to summary
diagnostics information. Add support for retrieving this data via
netlink ethtool. The basic structure in the core is the same as for
normal phy diagnostics, the PHY driver simply uses different helpers
to fill the netlink message with different data.

There is a graphical tool under development, as well a ethtool(1)
which can dump the data as text and JSON.

A patched ethtool(1) can be found in
https://github.com/lunn/ethtool.git feature/cable-test-v5

Thanks for Chris Healy for lots of testing.

v2:
See the individual patches but:

Pass distances in centimeters, not meters

Allow the PHY to round distances to what it supports and report what
it actually used along with the results.

Make the Marvell PHY use steps a multiple of 0.805 meters, its native
step size.

Andrew Lunn (6):
  net: ethtool: Add attributes for cable test TDR data
  net: ethtool: Add generic parts of cable test TDR
  net: ethtool: Add helpers for cable test TDR data
  net: phy: marvell: Add support for amplitude graph
  net: ethtool: Allow PHY cable test TDR data to configured
  net : phy: marvell: Speedup TDR data retrieval by only changing page
    once

 Documentation/networking/ethtool-netlink.rst |  81 ++++++
 drivers/net/phy/marvell.c                    | 286 ++++++++++++++++++-
 drivers/net/phy/nxp-tja11xx.c                |   2 +-
 drivers/net/phy/phy.c                        |  67 ++++-
 include/linux/ethtool_netlink.h              |  25 +-
 include/linux/phy.h                          |  17 ++
 include/uapi/linux/ethtool_netlink.h         |  67 +++++
 net/ethtool/cabletest.c                      | 209 +++++++++++++-
 net/ethtool/netlink.c                        |   5 +
 net/ethtool/netlink.h                        |   1 +
 10 files changed, 747 insertions(+), 13 deletions(-)

-- 
2.27.0.rc0

