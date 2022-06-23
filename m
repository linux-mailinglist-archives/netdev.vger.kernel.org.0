Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88611557CB4
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 15:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiFWNP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 09:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiFWNPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 09:15:18 -0400
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BA43EB96;
        Thu, 23 Jun 2022 06:15:16 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 18B0C9C022D;
        Thu, 23 Jun 2022 09:15:16 -0400 (EDT)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id EUbVyBIyUrYL; Thu, 23 Jun 2022 09:15:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 8FF889C024D;
        Thu, 23 Jun 2022 09:15:15 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com 8FF889C024D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1655990115; bh=HqTVvKbBhmF85CAJUy+d131RKeVeGkM8Hebj8U7jc/E=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=wMBr+HWk+dDpEFBliv+V6DDEGmsko5SI1yW2vax+8tTQSpArZqzzl9qJ4C5tQE17z
         7Ft+2awk8MUVQqCY0TXutmBCwxXvrfpo7DQYxts3dRRH/JF8unLg5xNlxTKcG0ql6U
         K52JUJJtFwuXCu4fGMrn2893nBrEPvNklpBDc/JmupSpi1nxkoHuHXm+uWNJeQhPki
         eGca7PrVE68S32esvvYKwokaXBSgL87cLptNgLx84k8Vyt6wrHstwJIqIct8q770wB
         Z7ANjqspDuT2+Q+LUs25nWN2Spt22GbxybouUqhydYQJwnswZ1xtVBYq4aJwvf5h9O
         TrsEK0NWFynUw==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Bswq0EWqPZe8; Thu, 23 Jun 2022 09:15:15 -0400 (EDT)
Received: from sfl-deribaucourt.rennes.sfl (lfbn-ren-1-676-174.w81-53.abo.wanadoo.fr [81.53.245.174])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id 92BBC9C022D;
        Thu, 23 Jun 2022 09:15:14 -0400 (EDT)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     andrew@lunn.ch
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        hkallweit1@gmail.com,
        Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Subject: [PATCH v2 1/2] net: dp83822: disable false carrier interrupt
Date:   Thu, 23 Jun 2022 15:14:53 +0200
Message-Id: <20220623131453.1853406-2-enguerrand.de-ribaucourt@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220623131453.1853406-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
References: <YqzAKguRaxr74oXh@lunn.ch>
 <20220623131453.1853406-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When unplugging an Ethernet cable, false carrier events were produced by
the PHY at a very high rate. Once the false carrier counter full, an
interrupt was triggered every few clock cycles until the cable was
replugged. This resulted in approximately 10k/s interrupts.

Since the false carrier counter (FCSCR) is never used, we can safely
disable this interrupt.

In addition to improving performance, this also solved MDIO read
timeouts I was randomly encountering with an i.MX8 fec MAC because of
the interrupt flood. The interrupt count and MDIO timeout fix were
tested on a v5.4.110 kernel.

Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirf=
airelinux.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Fixes: 87461f7a58ab694e638ac52afa543b427751a9d0
---
 drivers/net/phy/dp83822.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index e6ad3a494d32..95ef507053a6 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -230,7 +230,6 @@ static int dp83822_config_intr(struct phy_device *phy=
dev)
 			return misr_status;
=20
 		misr_status |=3D (DP83822_RX_ERR_HF_INT_EN |
-				DP83822_FALSE_CARRIER_HF_INT_EN |
 				DP83822_LINK_STAT_INT_EN |
 				DP83822_ENERGY_DET_INT_EN |
 				DP83822_LINK_QUAL_INT_EN);
--=20
2.25.1

