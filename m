Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEAE752E0BB
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 01:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343724AbiESXpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 19:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343701AbiESXpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 19:45:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DB3DF119041
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 16:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653003911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xcqeqNHBqLaEPFvaMSIdVsHM/2ssgjepqSc89Z+McDY=;
        b=ZdH4nwsrnb55n6ATbu/cGio5L0TUU25mIotUvHfciY688Oma+bZewbMlSy9xearLdN29nN
        MuOlA2j1qeOKj5BJ6Koo/eYlLLv7fPBLYT6uwJ0Kd7ZIVNU3Wuv/S6rsaCYfUCi1TXO/tv
        KeuePE0A/24P+rm5+kkeZgWhCPvPjZA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-wBpG6HUkMsOVqd9lnF2Ofg-1; Thu, 19 May 2022 19:45:08 -0400
X-MC-Unique: wBpG6HUkMsOVqd9lnF2Ofg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A403D3C025CD;
        Thu, 19 May 2022 23:45:07 +0000 (UTC)
Received: from localhost (ovpn-12-42.pek2.redhat.com [10.72.12.42])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4ABA5492C14;
        Thu, 19 May 2022 23:45:06 +0000 (UTC)
Date:   Fri, 20 May 2022 07:45:02 +0800
From:   Baoquan He <bhe@redhat.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Petr Mladek <pmladek@suse.com>
Cc:     "michael Kelley (LINUX)" <mikelley@microsoft.com>,
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
Message-ID: <20220519234502.GA194232@MiWiFi-R3L-srv>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-25-gpiccoli@igalia.com>
 <Yn0TnsWVxCcdB2yO@alley>
 <d313eec2-96b6-04e3-35cd-981f103d010e@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d313eec2-96b6-04e3-35cd-981f103d010e@igalia.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/15/22 at 07:47pm, Guilherme G. Piccoli wrote:
> On 12/05/2022 11:03, Petr Mladek wrote:
...... 
> > OK, the question is how to make it better. Let's start with
> > a clear picture of the problem:
> > 
> > 1. panic() has basically two funtions:
> > 
> >       + show/store debug information (optional ways and amount)
> >       + do something with the system (reboot, stay hanged)
> > 
> > 
> > 2. There are 4 ways how to show/store the information:
> > 
> >       + tell hypervisor to store what it is interested about
> >       + crash_dump
> >       + kmsg_dump()
> >       + consoles
> > 
> >   , where crash_dump and consoles are special:
> > 
> >      + crash_dump does not return. Instead it ends up with reboot.
> > 
> >      + Consoles work transparently. They just need an extra flush
> >        before reboot or staying hanged.
> > 
> > 
> > 3. The various notifiers do things like:
> > 
> >      + tell hypervisor about the crash
> >      + print more information (also stop watchdogs)
> >      + prepare system for reboot (touch some interfaces)
> >      + prepare system for staying hanged (blinking)
> > 
> >    Note that it pretty nicely matches the 4 notifier lists.
> > 
> 
> I really appreciate the summary skill you have, to convert complex
> problems in very clear and concise ideas. Thanks for that, very useful!
> I agree with what was summarized above.

I want to say the similar words to Petr's reviewing comment when I went
through the patches and traced each reviewing sub-thread to try to
catch up. Petr has reivewed this series so carefully and given many
comments I want to ack immediately.

I agree with most of the suggestions from Petr to this patch, except of
one tiny concern, please see below inline comment.

