Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACCF96DE9EE
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 05:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbjDLDnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 23:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjDLDnv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 23:43:51 -0400
Received: from out-56.mta1.migadu.com (out-56.mta1.migadu.com [IPv6:2001:41d0:203:375::38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842E840D7
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 20:43:48 -0700 (PDT)
Date:   Tue, 11 Apr 2023 20:43:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1681271023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JSQAFi+1XTiJNdM/+Rp/iE74wT90FMDmD2C7OdnXF10=;
        b=lWaopEHdLhiXvd3INYxNBB+Y+32sAxe+dJVV6/nVthpL9nc5I89NRMooqDzgwdktUV/19R
        ZxB4xRDhCCLx/NGzhf6x5MWfWpxcfAW1b312pcyEGEqhi58VW40SLFxR50Nxa7y1A/iK3C
        arxWk1YvxCbDgqraG+MohNrVyudY+zE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ingo Rohloff <ingo.rohloff@lauterbach.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        robert.hancock@calian.com, Nicolas.Ferre@microchip.com,
        claudiu.beznea@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, tomas.melin@vaisala.com
Subject: Re: [PATCH 0/1] Alternative, restart tx after tx used bit read
Message-ID: <ZDYo6gwe0ukT3ozm@P9FQF9L96D.corp.robot.car>
References: <244d34f9e9fd2b948d822e1dffd9dc2b0c8b336c.camel@calian.com>
 <20230407213349.8013-1-ingo.rohloff@lauterbach.com>
 <20230411190715.6eefb4fa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411190715.6eefb4fa@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 07:07:15PM -0700, Jakub Kicinski wrote:
> On Fri,  7 Apr 2023 23:33:48 +0200 Ingo Rohloff wrote:
> > Analysis:
> > Commit 404cd086f29e867f ("net: macb: Allocate valid memory for TX and RX BD
> > prefetch") mentions:
> > 
> >     GEM version in ZynqMP and most versions greater than r1p07 supports
> >     TX and RX BD prefetch. The number of BDs that can be prefetched is a
> >     HW configurable parameter. For ZynqMP, this parameter is 4.
> > 
> > I think what happens is this:
> > Example Scenario (SW == linux kernel, HW == cadence ethernet IP).
> > 1) SW has written TX descriptors 0..7
> > 2) HW is currently transmitting TX descriptor 6.
> >    HW has already prefetched TX descriptors 6,7,8,9.
> > 3) SW writes TX descriptor 8 (clearing TX_USED)
> > 4) SW writes the TSTART bit.
> >    HW ignores this, because it is still transmitting.
> > 5) HW transmits TX descriptor 7.
> > 6) HW reaches descriptor 8; because this descriptor
> >    has already been prefetched, HW sees a non-active
> >    descriptor (TX_USED set) and stops transmitting.
> 
> This sounds broken, any idea if this is how the IP is supposed to work
> or it may be an integration issue in Zynq?  The other side of this
> question is how expensive the workaround is - a spin lock and two extra
> register reads on completion seems like a lot.
> 
> Roman, Lars, have you seen Tx stalls on your macb setups?

Not yet, but also we have a custom patch that reduces the number of tx queues
to 1, which "fixed" some lockup we've seen in the past.
