Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6F053254D
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 10:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbiEXIcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 04:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiEXIcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 04:32:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4622A5A08B
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 01:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653381131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e85r4r+pHFKTSezhh+x5QBd1PQ0NIYybBUBi1C3eVdc=;
        b=EfR6rtGZkHfbfhh+LVN/UkOZP1fdXnhdnnQHMsOKXRhHOlLL4ND38LXm5MJv4YG4l62Q6Z
        1n49TzPkMdT33MvYc5Kz2EXA8YxBgsCHIkeuhA9WAc+jENyY7QHCgD+RLo8FLAFMeTR3ek
        e2/n1g2asE+fXjqRJTCr9RF7kly+QDc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-303-vwaNLwEVOO-EOkL_6SMekQ-1; Tue, 24 May 2022 04:32:10 -0400
X-MC-Unique: vwaNLwEVOO-EOkL_6SMekQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDAAD3C01D8F;
        Tue, 24 May 2022 08:32:09 +0000 (UTC)
Received: from localhost (ovpn-13-156.pek2.redhat.com [10.72.13.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7602F2026D6A;
        Tue, 24 May 2022 08:32:08 +0000 (UTC)
Date:   Tue, 24 May 2022 16:32:03 +0800
From:   Baoquan He <bhe@redhat.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     Petr Mladek <pmladek@suse.com>,
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
Message-ID: <YoyYAz6jOShsfzbM@MiWiFi-R3L-srv>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-25-gpiccoli@igalia.com>
 <Yn0TnsWVxCcdB2yO@alley>
 <d313eec2-96b6-04e3-35cd-981f103d010e@igalia.com>
 <20220519234502.GA194232@MiWiFi-R3L-srv>
 <ded31ec0-076b-2c5b-0fe6-0c274954821f@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ded31ec0-076b-2c5b-0fe6-0c274954821f@igalia.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/20/22 at 08:23am, Guilherme G. Piccoli wrote:
> On 19/05/2022 20:45, Baoquan He wrote:
> > [...]
> >> I really appreciate the summary skill you have, to convert complex
> >> problems in very clear and concise ideas. Thanks for that, very useful!
> >> I agree with what was summarized above.
> > 
> > I want to say the similar words to Petr's reviewing comment when I went
> > through the patches and traced each reviewing sub-thread to try to
> > catch up. Petr has reivewed this series so carefully and given many
> > comments I want to ack immediately.
> > 
> > I agree with most of the suggestions from Petr to this patch, except of
> > one tiny concern, please see below inline comment.
> 
> Hi Baoquan, thanks! I'm glad you're also reviewing that =)
> 
> 
> > [...]
> > 
> > I like the proposed skeleton of panic() and code style suggested by
> > Petr very much. About panic_prefer_crash_dump which might need be added,
> > I hope it has a default value true. This makes crash_dump execute at
> > first by default just as before, unless people specify
> > panic_prefer_crash_dump=0|n|off to disable it. Otherwise we need add
> > panic_prefer_crash_dump=1 in kernel and in our distros to enable kdump,
> > this is inconsistent with the old behaviour.
> 
> I'd like to understand better why the crash_kexec() must always be the
> first thing in your use case. If we keep that behavior, we'll see all
> sorts of workarounds - see the last patches of this series, Hyper-V and
> PowerPC folks hardcoded "crash_kexec_post_notifiers" in order to force
> execution of their relevant notifiers (like the vmbus disconnect,
> specially in arm64 that has no custom machine_crash_shutdown, or the
> fadump case in ppc). This led to more risk in kdump.

Firstly, kdump is not always the first thing. In any use case, if kdump
kernel is not loaded, it's not the first thing at all. Not to mention
if crash_kexec_post_notifiers is specified.

if kdump kernel is loaded, kdump has been executing firslty, since it
was added into kenrel/panic(); Until 2014, Masa added crash_kexec_post_notifiers
kernel parameter to make panic notifiers be able to execute before kdump
if specified.

	commit dc009d92435f99498cbc579ce76bf28e837e2c14
	Author: Eric W. Biederman <ebiederm@xmission.com>
	Date:   Sat Jun 25 14:57:52 2005 -0700
	
	    [PATCH] kexec: add kexec syscalls
 
	commit f06e5153f4ae2e2f3b0300f0e260e40cb7fefd45
	Author: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
	Date:   Fri Jun 6 14:37:07 2014 -0700
	
	    kernel/panic.c: add "crash_kexec_post_notifiers" option for kdump after panic_notifers

Changing this will cause regression. During these years, nobody ever doubt
kdump should execute firstly if crashkernel is reserved and kdump kernel is
loaded. That's not saying we can't change
this, but need a convincing justification.

Secondly, even with the notifiers' split, we can't guarantee people will
absolutely add notifiers into right list in the future. Letting kdump
execute behind lists by default will put kdump into risk.

For example, you replied to Hatamata saying you have been working with
kdump in the last 3, 4 years, and you have have been working on these
panic notifiers refactoring issue in the recent months. However, in your
refactoring patches of introducing hypervisor/info/pre-reboot, I noticed
you acked the suggestion from Petr that several notifiers need be moved to
correct position. So even you can't make sure these, how can other people
be able to recognize which list should be 100% appropriate when they try
to register one notifier for their sub-component?

At last, I am wondering why fadump matters. I don't know in which case
people wants to load kdump kernel, but expect to trigger crash fadump.
Power people need consider this carefully and makes some change. Fadump
just borrows the crashkernel reservation mechanism. If fadump would rather
take risk to run all panic notifiers, whether fadump really needs them
or not, then execute crash_fadump(), that's powerpc's business.

As for Hyper-V, if it enforces to terminate VMbus connection, no matter
it's kdump or not, why not taking it out of panic notifiers list and
execute it before kdump unconditionally. Below is abstracted from
Michael's words.

https://lore.kernel.org/all/MWHPR21MB15933573F5C81C5250BF6A1CD75E9@MWHPR21MB1593.namprd21.prod.outlook.com/T/#u
=======
I looked at the code again, and should revise my previous comments
somewhat.   The Hyper-V resets that I described indeed must be done
prior to kexec'ing the kdump kernel.   Most such resets are actually
done via __crash_kexec() -> machine_crash_shutdown(), not via the
panic notifier. However, the Hyper-V panic notifier must terminate the
VMbus connection, because that must be done even if kdump is not
being invoked.  See commit 74347a99e73.
=======

> 
> The thing is: with the notifiers' split, we tried to keep only the most
> relevant/necessary stuff in this first list, things that ultimately
> should improve kdump reliability or if not, at least not break it. My
> feeling is that, with this series, we should change the idea/concept
> that kdump must run first nevertheless, not matter what. We're here
> trying to accommodate the antagonistic goals of hypervisors that need
> some clean-up (even for kdump to work) VS. kdump users, that wish a
> "pristine" system reboot ASAP after the crash.
> 
> Cheers,
> 
> 
> Guilherme
> 

