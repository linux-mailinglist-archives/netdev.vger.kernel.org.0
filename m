Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC6014CC517
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 19:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbiCCS0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 13:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235717AbiCCS0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 13:26:00 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831DA1A41D6;
        Thu,  3 Mar 2022 10:25:14 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3B06820004;
        Thu,  3 Mar 2022 18:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1646331911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=7ArTFO2DMWHfPbhHCQg0D82pyieQO6ZiTcwLZB6DrIg=;
        b=neBm1HAwXmbrSl+BqvoKSYOgukx1qm6ozSmv+aT0IVD9PuZV301h9PV5VG353U/cWxtvXK
        p1sJUnhZBysXoxeVe1Bb4MFkvlIxvDEqNQ7+t9oEEJ8lWyDvO6PdVlQIU2qGQSdLolWB+O
        q1QF1RkYsGNw/k6U+PApAoC9C1Fbd02NnhXi39aZbr8YbW2T95nh2fPNQgqZFNLqYEDlIb
        hps1LEXG8cuacc8vSdIKtE6IjkL/GpTHjDE3tcb/zySbQ02AMNMUMty6r5TgtPXHRpodtD
        AZYk5gGiL2Yt23aBe+cB38IcXrkL4lEqgOLw0VnSXvDB434obwqBxbGilynp8w==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v3 00/11] ieee802154: Better Tx error handling
Date:   Thu,  3 Mar 2022 19:24:57 +0100
Message-Id: <20220303182508.288136-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The idea here is to provide a fully synchronous Tx API and also be able
to be sure that a transfer as finished. This will be used later by
another series. However, while working on this task, it appeared
necessary to first rework the way MLME errors were (not) propagated to
the upper layers. This small series tries to tackle exactly that.

Changes in v3:
* Split the series into two parts, this is the "error handling" halve.
* Reworked the error path to not handle the ifs_handling situation
  anymore.
* Enhanced the list of MLME status codes available.
* Improved the error handling by collecting the error codes, somethimes
  by changing device drivers directly to propagate these MLME
  statuses. Then, once in the core, save one global Tx status value so
  that in the case of synchronous transfers we can check the return
  value and eventually error out.
* Prevented the core to stop the device before the end of the last
  transmission to avoid deadlocks by just sync'ing the last Tx
  transfer.

Changes in v2:
* Adapted with the changes already merged/refused.

Miquel Raynal (11):
  net: ieee802154: Enhance/fix the names of the MLME return codes
  net: ieee802154: Fill the list of MLME return codes
  net: mac802154: Create a transmit error helper
  net: mac802154: Save a global error code on transmissions
  net: ieee802154: at86rf230: Assume invalid TRAC if not recognized
  net: ieee802154: at86rf230: Return early in case of error
  net: ieee802154: at86rf230: Provide meaningful error codes when
    possible
  net: ieee802154: at86rf230: Call _xmit_error() when a transmission
    fails
  net: ieee802154: atusb: Call _xmit_error() when a transmission fails
  net: ieee802154: ca8210: Use core return codes instead of hardcoding
    them
  net: ieee802154: ca8210: Call _xmit_error() when a transmission fails

 drivers/net/ieee802154/at86rf230.c |  73 ++++++++----
 drivers/net/ieee802154/atusb.c     |   5 +-
 drivers/net/ieee802154/ca8210.c    | 182 +++++++++++------------------
 include/linux/ieee802154.h         |  81 +++++++++++--
 include/net/mac802154.h            |  10 ++
 net/mac802154/ieee802154_i.h       |   2 +
 net/mac802154/util.c               |  16 ++-
 7 files changed, 220 insertions(+), 149 deletions(-)

-- 
2.27.0

