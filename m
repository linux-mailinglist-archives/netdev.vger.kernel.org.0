Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C98E9045F
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 17:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbfHPPIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 11:08:44 -0400
Received: from mail.nic.cz ([217.31.204.67]:32850 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727245AbfHPPIl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 11:08:41 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 948DC140C8F;
        Fri, 16 Aug 2019 17:08:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1565968118; bh=ltTcSgxde7BWnfxdV9fBtHAqygIMAqiHT4sxlBSwc0g=;
        h=From:To:Date;
        b=PQ6ZyMpBPcdTVTJXdQcXMn3+KsoKUswnRG8LvUyKmYB64rWBET2EvV3SWxeZJjuGw
         F5Seu0C1HNVCfdTELwKp8aF1SLNK4QMybRHK9mDpEbI4QMgw7+5MteFWhjJGwN5Ivl
         czWAijbB9iZtSJGmQO5mYBHGoNJ+s1+j25RSnUbY=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH RFC net-next 0/3] mv88e6xxx: setting 2500base-x mode for CPU/DSA port in dts
Date:   Fri, 16 Aug 2019 17:08:31 +0200
Message-Id: <20190816150834.26939-1-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I am preparing device tree for Turris Mox, and am encountering the
question of how to properly tell in DTS that a specific port is
connected to the cpu via 2500base-x mode.

CPU port is connected to eth1. In eth1, I simply have
  &eth1 {
    phy-mode = "2500base-x";
    managed = "in-band-status";
  };

This does not work for the CPU/DSA ports though, because of how phylink
and mv88e6xxx operate. CPU/DSA ports SERDES is enabled from
mv88e6xxx_setup(). SERDES irq is not enabled for there ports. Enabling
SERDES irq for there ports cannot be done from mv88e6xxx_setup(),
because the IRQ may fire immediately after enablement, and the phylink
structures do not exist yet for there ports (they are create by DSA only
after the .setup() method is called).

One way to make it work is to use fixed-link for there ports, with
speed = <2500>. But looking at the mv88e6xxx driver I discovered that
this works only because we are lucky (or because of my commit
65b034cf5c176, whatever you prefer. But when I was sending that
patch, fixed-link was not needed for the switch to work):
  - when first the mv88e6xxx_port_setup_mac is called from
    mv88e6xxx_setup_port, it is called with SPEED_MAX. The
    ->port_max_speed_mode() method is called to determine cmode for
    this port, which is 2500basex
  - afterwards, mv88e6xxx_port_setup_mac is called with parameters
    speed=2500 and mode=PHY_INTERFACE_MODE_NA. Because of commit
    65b034cf5c176, cmode is not set to something else

I think that the correct way to do this would be for CPU/DSA port nodes
to have the same setting in dts as the eth node (eg 2500base-x/inband).

For this to work, the mv88e6390_serdes_irq_link_sgmii has to be able
to determine between 2500base-x vs 1000base-x modes. This is done by
the first patch.

The second patch adds two new methods into the DSA operations structure,
.port_setup() and .port_teardown(). The .port_setup is called from
dsa_port_setup() after the port is registered and phylink structure
already exists, and .port_teardown() is called from dsa_port_teardown()
before the port is unregistered.

The third patch then utilizes these new methods to enable/disable
SERDESes and ther IRQs for CPU/DSA ports.

Please comment on this new code, whether it is acceptable to have these
new methods, if they should be called differently, and so on.

Thank you.

Marek

Marek Behún (3):
  net: dsa: mv88e6xxx: support 2500base-x in SGMII IRQ handler
  net: dsa: add port_setup/port_teardown methods to DSA ops
  net: dsa: mv88e6xxx: setup SERDES irq also for CPU/DSA ports

 drivers/net/dsa/mv88e6xxx/chip.c   | 54 ++++++++++++++++++++++++------
 drivers/net/dsa/mv88e6xxx/serdes.c |  6 +++-
 include/net/dsa.h                  |  2 ++
 net/dsa/dsa2.c                     | 10 +++++-
 4 files changed, 60 insertions(+), 12 deletions(-)

-- 
2.21.0

