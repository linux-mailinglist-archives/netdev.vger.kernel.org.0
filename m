Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA2A5BBE4B
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 16:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiIROOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 10:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiIROOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 10:14:10 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7E923BF5;
        Sun, 18 Sep 2022 07:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=aDVyle5G3wtqIccxn/cBaHSZXXYVPnL6YNcpcqqbsXA=; b=I91NEcebw/ZpGroEZ11QU1CmBe
        qxInUn7rIoCX3CLVXGhhGfuz+ZmBv0nnIWJh9TyhqERtkoI6T0q2tisSnIhmcbyHxJNdNYDBf6A1N
        gTXmzClAfzBC6LtN7rIjPVIzVgYFHk9nHdF582Rl4jILjOuN6k+loxnoLdkCmi5LdumVTOSZpDK+q
        Y9ZtTZSPLNeG5QmwQkdpsdADSwd10DInYUGS44hH9YkaF7zoTcmDEKMFJKQSo+EaCUbjvmfZRaOT+
        Fslvq1PhA/2XIP1FVDJ6gsObNe9jSJWV0qymX9tQ4eqaV/F9OhxifebTXFFT52vNbBeWX0rN5rjcI
        bBzgCpTg==;
Received: from 201-27-35-168.dsl.telesp.net.br ([201.27.35.168] helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oZv3a-0081yC-2g; Sun, 18 Sep 2022 16:14:02 +0200
Message-ID: <09016e20-5b38-3650-24bf-5fd649ee9b93@igalia.com>
Date:   Sun, 18 Sep 2022 11:13:28 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH V3 11/11] panic: Fixes the panic_print NMI backtrace
 setting
Content-Language: en-US
To:     akpm@linux-foundation.org, kexec@lists.infradead.org
Cc:     bhe@redhat.com, pmladek@suse.com, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
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
        will@kernel.org, xuqiang36@huawei.com
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-12-gpiccoli@igalia.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20220819221731.480795-12-gpiccoli@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/08/2022 19:17, Guilherme G. Piccoli wrote:
> Commit 8d470a45d1a6 ("panic: add option to dump all CPUs backtraces in panic_print")
> introduced a setting for the "panic_print" kernel parameter to allow
> users to request a NMI backtrace on panic. Problem is that the panic_print
> handling happens after the secondary CPUs are already disabled, hence
> this option ended-up being kind of a no-op - kernel skips the NMI trace
> in idling CPUs, which is the case of offline CPUs.
> 
> Fix it by checking the NMI backtrace bit in the panic_print prior to
> the CPU disabling function.
> 
> Fixes: 8d470a45d1a6 ("panic: add option to dump all CPUs backtraces in panic_print")
> Cc: Feng Tang <feng.tang@intel.com>
> Cc: Petr Mladek <pmladek@suse.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> 
> ---
> 
> V3:
> - No changes.
> 
> V2:
> - new patch, there was no V1 of this one.
> 
> Hi folks, thanks upfront for reviews. This is a new patch, fixing an issue
> I found in my tests, so I shoved it into this fixes series.
> 
> Notice that while at it, I got rid of the "crash_kexec_post_notifiers"
> local copy in panic(). This was introduced by commit b26e27ddfd2a
> ("kexec: use core_param for crash_kexec_post_notifiers boot option"),
> but it is not clear from comments or commit message why this local copy
> is required.
> 
> My understanding is that it's a mechanism to prevent some concurrency,
> in case some other CPU modify this variable while panic() is running.
> I find it very unlikely, hence I removed it - but if people consider
> this copy needed, I can respin this patch and keep it, even providing a
> comment about that, in order to be explict about its need.
> 
> Let me know your thoughts! Cheers,
> 
> Guilherme
> 
> 
>  kernel/panic.c | 47 +++++++++++++++++++++++++++--------------------
>  1 file changed, 27 insertions(+), 20 deletions(-)
> [...]

Hi Andrew, sorry for the ping.

Does the patch makes sense for you? Any comments are much appreciated!
Tnx in advance,


Guilherme
