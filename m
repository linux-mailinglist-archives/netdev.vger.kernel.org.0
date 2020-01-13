Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1792138EDB
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 11:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgAMKQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 05:16:59 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51688 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgAMKQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 05:16:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TC8ktWymGRn+4RZ97AzmjSGIJ8ZQa/9bHdinVyx7ycg=; b=m9fa8+qyDpqOPF1lzJst9rx9Z
        tLwFtzUYhZGUGuR8ylDqhtV0deAG3/4U4pZ4AgRJFA6lwRXtlybu3cu/hdvzKNW/ASZqVK5bjR9d2
        dB7XKvGOnyW9pv/Y67GknqAc/nAWs4VILGEjXA7jXTMncEPOiTq6TypYHXj0QgKaIqi5fgFex9yJZ
        IvASIqOaazC2uF2dvArIiRK7ES6Kl+7TVLWEUsK0tXjYges7EwbOU342OUtpqfS9A/c/m7rVWvxz4
        eRT8VrqFpVq1r16TFS5UDVLUq8CAImRAiIt3vS+XPW6sqx8WuRLBIaIAqn0xz+Gg717mt5YWuj7XU
        NlJYa7ilg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iqwlY-0002xH-Vd; Mon, 13 Jan 2020 10:16:13 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 0C901304121;
        Mon, 13 Jan 2020 11:14:34 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4D3C02B616422; Mon, 13 Jan 2020 11:16:09 +0100 (CET)
Date:   Mon, 13 Jan 2020 11:16:09 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Eduardo Valentin <eduval@amazon.com>
Cc:     Anchal Agarwal <anchalag@amazon.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org, kamatam@amazon.com,
        sstabellini@kernel.org, konrad.wilk@oracle.co,
        roger.pau@citrix.com, axboe@kernel.dk, davem@davemloft.net,
        rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz,
        sblbir@amazon.com, xen-devel@lists.xenproject.org,
        vkuznets@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Woodhouse@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com,
        dwmw@amazon.co.uk, fllinden@amaozn.com
Subject: Re: [RFC PATCH V2 11/11] x86: tsc: avoid system instability in
 hibernation
Message-ID: <20200113101609.GT2844@hirez.programming.kicks-ass.net>
References: <20200107234526.GA19034@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200108105011.GY2827@hirez.programming.kicks-ass.net>
 <20200110153520.GC8214@u40b0340c692b58f6553c.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110153520.GC8214@u40b0340c692b58f6553c.ant.amazon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 07:35:20AM -0800, Eduardo Valentin wrote:
> Hey Peter,
> 
> On Wed, Jan 08, 2020 at 11:50:11AM +0100, Peter Zijlstra wrote:
> > On Tue, Jan 07, 2020 at 11:45:26PM +0000, Anchal Agarwal wrote:
> > > From: Eduardo Valentin <eduval@amazon.com>
> > > 
> > > System instability are seen during resume from hibernation when system
> > > is under heavy CPU load. This is due to the lack of update of sched
> > > clock data, and the scheduler would then think that heavy CPU hog
> > > tasks need more time in CPU, causing the system to freeze
> > > during the unfreezing of tasks. For example, threaded irqs,
> > > and kernel processes servicing network interface may be delayed
> > > for several tens of seconds, causing the system to be unreachable.
> > 
> > > The fix for this situation is to mark the sched clock as unstable
> > > as early as possible in the resume path, leaving it unstable
> > > for the duration of the resume process. This will force the
> > > scheduler to attempt to align the sched clock across CPUs using
> > > the delta with time of day, updating sched clock data. In a post
> > > hibernation event, we can then mark the sched clock as stable
> > > again, avoiding unnecessary syncs with time of day on systems
> > > in which TSC is reliable.
> > 
> > This makes no frigging sense what so bloody ever. If the clock is
> > stable, we don't care about sched_clock_data. When it is stable you get
> > a linear function of the TSC without complicated bits on.
> > 
> > When it is unstable, only then do we care about the sched_clock_data.
> > 
> 
> Yeah, maybe what is not clear here is that we covering for situation
> where clock stability changes over time, e.g. at regular boot clock is
> stable, hibernation happens, then restore happens in a non-stable clock.

Still confused, who marks the thing unstable? The patch seems to suggest
you do yourself, but it is not at all clear why.

If TSC really is unstable, then it needs to remain unstable. If the TSC
really is stable then there is no point in marking is unstable.

Either way something is off, and you're not telling me what.

> > > Reviewed-by: Erik Quanstrom <quanstro@amazon.com>
> > > Reviewed-by: Frank van der Linden <fllinden@amazon.com>
> > > Reviewed-by: Balbir Singh <sblbir@amazon.com>
> > > Reviewed-by: Munehisa Kamata <kamatam@amazon.com>
> > > Tested-by: Anchal Agarwal <anchalag@amazon.com>
> > > Signed-off-by: Eduardo Valentin <eduval@amazon.com>
> > > ---
> > 
> > NAK, the code very much relies on never getting marked stable again
> > after it gets set to unstable.
> > 
> 
> Well actually, at the PM_POST_HIBERNATION, we do the check and set stable if
> known to be stable.
> 
> The issue only really happens during the restoration path under scheduling pressure,
> which takes forever to finish, as described in the commit.
> 
> Do you see a better solution for this issue?

I still have no clue what your actual problem is. You say scheduling
goes wobbly because sched_clock_data is stale, but when stable that
doesn't matter.

So what is the actual problem?
