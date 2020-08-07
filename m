Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCA323E65B
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 05:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgHGDjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 23:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgHGDjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 23:39:31 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5B1C061574
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 20:39:31 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id x6so229103pgx.12
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 20:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y0ailie1Z2aZX0hGoNHFvSyIyfib5gtUns7hszvhL9c=;
        b=KNI1e4P5LhbN9zGvUZ5pFqXnjDXhc/jY0lREITr8bD2VBk1lKTdnycatW362OHbSOe
         +40L/nX7y/qtaGJPKC+cSfsbn1ci385fmu4D9ZgKToTKQaYykWc7if1YgJHyUmnyHfpv
         XHn/zeH3iE+wBtyzoRQcNYPs6LN5W/R3IcR5ykbZIafE8GXSBherfgnHkWHgHbZntnh0
         rSUkp4HZXWAXigsDD5taHaVUoe/PgiLiON/uxejEsh8aFCu2Q2nX7NHN6S7GjEr8pxnG
         2hlp0bKWFFyDSoQ/arl/Tnav1zTcYqZoop/ZJTP17rjlgyQrCAhfA+uZui59tzr83JR0
         5R+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y0ailie1Z2aZX0hGoNHFvSyIyfib5gtUns7hszvhL9c=;
        b=BLQyl/IqAIF44SVjbgnKyQwsXinmonidNGEPgWoHW1ge21CgNIBC3Xc3jW/59wcDhj
         mDFW9/5624abWY35Ltqg4N+U2qTe7M7VXzoPKpmcLBkPq5aJSrgQE3UZskgoOciugZwp
         rNQOwiNTBnCE2PwgflErW629jg5Hlui9GY8SuZ4Id4oswnlPv1gZ0ENWTO8EId83wVlK
         Hn1vvRcJw4nZhz08MzUavXJpZILL3zfU/zfzeUkngQa+kz7zTg9vo/6RD5l0Mgdi2RNs
         5i9JNr5bXfjRFrCJ3P9fMXI6gUr2XDDZ810IOLY9NUsyE7n8iB7HwQb3n13WKHbsHx1k
         qpsw==
X-Gm-Message-State: AOAM531tVeidmbOWgswe3RM23cE52ZukvqnGm6X6B5xBlg7l8T3p0Z33
        m7Kh7voHfR/9W/Ofjpj1y/Ntzw==
X-Google-Smtp-Source: ABdhPJy9RyVathXo7/5e5cKF9lvFIY8TAUFwylfusc3xisvXSIV1I8GgwuOISoeAjnT9QGLwA73ORw==
X-Received: by 2002:a65:47c7:: with SMTP id f7mr9723256pgs.361.1596771571028;
        Thu, 06 Aug 2020 20:39:31 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id gj2sm8499530pjb.21.2020.08.06.20.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 20:39:30 -0700 (PDT)
Date:   Thu, 6 Aug 2020 20:39:22 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: rtnl_trylock() versus SCHED_FIFO lockup
Message-ID: <20200806203922.3d687bf2@hermes.lan>
In-Reply-To: <2a6edf25-b12b-c500-ad33-c0ec9e60cde9@cumulusnetworks.com>
References: <b6eca125-351c-27c5-c34b-08c611ac2511@prevas.dk>
        <20200805163425.6c13ef11@hermes.lan>
        <191e0da8-178f-5f91-3d37-9b7cefb61352@prevas.dk>
        <2a6edf25-b12b-c500-ad33-c0ec9e60cde9@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Aug 2020 12:46:43 +0300
Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:

