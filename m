Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2C951587E
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 00:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381574AbiD2WjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 18:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244398AbiD2WjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 18:39:15 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746B3986C8;
        Fri, 29 Apr 2022 15:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KYNDBRYGzikXjzeP27ZJ4t/kgY9V1S1pNOCPI8BnGe8=; b=JT0K6BBCWKsaQymCLnJQaj/kvq
        7Y1QKfar8fCW1mBanEmBmavL+D5scKDYAiv+Of/1HRFoX5MBCl5YZC28TmWOdUUkF79M5XuV0xuXA
        v1gbxygEk8ExNgZKIAJmst62yXS49qdhdclQ0HpxXcHSkInmueEoQ8sxt8GK1dgkp3lrFANactIr6
        owme4UXa4bPRXwJl27nOJHEpmMOv8h6kOal3gO6YkUDEDSWCgod9VcuYizHGTaTCXAhQFrHVOF1Fo
        gyvc6I1Xl1Nz4QEoDGGy6DcOx8hQdBZ3SL8vuhOA2s2+e+h8l4Dvo0+AMgZTV5lbKle4rwJcb9Bd/
        P9qftm1A==;
Received: from [179.113.53.197] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1nkZD8-0003TG-7D; Sat, 30 Apr 2022 00:35:38 +0200
Message-ID: <2787b476-6366-1c83-db80-0393da417497@igalia.com>
Date:   Fri, 29 Apr 2022 19:35:09 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 16/30] drivers/hv/vmbus, video/hyperv_fb: Untangle and
 refactor Hyper-V panic notifiers
Content-Language: en-US
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "bhe@redhat.com" <bhe@redhat.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "openipmi-developer@lists.sourceforge.net" 
        <openipmi-developer@lists.sourceforge.net>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kernel-dev@igalia.com" <kernel-dev@igalia.com>,
        "kernel@gpiccoli.net" <kernel@gpiccoli.net>,
        "halves@canonical.com" <halves@canonical.com>,
        "fabiomirmar@gmail.com" <fabiomirmar@gmail.com>,
        "alejandro.j.jimenez@oracle.com" <alejandro.j.jimenez@oracle.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "bp@alien8.de" <bp@alien8.de>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "d.hatayama@jp.fujitsu.com" <d.hatayama@jp.fujitsu.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "dyoung@redhat.com" <dyoung@redhat.com>,
        "feng.tang@intel.com" <feng.tang@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hidehiro.kawai.ez@hitachi.com" <hidehiro.kawai.ez@hitachi.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "john.ogness@linutronix.de" <john.ogness@linutronix.de>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        vkuznets <vkuznets@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        Andrea Parri <parri.andrea@gmail.com>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-17-gpiccoli@igalia.com>
 <PH0PR21MB30250C9246FFF36AFB1DFDECD7FC9@PH0PR21MB3025.namprd21.prod.outlook.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <PH0PR21MB30250C9246FFF36AFB1DFDECD7FC9@PH0PR21MB3025.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael, first of all thanks for the great review, much appreciated.
Some comments inline below:

On 29/04/2022 14:16, Michael Kelley (LINUX) wrote:
> [...]
>> hypervisor I/O completion), so we postpone that to run late. But more
>> relevant: this *same* vmbus unloading happens in the crash_shutdown()
>> handler, so if kdump is set, we can safely skip this panic notifier and
>> defer such clean-up to the kexec crash handler.
> 
> While the last sentence is true for Hyper-V on x86/x64, it's not true for
> Hyper-V on ARM64.  x86/x64 has the 'machine_ops' data structure
> with the ability to provide a custom crash_shutdown() function, which
> Hyper-V does in the form of hv_machine_crash_shutdown().  But ARM64
> has no mechanism to provide such a custom function that will eventually
> do the needed vmbus_initiate_unload() before running kdump.
> 
> I'm not immediately sure what the best solution is for ARM64.  At this
> point, I'm just pointing out the problem and will think about the tradeoffs
> for various possible solutions.  Please do the same yourself. :-)
> 

Oh, you're totally right! I just assumed ARM64 would the the same, my
bad. Just to propose some alternatives, so you/others can also discuss
here and we can reach a consensus about the trade-offs:

(a) We could forget about this change, and always do the clean-up here,
not relying in machine_crash_shutdown().
Pro: really simple, behaves the same as it is doing currently.
Con: less elegant/concise, doesn't allow arm64 customization.

