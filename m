Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4C24FA75C
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 13:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240148AbiDILqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 07:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238441AbiDILqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 07:46:01 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC1E635C;
        Sat,  9 Apr 2022 04:43:54 -0700 (PDT)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nd9VP-0001NN-1u; Sat, 09 Apr 2022 13:43:51 +0200
Message-ID: <8665439b-e82e-65b8-ddb6-da6a41d6f6da@leemhuis.info>
Date:   Sat, 9 Apr 2022 13:43:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH bpf 0/2] vmalloc: bpf: introduce VM_ALLOW_HUGE_VMAP
Content-Language: en-US
To:     Song Liu <song@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kernel-team@fb.com, akpm@linux-foundation.org,
        rick.p.edgecombe@intel.com, hch@infradead.org,
        imbrenda@linux.ibm.com
References: <20220408223443.3303509-1-song@kernel.org>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20220408223443.3303509-1-song@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1649504634;d031920e;
X-HE-SMSGID: 1nd9VP-0001NN-1u
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, this is your Linux kernel regression tracker.

On 09.04.22 00:34, Song Liu wrote:
> Enabling HAVE_ARCH_HUGE_VMALLOC on x86_64 and use it for bpf_prog_pack has
> caused some issues [1], as many users of vmalloc are not yet ready to
> handle huge pages. To enable a more smooth transition to use huge page
> backed vmalloc memory, this set replaces VM_NO_HUGE_VMAP flag with an new
> opt-in flag, VM_ALLOW_HUGE_VMAP. More discussions about this topic can be
> found at [2].
> 
> Patch 1 removes VM_NO_HUGE_VMAP and adds VM_ALLOW_HUGE_VMAP.
> Patch 2 uses VM_ALLOW_HUGE_VMAP in bpf_prog_pack.
> 
> [1] https://lore.kernel.org/lkml/20220204185742.271030-1-song@kernel.org/
> [2] https://lore.kernel.org/linux-mm/20220330225642.1163897-1-song@kernel.org/

These patches apparently fix a regression (one that's mentioned in your
[2]) that I tracked. Hence in the next iteration of your patches could
you please instead add a 'Link:' tag pointing to the report for anyone
wanting to look into the backstory in the future, as explained in
'Documentation/process/submitting-patches.rst' and
'Documentation/process/5.Posting.rst'? E.g. like this:

"Link:
https://lore.kernel.org/netdev/14444103-d51b-0fb3-ee63-c3f182f0b546@molgen.mpg.de/"

Not totally sure, but I guess it needs a Fixes tag as well specifying
the change that cause this regression (that's "fac54e2bfb5b"). The
documents mentioned above explain this, too. A "Reported-by" might be
appropriate as well.

In anyone wonders why I care: there are internal and publicly used tools
and scripts out there that reply on proper "Link" tags. I don't known
how many, but there is at least one public tool I'm running that cares:
regzbot, my regression tracking bot, which I use to track Linux kernel
regressions and generate the regression reports sent to Linus. Proper
"Link:" tags allow the bot to automatically connect regression reports
with fixes being posted or applied to resolve the particular regression
-- which makes regression tracking a whole lot easier and feasible for
the Linux kernel. That's why it's a great help for me if people set
proper "Link" tags.

While at it, let me tell regzbot about this thread:
#regzbot ^backmonitor:
https://lore.kernel.org/netdev/14444103-d51b-0fb3-ee63-c3f182f0b546@molgen.mpg.de/

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I'm getting a lot of
reports on my table. I can only look briefly into most of them and lack
knowledge about most of the areas they concern. I thus unfortunately
will sometimes get things wrong or miss something important. I hope
that's not the case here; if you think it is, don't hesitate to tell me
in a public reply, it's in everyone's interest to set the public record
straight.
