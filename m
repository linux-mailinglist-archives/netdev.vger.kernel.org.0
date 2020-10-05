Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B47283222
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 10:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgJEIfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 04:35:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:57652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbgJEIfk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 04:35:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D24B2078D;
        Mon,  5 Oct 2020 08:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601886939;
        bh=Ux7wzqDZqMSfqPJ3C25oE2XjowrUaZ2Csg7ZYyQpSyQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xG4ndpIE1HYjiRaDkVwGZteyh+PtxQsDkHlQvVJdE5TLb0f82f9A8bN9FjA18lEjQ
         0f+v1mUrrqIujGYLT7yUkPq1t8J45BXjjMmFcaCOvAwkWdZV3MbCXiBEvsJdFYc/sY
         bDkVN7Z3deik1DQo+l9EBaJeVDMalPdSHv8LcRV8=
Date:   Mon, 5 Oct 2020 10:36:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Sathish Narsimman <sathish.narasimman@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "Bluetooth: Update resolving list when updating
 whitelist"
Message-ID: <20201005083624.GA2442@kroah.com>
References: <20201003135449.GA2691@kroah.com>
 <A1C95238-CBCB-4FD4-B46D-A62AED0C77E5@holtmann.org>
 <20201003160713.GA1512229@kroah.com>
 <AABC2831-4E88-41A2-8A20-1BFC88895686@holtmann.org>
 <20201004105124.GA2429@kroah.com>
 <3F7BDD50-DEA3-4CB0-A9A0-69E7EE2923D5@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3F7BDD50-DEA3-4CB0-A9A0-69E7EE2923D5@holtmann.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 04, 2020 at 06:59:24PM +0200, Marcel Holtmann wrote:
> Hi Greg,
> 
> >>>>> This reverts commit 0eee35bdfa3b472cc986ecc6ad76293fdcda59e2 as it
> >>>>> breaks all bluetooth connections on my machine.
> >>>>> 
> >>>>> Cc: Marcel Holtmann <marcel@holtmann.org>
> >>>>> Cc: Sathish Narsimman <sathish.narasimman@intel.com>
> >>>>> Fixes: 0eee35bdfa3b ("Bluetooth: Update resolving list when updating whitelist")
> >>>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >>>>> ---
> >>>>> net/bluetooth/hci_request.c | 41 ++-----------------------------------
> >>>>> 1 file changed, 2 insertions(+), 39 deletions(-)
> >>>>> 
> >>>>> This has been bugging me for since 5.9-rc1, when all bluetooth devices
> >>>>> stopped working on my desktop system.  I finally got the time to do
> >>>>> bisection today, and it came down to this patch.  Reverting it on top of
> >>>>> 5.9-rc7 restored bluetooth devices and now my input devices properly
> >>>>> work.
> >>>>> 
> >>>>> As it's almost 5.9-final, any chance this can be merged now to fix the
> >>>>> issue?
> >>>> 
> >>>> can you be specific what breaks since our guys and I also think the
> >>>> ChromeOS guys have been testing these series of patches heavily.
> >>> 
> >>> My bluetooth trackball does not connect at all.  With this reverted, it
> >>> all "just works".
> >>> 
> >>> Same I think for a Bluetooth headset, can check that again if you really
> >>> need me to, but the trackball is reliable here.
> >>> 
> >>>> When you run btmon does it indicate any errors?
> >>> 
> >>> How do I run it and where are the errors displayed?
> >> 
> >> you can do btmon -w trace.log and just let it run like tcdpump.
> > 
> > Ok, attached.
> > 
> > The device is not connecting, and then I open the gnome bluetooth dialog
> > and it scans for devices in the area, but does not connect to my
> > existing devices at all.
> > 
> > Any ideas?
> 
> the trace file is from -rc7 or from -rc7 with this patch reverted?
> 
> I asked, because I see no hint that anything goes wrong. However I have a suspicion if you bisected it to this patch.
> 
> diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
> index e0269192f2e5..94c0daa9f28d 100644
> --- a/net/bluetooth/hci_request.c
> +++ b/net/bluetooth/hci_request.c
> @@ -732,7 +732,7 @@ static int add_to_white_list(struct hci_request *req,
>                 return -1;
>  
>         /* White list can not be used with RPAs */
> -       if (!allow_rpa && !use_ll_privacy(hdev) &&
> +       if (!allow_rpa &&
>             hci_find_irk_by_addr(hdev, &params->addr, params->addr_type)) {
>                 return -1;
>         }
> @@ -812,7 +812,7 @@ static u8 update_white_list(struct hci_request *req)
>                 }
>  
>                 /* White list can not be used with RPAs */
> -               if (!allow_rpa && !use_ll_privacy(hdev) &&
> +               if (!allow_rpa &&
>                     hci_find_irk_by_addr(hdev, &b->bdaddr, b->bdaddr_type)) {
>                         return 0x00;
>                 }
> 
> 
> If you just do the above, does thing work for you again?

Corrupted white-space issues aside, yes, it works!

I am running 5.9-rc8 with just this change on it and my tracball works
just fine.

> My suspicion is that the use_ll_privacy check is the wrong one here. It only checks if hardware feature is available, not if it is also enabled.

How would one go about enabling such a hardware feature if they wanted
to?  :)

Anyway, feel free to put:

Tested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

on the above patch and hopefully get it to Linus for 5.9-final.

thanks,

greg k-h
