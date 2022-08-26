Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72ED15A2932
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 16:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238219AbiHZORk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 10:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbiHZORj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 10:17:39 -0400
X-Greylist: delayed 92614 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 26 Aug 2022 07:17:37 PDT
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF579C206;
        Fri, 26 Aug 2022 07:17:37 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id AC2BD60005;
        Fri, 26 Aug 2022 14:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661523456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=EBGcmPPjqpaDTKplW8ZCyDWmnpPadRiKMDQ8Yx3Y624=;
        b=I+1WcXCD02Og/9KlbaCI7e0UycUKzVan9FO6q6YhhiryYyZQbNbtWV40yBXo6I74lmZPFk
        znY2lDnSwHcLlAukMAc0VqlpfcFlPZyz8bwZMRZabuTFq+re9lEIzgHxEBx9v6cIYnt3NB
        nVNn5jaXAj9D6zHy/7/IPmJbuTIX6iNqQDhsUEKoJU6sX9z9kTBd8whv8BKlBextLIDxAB
        KtZztr5OAO3WYl2JweNqfPaKZgSS3HNx+JGIY4H0sGZpqpkLkTEIXwW0rPkDHqWsEi5PG0
        K4yPR1H4tUPPHPQs/vGxXwudS6tTh0a6MRlNkDn5EdCDlPke/n/Vw0tURFX0NQ==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        UNGLinuxDriver@microchip.com, thomas.petazzoni@bootlin.com
Subject: [PATCH net-next] phy: lan966x: add support for QUSGMII
Date:   Fri, 26 Aug 2022 16:17:22 +0200
Message-Id: <20220826141722.563352-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Makes so that the serdes driver also takes QUSGMII in consideration.
It's configured exactly as QSGMII as far as the serdes driver is
concerned.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---

Dear netdev and Generic PHY maintainers,

This patch should go through the net-next tree instead of the generic
PHY tree, as it has a dependency on :

5e61fe157a27 "net: phy: Introduce QUSGMII PHY mode"

This commits only lives in the net-next tree as of today.

Given the simplicity of this patch, would that be OK for you ?

Thanks,

Maxime

 drivers/phy/microchip/lan966x_serdes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/phy/microchip/lan966x_serdes.c b/drivers/phy/microchip/lan966x_serdes.c
index e86a879b92b5..d1a50fa81130 100644
--- a/drivers/phy/microchip/lan966x_serdes.c
+++ b/drivers/phy/microchip/lan966x_serdes.c
@@ -401,6 +401,9 @@ static int serdes_set_mode(struct phy *phy, enum phy_mode mode, int submode)
 	    submode == PHY_INTERFACE_MODE_2500BASEX)
 		submode = PHY_INTERFACE_MODE_SGMII;
 
+	if (submode == PHY_INTERFACE_MODE_QUSGMII)
+		submode = PHY_INTERFACE_MODE_QSGMII;
+
 	for (i = 0; i < ARRAY_SIZE(lan966x_serdes_muxes); i++) {
 		if (macro->idx != lan966x_serdes_muxes[i].idx ||
 		    mode != lan966x_serdes_muxes[i].mode ||
-- 
2.37.2

