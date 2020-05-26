Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1081E3258
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404301AbgEZWV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:21:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50574 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389638AbgEZWV5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 18:21:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fZSMbTmcaGBorLrmZ7jfTGv/f6VkZ/gyP0gO1IOBftI=; b=aawaYURcJ0laidBcMAI6itKXxc
        DHFZthcbSRTuI6TPA2IAlqo6lz1qc6NuBFZd1ET82KmrTY5a6asaP3A4r7hbJ3CLZ6yqZoFSraEss
        9D1WTsSDl/vc5jsxitnE42CpGhOSGvGJ58ZuvyQvLrF5Umke3oHuWbk7D5PkoMAwmjzM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdhxK-003KSw-0R; Wed, 27 May 2020 00:21:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 net-next 0/7] Raw PHY TDR data
Date:   Wed, 27 May 2020 00:21:36 +0200
Message-Id: <20200526222143.793613-1-andrew@lunn.ch>
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

v3:
Move the TDR configuration into a structure
Add a range check on step
Use NL_SET_ERR_MSG_ATTR() when appropriate
Move TDR configuration into a nest
Document attributes in the request
Unsquash the last two patches

Andrew Lunn (7):
  net: ethtool: Add attributes for cable test TDR data
  net: ethtool: Add generic parts of cable test TDR
  net: ethtool: Add helpers for cable test TDR data
  net: phy: marvell: Add support for amplitude graph
  net: ethtool: Allow PHY cable test TDR data to configured
  net : phy: marvell: Speedup TDR data retrieval by only changing page
    once
  net: phy: marvell: Configure TDR pulse based on measurement length

 Documentation/networking/ethtool-netlink.rst |  97 +++++++
 drivers/net/phy/marvell.c                    | 285 ++++++++++++++++++-
 drivers/net/phy/nxp-tja11xx.c                |   2 +-
 drivers/net/phy/phy.c                        |  66 ++++-
 include/linux/ethtool_netlink.h              |  25 +-
 include/linux/phy.h                          |  28 ++
 include/uapi/linux/ethtool_netlink.h         |  76 +++++
 net/ethtool/cabletest.c                      | 246 +++++++++++++++-
 net/ethtool/netlink.c                        |   5 +
 net/ethtool/netlink.h                        |   1 +
 10 files changed, 818 insertions(+), 13 deletions(-)

-- 
2.27.0.rc0

