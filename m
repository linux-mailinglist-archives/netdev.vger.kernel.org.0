Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC52169D5DD
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 22:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbjBTViF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 16:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232373AbjBTVh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 16:37:59 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FFA61AF;
        Mon, 20 Feb 2023 13:37:56 -0800 (PST)
Received: from localhost.localdomain.datenfreihafen.local (p200300e9d746344d8e4accf037150218.dip0.t-ipconnect.de [IPv6:2003:e9:d746:344d:8e4a:ccf0:3715:218])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@sostec.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id CF138C0373;
        Mon, 20 Feb 2023 22:37:53 +0100 (CET)
From:   Stefan Schmidt <stefan@datenfreihafen.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, alex.aring@gmail.com,
        miquel.raynal@bootlin.com, netdev@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Subject: pull-request v2: ieee802154-next 2023-02-20
Date:   Mon, 20 Feb 2023 22:37:49 +0100
Message-Id: <20230220213749.386451-1-stefan@datenfreihafen.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dave, Jakub.

An update from ieee802154 for *net-next*

Miquel Raynal build upon his earlier work and introduced two new
features into the ieee802154 stack. Beaconing to announce existing
PAN's and passive scanning to discover the beacons and associated
PAN's. The matching changes to the userspace configuration tool
have been posted as well and will be released together with the
kernel release.

Arnd Bergmann and Dmitry Torokhov worked on converting the
at86rf230 and cc2520 drivers away from the unused platform_data
usage and towards the new gpiod API. (I had to add a revert as
Dmitry found a regression on an already pushed tree on my side).

Changes since v1 (pull request 2023-02-02)
- Netlink API extack and NLA_POLICY* usage as suggested by Jakub
- Removed always true condition found by kernel test robot
- Simplify device removal with running background job for scanning
- Fix problems with beacon sending in some cases by using the MLME
  tx path

regards
Stefan Schmidt

The following changes since commit d8b879c00f69a22738f6bb7198e763cfcc6b68f8:

  Merge branch 'net-ethernet-ti-am65-cpsw-fix-set-channel-operation' (2022-12-07 20:17:35 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan-next.git tags/ieee802154-for-net-next-2023-02-20

for you to fetch changes up to ed9a8ad7d8a1a0eb7d4e1414d0a04ece7c2265df:

  ieee802154: Drop device trackers (2023-02-18 16:49:53 +0100)

----------------------------------------------------------------
Arnd Bergmann (2):
      at86rf230: convert to gpio descriptors
      cc2520: move to gpio descriptors

Dmitry Torokhov (2):
      ieee802154: at86rf230: drop support for platform data
      ieee802154: at86rf230: switch to using gpiod API

Miquel Raynal (15):
      ieee802154: Add support for user scanning requests
      ieee802154: Define a beacon frame header
      ieee802154: Introduce a helper to validate a channel
      mac802154: Prepare forcing specific symbol duration
      mac802154: Add MLME Tx locked helpers
      mac802154: Handle passive scanning
      ieee802154: Add support for user beaconing requests
      mac802154: Handle basic beaconing
      mac802154: Avoid superfluous endianness handling
      ieee802154: Use netlink policies when relevant on scan parameters
      ieee802154: Convert scan error messages to extack
      ieee802154: Change error code on monitor scan netlink request
      mac802154: Send beacons using the MLME Tx path
      mac802154: Fix an always true condition
      ieee802154: Drop device trackers

Stefan Schmidt (1):
      Revert "at86rf230: convert to gpio descriptors"

 MAINTAINERS                        |   1 -
 drivers/net/ieee802154/at86rf230.c |  90 +++-----
 drivers/net/ieee802154/cc2520.c    | 136 +++--------
 include/linux/ieee802154.h         |   7 +
 include/linux/spi/at86rf230.h      |  20 --
 include/linux/spi/cc2520.h         |  21 --
 include/net/cfg802154.h            |  78 ++++++-
 include/net/ieee802154_netdev.h    |  52 +++++
 include/net/nl802154.h             |  61 +++++
 net/ieee802154/header_ops.c        |  24 ++
 net/ieee802154/nl802154.c          | 283 ++++++++++++++++++++++-
 net/ieee802154/nl802154.h          |   4 +
 net/ieee802154/rdev-ops.h          |  56 +++++
 net/ieee802154/trace.h             |  61 +++++
 net/mac802154/Makefile             |   2 +-
 net/mac802154/cfg.c                |  60 ++++-
 net/mac802154/ieee802154_i.h       |  61 ++++-
 net/mac802154/iface.c              |   6 +
 net/mac802154/llsec.c              |   5 +-
 net/mac802154/main.c               |  37 ++-
 net/mac802154/rx.c                 |  36 ++-
 net/mac802154/scan.c               | 456 +++++++++++++++++++++++++++++++++++++
 net/mac802154/tx.c                 |  42 ++--
 23 files changed, 1368 insertions(+), 231 deletions(-)
 delete mode 100644 include/linux/spi/at86rf230.h
 delete mode 100644 include/linux/spi/cc2520.h
 create mode 100644 net/mac802154/scan.c
