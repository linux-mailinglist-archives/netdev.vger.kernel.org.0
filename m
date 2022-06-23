Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269A6557D43
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 15:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbiFWNrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 09:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbiFWNrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 09:47:05 -0400
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9173A263;
        Thu, 23 Jun 2022 06:47:04 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id EFFD49C0264;
        Thu, 23 Jun 2022 09:47:03 -0400 (EDT)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id iq-8oC4nyEZh; Thu, 23 Jun 2022 09:47:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 7C9F19C0252;
        Thu, 23 Jun 2022 09:47:03 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com 7C9F19C0252
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1655992023; bh=818XHbkmSa7Pq/rSA6mCvfYYUgYfJJaCNT/N9Ws60N4=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=Irth3LPddugdaTS2nx72EoOT8lhg6pBMCpCj/1kEEgrm4WtyZnVVxPBd9G14WAUo9
         dP7Jk4TeaPvlqNa1Vy07PvC5eOjIP6EE8l6K28nkxHsUvfQW5qVR2LXW3PIsjUafOE
         79jtlTy3IFGeTxk2vOJnSoDwzRHug/agtvuOrD73OozUSHdarlASu0CbZA0QPrvjZA
         MPRjplsZMaKd9Tbz5n+c8/YLH/m+y9R++V/Sw57VE4DItrV+SUqbEekPkZS1XfZ9kC
         aqpmNkfPoT3tXbaeRf27fz3WhkgA+FAQ7K+eaXKR0qgdyAZ+4y5KxvFzd7UVWemM5G
         YZvfMsVJcdqZg==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id YZDCfYHC0L8K; Thu, 23 Jun 2022 09:47:03 -0400 (EDT)
Received: from sfl-deribaucourt.rennes.sfl (lfbn-ren-1-676-174.w81-53.abo.wanadoo.fr [81.53.245.174])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id 7F34C9C0264;
        Thu, 23 Jun 2022 09:47:02 -0400 (EDT)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     andrew@lunn.ch
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        hkallweit1@gmail.com,
        Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Subject: [PATCH v3 2/2] net: dp83822: disable rx error interrupt
Date:   Thu, 23 Jun 2022 15:46:45 +0200
Message-Id: <20220623134645.1858361-3-enguerrand.de-ribaucourt@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220623134645.1858361-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
References: <YqzAKguRaxr74oXh@lunn.ch>
 <20220623134645.1858361-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
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

Some RX errors, notably when disconnecting the cable, increase the RCSR
register. Once half full (0x7fff), an interrupt flood is generated. I
measured ~3k/s interrupts even after the RX errors transfer was
stopped.

Since we don't read and clear the RCSR register, we should disable this
interrupt.

Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirf=
airelinux.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Fixes: 87461f7a58ab ("net: phy: DP83822 initial driver submission")
---
 drivers/net/phy/dp83822.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index 95ef507053a6..8549e0e356c9 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -229,8 +229,7 @@ static int dp83822_config_intr(struct phy_device *phy=
dev)
 		if (misr_status < 0)
 			return misr_status;
=20
-		misr_status |=3D (DP83822_RX_ERR_HF_INT_EN |
-				DP83822_LINK_STAT_INT_EN |
+		misr_status |=3D (DP83822_LINK_STAT_INT_EN |
 				DP83822_ENERGY_DET_INT_EN |
 				DP83822_LINK_QUAL_INT_EN);
=20
--=20
2.25.1

