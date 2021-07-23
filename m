Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067F23D3940
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 13:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbhGWKdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 06:33:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231912AbhGWKdj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 06:33:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F54A60EBC;
        Fri, 23 Jul 2021 11:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627038853;
        bh=UseeaPrqz/YFBbxCMHsqNT553PVjChHK30Ly8GJbOzY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gcm1Bu58yDiqm7o+2RQfbtbjTVUXcnVtaXqR0WK1ItRi8qm6Rg+SLWNqFN7CgV2a/
         Aefq3umIun7VbH9UACMuIL6CA1AGjlJrgZTbyv3Yq0Eygu9ySs+RL7Pqy0ZPfieMiG
         1qqAEQVak1z6BeLmY3reMagLPWlqBJCr6ZecXdno=
Date:   Fri, 23 Jul 2021 13:14:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Tejun Heo <tj@kernel.org>, rafael@kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, andriin@fb.com,
        daniel@iogearbox.net, atenart@kernel.org, alobakin@pm.me,
        weiwan@google.com, ap420073@gmail.com, jeyu@kernel.org,
        ngupta@vflare.org, sergey.senozhatsky.work@gmail.com,
        minchan@kernel.org, axboe@kernel.dk, mbenes@suse.com,
        jpoimboe@redhat.com, tglx@linutronix.de, keescook@chromium.org,
        jikos@kernel.org, rostedt@goodmis.org, peterz@infradead.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] sysfs: fix kobject refcount to address races with
 kobject removal
Message-ID: <YPqkgqxXQI1qYaxv@kroah.com>
References: <20210623215007.862787-1-mcgrof@kernel.org>
 <YNRnzxTabyoToKKJ@kroah.com>
 <20210625215558.xn4a24ts26bdyfzo@garbanzo>
 <20210701224816.pkzeyo4uqu3kbqdo@garbanzo>
 <YPgFVRAMQ9hN3dnB@kroah.com>
 <20210722213137.jegpykf2ddwmmck5@garbanzo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722213137.jegpykf2ddwmmck5@garbanzo>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 02:31:37PM -0700, Luis Chamberlain wrote:
> On Wed, Jul 21, 2021 at 01:30:29PM +0200, Greg KH wrote:
> > On Thu, Jul 01, 2021 at 03:48:16PM -0700, Luis Chamberlain wrote:
> > > On Fri, Jun 25, 2021 at 02:56:03PM -0700, Luis Chamberlain wrote:
> > > > On Thu, Jun 24, 2021 at 01:09:03PM +0200, Greg KH wrote:
> > > > > thanks for making this change and sticking with it!
> > > > > 
> > > > > Oh, and with this change, does your modprobe/rmmod crazy test now work?
> > > > 
> > > > It does but I wrote a test_syfs driver and I believe I see an issue with
> > > > this. I'll debug a bit more and see what it was, and I'll then also use
> > > > the driver to demo the issue more clearly, and then verification can be
> > > > an easy selftest test.
> > > 
> > > OK my conclusion based on a new selftest driver I wrote is we can drop
> > > this patch safely. The selftest will cover this corner case well now.
> > > 
> > > In short: the kernfs active reference will ensure the store operation
> > > still exists. The kernfs mutex is not enough, but if the driver removes
> > > the operation prior to getting the active reference, the write will just
> > > fail. The deferencing inside of the sysfs operation is abstract to
> > > kernfs, and while kernfs can't do anything to prevent a driver from
> > > doing something stupid, it at least can ensure an open file ensure the
> > > op is not removed until the operation completes.
> > 
> > Ok, so all is good?
> 
> It would seem to be the case.
> 
> > Then why is your zram test code blowing up so badly?
> 
> I checked the logs for the backtrace where the crash did happen
> and we did see clear evidence of the race we feared here. The *first*
> bug that happened was the CPU hotplug race:
> 
> [132004.787099] Error: Removing state 61 which has instances left.
> [132004.787124] WARNING: CPU: 17 PID: 9307 at ../kernel/cpu.c:1879 __cpuhp_remove_state_cpuslocked+0x1c4/0x1d0

I do not understand what this issue is, is it fixed?  Why is a cpu being
hot unplugged at the same time a zram?

thanks,

greg k-h
