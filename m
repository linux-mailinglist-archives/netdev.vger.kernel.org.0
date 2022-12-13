Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE1664BB58
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 18:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236371AbiLMRsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 12:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236366AbiLMRsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 12:48:11 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1705F11A0F;
        Tue, 13 Dec 2022 09:48:08 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id E6C3F18839C0;
        Tue, 13 Dec 2022 17:48:06 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id D6BA72500015;
        Tue, 13 Dec 2022 17:48:06 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id CAB329EC0027; Tue, 13 Dec 2022 17:48:06 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
Received: from fujitsu.vestervang (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id 7E8F891201E3;
        Tue, 13 Dec 2022 17:48:06 +0000 (UTC)
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
Subject: [PATCH v2 net-next 2/3] net: dsa: mv88e6xxx: disable hold of chip lock for handling
Date:   Tue, 13 Dec 2022 18:46:49 +0100
Message-Id: <20221213174650.670767-3-netdev@kapio-technology.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221213174650.670767-1-netdev@kapio-technology.com>
References: <20221213174650.670767-1-netdev@kapio-technology.com>
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

As functions called under the interrupt handler will need to take the
netlink lock, we need to release the chip lock before calling those
functions as otherwise double lock deadlocks will occur as userspace
calls towards the driver often take the netlink lock and then the
chip lock.

The deadlock would look like:

Interrupt handler: chip lock taken, but cannot take netlink lock as
                   userspace config call has netlink lock.
Userspace config: netlink lock taken, but cannot take chip lock as
                   the interrupt handler has the chip lock.

Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
---
 drivers/net/dsa/mv88e6xxx/global1_atu.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
index 61ae2d61e25c..34203e112eef 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
@@ -409,11 +409,11 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 
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
@@ -421,11 +421,13 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 
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
 
@@ -449,13 +451,13 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 						   fid);
 		chip->ports[spid].atu_full_violation++;
 	}
-	mv88e6xxx_reg_unlock(chip);
 
 	return IRQ_HANDLED;
 
-out:
+out_unlock:
 	mv88e6xxx_reg_unlock(chip);
 
+out:
 	dev_err(chip->dev, "ATU problem: error %d while handling interrupt\n",
 		err);
 	return IRQ_HANDLED;
-- 
2.34.1

