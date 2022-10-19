Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38846047A2
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 15:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbiJSNm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 09:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbiJSNlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 09:41:46 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC98710AA
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 06:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6rqIsGiuGIbdm1Qj9PHgbZHxsJ3BDKwgjZR6ybGW1JM=; b=ojrZNNq6T8N9/HnXv+VurFk6QS
        C2F2xdAvk1e+PCHbnhkwP2kNAZDZAlgtCas3tzkB0YwR2u/pi93ad21DeQKOcgLE1l+vwikasNrVz
        c7R/mGeb4KQL0rqLlB8u6Diu9l4X9mwVcRQXMYMz1uxoVHHRUfV/6+ymOK1v84D9vlz9gWCd93rrs
        no3kS6lLt0+dX9hiovmXDJCUfhfcaTNvAaL8ajszGTWwg8ccAyCiZCcGj3ReXBLN56Lwog8uPWBhf
        +Q+HIwDbsyv6R4ZyyXJXe59xxCsNO2brdYKdhy+jK17TfVGii8NmGpsAzcd+BOzIRXmf01JrJybKt
        iXd2oBbg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:55782 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ol97w-0005jQ-Ue; Wed, 19 Oct 2022 14:28:56 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1ol97w-00EDSd-CI; Wed, 19 Oct 2022 14:28:56 +0100
In-Reply-To: <Y0/7dAB8OU3jrbz6@shell.armlinux.org.uk>
References: <Y0/7dAB8OU3jrbz6@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 3/7] net: sfp: ignore power level 2 prior to SFF-8472
 Rev 10.2
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ol97w-00EDSd-CI@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 19 Oct 2022 14:28:56 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Power level 2 was introduced by SFF-8472 revision 10.2. Ignore
the power declaration bit for modules that are not compliant with
at least this revision.

This should remove any spurious indication of 1.5W modules.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index f7ad4d5d9041..a7635b02524a 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1761,7 +1761,8 @@ static int sfp_module_parse_power(struct sfp *sfp)
 	u32 power_mW = 1000;
 	bool supports_a2;
 
-	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_POWER_DECL))
+	if (sfp->id.ext.sff8472_compliance >= SFP_SFF8472_COMPLIANCE_REV10_2 &&
+	    sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_POWER_DECL))
 		power_mW = 1500;
 	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_HIGH_POWER_LEVEL))
 		power_mW = 2000;
-- 
2.30.2

