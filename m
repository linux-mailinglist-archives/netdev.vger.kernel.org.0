Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65C225A29C0
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 16:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344166AbiHZOk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 10:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiHZOk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 10:40:57 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE787A0314;
        Fri, 26 Aug 2022 07:40:54 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 97C7C1BF212;
        Fri, 26 Aug 2022 14:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661524853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Q+prOKvmlpVOGWkZXGIC28fpJnSPpdOQjo4meBRO7ho=;
        b=OEi33d0KGXTEq/rjX+WWnL0aYepwNU176GYfgKTSYF4OLwOaCWy8Syfa46LIfmwubsncA1
        Eby+lJ935Q199YOfdVswTw+gaAGJIK3jotwlc8lJOmfliHMEq5OedVVkTdj1Na/LkmYImO
        OT0CQ8Fc04QhiJ0njDeMzUBjtCiykxJOXld+hmWlgCO6iawYlE632COTp0cG5OKjH5MgAU
        luI0+oQkoM6Mx4danjLWwotWuN/oo7N7MFaGxYQZdTDrFR6lPJYmv4/LX2DSRUENtVndhK
        9OVNOt5orLYuw9oBGSJxfbeBfoFsPhmaVRENZ4D1TDfD5PWH5B/fwC+nhqBUfg==
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
Subject: [PATCH wpan-next v2 00/11] net: ieee802154: Support scanning/beaconing
Date:   Fri, 26 Aug 2022 16:40:38 +0200
Message-Id: <20220826144049.256134-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Here are the first patches of the big scan support series. Only passive
scan is present in these patches, we must agree on this first step
before moving forward with active scans, beaconing, associations and so
on. There are many other patches to come.

All of this is based on the initial work from David Girault and Romuald
Despres, they are often credited as Co-developpers.

Thanks,
Miquèl

Changes in v2 (some of them apply to other parts of the series not sent today):
* Initially tried to create a new (empty) path for COORD packets. As the
  processing, for now, is exactly the same as for NODE packets, I
  decided to go for a switch case as well as a comment indicating that
  the filtering should be enhanced with time.
* Reworked the rx path to clarify the ongoing filtering.
* Added an enum with the different filtering levels.
* Updated hwsim to reflect the right filtering level.
* Reworked again the rx path to include more filtering, in particular I
  added a real promiscuous mode as well as a level 4 filter (frame
  fields validation) which is enabled if the xceiver does not do it
  already.
* Set all the drivers (but the ca8210) able to create coordinators
  interfaces in theory.
* Prevented drivers with no promiscuous support to create COORD
  interfaces in the first place.
* Dropped the frame type enumeration because it was actually unused.
* The code already checked if the promiscuous mode was enabled, but
  it was not clear enough apparently, so I reorganized the logic a
  little bit in order to not hide this check.
* What was missing about the promiscuous mode however, was to remember
  in which state we found the PHY to avoid disabling the promiscuous
  mode if it was not enabled when we started scanning.
* Created a second workqueue, which would not be flushed in the close
  path because it does not need to be just for the mac commands. This
  allows acquiring the rtnl within scan_lock without issues.
* Thanks to the above change, I was able to drop the two patches
  reducing the use of the rtnl (in the tx path and in
  hwsim:change_channel()) but definitely not the change in the MLME Tx
  code which is really painful.

David Girault (1):
  net: ieee802154: Trace the registration of new PANs

Miquel Raynal (10):
  net: mac802154: Introduce filtering levels
  net: mac802154: Drop IEEE802154_HW_RX_DROP_BAD_CKSUM
  net: mac802154: Allow the creation of coordinator interfaces
  net: ieee802154: Advertize coordinators discovery
  net: ieee802154: Handle coordinators discovery
  net: ieee802154: Add support for user scanning requests
  net: ieee802154: Define a beacon frame header
  net: mac802154: Prepare forcing specific symbol duration
  net: mac802154: Introduce a global device lock
  net: mac802154: Handle passive scanning

 drivers/net/ieee802154/mac802154_hwsim.c |  10 +-
 include/linux/ieee802154.h               |   7 +
 include/net/cfg802154.h                  |  74 ++++-
 include/net/ieee802154_netdev.h          |  36 +++
 include/net/mac802154.h                  |  28 +-
 include/net/nl802154.h                   |  91 +++++++
 net/ieee802154/Makefile                  |   2 +-
 net/ieee802154/core.c                    |   2 +
 net/ieee802154/nl802154.c                | 331 +++++++++++++++++++++++
 net/ieee802154/nl802154.h                |   9 +
 net/ieee802154/pan.c                     | 115 ++++++++
 net/ieee802154/rdev-ops.h                |  28 ++
 net/ieee802154/trace.h                   |  65 +++++
 net/mac802154/Makefile                   |   2 +-
 net/mac802154/cfg.c                      |  41 ++-
 net/mac802154/ieee802154_i.h             |  38 ++-
 net/mac802154/iface.c                    |  26 +-
 net/mac802154/main.c                     |  40 ++-
 net/mac802154/rx.c                       |  63 ++++-
 net/mac802154/scan.c                     | 291 ++++++++++++++++++++
 net/mac802154/tx.c                       |  12 +-
 21 files changed, 1269 insertions(+), 42 deletions(-)
 create mode 100644 net/ieee802154/pan.c
 create mode 100644 net/mac802154/scan.c

-- 
2.34.1

