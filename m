Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF4354F892
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 15:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbiFQNxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 09:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381052AbiFQNw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 09:52:59 -0400
X-Greylist: delayed 393 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 17 Jun 2022 06:52:54 PDT
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABC62703;
        Fri, 17 Jun 2022 06:52:52 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id A4BE79C035C;
        Fri, 17 Jun 2022 09:46:19 -0400 (EDT)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id RxSxonNRBtIm; Fri, 17 Jun 2022 09:46:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 1D95C9C035E;
        Fri, 17 Jun 2022 09:46:19 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com 1D95C9C035E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1655473579; bh=6FyXPE9HabKRcoxbNWsYdPeExADy1asgHfS0MpAMcCo=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=dAW53u5txvU6CYNBr0Hue4BIbjb7YFmVNt0s+111UGLqXYZF192BtJC2bSDB4DI9F
         zw/y0j5vAqmS9KhZV+GvaX+M5FuKNYoHbH7dcI02nK4Uo1coBIOhhsaMnDSrMe6uT2
         V2xZ5Rh8AwFNoikmoKeae+9ANcFDDs+6K+Zej0NBCyMjWyNAOO4Tyo65fWluzwLeFU
         CZgOru1q3+1YxjeQEKiy+YWHFDBVBU3Ztxsu/u1p/vYHrAVuxrbyx1BgYQkzaitQ8U
         QPBD+JeyYElNVGqh6opkB2rDadHSFcl7VObwCn70e/v0Ly5QyBEeJkqLuFeOgEe124
         vWvgPKFx4QREQ==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id gBJqZQIRYTyR; Fri, 17 Jun 2022 09:46:19 -0400 (EDT)
Received: from sfl-deribaucourt.rennes.sfl (lfbn-ren-1-676-174.w81-53.abo.wanadoo.fr [81.53.245.174])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id 18E839C035C;
        Fri, 17 Jun 2022 09:46:18 -0400 (EDT)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, hkallweit1@gmail.com,
        Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Subject: [PATCH] net: dp83822: disable false carrier interrupt
Date:   Fri, 17 Jun 2022 15:46:11 +0200
Message-Id: <20220617134611.695690-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
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

