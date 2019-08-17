Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 636FC912A1
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 21:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbfHQTO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 15:14:59 -0400
Received: from mail.nic.cz ([217.31.204.67]:41628 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbfHQTO7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Aug 2019 15:14:59 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 949DF140B50;
        Sat, 17 Aug 2019 21:14:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566069297; bh=H/m4j0ZyYd1r9T97ff66kwnF38vFINhYnEW+9n+pXWY=;
        h=From:To:Date;
        b=gsHapUWsC1MUzcxGF30Zs7t2eZewdgBQAekYLxyg3+mcKuZN04DY9D6Om+fyOkqR/
         4OImg3F+nATRhtsXuLbXW9yBQ6DLkpHmdyj2UM43VDdOtSMrIhoWJ3HQTgNiez27+o
         rp8mdFDkpiW6IvGMfoxN6GcKiptT/2sVQMEV+Irg=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH RFC v2 net-next 0/4] mv88e6xxx: setting 2500base-x mode for CPU/DSA port in dts
Date:   Sat, 17 Aug 2019 21:14:48 +0200
Message-Id: <20190817191452.16716-1-marek.behun@nic.cz>
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

Hi,

here is another proposal for supporting setting 2500base-x mode for
CPU/DSA ports in device tree correctly.

The changes from v1 are that instead of adding .port_setup() and
.port_teardown() methods to the DSA operations struct we instead, for
CPU/DSA ports, call dsa_port_enable() from dsa_port_setup(), but only
after the port is registered (and required phylink/devlink structures
exist).

The .port_enable/.port_disable methods are now only meant to be used
for user ports, when the slave interface is brought up/down. This
proposal changes that in such a way that these methods are also called
for CPU/DSA ports, but only just after the switch is set up (and just
before the switch is tore down).

If we went this way, we would have to patch the other DSA drivers to
check if user port is being given in their respective .port_enable
and .port_disable implmentations.

What do you think about this?

Marek

Marek Behún (4):
  net: dsa: mv88e6xxx: support 2500base-x in SGMII IRQ handler
  net: dsa: call port_enable/port_disable for CPU/DSA ports
  net: dsa: mv88e6xxx: check for port type in port_disable
  net: dsa: mv88e6xxx: do not enable SERDESes in mv88e6xxx_setup

 drivers/net/dsa/mv88e6xxx/chip.c   | 15 +++------------
 drivers/net/dsa/mv88e6xxx/serdes.c | 23 +++++++++++++++++++++--
 net/dsa/dsa2.c                     | 21 ++++++++++++++++++++-
 net/dsa/port.c                     |  4 ++--
 4 files changed, 46 insertions(+), 17 deletions(-)

-- 
2.21.0

