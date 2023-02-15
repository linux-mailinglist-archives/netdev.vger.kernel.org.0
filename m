Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510A56984A9
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 20:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjBOTpv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 15 Feb 2023 14:45:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjBOTpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 14:45:49 -0500
X-Greylist: delayed 398 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 15 Feb 2023 11:45:48 PST
Received: from smtp5.emailarray.com (smtp5.emailarray.com [65.39.216.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3336241097
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 11:45:47 -0800 (PST)
Received: (qmail 82398 invoked by uid 89); 15 Feb 2023 19:39:07 -0000
Received: from unknown (HELO ?192.168.137.22?) (amxlbW9uQGZsdWdzdmFtcC5jb21AMjE2LjE2MC42NS4xNTU=) (POLARISLOCAL)  
  by smtp5.emailarray.com with ESMTPS (AES256-GCM-SHA384 encrypted); 15 Feb 2023 19:39:07 -0000
From:   Jonathan Lemon <jlemon@flugsvamp.com>
To:     =?utf-8?q?K=C3=B6ry_Maincent?= <kory.maincent@bootlin.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: net: phy: broadcom: error in rxtstamp callback?
Date:   Wed, 15 Feb 2023 11:39:02 -0800
X-Mailer: MailMate (1.14r5918)
Message-ID: <B04768ED-4E00-46AD-87A0-8AF89479A87F@flugsvamp.com>
In-Reply-To: <20230215110755.33bb9436@kmaincent-XPS-13-7390>
References: <20230215110755.33bb9436@kmaincent-XPS-13-7390>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The code is correct - see Documentation/networking/timestamping.rst

The function returns true/false to indicate whether a deferral is needed
in order to receive the timestamp.  For this chip, a deferral is never
required - the timestamp is inline if it is present.
—
Jonathan


On 15 Feb 2023, at 2:07, Köry Maincent wrote:

> Hello,
>
> I am new to PTP API. I am currently adding the support of PTP to a PHY driver.
> I looked at the other PTP supports to do it and I figured out there might be an
> issue with the broadcom driver. As I am only beginner in PTP I may have wrong
> and if it is the case could you explain me why.
> I also don't have such broadcom PHY to test it, but I want to report it if the
> issue is real.
> The issue is on the rxtstamp callback, it never return true nor deliver the
> skb.
>
> Here is the patch that may fix it:
>
> diff --git a/drivers/net/phy/bcm-phy-ptp.c b/drivers/net/phy/bcm-phy-ptp.c
> index ef00d6163061..57bb63bd98c7 100644
> --- a/drivers/net/phy/bcm-phy-ptp.c
> +++ b/drivers/net/phy/bcm-phy-ptp.c
> @@ -412,7 +412,9 @@ static bool bcm_ptp_rxtstamp(struct mii_timestamper *mii_ts,
>  		__pskb_trim(skb, skb->len - 8);
>  	}
>
> -	return false;
> +	netif_rx(skb);
> +
> +	return true;
>  }
>
>  static bool bcm_ptp_get_tstamp(struct bcm_ptp_private *priv,
> -- 
> 2.25.1
>
>
> Regards,
