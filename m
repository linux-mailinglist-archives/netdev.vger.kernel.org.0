Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E01B524F49
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 16:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354962AbiELODZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 10:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354935AbiELODW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 10:03:22 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E219F55206;
        Thu, 12 May 2022 07:03:17 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 5FD141F908;
        Thu, 12 May 2022 14:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652364196; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LqB96ySSQJ4ly+3J+rYGGuH/Fd7fkvILEbloF31pDTM=;
        b=q3SRuDuz1bsrtNT6AQbijhKvd/E1pyV5ISS04f4B5Eo/MpxJkThlvlpzsrdXZrusqFVq1r
        7s+CTa1eDnSZSlcSzDLMEjhXIjmmjm5vpsFw4wJd/0EtFszB2sl8NlJGjykorM6dG2+lpF
        5FiP1kelHffEWxoWnmRZqh37k1tv6Lg=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 5C2702C141;
        Thu, 12 May 2022 14:03:13 +0000 (UTC)
Date:   Thu, 12 May 2022 16:03:10 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     akpm@linux-foundation.org, bhe@redhat.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, coresight@lists.linaro.org,
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
        corbet@lwn.net, d.hatayama@jp.fujitsu.com,
        dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org
Subject: Re: [PATCH 24/30] panic: Refactor the panic path
Message-ID: <Yn0TnsWVxCcdB2yO@alley>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-25-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427224924.592546-25-gpiccoli@igalia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

first, I am sorry for stepping into the discussion so late.
I was busy with some other stuff and this patchset is far
from trivial.

Second, thanks a lot for putting so much effort into it.
Most of the changes look pretty good, especially all
the fixes of particular notifiers and split into
four lists.

Though this patch will need some more love. See below
for more details.


On Wed 2022-04-27 19:49:18, Guilherme G. Piccoli wrote:
> The panic() function is somewhat convoluted - a lot of changes were
> made over the years, adding comments that might be misleading/outdated
> now, it has a code structure that is a bit complex to follow, with
> lots of conditionals, for example. The panic notifier list is something
> else - a single list, with multiple callbacks of different purposes,
> that run in a non-deterministic order and may affect hardly kdump
> reliability - see the "crash_kexec_post_notifiers" workaround-ish flag.
> 
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -3784,6 +3791,33 @@
>  			timeout < 0: reboot immediately
>  			Format: <timeout>
>  
> +	panic_notifiers_level=
> +			[KNL] Set the panic notifiers execution order.
> +			Format: <unsigned int>
> +			We currently have 4 lists of panic notifiers; based
> +			on the functionality and risk (for panic success) the
> +			callbacks are added in a given list. The lists are:
> +			- hypervisor/FW notification list (low risk);
> +			- informational list (low/medium risk);
> +			- pre_reboot list (higher risk);
> +			- post_reboot list (only run late in panic and after
> +			kdump, not configurable for now).
> +			This parameter defines the ordering of the first 3
> +			lists with regards to kdump; the levels determine
> +			which set of notifiers execute before kdump. The
> +			accepted levels are:

This talks only about kdump. The reality is much more complicated.
The level affect the order of:

    + notifiers vs. kdump
    + notifiers vs. crash_dump
    + crash_dump vs. kdump

There might theoretically many variants of the ordering of kdump,
crash_dump, and the 4 notifier list. Some variants do not make
much sense. You choose 5 variants and tried to select them by
a level number.

The question is if we really could easily describe the meaning this
way. It is not only about a "level" of notifiers before kdump. It is
also about the ordering of crash_dump vs. kdump. IMHO, "level"
semantic does not fit there.

Maybe more parameters might be easier to understand the effect.
Anyway, we first need to agree on the chosen variants.
I am going to discuss it more in the code, see below.



