Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3D2258EB0
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 14:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgIAMye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 08:54:34 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40106 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728142AbgIAMuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 08:50:39 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598964628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=B57xot5d+Z91drM+Hpcp8+XcTEwxmnpriJrhtSqCEjs=;
        b=ub18kjFKZALPvWvc0acyM0duvHG7MckCm85Vkf6EbCeKwzubAtd4JSH8HzjwjHCwFjKWYA
        qTorVkv9vWNHfwyWUfuAPz2dNWY2rA8mV5XdilIFbbq8p/ffSqE/Px8Z6S55inT5bolvG5
        1WHyzg/x2bNo7AQh9jqB27wh5qDTmXKJhc7vV9zvSU7+Wl33kO+eK6yHxCEEaqxR6wb6qh
        1u7Q85WjE7a0BXa1+hdi3PzkDi3x7ZOxl7uo0F/nmbKvTkhEwtrJRZK5jxGPzDWLy+WwgB
        9o8Tiw441DXMJFsGngme84u/S49kT285wL/KD6zQDaRZaKmYkgdr3GcNro71Zw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598964628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=B57xot5d+Z91drM+Hpcp8+XcTEwxmnpriJrhtSqCEjs=;
        b=ExXfoPwAPv47+uGshvceQEmxRoq9Oe3OUdacabMaRoAcugc+lsbzzNx5zoJPFTrOlSIG06
        g/i/78Rpt7nR8eAA==
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
Subject: [PATCH v4 0/7] Hirschmann Hellcreek DSA driver
Date:   Tue,  1 Sep 2020 14:50:07 +0200
Message-Id: <20200901125014.17801-1-kurt@linutronix.de>
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
tagging protocol is leveraged. Furthermore, this driver supports PTP and
hardware timestamping.

This work is part of the AccessTSN project: https://www.accesstsn.com/

The previous versions can be found here:

 * https://lkml.kernel.org/netdev/20200618064029.32168-1-kurt@linutronix.de/
 * https://lkml.kernel.org/netdev/20200710113611.3398-1-kurt@linutronix.de/
 * https://lkml.kernel.org/netdev/20200723081714.16005-1-kurt@linutronix.de/
 * https://lkml.kernel.org/netdev/20200820081118.10105-1-kurt@linutronix.de/

Due to the changes with the compatible strings and platform data patch 2 and 7
should be re-reviewed.

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

 .../bindings/net/dsa/hellcreek.yaml           |  127 ++
 .../devicetree/bindings/vendor-prefixes.yaml  |    2 +
 drivers/net/dsa/Kconfig                       |    2 +
 drivers/net/dsa/Makefile                      |    1 +
 drivers/net/dsa/hirschmann/Kconfig            |    9 +
 drivers/net/dsa/hirschmann/Makefile           |    5 +
 drivers/net/dsa/hirschmann/hellcreek.c        | 1262 +++++++++++++++++
 drivers/net/dsa/hirschmann/hellcreek.h        |  282 ++++
 .../net/dsa/hirschmann/hellcreek_hwtstamp.c   |  479 +++++++
 .../net/dsa/hirschmann/hellcreek_hwtstamp.h   |   58 +
 drivers/net/dsa/hirschmann/hellcreek_ptp.c    |  452 ++++++
 drivers/net/dsa/hirschmann/hellcreek_ptp.h    |   76 +
 .../platform_data/hirschmann-hellcreek.h      |   22 +
 include/net/dsa.h                             |    2 +
 net/dsa/Kconfig                               |    6 +
 net/dsa/Makefile                              |    1 +
 net/dsa/tag_hellcreek.c                       |  101 ++
 17 files changed, 2887 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/hellcreek.yaml
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

