Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F115324C1
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 10:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235566AbiEXIBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 04:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235701AbiEXIBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 04:01:18 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE5FDEA0;
        Tue, 24 May 2022 01:01:15 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 15E5D1F8A8;
        Tue, 24 May 2022 08:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653379274; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YfQDkbqSOT+1qjQjuAj/jCMAhUotd54M/3ml94s/xOo=;
        b=PgXddxLSPksORjL/S6Twz65MXnqRLkhNWsZMkeMCJl5txCWJEZdmdegZfTAX/9coTEEbNM
        8MuciDtA/meSONuDDeUgJuaMT6sJm3SP6OoP4PPs2H8u+yjTfPOAegS/VmQ3g6ca5OFCQB
        kRtlLyoJ6CAvfuEa9KvE4DbHA1Jh8JI=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 8ADCF2C141;
        Tue, 24 May 2022 08:01:12 +0000 (UTC)
Date:   Tue, 24 May 2022 10:01:12 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     Baoquan He <bhe@redhat.com>,
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
Message-ID: <YoyQyHHfhIIXSX0U@alley>
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
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 2022-05-20 08:23:33, Guilherme G. Piccoli wrote:
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
> 
> The thing is: with the notifiers' split, we tried to keep only the most
> relevant/necessary stuff in this first list, things that ultimately
> should improve kdump reliability or if not, at least not break it. My
> feeling is that, with this series, we should change the idea/concept
> that kdump must run first nevertheless, not matter what. We're here
> trying to accommodate the antagonistic goals of hypervisors that need
> some clean-up (even for kdump to work) VS. kdump users, that wish a
> "pristine" system reboot ASAP after the crash.

Good question. I wonder if Baoquan knows about problems caused by the
particular notifiers that will end up in the hypervisor list. Note
that there will be some shuffles and the list will be slightly
different in V2.

Anyway, I see four possible solutions:

  1. The most conservative approach is to keep the current behavior
     and call kdump first by default.

  2. A medium conservative approach to change the default default
     behavior and call hypervisor and eventually the info notifiers
     before kdump. There still would be the possibility to call kdump
     first by the command line parameter.

  3. Remove the possibility to call kdump first completely. It would
     assume that all the notifiers in the info list are super safe
     or that they make kdump actually more safe.

  4. Create one more notifier list for operations that always should
     be called before crash_dump.

Regarding the extra notifier list (4th solution). It is not clear to
me whether it would be always called even before hypervisor list or
when kdump is not enabled. We must not over-engineer it.

2nd proposal looks like a good compromise. But maybe we could do
this change few releases later. The notifiers split is a big
change on its own.

Best Regards,
Petr
