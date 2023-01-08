Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523DF661461
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 10:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbjAHJuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 04:50:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbjAHJuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 04:50:32 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47990186B0;
        Sun,  8 Jan 2023 01:50:29 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 6AE1718839A3;
        Sun,  8 Jan 2023 09:50:27 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 616FE250007B;
        Sun,  8 Jan 2023 09:50:27 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 5869F9EC000B; Sun,  8 Jan 2023 09:50:27 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
Received: from fujitsu.vestervang (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id 04C5C91201DF;
        Sun,  8 Jan 2023 09:50:27 +0000 (UTC)
From:   "Hans J. Schultz" <netdev@kapio-technology.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 net-next 2/3] net: dsa: mv88e6xxx: shorten the locked section in mv88e6xxx_g1_atu_prob_irq_thread_fn()
Date:   Sun,  8 Jan 2023 10:48:48 +0100
Message-Id: <20230108094849.1789162-3-netdev@kapio-technology.com>
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

As only the hardware access functions up til and including
mv88e6xxx_g1_atu_mac_read() called under the interrupt handler
need to take the chip lock, we release the chip lock after this call.
The follow up code that handles the violations can run without the
chip lock held.
In further patches, the violation handler function will even be
incompatible with having the chip lock held. This due to an AB/BA
ordering inversion with rtnl_lock().

Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
---
 drivers/net/dsa/mv88e6xxx/global1_atu.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
index 61ae2d61e25c..0a9fd253c727 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
@@ -409,23 +409,25 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 
 	err = mv88e6xxx_g1_read_atu_violation(chip);
 	if (err)
-		goto out;
+		goto out_unlock;
 
 	err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_ATU_OP, &val);
 	if (err)
-		goto out;
+		goto out_unlock;
 
 	err = mv88e6xxx_g1_atu_fid_read(chip, &fid);
 	if (err)
-		goto out;
+		goto out_unlock;
 
 	err = mv88e6xxx_g1_atu_data_read(chip, &entry);
 	if (err)
-		goto out;
+		goto out_unlock;
 
 	err = mv88e6xxx_g1_atu_mac_read(chip, &entry);
 	if (err)
-		goto out;
+		goto out_unlock;
+
+	mv88e6xxx_reg_unlock(chip);
 
 	spid = entry.state;
 
@@ -449,13 +451,11 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 						   fid);
 		chip->ports[spid].atu_full_violation++;
 	}
-	mv88e6xxx_reg_unlock(chip);
 
 	return IRQ_HANDLED;
 
-out:
+out_unlock:
 	mv88e6xxx_reg_unlock(chip);
-
 	dev_err(chip->dev, "ATU problem: error %d while handling interrupt\n",
 		err);
 	return IRQ_HANDLED;
-- 
2.34.1

