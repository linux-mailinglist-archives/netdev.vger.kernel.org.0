Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5EAA535202
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 18:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348074AbiEZQ1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 12:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiEZQ1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 12:27:15 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC484506F8;
        Thu, 26 May 2022 09:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=g5u06r/Xg87j4V8Rg6/UfqgEi7DYXSrP5RmkrTIzh/Q=; b=iCgAR296S3LSbLmOpR3LkrCpsK
        y7YGr6I7yByIEwTjZ2WtYRzzbyBvMDTQTR3zmmZ44zuVyZpeJqajxLL5P1xpJLJTb2dMh5pJztl3L
        0g1AqEeOs5c1YhSNaGywDAZ/a8oRKFkwwQklOk+HDjN8XleGQXFDshk4Tc2fywUvD+bO6YJpDVBxc
        VZ4/e0yO80afyjzEwVVVSVn0AWE9cNQ3TmY2LMY1cD3yxOgLWBpjPGf2UcUw/gYnz7ZNSKeZGhrc7
        DZJCm/pzdYk71lBIOpedohq49XSnuibFm3AYgqR1AYHFLSTcilBkitlJTKPhazpNWpAJ8ROQUyMS/
        zY22U5mQ==;
Received: from 200-161-159-120.dsl.telesp.net.br ([200.161.159.120] helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1nuGJf-002CG3-Fu; Thu, 26 May 2022 18:26:28 +0200
Message-ID: <0d084eed-4781-c815-29c7-ac62c498e216@igalia.com>
Date:   Thu, 26 May 2022 13:25:57 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 24/30] panic: Refactor the panic path
Content-Language: en-US
To:     bhe@redhat.com, d.hatayama@jp.fujitsu.com,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mark Rutland <mark.rutland@arm.com>, mikelley@microsoft.com,
        pmladek@suse.com, vkuznets@redhat.com
Cc:     akpm@linux-foundation.org, kexec@lists.infradead.org,
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
        corbet@lwn.net, dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com, gregkh@linuxfoundation.org,
        hidehiro.kawai.ez@hitachi.com, jgross@suse.com,
        john.ogness@linutronix.de, keescook@chromium.org, luto@kernel.org,
        mhiramat@kernel.org, mingo@redhat.com, paulmck@kernel.org,
        peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, will@kernel.org
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-25-gpiccoli@igalia.com>
 <87fskzuh11.fsf@email.froward.int.ebiederm.org>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <87fskzuh11.fsf@email.froward.int.ebiederm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey folks, first of all thanks a lot for the reviews / opinions about
this. I imagined that such change would be polemic, and I see I was
right heh


I'll try to "mix" all the relevant opinions in a single email, since
they happened in different responses and even different mail threads.

I've looped here the most interested parties based on the feedback
received, such as Baoquan (kdump), Hatayama (kdump), Eric (kexec), Mark
(arm64), Michael (Hyper-V), Petr (console/printk) and Vitaly (hyper-v /
kvm). I hope we can discuss and try to reach some consensus - my
apologies in advance for this long message!

So, here goes some feedback we received about this change and correlated
feedback from arm64 community - my apologies if I missed something
important, I've tried to collect the most relevant portions, while
keeping the summary "as short" as possible. I'll respond to such
feedback below, after the quotes.


On 24/05/2022 05:32, Baoquan He wrote:
>> [...] 
>> Firstly, kdump is not always the first thing. In any use case, if kdump
>> kernel is not loaded, it's not the first thing at all. Not to mention
>> if crash_kexec_post_notifiers is specified.
>> [...]
>> Changing this will cause regression. During these years, nobody ever doubt
>> kdump should execute firstly if crashkernel is reserved and kdump kernel is
>> loaded. That's not saying we can't change
>> this, but need a convincing justification.
>> [...] 
>> Secondly, even with the notifiers' split, we can't guarantee people will
>> absolutely add notifiers into right list in the future. Letting kdump
>> execute behind lists by default will put kdump into risk.
>> [...] 
>> As for Hyper-V, if it enforces to terminate VMbus connection, no matter
>> it's kdump or not, why not taking it out of panic notifiers list and
>> execute it before kdump unconditionally.


