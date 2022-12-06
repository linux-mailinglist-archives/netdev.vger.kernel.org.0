Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B558644555
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 15:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234462AbiLFOJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 09:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiLFOJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 09:09:22 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D65D13E;
        Tue,  6 Dec 2022 06:09:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Si6FRZb37FNbgQkWe+CseEcMrXZ2g2ulTkRB1hZr1Zo=; b=oe4qn6ecFfzMWs6oZprIQsIZ3e
        eKXFpwE8PncL2qV4UIcBmkWkU1c/BNNupCMeMHgmbQgvEnTdIj1byexJgD3kjP3qa7pQofIqYXQZQ
        kGd94ao/7JfPpy7grX4Vt2FrIHL7LkfvtZSGL8sSLIDwePo0sFTIKKwmL56BmHeWGRnY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p2Yd1-004XDZ-0b; Tue, 06 Dec 2022 15:08:59 +0100
Date:   Tue, 6 Dec 2022 15:08:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya.Koppera@microchip.com
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        richardcochran@gmail.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v5 net-next 2/2] net: phy: micrel: Fix warn: passing zero
 to PTR_ERR
Message-ID: <Y49M++waEHLm0hEA@lunn.ch>
References: <20221206073511.4772-1-Divya.Koppera@microchip.com>
 <20221206073511.4772-3-Divya.Koppera@microchip.com>
 <Y48+rLpF7Gre/s1P@lunn.ch>
 <CO1PR11MB47713C125F3D0E08B7A6A132E21B9@CO1PR11MB4771.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB47713C125F3D0E08B7A6A132E21B9@CO1PR11MB4771.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > -     if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
> > > -         !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
> > > -             return 0;
> > > -
> > 
> > Why are you removing this ?
> > 
> 
> I got review comment from Richard in v2 as below, making it as consistent by checking ptp_clock. So removed it in next revision.
> 
> " > static int lan8814_ptp_probe_once(struct phy_device *phydev)
> > {
> >         struct lan8814_shared_priv *shared = phydev->shared->priv;
> > 
> >         if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
> >             !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
> >                 return 0;
> 
> It is weird to use macros here, but not before calling ptp_clock_register.
> Make it consistent by checking shared->ptp_clock instead.
> That is also better form."

O.K. If Richard said this fine.

Just out of interest, could you disassemble lan8814_ptp_probe_once()
when CONFIG_PTP_1588_CLOCK is disabled, with and without this check?

My guess is, when PTP is disabled, the mutex still gets initialised,
all the member of shared->ptp_clock_info are set. The optimise cannot
remove it. With the macro check, the function is empty. So you end up
with a slightly bigger text size.

       Andrew
