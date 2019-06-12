Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 509CA42BC7
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408064AbfFLQHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:07:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49336 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406078AbfFLQHB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 12:07:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version
        :Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/9uuFVYcaw6wHEo4cYPrf1BlphLkBYSevvfNqIsbzSg=; b=XGSLCFuA5DczThvjsHWi8G/mKz
        S+CVngMWnQJQ1MTQjTzRdlV/O7Su6r07yS31TM+O9VuPdNtbCCBHrx7Hd9G2C3d5L/0RDLOCqFNVj
        0fILnvWdV6qOnFh2nwThvVODUVZrMlBd5TMBvzYw/9C3Gua4AzKxFNBuRjF9yXMi/Hkk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hb5lC-00068E-Sq; Wed, 12 Jun 2019 18:06:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Raju.Lakkaraju@microchip.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RFC 00/13] Ethernet PHY cable test support
Date:   Wed, 12 Jun 2019 18:05:21 +0200
Message-Id: <20190612160534.23533-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds support for executing Ethernet PHY cable tests and
reporting the results back to user space. The Marvell PHY driver has
been extended so some of its cable test features can be used.

It builds upon the work of Michal Kubecek adding a netlink version of
ethtool. As such, that work needs to be merged first. However, with
Microchip posting their cable test work, i thought it a good idea to
post what i have.

A few examples:

./ethtool --cable-test lan6
Cable test for device lan6.
Pair: 0, result: OK
Pair: 1, result: OK
Pair: 2, result: OK
Pair: 3, result: OK

./ethtool --cable-test lan2
Cable test for device lan2.
Pair: 0, result: Open Circuit
Pair: 1, result: Open Circuit
Pair: 2, result: Open Circuit
Pair: 3, result: Open Circuit
Pair: 0, fault length: 14.40m
Pair: 1, fault length: 15.20m
Pair: 2, fault length: 14.40m
Pair: 3, fault length: 15.20m

./ethtool --cable-test lan5
Cable test for device lan5.
Pair: 0, result: OK
Pair: 1, result: OK
Pair: 2, result: Short within Pair
Pair: 3, result: Short within Pair
Pair: 2, fault length: 1.60m
Pair: 3, fault length: 0.80m

./ethtool --cable-test lan2 amplitude-graph
Cable test for device lan2.
Cable test Pulse: 1000mV
  Distance     Pair 0     Pair 1     Pair 2     Pair 3
         0       109         85         39         62
         1       -15         46         -7         31
         2         7          0          0         -7
         3         7          7          0         15
         4        15          7          7         15
         5        23          0          0          7
         6        15          0          0          7
         7        23          0          0          0
         8         7          0          0          7
         9         0          0          0          0
        10         0          0          0          0
        11         0          0          0          7
        12        -7          0          0          0
        13        -7          0         31          7
        14       359        140        273          7
        15       523        523        609        515
        16       601        570        632        585
        17       640        617        648        625
        18       562        625        179        640
        19       109        265         78        148
        20        85         93         70         70
        21        54         54         39         54
        22        46         46         31         39
        23        39         31         23         31
        24        15         23         15         23
        25         7         15         15         15
        26         0         15          7         15
        27         0          7          7          7
        28         0          7          7          7
        29         0          7          7          0
        30         7          0          7          0
        31         7          7          7          0
        32        -7          0        -23          7
        33       -15        -31        -39        -15
        34       -31        -39        -46        -23
        35       -39        -46        -39        -23
        36       -39        -46        -31        -39
        37       -23        -23        -23        -23
        38       -23        -23        -15        -15
        39       -15        -23        -15        -15


Andrew Lunn (13):
  net: phy: Add cable test support to state machine
  net: phy: Add support for polling cable test
  net: ethtool: netlink: Add support for triggering a cable test
  net: ethtool: Add Properties for cable test reports.
  net: ethtool: Make helpers public
  net: phy: Add infrastructure for reporting cable test results
  net: phy: cable test: Use request seq in broadcast reply
  net: phy: Add helpers for reporting test results
  net: phy: marvell: Add cable test support
  net: phy: Allow options to be passed to the cable test
  net: phy: Add helpers and attributes for amplitude graph
  net: phy: marvell: Add support for amplitude graph
  net: phy: Put interface into oper testing during cable test

 drivers/net/phy/Kconfig              |   1 +
 drivers/net/phy/marvell.c            | 374 +++++++++++++++++++++++++++
 drivers/net/phy/phy.c                | 215 +++++++++++++++
 include/linux/ethtool_netlink.h      |  12 +
 include/linux/phy.h                  |  49 ++++
 include/uapi/linux/ethtool_netlink.h |  87 +++++++
 net/ethtool/actions.c                |  84 ++++++
 net/ethtool/netlink.c                |  14 +-
 net/ethtool/netlink.h                |   7 +-
 9 files changed, 838 insertions(+), 5 deletions(-)

-- 
2.20.1

