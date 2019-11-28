Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4CD110CD7A
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 18:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbfK1RJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 12:09:31 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44325 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfK1RJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 12:09:30 -0500
Received: by mail-lf1-f65.google.com with SMTP id v201so19501840lfa.11;
        Thu, 28 Nov 2019 09:09:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oovU/UoFKB28dFGaRW8Or+9UKUNH0XZBR1OSIIn2e6g=;
        b=hzUYfTjo39TXo9TZKRhA4uQkplsq/Afm5rr8HVeaS00BTHBIAshlEPwFfBySH6GsYa
         RFZ6D2+upr3ft1ORzoRsbZw2pVihdkslv1nzdIkT46e/UkZsVJzSxKT0n/o8fq4D9mkT
         f1EzquKXBwhodH8zCugZdwzqMX9nGrOl4bqpQNIeAQR2swOjQWKmfzrZCmr82Jcdxfrr
         flp8A/5RRndGKm+C+Yu/7LuAGdE78bHZF9ZgHV81sjBaGF1DputFSM9KdcqIEQwOWkvD
         s9NL6ob97ldEwq3V+4QrYZZJPjo1JGpZeOqj14d6TI8OyHIw8eBD5nim5Gox/BK/JFsY
         bdew==
X-Gm-Message-State: APjAAAWcKUf8tgyKeWNmUrw2y4oOXZG5Wmc+MRy7r5cnGGCwDPRhIyzr
        lKk1PNzYr38PtTiBT4/SA5o=
X-Google-Smtp-Source: APXvYqyC2MAIJEY4bDUxVTflyKT8VF64NIE4LP4BJiK3oFmTdYcB2IiwWxfJXkDZd75YflZLAYOIBg==
X-Received: by 2002:a05:6512:71:: with SMTP id i17mr32858350lfo.113.1574960968041;
        Thu, 28 Nov 2019 09:09:28 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id q20sm720796lfm.97.2019.11.28.09.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 09:09:27 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1iaNIF-0006q2-ID; Thu, 28 Nov 2019 18:09:27 +0100
Date:   Thu, 28 Nov 2019 18:09:27 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Andrey Konovalov <andreyknvl@google.com>
Cc:     syzbot <syzbot+7c72edfb407b2bd866ce@syzkaller.appspotmail.com>,
        amitkarwar@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        siva8118@gmail.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: KASAN: invalid-free in rsi_91x_deinit
Message-ID: <20191128170927.GB29518@localhost>
References: <0000000000005ae4cd058731d407@google.com>
 <CAAeHK+wDcQpQhDp2Ajz0GOFqKcqV9E_DSNvZ8UW26BdX+T-Uug@mail.gmail.com>
 <20191128170702.GA29518@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191128170702.GA29518@localhost>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 28, 2019 at 06:07:02PM +0100, Johan Hovold wrote:
> On Tue, Nov 19, 2019 at 02:38:11PM +0100, Andrey Konovalov wrote:
> > On Tue, Apr 23, 2019 at 2:36 PM syzbot
> > <syzbot+7c72edfb407b2bd866ce@syzkaller.appspotmail.com> wrote:
> > >
> > > Hello,
> > >
> > > syzbot found the following crash on:
> > >
> > > HEAD commit:    d34f9519 usb-fuzzer: main usb gadget fuzzer driver
> > > git tree:       https://github.com/google/kasan/tree/usb-fuzzer
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=14a79403200000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=c73d1bb5aeaeae20
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=7c72edfb407b2bd866ce
> > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17547247200000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=147b3a1d200000
> > >
> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > Reported-by: syzbot+7c72edfb407b2bd866ce@syzkaller.appspotmail.com
> > >
> > > usb 1-1: config 252 interface 115 altsetting 0 has 1 endpoint descriptor,
> > > different from the interface descriptor's value: 4
> > > usb 1-1: New USB device found, idVendor=1618, idProduct=9113,
> > > bcdDevice=32.21
> > > usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> > > rsi_91x: rsi_probe: Failed to init usb interface
> > > ==================================================================
> > > BUG: KASAN: double-free or invalid-free in slab_free mm/slub.c:3003 [inline]
> > > BUG: KASAN: double-free or invalid-free in kfree+0xce/0x280 mm/slub.c:3958

> > Most likely the same issue as:
> > 
> > #syz dup: WARNING: ODEBUG bug in rsi_probe
> > 
> > https://syzkaller.appspot.com/bug?extid=1d1597a5aa3679c65b9f
> 
> No, this was separate bug that was fixed by commit 8b51dc729147 ("rsi:
> fix a double free bug in rsi_91x_deinit()").
> 
> Let me try to mark it as such:
> 
> #syz undup

#syz fix: rsi: fix a double free bug in rsi_91x_deinit()

Johan
