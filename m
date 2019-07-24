Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A51EB72916
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 09:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbfGXHg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 03:36:26 -0400
Received: from ispman.iskranet.ru ([62.213.33.10]:44364 "EHLO
        ispman.iskranet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfGXHgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 03:36:25 -0400
Received: by ispman.iskranet.ru (Postfix, from userid 8)
        id 5719B8217FA; Wed, 24 Jul 2019 14:36:21 +0700 (KRAT)
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on ispman.iskranet.ru
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=4.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.3.2
Received: from KB016249 (unknown [62.213.40.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ispman.iskranet.ru (Postfix) with ESMTPS id 323A88217F8;
        Wed, 24 Jul 2019 14:36:19 +0700 (KRAT)
From:   Arseny Solokha <asolokha@kb.kras.ru>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] gianfar: convert to phylink
References: <20190723151702.14430-1-asolokha@kb.kras.ru>
        <20190723151702.14430-2-asolokha@kb.kras.ru>
        <VI1PR04MB48809AFBB9DF01001AA5E2CA96C70@VI1PR04MB4880.eurprd04.prod.outlook.com>
Date:   Wed, 24 Jul 2019 14:36:17 +0700
In-Reply-To: <VI1PR04MB48809AFBB9DF01001AA5E2CA96C70@VI1PR04MB4880.eurprd04.prod.outlook.com>
        (Claudiu Manoil's message of "Tue, 23 Jul 2019 16:07:34 +0000")
Message-ID: <87muh33mvi.fsf@kb.kras.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>-----Original Message-----
>>From: Arseny Solokha <asolokha@kb.kras.ru>
>>Sent: Tuesday, July 23, 2019 6:17 PM
>>To: Claudiu Manoil <claudiu.manoil@nxp.com>; Ioana Ciornei
>><ioana.ciornei@nxp.com>; Russell King <linux@armlinux.org.uk>; Andrew Lunn
>><andrew@lunn.ch>
>>Cc: netdev@vger.kernel.org; Arseny Solokha <asolokha@kb.kras.ru>
>>Subject: [RFC PATCH 1/2] gianfar: convert to phylink
>>
>>Convert gianfar to use the phylink API for better SFP modules support.
>>
>>The driver still uses phylib for serdes configuration over the TBI
>>interface, as there seems to be no functionally equivalent API present
>>in phylink (yet). phylib usage is basically confined in two functions.
>>
>
> Thanks for your patch.  Phylink in gianfar... that would be something!
> At first glance a lot of code has changed with this patch or got relocated.
> To make it easier to swallow, I think a few cleanup patches could be
> separated before migrating to phylink.  Like for instance getting rid of the
> old* link state variables, which I think are an artifact from early phylib usage.
> Nonetheless good to see this implemented, I'll have a closer look asap.

Hi,

meanwhile I'll have to post v2 of this patch because it has some issues which
initially escaped my attention. For now I'm pasting the diff against v1 here for
reference:

--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -1666,7 +1666,7 @@ static int gfar_suspend(struct device *dev)
 		gfar_start_wol_filer(priv);
 
 	} else {
-		phylink_stop(phy->phylink);
+		phylink_stop(priv->phylink);
 	}
 
 	priv->speed = SPEED_UNKNOWN;
@@ -3699,9 +3699,6 @@ static void gfar_mac_config(struct phylink_config *config, unsigned int mode,
 	if (unlikely(test_bit(GFAR_RESETTING, &priv->state)))
 		return;
 
-	if (unlikely(phylink_autoneg_inband(mode)))
-		return;
-
 	maccfg1 = gfar_read(&regs->maccfg1);
 	maccfg2 = gfar_read(&regs->maccfg2);
 	ecntrl = gfar_read(&regs->ecntrl);

The first hunk here fixes a typo which broke build with PM enabled. The second
one removes an early return from gfar_mac_config() which I believe is really
bogus and also breaks coalesce parameters calculation for SGMII and 1000Base-X
attached PHYs.

I'd like to submit a real v2 after the patches gets actual review, though.

Thanks,
Arseny
