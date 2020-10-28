Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8392C29E185
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbgJ2CBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727822AbgJ1Vt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:49:28 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669B4C0613CF;
        Wed, 28 Oct 2020 14:49:28 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603870979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FSkdic7cx8rzeKxe0LlJxDOGlxIlhy5vc4K40zvdZTg=;
        b=Oqwr9pfRlCXRSRWDYQR8uXSxuYFhHOKJ9XYRhjlKXMDLiZScxYfs16Sp96ggHkxHpM2tGf
        zNZPi3cAFI1BLn+/cdy8IrIq6vUw7qMZRgZcY1V1EEtuCY9Vohtxt97x2zPNH4JwzVSCtk
        Tw7dUxNpXpiSAG4YnsoM24y+ozN8okLS3xf5p3JYS3BoQQQXd3NhKbxEFB3mg3j1esE+pa
        H+GvdIjH9BJ8ouaU71ig65UXKX9DCUEUSeUTXDvIv1sxuZdxIkrj3QN4Wd/80AdQVG4iuT
        5oeapFjkZTHSUS1oxgd+5rVeU2jRlotJgLxsNI812JtCEE/6NqMVD51648kn5w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603870979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FSkdic7cx8rzeKxe0LlJxDOGlxIlhy5vc4K40zvdZTg=;
        b=9moackIDOAVU9zGaDK4F4rrovCPOdIfVrTMVPawfGXEJ2bx0gP6NkX31V/L0MIHXg0P5uV
        p9Z5WyvFm1mw38DQ==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next v7 0/8] Hirschmann Hellcreek DSA driver
Date:   Wed, 28 Oct 2020 08:42:13 +0100
Message-Id: <20201028074221.29326-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
tagging protocol is leveraged. Furthermore, this driver supports PTP and
hardware timestamping.

This work is part of the AccessTSN project: https://www.accesstsn.com/

The previous versions can be found here:

 * https://lkml.kernel.org/netdev/20200618064029.32168-1-kurt@linutronix.de/
 * https://lkml.kernel.org/netdev/20200710113611.3398-1-kurt@linutronix.de/
 * https://lkml.kernel.org/netdev/20200723081714.16005-1-kurt@linutronix.de/
 * https://lkml.kernel.org/netdev/20200820081118.10105-1-kurt@linutronix.de/
 * https://lkml.kernel.org/netdev/20200901125014.17801-1-kurt@linutronix.de/
 * https://lkml.kernel.org/netdev/20200904062739.3540-1-kurt@linutronix.de/
 * https://lkml.kernel.org/netdev/20201004112911.25085-1-kurt@linutronix.de/

Changes since v6:

 * Add .tail_tag = true (Vladimir Oltean)
 * Fix vlan_filtering=0 bridges (Vladimir Oltean)
 * Enforce restrictions (Vladimir Oltean)
 * Sort stuff alphabetically (Vladimir Oltean)
 * Rename hellcreek.yaml to hirschmann,hellcreek.yaml
 * Typo fixes

Changes since v5:

 * Implement configure_vlan_while_not_filtering behavior (Vladimir Oltean)
 * Minor cleanups

Changes since v4:

 * Fix W=1 compiler warnings (kernel test robot)
 * Add tags

Changes since v3:

 * Drop TAPRIO support (David Miller)
   => Switch to mutexes due to the lack of hrtimers
 * Use more specific compatible strings and add platform data (Andrew Lunn)
 * Fix Kconfig ordering (Andrew Lunn)

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

Kurt Kanzenbach (5):
  net: dsa: Add tag handling for Hirschmann Hellcreek switches
  net: dsa: Add DSA driver for Hirschmann Hellcreek switches
  net: dsa: hellcreek: Add PTP status LEDs
  dt-bindings: Add vendor prefix for Hirschmann
  dt-bindings: net: dsa: Add documentation for Hellcreek switches

Vladimir Oltean (1):
  net: dsa: Give drivers the chance to veto certain upper devices

 .../net/dsa/hirschmann,hellcreek.yaml         |  127 ++
 .../devicetree/bindings/vendor-prefixes.yaml  |    2 +
 drivers/net/dsa/Kconfig                       |    2 +
 drivers/net/dsa/Makefile                      |    1 +
 drivers/net/dsa/hirschmann/Kconfig            |    9 +
 drivers/net/dsa/hirschmann/Makefile           |    5 +
 drivers/net/dsa/hirschmann/hellcreek.c        | 1339 +++++++++++++++++
 drivers/net/dsa/hirschmann/hellcreek.h        |  286 ++++
 .../net/dsa/hirschmann/hellcreek_hwtstamp.c   |  479 ++++++
 .../net/dsa/hirschmann/hellcreek_hwtstamp.h   |   58 +
 drivers/net/dsa/hirschmann/hellcreek_ptp.c    |  452 ++++++
 drivers/net/dsa/hirschmann/hellcreek_ptp.h    |   76 +
 .../platform_data/hirschmann-hellcreek.h      |   23 +
 include/net/dsa.h                             |    8 +
 net/dsa/Kconfig                               |    6 +
 net/dsa/Makefile                              |    1 +
 net/dsa/slave.c                               |   12 +
 net/dsa/tag_hellcreek.c                       |  102 ++
 18 files changed, 2988 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
 create mode 100644 drivers/net/dsa/hirschmann/Kconfig
 create mode 100644 drivers/net/dsa/hirschmann/Makefile
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek.c
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek.h
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek_hwtstamp.h
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek_ptp.c
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek_ptp.h
 create mode 100644 include/linux/platform_data/hirschmann-hellcreek.h
 create mode 100644 net/dsa/tag_hellcreek.c

-- 
2.20.1

