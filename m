Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9274352D6D7
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 17:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240371AbiESPFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 11:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240530AbiESPFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 11:05:23 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C127913FB4;
        Thu, 19 May 2022 08:05:20 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2A40F1BF210;
        Thu, 19 May 2022 15:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652972719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=x3oMINLuLXHgWQu8OA0jQ0SRhIC58wy3cKoGvq0tx3c=;
        b=D/986MERqQP2dDwkwAid7ms3dm2L1s6aUYMDdoCsSnLOfEk4MN6V/3S578D6Gw4ZEuXO9c
        KqaFZG6j0CDSvlH+S+klo29GEGnfd2TM/MqTbTUGWEuDATBullRP+OEUSLLAiicaZNIMbw
        zBcwmSCvskj6Hbtei4OqvtsWlpRrXxXJNfyQTJGcyz5LMA2jaevMSh/uAQP8UyHDMpbfa0
        /6W587lhpfxwi2SV2YvoxHQxXlW8coZ3gop27H9vloQhVs6hvI0/xb/HVyHcOZVAe04Qji
        GWqRA+/4PZRI0fUi50T9I7BbUKwPDtQNS5ojd6hcHTlB8ivaf+ucj6fz6lToWw==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v4 00/11] ieee802154: Synchronous Tx support
Date:   Thu, 19 May 2022 17:05:05 +0200
Message-Id: <20220519150516.443078-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
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

Hello,

This series brings support for that famous synchronous Tx API for MLME
commands.

MLME commands will be used during scan operations. In this situation,
we need to be sure that all transfers finished and that no transfer
will be queued for a short moment.

Cheers,
Miquèl

Changes in v4:
* Made visible the mlme_tx{_pre,,_post} helpers, used them later in the
  scanning code where relevant.
* Used the atomic_fetch_inc() alternative to only stop the queue when
  necessary.
* Used the netif_running() helper in place of the manual check against
  the IFF_UP netdev flag.
* Changed the error codes to ENETDOWN if the device was closed.
* Reworked the MLME transmissions error path so that they would not keep
  the rtnl taken.
* Updated the logic to avoid erroring out on the mlme_op_pre() call
  which just returns the code of the previous transmission (which we
  likely do not care about here).
* Dropped the queue_stopped variable, used the existing "flags"
  variable, turning it into an unsigned long so that it would accept
  atomic operations. Created a WPAN_PHY_FLAG_STATE_QUEUE_STOPPED
  definition for this purpose.

Changes in v3:
* Tested with lockdep enabled, a more aggressive preemption level and
  the sleeping while atomic warnings enabled.
* Changed the hold/release queue mutex into a spinlock.
* Split the mlme_tx function into three, one to hold the queue, then
  another part that does takes the rtnl and has the real content, and a
  last helper to release the queue.
* Fixed the warning condition in the slow path.
* Used an unsigned long and test/set_bit helpers to follow the queue
  state instead of an atomic_t.

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
  net: mac802154: Bring the ability to hold the transmit queue
  net: mac802154: Create a hot tx path
  net: mac802154: Introduce a helper to disable the queue
  net: mac802154: Introduce a tx queue flushing mechanism
  net: mac802154: Introduce a synchronous API for MLME commands
  net: mac802154: Add a warning in the hot path
  net: mac802154: Add a warning in the slow path

 include/net/cfg802154.h      |  13 +++-
 include/net/mac802154.h      |  27 -------
 net/ieee802154/core.c        |   3 +
 net/mac802154/cfg.c          |   4 +-
 net/mac802154/ieee802154_i.h |  40 +++++++++-
 net/mac802154/main.c         |   2 +-
 net/mac802154/tx.c           | 147 +++++++++++++++++++++++++++++++----
 net/mac802154/util.c         |  71 +++++++++++++++--
 8 files changed, 252 insertions(+), 55 deletions(-)

-- 
2.34.1

