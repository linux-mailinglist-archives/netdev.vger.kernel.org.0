Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B40265635BA
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 16:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbiGAOfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 10:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiGAOfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 10:35:31 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7516F350;
        Fri,  1 Jul 2022 07:31:00 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id BBE63FF80F;
        Fri,  1 Jul 2022 14:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656685856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Rij4TQi6ZDBkygH8eRcgVN8s5NKJxlENuwJhdOy24J0=;
        b=pZZ0n/GD1FAoYjds5wMCYa9m3o8/KA4QUJLLMa2rGfeCTNxxMnBAQphiqc6KwywCEmm+rj
        mG1/TXgP70K8fiUmaON4FQIcsDBu6H+jjuUeBGymVB4h9byfvGm+5IWORkN+ujdLtKHzBM
        ODf6q+1emLwR8a10V5nYntdetxz1fHDAY+PXXd14AKScQpiZ05KJP9Ux1LE+IAQNbnoqXG
        FG72hYD7zUv3Ke45rIELGd+OHeMq0qM+O6kCH8OrPl1yOvi45ff8cSa1B0o/H5nh/eS7aa
        yOBK2nP9uQOQmXOJVxG8oIZNZsLkTouxYYxvG//6OFp+/dejNWQUsiiLGuG16w==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next 00/20] net: ieee802154: Support scanning/beaconing
Date:   Fri,  1 Jul 2022 16:30:32 +0200
Message-Id: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

After a few exchanges about inter-PAN management with Alexander, it was
decided that most of this series would be dropped, because the kernel
should in the end not really care about keeping a local copy of the
discovered coordinators, this is userspace job.

So here is a "first" version of the scanning series which hopefully
meets the main requirements discussed the past days on the mailing
list. I know it is rather big, but there are a few very trivial patches
there, so here is how it is built:

* net: mac802154: Allow the creation of coordinator interfaces

  Beaconing must be reserved to coordinator interfaces, so we must
  support the creation of these interfaces in the mac layer.

* net: ieee802154: Advertize coordinators discovery
* net: ieee802154: Handle coordinators discovery
 
  Introduction of a user interface and then a cfg802154 interface for
  coordinators discovery and advertisement.

* net: ieee802154: Define frame types
* net: ieee802154: Add support for user scanning requests
* net: ieee802154: Define a beacon frame header
* net: mac802154: Prepare forcing specific symbol duration
* net: mac802154: Introduce a global device lock
* net: mac802154: Handle passive scanning

  User requests to scan and MAC handling of these requests.

* net: ieee802154: Add support for user beaconing requests
* net: mac802154: Handle basic beaconing

  User requests to send beacons and MAC handling of these requests.

* net: ieee802154: Add support for user active scan requests
* net: mac802154: Handle active scanning

  User requests to scan actively and MAC handling of these requests.

* net: ieee802154: Add support for allowing to answer BEACON_REQ
* net: mac802154: Handle received BEACON_REQ

  User requests to answer BEACON_RQ and MAC handling of these requests.

* net: ieee802154: Handle limited devices with only datagram support
* ieee802154: ca8210: Flag the driver as being limited

  This is a result of a previous review from Alexander, which pointed
  that the hardMAC ca8210 would not support the scanning operations, so
  it is flagged as limited.

* ieee802154: hwsim: Do not check the rtnl
* ieee802154: hwsim: Allow devices to be coordinators

  And finally these two patches are there to allow using hwsim to
  validate the series.

The corresponding userspace code will follow.

The series lacks support for forwarding association requests to the user
and waiting for feedback before accepting the device. This can be added
later on top of this work and is not necessary right now.

All of this is based on the initial work from David Girault and Romuald
Despres, they are often credited as Co-developpers.

Thanks,
Miquèl

David Girault (1):
  net: ieee802154: Trace the registration of new PANs

Miquel Raynal (19):
  net: mac802154: Allow the creation of coordinator interfaces
  net: ieee802154: Advertize coordinators discovery
  net: ieee802154: Handle coordinators discovery
  net: ieee802154: Define frame types
  net: ieee802154: Add support for user scanning requests
  net: ieee802154: Define a beacon frame header
  net: mac802154: Prepare forcing specific symbol duration
  net: mac802154: Introduce a global device lock
  net: mac802154: Handle passive scanning
  net: ieee802154: Add support for user beaconing requests
  net: mac802154: Handle basic beaconing
  net: ieee802154: Add support for user active scan requests
  net: mac802154: Handle active scanning
  net: ieee802154: Add support for allowing to answer BEACON_REQ
  net: mac802154: Handle received BEACON_REQ
  net: ieee802154: Handle limited devices with only datagram support
  ieee802154: ca8210: Flag the driver as being limited
  ieee802154: hwsim: Do not check the rtnl
  ieee802154: hwsim: Allow devices to be coordinators

 drivers/net/ieee802154/ca8210.c          |   3 +-
 drivers/net/ieee802154/mac802154_hwsim.c |   4 +-
 include/linux/ieee802154.h               |   7 +
 include/net/cfg802154.h                  |  97 ++++-
 include/net/ieee802154_netdev.h          |  89 +++++
 include/net/nl802154.h                   |  93 +++++
 net/ieee802154/Makefile                  |   2 +-
 net/ieee802154/core.c                    |   2 +
 net/ieee802154/header_ops.c              |  69 ++++
 net/ieee802154/nl802154.c                | 402 ++++++++++++++++++++
 net/ieee802154/nl802154.h                |   7 +
 net/ieee802154/pan.c                     | 114 ++++++
 net/ieee802154/rdev-ops.h                |  56 +++
 net/ieee802154/trace.h                   |  86 +++++
 net/mac802154/Makefile                   |   2 +-
 net/mac802154/cfg.c                      |  76 +++-
 net/mac802154/ieee802154_i.h             |  70 ++++
 net/mac802154/iface.c                    |  30 +-
 net/mac802154/main.c                     |  29 +-
 net/mac802154/rx.c                       | 113 +++++-
 net/mac802154/scan.c                     | 462 +++++++++++++++++++++++
 net/mac802154/tx.c                       |  12 +-
 22 files changed, 1793 insertions(+), 32 deletions(-)
 create mode 100644 net/ieee802154/pan.c
 create mode 100644 net/mac802154/scan.c

-- 
2.34.1

