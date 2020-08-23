Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA6724ECED
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 12:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgHWK6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 06:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbgHWK5t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 06:57:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FDF92072D;
        Sun, 23 Aug 2020 10:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598180269;
        bh=b2rTg/fR21l4CoWP+SM3cdEWOBguA/lksw8HvdFpxCI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OSYTjTDZLBWGAqgsRCEdTcNPmjxDG9UvSP8PqMzE8uEWC9CuuTsDuEgNYVIjbwRJx
         b1J0+KL+yPmuQJzpS+/lzMzv3fjHNlezGBrOe84wSPv92ks38mXpSffCLRXVtXe1aG
         kADUaA2xl+nl4t41nlxVEwLTBNeqEInWzR8UqYAs=
Date:   Sun, 23 Aug 2020 12:58:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Himadri Pandya <himadrispandya@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        USB list <linux-usb@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: [PATCH] net: usb: Fix uninit-was-stored issue in asix_read_cmd()
Message-ID: <20200823105808.GB87391@kroah.com>
References: <20200823082042.20816-1-himadrispandya@gmail.com>
 <CACT4Y+Y1TpqYowNXj+OTcQwH-7T4n6PtPPa4gDWkV-np5KhKAQ@mail.gmail.com>
 <20200823101924.GA3078429@kroah.com>
 <CACT4Y+YbDODLRFn8M5QcY4CazhpeCaunJnP_udXtAs0rYoASSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+YbDODLRFn8M5QcY4CazhpeCaunJnP_udXtAs0rYoASSg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 23, 2020 at 12:31:03PM +0200, Dmitry Vyukov wrote:
> On Sun, Aug 23, 2020 at 12:19 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Sun, Aug 23, 2020 at 11:26:27AM +0200, Dmitry Vyukov wrote:
> > > On Sun, Aug 23, 2020 at 10:21 AM Himadri Pandya
> > > <himadrispandya@gmail.com> wrote:
> > > >
> > > > Initialize the buffer before passing it to usb_read_cmd() function(s) to
> > > > fix the uninit-was-stored issue in asix_read_cmd().
> > > >
> > > > Fixes: KMSAN: kernel-infoleak in raw_ioctl
> > > > Reported by: syzbot+a7e220df5a81d1ab400e@syzkaller.appspotmail.com
> > > >
> > > > Signed-off-by: Himadri Pandya <himadrispandya@gmail.com>
> > > > ---
> > > >  drivers/net/usb/asix_common.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > >
> > > > diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
> > > > index e39f41efda3e..a67ea1971b78 100644
> > > > --- a/drivers/net/usb/asix_common.c
> > > > +++ b/drivers/net/usb/asix_common.c
> > > > @@ -17,6 +17,8 @@ int asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
> > > >
> > > >         BUG_ON(!dev);
> > > >
> > > > +       memset(data, 0, size);
> > >
> > > Hi Himadri,
> > >
> > > I think the proper fix is to check
> > > usbnet_read_cmd/usbnet_read_cmd_nopm return value instead.
> > > Memsetting data helps to fix the warning at hand, but the device did
> > > not send these 0's and we use them as if the device did send them.
> >
> > But, for broken/abusive devices, that really is the safest thing to do
> > here.  They are returning something that is obviously not correct, so
> > either all callers need to check the size received really is the size
> > they asked for, or we just plod onward with a 0 value like this.  Or we
> > could pick some other value, but that could cause other problems if it
> > is treated as an actual value.
> 
> Do we want callers to do at least some error check (e.g. device did
> not return anything at all, broke, hang)?
> If yes, then with a separate helper function that fails on short
> reads, we can get both benefits at no additional cost. User code will
> say "I want 4 bytes, anything that is not 4 bytes is an error" and
> then 1 error check will do. In fact, it seems that that was the
> intention of whoever wrote this code (they assumed no short reads),
> it's just they did not actually implement that "anything that is not 4
> bytes is an error" part.
> 
> 
> > > Perhaps we need a separate helper function (of a bool flag) that will
> > > fail on incomplete reads. Maybe even in the common USB layer because I
> > > think we've seen this type of bug lots of times and I guess there are
> > > dozens more.
> >
> > It's not always a failure, some devices have protocols that are "I could
> > return up to a max X bytes but could be shorter" types of messages, so
> > it's up to the caller to check that they got what they really asked for.
> 
> Yes, that's why I said _separate_ helper function. There seems to be
> lots of callers that want exactly this -- "I want 4 bytes, anything
> else is an error". With the current API it's harder to do - you need
> additional checks, additional code, maybe even additional variables to
> store the required size. APIs should make correct code easy to write.

I guess I already answered both of these in my previous email...

> > Yes, it's more work to do this checking.  However converting the world
> > over to a "give me an error value if you don't read X number of bytes"
> > function would also be the same amount of work, right?
> 
> Should this go into the common USB layer then?
> It's weird to have such a special convention on the level of a single
> driver. Why are rules for this single driver so special?...

They aren't special at all, so yes, we should be checking for a short
read everywhere.  That would be the "correct" thing to do, I was just
suggesting a "quick fix" here, sorry.

Himadri, want to fix up all callers to properly check the size of the
message recieved before they access it?  That will fix this issue
properly.

thanks,

greg k-h
