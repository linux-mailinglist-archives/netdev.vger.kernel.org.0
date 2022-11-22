Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890B5633EF9
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233974AbiKVObN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233953AbiKVObH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:31:07 -0500
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304CF6A6B7;
        Tue, 22 Nov 2022 06:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rSYIGGtjZljFBal86Avbxge1dAX05jgxf9qrktsTsB8=; b=MX800+aYXTdyYof4USzixvuPvg
        9FbkPgWEf4yn5YKSZ6YZvZYMUIrJ83siHY3JDQnjBib+dAZOvIjPcv4rwFWWZmC8nuU/CNyqTv37J
        LI9uahtiyTlFT5sg3l2Jt6DAPlbV/eGuCYZHMx1mJgP8y9VUP0QV5AhKWiiwBT3/TtAdOZxoHUjGo
        wBjoV4n84SXGRfQJ1FQgM2titKAX9RMXtyQrLP2E1UPM76R5ywtg8b8JzSylFz4KM6CKbhsW2RDhw
        2Wuo/c750D1OMJECUK35f1MTpZl3Tuqe5CqaKSXYSU2Si3ILxqlcvyZFxEYL6RqkDNw1VeQ19rA9/
        QwSDYHeg==;
Received: from [177.102.6.147] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oxTR5-006yBT-L8; Tue, 22 Nov 2022 14:35:39 +0100
Message-ID: <831175d7-1b30-de61-d6c5-cbb91e4fdcfb@igalia.com>
Date:   Tue, 22 Nov 2022 10:35:34 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH V3 11/11] panic: Fixes the panic_print NMI backtrace
 setting
Content-Language: en-US
To:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        feng.tang@intel.com
Cc:     kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-12-gpiccoli@igalia.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20220819221731.480795-12-gpiccoli@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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

Hi folks, bi-monthly ping - apologies for the noise heh

Is there anything suggested so we can get this fix merged in 6.2? Any
suggestions / reviews are much appreciated.

Tnx in advance,


Guilherme
