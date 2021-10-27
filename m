Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAE143C41C
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 09:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240544AbhJ0Hmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 03:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238693AbhJ0Hmq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 03:42:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A48F56109E;
        Wed, 27 Oct 2021 07:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635320421;
        bh=7NBy8H/C7YS9N/C30iua9nG2v+v5baH7aK0havVA+7g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n1J0aCJP1Tt5r11wC3fsuUBKHhmqMu5E4aO6FiBDjPG43XDSR3rS4raX0hIm0fezP
         YRM5c3HoaQhLVu2oDo6n1ATBH5FzZeSWfPi0IEn0K+/Zk8x9M0vLuIZvVlJp0/cCLj
         YqkoZAZW5ZYN8cWjYKFQBsKuSFmEfT1EnwVw3WTZTgGWRl0JMc+QK6vYAcYGsQCgVl
         rT+Qw9mv+PWHvf7vuWxKJm5QDFR+mqgwBTt891XlOL3Csija5aW2d04BMGzi0+3Lac
         D5QvHYohjIJ47V0p+7NAR50wV7FpxdAyJPOjjux8uDPN+Sz20aEbzPS94mJh3Goiem
         UJxZ9oACWynBw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mfdXY-000468-Q9; Wed, 27 Oct 2021 09:40:05 +0200
Date:   Wed, 27 Oct 2021 09:40:04 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Amitkumar Karwar <akarwar@marvell.com>
Subject: Re: [PATCH 3/3] mwifiex: fix division by zero in fw download path
Message-ID: <YXkCVLJrQC7ig31t@hovoldconsulting.com>
References: <20211026095214.26375-1-johan@kernel.org>
 <20211026095214.26375-3-johan@kernel.org>
 <CA+ASDXNbMJ1EgPRvosx0AbJgsE-qOiaQjeD=vCEyDLoUQAgkiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+ASDXNbMJ1EgPRvosx0AbJgsE-qOiaQjeD=vCEyDLoUQAgkiw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 10:35:37AM -0700, Brian Norris wrote:
> On Tue, Oct 26, 2021 at 2:53 AM Johan Hovold <johan@kernel.org> wrote:
> >
> > Add the missing endpoint max-packet sanity check to probe() to avoid
> > division by zero in mwifiex_write_data_sync() in case a malicious device
> > has broken descriptors (or when doing descriptor fuzz testing).
> >
> > Note that USB core will reject URBs submitted for endpoints with zero
> > wMaxPacketSize but that drivers doing packet-size calculations still
> > need to handle this (cf. commit 2548288b4fb0 ("USB: Fix: Don't skip
> > endpoint descriptors with maxpacket=0")).
> >
> > Fixes: 4daffe354366 ("mwifiex: add support for Marvell USB8797 chipset")
> > Cc: stable@vger.kernel.org      # 3.5
> > Cc: Amitkumar Karwar <akarwar@marvell.com>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
> 
> Seems like you're missing a changelog and a version number, since
> you've already sent previous versions of this patch.

Seems like you're confusing me with someone else.
 
> >  drivers/net/wireless/marvell/mwifiex/usb.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
> > index 426e39d4ccf0..2826654907d9 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/usb.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/usb.c
> > @@ -502,6 +502,9 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
> >                         atomic_set(&card->tx_cmd_urb_pending, 0);
> >                         card->bulk_out_maxpktsize =
> >                                         le16_to_cpu(epd->wMaxPacketSize);
> > +                       /* Reject broken descriptors. */
> > +                       if (card->bulk_out_maxpktsize == 0)
> > +                               return -ENODEV;
> 
> If we're really talking about malicious devices, I'm still not 100%
> sure this is sufficient -- what if the device doesn't advertise the
> right endpoints? Might we get through the surrounding loop without
> ever even reaching this code? Seems like the right thing to do would
> be to pull the validation outside the loop.

But you're right about this. The driver looks up its resources but still
proceeds if they're not there (and will eventually try to submit URBs
for the default pipe).

I'll send a v2.

Johan
