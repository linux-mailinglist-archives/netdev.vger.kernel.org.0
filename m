Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84D4850BB4
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729359AbfFXNTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:19:01 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:36841 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729059AbfFXNTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:19:01 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hfOrd-0002bh-O4; Mon, 24 Jun 2019 15:18:29 +0200
Date:   Mon, 24 Jun 2019 15:18:28 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Dmitry Vyukov <dvyukov@google.com>
cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzbot+c4521ac872a4ccc3afec@syzkaller.appspotmail.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        amritha.nambiar@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ido Schimmel <idosch@mellanox.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        tyhicks@canonical.com, wanghai26@huawei.com, yuehaibing@huawei.com
Subject: Re: WARNING: ODEBUG bug in netdev_freemem (2)
In-Reply-To: <CACT4Y+bk1h+CFVdbbKau490Wjis8zt_ia8gVctGZ+bs=7qPk=Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1906241433020.32342@nanos.tec.linutronix.de>
References: <000000000000d6a8ba058c0df076@google.com> <alpine.DEB.2.21.1906241130100.32342@nanos.tec.linutronix.de> <CACT4Y+Y_TadXGE_CVFa4fKqrbpAD4i5WGem9StgoyP_YAVraXw@mail.gmail.com> <da83da44-0088-3056-6bba-d028b6cbb218@gmail.com>
 <CACT4Y+bk1h+CFVdbbKau490Wjis8zt_ia8gVctGZ+bs=7qPk=Q@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jun 2019, Dmitry Vyukov wrote:
> On Mon, Jun 24, 2019 at 2:08 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > >>> ------------[ cut here ]------------
> > >>> ODEBUG: free active (active state 0) object type: timer_list hint:
> > >>> delayed_work_timer_fn+0x0/0x90 arch/x86/include/asm/paravirt.h:767
> > >>
> > >> One of the cleaned up devices has left an active timer which belongs to a
> > >> delayed work. That's all I can decode out of that splat. :(
> > >
> > > Hi Thomas,
> > >
> > > If ODEBUG would memorize full stack traces for object allocation
> > > (using lib/stackdepot.c), it would make this splat actionable, right?
> > > I've fixed https://bugzilla.kernel.org/show_bug.cgi?id=203969 for this.
> > >
> >
> > Not sure this would help in this case as some netdev are allocated through a generic helper.
> >
> > The driver specific portion might not show up in the stack trace.
> >
> > It would be nice here to get the work queue function pointer,
> > so that it gives us a clue which driver needs a fix.

Hrm. Let me think about a way to achieve that after I handled that
regression which is on my desk.

> I see. But isn't the workqueue callback is cleanup_net in this case
> and is in the stack?
> 
>   cleanup_net+0x3fb/0x960 net/core/net_namespace.c:553
>   process_one_work+0x989/0x1790 kernel/workqueue.c:2269

That's the work which does the cleanup, but I doubt that this is part of
the offending net_device.

Thanks,

	tglx



