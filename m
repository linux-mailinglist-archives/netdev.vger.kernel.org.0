Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30871777ED
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 11:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbfG0JgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 05:36:21 -0400
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:48163 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727885AbfG0JgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 05:36:20 -0400
Received: from xps13 ([83.160.161.190])
        by smtp-cloud9.xs4all.net with ESMTPSA
        id rJ7YhQoAMAffArJ7chatBJ; Sat, 27 Jul 2019 11:36:18 +0200
Message-ID: <fcb8a79e4dab34511e4d7b379afff4736a8aa401.camel@tiscali.nl>
Subject: Re: [PATCH] isdn/gigaset: check endpoint null in gigaset_probe
From:   Paul Bolle <pebolle@tiscali.nl>
To:     Phong Tran <tranmanphong@gmail.com>, isdn@linux-pingi.de,
        gregkh@linuxfoundation.org
Cc:     gigaset307x-common@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+35b1c403a14f5c89eba7@syzkaller.appspotmail.com
Date:   Sat, 27 Jul 2019 11:36:08 +0200
In-Reply-To: <24cd0b70-45e6-ea98-fc8f-b25fbf6e817f@gmail.com>
References: <20190726133528.11063-1-tranmanphong@gmail.com>
         <1876196a0e7fc665f0f50d5e9c0e2641f713e089.camel@tiscali.nl>
         <24cd0b70-45e6-ea98-fc8f-b25fbf6e817f@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfAE4QiX/kIkiNTf4R1QNPlw9skCGmNOdLN44/srRWjC4q2vYh0+a4uiqDbjBFlLlDoRf2FFT805YllaVQQfDn+7dHskDAv1OLsvfmDNDv4PcjUP13bwr
 rLN5daNrS8FpMa+3yz39hclzuvWSe11KbFo95QMST6KoAEga/l4/8A4hxmszyE7Sw8eKquqUPa37jozTylwsT6HzjlGNOoIr/TsTMUviYRlBHdHfshA6ZMSc
 7qQBDB/eS/7COLTm02O1zu9LAna9kIVfa8Mr24m2tyRvwapApf4htVsoF8ieRHCf3Z/5Pt9qWhka60fqnRoiaxqr4ojYM4ytC0JcjPXjRLfNulI65L3Db1d9
 8bBCPYkJ3V9EB0kgbOMW/ONVJe7pG3MShukYsQ6AnKp0I7gOOOWnHs13jtOcLSTwa78Lq8U8UWwsw6WEFqtdIN11g5xBS/uRyc6Z2VQQ7Bl2WyA3yz5NiMdB
 998b/5uhZ0tsNpoL51NuRN9yY0apzmm1b/ZmTA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Phong,

Phong Tran schreef op za 27-07-2019 om 08:56 [+0700]:
> On 7/26/19 9:22 PM, Paul Bolle wrote:
> > Phong Tran schreef op vr 26-07-2019 om 20:35 [+0700]:
> > > diff --git a/drivers/isdn/gigaset/usb-gigaset.c b/drivers/isdn/gigaset/usb-gigaset.c
> > > index 1b9b43659bdf..2e011f3db59e 100644
> > > --- a/drivers/isdn/gigaset/usb-gigaset.c
> > > +++ b/drivers/isdn/gigaset/usb-gigaset.c
> > > @@ -703,6 +703,10 @@ static int gigaset_probe(struct usb_interface *interface,
> > >   	usb_set_intfdata(interface, cs);
> > >   
> > >   	endpoint = &hostif->endpoint[0].desc;
> > > +        if (!endpoint) {
> > > +		dev_err(cs->dev, "Couldn't get control endpoint\n");
> > > +		return -ENODEV;
> > > +	}
> > 
> > When can this happen? Is this one of those bugs that one can only trigger with
> > a specially crafted (evil) usb device?
> > 
> 
> Yes, in my understanding, this only happens with random test of syzbot.

Looking at this again, I note the code is taking the address of a struct
usb_endpoint_descriptor that's stored somewhere in memory. That address can't
be NULL, can it?

So I haven't even looked at the fuzzer's report here, but I don't see how this
patch could help. It only adds dead code. Am I missing something and should I
drink even more coffee this Saturday morning?

> > >   	buffer_size = le16_to_cpu(endpoint->wMaxPacketSize);
> > >   	ucs->bulk_out_size = buffer_size;
> > > @@ -722,6 +726,11 @@ static int gigaset_probe(struct usb_interface *interface,
> > > 
> > Please note that I'm very close to getting cut off from the ISDN network, so
> > the chances of being able to testi this on a live system are getting small.
> > 
> 
> This bug can be invalid now. Do you agree?

It's just that your patch arrived while I was busy doing my last ever test of
the gigaset driver. So please don't expect me to put much time in this report
(see 
https://lwn.net/ml/linux-kernel/20190726220541.28783-1-pebolle%40tiscali.nl/
).

Thanks,


Paul Bolle

