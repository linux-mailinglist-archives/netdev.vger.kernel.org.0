Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA5713905D
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 12:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbgAMLsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 06:48:20 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:42546 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgAMLsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 06:48:20 -0500
Received: by mail-ot1-f67.google.com with SMTP id 66so8635587otd.9;
        Mon, 13 Jan 2020 03:48:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LxnhZqYlYpH5Vy9lVIo6OhZ32kMjzMITo+VXkeln1fw=;
        b=pgtg9JnHLBwCYyAZ5RFYQGgsl66M/mj7yM4MaFDspS6YKEdB6ROJMmAjIIAEXYkksF
         KzKUHo82O4P/9hmKRMftjCb4Bg13udYWoRS5mI7ymCEb0qYb2lsDeBQ9aJ8c03P6YYu3
         RpWLNKYlDqjUndZh+iMRoeNY3reI9vvAUIlyGZWXv2/dZ88XegVLV2+nIr7XuhSrBLiF
         ATtFSmI6LuVhD2SVTvG9pcezEIeyuJj62e0CIabQLIBbsHYv0TvFCPjTS+bcTY3OqRt5
         zu2UluqGJWQF1SD/cHUMRL91/W2L5V5U0lQnKwRg4sqLYLXhn6jHzMlRP5NmGkJWY3B5
         GQTg==
X-Gm-Message-State: APjAAAUxBfUnWj5LxEpGzaWPJZmSoYX9m1hVevSpYeSTEhxL4qZfH0ho
        tN+Wn8dJGaZVxT2lIoutfhcA2CamCqh4dboRlVE=
X-Google-Smtp-Source: APXvYqw3Qgw3VCVDMPHWyRb4A+fn8GcFRFWgD+RozWxW13+tMz8RTbaH9oz22LVJAtTKMJUr2mfSKOEXlhCa9eU2PHs=
X-Received: by 2002:a05:6830:4b9:: with SMTP id l25mr13198440otd.266.1578916099461;
 Mon, 13 Jan 2020 03:48:19 -0800 (PST)
MIME-Version: 1.0
References: <20200107234526.GA19034@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200108105011.GY2827@hirez.programming.kicks-ass.net> <20200110153520.GC8214@u40b0340c692b58f6553c.ant.amazon.com>
 <20200113101609.GT2844@hirez.programming.kicks-ass.net> <857b42b2e86b2ae09a23f488daada3b1b2836116.camel@amazon.com>
In-Reply-To: <857b42b2e86b2ae09a23f488daada3b1b2836116.camel@amazon.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 13 Jan 2020 12:48:08 +0100
Message-ID: <CAJZ5v0jkaw1jJVahWbvcqcYhcwWLqajm7gchn4L4WOngHJcbUA@mail.gmail.com>
Subject: Re: [RFC PATCH V2 11/11] x86: tsc: avoid system instability in hibernation
To:     "Singh, Balbir" <sblbir@amazon.com>
Cc:     "peterz@infradead.org" <peterz@infradead.org>,
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

On Mon, Jan 13, 2020 at 12:43 PM Singh, Balbir <sblbir@amazon.com> wrote:
>
> On Mon, 2020-01-13 at 11:16 +0100, Peter Zijlstra wrote:
> > On Fri, Jan 10, 2020 at 07:35:20AM -0800, Eduardo Valentin wrote:
> > > Hey Peter,
> > >
> > > On Wed, Jan 08, 2020 at 11:50:11AM +0100, Peter Zijlstra wrote:
> > > > On Tue, Jan 07, 2020 at 11:45:26PM +0000, Anchal Agarwal wrote:
> > > > > From: Eduardo Valentin <eduval@amazon.com>
> > > > >
> > > > > System instability are seen during resume from hibernation when system
> > > > > is under heavy CPU load. This is due to the lack of update of sched
> > > > > clock data, and the scheduler would then think that heavy CPU hog
> > > > > tasks need more time in CPU, causing the system to freeze
> > > > > during the unfreezing of tasks. For example, threaded irqs,
> > > > > and kernel processes servicing network interface may be delayed
> > > > > for several tens of seconds, causing the system to be unreachable.
> > > > > The fix for this situation is to mark the sched clock as unstable
> > > > > as early as possible in the resume path, leaving it unstable
> > > > > for the duration of the resume process. This will force the
> > > > > scheduler to attempt to align the sched clock across CPUs using
> > > > > the delta with time of day, updating sched clock data. In a post
> > > > > hibernation event, we can then mark the sched clock as stable
> > > > > again, avoiding unnecessary syncs with time of day on systems
> > > > > in which TSC is reliable.
> > > >
> > > > This makes no frigging sense what so bloody ever. If the clock is
> > > > stable, we don't care about sched_clock_data. When it is stable you get
> > > > a linear function of the TSC without complicated bits on.
> > > >
> > > > When it is unstable, only then do we care about the sched_clock_data.
> > > >
> > >
> > > Yeah, maybe what is not clear here is that we covering for situation
> > > where clock stability changes over time, e.g. at regular boot clock is
> > > stable, hibernation happens, then restore happens in a non-stable clock.
> >
> > Still confused, who marks the thing unstable? The patch seems to suggest
> > you do yourself, but it is not at all clear why.
> >
> > If TSC really is unstable, then it needs to remain unstable. If the TSC
> > really is stable then there is no point in marking is unstable.
> >
> > Either way something is off, and you're not telling me what.
> >
>
> Hi, Peter
>
> For your original comment, just wanted to clarify the following:
>
> 1. After hibernation, the machine can be resumed on a different but compatible
> host (these are VM images hibernated)
> 2. This means the clock between host1 and host2 can/will be different

So the problem is specific to this particular use case.

I'm not sure why to impose this hack on hibernation in all cases.
