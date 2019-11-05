Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB953F018E
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 16:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389836AbfKEPfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 10:35:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389359AbfKEPfX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 10:35:23 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73B4B2087E;
        Tue,  5 Nov 2019 15:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572968122;
        bh=Cbfu3/n7gIxvq4upIXJWRu4k+r0dK46FEC6wlFd+xTQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uDGbHOJtbbPko/WrESWxDR7Kk2ZYDJyp8QDmRxfcw7JYrte92PPXyiRCURS9oOoAs
         UD2slh/B6oZatxV50V538Z2qOi1YsHIjESlcOSY5or2DIPEXmiRy04irh/RLAnykpF
         PuGMJ27rcsBKo+4amwx4pUlKieFQMdbBYfQUXnGE=
Date:   Tue, 5 Nov 2019 16:35:16 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexander Potapenko <glider@google.com>
Cc:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.com>,
        syzbot <syzbot+0631d878823ce2411636@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: KMSAN: uninit-value in cdc_ncm_set_dgram_size
Message-ID: <20191105153516.GA2617867@kroah.com>
References: <00000000000013c4c1059625a655@google.com>
 <87ftj32v6y.fsf@miraculix.mork.no>
 <1572952516.2921.6.camel@suse.com>
 <875zjy33z2.fsf@miraculix.mork.no>
 <CAG_fn=XXGX5U9oJ2bJDHCwVcp8M+rGDvFDTt4kWFiyWoqL8vAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG_fn=XXGX5U9oJ2bJDHCwVcp8M+rGDvFDTt4kWFiyWoqL8vAA@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 05, 2019 at 02:55:09PM +0100, Alexander Potapenko wrote:
> + Greg K-H
> On Tue, Nov 5, 2019 at 1:25 PM Bjørn Mork <bjorn@mork.no> wrote:
> >
> > Oliver Neukum <oneukum@suse.com> writes:
> > > Am Montag, den 04.11.2019, 22:22 +0100 schrieb Bjørn Mork:
> > >> This looks like a false positive to me. max_datagram_size is two bytes
> > >> declared as
> > >>
> > >>         __le16 max_datagram_size;
> > >>
> > >> and the code leading up to the access on drivers/net/usb/cdc_ncm.c:587
> > >> is:
> > >>
> > >>         /* read current mtu value from device */
> > >>         err = usbnet_read_cmd(dev, USB_CDC_GET_MAX_DATAGRAM_SIZE,
> > >>                               USB_TYPE_CLASS | USB_DIR_IN | USB_RECIP_INTERFACE,
> > >>                               0, iface_no, &max_datagram_size, 2);
> > >
> > > At this point err can be 1.
> > >
> > >>         if (err < 0) {
> > >>                 dev_dbg(&dev->intf->dev, "GET_MAX_DATAGRAM_SIZE failed\n");
> > >>                 goto out;
> > >>         }
> > >>
> > >>         if (le16_to_cpu(max_datagram_size) == ctx->max_datagram_size)
> > >>
> > >>
> > >>
> > >> AFAICS, there is no way max_datagram_size can be uninitialized here.
> > >> usbnet_read_cmd() either read 2 bytes into it or returned an error,
> > >
> > > No. usbnet_read_cmd() will return the number of bytes transfered up
> > > to the number requested or an error.
> >
> > Ah, OK. So that could be fixed with e.g.
> >
> >   if (err < 2)
> >        goto out;
> It'd better be (err < sizeof(max_datagram_size)), and probably in the
> call to usbnet_read_cmd() as well.
> >
> > Or would it be better to add a strict length checking variant of this
> > API?  There are probably lots of similar cases where we expect a
> > multibyte value and a short read is (or should be) considered an error.
> > I can't imagine any situation where we want a 2, 4, 6 or 8 byte value
> > and expect a flexible length returned.
> This is really a widespread problem on syzbot: a lot of USB devices
> use similar code calling usb_control_msg() to read from the device and
> not checking that the buffer is fully initialized.
> 
> Greg, do you know how often usb_control_msg() is expected to read less
> than |size| bytes? Is it viable to make it return an error if this
> happens?
> Almost nobody is using this function correctly (i.e. checking that it
> has read the whole buffer before accessing it).

It could return less than size if the endpoint size isn't the same as
the message.  I think.  It's been a long time since I've read the USB
spec in that area, but usually if the size is "short" then status should
also be set saying something went wrong, right?  Ah wait, you are
playing the "malicious device" card, I think we always just need to
check the thing :(

sorry,

greg k-h
