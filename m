Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C9958CB5F
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 17:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237548AbiHHPiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 11:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233652AbiHHPiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 11:38:21 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CBD16599;
        Mon,  8 Aug 2022 08:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7mDwuqu1nsWLkvdlsGue1nXAGyykJn4H1kQrpjJWKK4=; b=nvwwtNT9v+5EaJYdYt7rD+i76Z
        A+qfeXLo54sRVHQkL6knwB+rhdWkzmhrz0GI6se2mb4qXp79J+AINty7ndHbNziIwI2DN3eimBLNh
        Whee4B4u8Abu7EsEy0jO8isTNizj5NAuDPdgDDc/gDCWJeO799pW1h2dodNc9pJAbzpKdidEAfyFW
        DkqmqiWbdA1qcB8lf3F2nJmUMPWYY+wPYT+eR3Apomdy5tIn1+gk82LIX8U0kTWRZeLdahbhzKhEK
        /qZOUo+yZYQGhdflMJTwxHoN45L9Sb1zdlV4MYrzNHaHuW0EaXEywPnC2wyHEMzHQyhS3aDnYWm9F
        rA38+8Bg==;
Received: from [187.56.70.103] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oL4pZ-002u80-Gv; Mon, 08 Aug 2022 17:38:13 +0200
Message-ID: <55a074a0-ca3a-8afc-4336-e40cff757394@igalia.com>
Date:   Mon, 8 Aug 2022 12:37:46 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 03/13] firmware: google: Test spinlock on panic path to
 avoid lockups
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Evan Green <evgreen@chromium.org>, linux-efi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, bhe@redhat.com,
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
 <019ae735-3d69-cb4e-c003-b83cc8cd76f8@igalia.com>
 <YvErMyM8FNjeDeiW@kroah.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <YvErMyM8FNjeDeiW@kroah.com>
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

On 08/08/2022 12:26, Greg Kroah-Hartman wrote:
> [...]
>>
>> Ard / Greg, do you think you could get this patch through your -next (or
>> -fixes) trees? Not sure which tree is the most common for picking GSMI
>> stuff.
> 
> Picking out an individual patch from a series with as many responses and
> threads like this one is quite difficult.
> 
> Just resend this as a stand-alone patch if you want it applied
> stand-alone as our tools want to apply a whole patch series at once.
> 
>> I'm trying to get these fixes merged individually in their trees to not
>> stall the whole series and increase the burden of re-submitting.
> 
> The burden is on the submitter, not the maintainer as we have more
> submitters than reviewers/maintainers.
> 

I understand, thanks for letting me know!

Let me clarify / ask something: this series, for example, is composed as
a bunch of patches "centered" around the same idea, panic notifiers
improvements/fixes. But its patches belong to completely different
subsystems, like EFI/misc, architectures (alpha, parisc, arm), core
kernel code, etc.

What is the best way of getting this merged?
(a) Re-send individual patches with the respective Review/ACK tags to
the proper subsystem, or;

(b) Wait until the whole series is ACKed/Reviewed, and a single
maintainer (like you or Andrew, for example) would pick the whole series
and apply at once, even if it spans across multiple parts of the kernel?

Let me know what is the general preference of the kernel maintainers,
and I'll gladly follow that =)

Thanks,


Guilherme
