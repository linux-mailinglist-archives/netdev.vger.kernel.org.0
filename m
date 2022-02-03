Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84EF24A852C
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 14:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350823AbiBCNbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 08:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350825AbiBCNa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 08:30:58 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018D1C06173D
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 05:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=htYwcc8ipT9WxyPOKdbA0sX86vE0IATgHGZ37ypbYPw=; b=qkAsly2HMXYO5ibUUVagj6/KlU
        3CmZQKR+5LsvDDBQTyKuZedqRLWjnQobcx0Pby+DrW9YsaooVpsIZWoF4j2YlfvovbK0eTLKFInYR
        FVoLBYZeZ3/pj5iR8bgHPN0+afQ2JJuamgVDq2sJw5sJgsFHXXhASu1OhUn34IUddamipThPWKZY5
        ENOwFsUpPqMVR+TZMHJXSe0T0wYDf8LXtVmTHOj/GXWFT+TgljWumDbtbdRQVQLDtfxjZ0AK0Irz2
        YZVZiWkeX5pC/HyNoEVfaKXg16OEoFde0DJX1ICCPDzCdmJQMb0HszTZIRfVh9NPahzJIOWExZfPd
        2/gA3maQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:53938 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nFcCL-0002gQ-13; Thu, 03 Feb 2022 13:30:53 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nFcCK-006WN0-Do; Thu, 03 Feb 2022 13:30:52 +0000
In-Reply-To: <YfvYxNAkOZ6aNxql@shell.armlinux.org.uk>
References: <YfvYxNAkOZ6aNxql@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Marek Beh__n <kabel@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 4/4] net: dsa: mv88e6xxx: improve 88e6352 serdes
 statistics detection
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nFcCK-006WN0-Do@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 03 Feb 2022 13:30:52 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The decision whether to report serdes statistics currently depends on
the cached C_Mode value for the port, read at probe time or updated by
configuration. However, port 4 can be in "automedia" mode when it is
used as a serdes port, meaning it switches between the internal PHY and
the serdes, changing the read-only C_Mode value depending on which
first gains link. Consequently, the C_Mode value read at probe does not
accurately reflect whether the port has the serdes associated with it.

In "net: dsa: mv88e6xxx: add mv88e6352_g2_scratch_port_has_serdes()",
we added a way to read the hardware configuration to determine which
port has the serdes associated with it. Use this to determine which
port reports the serdes statistics.

Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 43 ++++++++++++++++--------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 2b05ead515cd..6a177bf654ee 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -272,14 +272,6 @@ int mv88e6352_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 	return lane;
 }
 
-static bool mv88e6352_port_has_serdes(struct mv88e6xxx_chip *chip, int port)
-{
-	if (mv88e6xxx_serdes_get_lane(chip, port) >= 0)
-		return true;
-
-	return false;
-}
-
 struct mv88e6352_serdes_hw_stat {
 	char string[ETH_GSTRING_LEN];
 	int sizeof_stat;
@@ -293,20 +285,24 @@ static struct mv88e6352_serdes_hw_stat mv88e6352_serdes_hw_stats[] = {
 
 int mv88e6352_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port)
 {
-	if (mv88e6352_port_has_serdes(chip, port))
-		return ARRAY_SIZE(mv88e6352_serdes_hw_stats);
+	int err;
 
-	return 0;
+	err = mv88e6352_g2_scratch_port_has_serdes(chip, port);
+	if (err <= 0)
+		return err;
+
+	return ARRAY_SIZE(mv88e6352_serdes_hw_stats);
 }
 
 int mv88e6352_serdes_get_strings(struct mv88e6xxx_chip *chip,
 				 int port, uint8_t *data)
 {
 	struct mv88e6352_serdes_hw_stat *stat;
-	int i;
+	int err, i;
 
-	if (!mv88e6352_port_has_serdes(chip, port))
-		return 0;
+	err = mv88e6352_g2_scratch_port_has_serdes(chip, port);
+	if (err <= 0)
+		return err;
 
 	for (i = 0; i < ARRAY_SIZE(mv88e6352_serdes_hw_stats); i++) {
 		stat = &mv88e6352_serdes_hw_stats[i];
@@ -348,11 +344,12 @@ int mv88e6352_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
 {
 	struct mv88e6xxx_port *mv88e6xxx_port = &chip->ports[port];
 	struct mv88e6352_serdes_hw_stat *stat;
+	int i, err;
 	u64 value;
-	int i;
 
-	if (!mv88e6352_port_has_serdes(chip, port))
-		return 0;
+	err = mv88e6352_g2_scratch_port_has_serdes(chip, port);
+	if (err <= 0)
+		return err;
 
 	BUILD_BUG_ON(ARRAY_SIZE(mv88e6352_serdes_hw_stats) >
 		     ARRAY_SIZE(mv88e6xxx_port->serdes_stats));
@@ -419,8 +416,13 @@ unsigned int mv88e6352_serdes_irq_mapping(struct mv88e6xxx_chip *chip, int port)
 
 int mv88e6352_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port)
 {
-	if (!mv88e6352_port_has_serdes(chip, port))
-		return 0;
+	int err;
+
+	mv88e6xxx_reg_lock(chip);
+	err = mv88e6352_g2_scratch_port_has_serdes(chip, port);
+	mv88e6xxx_reg_unlock(chip);
+	if (err <= 0)
+		return err;
 
 	return 32 * sizeof(u16);
 }
@@ -432,7 +434,8 @@ void mv88e6352_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p)
 	int err;
 	int i;
 
-	if (!mv88e6352_port_has_serdes(chip, port))
+	err = mv88e6352_g2_scratch_port_has_serdes(chip, port);
+	if (err <= 0)
 		return;
 
 	for (i = 0 ; i < 32; i++) {
-- 
2.30.2

