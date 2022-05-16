Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94065287C2
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 16:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244817AbiEPO6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 10:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244894AbiEPO4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 10:56:52 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C816137A95;
        Mon, 16 May 2022 07:56:50 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 884A921FE4;
        Mon, 16 May 2022 14:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652713009; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oTDrZeo/UdLI29Tuaw8mlcdG/RkPgJLQM7cePAnlqRg=;
        b=qMST7ia3BcKl3UtC1W2uQ0qkLBJP5Q7YC0oT0Qsb2KbEzU3Or4Q8r5PYsshuphM/GEHsx/
        3TbgfR0/0E5XpsXnd9OyJN2pbUs6sglf0Hs/rZTi2wLDZTO2OOnHvkd7qA4fAmNZA1vdry
        3XHA87WfjJ2L5kh4VZznBS1IZ/1m/S0=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 028062C141;
        Mon, 16 May 2022 14:56:49 +0000 (UTC)
Date:   Mon, 16 May 2022 16:56:41 +0200
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
Subject: Re: [PATCH 25/30] panic, printk: Add console flush parameter and
 convert panic_print to a notifier
Message-ID: <YoJmKYLzPZqCDDim@alley>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-26-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427224924.592546-26-gpiccoli@igalia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 2022-04-27 19:49:19, Guilherme G. Piccoli wrote:
> Currently the parameter "panic_print" relies in a function called
> directly on panic path; one of the flags the users can set for
> panic_print triggers a console replay mechanism, to show the
> entire kernel log buffer (from the beginning) in a panic event.
> 
> Two problems with that: the dual nature of the panic_print
> isn't really appropriate, the function was originally meant
> to allow users dumping system information on panic events,
> and was "overridden" to also force a console flush of the full
> kernel log buffer. It also turns the code a bit more complex
> and duplicate than it needs to be.
> 
> This patch proposes 2 changes: first, we decouple panic_print
> from the console flushing mechanism, in the form of a new kernel
> core parameter (panic_console_replay); we kept the functionality
> on panic_print to avoid userspace breakage, although we comment
> in both code and documentation that this panic_print usage is
> deprecated.
> 
> We converted panic_print function to a panic notifier too, adding
> it on the panic informational notifier list, executed as the final
> callback. This allows a more clear code and makes sense, as
> panic_print_sys_info() is really a panic-time only function.
> We also moved its code to kernel/printk.c, it seems to make more
> sense given it's related to printing stuff.

I really like both changes. Just please split it them into two
patchset. I mean one patch for the new "panic_console_replay"
parameter and 2nd that moves "printk_info" into the notifier.

Best Regards,
Petr
