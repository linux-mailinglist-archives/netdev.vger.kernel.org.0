Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71C6557C7B
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 15:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbiFWNIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 09:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbiFWNIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 09:08:00 -0400
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [208.88.110.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B515590;
        Thu, 23 Jun 2022 06:07:58 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 10A9D9C020F;
        Thu, 23 Jun 2022 09:07:58 -0400 (EDT)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id bxgaT8NIpJQw; Thu, 23 Jun 2022 09:07:57 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 8E7919C022D;
        Thu, 23 Jun 2022 09:07:57 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.savoirfairelinux.com 8E7919C022D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=savoirfairelinux.com; s=DFC430D2-D198-11EC-948E-34200CB392D2;
        t=1655989677; bh=2W+lIf6qQ2lUkL8+3ZiA5lGY3Srk9AN/ouUZgnymuxg=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=x1LucgElIr9jwfGficzBl1Gqb5zZz1q007Ea/Wczm2duLOXU+gRuKLQ4oD6+HDmhE
         m28w5Pz/1+zmJCE+CJyuTKekcbwFp7j3zNnNpaiseMpfiyDaWknT22L8U4j7Et8H7b
         Gr+5JGQxeSmjJ6gq14lh6Xs48Cbe89mVTptdEqQv1gVU2X3zpuFSQ8gPX5+pRvlQTu
         TUV1eptvSezWAQ/LMkJPN7abiXUpb7lMQAosmCgw0/v8VcRabJhUakEhF+QjLWKJ7g
         pTiOkWGsRIRnT2SmtGZJRrrFEnwHcEYjM0OvZFxnt8b9i6BQx+5Jg8NqxlV2Sv3m85
         36WzYU3wyeP0Q==
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 8sQ4xztY2Yl7; Thu, 23 Jun 2022 09:07:57 -0400 (EDT)
Received: from sfl-deribaucourt.rennes.sfl (lfbn-ren-1-676-174.w81-53.abo.wanadoo.fr [81.53.245.174])
        by mail.savoirfairelinux.com (Postfix) with ESMTPSA id 90CE59C020F;
        Thu, 23 Jun 2022 09:07:56 -0400 (EDT)
From:   Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
To:     andrew@lunn.ch
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        hkallweit1@gmail.com,
        Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Subject: [PATCH v2 1/2] net: dp83822: disable false carrier interrupt
Date:   Thu, 23 Jun 2022 15:06:52 +0200
Message-Id: <20220623130651.1805615-2-enguerrand.de-ribaucourt@savoirfairelinux.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220623130651.1805615-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
References: <YqzAKguRaxr74oXh@lunn.ch>
 <20220623130651.1805615-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
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

 		misr_status |=3D (DP83822_RX_ERR_HF_INT_EN |
-				DP83822_FALSE_CARRIER_HF_INT_EN |
 				DP83822_LINK_STAT_INT_EN |
 				DP83822_ENERGY_DET_INT_EN |
 				DP83822_LINK_QUAL_INT_EN);
--
2.25.1
