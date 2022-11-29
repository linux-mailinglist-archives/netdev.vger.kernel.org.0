Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835FD63C186
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 14:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbiK2Nzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 08:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiK2Nzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 08:55:46 -0500
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB87B56EEF;
        Tue, 29 Nov 2022 05:55:41 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id D39CBFF808;
        Tue, 29 Nov 2022 13:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669730140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=b1hvMzyDfgcapMhR9y1z+djtVZr7gypeYyBgGbCnvPY=;
        b=Jk/Txl+6Gu70L/hNZynkv0GkE03Jwz4YEwvT2cJMAaYBfVH8OoDGZxbl9pHLpp0wwveJMa
        3tgOXNpv/xnYs1j+Wa/v1SVNm+r/V7cyYuSInAzj557w/dYgk6M898eoC5ZMepUq7IasBc
        SBvlAacJ5qZjdqbXzAzCTwV1K8xS1V89+pdmbmveKGovqC1YdBZr/s+nHWlgwiOR9ACsJ6
        M+j5VuIQz4VXT/Qpw+6bvwvRl0D8h3PqLCIVClSW+bkeD52O49xxQSSrvAynWctp+0bWNr
        p6S38j2n2MdjKO10W+SCriVnhrdhlWXyCPF6562A0p0Ktluh3tGydrjyImvKTA==
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
Subject: [PATCH wpan-next v3 0/2] IEEE 802.15.4 PAN discovery handling
Date:   Tue, 29 Nov 2022 14:55:33 +0100
Message-Id: <20221129135535.532513-1-miquel.raynal@bootlin.com>
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

Hello,

>>> Just a resent of the v2, rebased <<<

Last preparation step before the introduction of the scanning feature
(really): generic helpers to handle PAN discovery upon beacon
reception. We need to tell user space about the discoveries.

In all the past, current and future submissions, David and Romuald from
Qorvo are credited in various ways (main author, co-author,
suggested-by) depending of the amount of rework that was involved on
each patch, reflecting as much as possible the open-source guidelines we
follow in the kernel. All this effort is made possible thanks to Qorvo
Inc which is pushing towards a featureful upstream WPAN support.

Cheers,
Miquèl

Changes in v3:
* Rebased on wpan-next/master.

Changes in v2:
* Dropped all the logic around the knowledge of PANs: we forward all
  beacons received to userspace and let the user decide whether or not
  the coordinator is new or not.
* Changed the coordinator descriptor address member to a proper
  structure (not a pointer).

David Girault (1):
  mac802154: Trace the registration of new PANs

Miquel Raynal (1):
  ieee802154: Advertize coordinators discovery

 include/net/cfg802154.h   |  18 +++++++
 include/net/nl802154.h    |  43 ++++++++++++++++
 net/ieee802154/nl802154.c | 103 ++++++++++++++++++++++++++++++++++++++
 net/ieee802154/nl802154.h |   2 +
 net/mac802154/trace.h     |  25 +++++++++
 5 files changed, 191 insertions(+)

-- 
2.34.1

