Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 432744E66A2
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 17:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351493AbiCXQIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 12:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236762AbiCXQIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 12:08:17 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55F050B15;
        Thu, 24 Mar 2022 09:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=KCYZNR0DLQtC/d/G+7mDrCn/HPx7CoTGKtODd2xHtMg=; b=0sSxb6GH3H5fI0U9vqZvk6pxAy
        5dQJNy9rKaMdjqAoQeB+oZ4VO/nKoP3cgf/oL0ig1zvhcy3zI2KDHU9Pat01r3Loh1vSKB8yUsYOT
        HxZ3/lB72IYkSobOSvhBHb7J/BUrYD41YfabVp5vUGGXmjtMlGuNQVSNq2RVP0gvIeNs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nXPyt-00CTUk-Up; Thu, 24 Mar 2022 17:06:35 +0100
Date:   Thu, 24 Mar 2022 17:06:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arun.Ramadoss@microchip.com
Cc:     linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, davem@davemloft.net, hkallweit1@gmail.com
Subject: Re: [RFC Patch net-next 3/3] net: phy: lan87xx: added ethtool SQI
 support
Message-ID: <YjyXCzPVl0ZlRUeE@lunn.ch>
References: <20220321155337.16260-1-arun.ramadoss@microchip.com>
 <20220321155337.16260-4-arun.ramadoss@microchip.com>
 <YjjFtUEDm2Dta1ez@lunn.ch>
 <ba1d251a9bd93cdf4c894313637dd9618cd8091c.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba1d251a9bd93cdf4c894313637dd9618cd8091c.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 24, 2022 at 03:48:57PM +0000, Arun.Ramadoss@microchip.com wrote:
> Hi Andrew,
> 
> Thanks for the review.
> 
> On Mon, 2022-03-21 at 19:36 +0100, Andrew Lunn wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you
> > know the content is safe
> > 
> > > +#define T1_DCQ_SQI_MSK                       GENMASK(3, 1)
> > > +static int lan87xx_get_sqi(struct phy_device *phydev)
> > > +{
> > > +     u16 sqi_value[LAN87XX_SQI_ENTRY];
> > > +     for (i = 0; i < LAN87XX_SQI_ENTRY; i++) {
> > > +
> > > +             sqi_value[i] = FIELD_GET(T1_DCQ_SQI_MSK, rc);
> > > +
> > > +     /* Sorting SQI values */
> > > +     sort(sqi_value, LAN87XX_SQI_ENTRY, sizeof(u16),
> > > lan87xx_sqi_cmp, NULL);
> > 
> > Sort is quite heavyweight. Your SQI values are in the range 0-7
> > right?
> > So rather than have an array of LAN87XX_SQI_ENTRY entries, why not
> > create a histogram? You then just need to keep 8 uints. There is no
> > need to perform a sort to discard the outliers, simply remove from
> > the
> > outer histogram buckets. And then you can calculate the average.
> > 
> > That should be faster and use less memory.
> > 
> >      Andrew
> 
> I could get the algorithm for replacing array of LAN87XX_SQI_ENTRY(200)
> to array of 8 (sqi values 0 to 7) and increment the array[sqi_value]
> for every reading. And calculate the Average = ( 1 * array[1] + 2 *
> array[2] ... + 7 * array[7])/LAN87XX_SQI_ENTRY. By this way we get the
> average for 200 entries.
> But I couldn't get the algorithm on how to discard the outliers from
> the buckets. our main aim is to average from array[40] to arrary[160]
> value. Can you bit elaborate on how to remove the outer histogram
> buckets.

So your raw results look something like

array[0] = 10
array[1] = 10
array[2] = 25
array[3] = 100
array[4] = 50
array[5] = 1
array[6] = 4
array[7] = 0

To discard the lower outliers, take 40 away from the array[0],
array[1], array[2], etc. To discard the upper outliers, take 40 away
from array[7], array[6], array[5], etc. So you should end up with:

array[0] = 0
array[1] = 0
array[2] = 5
array[3] = 100
array[4] = 15
array[5] = 0
array[6] = 0
array[7] = 0

and then calculate the average: (2*5 + 3*100 + 4*15) / 120 = 3.

    Andrew
