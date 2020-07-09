Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59CC921984A
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 08:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgGIGMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 02:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726649AbgGIGMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 02:12:05 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B8EC03541E
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 23:12:04 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id k5so390658plk.13
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 23:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X1Ht58e7pYDo3+OXGKFN8q0KvuGq5a6uMZgYYH+au1E=;
        b=hlOuhtl/aHThddrZ1Zq75gvYoKWCyCVF3dPgpKO5VuUU4HX+ZkowOigtFAWcrinqid
         v/NMXtQ14Q0GhYCuUsRiOo/IWfG261BhUjaz6YBYvbtnPKGBUq8JIHdwLoW1Ms/oScNk
         oT9osKbbh7Ip3vrzHYKxCPxuTYWQbad4SsQvw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X1Ht58e7pYDo3+OXGKFN8q0KvuGq5a6uMZgYYH+au1E=;
        b=NLoFQY4hg2dJifmxt6qWD9jyg9LnoCWPttgU31z+/tHS4JVwIXmGNr88pZhIFJOn4Q
         7hsgrlq8oLmEKplk01q6ZA0yamAe66tZIRZ0ZQhSygxYoN6NY/8W6eZCvxc9IFKpIMD4
         Eyoi6/xO/2LvmKkOhqBO9sNRYstpZ/r5kWEL0pP6jatVEesBAtbcKqAT6TeDvKdC+Xmb
         fKiXwT2vvnQjJi/mGmEOLFKeRR9T0ZygxJIYlsLs6GQpS/Tv+fj0kV1xWLB9pWFilWhU
         GsgD3qcRRi15khuufX3T53Ojxm+SFLxeulZo9jIY4kaP9wjDV9b24Ety95hbS2z3sgPa
         vvqQ==
X-Gm-Message-State: AOAM533UWCL3Atip91XiCjW1mbhh1BVEONRSWSWW5JeAEhZGKbIckC2q
        X8hRHFJh2ENFz8fpig2/Lz8Kwg==
X-Google-Smtp-Source: ABdhPJwH/e7s5/I6MewIH9/hgc0PZ3d5rkN3EN0RRGrJQj5XVg8j105Pt7Ryn2fQD7oU1TruCUw/6Q==
X-Received: by 2002:a17:90a:e618:: with SMTP id j24mr12994897pjy.41.1594275124152;
        Wed, 08 Jul 2020 23:12:04 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id z66sm1490399pfb.162.2020.07.08.23.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 23:12:03 -0700 (PDT)
Date:   Wed, 8 Jul 2020 23:12:02 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     linux-kernel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Matt Denton <mpdenton@google.com>,
        Christian Brauner <christian@brauner.io>,
        Tycho Andersen <tycho@tycho.ws>,
        David Laight <David.Laight@ACULAB.COM>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>, Jann Horn <jannh@google.com>,
        Chris Palmer <palmer@google.com>,
        Robert Sesek <rsesek@google.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v6 6/7] seccomp: Introduce addfd ioctl to seccomp user
 notifier
Message-ID: <202007082307.EB5BAD3A0@keescook>
References: <20200706201720.3482959-1-keescook@chromium.org>
 <20200706201720.3482959-7-keescook@chromium.org>
 <20200707133049.nfxc6vz6vcs26m3b@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707133049.nfxc6vz6vcs26m3b@wittgenstein>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 07, 2020 at 03:30:49PM +0200, Christian Brauner wrote:
> Hm, maybe change that description to sm like:
> 
> [...]

Cool, yeah. Thanks! I've tweaked it a little more

> > +	/* 24 is original sizeof(struct seccomp_notif_addfd) */
> > +	if (size < 24 || size >= PAGE_SIZE)
> > +		return -EINVAL;
> 
> Hm, so maybe add the following:
> 
> #define SECCOMP_NOTIFY_ADDFD_VER0 24
> #define SECCOMP_NOTIFY_ADDFD_LATEST SECCOMP_NOTIFY_ADDFD_VER0
> 
> and then place:
> 
> BUILD_BUG_ON(sizeof(struct seccomp_notify_addfd) < SECCOMP_NOTIFY_ADDFD_VER0);
> BUILD_BUG_ON(sizeof(struct open_how) != SECCOMP_NOTIFY_ADDFD_LATEST);

Yes, good idea (BTW, did the EA syscall docs land?)

I've made these SECCOMP_NOTIFY_ADDFD_SIZE_* to match your examples below
(i.e.  I added "SIZE" to what you suggested above).

> somewhere which is what we do for clone3(), openat2() and others to
> catch build-time nonsense.
> 
> include/uapi/linux/perf_event.h:#define PERF_ATTR_SIZE_VER0     64      /* sizeof first published struct */
> include/uapi/linux/sched.h:#define CLONE_ARGS_SIZE_VER0 64 /* sizeof first published struct */
> include/uapi/linux/sched/types.h:#define SCHED_ATTR_SIZE_VER0   48      /* sizeof first published struct */
> include/linux/fcntl.h:#define OPEN_HOW_SIZE_VER0        24 /* sizeof first published struct */
> include/linux/fcntl.h:#define OPEN_HOW_SIZE_LATEST      OPEN_HOW_SIZE_VER0

The ..._SIZE_VER0 and ...LATEST stuff doesn't seem useful to export via
UAPI. Above, 2 of the 3 export to uapi. Is there a specific rationale
for which should and which shouldn't?

> > +#undef EA_IOCTL
> 
> Why is this undefed? :)

It was defined "in" a function, so I like to mimic function visibility.
But you're right; there's no reason to undef it.

-- 
Kees Cook
