Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7770252A2E3
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 15:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347414AbiEQNMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 09:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347868AbiEQNLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 09:11:23 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1A21145;
        Tue, 17 May 2022 06:11:21 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0C09D21CDB;
        Tue, 17 May 2022 13:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652793080; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R3V2DPM1jjc4jD8tVw3U8Rq3S0Maoan+sJ+xup8d8sI=;
        b=FE8yzrStcygQwANxOmZrJZbOrCy87Ou5DJ3FGcXlGzv/8KcD1Q9vQAYohnpV6O9yl65Qfm
        zyx0GaYk63CmAg8xlzK3VRV5wlBb3dplZbLwFVDWl++Ff8DNSFdVejZHiQCHUg6G6gVRgz
        J3YUEPeJCts4dfmVUl5hnzLG7sbV2vU=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D75DF2C141;
        Tue, 17 May 2022 13:11:17 +0000 (UTC)
Date:   Tue, 17 May 2022 15:11:10 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     akpm@linux-foundation.org, bhe@redhat.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-um@lists.infradead.org,
        linux-xtensa@linux-xtensa.org, netdev@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net, rcu@vger.kernel.org,
        sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org
Subject: Re: [PATCH 14/30] panic: Properly identify the panic event to the
 notifiers' callbacks
Message-ID: <YoOe7ifxfW8CEHdt@alley>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-15-gpiccoli@igalia.com>
 <YnqBsXBImU64PAOL@alley>
 <244a412c-4589-28d1-bb77-d3648d4f0b12@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <244a412c-4589-28d1-bb77-d3648d4f0b12@igalia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 2022-05-10 13:16:54, Guilherme G. Piccoli wrote:
> On 10/05/2022 12:16, Petr Mladek wrote:
> > [...]
> > Hmm, this looks like a hack. PANIC_UNUSED will never be used.
> > All notifiers will be always called with PANIC_NOTIFIER.
> > 
> > The @val parameter is normally used when the same notifier_list
> > is used in different situations.
> > 
> > But you are going to use it when the same notifier is used
> > in more lists. This is normally distinguished by the @nh
> > (atomic_notifier_head) parameter.
> > 
> > IMHO, it is a bad idea. First, it would confuse people because
> > it does not follow the original design of the parameters.
> > Second, the related code must be touched anyway when
> > the notifier is moved into another list so it does not
> > help much.
> > 
> > Or do I miss anything, please?
> > 
> > Best Regards,
> > Petr
> 
> Hi Petr, thanks for the review.
> 
> I'm not strong attached to this patch, so we could drop it and refactor
> the code of next patches to use the @nh as identification - but
> personally, I feel this parameter could be used to identify the list
> that called such function, in other words, what is the event that
> triggered the callback. Some notifiers are even declared with this
> parameter called "ev", like the event that triggers the notifier.
> 
> 
> You mentioned 2 cases:
> 
> (a) Same notifier_list used in different situations;
> 
> (b) Same *notifier callback* used in different lists;
> 
> Mine is case (b), right? Can you show me an example of case (a)?

There are many examples of case (a):

   + module_notify_list:
	MODULE_STATE_LIVE, 	/* Normal state. */
	MODULE_STATE_COMING,	/* Full formed, running module_init. */
	MODULE_STATE_GOING,	/* Going away. */
	MODULE_STATE_UNFORMED,	/* Still setting it up. */


   + netdev_chain:

	NETDEV_UP	= 1,	/* For now you can't veto a device up/down */
	NETDEV_DOWN,
	NETDEV_REBOOT,		/* Tell a protocol stack a network interface
				   detected a hardware crash and restarted
				   - we can use this eg to kick tcp sessions
				   once done */
	NETDEV_CHANGE,		/* Notify device state change */
	NETDEV_REGISTER,
	NETDEV_UNREGISTER,
	NETDEV_CHANGEMTU,	/* notify after mtu change happened */
	NETDEV_CHANGEADDR,	/* notify after the address change */
	NETDEV_PRE_CHANGEADDR,	/* notify before the address change */
	NETDEV_GOING_DOWN,
	...

    + vt_notifier_list:

	#define VT_ALLOCATE		0x0001 /* Console got allocated */
	#define VT_DEALLOCATE		0x0002 /* Console will be deallocated */
	#define VT_WRITE		0x0003 /* A char got output */
	#define VT_UPDATE		0x0004 /* A bigger update occurred */
	#define VT_PREWRITE		0x0005 /* A char is about to be written to the console */

    + die_chain:

	DIE_OOPS = 1,
	DIE_INT3,
	DIE_DEBUG,
	DIE_PANIC,
	DIE_NMI,
	DIE_DIE,
	DIE_KERNELDEBUG,
	...

These all call the same list/chain in different situations.
The situation is distinguished by @val.


> You can see in the following patches (or grep the kernel) that people are using
> this identification parameter to determine which kind of OOPS trigger
> the callback to condition the execution of the function to specific
> cases.

Could you please show me some existing code for case (b)?
I am not able to find any except in your patches.

Anyway, the solution in 16th patch is bad, definitely.
hv_die_panic_notify_crash() uses "val" to disinguish
both:

     + "panic_notifier_list" vs "die_chain"
     + die_val when callen via "die_chain"

The API around "die_chain" API is not aware of enum panic_notifier_val
and the API using "panic_notifier_list" is not aware of enum die_val.
As I said, it is mixing apples and oranges and it is error prone.

Best Regards,
Petr
