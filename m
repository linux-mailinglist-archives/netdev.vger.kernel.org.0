Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D78B21B414
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 13:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgGJLg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 07:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbgGJLg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 07:36:28 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C280CC08C5CE;
        Fri, 10 Jul 2020 04:36:27 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594380985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=kW5iQKvueihTm+gqITX1I5662N3JykpJnqULwrfoYXg=;
        b=F3UW57HiPJVUzuaUa7iGjFBjr29/zjLFDHfAHUH54Sf8dHydlkCvr4QehzsrrUcpVB/5wi
        QYdRN8FOciXhOxno5cQTTfgGtMRwcydodmLOzgws/65EP4Dwr57Qyfu8hQpGE5mFcWrDZg
        uK7+uaTUlQfF8PO69NeUt5HHgf6QlpAc+YnP238IF6aCOxeCJq2ASiWKeDQvo3gXxUak8N
        vLpmrf9KXZ2IoEIJ4id+sPf8aeYPv9W56jk0lyxC8uOsOxrtRzNhGZ8eEtyPSclpf1DvaQ
        8211QUtvlk2UarVynT5ytiUn0BYoINrBNgBJwLRDhMHsvdxmWs/FG0NN1Bzitw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594380985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=kW5iQKvueihTm+gqITX1I5662N3JykpJnqULwrfoYXg=;
        b=j7UAB4Qw9a9cPHPk+Fhn0Xn6AOJxkO0vr98THZKvUbxSsYA20Kiis8LVUBl9aKTmrkUUn0
        oBF+1nNTBcDQXEAw==
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
Subject: [PATCH v1 0/8] Hirschmann Hellcreek DSA driver
Date:   Fri, 10 Jul 2020 13:36:03 +0200
Message-Id: <20200710113611.3398-1-kurt@linutronix.de>
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

The RFC version can be found here:

 https://lkml.kernel.org/netdev/20200618064029.32168-1-kurt@linutronix.de/

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

And two problems I found myself:

 * Fix reg property in DT
 * Fix wrong comments

Please note, that this series depends on

 https://lkml.kernel.org/netdev/20200710090618.28945-2-kurt@linutronix.de/

Tested on top of 5.8.0-rc2.

Thanks,
Kurt

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

 .../bindings/net/dsa/hellcreek.yaml           |  132 ++
 .../devicetree/bindings/vendor-prefixes.yaml  |    2 +
 drivers/net/dsa/Kconfig                       |    2 +
 drivers/net/dsa/Makefile                      |    1 +
 drivers/net/dsa/hirschmann/Kconfig            |    7 +
 drivers/net/dsa/hirschmann/Makefile           |    5 +
 drivers/net/dsa/hirschmann/hellcreek.c        | 1555 +++++++++++++++++
 drivers/net/dsa/hirschmann/hellcreek.h        |  301 ++++
 .../net/dsa/hirschmann/hellcreek_hwtstamp.c   |  498 ++++++
 .../net/dsa/hirschmann/hellcreek_hwtstamp.h   |   58 +
 drivers/net/dsa/hirschmann/hellcreek_ptp.c    |  452 +++++
 drivers/net/dsa/hirschmann/hellcreek_ptp.h    |   76 +
 include/net/dsa.h                             |    2 +
 net/dsa/Kconfig                               |    6 +
 net/dsa/Makefile                              |    1 +
 net/dsa/tag_hellcreek.c                       |  101 ++
 16 files changed, 3199 insertions(+)
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

