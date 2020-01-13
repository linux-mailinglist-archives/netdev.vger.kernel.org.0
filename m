Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01775139BDE
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 22:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgAMVvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 16:51:12 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34788 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgAMVvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 16:51:11 -0500
Received: by mail-ot1-f65.google.com with SMTP id a15so10514615otf.1;
        Mon, 13 Jan 2020 13:51:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ffKiZp7TgACphMkCDUm1FD5yMgsxVZ6Ff6N1urk4jWc=;
        b=deFlpVMUp8KPg/GoPHcDInQsdO2DE3pW1dltR5BS+dQWI6Zfumqd6IaxGvnF/jQNK1
         JxwTl6yG5pKob2Kpni0NmwZhZMt+1baYy+a2n4sUXoO4h0ODYrNiynQ+AFJJh8y7jFGD
         8rWlRFPMy0k3zS+LbblyK/w2r6Pk7XF7O0QgccnBy/WoJw6fII4AJehYAy3BC1TiR860
         PWn9GpSkBlMQNVDGiS9c+DaGrC35F4w1Ya1GeThKk/NhzvwRpkcGzS/YUhkVfXNkhMTC
         DW7UFg/YXGBuirigcFU1mOPa3KhkHpvT5hOsfmPF+Zj7CYeIpiZTImxe9I5JTzM670Hn
         okKQ==
X-Gm-Message-State: APjAAAWTuT559MLu0l1TK5pr1WjoB5TzR77tzOlIm3Oi+VkeOTL9o1dy
        PFWppNRUgL7xnF6VPL7FSPmBtfG7/gn5HoRrePo=
X-Google-Smtp-Source: APXvYqzboRxdkjdj+vWtBhL4TgciiCHxHfLR6hQIa9NC97Z5QPZwbV5+qGJCzmxQC2fQg0RpLiUiJ5XFNlHcaKaz1Xg=
X-Received: by 2002:a05:6830:4b9:: with SMTP id l25mr15083303otd.266.1578952270976;
 Mon, 13 Jan 2020 13:51:10 -0800 (PST)
MIME-Version: 1.0
References: <20200107234526.GA19034@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200108105011.GY2827@hirez.programming.kicks-ass.net> <20200110153520.GC8214@u40b0340c692b58f6553c.ant.amazon.com>
 <20200113101609.GT2844@hirez.programming.kicks-ass.net> <857b42b2e86b2ae09a23f488daada3b1b2836116.camel@amazon.com>
 <20200113124247.GG2827@hirez.programming.kicks-ass.net>
In-Reply-To: <20200113124247.GG2827@hirez.programming.kicks-ass.net>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 13 Jan 2020 22:50:59 +0100
Message-ID: <CAJZ5v0jv+5aLY3N4wFSitu61o9S8tJWEWGGn1Xyw-P82_TwFdQ@mail.gmail.com>
Subject: Re: [RFC PATCH V2 11/11] x86: tsc: avoid system instability in hibernation
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "Singh, Balbir" <sblbir@amazon.com>,
        "Valentin, Eduardo" <eduval@amazon.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Agarwal, Anchal" <anchalag@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Woodhouse@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com" 
        <Woodhouse@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "jgross@suse.com" <jgross@suse.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "x86@kernel.org" <x86@kernel.org>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Kamata, Munehisa" <kamatam@amazon.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "konrad.wilk@oracle.co" <konrad.wilk@oracle.co>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "fllinden@amaozn.com" <fllinden@amaozn.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 13, 2020 at 1:43 PM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Mon, Jan 13, 2020 at 11:43:18AM +0000, Singh, Balbir wrote:
> > For your original comment, just wanted to clarify the following:
> >
> > 1. After hibernation, the machine can be resumed on a different but compatible
> > host (these are VM images hibernated)
> > 2. This means the clock between host1 and host2 can/will be different
> >
> > In your comments are you making the assumption that the host(s) is/are the
> > same? Just checking the assumptions being made and being on the same page with
> > them.
>
> I would expect this to be the same problem we have as regular suspend,
> after power off the TSC will have been reset, so resume will have to
> somehow bridge that gap. I've no idea if/how it does that.

In general, this is done by timekeeping_resume() and the only special
thing done for the TSC appears to be the tsc_verify_tsc_adjust(true)
call in tsc_resume().

> I remember some BIOSes had crazy TSC ideas for suspend2ram, and we grew
> tsc_restore_sched_clock_state() for it.
>
> Playing crazy games like what you're doing just isn't it though.

Right.
