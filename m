Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEBF2525028
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 16:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355321AbiELOd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 10:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355337AbiELOd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 10:33:26 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D92425D130;
        Thu, 12 May 2022 07:33:19 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 5B329FF80F;
        Thu, 12 May 2022 14:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652365998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0Nolu4+cxZot8KO9Bdp6XNPXS6bQvguk5M6CgMmIybk=;
        b=gBmQ5J0s5UAv4jRioQSfuDA4lqrk9vZfaEN0od+FtwB6gtHI7bdD32UviPwyG7RibqhUsb
        LQnWPD/adT3aW7yYQ+//nrJfUn6pR4odm1Uv0EwbEGtgPc7CajTUZRO0YUQSr6NQ5/FyI0
        NWYG8VRvPhvj1epWdRI0lIc7ARVLzt32LSVjwc8EfVu6GKHe6P/jZlblic0gZ2mz/fTjsU
        stwkCxYp8Q1emwcAxGFga2ABDNvWUj3mzOYbNpL+jFZDzFWLnVI7nkT1ausVavVgikDp4r
        0Y42A2CKl4vp2uh+aRvML9enGfIMf6S2DkWX+ysgz42IkyA1jX09CLiuim23Fw==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v2 00/11] ieee802154: Synchronous Tx support
Date:   Thu, 12 May 2022 16:33:03 +0200
Message-Id: <20220512143314.235604-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
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

New series bringing support for that famous synchronous Tx API for MLME
commands.

MLME commands will be used for during scan operations.

We need to be able to be sure that all transfers finished and that no
transfer will be queued for a short moment.

Cheers,
Miquèl

Changes in v2:
* Updated the main tx function error path.
* Added a missing atomic_dec_at_test() call on the hold counter.
* Always called (upon a certain condition) the queue wakeup helper from
  the release queue helper (and similarly in the hold helper) and
  squashed two existing patches in it to simplify the series.
* Introduced a mutex to serialize accesses to the increment/decrement of
  the hold counter and the wake up call.
* Added a warning in case an MLME Tx gets triggered while the device was
  stopped.
* Used the rtnl to ensure the device cannot be stopped while an MLME
  transmission is ongoing.

Changes in v1 since this series got extracted from a bigger change:
* Introduced a new atomic variable to know when the queue is actually
  stopped. So far we only had an atomic to know when the queue was held
  (indicates a transitioning state towards a stopped queue only) and
  another atomic indicating if a transfer was still ongoing at this
  point (used by the wait logic as a condition to wake up).


Miquel Raynal (11):
  net: mac802154: Rename the synchronous xmit worker
  net: mac802154: Rename the main tx_work struct
  net: mac802154: Enhance the error path in the main tx helper
  net: mac802154: Follow the count of ongoing transmissions
  net: mac802154: Bring the hability to hold the transmit queue
  net: mac802154: Create a hot tx path
  net: mac802154: Introduce a helper to disable the queue
  net: mac802154: Introduce a tx queue flushing mechanism
  net: mac802154: Introduce a synchronous API for MLME commands
  net: mac802154: Add a warning in the hot path
  net: mac802154: Add a warning in the slow path

 include/net/cfg802154.h      |   7 ++
 include/net/mac802154.h      |  27 --------
 net/ieee802154/core.c        |   3 +
 net/mac802154/cfg.c          |   4 +-
 net/mac802154/ieee802154_i.h |  37 +++++++++-
 net/mac802154/main.c         |   2 +-
 net/mac802154/tx.c           | 126 +++++++++++++++++++++++++++++++----
 net/mac802154/util.c         |  67 +++++++++++++++++--
 8 files changed, 220 insertions(+), 53 deletions(-)

-- 
2.27.0

