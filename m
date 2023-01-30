Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD34C681556
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 16:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236508AbjA3PnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 10:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbjA3PnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 10:43:14 -0500
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83170B47F;
        Mon, 30 Jan 2023 07:43:12 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 105CD1BF20F;
        Mon, 30 Jan 2023 15:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675093391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UgDF6XswPVIJMHmBH/cRGdx6mNnueiaomb/l7bbA2As=;
        b=jLhDubxcszUNdAv8g2R1BGlYAOAeo1tu9LwxcLkMSqwSTecEEbsAdRqgB+tpmgKIszWtnh
        6KIZDFKCEAGuHzSaXSWAFF0tnM0RRoHG2gNOaIQDTkSr227KCBHasOXoX9xowu+yxRuAd3
        eI3W2h7c1UlkO+zuTdX4VjglYrHs7Y3UGsG1doDKayWCAVoXGhG02vGOTYQdnaOGGBDe9G
        4MhTBboPgVfaXslsIWYDBXJE5Utn/w5ux8iPnfL+df3LmB9vM6CtvsRX6bFVJl73RTqx5D
        dYwrRWG5IdUZKxodbfDy1Aq2tdTsawyQYklFjIKJ4ExaH/ZuhtmNHg2nGXIkKw==
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
        Miquel Raynal <miquel.raynal@bootlin.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH wpan-next] mac802154: Avoid superfluous endianness handling
Date:   Mon, 30 Jan 2023 16:43:06 +0100
Message-Id: <20230130154306.114265-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When compiling scan.c with C=1, Sparse complains with:

   sparse:     expected unsigned short [usertype] val
   sparse:     got restricted __le16 [usertype] pan_id
   sparse: sparse: cast from restricted __le16

   sparse:     expected unsigned long long [usertype] val
   sparse:     got restricted __le64 [usertype] extended_addr
   sparse: sparse: cast from restricted __le64

The tool is right, both pan_id and extended_addr already are rightfully
defined as being __le16 and __le64 on both sides of the operations and
do not require extra endianness handling.

Fixes: 3accf4762734 ("mac802154: Handle basic beaconing")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/mac802154/scan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
index cfbe20b1ec5e..8f98efec7753 100644
--- a/net/mac802154/scan.c
+++ b/net/mac802154/scan.c
@@ -419,8 +419,8 @@ int mac802154_send_beacons_locked(struct ieee802154_sub_if_data *sdata,
 	local->beacon.mhr.fc.source_addr_mode = IEEE802154_EXTENDED_ADDRESSING;
 	atomic_set(&request->wpan_dev->bsn, -1);
 	local->beacon.mhr.source.mode = IEEE802154_ADDR_LONG;
-	local->beacon.mhr.source.pan_id = cpu_to_le16(request->wpan_dev->pan_id);
-	local->beacon.mhr.source.extended_addr = cpu_to_le64(request->wpan_dev->extended_addr);
+	local->beacon.mhr.source.pan_id = request->wpan_dev->pan_id;
+	local->beacon.mhr.source.extended_addr = request->wpan_dev->extended_addr;
 	local->beacon.mac_pl.beacon_order = request->interval;
 	local->beacon.mac_pl.superframe_order = request->interval;
 	local->beacon.mac_pl.final_cap_slot = 0xf;
-- 
2.34.1

