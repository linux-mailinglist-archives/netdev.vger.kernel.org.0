Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF24367AFAE
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 11:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235584AbjAYK33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 05:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235354AbjAYK32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 05:29:28 -0500
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605FE3D0BC;
        Wed, 25 Jan 2023 02:29:27 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id EB51B24000F;
        Wed, 25 Jan 2023 10:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1674642565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ATB5Vml7y+cYWd6nni5dWMmvyTA/B7/6gbZdFbLw0Uk=;
        b=BXOvmBtX6yTDLN5uD5vk/YrnWSbozxJE8mzW+Lm9yvLnV9TZlZtvnru83U7jhVuT8+nRn2
        RHNGsbqTURjM5toXTVHxfFLJ1Qw5MmRcBebsm5A2oOUohfZE9jUBcWlU9OArtveRAc6Dco
        Dd/daWyJaID/7lcoaKhe0KKVpt8SXRCui/DEFjbJA7EZvqeH8aNpkRSXWpJLjwc97LVO4g
        xcJL0P+NHlqODkjVFzLUbeAed9P+89IZkJ0xnl0zu9GJFrtWN5oJONLb3Q0iKbeShLewDT
        plN6kTLpgFQqisl0yX0Prn2B3D18019Xl2xyzE+DdFR3+7ucTryKfdy7QRCWmA==
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
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v2 0/2] ieee802154: Beaconing support
Date:   Wed, 25 Jan 2023 11:29:21 +0100
Message-Id: <20230125102923.135465-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Scanning being now supported, we can eg. play with hwsim to verify
everything works as soon as this series including beaconing support gets
merged.

Thanks,
Miquèl

Changes in v2:
* Clearly state in the commit log llsec is not supported yet.
* Do not use mlme transmission helpers because we don't really need to
  stop the queue when sending a beacon, as we don't expect any feedback
  from the PHY nor from the peers. However, we don't want to go through
  the whole net stack either, so we bypass it calling the subif helper
  directly.

Miquel Raynal (2):
  ieee802154: Add support for user beaconing requests
  mac802154: Handle basic beaconing

 include/net/cfg802154.h         |  23 +++++
 include/net/ieee802154_netdev.h |  16 ++++
 include/net/nl802154.h          |   3 +
 net/ieee802154/header_ops.c     |  24 +++++
 net/ieee802154/nl802154.c       |  93 ++++++++++++++++++++
 net/ieee802154/nl802154.h       |   1 +
 net/ieee802154/rdev-ops.h       |  28 ++++++
 net/ieee802154/trace.h          |  21 +++++
 net/mac802154/cfg.c             |  31 ++++++-
 net/mac802154/ieee802154_i.h    |  18 ++++
 net/mac802154/iface.c           |   3 +
 net/mac802154/llsec.c           |   5 +-
 net/mac802154/main.c            |   1 +
 net/mac802154/scan.c            | 151 ++++++++++++++++++++++++++++++++
 14 files changed, 415 insertions(+), 3 deletions(-)

-- 
2.34.1

