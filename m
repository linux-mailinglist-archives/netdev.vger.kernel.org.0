Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30EB44D2D30
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 11:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiCIKge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 05:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiCIKge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 05:36:34 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C374BEB15A
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 02:35:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Wjrb1sbSUlTlQ8uUDeEcmyVsKaopRQ776msP0U20gV0=; b=yLbq4knRr2LUF5+rOdtntBUAig
        M/CJa94G/VBxzspk4dHfcBDjBBDpV9JweECJLjHo/Vg8uGOUpVvZFc3x4wow3ulaG2490HE4DX3pV
        MgLeZE2Axvx/vOvlZSCOgmK8bgaIOP48LP/b/38UzY8cljwOZz/hqbfOUgWXGAkD1DpstoDWB7sLv
        8CAZ7DzYDSm2tvZwoj0YypxnDnX8VR9aTfK6mFuGsidC4F9HJgmHuZoA0FmCypVmrRkai/fOiKu2W
        kEd4pNlD7tNZbzuItOfWMuNWE82AJ82FGD5G1AbZ8qhRp2opgD62oeHGoR3/kAp1JeyjA0Fy6l8NY
        Wj9L2aWw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52554 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nRtfJ-0001fF-5F; Wed, 09 Mar 2022 10:35:33 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nRtfI-00EnmD-I8; Wed, 09 Mar 2022 10:35:32 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] net: dsa: silence fdb errors when unsupported
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nRtfI-00EnmD-I8@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 09 Mar 2022 10:35:32 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When booting with a Marvell 88e6xxx switch, the kernel spits out a
load of:

[    7.820996] mv88e6085 f1072004.mdio-mii:04: port 3 failed to add aa:bb:cc:dd:ee:ff vid XYZ1 to fdb: -95
[    7.835717] mv88e6085 f1072004.mdio-mii:04: port 2 failed to add aa:bb:cc:dd:ee:ff vid XYZ1 to fdb: -95
[    7.851090] mv88e6085 f1072004.mdio-mii:04: port 1 failed to add aa:bb:cc:dd:ee:ff vid XYZ1 to fdb: -95
[    7.968594] mv88e6085 f1072004.mdio-mii:04: port 0 failed to add aa:bb:cc:dd:ee:ff vid XYZ1 to fdb: -95
[    8.035408] mv88e6085 f1072004.mdio-mii:04: port 3 failed to add aa:bb:cc:dd:ee:ff vid XYZ3 to fdb: -95

while the switch is being setup. Comments in the Marvell DSA driver
indicate that "switchdev expects -EOPNOTSUPP to honor software VLANs"
in mv88e6xxx_port_db_load_purge() so this error code should not be
treated as an error.

Fixes: 3dc80afc5098 ("net: dsa: introduce a separate cross-chip notifier type for host FDBs")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
Hi,

I noticed these errors booting 5.16 on my Clearfog platforms with a
Marvell DSA switch. It appears that the switch continues to work
even though these errors are logged in the kernel log, so this patch
merely silences the errors, but I'm unsure this is the right thing
to do.

 net/dsa/slave.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 22241afcac81..e8f4a59022a8 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2411,7 +2411,7 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 		else
 			err = dsa_port_fdb_add(dp, switchdev_work->addr,
 					       switchdev_work->vid);
-		if (err) {
+		if (err && err != -EOPNOTSUPP) {
 			dev_err(ds->dev,
 				"port %d failed to add %pM vid %d to fdb: %d\n",
 				dp->index, switchdev_work->addr,
@@ -2428,7 +2428,7 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 		else
 			err = dsa_port_fdb_del(dp, switchdev_work->addr,
 					       switchdev_work->vid);
-		if (err) {
+		if (err && err != -EOPNOTSUPP) {
 			dev_err(ds->dev,
 				"port %d failed to delete %pM vid %d from fdb: %d\n",
 				dp->index, switchdev_work->addr,
-- 
2.30.2