On 24/05/2022 05:01, Petr Mladek wrote:
>> [...]
>> Anyway, I see four possible solutions:
>> 
>>   1. The most conservative approach is to keep the current behavior
>>      and call kdump first by default.
>> 
>>   2. A medium conservative approach to change the default default
>>      behavior and call hypervisor and eventually the info notifiers
>>      before kdump. There still would be the possibility to call kdump
>>      first by the command line parameter.
>> 
>>   3. Remove the possibility to call kdump first completely. It would
>>      assume that all the notifiers in the info list are super safe
>>      or that they make kdump actually more safe.
>> 
>>   4. Create one more notifier list for operations that always should
>>      be called before crash_dump.
>> 
>> Regarding the extra notifier list (4th solution). It is not clear to
>> me whether it would be always called even before hypervisor list or
>> when kdump is not enabled. We must not over-engineer it.
>> 
>> 2nd proposal looks like a good compromise. But maybe we could do
>> this change few releases later. The notifiers split is a big
>> change on its own.


On 24/05/2022 07:18, Baoquan He wrote:
>>[...]
>> I would vote for 1 or 4 without any hesitation, and prefer 4. I ever
>> suggest the variant of solution 4 in v1 reviewing. That's taking those
>> notifiers out of list and enforcing to execute them before kdump. E.g
>> the one on HyperV to terminate VMbus connection. Maybe solution 4 is
>> better to provide a determinate way for people to add necessary code
>> at the earliest part.
>> [...] 
>>>
>>> Regarding the extra notifier list (4th solution). It is not clear to
>>> me whether it would be always called even before hypervisor list or
>>> when kdump is not enabled. We must not over-engineer it.
>> 
>> One thing I would like to notice is, no matter how perfect we split the
>> lists this time, we can't gurantee people will add notifiers reasonablly
>> in the future. And people from different sub-component may not do
>> sufficient investigation and add them to fulfil their local purpose.
>> 
>> The current panic notifers list is the best example. Hyper-V actually
>> wants to run some necessary code before kdump, but not all of them, they
>> just add it, ignoring the original purpose of
>> crash_kexec_post_notifiers. I guess they do like this just because it's
>> easy to do, no need to bother changing code in generic place.
>> 
>> Solution 4 can make this no doubt, that's why I like it better.
>> [...] 
>> As I replied to Guilherme, solution 2 will cause regression if not
>> calling kdump firstly. Solution 3 leaves people space to make mistake,
>> they could add nontifier into wrong list.
>> 
>> I would like to note again that the panic notifiers are optional to run,
>> while kdump is expectd once loaded, from the original purpose. I guess
>> people I know will still have this thought, e.g Hatayama, Masa, they are
>> truly often use panic notifiers like this on their company's system.


On 24/05/2022 11:44, Eric W. Biederman wrote:
> [...]
> Unfortunately I am also very grouchy.
> 
> Notifiers before kexec on panic are fundamentally broken.  So please
> just remove crash_kexec_post notifiers and be done with it.  Part of the
> deep issue is that firmware always has a common and broken
> implementation for anything that is not mission critical to
> motherboards.
> 
> Notifiers in any sense on these paths are just bollocks.  Any kind of
> notifier list is fundamentally fragile in the face of memory corruption
> and very very difficult to review.
> 
> So I am going to refresh my ancient NACK on this.
> 
> I can certainly appreciate that there are pieces of the reboot paths
> that can be improved.  I don't think making anything more feature full
> or flexible is any kind of real improvement.


Now, from the thread "Should arm64 have a custom crash shutdown
handler?" (link:
https://lore.kernel.org/lkml/427a8277-49f0-4317-d6c3-4a15d7070e55@igalia.com/),
we have:

On 05/05/2022 08:10, Mark Rutland wrote:
>> On Wed, May 04, 2022 at 05:00:42PM -0300, Guilherme G. Piccoli wrote:
>>> [...]
>>> Currently, when we kexec in arm64, the function machine_crash_shutdown()
>>> is called as a handler to disable CPUs and (potentially) do extra
>>> quiesce work. In the aforementioned architectures, there's a way to
>>> override this function, if for example an hypervisor wish to have its
>>> guests running their own custom shutdown machinery.
>> 
>> What exactly do you need to do in this custom shutdown machinery?
>> 
>> The general expectation for arm64 is that any hypervisor can implement PSCI,
>> and as long as you have that, CPUs (and the VM as a whole) can be shutdown in a
>> standard way.
>> 
>> I suspect what you're actually after is a mechanism to notify the hypervisor
>> when the guest crashes, rather than changing the way the shutdown itself
>> occurs? If so, we already have panic notifiers, and QEMU has a "pvpanic"
>> device using that. See drivers/misc/pvpanic/.


