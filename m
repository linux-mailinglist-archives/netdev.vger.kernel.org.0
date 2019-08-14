Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7BC18D071
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 12:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfHNKQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 06:16:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:48034 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725828AbfHNKQK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 06:16:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F1704AC8C;
        Wed, 14 Aug 2019 10:16:08 +0000 (UTC)
Message-ID: <1565777764.25764.4.camel@suse.com>
Subject: Re: KMSAN: uninit-value in smsc75xx_bind
From:   Oliver Neukum <oneukum@suse.com>
To:     Andrey Konovalov <andreyknvl@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexander Potapenko <glider@google.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        steve.glendinning@shawell.net,
        syzbot <syzbot+6966546b78d050bb0b5d@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Date:   Wed, 14 Aug 2019 12:16:04 +0200
In-Reply-To: <CAAeHK+zzj_+Qvm217KO2OHnfBMWbepP0Y-OYTWpOw3ghe5ji=g@mail.gmail.com>
References: <0000000000009f4316058fab3bd7@google.com>
         <1565700220.7043.8.camel@suse.com>
         <CAAeHK+zzj_+Qvm217KO2OHnfBMWbepP0Y-OYTWpOw3ghe5ji=g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Dienstag, den 13.08.2019, 17:08 +0200 schrieb Andrey Konovalov:
> On Tue, Aug 13, 2019 at 2:43 PM Oliver Neukum <oneukum@suse.com> wrote:
> > 
> > 
> > Hi,
> > 
> > this looks like a false positive to me.
> > The offending code is likely this:
> > 
> >         if (size) {
> >                 buf = kmalloc(size, GFP_KERNEL);
> >                 if (!buf)
> >                         goto out;
> >         }
> > 
> >         err = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
> >                               cmd, reqtype, value, index, buf, size,
> >                               USB_CTRL_GET_TIMEOUT);
> > 
> > which uses 'buf' uninitialized. But it is used for input.
> > What is happening here?
> 
> AFAICS, the uninitialized use of buf that KMSAN points out is in the
> "if (buf & PMT_CTL_DEV_RDY)"  statement in smsc75xx_wait_ready(). Does
> __smsc75xx_read_reg/usb_control_msg() always initialize buf? Can it
> just initialize the first few bytes for example?
> 

Hi,

you are unfortunately right and this is not the only driver vulnerable
in this way. I am going through them.

	Regards
		Oliver

