Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFE34AC26F
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353420AbiBGPFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:05:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442261AbiBGOsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:48:10 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64AAC0401C2;
        Mon,  7 Feb 2022 06:48:09 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 0115320007;
        Mon,  7 Feb 2022 14:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1644245286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=eaDB1UBx5XrPGGkfvZYFP+JmE3S6lTPw6aBzvBv+vXs=;
        b=fQV/JLwWKRK+XtGN39BnOX3TjF4kxcBM6XSOtLl4tdhFLG+c7Yvst8t1GmWO1mUWR/VOPh
        rB0e3R5OKS+ItbuLisobX7+GKAyMqPM5fRstgfEDrvvwLpEQpa4BOgO9u+daYfpq6Rwm4C
        ALFQQNFkKEcNQ8RrJy/VfrcRlb1e3OdQ6HSg61Z3+l34/21C21wVMoEO52rmpATVs1uTfZ
        1vwW2pGP/6JtRqiW4Jw69+6R/LBeDkG2/xnsfjJGpWHQU1jwqxz2fUWXLhGPYsHx1uekQ+
        aSvKfc82j8QStW1rHUKdAF1d0G3fGaQ4X21RlRNXAIFM4trfVYlTb0sMZ1YB7A==
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
Subject: [PATCH wpan-next v2 00/14] ieee802154: Synchronous Tx API
Date:   Mon,  7 Feb 2022 15:47:50 +0100
Message-Id: <20220207144804.708118-1-miquel.raynal@bootlin.com>
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
another series.

The first patches create an error helper and then use it in order to
have only two "end of transmission" helpers that are always called.

Then, a bit of cleanup regarding the naming and the locations of certain
peaces of code is done.

Finally, we create a hot and a slow path, add the necessary logic to be
able to track ongoing transfers and when the queue must be kept on hold,
until we finally create a helper to stop emitting after the last
transfer, which we then use to create a synchronous MLME API.

Changes in v2:
* Adapted with the changes already merged/refused.

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
 drivers/net/ieee802154/ca8210.c    |  7 +++--
 include/net/cfg802154.h            |  5 ++++
 include/net/mac802154.h            | 37 +++++++----------------
 net/ieee802154/core.c              |  1 +
 net/mac802154/cfg.c                |  5 ++--
 net/mac802154/ieee802154_i.h       | 35 ++++++++++++++++++++--
 net/mac802154/main.c               |  2 +-
 net/mac802154/tx.c                 | 48 +++++++++++++++++++++++++-----
 net/mac802154/util.c               | 39 ++++++++++++++++++++----
 11 files changed, 134 insertions(+), 52 deletions(-)

-- 
2.27.0

