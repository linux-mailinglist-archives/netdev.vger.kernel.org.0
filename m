Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6F924ECB5
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 12:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgHWKTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 06:19:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:32968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbgHWKTG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 06:19:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D21762075B;
        Sun, 23 Aug 2020 10:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598177945;
        bh=Ujak7Kc517HcPZ0LyBiz0rIH59QGuYtCtf+7xmhT4G0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0NF1MK1uPeo4chp3b3OeVF3gntArq7804AdQn5p/vFZQPYHLStv4l/ojbpmmEREiM
         LH+z03UqMadgSGfgYxn/yfcAvAGEqN6mPgJfxLRfvE7EFZ5QVByuL3HXW5l/NS58k1
         ELQRH9UOuSkb8chxVn+ppKNIRirtp99toiAZnqmg=
Date:   Sun, 23 Aug 2020 12:19:24 +0200
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
Message-ID: <20200823101924.GA3078429@kroah.com>
References: <20200823082042.20816-1-himadrispandya@gmail.com>
 <CACT4Y+Y1TpqYowNXj+OTcQwH-7T4n6PtPPa4gDWkV-np5KhKAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+Y1TpqYowNXj+OTcQwH-7T4n6PtPPa4gDWkV-np5KhKAQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 23, 2020 at 11:26:27AM +0200, Dmitry Vyukov wrote:
> On Sun, Aug 23, 2020 at 10:21 AM Himadri Pandya
> <himadrispandya@gmail.com> wrote:
> >
> > Initialize the buffer before passing it to usb_read_cmd() function(s) to
> > fix the uninit-was-stored issue in asix_read_cmd().
> >
> > Fixes: KMSAN: kernel-infoleak in raw_ioctl
> > Reported by: syzbot+a7e220df5a81d1ab400e@syzkaller.appspotmail.com
> >
> > Signed-off-by: Himadri Pandya <himadrispandya@gmail.com>
> > ---
> >  drivers/net/usb/asix_common.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
> > index e39f41efda3e..a67ea1971b78 100644
> > --- a/drivers/net/usb/asix_common.c
> > +++ b/drivers/net/usb/asix_common.c
> > @@ -17,6 +17,8 @@ int asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
> >
> >         BUG_ON(!dev);
> >
> > +       memset(data, 0, size);
> 
> Hi Himadri,
> 
> I think the proper fix is to check
> usbnet_read_cmd/usbnet_read_cmd_nopm return value instead.
> Memsetting data helps to fix the warning at hand, but the device did
> not send these 0's and we use them as if the device did send them.

But, for broken/abusive devices, that really is the safest thing to do
here.  They are returning something that is obviously not correct, so
either all callers need to check the size received really is the size
they asked for, or we just plod onward with a 0 value like this.  Or we
could pick some other value, but that could cause other problems if it
is treated as an actual value.

> Perhaps we need a separate helper function (of a bool flag) that will
> fail on incomplete reads. Maybe even in the common USB layer because I
> think we've seen this type of bug lots of times and I guess there are
> dozens more.

It's not always a failure, some devices have protocols that are "I could
return up to a max X bytes but could be shorter" types of messages, so
it's up to the caller to check that they got what they really asked for.

Yes, it's more work to do this checking.  However converting the world
over to a "give me an error value if you don't read X number of bytes"
function would also be the same amount of work, right?

So personally, I think this patch is right for when you are trying to
abuse the USB driver stack :)

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

