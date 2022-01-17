Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F3A490771
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 12:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239259AbiAQLyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 06:54:45 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:51375 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236460AbiAQLyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 06:54:45 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 5C11C200004;
        Mon, 17 Jan 2022 11:54:41 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH v3 00/41] IEEE 802.15.4 scan support
Date:   Mon, 17 Jan 2022 12:53:59 +0100
Message-Id: <20220117115440.60296-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

	*** TLDR ***

Here is a series attempting to bring support for scans in the
IEEE 802.15.4 stack. A number of improvements had to be made, including:
* a better handling of the symbol durations
* a few changes in Kconfig
* a better handling of the tx queues
* a synchronous Tx API

Active and passive scans can be locally tested only with hwsim.

Sorry for the big series, might be split in the near future.

	************

A second series aligning the tooling with these changes is related,
bringing support for a number of new features such as:

* Sending (or stopping) beacons. Intervals ranging from 0 to 14 are
  valid for passively sending beacons at regular intervals. An interval
  of 15 would request the core to answer to received BEACON_REQ.
  # iwpan dev wpan0 beacons send interval 2 # send BEACON at a fixed rate
  # iwpan dev wpan0 beacons send interval 15 # answer BEACON_REQ only
  # iwpan dev wpan0 beacons stop # apply to both cases

* Scanning all the channels or only a subset:
  # iwpan dev wpan1 scan type passive duration 3 # will not trigger BEACON_REQ
  # iwpan dev wpan1 scan type active duration 3 # will trigger BEACON_REQ

* If a beacon is received during a scan, the internal PAN list is
  updated and can be dumped, flushed and configured with:
  # iwpan dev wpan1 pans dump
  PAN 0xffff (on wpan1)
      coordinator 0x2efefdd4cdbf9330
      page 0
      channel 13
      superframe spec. 0xcf22
      LQI 0
      seen 7156ms ago
  # iwpan dev wpan1 pans flush
  # iwpan dev wpan1 set max_pan_entries 100
  # iwpan dev wpan1 set pans_expiration 3600

* It is also possible to monitor the events with:
  # iwpan event

* As well as triggering a non blocking scan:
  # iwpan dev wpan1 scan trigger type passive duration 3
  # iwpan dev wpan1 scan done
  # iwpan dev wpan1 scan abort

The PAN list gets automatically updated by dropping the expired PANs
each time the user requests access to the list.

Internally, both requests (scan/beacons) are handled periodically by
delayed workqueues when relevant.

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

Changes in v3:
* Dropped two patches:
  net: mac802154: Split the set channel hook implementation
  net: mac802154: Ensure proper channel selection at probe time
* Fixed a check against the supported channels list in
  ieee802154_set_symbol_duration().
* Reworded a bit the above helper to print different error messages and
  dropped the goto statement in it.
* Used the NSEC_PER_USEC macro in the symbol conversion from us to ns.
* Stopped calling ->set_channel() at probe time.
* Fixed hwsim which does not internally set the right channel.
* Used definitions instead of hardcoded values when relevant.
* Moved two helpers out of the experimental section because they are now
  used outside of experimental code.
* Did a number of renames. Added a couple of comments.
* Updated several drivers to force them to use the core xmit complete
  callback instead of workarounding it.
* Created a helper checking if a queue must be kept on hold.
* Created a couple of atomic variables and wait_queue_t per phy.
* Created a sync API for MLME transmissions.
* Created a hot path and a slow path.
* Put the warning in the hot path.
* Added a flag to prevent drivers supporting only datagrams to use the
  different scanning features.
* Dropped ieee802154_wake/stop_queue() from the exported
  symbols. Drivers should not use these directly, but call other helpers
  in order to fail the tx counters.

Changes in v2:
* Create two new netlink commands to set the maximum number of PANs that
  can be listed as well as their expiration time (in seconds).
* Added a patch to the series to avoid ignoring bad frames in hwsim as
  requested by Alexander.
* Changed the symbol duration type to receive nanoseconds instead of
  microseconds.
* Dropped most of the hwsim patches and reworked how drivers advertise
  their channels in order to be capable of deriving the symbol durations
  automatically.
* The scanning boolean gets turned into an atomic.
* The ca8210 driver does not support scanning, implement the driver
  hooks to reflect the situation.
* Reworked a bit the content of each patch to ease the introduction of
  active scans. 
* Added active scan support.

David Girault (5):
  net: ieee802154: Move IEEE 802.15.4 Kconfig main entry
  net: mac802154: Include the softMAC stack inside the IEEE 802.15.4
    menu
  net: ieee802154: Move the address structure earlier
  net: ieee802154: Add a kernel doc header to the ieee802154_addr
    structure
  net: ieee802154: Trace the registration of new PANs

