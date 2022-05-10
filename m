Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 392995220F6
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 18:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347256AbiEJQV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 12:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347193AbiEJQVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 12:21:47 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21D428ED28;
        Tue, 10 May 2022 09:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DG+kC/U+ySej5D6tfV4OCa8YH0d8ESpuNC4bFJt4RU8=; b=C2KkFYKUIxmXZpa9w2+Tc0j2Ea
        RFFr76ch465vsOUiMZW1uqZNDnhRYy0QqpFeaougTFG9GOX2EvcKO8NnFtvJdvaTDSvmTGm5I6bLE
        gx/SYLZAEuVfjx7NJeu1tB8cieKdzixVjql/phg2ZRqRsu9xZgqdP1nbzw6Nv7UUXN3Dua0weQYl6
        +N3ACyNpHY020LPMtgokauBK3/rzBv0qIzP0VJEueNDPsJdk0Noe60ugWXyfyRTapgsSXBPVXAg4/
        oobDhrEfQYteiYAwrodL1TGkVGLJREzPqDYfYYN3sh0JBT6vnlq6trf1vxZCJI19NPJiA+YiSFKJe
        qkMs6K7A==;
Received: from [177.183.162.244] (helo=[192.168.0.5])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1noSY8-0008UD-Jz; Tue, 10 May 2022 18:17:24 +0200
Message-ID: <244a412c-4589-28d1-bb77-d3648d4f0b12@igalia.com>
Date:   Tue, 10 May 2022 13:16:54 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 14/30] panic: Properly identify the panic event to the
 notifiers' callbacks
Content-Language: en-US
To:     Petr Mladek <pmladek@suse.com>
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
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-15-gpiccoli@igalia.com> <YnqBsXBImU64PAOL@alley>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <YnqBsXBImU64PAOL@alley>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/05/2022 12:16, Petr Mladek wrote:
> [...]
> Hmm, this looks like a hack. PANIC_UNUSED will never be used.
> All notifiers will be always called with PANIC_NOTIFIER.
> 
> The @val parameter is normally used when the same notifier_list
> is used in different situations.
> 
> But you are going to use it when the same notifier is used
> in more lists. This is normally distinguished by the @nh
> (atomic_notifier_head) parameter.
> 
> IMHO, it is a bad idea. First, it would confuse people because
> it does not follow the original design of the parameters.
> Second, the related code must be touched anyway when
> the notifier is moved into another list so it does not
> help much.
> 
> Or do I miss anything, please?
> 
> Best Regards,
> Petr

Hi Petr, thanks for the review.

I'm not strong attached to this patch, so we could drop it and refactor
the code of next patches to use the @nh as identification - but
personally, I feel this parameter could be used to identify the list
that called such function, in other words, what is the event that
triggered the callback. Some notifiers are even declared with this
parameter called "ev", like the event that triggers the notifier.


You mentioned 2 cases:

(a) Same notifier_list used in different situations;

(b) Same *notifier callback* used in different lists;

Mine is case (b), right? Can you show me an example of case (a)? You can
see in the following patches (or grep the kernel) that people are using
this identification parameter to determine which kind of OOPS trigger
the callback to condition the execution of the function to specific
cases. IIUIC, this is more or less what I'm doing, but extending the
idea for panic notifiers.

Again, as a personal preference, it makes sense to me using id's VS
comparing pointers to differentiate events/callers.

Cheers,


Guilherme