> +			0: kdump is the first thing to run, NO list is
> +			executed before kdump.
> +			1: only the hypervisor list is executed before kdump.
> +			2 (default level): the hypervisor list and (*if*
> +			there's any kmsg_dumper defined) the informational
> +			list are executed before kdump.
> +			3: both the hypervisor and the informational lists
> +			(always) execute before kdump.
> +			4: the 3 lists (hypervisor, info and pre_reboot)
> +			execute before kdump - this behavior is analog to the
> +			deprecated parameter "crash_kexec_post_notifiers".
> +
>  	panic_print=	Bitmask for printing system info when panic happens.
>  			User can chose combination of the following bits:
>  			bit 0: print all tasks info
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -183,6 +195,112 @@ static void panic_print_sys_info(bool console_flush)
>  		ftrace_dump(DUMP_ALL);
>  }
>  
> +/*
> + * Helper that accumulates all console flushing routines executed on panic.
> + */
> +static void console_flushing(void)
> +{
> +#ifdef CONFIG_VT
> +	unblank_screen();
> +#endif
> +	console_unblank();
> +
> +	/*
> +	 * In this point, we may have disabled other CPUs, hence stopping the
> +	 * CPU holding the lock while still having some valuable data in the
> +	 * console buffer.
> +	 *
> +	 * Try to acquire the lock then release it regardless of the result.
> +	 * The release will also print the buffers out. Locks debug should
> +	 * be disabled to avoid reporting bad unlock balance when panic()
> +	 * is not being called from OOPS.
> +	 */
> +	debug_locks_off();
> +	console_flush_on_panic(CONSOLE_FLUSH_PENDING);
> +
> +	panic_print_sys_info(true);
> +}
> +
> +#define PN_HYPERVISOR_BIT	0
> +#define PN_INFO_BIT		1
> +#define PN_PRE_REBOOT_BIT	2
> +#define PN_POST_REBOOT_BIT	3
> +
> +/*
> + * Determine the order of panic notifiers with regards to kdump.
> + *
> + * This function relies in the "panic_notifiers_level" kernel parameter
> + * to determine how to order the notifiers with regards to kdump. We
> + * have currently 5 levels. For details, please check the kernel docs for
> + * "panic_notifiers_level" at Documentation/admin-guide/kernel-parameters.txt.
> + *
> + * Default level is 2, which means the panic hypervisor and informational
> + * (unless we don't have any kmsg_dumper) lists will execute before kdump.
> + */
> +static void order_panic_notifiers_and_kdump(void)
> +{
> +	/*
> +	 * The parameter "crash_kexec_post_notifiers" is deprecated, but
> +	 * valid. Users that set it want really all panic notifiers to
> +	 * execute before kdump, so it's effectively the same as setting
> +	 * the panic notifiers level to 4.
> +	 */
> +	if (panic_notifiers_level >= 4 || crash_kexec_post_notifiers)
> +		return;
> +
> +	/*
> +	 * Based on the level configured (smaller than 4), we clear the
> +	 * proper bits in "panic_notifiers_bits". Notice that this bitfield
> +	 * is initialized with all notifiers set.
> +	 */
> +	switch (panic_notifiers_level) {
> +	case 3:
> +		clear_bit(PN_PRE_REBOOT_BIT, &panic_notifiers_bits);
> +		break;
> +	case 2:
> +		clear_bit(PN_PRE_REBOOT_BIT, &panic_notifiers_bits);
> +
> +		if (!kmsg_has_dumpers())
> +			clear_bit(PN_INFO_BIT, &panic_notifiers_bits);
> +		break;
> +	case 1:
> +		clear_bit(PN_PRE_REBOOT_BIT, &panic_notifiers_bits);
> +		clear_bit(PN_INFO_BIT, &panic_notifiers_bits);
> +		break;
> +	case 0:
> +		clear_bit(PN_PRE_REBOOT_BIT, &panic_notifiers_bits);
> +		clear_bit(PN_INFO_BIT, &panic_notifiers_bits);
> +		clear_bit(PN_HYPERVISOR_BIT, &panic_notifiers_bits);
> +		break;
> +	}
> +}
>
> +/*
> + * Set of helpers to execute the panic notifiers only once.
> + * Just the informational notifier cares about the return.
> + */
> +static inline bool notifier_run_once(struct atomic_notifier_head head,
> +				     char *buf, long bit)
> +{
> +	if (test_and_change_bit(bit, &panic_notifiers_bits)) {
> +		atomic_notifier_call_chain(&head, PANIC_NOTIFIER, buf);
> +		return true;
> +	}
> +	return false;
> +}

Here is the code using the above functions. It helps to discuss
the design and logic.

<kernel/panic.c>
	order_panic_notifiers_and_kdump();

	/* If no level, we should kdump ASAP. */
	if (!panic_notifiers_level)
		__crash_kexec(NULL);

	crash_smp_send_stop();
	panic_notifier_hypervisor_once(buf);

	if (panic_notifier_info_once(buf))
		kmsg_dump(KMSG_DUMP_PANIC);

	panic_notifier_pre_reboot_once(buf);

	__crash_kexec(NULL);

	panic_notifier_hypervisor_once(buf);

	if (panic_notifier_info_once(buf))
		kmsg_dump(KMSG_DUMP_PANIC);

	panic_notifier_pre_reboot_once(buf);
</kernel/panic.c>