Miquel Raynal (36):
  MAINTAINERS: Remove Harry Morris bouncing address
  net: ieee802154: hwsim: Ensure proper channel selection at probe time
  net: ieee802154: hwsim: Ensure frame checksum are valid
  net: ieee802154: Use the IEEE802154_MAX_PAGE define when relevant
  net: ieee802154: Improve the way supported channels are declared
  net: ieee802154: Give more details to the core about the channel
    configurations
  net: ieee802154: mcr20a: Fix lifs/sifs periods
  net: mac802154: Convert the symbol duration into nanoseconds
  net: mac802154: Set the symbol duration automatically
  net: ieee802154: Drop duration settings when the core does it already
  net: ieee802154: Return meaningful error codes from the netlink
    helpers
  net: mac802154: Explain the use of ieee802154_wake/stop_queue()
  net: ieee802154: at86rf230: Call the complete helper when a
    transmission is over
  net: ieee802154: atusb: Call the complete helper when a transmission
    is over
  net: ieee802154: ca8210: Call the complete helper when a transmission
    is over
  net: mac802154: Stop exporting ieee802154_wake/stop_queue()
  net: mac802154: Rename the synchronous xmit worker
  net: mac802154: Rename the main tx_work struct
  net: mac802154: Follow the count of ongoing transmissions
  net: mac802154: Hold the transmit queue when relevant
  net: mac802154: Create a hot tx path
  net: mac802154: Add a warning in the hot path
  net: mac802154: Introduce a tx queue flushing mechanism
  net: mac802154: Introduce a synchronous API for MLME commands
  net: ieee802154: Add support for internal PAN management
  net: ieee802154: Define a beacon frame header
  net: ieee802154: Define frame types
  net: ieee802154: Add support for scanning requests
  net: mac802154: Handle scan requests
  net: ieee802154: Full PAN management
  net: ieee802154: Add beacons support
  net: mac802154: Handle beacons requests
  net: mac802154: Add support for active scans
  net: mac802154: Add support for processing beacon requests
  net: ieee802154: Handle limited devices with only datagram support
  net: ieee802154: ca8210: Flag the driver as being limited

 MAINTAINERS                              |   3 +-
 drivers/net/ieee802154/adf7242.c         |   3 +-
 drivers/net/ieee802154/at86rf230.c       |  68 ++-
 drivers/net/ieee802154/atusb.c           |  89 ++--
 drivers/net/ieee802154/ca8210.c          |  17 +-
 drivers/net/ieee802154/cc2520.c          |   3 +-
 drivers/net/ieee802154/fakelb.c          |  43 +-
 drivers/net/ieee802154/mac802154_hwsim.c |  88 +++-
 drivers/net/ieee802154/mcr20a.c          |  11 +-
 drivers/net/ieee802154/mrf24j40.c        |   3 +-
 include/linux/ieee802154.h               |   7 +
 include/net/cfg802154.h                  | 175 ++++++-
 include/net/ieee802154_netdev.h          |  85 ++++
 include/net/mac802154.h                  |  29 +-
 include/net/nl802154.h                   |  99 ++++
 net/Kconfig                              |   3 +-
 net/ieee802154/Kconfig                   |   1 +
 net/ieee802154/Makefile                  |   2 +-
 net/ieee802154/core.c                    |   3 +
 net/ieee802154/core.h                    |  31 ++
 net/ieee802154/header_ops.c              |  67 +++
 net/ieee802154/nl-phy.c                  |  13 +-
 net/ieee802154/nl802154.c                | 556 ++++++++++++++++++++++-
 net/ieee802154/nl802154.h                |   4 +
 net/ieee802154/pan.c                     | 234 ++++++++++
 net/ieee802154/rdev-ops.h                |  52 +++
 net/ieee802154/trace.h                   |  86 ++++
 net/mac802154/Makefile                   |   2 +-
 net/mac802154/cfg.c                      |  82 +++-
 net/mac802154/ieee802154_i.h             |  86 +++-
 net/mac802154/main.c                     | 119 ++++-
 net/mac802154/rx.c                       |  34 +-
 net/mac802154/scan.c                     | 447 ++++++++++++++++++
 net/mac802154/tx.c                       |  48 +-
 net/mac802154/util.c                     |  38 +-
 35 files changed, 2413 insertions(+), 218 deletions(-)
 create mode 100644 net/ieee802154/pan.c
 create mode 100644 net/mac802154/scan.c

-- 
2.27.0

