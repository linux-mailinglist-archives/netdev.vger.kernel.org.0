Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7162D494512
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 01:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357918AbiATAv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 19:51:27 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:41075 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357906AbiATAv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 19:51:26 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 4F6AF100002;
        Thu, 20 Jan 2022 00:51:23 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-next 00/14] ieee802154: Synchronous Tx API
Date:   Thu, 20 Jan 2022 01:51:08 +0100
Message-Id: <20220120005122.309104-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The idea here is to provide a fully synchronous Tx API and also be able
to be sure that a transfer as finished. This will be used later by
another series.

The first patches create an error helper and then use it in order to
have only two "end of transmission" helpers that are always called.

Then, a bit of cleanup regarding the naming and the locations of certain
peaces of code is done.

Finally, we create a hot and a slow path, add the necessary logic to be
able to track ongoing transfers and when the queue must be kept on hold,
until we finally create a helper to stop emitting after the last
transfer, which we then use to create a synchronous MLME API.

(Caution: I haven't fully tested that part yet, but as Alexander and me
are on very different time slots I prefer to provide this tonight and
eventually fix it tomorrow)

Miquel Raynal (14):
  net: ieee802154: Move the logic restarting the queue upon transmission
  net: mac802154: Create a transmit error helper
  net: ieee802154: at86rf230: Call _xmit_error() when a transmission
    fails
  net: ieee802154: atusb: Call _xmit_error() when a transmission fails
  net: ieee802154: ca8210: Call _xmit_error() when a transmission fails
  net: mac802154: Stop exporting ieee802154_wake/stop_queue()
  net: mac802154: Rename the synchronous xmit worker
  net: mac802154: Rename the main tx_work struct
  net: mac802154: Follow the count of ongoing transmissions
  net: mac802154: Hold the transmit queue when relevant
  net: mac802154: Create a hot tx path
  net: mac802154: Add a warning in the hot path
  net: mac802154: Introduce a tx queue flushing mechanism
  net: mac802154: Introduce a synchronous API for MLME commands

 drivers/net/ieee802154/at86rf230.c |  3 +-
 drivers/net/ieee802154/atusb.c     |  4 +--
 drivers/net/ieee802154/ca8210.c    | 12 ++++----
 include/net/cfg802154.h            |  5 ++++
 include/net/mac802154.h            | 37 +++++++----------------
 net/ieee802154/core.c              |  1 +
 net/mac802154/cfg.c                |  5 ++--
 net/mac802154/ieee802154_i.h       | 35 ++++++++++++++++++++--
 net/mac802154/main.c               |  2 +-
 net/mac802154/tx.c                 | 48 +++++++++++++++++++++++++-----
 net/mac802154/util.c               | 34 ++++++++++++++++++---
 11 files changed, 132 insertions(+), 54 deletions(-)

-- 
2.27.0

