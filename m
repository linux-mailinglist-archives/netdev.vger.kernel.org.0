Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09301551E46
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 16:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350021AbiFTOZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 10:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351100AbiFTOYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 10:24:32 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13AFC28E3E;
        Mon, 20 Jun 2022 06:40:22 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 3336C40002;
        Mon, 20 Jun 2022 13:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1655732420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=cReJwg111/Kka2t3uUDnStvxAa8TQUViqU4YfmtL0Ns=;
        b=LuoRGqkYrJXMfvnY3DajDtFI9BHEt+erIeTqlp18uL+RbQ0xlxE9Zx0T9y8BhZBAm7RDtA
        mn3RRcCe8QLjUGYRLIwRzMBTPBbzHSIbT5/bF0wOyeAK2t5eJqbaGGIChAKb2SNntEPQvJ
        xbFgLej4ca2gj3OreuA3t5Uz3Jkp2zDtVphi/9H6eV87K0iyCbEqxyoeOhEjtPfEzzFkk+
        c65pdKDG2heh93T56rkS0UuDe9ZEJ79SdMuDL6cfdbQ8FnFvy+umovO78SDG5+AFJOeWIm
        XIrFEXu3Tz3olWcO2moFwkqM1txKyw7SMEgqY3yQ5Kblkde6pCdeIzMBi+cO4Q==
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
Subject: [PATCH wpan-next v3 0/4] net: ieee802154: PAN management
Date:   Mon, 20 Jun 2022 15:40:14 +0200
Message-Id: <20220620134018.62414-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Last step before adding scan support, we need to introduce a proper PAN
description (with its main properties) and PAN management helpers.

This series provides generic code to do simple operations on the list of
surrounding PANs, such as registering, listing, flushing... The scanning
code will soon make use of these additions.

Thanks,
Miquèl

Changes in v3:
* Dropped the device type (FFD, RFD, etc) enumeration, all the checks
  that were related to this parameter and of course the additional user
  attribute which allowed to check for that value.
* Reworded a few commit messages.

Changes in v2:
* The main change is related to the use of the COORD interface (instead
  of dropping it). Most of the actual diff is in the following series.

David Girault (1):
  net: ieee802154: Trace the registration of new PANs

Miquel Raynal (3):
  net: mac802154: Allow the creation of coordinator interfaces
  net: ieee802154: Add support for inter PAN management
  net: ieee802154: Give the user access to list of surrounding PANs

 include/net/cfg802154.h   |  31 +++++
 include/net/nl802154.h    |  49 ++++++++
 net/ieee802154/Makefile   |   2 +-
 net/ieee802154/core.c     |   2 +
 net/ieee802154/core.h     |  26 +++++
 net/ieee802154/nl802154.c | 199 +++++++++++++++++++++++++++++++-
 net/ieee802154/pan.c      | 234 ++++++++++++++++++++++++++++++++++++++
 net/ieee802154/trace.h    |  25 ++++
 net/mac802154/iface.c     |  14 ++-
 net/mac802154/rx.c        |   2 +-
 10 files changed, 574 insertions(+), 10 deletions(-)
 create mode 100644 net/ieee802154/pan.c

-- 
2.34.1

