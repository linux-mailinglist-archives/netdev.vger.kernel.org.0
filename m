Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3A365C453
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 17:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238206AbjACQ5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 11:57:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237887AbjACQ4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 11:56:50 -0500
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F122B30;
        Tue,  3 Jan 2023 08:56:48 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 7C58F240002;
        Tue,  3 Jan 2023 16:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1672765007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=E4d3gAcNsfOmX4aQ2aVWG/2biS4kFpgc3B+8GMBBtEM=;
        b=IQwSUc9g+xYJtXktfJZth+aG9YCZsKM9HDWq/IVF+z2/xouwAy+9Tyqhx0On/bKzBA/y/I
        BUg1INqJgUgyyn49/G0gIkfFOCTVHq0SoHUVbiVNmTGcxhIOq6HDge2dCFUoJuHUqZwHaB
        78+8d29GG+zFKSGG0IaxLXzVnN06w4Z9GqsgASZKdiwwS5jiDzYsMjYpk9dnYVZaJh0sbU
        BvJfXN3lOnc/N1TMiUqtbMGW7oxsQeg4oDJfNh2ua+Sbt7hqHen7AdnipH/PYjvYVijhCb
        Ar+JSEtkjTbqM1Rb4DcB7nBlK3KTqe2HSyS72ReMFdQrFX7x6PNm/QlgAMiP/g==
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
Subject: [PATCH wpan-next v3 0/6] IEEE 802.15.4 passive scan support
Date:   Tue,  3 Jan 2023 17:56:38 +0100
Message-Id: <20230103165644.432209-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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

Example of output:

	# iwpan monitor
	coord1 (phy #1): scan started
	coord1 (phy #1): beacon received: PAN 0xabcd, addr 0xb2bcc36ac5570abe
	coord1 (phy #1): scan finished
	coord1 (phy #1): scan started
	coord1 (phy #1): scan aborted

Cheers,
Miquèl

Changes in v3:
* Fixed most checkpatch.pl issues. A few remain to keep the visual
  consistent with the existing code (in the trace.h files).
* Added Alexander's Acked-by on each patch.

Changes in v2:
* Different way to forward the reason why a scan was terminated, instead
  of providing two different "commands" we provide the same "scan done"
  command and aside an attribute, saying whether the scan was aborted by
  the user or terminated by itself at the end of the required list of
  (complex) channels to scan.

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
 include/net/nl802154.h          |  58 +++++++
 net/ieee802154/nl802154.c       | 223 ++++++++++++++++++++++++-
 net/ieee802154/nl802154.h       |   3 +
 net/ieee802154/rdev-ops.h       |  28 ++++
 net/ieee802154/trace.h          |  40 +++++
 net/mac802154/Makefile          |   2 +-
 net/mac802154/cfg.c             |  33 +++-
 net/mac802154/ieee802154_i.h    |  43 ++++-
 net/mac802154/iface.c           |   3 +
 net/mac802154/main.c            |  36 ++--
 net/mac802154/rx.c              |  36 +++-
 net/mac802154/scan.c            | 288 ++++++++++++++++++++++++++++++++
 net/mac802154/tx.c              |  42 +++--
 16 files changed, 901 insertions(+), 32 deletions(-)
 create mode 100644 net/mac802154/scan.c

-- 
2.34.1

