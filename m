Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409575ADA36
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 22:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbiIEUeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 16:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiIEUeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 16:34:20 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B561115FE1;
        Mon,  5 Sep 2022 13:34:18 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id AA935FF806;
        Mon,  5 Sep 2022 20:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1662410057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=lqhGDOI8GVtLJGvyWnop/3a2J/7ykrhptY3GPc6vWOI=;
        b=AB9sSWbRUr7mJkgsmRyZj7h9LF/eWttFDZc8fG0Kjzd6+ygk2pL9IhtX/vx6afaQNKb6vJ
        PhSQFQeKPrYBhbYIAMA/IveIm5PHFteZX9pnzUjN+qW/v5T8jMUX9BrqCGb3KN1K444tO1
        RdROJ9rj4goLOLALOwLP3Z9RP4R8DSIdFR/QErDiguy1Xp50lqXSAbXswzTHjSKlTw0WBI
        9G3SEm3GWZM0TsW8pA7yjjj0MtiI+WidkDa7sgVzZt+fxPBDzlzhafHDQcnyuE70tiIY5u
        yJghyyrLtlT4jqTDoT1yb2wcpEwNBIOk31j50R/0Q4PpsDu6PtePd0yjCVWvew==
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
Subject: [PATCH wpan/next v3 0/9] net: ieee802154: Support scanning/beaconing
Date:   Mon,  5 Sep 2022 22:34:03 +0200
Message-Id: <20220905203412.1322947-1-miquel.raynal@bootlin.com>
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

A third version of this series, dropping the scan patches for now
because before we need to settle on the filtering topic and the
coordinator interface topic. Here is just the filtering part, I've
integrated Alexander's patches, as well as the atusb fix. Once this is
merge there are a few coordinator-related patches, and finally the
scan.

Thanks,
Miquèl

Changes in v3:
* Full rework of the way the promiscuous mode is handled, with new
  filtering levels, one per-phy and the actual one on the device.
* Dropped all the manual acking, everything is happenging on hardware.
* Better handling of the Acks in atusb to report the trac status.


Alexander Aring (3):
  net: mac802154: move receive parameters above start
  net: mac802154: set filter at drv_start()
  ieee802154: atusb: add support for trac feature

Miquel Raynal (6):
  net: mac802154: Introduce filtering levels
  net: mac802154: Don't limit the FILTER_NONE level to monitors
  net: mac802154: Drop IEEE802154_HW_RX_DROP_BAD_CKSUM
  net: mac802154: Add promiscuous software filtering
  net: mac802154: Ensure proper scan-level filtering
  net: mac802154: Ensure proper general purpose frame filtering

 drivers/net/ieee802154/atusb.c           |  33 ++-
 drivers/net/ieee802154/mac802154_hwsim.c |   3 +-
 include/linux/ieee802154.h               |  24 ++
 include/net/cfg802154.h                  |   7 +-
 include/net/ieee802154_netdev.h          |   8 +
 include/net/mac802154.h                  |   4 -
 net/mac802154/cfg.c                      |   3 +-
 net/mac802154/driver-ops.h               | 284 ++++++++++++++---------
 net/mac802154/ieee802154_i.h             |   4 +
 net/mac802154/iface.c                    |  44 ++--
 net/mac802154/rx.c                       | 129 +++++++++-
 11 files changed, 388 insertions(+), 155 deletions(-)

-- 
2.34.1

