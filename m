Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379C358BB9E
	for <lists+netdev@lfdr.de>; Sun,  7 Aug 2022 17:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234788AbiHGPjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 11:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbiHGPjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 11:39:04 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D4A626B;
        Sun,  7 Aug 2022 08:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FfOmDqrueH5zbkn3yATMhpqMWWEe+35EmBPi72/LV0I=; b=qAULYagpbd2RoWJByTE0dULDjL
        r7Tu7V5xMI6abRrlBB1Hdw79O2+Gi1+SniR1hAmkwGAZLtm63NGffvzeN9UTGCm5bw4JRv7N3/vug
        hf4eGxeOAY49HIsm/Vot9pTpSQF7Q8xM6I2Rt5rEoIcAvOGE8ciejoIAfsZ/B2IsWvr82U8P7Hk4Q
        C13RHqD5sFxOCSCBo5zBx6YZ1ZD36P7qDjBwFgNMsZ2OSQ7nnkn9tW6FLa5TptfpHKGEa0NR0w1Z+
        k8DeFu3wlxquxk0Jsn7hIHZjWq2TmYaGFvCrd1/xXk1jUKgyliHRhTH6USSKsazGe0o59QY0IFDhP
        FxNVrtnQ==;
Received: from [187.56.70.103] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oKiMm-0011kP-W9; Sun, 07 Aug 2022 17:39:01 +0200
Message-ID: <5e9d4906-3601-f07d-a886-7a723c6867c8@igalia.com>
Date:   Sun, 7 Aug 2022 12:38:33 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 03/13] firmware: google: Test spinlock on panic path to
 avoid lockups
Content-Language: en-US
To:     kexec@lists.infradead.org, linux-efi@vger.kernel.org,
        Evan Green <evgreen@chromium.org>
Cc:     pmladek@suse.com, bhe@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, kernel-dev@igalia.com,
        kernel@gpiccoli.net, halves@canonical.com, fabiomirmar@gmail.com,
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
        will@kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Julius Werner <jwerner@chromium.org>,
        David Gow <davidgow@google.com>
References: <20220719195325.402745-1-gpiccoli@igalia.com>
 <20220719195325.402745-4-gpiccoli@igalia.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20220719195325.402745-4-gpiccoli@igalia.com>
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

On 19/07/2022 16:53, Guilherme G. Piccoli wrote:
> Currently the gsmi driver registers a panic notifier as well as
> reboot and die notifiers. The callbacks registered are called in
> atomic and very limited context - for instance, panic disables
> preemption and local IRQs, also all secondary CPUs (not executing
> the panic path) are shutdown.
> 
> With that said, taking a spinlock in this scenario is a dangerous
> invitation for lockup scenarios. So, fix that by checking if the
> spinlock is free to acquire in the panic notifier callback - if not,
> bail-out and avoid a potential hang.
> 
> Fixes: 74c5b31c6618 ("driver: Google EFI SMI")
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: David Gow <davidgow@google.com>
> Cc: Evan Green <evgreen@chromium.org>
> Cc: Julius Werner <jwerner@chromium.org>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> 
> ---
> 
> V2:
> - do not use spin_trylock anymore, to avoid messing with
> non-panic paths; now we just check the spinlock state in
> the panic notifier before taking it. Thanks Evan for the
> review/idea!
> 
>  drivers/firmware/google/gsmi.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> [...]

Hi Evan, do you think this one is good now, based on your previous review?

Appreciate any feedback!
Cheers,


Guilherme
