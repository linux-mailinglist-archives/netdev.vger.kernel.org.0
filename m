Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22EF32FE938
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 12:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730622AbhAULsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 06:48:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:43242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728099AbhAULVJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 06:21:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09B32238D7;
        Thu, 21 Jan 2021 11:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611228024;
        bh=oqop0twjqlbSgzrrsCfJFeNbZklQ/9KPE1LoX1/YoI8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ilOnPjMT0dtqbGq6/8vjfoJhInUtRcx2P+52xAUcJnDiGyfpjO7Q6dIgp2GdDqm8u
         I4iKMu4Oxt9xazVOdXqatyB9YSkvnStbCanl98lusfVhrWyaJyCuHT+XAY6modWPvF
         T725MUExgHFOkxjGFgYDXrf7H7bGz/mqfriQBGYs=
Date:   Thu, 21 Jan 2021 12:20:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?utf-8?B?5oWV5Yas5Lqu?= <mudongliangabcd@gmail.com>
Cc:     davem@davemloft.net, helmut.schaa@googlemail.com,
        kvalo@codeaurora.org, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        sgruszka@redhat.com
Subject: Re: [PATCH] rt2x00: reset reg earlier in rt2500usb_register_read
Message-ID: <YAljdQmZVB38NCrp@kroah.com>
References: <20210121092026.3261412-1-mudongliangabcd@gmail.com>
 <YAlORNKQ4y7bzYeZ@kroah.com>
 <CAD-N9QXhD48-6GbpCUYuxPKEbkzGgGTaFKQ8TAaQ93WfD_sT2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD-N9QXhD48-6GbpCUYuxPKEbkzGgGTaFKQ8TAaQ93WfD_sT2A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 06:59:08PM +0800, 慕冬亮 wrote:
> On Thu, Jan 21, 2021 at 5:49 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Jan 21, 2021 at 05:20:26PM +0800, Dongliang Mu wrote:
> > > In the function rt2500usb_register_read(_lock), reg is uninitialized
> > > in some situation. Then KMSAN reports uninit-value at its first memory
> > > access. To fix this issue, add one reg initialization in the function
> > > rt2500usb_register_read and rt2500usb_register_read_lock
> > >
> > > BUG: KMSAN: uninit-value in rt2500usb_init_eeprom rt2500usb.c:1443 [inline]
> > > BUG: KMSAN: uninit-value in rt2500usb_probe_hw+0xb5e/0x22a0 rt2500usb.c:1757
> > > CPU: 0 PID: 3369 Comm: kworker/0:2 Not tainted 5.3.0-rc7+ #0
> > > Hardware name: Google Compute Engine
> > > Workqueue: usb_hub_wq hub_event
> > > Call Trace:
> > >  __dump_stack lib/dump_stack.c:77 [inline]
> > >  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
> > >  kmsan_report+0x162/0x2d0 mm/kmsan/kmsan_report.c:109
> > >  __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:294
> > >  rt2500usb_init_eeprom wireless/ralink/rt2x00/rt2500usb.c:1443 [inline]
> > >  rt2500usb_probe_hw+0xb5e/0x22a0 wireless/ralink/rt2x00/rt2500usb.c:1757
> > >  rt2x00lib_probe_dev+0xba9/0x3260 wireless/ralink/rt2x00/rt2x00dev.c:1427
> > >  rt2x00usb_probe+0x7ae/0xf60 wireless/ralink/rt2x00/rt2x00usb.c:842
> > >  rt2500usb_probe+0x50/0x60 wireless/ralink/rt2x00/rt2500usb.c:1966
> > >  ......
> > >
> > > Local variable description: ----reg.i.i@rt2500usb_probe_hw
> > > Variable was created at:
> > >  rt2500usb_register_read wireless/ralink/rt2x00/rt2500usb.c:51 [inline]
> > >  rt2500usb_init_eeprom wireless/ralink/rt2x00/rt2500usb.c:1440 [inline]
> > >  rt2500usb_probe_hw+0x774/0x22a0 wireless/ralink/rt2x00/rt2500usb.c:1757
> > >  rt2x00lib_probe_dev+0xba9/0x3260 wireless/ralink/rt2x00/rt2x00dev.c:1427
> > >
> > > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > > ---
> > >  drivers/net/wireless/ralink/rt2x00/rt2500usb.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> > > index fce05fc88aaf..f6c93a25b18c 100644
> > > --- a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> > > +++ b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
> > > @@ -48,6 +48,7 @@ static u16 rt2500usb_register_read(struct rt2x00_dev *rt2x00dev,
> > >                                  const unsigned int offset)
> > >  {
> > >       __le16 reg;
> > > +     memset(&reg, 0, sizeof(reg));
> >
> > As was pointed out, just set reg = 0 on the line above please.
> 
> I've sent another patch.
> 
> BTW, I set "--subject-prefix="PATCH v2" in my git-send-mail command.
> But it does not show "v2" in the subject of the new email.

You can set the "v2" in the 'git format-patch' option, right?

thanks,

greg k-h
