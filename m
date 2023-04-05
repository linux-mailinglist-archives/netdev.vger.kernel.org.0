Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008316D8003
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 16:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238477AbjDEOuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 10:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238213AbjDEOuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 10:50:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE80546B0
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 07:50:38 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1pk4SX-0001Cb-Ce; Wed, 05 Apr 2023 16:50:01 +0200
Received: from mfe by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1pk4SV-0007PB-33; Wed, 05 Apr 2023 16:49:59 +0200
Date:   Wed, 5 Apr 2023 16:49:59 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 03/12] net: phy: add phy_device_set_miits helper
Message-ID: <20230405144959.t2vledwhwzyahyuk@pengutronix.de>
References: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
 <20230405-net-next-topic-net-phy-reset-v1-3-7e5329f08002@pengutronix.de>
 <d00dab9f-7678-4ef3-be51-c31cdb9564d1@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d00dab9f-7678-4ef3-be51-c31cdb9564d1@lunn.ch>
User-Agent: NeoMutt/20180716
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23-04-05, Andrew Lunn wrote:
> > +void phy_device_set_miits(struct phy_device *phydev,
> > +			  struct mii_timestamper *mii_ts)
> > +{
> > +	if (!phydev)
> > +		return;
> > +
> > +	if (phydev->mii_ts) {
> > +		phydev_dbg(phydev,
> > +			   "MII timestamper already set -> skip set\n");
> > +		return;
> > +	}
> > +
> > +	phydev->mii_ts = mii_ts;
> > +}
> 
> We tend to be less paranoid. Few, if any, other functions test that
> phydev is not NULL. And the current code allows overwriting of an
> existing stamper. If you think overwriting should not be allowed
> return -EINVAL, and change all the callers to test for it.

I can drop the 'if (!phydev)' check if you want. Return -EINVAL is
possible too.

> > +EXPORT_SYMBOL(phy_device_set_miits);
> 
> _GPL please. The code is a bit inconsistent, but new symbols should be
> EXPORT_SYMBOL_GPL.

Sure! Don't know why I added it as EXPORT_SYMBOL in the first place.

> I do however like this patch, hiding away the internals of phydev.

Thanks for the fast response.

Regards,
  Marco

> 
>   Andrew
> 
