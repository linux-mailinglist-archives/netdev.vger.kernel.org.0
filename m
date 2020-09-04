Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C4725DBE3
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 16:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730395AbgIDOgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 10:36:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730416AbgIDOg2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 10:36:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DF80206F2;
        Fri,  4 Sep 2020 14:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599230187;
        bh=SJlEO4N5TR/khQclPBpz+ffvQxoaMzhtcy+BXKr8CN4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RSsNrw0B7NTAEh5S2xDcxMCwg9oo3qOuYcnBcEO9fUkmRH51/vrsJYuf5TNAGBLN7
         QHceADKwaHesQ7q1qSl51AelLujPDfeZRNKCIhPXCdXy7NEKN1Rn4AJe2wyyN/12Ra
         k+2NmfnZGXK1Xah4n6Wy2wOBczhAFf6b6uowzIj0=
Date:   Fri, 4 Sep 2020 16:36:48 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Nuernberger, Stefan" <snu@amazon.de>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "orcohen@paloaltonetworks.com" <orcohen@paloaltonetworks.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "Shah, Amit" <aams@amazon.de>
Subject: Re: [PATCH] net/packet: fix overflow in tpacket_rcv
Message-ID: <20200904143648.GA3212511@kroah.com>
References: <CAM6JnLf_8nwzq+UGO+amXpeApCDarJjwzOEHQd5qBhU7YKm3DQ@mail.gmail.com>
 <20200904133052.20299-1-snu@amazon.com>
 <20200904141617.GA3185752@kroah.com>
 <1599229365.17829.3.camel@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1599229365.17829.3.camel@amazon.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 04, 2020 at 02:22:46PM +0000, Nuernberger, Stefan wrote:
> On Fri, 2020-09-04 at 16:16 +0200, Greg Kroah-Hartman wrote:
> > On Fri, Sep 04, 2020 at 03:30:52PM +0200, Stefan Nuernberger wrote:
> > > 
> > > From: Or Cohen <orcohen@paloaltonetworks.com>
> > > 
> > > Using tp_reserve to calculate netoff can overflow as
> > > tp_reserve is unsigned int and netoff is unsigned short.
> > > 
> > > This may lead to macoff receving a smaller value then
> > > sizeof(struct virtio_net_hdr), and if po->has_vnet_hdr
> > > is set, an out-of-bounds write will occur when
> > > calling virtio_net_hdr_from_skb.
> > > 
> > > The bug is fixed by converting netoff to unsigned int
> > > and checking if it exceeds USHRT_MAX.
> > > 
> > > This addresses CVE-2020-14386
> > > 
> > > Fixes: 8913336a7e8d ("packet: add PACKET_RESERVE sockopt")
> > > Signed-off-by: Or Cohen <orcohen@paloaltonetworks.com>
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > 
> > > [ snu: backported to 4.9, changed tp_drops counting/locking ]
> > > 
> > > Signed-off-by: Stefan Nuernberger <snu@amazon.com>
> > > CC: David Woodhouse <dwmw@amazon.co.uk>
> > > CC: Amit Shah <aams@amazon.com>
> > > CC: stable@vger.kernel.org
> > > ---
> > >  net/packet/af_packet.c | 9 ++++++++-
> > >  1 file changed, 8 insertions(+), 1 deletion(-)
> > What is the git commit id of this patch in Linus's tree?
> > 
> 
> Sorry, this isn't merged on Linus' tree yet. It's a heads up that the
> backport isn't straightforward.

Ok, please be more specific about this when sending patches out...

greg k-h
