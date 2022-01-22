Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F055496949
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 02:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbiAVBxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 20:53:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48530 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230093AbiAVBxp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 20:53:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=grnrX8R53/kbNDeyKjYFLKU8gH21NFChKoGWFWbG/ko=; b=yJ0cKD3VVjIOTpNR/7C5kbD/CP
        8ryoN7qnZjxEk9vMCFCtT1y07KFFIVRFxZoUwaKsgMydCbtFpUInMd6nRhq1yjGMd41lEnNBBcRyN
        hpzFr8H71s7mmrPLnFvEYY9aRUXWTjkf6JW+JNjYWs0FpRDyW6EuWdnPArNvS3NMQiXE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nB5b4-002CXG-MF; Sat, 22 Jan 2022 02:53:42 +0100
Date:   Sat, 22 Jan 2022 02:53:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Sergei Trofimovich <slyich@gmail.com>, netdev@vger.kernel.org
Subject: Re: atl1c drivers run 'napi/eth%d-385' named threads with
 unsubstituted %d
Message-ID: <YetjpvBgQFApTRu0@lunn.ch>
References: <YessW5YR285JeLf5@nz>
 <YetFsbw6885xUwSg@lunn.ch>
 <20220121170313.1d6ccf4d@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121170313.1d6ccf4d@hermes.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > So please give this a try. I've not even compile tested it...
> > 
> > iff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> > index da595242bc13..983a52f77bda 100644
> > --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> > +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> > @@ -2706,6 +2706,10 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> >                 goto err_alloc_etherdev;
> >         }
> >  
> > +       err = dev_alloc_name(netdev, netdev->name);
> > +       if (err < 0)
> > +               goto err_init_netdev;
> > +
> >         err = atl1c_init_netdev(netdev, pdev);
> >         if (err) {
> >                 dev_err(&pdev->dev, "init netdevice failed\n");
> > 
> > If this works, i can turn it into a real patch submission.
> > 
> >    Andrew
> 
> 
> This may not work right because probe is not called with RTNL.
> And the alloc_name is using RTNL to prevent two devices from
> getting the same name.

Oh, yes. I looked at some of the users. And some do take rtnl before
calling it. And some don't!

Looking at register_netdev(), it seems we need something like:

	if (rtnl_lock_killable()) {
	       err = -EINTR;
	       goto err_init_netdev;
	}
	err = dev_alloc_name(netdev, netdev->name);
	rtnl_unlock();
	if (err < 0)
		goto err_init_netdev;


It might also be a good idea to put a ASSERT_RTNL() in
__dev_alloc_name() to catch any driver doing this wrong.

	   Andrew
