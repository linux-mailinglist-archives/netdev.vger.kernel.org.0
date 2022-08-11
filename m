Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933AC58F50D
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 02:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbiHKAFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 20:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiHKAFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 20:05:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949A145066
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 17:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=E+VMxyFx22o9k6Z47KDFf3vd8iJpnH6qCgtaat/xdhU=; b=G5Orc4dl6bG+skXptOT5lQQLq8
        nwtzT1cIH+lyDIAwuApOCjt4iP8Nu63QGhyo3TNWegvb5vWPABMZki1jz7zwXJ3MMprRkSXmWTist
        D7XXVefQvrb92pilflEE6bTGPDcCR5wsFt6ezStObYyvo1sncLHLF1FK7q+Ub3Yd//Hs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oLvhj-00CyTn-L8; Thu, 11 Aug 2022 02:05:39 +0200
Date:   Thu, 11 Aug 2022 02:05:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>
Subject: Re: [PATCH] fec: Restart PPS after link state change
Message-ID: <YvRH06S/7E6J8RY0@lunn.ch>
References: <20220809124119.29922-1-csokas.bence@prolan.hu>
 <YvKZNcVfYdLw7bkm@lunn.ch>
 <299d74d5-2d56-23f6-affc-78bb3ae3e03c@prolan.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <299d74d5-2d56-23f6-affc-78bb3ae3e03c@prolan.hu>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The fec driver doesn't support anything other than PTP_CLK_REQ_PPS. And if
> it will at some point, this will need to be amended anyways.

O.K.

> > 
> > >   	/* Whack a reset.  We should wait for this.
> > >   	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
> > > @@ -1119,6 +1120,13 @@ fec_restart(struct net_device *ndev)
> > >   	if (fep->bufdesc_ex)
> > >   		fec_ptp_start_cyclecounter(ndev);
> > > +	/* Restart PPS if needed */
> > > +	if (fep->pps_enable) {
> > > +		/* Clear flag so fec_ptp_enable_pps() doesn't return immediately */
> > > +		fep->pps_enable = 0;
> > 
> > If reset causes PPS to stop, maybe it would be better to do this
> > unconditionally?
> 
> But if it wasn't enabled before the reset in the first place, we wouldn't
> want to unexpectedly start it.

We should decide what fep->pps_enable actually means. It should be
enabled, or it is actually enabled? Then it becomes clear if the reset
function should clear it to reflect the hardware, or if the
fec_ptp_enable_pps() should not be looking at it, and needs to read
the status from the hardware.

> > 	fep->pps_enable = 0;
> > 	fep->ptp_caps.enable(&fep->ptp_caps, &ptp_rq, 1);
> > 
> > > +	if (fep->bufdesc_ex)
> > > +		ecntl |= (1 << 4);
> > 
> > Please replace (1 << 4) with a #define to make it clear what this is doing.
> 
> I took it from the original source, line 1138 as of commit #504148f. It is
> the EN1588 bit by the way. I shall replace it with a #define in both places
> then. Though the code is riddled with other magic numbers without
> explanation, and I probably won't be bothered to fix them all.

Yes, i understand. It just makes it easier to review if you fixup
parts of the code you are changing.

> > So you re-start PPS in stop()? Should it keep outputting when the
> > interface is down?
> 
> Yes. We use PPS to synchronize devices on a common backplane. We use PTP to
> sync this PPS to a master clock. But if PTP sync drops out, we wouldn't want
> the backplane-level synchronization to fail. The PPS needs to stay on as
> long as userspace *explicitly* disables it, regardless of what happens to
> the link.

We need the PTP Maintainers view on that. I don't know if that is
normal or not.

> > Also, if it is always outputting, don't you need to stop it in
> > fec_drv_remove(). You probably don't want to still going after the
> > driver is unloaded.
> 
> Good point, that is one exception we could make to the above statement
> (though even in this case, userspace *really* should disable PPS before
> unloading the module).

Never trust userspace. Ever.

      Andrew
