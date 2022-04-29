Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 441F65155E5
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 22:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380997AbiD2UnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 16:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381104AbiD2UnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 16:43:02 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871DD83021;
        Fri, 29 Apr 2022 13:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9LhFYA+MjEc96AcZxxeEKFjkU9Lk82GaxnYYVWnVk68=; b=XwGE93aX+1E0t3pByj3j/O+5Ga
        K3u/NbvWUIPTGWXFFUF5/S8bghnnop1aApPsPGKNCX+XA1bvvH3EQ0PcLpFJhLHgKjy3gTmHDpRZx
        xpeiw9TV1dPXB2YSqRvo3agu2ikjDsTWOdpgS/WgDbAttd/ff7K6VJQNlrO38xJTdLOWq3LaiPpb7
        BCxPsp9BBfFRjEJDD6TJuu/Y8uUcnXFJiNLt6QIOyD0DFBtRwQdBNCscMgnx+i0qVThLJVg3KcgFz
        9afxev7tVqQLuY2Z0izXtjt9I1wawTaSR9Ugp7AvNWX4ugYt89qxijRM6XzCj5d2MXRHOn6SprLRr
        LWTDMVqw==;
Received: from [179.113.53.197] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1nkXNs-000CEn-5h; Fri, 29 Apr 2022 22:38:36 +0200
Message-ID: <50178dfb-8e94-f35f-09c3-22fe197550ef@igalia.com>
Date:   Fri, 29 Apr 2022 17:38:08 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 24/30] panic: Refactor the panic path
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
        "will@kernel.org" <will@kernel.org>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-25-gpiccoli@igalia.com>
 <PH0PR21MB30252C55EB4F97F3D78021BDD7FC9@PH0PR21MB3025.namprd21.prod.outlook.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <PH0PR21MB30252C55EB4F97F3D78021BDD7FC9@PH0PR21MB3025.namprd21.prod.outlook.com>
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

On 29/04/2022 14:53, Michael Kelley (LINUX) wrote:
> From: Guilherme G. Piccoli <gpiccoli@igalia.com> Sent: Wednesday, April 27, 2022 3:49 PM
>> [...]
>> +	panic_notifiers_level=
>> +			[KNL] Set the panic notifiers execution order.
>> +			Format: <unsigned int>
>> +			We currently have 4 lists of panic notifiers; based
>> +			on the functionality and risk (for panic success) the
>> +			callbacks are added in a given list. The lists are:
>> +			- hypervisor/FW notification list (low risk);
>> +			- informational list (low/medium risk);
>> +			- pre_reboot list (higher risk);
>> +			- post_reboot list (only run late in panic and after
>> +			kdump, not configurable for now).
>> +			This parameter defines the ordering of the first 3
>> +			lists with regards to kdump; the levels determine
>> +			which set of notifiers execute before kdump. The
>> +			accepted levels are:
>> +			0: kdump is the first thing to run, NO list is
>> +			executed before kdump.
>> +			1: only the hypervisor list is executed before kdump.
>> +			2 (default level): the hypervisor list and (*if*
>> +			there's any kmsg_dumper defined) the informational
>> +			list are executed before kdump.
>> +			3: both the hypervisor and the informational lists
>> +			(always) execute before kdump.
> 
> I'm not clear on why level 2 exists.  What is the scenario where
> execution of the info list before kdump should be conditional on the
> existence of a kmsg_dumper?   Maybe the scenario is described
> somewhere in the patch set and I just missed it.
> 

Hi Michael, thanks for your review/consideration. So, this idea started
kind of some time ago. It all started with a need of exposing more
information on kernel log *before* kdump and *before* pstore -
specifically, we're talking about panic_print. But this cause some
reactions, Baoquan was very concerned with that [0]. Soon after, I've
proposed a panic notifiers filter (orthogonal) approach, to which Petr
suggested instead doing a major refactor [1] - it finally is alive in
the form of this series.

The theory behind the level 2 is to allow a scenario of kdump with the
minimum amount of notifiers - what is the point in printing more
information if the user doesn't care, since it's going to kdump? Now, if
there is a kmsg dumper, it means that there is likely some interest in
collecting information, and that might as well be required before the
potential kdump (which is my case, hence the proposal on [0]).

Instead of forcing one of the two behaviors (level 1 or level 3), we
have a middle-term/compromise: if there's interest in collecting such
data (in the form of a kmsg dumper), we then execute the informational
notifiers before kdump. If not, why to increase (even slightly) the risk
for kdump?

I'm OK in removing the level 2 if people prefer, but I don't feel it's a
burden, quite opposite - seems a good way to accommodate the somewhat
antagonistic ideas (jump to kdump ASAP vs collecting more info in the
panicked kernel log).

[0] https://lore.kernel.org/lkml/20220126052246.GC2086@MiWiFi-R3L-srv/

[1] https://lore.kernel.org/lkml/YfPxvzSzDLjO5ldp@alley/


>[...]
>> +	 * Based on the level configured (smaller than 4), we clear the
>> +	 * proper bits in "panic_notifiers_bits". Notice that this bitfield
>> +	 * is initialized with all notifiers set.
>> +	 */
>> +	switch (panic_notifiers_level) {
>> +	case 3:
>> +		clear_bit(PN_PRE_REBOOT_BIT, &panic_notifiers_bits);
>> +		break;
>> +	case 2:
>> +		clear_bit(PN_PRE_REBOOT_BIT, &panic_notifiers_bits);
>> +
>> +		if (!kmsg_has_dumpers())
>> +			clear_bit(PN_INFO_BIT, &panic_notifiers_bits);
>> +		break;
>> +	case 1:
>> +		clear_bit(PN_PRE_REBOOT_BIT, &panic_notifiers_bits);
>> +		clear_bit(PN_INFO_BIT, &panic_notifiers_bits);
>> +		break;
>> +	case 0:
>> +		clear_bit(PN_PRE_REBOOT_BIT, &panic_notifiers_bits);
>> +		clear_bit(PN_INFO_BIT, &panic_notifiers_bits);
>> +		clear_bit(PN_HYPERVISOR_BIT, &panic_notifiers_bits);
>> +		break;
>> +	}
> 
> I think the above switch statement could be done as follows:
> 
> if (panic_notifiers_level <= 3)
> 	clear_bit(PN_PRE_REBOOT_BIT, &panic_notifiers_bits);
> if (panic_notifiers_level <= 2)
> 	if (!kmsg_has_dumpers())
> 		clear_bit(PN_INFO_BIT, &panic_notifiers_bits);
> if (panic_notifiers_level <=1)
> 	clear_bit(PN_INFO_BIT, &panic_notifiers_bits);
> if (panic_notifiers_level == 0)
> 	clear_bit(PN_HYPERVISOR_BIT, &panic_notifiers_bits);
> 
> That's about half the lines of code.  It's somewhat a matter of style,
> so treat this as just a suggestion to consider.  I just end up looking
> for a better solution when I see the same line of code repeated
> 3 or 4 times!
> 

It's a good idea - I liked your code. The switch seems more
natural/explicit for me, even duplicating some lines, but in case more
people prefer your way, I can definitely change the code - thanks for
the suggestion.
Cheers,


Guilherme
