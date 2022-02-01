Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF084A6327
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 19:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241761AbiBASGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 13:06:34 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:45217 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiBASGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 13:06:34 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id CCF0DC0008;
        Tue,  1 Feb 2022 18:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1643738792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=zb2aU6njNAyPcjaM2Z/f6ksFPnTsFp1ZR7F3/SRxBdk=;
        b=IWYbBKJLYLJlSVCIf3IJnvNEpJLypcUV2i/+5m+Ybku/dErOLLtCM+wuUb4OI1G/Lzv8Nq
        rEg+sbSHryZ7nJA9tfPtIzvyOIGkq19p6PnFnDqxMrz3HYWe/OnGM638JTFo+cBsNodJd/
        87VI7/K0PmNxSMcxxhHSXfyRHC7MN0b6DtAsRHo9OGkTenYioV2rJ0JayLCxyhFHx+HnZs
        nGwkr8Jo/OfefMrfrCsSkgLnpz7fa6P2fK6S/7Lnf0SfLTF6uFk3Jqo71OlhN+BgMc2Yp1
        TNdwKGgaYcbJihqkGloAUSLHEZYWlaMoX8uWbmRA1TQxFLnqAq4H+VwkB9lpAA==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v3 0/4] ieee802154: Improve durations handling
Date:   Tue,  1 Feb 2022 19:06:25 +0100
Message-Id: <20220201180629.93410-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches try to enhance the support of the various delays by adding
into the core the necessary logic to derive the actual symbol duration
(and then the lifs/sifs durations) depending on the protocol used. The
symbol duration type is also updated to fit smaller numbers.

Having the symbol durations properly set is a mandatory step in order to
use the scanning feature that will soon be introduced.

Changes since v2:
* Added the ca8210 driver fix.
* Fully dropped my rework of the way channels are advertised by device
  drivers. Adapted instead the main existing helper to derive durations
  based on the page/channel couple.

Miquel Raynal (4):
  net: ieee802154: ca8210: Fix lifs/sifs periods
  net: mac802154: Convert the symbol duration into nanoseconds
  net: mac802154: Set durations automatically
  net: ieee802154: Drop duration settings when the core does it already

 drivers/net/ieee802154/at86rf230.c | 33 ------------------
 drivers/net/ieee802154/atusb.c     | 33 ------------------
 drivers/net/ieee802154/ca8210.c    |  3 --
 drivers/net/ieee802154/mcr20a.c    |  5 ---
 include/net/cfg802154.h            |  6 ++--
 net/mac802154/cfg.c                |  1 +
 net/mac802154/main.c               | 54 +++++++++++++++++++++++++++---
 7 files changed, 55 insertions(+), 80 deletions(-)

-- 
2.27.0

