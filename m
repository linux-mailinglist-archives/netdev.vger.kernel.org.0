Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A14679D862
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 23:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbfHZVcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 17:32:01 -0400
Received: from mail.nic.cz ([217.31.204.67]:35086 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728755AbfHZVcA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 17:32:00 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id CBAF6140AB8;
        Mon, 26 Aug 2019 23:31:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566855118; bh=a00ABvZn/KYrqqJqu4MIcgvfGc2bg7h6dupp1H4iFNw=;
        h=From:To:Date;
        b=oA+yoKe1GYppnSZnq6v2dW1vvR3fuUEPa70Bjsxz+VPVMI1oJOCKqF4G1w0QMhrPq
         +KzwpG/QOXGygD0KzrRGnHJGv7PVD1aHFsM4QUEwAKBUeaijoaBPdYfVHWEb9d+qJb
         GCPTfH0CygmSyx9OEnp+w+y3HfkhiaAEJRL9NydM=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Subject: [PATCH net-next v5 0/6] net: dsa: mv88e6xxx: Peridot/Topaz SERDES changes
Date:   Mon, 26 Aug 2019 23:31:49 +0200
Message-Id: <20190826213155.14685-1-marek.behun@nic.cz>
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

this is the fifth version of changes for the Topaz/Peridot family of
switches. The patches apply on net-next.
Changes since v4:
 - added Reviewed-by and Tested-by tags on first 2 patches, the others
   are changed are affected by changes in patch 3/6, so I did not add
   the tags, except for 5/6, which is just macro renaming
 - patch 3 was changed: the serdes_get_lane returns 0 on success (lane
   was discovered), -ENODEV if not lane is present on the port, and
   other error if other error occured. Lane is put into a pointer of
   type u8
 - patches 4 and 6 were affected by this (error detecting from
   serdes_get_lane)
 - Andrew's complaint about the two additional parameters
   (allow_over_2500 and make_cmode_writable) was addressed, by Vivien's
   advice: I put a new method into chip operations structure, named
   port_set_cmode_writable. This is called from mv88e6xxx_port_setup_mac
   just before port_set_cmode. The method is implemented for Topaz.
   The check if cmodes over 2500 should be allowed on given port is now
   done in the specific port_set_cmode() that requires it, thus the
   allow_over_2500 argument is not needed

Again, tested on Turris Mox with Peridot, Topaz, and Peridot + Topaz.

Marek

Marek Behún (6):
  net: dsa: mv88e6xxx: support 2500base-x in SGMII IRQ handler
  net: dsa: mv88e6xxx: update code operating on hidden registers
  net: dsa: mv88e6xxx: create serdes_get_lane chip operation
  net: dsa: mv88e6xxx: simplify SERDES code for Topaz and Peridot
  net: dsa: mv88e6xxx: rename port cmode macro
  net: dsa: mv88e6xxx: fully support SERDES on Topaz family

 drivers/net/dsa/mv88e6xxx/Makefile      |   1 +
 drivers/net/dsa/mv88e6xxx/chip.c        |  96 +++----
 drivers/net/dsa/mv88e6xxx/chip.h        |   4 +
 drivers/net/dsa/mv88e6xxx/port.c        |  89 +++++--
 drivers/net/dsa/mv88e6xxx/port.h        |  31 ++-
 drivers/net/dsa/mv88e6xxx/port_hidden.c |  70 +++++
 drivers/net/dsa/mv88e6xxx/serdes.c      | 325 ++++++++++++------------
 drivers/net/dsa/mv88e6xxx/serdes.h      |  27 +-
 8 files changed, 379 insertions(+), 264 deletions(-)
 create mode 100644 drivers/net/dsa/mv88e6xxx/port_hidden.c

-- 
2.21.0

