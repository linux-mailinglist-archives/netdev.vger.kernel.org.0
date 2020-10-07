Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F83286060
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 15:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbgJGNnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 09:43:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728441AbgJGNnJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 09:43:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A7972087D;
        Wed,  7 Oct 2020 13:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602078187;
        bh=gkAomzc45+MS7PgJfwNGVSS/cVU6gEEj030vWgFB0kM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u0fS/4xwqpEtLgB7Wuz6e08ksR24fTmMXj1vFC2PjiOYqDn+iBQ+lu+EV3IIYlqv4
         J4caKn/HHpp3EwM2wBa7XZmXXXtCCsM4aznKvq6hlebb1upe9+iVqsWyxwA941RzY9
         ekgQloXzV3IqKs/9u/zXk+Lq7ddfygLoTT4YZ20U=
Date:   Wed, 7 Oct 2020 15:43:53 +0200
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
Message-ID: <20201007134353.GA3639@kroah.com>
References: <220D3B4E-D73E-43AD-8FF8-887D1A628235@holtmann.org>
 <20201005124018.GA800868@kroah.com>
 <824BC92C-5035-4B80-80E7-298508E4ADD7@holtmann.org>
 <20201005161149.GA2378402@kroah.com>
 <0C92E812-BF43-46A6-A069-3F7F3278FBB4@holtmann.org>
 <20201005173835.GB2388217@kroah.com>
 <20201005180208.GA2739@kroah.com>
 <D577711C-4AF5-4E82-8A17-E766B64E15A9@holtmann.org>
 <20201007132321.GA2466@kroah.com>
 <20201007134025.GB5963@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201007134025.GB5963@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 03:40:25PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Oct 07, 2020 at 03:23:21PM +0200, Greg Kroah-Hartman wrote:
