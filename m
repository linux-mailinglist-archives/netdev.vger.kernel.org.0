Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4523B3D2F36
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 23:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbhGVUvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 16:51:09 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:45952 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbhGVUvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 16:51:08 -0400
Received: by mail-pl1-f175.google.com with SMTP id k1so678557plt.12;
        Thu, 22 Jul 2021 14:31:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jSCmUr9GKS/GiaL0TeZUtQcPpIOauEt/0WR4gAi238s=;
        b=XTLh3MGLCpwoGOs6H5tpk5w8xwRHJEwWkPihZ2/E9XM/JBUQ5/O9+CXdh9p2EuS6eS
         vd9Dic1he61mL+SgoWFY0IAjNKSCr6NXrq5ISNuffaIhSjRILuNmXEaZgL2D44NKRWBl
         vp0ThAwF1Qte41cULLxt3onMvS+d6Efk8tAZJQDcgW0hb3tm27FyplZiamDF7JH4zZOZ
         6TpWgFcOKAIFw+w+naNeKUrsxu4FjLt57fQlxBEdoIerBbzyzgvHsS+6kp3pm2olaH0o
         zvMbCA2mTakejSVubmnYNWN+Z/un7bBchMYU+mzzn5hfSuepHY0NZFd9B5HdPr/GFw2c
         BPlQ==
X-Gm-Message-State: AOAM531M+DjrCGvl9K14vFKGPtn5tPc96hBaU3e+FRRxjeRGz8Fi3ccB
        +ukNYQsvwdXE61OFNgc0YWI=
X-Google-Smtp-Source: ABdhPJzQOWglTfCn+Teq0vzARk0FuAMkfuOJCuM3kRI5Cw1TKivoj/8zuXA6h8tp89Fz+pzsWQkRTQ==
X-Received: by 2002:a17:90b:2112:: with SMTP id kz18mr10792001pjb.137.1626989501725;
        Thu, 22 Jul 2021 14:31:41 -0700 (PDT)
Received: from garbanzo ([191.96.121.239])
        by smtp.gmail.com with ESMTPSA id w145sm20649900pfc.39.2021.07.22.14.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 14:31:40 -0700 (PDT)
Date:   Thu, 22 Jul 2021 14:31:37 -0700
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
Message-ID: <20210722213137.jegpykf2ddwmmck5@garbanzo>
References: <20210623215007.862787-1-mcgrof@kernel.org>
 <YNRnzxTabyoToKKJ@kroah.com>
 <20210625215558.xn4a24ts26bdyfzo@garbanzo>
 <20210701224816.pkzeyo4uqu3kbqdo@garbanzo>
 <YPgFVRAMQ9hN3dnB@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPgFVRAMQ9hN3dnB@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 01:30:29PM +0200, Greg KH wrote:
> On Thu, Jul 01, 2021 at 03:48:16PM -0700, Luis Chamberlain wrote:
> > On Fri, Jun 25, 2021 at 02:56:03PM -0700, Luis Chamberlain wrote:
> > > On Thu, Jun 24, 2021 at 01:09:03PM +0200, Greg KH wrote:
> > > > thanks for making this change and sticking with it!
> > > > 
> > > > Oh, and with this change, does your modprobe/rmmod crazy test now work?
> > > 
> > > It does but I wrote a test_syfs driver and I believe I see an issue with
> > > this. I'll debug a bit more and see what it was, and I'll then also use
> > > the driver to demo the issue more clearly, and then verification can be
> > > an easy selftest test.
> > 
> > OK my conclusion based on a new selftest driver I wrote is we can drop
> > this patch safely. The selftest will cover this corner case well now.
> > 
> > In short: the kernfs active reference will ensure the store operation
> > still exists. The kernfs mutex is not enough, but if the driver removes
> > the operation prior to getting the active reference, the write will just
> > fail. The deferencing inside of the sysfs operation is abstract to
> > kernfs, and while kernfs can't do anything to prevent a driver from
> > doing something stupid, it at least can ensure an open file ensure the
> > op is not removed until the operation completes.
> 
> Ok, so all is good?

It would seem to be the case.

> Then why is your zram test code blowing up so badly?

I checked the logs for the backtrace where the crash did happen
and we did see clear evidence of the race we feared here. The *first*
bug that happened was the CPU hotplug race:

[132004.787099] Error: Removing state 61 which has instances left.
[132004.787124] WARNING: CPU: 17 PID: 9307 at ../kernel/cpu.c:1879 __cpuhp_remove_state_cpuslocked+0x1c4/0x1d0

After this the crash happen:

[132005.254022] BUG: Unable to handle kernel instruction fetch
[132005.254049] Faulting instruction address: 0xc0080000004a0c24
[132005.254059] Oops: Kernel access of bad area, sig: 11 [#1]

And that's when the backtrace does come up with race. Given the first
race though, I think we can be skeptical of the rest, specially since
I cannot reproduce with a self bombing selftest.

> Where is the reference counting going wrong?

It's not clear, as the misuse with the CPU multistate could lead
to to us leaking per cpu stuct zcomp instances, leaving these
behind as there is no one to remove them. I can't think of the
relationship of this leak and the crash other then memory pressure.

Because of this and the deadlock which is easily triggerable,
I decided to write a selftest to allow is to more cleanly be
able to reproduce any races we can dream up of.

  Luis
