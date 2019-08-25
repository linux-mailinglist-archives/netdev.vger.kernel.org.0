Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD059C171
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 05:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbfHYD7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 23:59:24 -0400
Received: from mail.nic.cz ([217.31.204.67]:44152 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728270AbfHYD7Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 23:59:24 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 2318E13FFDC;
        Sun, 25 Aug 2019 05:59:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566705562; bh=MEdCRejjMHl7duOVd3pEfSFe90tstGXZvl86K+yH88E=;
        h=From:To:Date;
        b=UBptG6s6GgJBFO+ZdlRv22ffDldEekIeeAD9rx+dwi9KZieg2rLo//R0bnFViWr0w
         Prr2mB+gNHoL9l6r4GvaSvrYFMCL9nHVF4O2SDBHwKHMIfO+JVSRSBDubsLNaOLpg+
         7Q+YszQVxkMuVrz9TXsJd2nSef49GQ4ebMaR6CJw=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next v3 0/6] net: dsa: mv88e6xxx: Peridot/Topaz SERDES changes
Date:   Sun, 25 Aug 2019 05:59:09 +0200
Message-Id: <20190825035915.13112-1-marek.behun@nic.cz>
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

this is the third version of changes for the Topaz/Peridot family of
switches. The patches apply on net-next.
Changes since v2:
 - per Vivien's request I merged the three different patches operating
   on code for hidden registers into one patch (second in this series)
 - also per Vivien's request I changed the serdes_get_lane method: its
   return value is now used only if error's occur, as the rest of this
   drivers functions do. Lane number is put into a place pointed to
   by the s8 *lane argument. The error semantics also changed: if there
   is no lane on a port, the function should still return 0 and should
   put -1 into *lane. Negative error value should be returned only if
   a real error occurs, for example when a MDIO read operation failed.
 - also per Vivien's request the mv88e6xxx_serdes_get_lane function was
   put into serdes.h as static inline, since it is just a wrapper
 - the patch that simplified SERDES code for Topaz and Peridot families
   was merged into one patch

Marek

Marek Behún (6):
  net: dsa: mv88e6xxx: support 2500base-x in SGMII IRQ handler
  net: dsa: mv88e6xxx: update code operating on hidden registers
  net: dsa: mv88e6xxx: create serdes_get_lane chip operation
  net: dsa: mv88e6xxx: simplify SERDES code for Topaz and Peridot
  net: dsa: mv88e6xxx: rename port cmode macro
  net: dsa: mv88e6xxx: fully support SERDES on Topaz family

 drivers/net/dsa/mv88e6xxx/Makefile      |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c        |  88 +++-----
 drivers/net/dsa/mv88e6xxx/chip.h        |   3 +
 drivers/net/dsa/mv88e6xxx/port.c        |  98 ++++++---
 drivers/net/dsa/mv88e6xxx/port.h        |  30 ++-
 drivers/net/dsa/mv88e6xxx/port_hidden.c |  70 ++++++
 drivers/net/dsa/mv88e6xxx/serdes.c      | 275 +++++++++++-------------
 drivers/net/dsa/mv88e6xxx/serdes.h      |  27 ++-
 8 files changed, 333 insertions(+), 259 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/port_hidden.c

-- 
2.21.0

