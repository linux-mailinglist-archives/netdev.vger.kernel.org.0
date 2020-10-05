Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3E52835DE
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 14:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgJEMje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 08:39:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgJEMje (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 08:39:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB4342085B;
        Mon,  5 Oct 2020 12:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601901573;
        bh=KxuFX01UdKML8M/f3XAHRInT6NJBmExMMZe6BPoLwow=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PbwN8ebIa5g1VufJANo9KZ31DsxjHeUVqMxSIrDrUv4TugU9+ymp78CSRhBoL1ZRO
         20HdnviuG/Kjn17GdvsiRjK5Mcq5BJorCK6zGPmkwIUvx7GhX0qGgNwi7QRjKmVyiF
         kcjmY0qkKlEsK+u925V9wNSwnTOWr+MNMxa4IjII=
Date:   Mon, 5 Oct 2020 14:40:18 +0200
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
Message-ID: <20201005124018.GA800868@kroah.com>
References: <20201003135449.GA2691@kroah.com>
 <A1C95238-CBCB-4FD4-B46D-A62AED0C77E5@holtmann.org>
 <20201003160713.GA1512229@kroah.com>
 <AABC2831-4E88-41A2-8A20-1BFC88895686@holtmann.org>
 <20201004105124.GA2429@kroah.com>
 <3F7BDD50-DEA3-4CB0-A9A0-69E7EE2923D5@holtmann.org>
 <20201005083624.GA2442@kroah.com>
 <220D3B4E-D73E-43AD-8FF8-887D1A628235@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <220D3B4E-D73E-43AD-8FF8-887D1A628235@holtmann.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 05, 2020 at 02:19:32PM +0200, Marcel Holtmann wrote:
> Hi Greg,
> 
> >>>>>>> This reverts commit 0eee35bdfa3b472cc986ecc6ad76293fdcda59e2 as it
> >>>>>>> breaks all bluetooth connections on my machine.
> >>>>>>> 
> >>>>>>> Cc: Marcel Holtmann <marcel@holtmann.org>
> >>>>>>> Cc: Sathish Narsimman <sathish.narasimman@intel.com>
> >>>>>>> Fixes: 0eee35bdfa3b ("Bluetooth: Update resolving list when updating whitelist")
> >>>>>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >>>>>>> ---
> >>>>>>> net/bluetooth/hci_request.c | 41 ++-----------------------------------
> >>>>>>> 1 file changed, 2 insertions(+), 39 deletions(-)
> >>>>>>> 
> >>>>>>> This has been bugging me for since 5.9-rc1, when all bluetooth devices
> >>>>>>> stopped working on my desktop system.  I finally got the time to do
> >>>>>>> bisection today, and it came down to this patch.  Reverting it on top of
> >>>>>>> 5.9-rc7 restored bluetooth devices and now my input devices properly
> >>>>>>> work.
> >>>>>>> 
> >>>>>>> As it's almost 5.9-final, any chance this can be merged now to fix the
> >>>>>>> issue?
> >>>>>> 
> >>>>>> can you be specific what breaks since our guys and I also think the
> >>>>>> ChromeOS guys have been testing these series of patches heavily.
> >>>>> 
> >>>>> My bluetooth trackball does not connect at all.  With this reverted, it
> >>>>> all "just works".
> >>>>> 
> >>>>> Same I think for a Bluetooth headset, can check that again if you really
> >>>>> need me to, but the trackball is reliable here.
> >>>>> 
> >>>>>> When you run btmon does it indicate any errors?
> >>>>> 
> >>>>> How do I run it and where are the errors displayed?
> >>>> 
> >>>> you can do btmon -w trace.log and just let it run like tcdpump.
> >>> 
> >>> Ok, attached.
> >>> 
> >>> The device is not connecting, and then I open the gnome bluetooth dialog
> >>> and it scans for devices in the area, but does not connect to my
> >>> existing devices at all.
> >>> 
> >>> Any ideas?
> >> 
> >> the trace file is from -rc7 or from -rc7 with this patch reverted?
> >> 
> >> I asked, because I see no hint that anything goes wrong. However I have a suspicion if you bisected it to this patch.
> >> 
> >> diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
> >> index e0269192f2e5..94c0daa9f28d 100644
> >> --- a/net/bluetooth/hci_request.c
> >> +++ b/net/bluetooth/hci_request.c
> >> @@ -732,7 +732,7 @@ static int add_to_white_list(struct hci_request *req,
> >>                return -1;
> >> 
> >>        /* White list can not be used with RPAs */
> >> -       if (!allow_rpa && !use_ll_privacy(hdev) &&
> >> +       if (!allow_rpa &&
> >>            hci_find_irk_by_addr(hdev, &params->addr, params->addr_type)) {
> >>                return -1;
> >>        }
> >> @@ -812,7 +812,7 @@ static u8 update_white_list(struct hci_request *req)
> >>                }
> >> 
> >>                /* White list can not be used with RPAs */
> >> -               if (!allow_rpa && !use_ll_privacy(hdev) &&
> >> +               if (!allow_rpa &&
> >>                    hci_find_irk_by_addr(hdev, &b->bdaddr, b->bdaddr_type)) {
> >>                        return 0x00;
> >>                }
> >> 
> >> 
> >> If you just do the above, does thing work for you again?
> > 
> > Corrupted white-space issues aside, yes, it works!
> 
> I just pasted it from a different terminal ;)
> 
> > I am running 5.9-rc8 with just this change on it and my tracball works
> > just fine.
> > 
> >> My suspicion is that the use_ll_privacy check is the wrong one here. It only checks if hardware feature is available, not if it is also enabled.
> > 
> > How would one go about enabling such a hardware feature if they wanted
> > to?  :)
> 
> I need to understand what is going wrong for you. I have a suspicion,
> but first I need to understand what kind of device you have. I hope
> the trace file is enough.

If you need any other information, just let me know, this is a USB
Bluetooth controller from Intel:

	$ lsusb | grep Blue
	Bus 009 Device 002: ID 8087:0029 Intel Corp. AX200 Bluetooth

And the output of usb-devices for it:
	T:  Bus=09 Lev=01 Prnt=01 Port=04 Cnt=01 Dev#=  2 Spd=12  MxCh= 0
	D:  Ver= 2.01 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
	P:  Vendor=8087 ProdID=0029 Rev=00.01
	C:  #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
	I:  If#=0x0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
	I:  If#=0x1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb

thanks,

greg k-h