OK, so it seems we have some points in which agreement exists, and some
points that there is no agreement and instead, we have antagonistic /
opposite views and needs. Let's start with the easier part heh


It seems everybody agrees that *we shouldn't over-engineer things*, and
as per Eric good words: making the panic path more feature-full or
increasing flexibility isn't a good idea. So, as a "corollary": the
panic level approach I'm proposing is not a good fit, I'll drop it and
let's go with something simpler.

Another point of agreement seems to be that _notifier lists in the panic
path are dangerous_, for *2 different reasons*:

(a) We cannot guarantee that people won't add crazy callbacks there, we
can plan and document things the best as possible - it'll never be
enough, somebody eventually would slip a nonsense callback that would
break things and defeat the planned purpose of such a list;

(b) As per Eric point, in a panic/crash situation we might have memory
corruption exactly in the list code / pointers, etc, so the notifier
lists are, by nature, a bit fragile. But I think we shouldn't consider
it completely "bollocks", since this approach has been used for a while
with a good success rate. So, lists aren't perfect at all, but at the
same time, they aren't completely useless.


Now, to the points in which there are conflicting / antagonistic
needs/views:

(I) Kdump should be the first thing to run, as it's been like that since
forever. But...notice that "crash_kexec_post_notifiers" was created
exactly as a way to circumvent that, so we can see this is not an
absolute truth. Some users really *require to execute* some special code
*before kdump*.
Worth noticing here that regular kexec invokes the drivers .shutdown()
handlers, while kdump [aka crash_kexec()] does not, so we must have a
way to run code before kdump in a crash situation.

(II) If *we need* to have some code always running before kdump/reboot
on panic path (like the Hyper-V vmbus connection unload), *where to add
such code*? Again, conflicting views. Some would say we should hardcode
this in the panic() function. Others, that we should use the custom
machine_crash_shutdown() infrastructure - but notice that this isn't
available in all architectures, like arm64. Finally, others suggest
to...use notifier lists! Which was more or less the approach we took in
this patch.

How can we reach consensus on this? Not everybody will be 100% happy,
that's for sure. Also, I'd risk to say keep things as-is now or even
getting rid of "crash_kexec_post_notifiers" won't work at all, we have
users with legitimate needs of running code before a kdump/reboot when
crash happens. The *main goal* should be to have a *simple solution*
that doesn't require users to abuse parameters, like it's been done with
"crash_kexec_post_notifiers" (Hyper-V and PowerPC currently force this
parameter to be enabled, for example).


To avoid using a 4th list, especially given the list nature is a bit
fragile, I'd suggest one of the 3 following approaches - I *really
appreciate feedbacks* on that so I can implement the best solution and
avoid wasting time in some poor/disliked solution:

(1) We could have a helper function in the "beginning" of panic path,
i.e., after the logic to disable preemption/IRQs/secondary CPUs, but
*before* kdump. Then, users like Hyper-V that require to execute stuff
regardless of kdump or not, would run their callbacks from there,
directly, no lists involved.

- pros: simple, doesn't mess with arch code or involve lists.
- cons: header issues - will need to "export" such function from driver
code, for example, to run in core code. Also, some code might only be
required to run in some architectures, or only if kdump is set, etc.,
making the callbacks more complex / full of if conditionals.


(2) Similarly to previous solution, we could have a helper in the kexec
core code, not in the panic path. This way, users that require running
stuff *before a kdump* would add direct calls there; if kdump isn't
configured, and if such users also require that this code execute in
panic nevertheless, they'd need to also add a callback to some notifier
list.

- pros: also simple / doesn't mess with arch code or involve lists;
restricts the callbacks to kdump case.
- cons: also header issues, but might cause code duplicity too, since
some users would require both to run their code before a kdump and in
some panic notifier list.


(3) Have a way in arm64 (and all archs maybe) to run code before a kdump
- this is analog to the custom machine_crash_shutdown() we have nowadays
in some archs.

- pros: decouple kdump-required callbacks from panic notifiers, doesn't
involve lists, friendly to arch-dependent callbacks.
- cons: also header issues, might cause code duplicity (since some users
would also require to run their code in panic path regardless of kdump)
and involve changing arch code (some maintainers like Mark aren't fond
about that, with good reasons!).


So, hopefully we can converge to some direction even if not 100% of
users are happy - this problem is naturally full of trade-offs.
Thanks again for the reviews and the time you're spending reading these
long threads.

Cheers,


Guilherme
