Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E236958CB15
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 17:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243538AbiHHPPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 11:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243008AbiHHPPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 11:15:17 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57125B39;
        Mon,  8 Aug 2022 08:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8NeebcQIowJFvYNvYAuayRA5HrGpbu0y4rq77R8ZNew=; b=UkbTPpK3PkL/KNCksKY7NedBjm
        eKGiMxQ4EDIlwc6yVThl6uDq8BNqa4i68qOQ2Qq5S90ePBFJodmONvOinj6rYRKU6GiWn/OWgq1Es
        UIzqDDJemiX7jgCVd3GNHShRuixAW+yG8Oh+DqrjWqkwf8Py90cGVhk2xbcxCWicuz/ewTPJeLHxT
        KjoC96tOXtJRhzyQkOrOz8StFqrRq+Uh/Pu/C6+u0nELLuErbjXiUorKj+4jNXJfclDHIn47M4+xG
        zqeERGj2xybEfBqXzwIGK7cVMaWSp/uv9wMXfCaStJPbYwCSSyhl1n6XwAwA+F2AzoQY35Tq/eNZY
        v+RLic4w==;
Received: from [187.56.70.103] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oL4T6-002tRL-3C; Mon, 08 Aug 2022 17:15:00 +0200
Message-ID: <019ae735-3d69-cb4e-c003-b83cc8cd76f8@igalia.com>
Date:   Mon, 8 Aug 2022 12:14:30 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 03/13] firmware: google: Test spinlock on panic path to
 avoid lockups
Content-Language: en-US
To:     Evan Green <evgreen@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-efi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, bhe@redhat.com,
        Petr Mladek <pmladek@suse.com>, kexec@lists.infradead.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Jonathan Corbet <corbet@lwn.net>, d.hatayama@jp.fujitsu.com,
        dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com, mikelley@microsoft.com,
        hidehiro.kawai.ez@hitachi.com, jgross@suse.com,
        john.ogness@linutronix.de, Kees Cook <keescook@chromium.org>,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, Alan Stern <stern@rowland.harvard.edu>,
        Thomas Gleixner <tglx@linutronix.de>, vgoyal@redhat.com,
        vkuznets@redhat.com, Will Deacon <will@kernel.org>,
        David Gow <davidgow@google.com>,
        Julius Werner <jwerner@chromium.org>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
 <20220719195325.402745-4-gpiccoli@igalia.com>
 <CAE=gft71vH+P3iAFXC0bLu0M2x2V4uJGWc82Xa+246ECuUdT-w@mail.gmail.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <CAE=gft71vH+P3iAFXC0bLu0M2x2V4uJGWc82Xa+246ECuUdT-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/08/2022 02:07, Evan Green wrote:
> On Tue, Jul 19, 2022 at 12:55 PM Guilherme G. Piccoli
> <gpiccoli@igalia.com> wrote:
>>
>> Currently the gsmi driver registers a panic notifier as well as
>> reboot and die notifiers. The callbacks registered are called in
>> atomic and very limited context - for instance, panic disables
>> preemption and local IRQs, also all secondary CPUs (not executing
>> the panic path) are shutdown.
>>
>> With that said, taking a spinlock in this scenario is a dangerous
>> invitation for lockup scenarios. So, fix that by checking if the
>> spinlock is free to acquire in the panic notifier callback - if not,
>> bail-out and avoid a potential hang.
>>
>> Fixes: 74c5b31c6618 ("driver: Google EFI SMI")
>> Cc: Ard Biesheuvel <ardb@kernel.org>
>> Cc: David Gow <davidgow@google.com>
>> Cc: Evan Green <evgreen@chromium.org>
>> Cc: Julius Werner <jwerner@chromium.org>
>> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> 
> Reviewed-by: Evan Green <evgreen@chromium.org>

Thanks a bunch Evan!

Ard / Greg, do you think you could get this patch through your -next (or
-fixes) trees? Not sure which tree is the most common for picking GSMI
stuff.

I'm trying to get these fixes merged individually in their trees to not
stall the whole series and increase the burden of re-submitting.
Thanks in advance,


Guilherme
