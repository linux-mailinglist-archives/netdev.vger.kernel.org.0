Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E1163C486
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236072AbiK2QCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:02:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236176AbiK2QCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:02:03 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DAB69DC0;
        Tue, 29 Nov 2022 08:00:52 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6A36C1C0014;
        Tue, 29 Nov 2022 16:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669737651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=PWrVBrgr0qlUu/E/9JfiYW88SJuanAXsEpngMFuZaJE=;
        b=cGvAEddJUuSZ1yjGX/M0/e7WRqEQP20rZybyKWR+LZBDtidXPy22Vj9xbDdqHFIaPrIDfq
        l5BoCg+gIp2s6ZCvh+vdfq5RtgXERCCm5UJ5ymRmd2cVi/lk57b46NEYJIrzNMIXuOEPiV
        uOArpPPYTSHorX8KTNZtNl3xrSmSL6jHDmsB5NWvMvAqz6SpmBK8pAGgrHPQYW5UwpWjmY
        IgjQcleA+t3mLJrOwNoL60ebi3cVTR43Y8MbODoVk5x1C11Uc4Tf/S+mpwMiVZPetHYGbR
        tP0Qe68qQC88Zkn6IWXYDs48q7gO6Lxnc0BlOFTIBIvCyGkQcmR2Uvq+D8EM9A==
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
Subject: [PATCH wpan-next 0/6] IEEE 802.15.4 passive scan support
Date:   Tue, 29 Nov 2022 17:00:40 +0100
Message-Id: <20221129160046.538864-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

We now have the infrastructure to report beacons/PANs, we also have the
capability to transmit MLME commands synchronously. It is time to use
these to implement a proper scan implementation.

There are a few side-changes which are necessary for the soft MAC scan
implementation to compile/work, but nothing big. The two main changes
are:
* The introduction of a user API for managing scans.
* The soft MAC implementation of a scan.

In all the past, current and future submissions, David and Romuald from
Qorvo are credited in various ways (main author, co-author,
suggested-by) depending of the amount of rework that was involved on
each patch, reflecting as much as possible the open-source guidelines we
follow in the kernel. All this effort is made possible thanks to Qorvo
Inc which is pushing towards a featureful upstream WPAN support.

Cheers,
Miquèl

Miquel Raynal (6):
  ieee802154: Add support for user scanning requests
  ieee802154: Define a beacon frame header
  ieee802154: Introduce a helper to validate a channel
  mac802154: Prepare forcing specific symbol duration
  mac802154: Add MLME Tx locked helpers
  mac802154: Handle passive scanning

 include/linux/ieee802154.h      |   7 +
 include/net/cfg802154.h         |  55 +++++-
 include/net/ieee802154_netdev.h |  36 ++++
 include/net/nl802154.h          |  49 ++++++
 net/ieee802154/nl802154.c       | 218 +++++++++++++++++++++++-
 net/ieee802154/nl802154.h       |   3 +
 net/ieee802154/rdev-ops.h       |  28 ++++
 net/ieee802154/trace.h          |  40 +++++
 net/mac802154/Makefile          |   2 +-
 net/mac802154/cfg.c             |  33 +++-
 net/mac802154/ieee802154_i.h    |  43 ++++-
 net/mac802154/iface.c           |   3 +
 net/mac802154/main.c            |  36 ++--
 net/mac802154/rx.c              |  36 +++-
 net/mac802154/scan.c            | 286 ++++++++++++++++++++++++++++++++
 net/mac802154/tx.c              |  42 +++--
 16 files changed, 885 insertions(+), 32 deletions(-)
 create mode 100644 net/mac802154/scan.c

-- 
2.34.1

