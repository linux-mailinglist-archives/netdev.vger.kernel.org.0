Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8275575EB
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 10:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiFWIwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 04:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiFWIwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 04:52:05 -0400
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401D4496A2;
        Thu, 23 Jun 2022 01:52:04 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 906FD9C021C;
        Thu, 23 Jun 2022 04:52:03 -0400 (EDT)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id goANI2I5l6g7; Thu, 23 Jun 2022 04:52:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 24FD29C0229;
        Thu, 23 Jun 2022 04:52:03 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com 24FD29C0229
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1655974323; bh=YiOz7KlajIpUudqSOOIyp2/QebO/yeM7e3nDDXSt/jo=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=HBtP71sVGLSxC6ke7E37YPpMuzZNsOdpdUQVDJP48de8mrQkdfNc9zajkVmpdSCkZ
         j3mrQSxIt9eKDtdsEnr8EjyL7SyUBQEbDoiM4zPWYlczusLD/XcfS0+RSS4Y2gAZ6K
         rXNFb1uVUa6wH0NCA4iUNyT2W7/xnlJnFBiZp9E8etO19lNn6qk7S1b7bXQrLT+86t
         wy4s1id4h1WsZh1OH547yV76tl7hPmHBlEUcHE6rBgEaLR53OM0eHmjxUd8fC68qq1
         GN0pRK/0h/dgOYUZtT72UQRFC58HQOchN5VnCvoTkyx7nncuFM3AipfRw2w+9nGduq
         79bPWxz/axlrw==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 0juuMgFNS0XS; Thu, 23 Jun 2022 04:52:03 -0400 (EDT)
Received: from sfl-deribaucourt.rennes.sfl (lfbn-ren-1-676-174.w81-53.abo.wanadoo.fr [81.53.245.174])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id 2A56E9C021C;
        Thu, 23 Jun 2022 04:52:02 -0400 (EDT)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     andrew@lunn.ch
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        hkallweit1@gmail.com,
        Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Subject: [PATCH 2/2] net: dp83822: disable rx error interrupt
Date:   Thu, 23 Jun 2022 10:51:27 +0200
Message-Id: <20220623085125.1426049-2-enguerrand.de-ribaucourt@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <YqzAKguRaxr74oXh@lunn.ch>
References: <YqzAKguRaxr74oXh@lunn.ch>
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

