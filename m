Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53751C4AF0
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 02:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgEEASn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 20:18:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41270 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbgEEASm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 20:18:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EsNYS4+5m7q+oRPo4EW5tPZCrhDvNhBoLFNfaZOUkjo=; b=grfaFBvY699CSFUPS8fbVW3Cg0
        nrLupL1sZGv4jBLNZMVa5siuhzj+Ty7eWlt6PbSsaTNc3s3OIPF+VCI5KO1jfUfJ+NL1o6A3UqbbG
        EoPle0rST6IY/mp0RHE+2iyIO+NMhfiIWDdXjwCEyZYRBpT99ibkq0wiwjWxVkxZPIBI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jVlID-000sGB-BE; Tue, 05 May 2020 02:18:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, michael@walle.cc,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 00/10] Ethernet Cable test support
Date:   Tue,  5 May 2020 02:18:11 +0200
Message-Id: <20200505001821.208534-1-andrew@lunn.ch>
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
https://github.com/lunn/ethtool.git feature/cable-test-v2. This also
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

 Documentation/networking/ethtool-netlink.rst |  59 +++++-
 drivers/net/phy/marvell.c                    | 202 +++++++++++++++++++
 drivers/net/phy/phy.c                        | 106 ++++++++++
 include/linux/ethtool_netlink.h              |  33 +++
 include/linux/phy.h                          |  42 ++++
 include/uapi/linux/ethtool_netlink.h         |  65 ++++++
 net/Kconfig                                  |   1 +
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/cabletest.c                      | 202 +++++++++++++++++++
 net/ethtool/netlink.c                        |   9 +-
 net/ethtool/netlink.h                        |   4 +
 11 files changed, 721 insertions(+), 4 deletions(-)
 create mode 100644 net/ethtool/cabletest.c

-- 
2.26.2