(b) Add a way to allow ARM64 customization of shutdown crash handler.
Pro: matches x86, more customizable, improves arm64 arch code.
Con: A tad more complex.

Also, a question that came-up: if ARM64 has no way of calling special
crash shutdown handler, how can you execute hv_stimer_cleanup() and
hv_synic_disable_regs() there? Or are they not required in ARM64?


>>
>> (c) There is also a Hyper-V framebuffer panic notifier, which relies in
>> doing a vmbus operation that demands a valid connection. So, we must
>> order this notifier with the panic notifier from vmbus_drv.c, in order to
>> guarantee that the framebuffer code executes before the vmbus connection
>> is unloaded.
> 
> Patch 21 of this set puts the Hyper-V FB panic notifier on the pre_reboot
> notifier list, which means it won't execute before the VMbus connection
> unload in the case of kdump.   This notifier is making sure that Hyper-V
> is notified about the last updates made to the frame buffer before the
> panic, so maybe it needs to be put on the hypervisor notifier list.  It
> sends a message to Hyper-V over its existing VMbus channel, but it
> does not wait for a reply.  It does, however, obtain a spin lock on the
> ring buffer used to communicate with Hyper-V.   Unless someone has
> a better suggestion, I'm inclined to take the risk of blocking on that
> spin lock.

The logic behind that was: when kdump is set, we'd skip the vmbus
disconnect on notifiers, deferring that to crash_shutdown(), logic this
one refuted in the above discussion on ARM64 (one more Pro argument to
the idea of refactoring aarch64 code to allow a custom crash shutdown
handler heh). But you're right, for the default level 2, we skip the
pre_reboot notifiers on kdump, effectively skipping this notifier.

Some ideas of what we can do here:

I) we could change the framebuffer notifier to rely on trylocks, instead
of risking a lockup scenario, and with that, we can execute it before
the vmbus disconnect in the hypervisor list;

II) we ignore the hypervisor notifier in case of kdump _by default_, and
if the users don't want that, they can always set the panic notifier
level to 4 and run all notifiers prior to kdump; would that be terrible
you think? Kdump users might don't care about the framebuffer...

III) we go with approach (b) above and refactor arm64 code to allow the
custom crash handler on kdump time, then [with point (I) above] the
logic proposed in this series is still valid - seems more and more the
most correct/complete solution.

In any case, I guess we should avoid workarounds if possible and do the
things the best way we can, to encompass all (or almost all) the
possible scenarios and don't force things on users (like enforcing panic
notifier level 4 for Hyper-V or something like this...)

More feedback from you / Hyper-V folks is pretty welcome about this.


> 
>> [...]
> The "Fixes:" tags imply that these changes should be backported to older
> longterm kernel versions, which I don't think is the case.  There is a
> dependency on Patch 14 of your series where PANIC_NOTIFIER is
> introduced.
> 

Oh, this was more related with archeology of the kernel. When I'm
investigating stuff, I really want to understand why code was added and
that usually require some time git blaming stuff, so having that pronto
in the commit message is a bonus.

But of course we don't need to use the Fixes tag for that, easy to only
mention it in the text. A secondary benefit by using this tag is to
indicate this is a _real fix_ to some code, and not an improvement, but
as you say, I agree we shouldn't backport it to previous releases having
or not the Fixes tag (AFAIK it's not mandatory to backport stuff with
Fixes tag).


>> [...]
>> + * intrincated is the relation of this notifier with Hyper-V framebuffer
> 
> s/intrincated/intricate/

Thanks, fixed in V2!


>
>> [...]
>> +static int hv_panic_vmbus_unload(struct notifier_block *nb, unsigned long val,
>>  			      void *args)
>> +{
>> +	if (!kexec_crash_loaded())
> 
> I'm not clear on the purpose of this condition.  I think it means
> we will skip the vmbus_initiate_unload() if a panic occurs in the
> kdump kernel.  Is there a reason a panic in the kdump kernel
> should be treated differently?  Or am I misunderstanding?

This is really related with the point discussed in the top of this
response - I assumed both ARM64/x86_64 would behave the same and
disconnect the vmbus through the custom crash handler when kdump is set,
so worth skipping it here in the notifier. But that's not true for ARM64
as you pointed, so this guard against kexec is really part of the
decision/discussion on what to do with ARM64 heh

Cheers!
