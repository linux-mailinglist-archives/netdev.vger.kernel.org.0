Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04EC0661460
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 10:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbjAHJue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 04:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232841AbjAHJuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 04:50:32 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFBD4183B3;
        Sun,  8 Jan 2023 01:50:29 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 3A1E318839BC;
        Sun,  8 Jan 2023 09:50:27 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 213EC250007B;
        Sun,  8 Jan 2023 09:50:27 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 16F399EC000B; Sun,  8 Jan 2023 09:50:27 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
Received: from fujitsu.vestervang (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id AF71E91201E4;
        Sun,  8 Jan 2023 09:50:26 +0000 (UTC)
From:   "Hans J. Schultz" <netdev@kapio-technology.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 net-next 1/3] net: dsa: mv88e6xxx: change default return of mv88e6xxx_port_bridge_flags
Date:   Sun,  8 Jan 2023 10:48:47 +0100
Message-Id: <20230108094849.1789162-2-netdev@kapio-technology.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230108094849.1789162-1-netdev@kapio-technology.com>
References: <20230108094849.1789162-1-netdev@kapio-technology.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The default return value -EOPNOTSUPP of mv88e6xxx_port_bridge_flags()
came from the return value of the DSA method port_egress_floods() in
commit 4f85901f0063 ("net: dsa: mv88e6xxx: add support for bridge flags"),
but the DSA API was changed in commit a8b659e7ff75 ("net: dsa: act as
passthrough for bridge port flags"), resulting in the return value
-EOPNOTSUPP not being valid anymore, and sections for new flags will not
need to set the return value to zero on success, as with the new mab flag
added in a following patch.

Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 242b8b325504..29d4ff8e1181 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6545,7 +6545,7 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 				       struct netlink_ext_ack *extack)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
-	int err = -EOPNOTSUPP;
+	int err = 0;
 
 	mv88e6xxx_reg_lock(chip);
 
-- 
2.34.1

