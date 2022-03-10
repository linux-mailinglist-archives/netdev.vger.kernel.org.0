Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00EAA4D3E45
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 01:37:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238926AbiCJAiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 19:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239124AbiCJAiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 19:38:06 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4F511EF1B;
        Wed,  9 Mar 2022 16:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qkSw8hFepbS/+lTKiAiHCLoo8HAGpSWpJ3J4XSJ2/aQ=; b=NgwZf8pABSXEAREtCZ5A0GPZeh
        0pqAIZgLqe9RaJebDPGZT5iu/UrxJWB0fQPQ3jAqT5NpCASIlahl8tuss8BvunFNULc3b1P9c4S8e
        GHlvxc3DuregtawaU8CkNnblPsxCmtJ6WkEjGeYS4ja7Y9PGgEXDweHzsm+eGhlBsucs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nS6ne-00A3wA-TX; Thu, 10 Mar 2022 01:37:02 +0100
Date:   Thu, 10 Mar 2022 01:37:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net-next] net: lan966x: Improve the CPU TX bitrate.
Message-ID: <YilILpaLAUuwbo6J@lunn.ch>
References: <20220308165727.4088656-1-horatiu.vultur@microchip.com>
 <YifMSUA/uZoPnpf1@lunn.ch>
 <20220308223000.vwdc6tk6wa53x64c@soft-dev3-1.localhost>
 <YiinmN+VBWRxN5l4@lunn.ch>
 <20220309220516.smxhbtikbvctlkeh@soft-dev3-1.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309220516.smxhbtikbvctlkeh@soft-dev3-1.localhost>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 09, 2022 at 11:05:16PM +0100, Horatiu Vultur wrote:
> The 03/09/2022 14:11, Andrew Lunn wrote:
> > 
> > On Tue, Mar 08, 2022 at 11:30:00PM +0100, Horatiu Vultur wrote:
> > > The 03/08/2022 22:36, Andrew Lunn wrote:
> > > >
> > > > >  static int lan966x_port_inj_ready(struct lan966x *lan966x, u8 grp)
> > > > >  {
> > > > > -     u32 val;
> > > > > +     unsigned long time = jiffies + usecs_to_jiffies(READL_TIMEOUT_US);
> > > > > +     int ret = 0;
> > > > >
> > > > > -     return readx_poll_timeout_atomic(lan966x_port_inj_status, lan966x, val,
> > > > > -                                      QS_INJ_STATUS_FIFO_RDY_GET(val) & BIT(grp),
> > > > > -                                      READL_SLEEP_US, READL_TIMEOUT_US);
> > > > > +     while (!(lan_rd(lan966x, QS_INJ_STATUS) &
> > > > > +              QS_INJ_STATUS_FIFO_RDY_SET(BIT(grp)))) {
> > > > > +             if (time_after(jiffies, time)) {
> > > > > +                     ret = -ETIMEDOUT;
> > > > > +                     break;
> > > > > +             }
> > > >
> > > > Did you try setting READL_SLEEP_US to 0? readx_poll_timeout_atomic()
> > > > explicitly supports that.
> > >
> > > I have tried but it didn't improve. It was the same as before.
> > 
> > The reason i recommend ipoll.h is that your implementation has the
> > usual bug, which iopoll does not have. Since you are using _atomic()
> > it is less of an issue, but it still exists.
> > 
> >      while (!(lan_rd(lan966x, QS_INJ_STATUS) &
> >               QS_INJ_STATUS_FIFO_RDY_SET(BIT(grp)))) {
> > 
> > Say you take an interrupt here
> > 
> >              if (time_after(jiffies, time)) {
> >                      ret = -ETIMEDOUT;
> >                      break;
> >              }
> > 
> > 
> > The interrupt takes a while, so that by the time you get to
> > time_after(), you have reached your timeout. So -ETIMEDOUT is
> > returned. But in fact, the hardware has done its thing, and if you
> > where to read the status the bit would be set, and you should actually
> > return O.K, not an error.
> 
> That is a good catch and really nice explanation!
> Then if I add also the check at the end, then it should be also OK.

You are then just repeating code which is already in the core. That is
generally not liked. If you find reading the status once works 99% of
the time, then i suggest you call readx_poll_timeout_atomic() when the
status does indicate you need to poll.

       Andrew