> > On Mon, Oct 05, 2020 at 08:58:33PM +0200, Marcel Holtmann wrote:
> > > Hi Greg,
> > > 
> > > >>>>>>>>>>>>>> This reverts commit 0eee35bdfa3b472cc986ecc6ad76293fdcda59e2 as it
> > > >>>>>>>>>>>>>> breaks all bluetooth connections on my machine.
> > > >>>>>>>>>>>>>> 
> > > >>>>>>>>>>>>>> Cc: Marcel Holtmann <marcel@holtmann.org>
> > > >>>>>>>>>>>>>> Cc: Sathish Narsimman <sathish.narasimman@intel.com>
> > > >>>>>>>>>>>>>> Fixes: 0eee35bdfa3b ("Bluetooth: Update resolving list when updating whitelist")
> > > >>>>>>>>>>>>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > >>>>>>>>>>>>>> ---
> > > >>>>>>>>>>>>>> net/bluetooth/hci_request.c | 41 ++-----------------------------------
> > > >>>>>>>>>>>>>> 1 file changed, 2 insertions(+), 39 deletions(-)
> > > >>>>>>>>>>>>>> 
> > > >>>>>>>>>>>>>> This has been bugging me for since 5.9-rc1, when all bluetooth devices
> > > >>>>>>>>>>>>>> stopped working on my desktop system.  I finally got the time to do
> > > >>>>>>>>>>>>>> bisection today, and it came down to this patch.  Reverting it on top of
> > > >>>>>>>>>>>>>> 5.9-rc7 restored bluetooth devices and now my input devices properly
> > > >>>>>>>>>>>>>> work.
> > > >>>>>>>>>>>>>> 
> > > >>>>>>>>>>>>>> As it's almost 5.9-final, any chance this can be merged now to fix the
> > > >>>>>>>>>>>>>> issue?
> > > >>>>>>>>>>>>> 
> > > >>>>>>>>>>>>> can you be specific what breaks since our guys and I also think the
> > > >>>>>>>>>>>>> ChromeOS guys have been testing these series of patches heavily.
> > > >>>>>>>>>>>> 
> > > >>>>>>>>>>>> My bluetooth trackball does not connect at all.  With this reverted, it
> > > >>>>>>>>>>>> all "just works".
> > > >>>>>>>>>>>> 
> > > >>>>>>>>>>>> Same I think for a Bluetooth headset, can check that again if you really
> > > >>>>>>>>>>>> need me to, but the trackball is reliable here.
> > > >>>>>>>>>>>> 
> > > >>>>>>>>>>>>> When you run btmon does it indicate any errors?
> > > >>>>>>>>>>>> 
> > > >>>>>>>>>>>> How do I run it and where are the errors displayed?
> > > >>>>>>>>>>> 
> > > >>>>>>>>>>> you can do btmon -w trace.log and just let it run like tcdpump.
> > > >>>>>>>>>> 
> > > >>>>>>>>>> Ok, attached.
> > > >>>>>>>>>> 
> > > >>>>>>>>>> The device is not connecting, and then I open the gnome bluetooth dialog
> > > >>>>>>>>>> and it scans for devices in the area, but does not connect to my
> > > >>>>>>>>>> existing devices at all.
> > > >>>>>>>>>> 
> > > >>>>>>>>>> Any ideas?
> > > >>>>>>>>> 
> > > >>>>>>>>> the trace file is from -rc7 or from -rc7 with this patch reverted?
> > > >>>>>>>>> 
> > > >>>>>>>>> I asked, because I see no hint that anything goes wrong. However I have a suspicion if you bisected it to this patch.
> > > >>>>>>>>> 
> > > >>>>>>>>> diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
> > > >>>>>>>>> index e0269192f2e5..94c0daa9f28d 100644
> > > >>>>>>>>> --- a/net/bluetooth/hci_request.c
> > > >>>>>>>>> +++ b/net/bluetooth/hci_request.c
> > > >>>>>>>>> @@ -732,7 +732,7 @@ static int add_to_white_list(struct hci_request *req,
> > > >>>>>>>>>             return -1;
> > > >>>>>>>>> 
> > > >>>>>>>>>     /* White list can not be used with RPAs */
> > > >>>>>>>>> -       if (!allow_rpa && !use_ll_privacy(hdev) &&
> > > >>>>>>>>> +       if (!allow_rpa &&
> > > >>>>>>>>>         hci_find_irk_by_addr(hdev, &params->addr, params->addr_type)) {
> > > >>>>>>>>>             return -1;
> > > >>>>>>>>>     }
> > > >>>>>>>>> @@ -812,7 +812,7 @@ static u8 update_white_list(struct hci_request *req)
> > > >>>>>>>>>             }
> > > >>>>>>>>> 
> > > >>>>>>>>>             /* White list can not be used with RPAs */
> > > >>>>>>>>> -               if (!allow_rpa && !use_ll_privacy(hdev) &&
> > > >>>>>>>>> +               if (!allow_rpa &&
> > > >>>>>>>>>                 hci_find_irk_by_addr(hdev, &b->bdaddr, b->bdaddr_type)) {
> > > >>>>>>>>>                     return 0x00;
> > > >>>>>>>>>             }
> > > >>>>>>>>> 
> > > >>>>>>>>> 
> > > >>>>>>>>> If you just do the above, does thing work for you again?
> > > >>>>>>>> 
> > > >>>>>>>> Corrupted white-space issues aside, yes, it works!
> > > >>>>>>> 
> > > >>>>>>> I just pasted it from a different terminal ;)
> > > >>>>>>> 
> > > >>>>>>>> I am running 5.9-rc8 with just this change on it and my tracball works
> > > >>>>>>>> just fine.
> > > >>>>>>>> 
> > > >>>>>>>>> My suspicion is that the use_ll_privacy check is the wrong one here. It only checks if hardware feature is available, not if it is also enabled.
> > > >>>>>>>> 
> > > >>>>>>>> How would one go about enabling such a hardware feature if they wanted
> > > >>>>>>>> to?  :)
> > > >>>>>>> 
> > > >>>>>>> I need to understand what is going wrong for you. I have a suspicion,
> > > >>>>>>> but first I need to understand what kind of device you have. I hope
> > > >>>>>>> the trace file is enough.
> > > >>>>>> 
> > > >>>>>> If you need any other information, just let me know, this is a USB
> > > >>>>>> Bluetooth controller from Intel:
> > > >>>>>> 
> > > >>>>>> 	$ lsusb | grep Blue
> > > >>>>>> 	Bus 009 Device 002: ID 8087:0029 Intel Corp. AX200 Bluetooth
> > > >>>>>> 
> > > >>>>>> And the output of usb-devices for it:
> > > >>>>>> 	T:  Bus=09 Lev=01 Prnt=01 Port=04 Cnt=01 Dev#=  2 Spd=12  MxCh= 0
> > > >>>>>> 	D:  Ver= 2.01 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
> > > >>>>>> 	P:  Vendor=8087 ProdID=0029 Rev=00.01
> > > >>>>>> 	C:  #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
> > > >>>>>> 	I:  If#=0x0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> > > >>>>>> 	I:  If#=0x1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> > > >>>>> 
> > > >>>>> I already figured out that it is one of our controllers. The trace file gives it away.
> > > >>>>> 
> > > >>>>> So my suspicion is that the device you want to connect to uses RPA (aka random addresses). And we added support for resolving them in the firmware. Your hardware does support that, but the host side is not fully utilizing it and thus your device is filtered out.
> > > >>>> 
> > > >>>> Dude, get an email client that line-wraps :)
> > > >>>> 
> > > >>>>> If I am not mistaken, then the use_ll_privacy() check in these two specific places need to be replaced with LL Privacy Enabled check. And then the allow_rpa condition will do its job as expected.
> > > >>>>> 
> > > >>>>> We can confirm this if you send me a trace with the patch applied.
> > > >>>> 
> > > >>>> Want me to disconnect the device and then reconnect it using
> > > >>>> bluetootctl?  I'll go do that now...
> > > >>>> 
> > > >>>> Ok, it's attached, I did:
> > > >>>> 
> > > >>>> $ bluetoothctl disconnect F1:85:91:79:73:70
> > > >>>> Attempting to disconnect from F1:85:91:79:73:70
> > > >>>> [CHG] Device F1:85:91:79:73:70 ServicesResolved: no
> > > >>>> Successful disconnected
> > > >>>> 
> > > >>>> And then the gnome bluetooth daemon (or whatever it has) reconnected it
> > > >>>> automatically, so you can see the connection happen, and some movements
> > > >>>> in the log.
> > > >>>> 
> > > >>>> If there's anything else you need, just let me know.
> > > >>> 
> > > >>> so the trace file indicates that you are using static addresses and not RPAs. Now I am confused.
> > > >>> 
> > > >>> What is the content of /sys/kernel/debug/bluetooth/hci0/identity_resolving_keys?
> > > >> 
> > > >> f1:85:91:79:73:70 (type 1) f02567096e8537e5dac1cadf548fa750 00:00:00:00:00:00
> > > > 
> > > > I rebooted, and the same value was there.
> > > > 
> > > >>> The only way I can explain this if you have an entry in that file, but the device is not using it.
> > > >>> 
> > > >>> If you have btmgmt (from bluez.git) you can try "./tools/btmgmt irks” to clear that list and try again.
> > > >> 
> > > >> Ok, I did that, and reconnected, this is still with the kernel that has
> > > >> the patch.  Want me to reboot to a "clean" 5.9-rc8?
> > > > 
> > > > I rebooted into a clean 5.9-rc8 and the device does not connect.
> > > > 
> > > > So I did the following to trace this:
> > > > 
> > > > $ sudo btmgmt irks
> > > > Identity Resolving Keys successfully loaded
> > > > $ sudo cat /sys/kernel/debug/bluetooth/hci0/identity_resolving_keys
> > > > $ bluetoothctl connect F1:85:91:79:73:70
> > > > Attempting to connect to F1:85:91:79:73:70
> > > > Failed to connect: org.bluez.Error.Failed
> > > > 
> > > > and ran another btmon session to see this, it is attached.
> > > 
> > > this is confusing and makes no sense :(
> > > 
> > > What is the content of debug/bluetooth/hci0/whitelist and
> > 
> > # cat white_list
> > f1:85:91:79:73:70 (type 1)
> > 
> > > debug/bluetooth/hci0/device_list?
> > 
> > # cat device_list
> > 2c:41:a1:4d:f2:2c (type 0)
> > f1:85:91:79:73:70 (type 1) 3
> > 
> > > The only way I can explain this is that somehow the whitelist filter doesn’t
> > > get programmed correctly and thus the scan will not find your device. Why
> > > this points to use_ll_privacy() is totally unclear to me.
> > > 
> > > Btw. reboots won’t help since bluetoothd will restore from settings. You
> > > need to go into the files in /var/lib/bluetooth/ and look for an entry of
> > > IdentityResolvingKey for your device and remove it and then restart
> > > bluetoothd.
> > 
> > I see that entry in there, let me remove it...
> > 
> > > You can run btmon and will even show you what bluetoothd loads during start.
> > > 
> > > Can you try to do systemctl stop bluetooth, then start btmon and then
> > > systemctl start bluetooth. It should reprogram the controller and I could
> > > see the complete trace on how it sets up your hardware.
> > 
> > Ok, I remove the entry for IdentityResolvingKey and restarted bluetoothd
> > and now it works on a clean 5.9-rc8!
> > 
> > I'll stop it again and run the monitor and attach it below when it
> > starts back up.
> > 
> > Ah, I did just that, and it did not connect this time.  Attached is the
> > trace.  No IdentityResolvingKey entries anywhere...
> > 
> > > If this really breaks for your, it should have been broken for weeks for
> > > everybody. So this is the part that is confusing to me. And my original
> > > suspicion turned out to be wrong.
> > 
> > Some bluetoothd interaction?
> 
> Ok, rebooting to 5.9-rc8 again, all works fine.  Restarting bluetoothd a
> few times, and then it stops working on the 2nd restart.
> 
> Logging out of GNOME and then back in, it's working again.
> 
> Ugh.  Don't know what to say now, but 5.9-rc8 is working for me.  I
> guess.  Watch out for this with users when 5.9 is released if they end
> up with the same problem.
> 
> Let me do a jump back to 5.8 and then to 5.9 and see if that changes
> anything...

And in 5.8.14 the "restart bluetoothd a bunch of times causes problems"
is the same thing here, and logging out and then back into GNOME solves
it.

So that's not 5.9-rc specific.

Anything else you want me to try?

thanks,

greg k-h
