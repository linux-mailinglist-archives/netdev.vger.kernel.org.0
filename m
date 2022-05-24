Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5C053275A
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 12:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235901AbiEXKTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 06:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235884AbiEXKTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 06:19:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A94C88A331
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 03:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653387543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5hjdGDxm/5eb7UZfehykEkfZZM041fRa5GaKQ9lwQHI=;
        b=dFZou+p8vkJiHBbQ9iYfjSO1qVTRU/ayTzCYF3x3n0eWy5u8Pc+xvjFgqjKUbIqJmwDCru
        dwfhYFx7I81jY1vqRLm34aYZodbB0KFU2v8mMvu5OAAojeX3V6+qucoa8bIE8JZO/gfKlV
        cIUO82fHB3JU8cQFz9tZ3H+Yf9WTanc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-577-ntR76qRiOoW46ArNNEAfwQ-1; Tue, 24 May 2022 06:19:00 -0400
X-MC-Unique: ntR76qRiOoW46ArNNEAfwQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78A678015BA;
        Tue, 24 May 2022 10:19:00 +0000 (UTC)
Received: from localhost (ovpn-13-156.pek2.redhat.com [10.72.13.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2727240E7F0C;
        Tue, 24 May 2022 10:18:59 +0000 (UTC)
Date:   Tue, 24 May 2022 18:18:55 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        "michael Kelley (LINUX)" <mikelley@microsoft.com>,
        Dave Young <dyoung@redhat.com>, d.hatayama@jp.fujitsu.com,
        akpm@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-um@lists.infradead.org, linux-xtensa@linux-xtensa.org,
        netdev@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        rcu@vger.kernel.org, sparclinux@vger.kernel.org,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        kernel-dev@igalia.com, kernel@gpiccoli.net, halves@canonical.com,
        fabiomirmar@gmail.com, alejandro.j.jimenez@oracle.com,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, bp@alien8.de,
        corbet@lwn.net, dave.hansen@linux.intel.com, feng.tang@intel.com,
        gregkh@linuxfoundation.org, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org
Subject: Re: [PATCH 24/30] panic: Refactor the panic path
Message-ID: <YoyxD3WApHpa/N1n@MiWiFi-R3L-srv>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-25-gpiccoli@igalia.com>
 <Yn0TnsWVxCcdB2yO@alley>
 <d313eec2-96b6-04e3-35cd-981f103d010e@igalia.com>
 <20220519234502.GA194232@MiWiFi-R3L-srv>
 <ded31ec0-076b-2c5b-0fe6-0c274954821f@igalia.com>
 <YoyQyHHfhIIXSX0U@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoyQyHHfhIIXSX0U@alley>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/24/22 at 10:01am, Petr Mladek wrote:
> On Fri 2022-05-20 08:23:33, Guilherme G. Piccoli wrote:
> > On 19/05/2022 20:45, Baoquan He wrote:
> > > [...]
> > >> I really appreciate the summary skill you have, to convert complex
> > >> problems in very clear and concise ideas. Thanks for that, very useful!
> > >> I agree with what was summarized above.
> > > 
> > > I want to say the similar words to Petr's reviewing comment when I went
> > > through the patches and traced each reviewing sub-thread to try to
> > > catch up. Petr has reivewed this series so carefully and given many
> > > comments I want to ack immediately.
> > > 
> > > I agree with most of the suggestions from Petr to this patch, except of
> > > one tiny concern, please see below inline comment.
> > 
> > Hi Baoquan, thanks! I'm glad you're also reviewing that =)
> > 
> > 
> > > [...]
> > > 
> > > I like the proposed skeleton of panic() and code style suggested by
> > > Petr very much. About panic_prefer_crash_dump which might need be added,
> > > I hope it has a default value true. This makes crash_dump execute at
> > > first by default just as before, unless people specify
> > > panic_prefer_crash_dump=0|n|off to disable it. Otherwise we need add
> > > panic_prefer_crash_dump=1 in kernel and in our distros to enable kdump,
> > > this is inconsistent with the old behaviour.
> > 
> > I'd like to understand better why the crash_kexec() must always be the
> > first thing in your use case. If we keep that behavior, we'll see all
> > sorts of workarounds - see the last patches of this series, Hyper-V and
> > PowerPC folks hardcoded "crash_kexec_post_notifiers" in order to force
> > execution of their relevant notifiers (like the vmbus disconnect,
> > specially in arm64 that has no custom machine_crash_shutdown, or the
> > fadump case in ppc). This led to more risk in kdump.
> > 
> > The thing is: with the notifiers' split, we tried to keep only the most
> > relevant/necessary stuff in this first list, things that ultimately
> > should improve kdump reliability or if not, at least not break it. My
> > feeling is that, with this series, we should change the idea/concept
> > that kdump must run first nevertheless, not matter what. We're here
> > trying to accommodate the antagonistic goals of hypervisors that need
> > some clean-up (even for kdump to work) VS. kdump users, that wish a
> > "pristine" system reboot ASAP after the crash.
> 
> Good question. I wonder if Baoquan knows about problems caused by the
> particular notifiers that will end up in the hypervisor list. Note
> that there will be some shuffles and the list will be slightly
> different in V2.

Yes, I knew some of them. Please check my response to Guilherme.

We have bug to track the issue on Hyper-V in which failure happened
during panic notifiers running, haven't come to kdump. Seems both of
us sent mail replying to Guilherme at the same time. 

> 
> Anyway, I see four possible solutions:
> 
>   1. The most conservative approach is to keep the current behavior
>      and call kdump first by default.
> 
>   2. A medium conservative approach to change the default default
>      behavior and call hypervisor and eventually the info notifiers
>      before kdump. There still would be the possibility to call kdump
>      first by the command line parameter.
> 
>   3. Remove the possibility to call kdump first completely. It would
>      assume that all the notifiers in the info list are super safe
>      or that they make kdump actually more safe.
> 
>   4. Create one more notifier list for operations that always should
>      be called before crash_dump.

I would vote for 1 or 4 without any hesitation, and prefer 4. I ever
suggest the variant of solution 4 in v1 reviewing. That's taking those
notifiers out of list and enforcing to execute them before kdump. E.g
the one on HyperV to terminate VMbus connection. Maybe solution 4 is
better to provide a determinate way for people to add necessary code
at the earliest part.

> 
> Regarding the extra notifier list (4th solution). It is not clear to
> me whether it would be always called even before hypervisor list or
> when kdump is not enabled. We must not over-engineer it.

One thing I would like to notice is, no matter how perfect we split the
lists this time, we can't gurantee people will add notifiers reasonablly
in the future. And people from different sub-component may not do
sufficient investigation and add them to fulfil their local purpose.

The current panic notifers list is the best example. Hyper-V actually
wants to run some necessary code before kdump, but not all of them, they
just add it, ignoring the original purpose of
crash_kexec_post_notifiers. I guess they do like this just because it's
easy to do, no need to bother changing code in generic place.

Solution 4 can make this no doubt, that's why I like it better.

> 
> 2nd proposal looks like a good compromise. But maybe we could do
> this change few releases later. The notifiers split is a big
> change on its own.

As I replied to Guilherme, solution 2 will cause regression if not
calling kdump firstly. Solution 3 leaves people space to make mistake,
they could add nontifier into wrong list.

I would like to note again that the panic notifiers are optional to run,
while kdump is expectd once loaded, from the original purpose. I guess
people I know will still have this thought, e.g Hatayama, Masa, they are
truly often use panic notifiers like this on their company's system.

