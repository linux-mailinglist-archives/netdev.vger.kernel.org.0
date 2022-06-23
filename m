Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B371557CB6
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 15:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiFWNP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 09:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbiFWNPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 09:15:18 -0400
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66F73ED12;
        Thu, 23 Jun 2022 06:15:17 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 1ABCE9C0252;
        Thu, 23 Jun 2022 09:15:17 -0400 (EDT)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id SleSsz1a9H3z; Thu, 23 Jun 2022 09:15:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id A37629C024D;
        Thu, 23 Jun 2022 09:15:16 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com A37629C024D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1655990116; bh=u2Hm+I+Sfe4JGJXNzHFwIv5s8dMMHx/ZCUQYJk9AHUw=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=QRWOwqpwsK+6OtMtoefsKip4CZgddM9/f/KExNdTPYqF18fEZFnRJw2HOLvnvfBwy
         VlnWrX5uI2AKaYb1A/61NIddiU3EP9m5LHYE52E5PNwQfRtQlojgk192hJT1RMaZIM
         PMVV0qE+aXQKbPla+HQqr/KqduYCZ1dF0R5hyBI7afm1ZkeeMRJMaYzbSGT4/LaUsS
         hLk/jYQGqxMIg3kHO9W8Rn2BlKFW8HmoWFifjN8oRy1xgD27fRskhS1bHNWoJJ+RoL
         aTgmRAzJ5SaneU2d/IYnHJN44eFoLr/iWV1v2+ZedNWq9T80/Dz3dDGGlkjdGDcJzA
         nh3UUUzw83vRg==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 5zrCDrxeODnB; Thu, 23 Jun 2022 09:15:16 -0400 (EDT)
Received: from sfl-deribaucourt.rennes.sfl (lfbn-ren-1-676-174.w81-53.abo.wanadoo.fr [81.53.245.174])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id A7E3C9C0252;
        Thu, 23 Jun 2022 09:15:15 -0400 (EDT)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     andrew@lunn.ch
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        hkallweit1@gmail.com,
        Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Subject: [PATCH v2 2/2] net: dp83822: disable rx error interrupt
Date:   Thu, 23 Jun 2022 15:14:54 +0200
Message-Id: <20220623131453.1853406-3-enguerrand.de-ribaucourt@savoirfairelinux.com>
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

Some RX errors, notably when disconnecting the cable, increase the RCSR
register. Once half full (0x7fff), an interrupt flood is generated. I
measured ~3k/s interrupts even after the RX errors transfer was
stopped.

Since we don't read and clear the RCSR register, we should disable this
interrupt.

Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirf=
airelinux.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Fixes: 87461f7a58ab694e638ac52afa543b427751a9d0
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

