Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7213762FFCE
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 23:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbiKRWLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 17:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbiKRWKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 17:10:50 -0500
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5229631F97;
        Fri, 18 Nov 2022 14:10:46 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 23B51FF803;
        Fri, 18 Nov 2022 22:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1668809444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=dTlVCjNqg7y+V9nyr2HcMm/ySt8TD7VcTdCsIjfxyEk=;
        b=bkpjiU4LieZ8FWVsrpD4k+CPoGhm7KnsZmEi7GbcLRYvFHBEkhFPzYk4RJJ5TZDxmKlkmh
        uvltaoOKpxHAXbghNiUgQRcZOPNkE35OF+EGSTknpxCfK8DyCHlalPAeZiEKgxX5AZ1nMO
        5u9fxnqnksrZ8l9DXSE5d+CWRCLyefEOC1bJ3r7z+Q8aNvB90Mt57OzLr5XGKEURdfaAtt
        Fi4mGmjSL17FUmNc4OpPAtsKQVoXT21l3x0XRUYEOdTZjHpLoVMYy6ZklBMVJN8pvSCYc7
        /iBrF7UCIIZd0ea/9YW6erKEEEW2uw6eeilCV3oNKrilRZTjID/ddI1tdHlTKw==
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
Subject: [PATCH wpan-next v2 0/2] IEEE 802.15.4 PAN discovery handling
Date:   Fri, 18 Nov 2022 23:10:39 +0100
Message-Id: <20221118221041.1402445-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

