Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5413A1DF126
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 23:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731068AbgEVVbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 17:31:07 -0400
Received: from foss.arm.com ([217.140.110.172]:42296 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730976AbgEVVbH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 17:31:07 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4EAB61FB;
        Fri, 22 May 2020 14:31:06 -0700 (PDT)
Received: from mammon-tx2.austin.arm.com (mammon-tx2.austin.arm.com [10.118.28.62])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 45C573F68F;
        Fri, 22 May 2020 14:31:06 -0700 (PDT)
From:   Jeremy Linton <jeremy.linton@arm.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>
Subject: [RFC 00/11] Make C45 autoprobe more robust
Date:   Fri, 22 May 2020 16:30:48 -0500
Message-Id: <20200522213059.1535892-1-jeremy.linton@arm.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It would be nice if we could depend on the c45 scanner
to identify standards complaint phys or fail cleanly
enough that we can turn around and continue probing the
bus for c22 devices.

In order to pull this off we should be looking at a larger
range of MMD addresses, as well as doing a better job of judging
if a phy appears to be responding correctly. Once that is in
place we then allow a MDIO bus to report that its c45 capable
with a c22 fallback.

So this set is really a heavy RFC, and I have my own set of
questions about it.

First, it seems like its ok to scan reserved parts of the MMD space,
given the existing code is scanning MMD 0. Should we do a better
job of blocking out the reserved areas? Or was this really what
the commit to sanitize the c22 capability was fixing (avoid a
probe at location 0).

Secondly, are there parts of the system that are depending on
"stub" MDIO devices being created?The DT code looks ok, but I
think the existing code path left open a number possibilities
where devices are created without valid IDs. The commit which
cleared the c22 capability registers from the device id list
doesn't make much sense to me except to create bugus devices
by avoiding breaking out of the devices loop early. There were
a couple other cases (all 0 device lists, device lists
reporting devices that respond as 0xFFFFFFFF to the id registers).

Do we want to probe some of the additional package id registers?

Do we want a more "strict" flag for fully compliant MDIO/PHY
combinations or are we ok with extra stub devices? The 3rd to last
set is just using the C45_FIRST flag for it.

What have I missed?

Jeremy Linton (11):
  net: phy: Don't report success if devices weren't found
  net: phy: Simplify MMD device list termination
  net: phy: refactor c45 phy identification sequence
  net: phy: Handle c22 regs presence better
  net: phy: Scan the entire MMD device space
  net: phy: Hoist no phy detected state
  net: phy: reset invalid phy reads of 0 back to 0xffffffff
  net: phy: Allow mdio buses to auto-probe c45 devices
  net: phy: Refuse to consider phy_id=0 a valid phy
  net: example acpize xgmac_mdio
  net: example xgmac enable extended scanning

 drivers/net/ethernet/freescale/xgmac_mdio.c |  28 +++--
 drivers/net/phy/mdio_bus.c                  |   9 +-
 drivers/net/phy/phy_device.c                | 112 ++++++++++++--------
 include/linux/phy.h                         |   7 +-
 4 files changed, 100 insertions(+), 56 deletions(-)

-- 
2.26.2

