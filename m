Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1AA41CC29A
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 18:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgEIQ3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 12:29:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50906 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726214AbgEIQ3N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 12:29:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GbU8zzepzAjhIkLhy/qgVvoTJIgZIYkgvJXM54LTTRo=; b=ynw+hjlRB8EEFnyCAac8TnFPzB
        YDtrMHf32dNn5znFVDsgdeK9LqfKTjEl2yGaVxWBPGoLIul9f6ZzGJsLg9xtvs/7Jl/RFJNFNoW7t
        Wrxz7EKnDIy1vOncKlBd68v4sEIUhW86kg4h26sh8tHoFBV9Rl58ZBh18O/Uwy9zpKnY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jXSLb-001WH3-VW; Sat, 09 May 2020 18:29:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, michael@walle.cc,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v3 00/10] Ethernet Cable test support
Date:   Sat,  9 May 2020 18:28:41 +0200
Message-Id: <20200509162851.362346-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many copper Ethernet PHY have support for performing diagnostics of
the cable. Are the cable shorted, broken, not plugged into anything at
the other end? And they can report roughly how far along the cable any
fault is.

Add infrastructure in ethtool and phylib support for triggering a
cable test and reporting the results. The Marvell 1G PHY driver is
then extended to make use of this infrastructure.

For testing, a modified ethtool(1) can be found here:
https://github.com/lunn/ethtool.git feature/cable-test-v4. This also
contains extra code for TDR dump, which will be added to the kernel in
a later patch series.

Thanks to Chris Healy for extensive testing.

v2:
See individual patches but:

Remove _REPLY messages
Change length into a u32
Grammar fixes
Rename functions for consistency
Extack for cable test already running
Remove ethnl_cable_test_act_ops
Add status attributes
Rename pairs from numbers to letters

v3:
See individual patches but:

Remove ETHTOOL_MSG_CABLE_TEST_ACT_REPLY from documentation
Remove unused cable_test_get_policy
Fixed example in document
Add ETHTOOL_A_CABLE_NEST_* enum
Add ETHTOOL_MSG_CABLE_TEST_NTF to documentation
Poison phydev->skb
Return -EMSGSIZE when ethnl_bcastmsg_put() fails
Return valid error code when nla_nest_start() fails
Use u8 for results
Actually put u32 length into message
s/mavell/marvell/g
Remove include of <uapi/linux/ethtool_netlink.h>
EMSGSIZE when ethnl_bcastmsg_put() fails
Print an error message on failure, since this is a void function.

Andrew Lunn (10):
  net: phy: Add cable test support to state machine
  net: phy: Add support for polling cable test
  net: ethtool: netlink: Add support for triggering a cable test
  net: ethtool: Add attributes for cable test reports
  net: ethtool: Make helpers public
  net: ethtool: Add infrastructure for reporting cable test results
  net: ethtool: Add helpers for reporting test results
  net: phy: marvell: Add cable test support
  net: phy: Put interface into oper testing during cable test
  net: phy: Send notifier when starting the cable test

 Documentation/networking/ethtool-netlink.rst |  57 +++++-
 drivers/net/phy/marvell.c                    | 201 +++++++++++++++++++
 drivers/net/phy/phy.c                        | 106 ++++++++++
 include/linux/ethtool_netlink.h              |  33 +++
 include/linux/phy.h                          |  42 ++++
 include/uapi/linux/ethtool_netlink.h         |  71 +++++++
 net/Kconfig                                  |   1 +
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/cabletest.c                      | 199 ++++++++++++++++++
 net/ethtool/netlink.c                        |   9 +-
 net/ethtool/netlink.h                        |   3 +
 11 files changed, 720 insertions(+), 4 deletions(-)
 create mode 100644 net/ethtool/cabletest.c

-- 
2.26.2

