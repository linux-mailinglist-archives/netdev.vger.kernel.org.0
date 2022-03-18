Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988164DE171
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 19:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240264AbiCRS6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 14:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239672AbiCRS6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 14:58:09 -0400
X-Greylist: delayed 39534 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 18 Mar 2022 11:56:49 PDT
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60A5223BC3;
        Fri, 18 Mar 2022 11:56:48 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 83516C0007;
        Fri, 18 Mar 2022 18:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647629807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZngBw8RPaSNnQzs7KObYiIjcLSn5DWlyyJF8eJWztrU=;
        b=PTFLOLFKxBL91ffNYpIZVn9354GWq8AtzYtyNfFRFNHBR+78w0DcZHyNesipOjFiufMvap
        F3z6PPgscPRSTF6F2IjnFngqvDn8eWqzleauqASzd9cYbHosjdIxFYCvXjtArbdGwgdxV+
        HzVcnYq1p2ziUBcgyDwgz7t6ft8Xr83pGgal8Z5AH/wMxhAbdlYaO+cDl953uZ1SjPS4Rz
        baPx783IWwjI+2jlPmrVCeQwLxgZvAon8nYwfhKMTJTtJzRqaKKVn6+cP71dcEu6mu1kXJ
        bkAkGjZDv1g97VhS5kikYbdkXO8Wu2vu7KHZlWFCSy6j1kxzNfO8q6vIYfIjSA==
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
Subject: [PATCH wpan-next v4 00/11] ieee802154: Better Tx error handling
Date:   Fri, 18 Mar 2022 19:56:33 +0100
Message-Id: <20220318185644.517164-1-miquel.raynal@bootlin.com>
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

The idea here is to provide a fully synchronous Tx API and also be able
to be sure that a transfer as finished. This will be used later by
another series. However, while working on this task, it appeared
necessary to first rework the way MLME errors were (not) propagated to
the upper layers. This small series tries to tackle exactly that.

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

Miquel Raynal (11):
  net: ieee802154: Enhance/fix the names of the MLME return codes
  net: ieee802154: Fill the list of MLME return codes
  net: mac802154: Save a global error code on transmissions
  net: mac802154: Create a transmit error helper
  Revert "at86rf230: add debugfs support"
  net: ieee802154: at86rf230: Error out upon failed offloaded
    transmissions
  net: ieee802154: at86rf230: Provide meaningful error codes when
    possible
  net: ieee802154: at86rf230: Call _xmit_error() when a transmission
    fails
  net: ieee802154: atusb: Call _xmit_error() when a transmission fails
  net: ieee802154: ca8210: Use core return codes instead of hardcoding
    them
  net: ieee802154: ca8210: Call _xmit_error() when a transmission fails

 drivers/net/ieee802154/Kconfig     |   7 --
 drivers/net/ieee802154/at86rf230.c | 139 +++++-----------------
 drivers/net/ieee802154/atusb.c     |   5 +-
 drivers/net/ieee802154/ca8210.c    | 182 +++++++++++------------------
 include/linux/ieee802154.h         |  81 +++++++++++--
 include/net/mac802154.h            |  10 ++
 net/mac802154/ieee802154_i.h       |   2 +
 net/mac802154/util.c               |  16 ++-
 8 files changed, 202 insertions(+), 240 deletions(-)

-- 
2.27.0

