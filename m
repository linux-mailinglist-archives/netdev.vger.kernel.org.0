Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF61E47D479
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 16:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343796AbhLVP5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 10:57:48 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:49975 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343765AbhLVP5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 10:57:47 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 6569660013;
        Wed, 22 Dec 2021 15:57:44 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        <linux-kernel@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [net-next 00/18] IEEE 802.15.4 passive scan support
Date:   Wed, 22 Dec 2021 16:57:25 +0100
Message-Id: <20211222155743.256280-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Here is a series attempting to bring support for passive scans in the
IEEE 802.15.4 stack. A second series follows in order to align the
tooling with these changes, bringing support for a number of new
features such as:

* Passively sending (or stopping) beacons. So far only intervals ranging
  from 0 to 14 are valid. Bigger values would request the PAN
  coordinator to answer BEACONS_REQ (active scans), this is not
  supported yet.
  # iwpan dev wpan0 beacons send interval 2
  # iwpan dev wpan0 beacons stop

* Scanning all the channels or only a subset:
  # iwpan dev wpan1 scan type passive duration 3

* If a beacon is received during this operation the internal PAN list is
  updated and can be dumped or flushed with:
  # iwpan dev wpan1 pans dump
  PAN 0xffff (on wpan1)
      coordinator 0x2efefdd4cdbf9330
      page 0
      channel 13
      superframe spec. 0xcf22
      LQI 0
      seen 7156ms ago
  # iwpan dev wpan1 pans flush

* It is also possible to monitor the events with:
  # iwpan event

* As well as triggering a non blocking scan:
  # iwpan dev wpan1 scan trigger type passive duration 3
  # iwpan dev wpan1 scan done
  # iwpan dev wpan1 scan abort

The PAN list gets automatically updated by dropping the expired PANs
each time the user requests access to the list.

Internally, both requests (scan/beacons) are handled periodically by
delayed workqueues.

So far the only technical point that is missing in this series is the
possibility to grab a reference over the module driving the net device
in order to prevent module unloading during a scan or when the beacons
work is ongoing.

Finally, this series is a deep reshuffle of David Girault's original
work, hence the fact that he is almost systematically credited, either
by being the only author when I created the patches based on his changes
with almost no modification, or with a Co-developped-by tag whenever the
final code base is significantly different than his first proposal while
still being greatly inspired from it.

Cheers,
Miquèl

David Girault (5):
  net: ieee802154: Move IEEE 802.15.4 Kconfig main entry
  net: mac802154: Include the softMAC stack inside the IEEE 802.15.4
    menu
  net: ieee802154: Move the address structure earlier
  net: ieee802154: Add a kernel doc header to the ieee802154_addr
    structure
  net: ieee802154: Trace the registration of new PANs

Miquel Raynal (13):
  ieee802154: hwsim: Ensure proper channel selection at probe time
  ieee802154: hwsim: Provide a symbol duration
  net: ieee802154: Return meaningful error codes from the netlink
    helpers
  net: ieee802154: Add support for internal PAN management
  net: ieee802154: Define a beacon frame header
  net: ieee802154: Define frame types
  net: ieee802154: Add support for scanning requests
  net: mac802154: Handle scan requests
  net: mac802154: Inform device drivers about the scanning operation
  net: ieee802154: Full PAN management
  net: ieee802154: Add support for beacon requests
  net: mac802154: Handle beacons requests
  net: mac802154: Let drivers provide their own beacons implementation

 drivers/net/ieee802154/mac802154_hwsim.c |  77 +++-
 include/linux/ieee802154.h               |   6 +
 include/net/cfg802154.h                  | 107 +++++-
 include/net/ieee802154_netdev.h          |  71 ++++
 include/net/mac802154.h                  |  40 ++
 include/net/nl802154.h                   |  95 +++++
 net/Kconfig                              |   3 +-
 net/ieee802154/Kconfig                   |   1 +
 net/ieee802154/Makefile                  |   2 +-
 net/ieee802154/core.c                    |   2 +
 net/ieee802154/core.h                    |  23 ++
 net/ieee802154/header_ops.c              |  29 ++
 net/ieee802154/nl802154.c                | 466 ++++++++++++++++++++++-
 net/ieee802154/nl802154.h                |   4 +
 net/ieee802154/pan.c                     | 211 ++++++++++
 net/ieee802154/rdev-ops.h                |  52 +++
 net/ieee802154/trace.h                   |  86 +++++
 net/mac802154/Makefile                   |   2 +-
 net/mac802154/cfg.c                      |  76 ++++
 net/mac802154/driver-ops.h               |  66 ++++
 net/mac802154/ieee802154_i.h             |  28 ++
 net/mac802154/main.c                     |   4 +
 net/mac802154/rx.c                       |  10 +-
 net/mac802154/scan.c                     | 374 ++++++++++++++++++
 net/mac802154/trace.h                    |  49 +++
 net/mac802154/util.c                     |  26 ++
 26 files changed, 1889 insertions(+), 21 deletions(-)
 create mode 100644 net/ieee802154/pan.c
 create mode 100644 net/mac802154/scan.c

-- 
2.27.0

