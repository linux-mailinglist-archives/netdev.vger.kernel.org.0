Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5098E24B0CD
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 10:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgHTIMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 04:12:21 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45272 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgHTILh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 04:11:37 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597911094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3t0JToVYaafJcseAUMAiYq9X3VvTL+kr3n0+JrP2Fi0=;
        b=chXWiN3yMgR5uM7JVy1+o8b/DUalPYZdR/7U3RfxHhmuxm1zObv/htTd6Fy3j5Z69ohG60
        8tC5v7Qjj7aFbde3BI4kHG+q3MD6ldjhcUglfQRVWma0TSPv+ZAoqua1MjVkHs9OU0+mWr
        0Fl2gZbroJVtKCjoPMhRa7rXPviAlz0993jBRNZzjTdDsI7lp2El1zyQTdSKdK6FPuEyzN
        5jYtytbBqJ5zGQbiOHq+K1SlpPT5YM+0YzQkvFrzvFezCk51KzzCWADpBDIvjL6FJ0Yk/Z
        ZK10pDyBWtKmA+UyIk9zwcS9c2haFRRUigFlBeJKiST73DL8nPDq5J6Hlm0qBA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597911094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3t0JToVYaafJcseAUMAiYq9X3VvTL+kr3n0+JrP2Fi0=;
        b=/PtYCe5Hh5dSE7SWEg3WgBOAu6W985AUVNdx5bLiQoxoU7Fyh8pgEe3gs3Wm1fIXfIPXZx
        HZTX9jIMz+hZfMDQ==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v3 0/8] Hirschmann Hellcreek DSA driver
Date:   Thu, 20 Aug 2020 10:11:10 +0200
Message-Id: <20200820081118.10105-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this series adds a DSA driver for the Hirschmann Hellcreek TSN switch
IP. Characteristics of that IP:

 * Full duplex Ethernet interface at 100/1000 Mbps on three ports
 * IEEE 802.1Q-compliant Ethernet Switch
 * IEEE 802.1Qbv Time-Aware scheduling support
 * IEEE 1588 and IEEE 802.1AS support

That IP is used e.g. in

 https://www.arrow.com/en/campaigns/arrow-kairos

Due to the hardware setup the switch driver is implemented using DSA. A special
tagging protocol is leveraged. Furthermore, this driver supports PTP, hardware
timestamping and TAPRIO offloading.

This work is part of the AccessTSN project: https://www.accesstsn.com/

The previous versions can be found here:

 * https://lkml.kernel.org/netdev/20200618064029.32168-1-kurt@linutronix.de/
 * https://lkml.kernel.org/netdev/20200710113611.3398-1-kurt@linutronix.de/
 * https://lkml.kernel.org/netdev/20200723081714.16005-1-kurt@linutronix.de/

Changes since v2:

 * Make it compile by getting all requirements merged first (Jakub Kicinski, David Miller)
 * Use "tsn" for TSN register set (Rob Herring)
 * Fix DT binding issues (Rob Herring)

Changes since v1:

 * Code simplifications (Florian Fainelli, Vladimir Oltean)
 * Fix issues with hellcreek.yaml bindings (Florian Fainelli)
 * Clear reserved field in ptp v2 event messages (Richard Cochran)
 * Make use of generic ptp parsing function (Richard Cochran, Vladimir Oltean)
 * Fix Kconfig (Florian Fainelli)
 * Add tags (Florian Fainelli, Rob Herring, Richard Cochran) 

Changes since RFC ordered by reviewers:

 * Andrew Lunn
   * Use dev_dbg for debug messages
   * Get rid of __ function names where possible
   * Use reverse xmas tree variable ordering
   * Remove redundant/useless checks
   * Improve comments e.g. for PTP
   * Fix Kconfig ordering
   * Make LED handling more generic and provide info via DT
   * Setup advertisement of PHYs according to hardware
   * Drop debugfs patch
 * Jakub Kicinski
   * Fix compiler warnings
 * Florian Fainelli
   * Switch to YAML DT bindings
 * Richard Cochran
   * Fix typo
   * Add missing NULL checks

Kamil Alkhouri (2):
  net: dsa: hellcreek: Add PTP clock support
  net: dsa: hellcreek: Add support for hardware timestamping

Kurt Kanzenbach (6):
  net: dsa: Add tag handling for Hirschmann Hellcreek switches
  net: dsa: Add DSA driver for Hirschmann Hellcreek switches
  net: dsa: hellcreek: Add TAPRIO offloading support
  net: dsa: hellcreek: Add PTP status LEDs
  dt-bindings: Add vendor prefix for Hirschmann
  dt-bindings: net: dsa: Add documentation for Hellcreek switches

 .../bindings/net/dsa/hellcreek.yaml           |  125 ++
 .../devicetree/bindings/vendor-prefixes.yaml  |    2 +
 drivers/net/dsa/Kconfig                       |    2 +
 drivers/net/dsa/Makefile                      |    1 +
 drivers/net/dsa/hirschmann/Kconfig            |    9 +
 drivers/net/dsa/hirschmann/Makefile           |    5 +
 drivers/net/dsa/hirschmann/hellcreek.c        | 1551 +++++++++++++++++
 drivers/net/dsa/hirschmann/hellcreek.h        |  301 ++++
 .../net/dsa/hirschmann/hellcreek_hwtstamp.c   |  479 +++++
 .../net/dsa/hirschmann/hellcreek_hwtstamp.h   |   58 +
 drivers/net/dsa/hirschmann/hellcreek_ptp.c    |  452 +++++
 drivers/net/dsa/hirschmann/hellcreek_ptp.h    |   76 +
 include/net/dsa.h                             |    2 +
 net/dsa/Kconfig                               |    6 +
 net/dsa/Makefile                              |    1 +
 net/dsa/tag_hellcreek.c                       |  101 ++
 16 files changed, 3171 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/hellcreek.yaml
 create mode 100644 drivers/net/dsa/hirschmann/Kconfig
 create mode 100644 drivers/net/dsa/hirschmann/Makefile
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek.c
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek.h
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek_hwtstamp.h
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek_ptp.c
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek_ptp.h
 create mode 100644 net/dsa/tag_hellcreek.c

-- 
2.20.1

