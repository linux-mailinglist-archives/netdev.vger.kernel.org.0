Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6AA54FDBF
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 21:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236553AbiFQTdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 15:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiFQTdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 15:33:01 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F009DE84;
        Fri, 17 Jun 2022 12:32:59 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 06FA7C0005;
        Fri, 17 Jun 2022 19:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1655494377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=a018nv1+KW3o5XQ475gvD/KO2CtmK+QeMl91GzLBs28=;
        b=bUBRG7PWpyUbbhAGA/s9wDKyH4x6/s1uUdkgOEGeCe0KVIk0Ct1qPN1rPm/AC3xOYYhzao
        KbT9EFlNLHzD2T2SYp5SauCxzhb0r/RkQpk7VIfu1yv8AXKwXSKBGGmjOv3HH6zIbjCwP+
        JFw+qousT8Tx9QtwZ0PMwJ+Ipz4jroij1nfiGqyMJRKUDaOw0eZ8XFhWAaNAVqR13ZmMjx
        EgIs48qPicC8p5cXfEsvQBPmXpEyMF6r6+IuGX0iE9BkqQDvil0DQw9gJHENVpwFUTyR8n
        NR6TMHixSyGfiBLNy8AqRDDAEaMSaMksFkuJloUTGnOn4djJZ2F4q1YYYEXCUw==
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
Subject: [PATCH wpan-next v2 0/6] net: ieee802154: PAN management
Date:   Fri, 17 Jun 2022 21:32:48 +0200
Message-Id: <20220617193254.1275912-1-miquel.raynal@bootlin.com>
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

Last step before adding scan support, we need to introduce a proper PAN
description (with its main properties) and PAN management helpers.

This series provides generic code to do simple operations on PANs and
PAN coordinators.

Thanks,
Miquèl

Changes in v2:
* The main change is related to the use of the COORD interface (instead
  of dropping it). Most of the actual diff is in the following series.

David Girault (1):
  net: ieee802154: Trace the registration of new PANs

Miquel Raynal (5):
  net: ieee802154: Create a device type
  net: ieee802154: Ensure only FFDs can become PAN coordinators
  net: mac802154: Allow the creation of PAN coordinator interfaces
  net: ieee802154: Add support for inter PAN management
  net: ieee802154: Give the user to the PAN information

 include/net/cfg802154.h   |  31 +++++
 include/net/nl802154.h    |  57 ++++++++++
 net/ieee802154/Makefile   |   2 +-
 net/ieee802154/core.c     |   2 +
 net/ieee802154/core.h     |  33 ++++++
 net/ieee802154/nl802154.c | 206 ++++++++++++++++++++++++++++++++-
 net/ieee802154/pan.c      | 234 ++++++++++++++++++++++++++++++++++++++
 net/ieee802154/trace.h    |  25 ++++
 net/mac802154/iface.c     |  14 ++-
 net/mac802154/rx.c        |   2 +-
 10 files changed, 595 insertions(+), 11 deletions(-)
 create mode 100644 net/ieee802154/pan.c

-- 
2.34.1

