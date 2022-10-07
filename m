Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4EFA5F7590
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 10:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiJGIx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 04:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiJGIxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 04:53:21 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1C7FDB41;
        Fri,  7 Oct 2022 01:53:17 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6AA591BF208;
        Fri,  7 Oct 2022 08:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1665132796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=uh+P3R5zCB33IwZ4os0qwmtcfWBN2fhAjbxw11nSeYA=;
        b=WiP7T7dC4Li9EAOgPEiduB+4pmb1KeQ00SJxPGSqLbpJ2zn/aGGBGC//B7SbmK9jo/X89u
        Ul7f/MorqhFR+eLl7HMv0wsv69CEALwIO+o5pK4daSA9pg6YcLV/9LNgbsSMWc9NUNcAp5
        1ahZplu1KSoFiHIKf+Z6n4u7G1xMhQXdR7oc3rQ/2SD3kruHlfnt3gmI0ms6Bem6IeWszr
        njvxXufbHasfpvoEJVDj4Z9PVc5ZwZBKdeDIUqQhHLRY0XtCS40xMOI7reyZ6rtIs0oNTq
        hDMkgqMz1GdG9UPbQ/smWFTRdi+17pL5g2EZxcJJrzv+xoonVGJMILctmHFyVg==
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
Subject: [PATCH wpan/next v4 0/8] net: ieee802154: Improve filtering support
Date:   Fri,  7 Oct 2022 10:53:02 +0200
Message-Id: <20221007085310.503366-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

A fourth version of this series, where we try to improve filtering
support to ease scan integration. Will then come a short series about
the coordinator interfaces and then the proper scan series.

Thanks,
Miquèl

Changes in v4:
* Added a condition upon which the packets for a given interface would be
  dropped: in case AACK and/or address filtering was expected, but
  another interface has disabled it on the PHY.
* Changed the way Alexander's patch behaves regarding the handling of
  the different filtering levels. I added a third variable which shows
  the default filtering level for the interface. There is a second
  (per-interface) field giving the expected filtering level for this
  interface and finally we keep the per-PHY actual filtering level
  information. With this we can safely go back to the right level after
  a scan and also we can detect any wrong situation where ACKs would not
  be sent while expected and drop the frames if in this situation.
* Moved all the additional filtering logic out of the core and put it
  into hwsim's in-driver receive path, so that it can act like any other
  transceiver depending on the filtering level requested.
* Dropped the addition of the support for the ieee802154 promiscuous
  filtering mode which is anyway not usable yet.
* Dropped the "net:" prefixes in many patches to fit what Alexander
  does.

Changes in v3:
* Full rework of the way the promiscuous mode is handled, with new
  filtering levels, one per-phy and the actual one on the device.
* Dropped all the manual acking, everything is happenging on hardware.
* Better handling of the Acks in atusb to report the trac status.



Alexander Aring (2):
  mac802154: move receive parameters above start
  mac802154: set filter at drv_start()

Miquel Raynal (6):
  mac802154: Introduce filtering levels
  ieee802154: hwsim: Record the address filter values
  ieee802154: hwsim: Implement address filtering
  mac802154: Drop IEEE802154_HW_RX_DROP_BAD_CKSUM
  mac802154: Avoid delivering frames received in a non satisfying
    filtering mode
  mac802154: Ensure proper scan-level filtering

 drivers/net/ieee802154/mac802154_hwsim.c | 150 +++++++++++-
 include/linux/ieee802154.h               |  24 ++
 include/net/cfg802154.h                  |   7 +-
 include/net/ieee802154_netdev.h          |   8 +
 include/net/mac802154.h                  |   4 -
 net/mac802154/cfg.c                      |   2 +-
 net/mac802154/driver-ops.h               | 281 ++++++++++++++---------
 net/mac802154/ieee802154_i.h             |  12 +
 net/mac802154/iface.c                    |  44 ++--
 net/mac802154/rx.c                       |  25 +-
 10 files changed, 409 insertions(+), 148 deletions(-)

-- 
2.34.1

