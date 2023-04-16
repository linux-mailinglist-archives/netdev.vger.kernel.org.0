Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E82836E39DD
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 17:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbjDPPkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 11:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDPPkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 11:40:19 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEC02D40
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 08:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vhViE8j1ygycZUj3OeUJN/Tg5Ba47Om0Hp0G1Sh7+iQ=; b=hIo3uPcYCpwOMddE1rJhF3hxHv
        kRwkvYPnyDbgGyNytSZdVw0O0S8p4/u6ru75UQByjkb8ywS/8VP9OvgXQrqVB6/uPygP8cG2uSlzA
        v1t7ldT3GtX0jdIFxlHyc63Wys5BJbA7BY9eLN+X3cYGgdV63drJ6JenrHBdzrYy2X0c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1po4U8-00AQys-7B; Sun, 16 Apr 2023 17:40:12 +0200
Date:   Sun, 16 Apr 2023 17:40:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shmuel Hazan <shmuel.h@siklu.com>
Cc:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC PATCH] net: mvpp2: tai: add refcount for ptp worker
Message-ID: <fb41eeca-6a75-44cb-9b95-4f8b7ed052f2@lunn.ch>
References: <6806f01c8a6281a15495f5ead08c8b4403b1a581.camel@siklu.com>
 <69b2616d-dfeb-4e06-8f9b-60ced06cca00@lunn.ch>
 <43513e82fcdf84ce363abe31d6998b4f40aaa49f.camel@siklu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43513e82fcdf84ce363abe31d6998b4f40aaa49f.camel@siklu.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 16, 2023 at 03:25:55PM +0000, Shmuel Hazan wrote:
> On Sun, 2023-04-16 at 16:52 +0200, Andrew Lunn wrote:
> > 
> > > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
> > > b/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
> > > index 95862aff49f1..1b57573dd866 100644
> > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
> > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
> > > @@ -61,6 +61,7 @@ struct mvpp2_tai {
> > >       u64 period;             // nanosecond period in 32.32 fixed
> > > point
> > >       /* This timestamp is updated every two seconds */
> > >       struct timespec64 stamp;
> > > +     u16 poll_worker_refcount;
> > 
> > What lock is protecting this? It would be nice to comment in the
> > commit message why it is safe to use a simple u16.
> 
> Hi Andrew, 
> 
> thanks for your response. In theory, the only code path
> to these functions (mvpp22_tai_start and mvpp22_tai_stop)
> is ioctl (mvpp2_ioctl -> mvpp2_set_ts_config) which should lock
> rtnl. However, 
> It would probably be a good idea to also lock mvpp2_tai->lock too.

I cannot comment on what locks should be used, i don't know the code.

Which is why as a reviewer, i just want some indication you have
thought about locking, and you think it is safe, given that there are
not obvious locks in the code.

	Andrew