I have to say that the logic is very unclear. Almost all
functions are called twice:

   + __crash_kexec()
   + kmsg_dump()
   + panic_notifier_hypervisor_once()
   + panic_notifier_pre_reboot_once()
   + panic_notifier_info_once()

It is pretty hard to find what functions are always called in the same
order and where the order can be inverted.

The really used code path is defined by order_panic_notifiers_and_kdump()
that encodes "level" into "bits". The bits are then flipped in
panic_notifier_*_once() calls that either do something or not.
kmsg_dump() is called according to the bit flip.

It is an interesting approach. I guess that you wanted to avoid too
many if/then/else levels in panic(). But honestly, it looks like
a black magic to me.

IMHO, it is always easier to follow if/then/else logic than using
a translation table that requires additional bit flips when
a value is used more times.

Also I guess that it is good proof that "level" abstraction does
not fit here. Normal levels would not need this kind of magic.


OK, the question is how to make it better. Let's start with
a clear picture of the problem:

1. panic() has basically two funtions:

      + show/store debug information (optional ways and amount)
      + do something with the system (reboot, stay hanged)


2. There are 4 ways how to show/store the information:

      + tell hypervisor to store what it is interested about
      + crash_dump
      + kmsg_dump()
      + consoles

  , where crash_dump and consoles are special:

     + crash_dump does not return. Instead it ends up with reboot.

     + Consoles work transparently. They just need an extra flush
       before reboot or staying hanged.


3. The various notifiers do things like:

     + tell hypervisor about the crash
     + print more information (also stop watchdogs)
     + prepare system for reboot (touch some interfaces)
     + prepare system for staying hanged (blinking)

   Note that it pretty nicely matches the 4 notifier lists.


Now, we need to decide about the ordering. The main area is how
to store the debug information. Consoles are transparent so
the quesition is about:

     + hypervisor
     + crash_dump
     + kmsg_dump

Some people need none and some people want all. There is a
risk that system might hung at any stage. This why people want to
make the order configurable.

But crash_dump() does not return when it succeeds. And kmsg_dump()
users havn't complained about hypervisor problems yet. So, that
two variants might be enough:

    + crash_dump (hypervisor, kmsg_dump as fallback)
    + hypervisor, kmsg_dump, crash_dump

One option "panic_prefer_crash_dump" should be enough.
And the code might look like:

void panic()
{
[...]
	dump_stack();
	kgdb_panic(buf);

	< ---  here starts the reworked code --- >

	/* crash dump is enough when enabled and preferred. */
	if (panic_prefer_crash_dump)
		__crash_kexec(NULL);

	/* Stop other CPUs and focus on handling the panic state. */
	if (has_kexec_crash_image)
		crash_smp_send_stop();
	else
		smp_send_stop()

	/* Notify hypervisor about the system panic. */
	atomic_notifier_call_chain(&panic_hypervisor_list, 0, NULL);

	/*
	 * No need to risk extra info when there is no kmsg dumper
	 * registered.
	 */
	if (!has_kmsg_dumper())
		__crash_kexec(NULL);

	/* Add extra info from different subsystems. */
	atomic_notifier_call_chain(&panic_info_list, 0, NULL);

	kmsg_dump(KMSG_DUMP_PANIC);
	__crash_kexec(NULL);

	/* Flush console */
	unblank_screen();
	console_unblank();
	debug_locks_off();
	console_flush_on_panic(CONSOLE_FLUSH_PENDING);

	if (panic_timeout > 0) {
		delay()
	}

	/*
	 * Prepare system for eventual reboot and allow custom
	 * reboot handling.
	 */
	atomic_notifier_call_chain(&panic_reboot_list, 0, NULL);

	if (panic_timeout != 0) {
		reboot();
	}

	/*
	 * Prepare system for the infinite waiting, for example,
	 * setup blinking.
	 */
	atomic_notifier_call_chain(&panic_loop_list, 0, NULL);

	infinite_loop();
}


__crash_kexec() is there 3 times but otherwise the code looks
quite straight forward.

Note 1: I renamed the two last notifier list. The name 'post-reboot'
	did sound strange from the logical POV ;-)

Note 2: We have to avoid the possibility to call "reboot" list
	before kmsg_dump(). All callbacks providing info
	have to be in the info list. It a callback combines
	info and reboot functionality then it should be split.

	There must be another way to calm down problematic
	info callbacks. And it has to be solved when such
	a problem is reported. Is there any known issue, please?

It is possible that I have missed something important.
But I would really like to make the logic as simple as possible.

Best Regards,
Petr
