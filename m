Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0541B8868
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 20:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgDYSHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 14:07:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34976 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbgDYSHA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Apr 2020 14:07:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=j0c49oFou4lXFYWm7UCeBJ8jGsK9k+t7ipIInt74rzk=; b=qr2l36BfQO9d5sqLEkBm/UIYXX
        TxuDvTa82bxL8amz5iblvT7/uHTNnBVw68bOP29MKTzBxibI+z/j8aWqvB3/7pw6uS4Wf5pzKDZgr
        zSSJc9K1YQmLW2Wu/1zddC36LgC3BL5nEIEb+p1XVJnOU3E0qX/vEW7MDCpyEOzibq40=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jSPCG-004mhP-4q; Sat, 25 Apr 2020 20:06:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v1 0/9] Ethernet Cable test support
Date:   Sat, 25 Apr 2020 20:06:12 +0200
Message-Id: <20200425180621.1140452-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.0.rc2
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

Andrew Lunn (9):
  net: phy: Add cable test support to state machine
  net: phy: Add support for polling cable test
  net: ethtool: netlink: Add support for triggering a cable test
  net: ethtool: Add attributes for cable test reports
  net: ethtool: Make helpers public
  net: ethtool: Add infrastructure for reporting cable test results
  net: ethtool: Add helpers for reporting test results
  net: phy: marvell: Add cable test support
  net: phy: Put interface into oper testing during cable test

 Documentation/networking/ethtool-netlink.rst |  53 ++++-
 drivers/net/phy/marvell.c                    | 202 +++++++++++++++++++
 drivers/net/phy/phy.c                        |  94 +++++++++
 include/linux/ethtool_netlink.h              |  33 +++
 include/linux/phy.h                          |  42 ++++
 include/uapi/linux/ethtool_netlink.h         |  59 ++++++
 net/Kconfig                                  |   1 +
 net/ethtool/Makefile                         |   2 +-
 net/ethtool/cabletest.c                      | 179 ++++++++++++++++
 net/ethtool/netlink.c                        |  10 +-
 net/ethtool/netlink.h                        |   4 +
 11 files changed, 674 insertions(+), 5 deletions(-)
 create mode 100644 net/ethtool/cabletest.c

-- 
2.26.1