> 
> 
> > Now, we need to decide about the ordering. The main area is how
> > to store the debug information. Consoles are transparent so
> > the quesition is about:
> > 
> >      + hypervisor
> >      + crash_dump
> >      + kmsg_dump
> > 
> > Some people need none and some people want all. There is a
> > risk that system might hung at any stage. This why people want to
> > make the order configurable.
> > 
> > But crash_dump() does not return when it succeeds. And kmsg_dump()
> > users havn't complained about hypervisor problems yet. So, that
> > two variants might be enough:
> > 
> >     + crash_dump (hypervisor, kmsg_dump as fallback)
> >     + hypervisor, kmsg_dump, crash_dump
> > 
> > One option "panic_prefer_crash_dump" should be enough.
> > And the code might look like:
> > 
> > void panic()
> > {
> > [...]
> > 	dump_stack();
> > 	kgdb_panic(buf);
> > 
> > 	< ---  here starts the reworked code --- >
> > 
> > 	/* crash dump is enough when enabled and preferred. */
> > 	if (panic_prefer_crash_dump)
> > 		__crash_kexec(NULL);

I like the proposed skeleton of panic() and code style suggested by
Petr very much. About panic_prefer_crash_dump which might need be added,
I hope it has a default value true. This makes crash_dump execute at
first by default just as before, unless people specify
panic_prefer_crash_dump=0|n|off to disable it. Otherwise we need add
panic_prefer_crash_dump=1 in kernel and in our distros to enable kdump,
this is inconsistent with the old behaviour.

> > 
> > 	/* Stop other CPUs and focus on handling the panic state. */
> > 	if (has_kexec_crash_image)
> > 		crash_smp_send_stop();
> > 	else
> > 		smp_send_stop()
> > 
> 
> Here we have a very important point. Why do we need 2 variants of SMP
> CPU stopping functions? I disagree with that - my understanding of this
> after some study in architectures is that the crash_() variant is
> "stronger", should work in all cases and if not, we should fix that -
> that'd be a bug.
> 
> Such variant either maps to smp_send_stop() (in various architectures,
> including XEN/x86) or overrides the basic function with more proper
> handling for panic() case...I don't see why we still need such
> distinction, if you / others have some insight about that, I'd like to
> hear =)
> 
> 
> > 	/* Notify hypervisor about the system panic. */
> > 	atomic_notifier_call_chain(&panic_hypervisor_list, 0, NULL);
> > 
> > 	/*
> > 	 * No need to risk extra info when there is no kmsg dumper
> > 	 * registered.
> > 	 */
> > 	if (!has_kmsg_dumper())
> > 		__crash_kexec(NULL);
> > 
> > 	/* Add extra info from different subsystems. */
> > 	atomic_notifier_call_chain(&panic_info_list, 0, NULL);
> > 
> > 	kmsg_dump(KMSG_DUMP_PANIC);
> > 	__crash_kexec(NULL);
> > 
> > 	/* Flush console */
> > 	unblank_screen();
> > 	console_unblank();
> > 	debug_locks_off();
> > 	console_flush_on_panic(CONSOLE_FLUSH_PENDING);
> > 
> > 	if (panic_timeout > 0) {
> > 		delay()
> > 	}
> > 
> > 	/*
> > 	 * Prepare system for eventual reboot and allow custom
> > 	 * reboot handling.
> > 	 */
> > 	atomic_notifier_call_chain(&panic_reboot_list, 0, NULL);
> 
> You had the order of panic_reboot_list VS. consoles flushing inverted.
> It might make sense, although I didn't do that in V1...
> Are you OK in having a helper for console flushing, as I did in V1? It
> makes code of panic() a bit less polluted / more focused I feel.
> 
> 
> > 
> > 	if (panic_timeout != 0) {
> > 		reboot();
> > 	}
> > 
> > 	/*
> > 	 * Prepare system for the infinite waiting, for example,
> > 	 * setup blinking.
> > 	 */
> > 	atomic_notifier_call_chain(&panic_loop_list, 0, NULL);
> > 
> > 	infinite_loop();
> > }
> > 
> > 
> > __crash_kexec() is there 3 times but otherwise the code looks
> > quite straight forward.
> > 
> > Note 1: I renamed the two last notifier list. The name 'post-reboot'
> > 	did sound strange from the logical POV ;-)
> > 
> > Note 2: We have to avoid the possibility to call "reboot" list
> > 	before kmsg_dump(). All callbacks providing info
> > 	have to be in the info list. It a callback combines
> > 	info and reboot functionality then it should be split.
> > 
> > 	There must be another way to calm down problematic
> > 	info callbacks. And it has to be solved when such
> > 	a problem is reported. Is there any known issue, please?
> > 
> > It is possible that I have missed something important.
> > But I would really like to make the logic as simple as possible.
> 
> OK, I agree with you! It's indeed simpler and if others agree, I can
> happily change the logic to what you proposed. Although...currently the
> "crash_kexec_post_notifiers" allows to call _all_ panic_reboot_list
> callbacks _before kdump_.
> 
> We need to mention this change in the commit messages, but I really
> would like to hear the opinions of heavy users of notifiers (as
> Michael/Hyper-V) and the kdump interested parties (like Baoquan / Dave
> Young / Hayatama). If we all agree on such approach, will change that
> for V2 =)
> 
> Thanks again Petr, for the time spent in such detailed review!
> Cheers,
> 
> 
> Guilherme
> 

