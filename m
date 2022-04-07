Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79AF14F7C65
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244122AbiDGKLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244119AbiDGKLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:11:07 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C940B05;
        Thu,  7 Apr 2022 03:09:06 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8D6B66000F;
        Thu,  7 Apr 2022 10:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649326145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=tSrPTpuEu5oOylzMM4RajwuVUm7Olxs0UWouqcFW/og=;
        b=BeSH99K4soFbUY52Fx/bVVqbpZxUTz1+javCRXm/FsnVjjrhQ2CQebzi2FKpqzldLyuvt3
        SSwSmpjYNSkDrH2/uoAajs9BYxrFB6AfbELLkHaV3Fpgr4GHFmrnqdcSAQ74iQni3FybDL
        vxjW8VUls02BxwuaV0kFbK3s8C2p/fgdOjUE9zqOaGCKstw6OeThVJRq59yQq8pX0eoW3C
        OyvlVdf1SQEREzQHbzdSUTJw5ZRuJPjQ4KIDzcn7MQdp7QJtu1vYgUjbGJwb6B67s1Ktjv
        15JpspnFjb8v7IolFOtE1TnbnUke18b4ieUgyjaiyWKRSenLY6qS/r744/zVGw==
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
Subject: [PATCH v6 00/10] ieee802154: Better Tx error handling
Date:   Thu,  7 Apr 2022 12:08:53 +0200
Message-Id: <20220407100903.1695973-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The idea here is to provide a fully synchronous Tx API and also be able
to be sure that a transfer has finished. This will be used later by
another series. However, while working on this task, it appeared
necessary to first rework the way MLME errors were (not) propagated to
the upper layers. This small series tries to tackle exactly that, before
introducing the synchronous API.

Changes in v6:
* Dropped the renaming of the asynchronous error functions in the
  at86rf320 driver to avoid confusions between asynchronous bus errors
  and timeout errors.
* Called the _xmit_error() helper from _xmit_bus_error() to avoid hard
  coding almost the exact same lines.
* Renamed _xmit_bus_error() into _xmit_hw_error() which I think fits
  better the purpose of the helper: we signify a hardware error when
  offloading the frame to the hardware.
* Improved a little bit the kdoc of _xmit_error() to mention that we are
  returning here the errors from successfully offloaded transmissions.
* Called _xmit_hw_error() from atsub.c.

Changes in v5:
* Introduced a new helper which should be used upon bus errors. We don't
  ask users to provide an error code (which would be misleading) and
  instead forward IEEE802154_SYSTEM_ERROR which is our generic code.
* Dropped most of my changes in the at86rf320 driver in order to do
  things a little bit differently:
  - the existing error path is renamed to clearly identify that it
    handles bus errors.
  - trac errors are handled in a separate path and the core helper is
    used to return the trac value.
* Merged the revert commit with the following commit forwarding trac
  errors to the core.

Changes in v4:
* Reverted the at86rf320 patch introducing trac values for debugfs
  purposes as suggested by Alex. Reintroduced some of its content in a
  subsequent patch to filter out offloaded transmission error cases.
* Used IEEE802154_SYSTEM_ERROR as a non specific error code.

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

Miquel Raynal (10):
  net: ieee802154: Enhance/fix the names of the MLME return codes
  net: ieee802154: Fill the list of MLME return codes
  net: mac802154: Save a global error code on transmissions
  net: mac802154: Create an offloaded transmission error helper
  net: mac802154: Create an error helper for asynchronous offloading
    errors
  net: ieee802154: at86rf230: Call _xmit_hw_error() when failing to
    offload frames
  net: ieee802154: at86rf230: Forward Tx trac errors
  net: ieee802154: atusb: Call _xmit_hw_error() upon transmission error
  net: ieee802154: ca8210: Use core return codes instead of hardcoding
    them
  net: ieee802154: ca8210: Call _xmit_error() when a transmission fails

 drivers/net/ieee802154/Kconfig     |   7 --
 drivers/net/ieee802154/at86rf230.c | 130 ++++-----------------
 drivers/net/ieee802154/atusb.c     |   4 +-
 drivers/net/ieee802154/ca8210.c    | 181 +++++++++++------------------
 include/linux/ieee802154.h         |  81 +++++++++++--
 include/net/mac802154.h            |  19 +++
 net/mac802154/ieee802154_i.h       |   2 +
 net/mac802154/util.c               |  22 +++-
 8 files changed, 207 insertions(+), 239 deletions(-)

-- 
2.27.0

