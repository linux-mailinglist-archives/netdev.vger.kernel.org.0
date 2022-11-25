Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 489E0638B02
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 14:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiKYNST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 08:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiKYNSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 08:18:14 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF99732B8D;
        Fri, 25 Nov 2022 05:18:12 -0800 (PST)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id AC810100004;
        Fri, 25 Nov 2022 13:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669382291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0vN53Jicp2EQLGwxHenx0pNuudpw6RE4UZUcHo5SquA=;
        b=FZdFGvNZ+6wfMb4AaDqlr+5u/y02N0LfnuwXdaIOqZbpRmii5u/VTHguLkaR2klLjp06Za
        FT4x8kZTrcAkyyMcyE+jtQpMdch88/iLNOmAB9rUeR/DfnEDb6CkJmzXUULesE7wKU5It4
        /WDvLmsF5guHQNjIh7daVXMXkpqrEFvVEVjohe7jlyE+eHpEvyCPRSZBH1qXzPdotJDLSX
        8ZsMn4Fke+SZE0Cu+v+7H5+mwALAxhvUym2Vg7ZGOvCmnN9fkZ7FRkEPULzMo+IG/jDJs9
        gwDwdJ/1bKwA+DDQDBmNaqFuc3hg3UOQJTGyVkkGP3mMDfEln3y8pYWrLAkn3Q==
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        devicetree@vger.kernel.org
Subject: [PATCH net-next 2/3] net: pcs: altera-tse: don't set the speed for 1000BaseX
Date:   Fri, 25 Nov 2022 14:18:00 +0100
Message-Id: <20221125131801.64234-3-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221125131801.64234-1-maxime.chevallier@bootlin.com>
References: <20221125131801.64234-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When disabling the SGMII mode bit, the PCS defaults to 1000BaseX mode.
In that mode, we don't need to set the speed since it's always 1000Mbps.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/pcs/pcs-altera-tse.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/pcs/pcs-altera-tse.c b/drivers/net/pcs/pcs-altera-tse.c
index e86cadc391e8..be65271ff5de 100644
--- a/drivers/net/pcs/pcs-altera-tse.c
+++ b/drivers/net/pcs/pcs-altera-tse.c
@@ -102,7 +102,6 @@ static int alt_tse_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 		if_mode |= PCS_IF_MODE_USE_SGMII_AN | PCS_IF_MODE_SGMII_ENA;
 	} else if (interface == PHY_INTERFACE_MODE_1000BASEX) {
 		if_mode &= ~(PCS_IF_MODE_USE_SGMII_AN | PCS_IF_MODE_SGMII_ENA);
-		if_mode |= PCS_IF_MODE_SGMI_SPEED_1000;
 	}
 
 	ctrl |= (BMCR_SPEED1000 | BMCR_FULLDPLX | BMCR_ANENABLE);
-- 
2.38.1