> On 06/08/2020 12:17, Rasmus Villemoes wrote:
> > On 06/08/2020 01.34, Stephen Hemminger wrote:  
> >> On Wed, 5 Aug 2020 16:25:23 +0200
> >> Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:
> >>  
> >>> Hi,
> >>>
> >>> We're seeing occasional lockups on an embedded board (running an -rt
> >>> kernel), which I believe I've tracked down to the
> >>>
> >>>             if (!rtnl_trylock())
> >>>                     return restart_syscall();
> >>>
> >>> in net/bridge/br_sysfs_br.c. The problem is that some SCHED_FIFO task
> >>> writes a "1" to the /sys/class/net/foo/bridge/flush file, while some
> >>> lower-priority SCHED_FIFO task happens to hold rtnl_lock(). When that
> >>> happens, the higher-priority task is stuck in an eternal ERESTARTNOINTR
> >>> loop, and the lower-priority task never gets runtime and thus cannot
> >>> release the lock.
> >>>
> >>> I've written a script that rather quickly reproduces this both on our
> >>> target and my desktop machine (pinning everything on one CPU to emulate
> >>> the uni-processor board), see below. Also, with this hacky patch  
> >>
> >> There is a reason for the trylock, it works around a priority inversion.  
> > 
> > Can you elaborate? It seems to me that it _causes_ a priority inversion
> > since priority inheritance doesn't have a chance to kick in.
> >   
> >> The real problem is expecting a SCHED_FIFO task to be safe with this
> >> kind of network operation.  
> > 
> > Maybe. But ignoring the SCHED_FIFO/rt-prio stuff, it also seems a bit
> > odd to do what is essentially a busy-loop - yes, the restart_syscall()
> > allows signals to be delivered (including allowing the process to get
> > killed), but in the absence of any signals, the pattern essentially
> > boils down to
> > 
> >   while (!rtnl_trylock())
> >     ;
> > 
> > So even for regular tasks, this seems to needlessly hog the cpu.
> > 
> > I tried this
> > 
> > diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
> > index 0318a69888d4..e40e264f9b16 100644
> > --- a/net/bridge/br_sysfs_br.c
> > +++ b/net/bridge/br_sysfs_br.c
> > @@ -44,8 +44,8 @@ static ssize_t store_bridge_parm(struct device *d,
> >         if (endp == buf)
> >                 return -EINVAL;
> > 
> > -       if (!rtnl_trylock())
> > -               return restart_syscall();
> > +       if (rtnl_lock_interruptible())
> > +               return -ERESTARTNOINTR;
> > 
> >         err = (*set)(br, val);
> >         if (!err)
> > 
> > with the obvious definition of rtnl_lock_interruptible(), and it makes
> > the problem go away. Isn't it better to sleep waiting for the lock (and
> > with -rt, giving proper priority boost) or a signal to arrive rather
> > than busy-looping back and forth between syscall entry point and the
> > trylock()?
> > 
> > I see quite a lot of
> > 
> >     if (mutex_lock_interruptible(...))
> >             return -ERESTARTSYS;
> > 
> > but for the rtnl_mutex, I see the trylock...restart_syscall pattern
> > being used in a couple of places. So there must be something special
> > about the rtnl_mutex?
> > 
> > Thanks,
> > Rasmus
> >   
> 
> Hi Rasmus,
> I haven't tested anything but git history (and some grepping) points to deadlocks when
> sysfs entries are being changed under rtnl.
> For example check: af38f2989572704a846a5577b5ab3b1e2885cbfb and 336ca57c3b4e2b58ea3273e6d978ab3dfa387b4c
> This is a common usage pattern throughout net/, the bridge is not the only case and there are more
> commits which talk about deadlocks.
> Again I haven't verified anything but it seems on device delete (w/ rtnl held) -> sysfs delete
> would wait for current readers, but current readers might be stuck waiting on rtnl and we can deadlock.
> 

I was referring to AB BA lock inversion problems.

Yes the trylock goes back to:

commit af38f2989572704a846a5577b5ab3b1e2885cbfb
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Wed May 13 17:00:41 2009 +0000

    net: Fix bridgeing sysfs handling of rtnl_lock
    
    Holding rtnl_lock when we are unregistering the sysfs files can
    deadlock if we unconditionally take rtnl_lock in a sysfs file.  So fix
    it with the now familiar patter of: rtnl_trylock and syscall_restart()
    
    Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>


The problem is that the unregister of netdevice happens under rtnl and
this unregister path has to remove sysfs and other objects.
So those objects have to have conditional locking.





