Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30B26521C7C
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 16:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242988AbiEJOhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 10:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344626AbiEJOfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 10:35:09 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44F72DD793;
        Tue, 10 May 2022 06:54:12 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KyKJp4qqdz4yTd;
        Tue, 10 May 2022 23:54:02 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1652190848;
        bh=RKiZUE5HvPhTVnUibJtmltdG/qpHsl+mSP0bgs2lHhQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Z05kSyfn/tRZEkMC+xx0iIJQ7Am+MQO7HLgvv0mZSHOcfpqTom2o/uwqzS0x8Mf2S
         +MV9rZ+Fzf71f3gh47v8ZN6FuQpE+0hL2e6Ug+4kF9Y6fEpYke0W/joqSUA70Lwp5I
         4Ppma9tFa9PkRNG20BN4X8MRlMpJ63sRO/S19u9v0FZlEHa4Js3eqk1sS3wGAa85dR
         +Jh96R1o2OAtJhZFfuVMo1EZ8CMSa8mkEAFP0AyoLzOV+kygqKbLAfKRxs3fKgbcsD
         1Vaxn4RMiVSaImYmC7RQ1ktIs3LG4P5Jb+tgoFnzybYroBhkWvfkc77elbZWKz1nx/
         2xhke52QkhhQQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        Hari Bathini <hbathini@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        pmladek@suse.com, kexec@lists.infradead.org, bhe@redhat.com,
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
        will@kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@samba.org>, akpm@linux-foundation.org
Subject: Re: [PATCH 08/30] powerpc/setup: Refactor/untangle panic notifiers
In-Reply-To: <f9c3de3c-1709-a1aa-2ece-c9fbfd5e6d6a@igalia.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-9-gpiccoli@igalia.com>
 <3c34d8e2-6f84-933f-a4ed-338cd300d6b0@linux.ibm.com>
 <f9c3de3c-1709-a1aa-2ece-c9fbfd5e6d6a@igalia.com>
Date:   Tue, 10 May 2022 23:53:56 +1000
Message-ID: <87fslh8pe3.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Guilherme G. Piccoli" <gpiccoli@igalia.com> writes:
> On 05/05/2022 15:55, Hari Bathini wrote:
>> [...] 
>> The change looks good. I have tested it on an LPAR (ppc64).
>> 
>> Reviewed-by: Hari Bathini <hbathini@linux.ibm.com>
>> 
>
> Hi Michael. do you think it's possible to add this one to powerpc/next
> (or something like that), or do you prefer a V2 with his tag?

Ah sorry, I assumed it was going in as part of the whole series. I guess
I misread the cover letter.

So you want me to take this patch on its own via the powerpc tree?

cheers
