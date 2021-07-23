Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACA03D3EE7
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 19:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbhGWQz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:55:29 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:37784 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbhGWQz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 12:55:28 -0400
Received: by mail-pj1-f46.google.com with SMTP id a4-20020a17090aa504b0290176a0d2b67aso1500589pjq.2;
        Fri, 23 Jul 2021 10:36:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iWj+UiJlctAcr7NRJfbxKaLRnJxPvdLf6JLcPvykEvo=;
        b=Ref6rsWenw2i3oxFdxNQk9dLJ/5LGKGh+S4lrJXeRhoaCGBo42+rCAMszGYwB3Y5c6
         hnVIvOO8UR7BnwrynQGF948Lb40dHAWtnLc8CCIHVzw+sVNVi0G+fajDrxIJ+zmesRPZ
         VIOIFdSahgfuzQBv2noqK753uv5MTX6DEwbNOTW1LGzZ0y7NCTBPFOAzSioHau12fJs4
         xswWNgiikTVQYsikMD3bjZIzFmKWBKwhzmT0y9mV62EssvQ+TeBJsaaELmgKlv0YTel4
         LfX6yHISaeUEQgqE1YaUtue/2wdllyXWQJmsjj6Q5376KZZWE80Isr12zW/gzLoJxWow
         lfAA==
X-Gm-Message-State: AOAM533+LmTZJiahnsogZjBihfptYgqruGODhz8aCNe6QQ8oEk6NRJaa
        2+dVosbfaTNs49Oj5PCeSD8=
X-Google-Smtp-Source: ABdhPJxYoJmhzT8pKpe2fdHABoA6MrXAk7kHnpYcCjltHOiWPuLGY7lMMQ720SqX7mQxRKtcnwH21g==
X-Received: by 2002:a17:902:c941:b029:12b:27b:a7b0 with SMTP id i1-20020a170902c941b029012b027ba7b0mr4528705pla.10.1627061761364;
        Fri, 23 Jul 2021 10:36:01 -0700 (PDT)
Received: from garbanzo ([191.96.121.239])
        by smtp.gmail.com with ESMTPSA id a13sm36007774pfl.92.2021.07.23.10.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 10:36:00 -0700 (PDT)
Date:   Fri, 23 Jul 2021 10:35:56 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
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
Message-ID: <20210723173556.2t3pgt27xb5lpk35@garbanzo>
References: <20210623215007.862787-1-mcgrof@kernel.org>
 <YNRnzxTabyoToKKJ@kroah.com>
 <20210625215558.xn4a24ts26bdyfzo@garbanzo>
 <20210701224816.pkzeyo4uqu3kbqdo@garbanzo>
 <YPgFVRAMQ9hN3dnB@kroah.com>
 <20210722213137.jegpykf2ddwmmck5@garbanzo>
 <YPqkgqxXQI1qYaxv@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPqkgqxXQI1qYaxv@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 01:14:10PM +0200, Greg KH wrote:
> On Thu, Jul 22, 2021 at 02:31:37PM -0700, Luis Chamberlain wrote:
> > On Wed, Jul 21, 2021 at 01:30:29PM +0200, Greg KH wrote:
> > > On Thu, Jul 01, 2021 at 03:48:16PM -0700, Luis Chamberlain wrote:
> > > > On Fri, Jun 25, 2021 at 02:56:03PM -0700, Luis Chamberlain wrote:
> > > > > On Thu, Jun 24, 2021 at 01:09:03PM +0200, Greg KH wrote:
> > > > > > thanks for making this change and sticking with it!
> > > > > > 
> > > > > > Oh, and with this change, does your modprobe/rmmod crazy test now work?
> > > > > 
> > > > > It does but I wrote a test_syfs driver and I believe I see an issue with
> > > > > this. I'll debug a bit more and see what it was, and I'll then also use
> > > > > the driver to demo the issue more clearly, and then verification can be
> > > > > an easy selftest test.
> > > > 
> > > > OK my conclusion based on a new selftest driver I wrote is we can drop
> > > > this patch safely. The selftest will cover this corner case well now.
> > > > 
> > > > In short: the kernfs active reference will ensure the store operation
> > > > still exists. The kernfs mutex is not enough, but if the driver removes
> > > > the operation prior to getting the active reference, the write will just
> > > > fail. The deferencing inside of the sysfs operation is abstract to
> > > > kernfs, and while kernfs can't do anything to prevent a driver from
> > > > doing something stupid, it at least can ensure an open file ensure the
> > > > op is not removed until the operation completes.
> > > 
> > > Ok, so all is good?
> > 
> > It would seem to be the case.
> > 
> > > Then why is your zram test code blowing up so badly?
> > 
> > I checked the logs for the backtrace where the crash did happen
> > and we did see clear evidence of the race we feared here. The *first*
> > bug that happened was the CPU hotplug race:
> > 
> > [132004.787099] Error: Removing state 61 which has instances left.
> > [132004.787124] WARNING: CPU: 17 PID: 9307 at ../kernel/cpu.c:1879 __cpuhp_remove_state_cpuslocked+0x1c4/0x1d0
> 
> I do not understand what this issue is, is it fixed?

My first patch for zram fixes the CPU multistate mis-use. And after that
patch is applied triggering the other race does not happen.  It is why I
decided to write a selftest driver, so that we can have a way to do all
sorts of crazy races in a self contained driver example.

> Why is a cpu being hot unplugged at the same time a zram?

That's not what is happening. The description of the issue with zram's
misuse of CPU multistate is described clearly in my commit log for the
fix for that driver. You can refer to that commit log description.

  Luis
