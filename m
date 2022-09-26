Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6A15EAC3C
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 18:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236556AbiIZQPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 12:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236346AbiIZQPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 12:15:02 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061A6474C8;
        Mon, 26 Sep 2022 08:03:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A52A71F37C;
        Mon, 26 Sep 2022 15:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1664204628; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=01qeiKj0xPZt2yV6W9R9BgcSaKJv5A3vVLXYXTwM4w8=;
        b=SA5M+y6N23TqcIqPGlbRc8oqT4Uuy+p5dMYFN6WK0NLkUGq8Jt47jRsNmOCMh7YcSh/8RF
        LCdmh9VcU3hX5sHLScUc+6omIv5MwG0GIJWHSlbv2lu2UkwbRQr2dOxIyoM0iIpUlhvr8/
        QQkGXKB8V93LkmHWKWIjfY59ALczuio=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1664204628;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=01qeiKj0xPZt2yV6W9R9BgcSaKJv5A3vVLXYXTwM4w8=;
        b=bpEZ+jbhguY6P5sWORLAfxVIAwXXbwTT42WVUWUo9x1rPZv1LPnR+RQ5p4UbYjP3C5dwcW
        VCB47nBmhxhz4hDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7071413486;
        Mon, 26 Sep 2022 15:03:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HQsSGlS/MWOBGgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Mon, 26 Sep 2022 15:03:48 +0000
Message-ID: <76d0cb2b-a963-b867-4399-3e3c4828ecc4@suse.cz>
Date:   Mon, 26 Sep 2022 17:03:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH mm] mm: fix BUG with kvzalloc+GFP_ATOMIC
Content-Language: en-US
To:     Uladzislau Rezki <urezki@gmail.com>,
        Florian Westphal <fw@strlen.de>
Cc:     Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Martin Zaharinov <micron10@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
References: <20220923103858.26729-1-fw@strlen.de>
 <Yy20toVrIktiMSvH@dhcp22.suse.cz> <20220923133512.GE22541@breakpoint.cc>
 <Yy3GL12BOgp3wLjI@pc636> <20220923145409.GF22541@breakpoint.cc>
 <Yy3MS2uhSgjF47dy@pc636>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <Yy3MS2uhSgjF47dy@pc636>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/22 17:10, Uladzislau Rezki wrote:
> On Fri, Sep 23, 2022 at 04:54:09PM +0200, Florian Westphal wrote:
>> Uladzislau Rezki <urezki@gmail.com> wrote:
>>> On Fri, Sep 23, 2022 at 03:35:12PM +0200, Florian Westphal wrote:
>>>> Michal Hocko <mhocko@suse.com> wrote:
>>>>> On Fri 23-09-22 12:38:58, Florian Westphal wrote:
>>>>>> Martin Zaharinov reports BUG() in mm land for 5.19.10 kernel:
>>>>>>   kernel BUG at mm/vmalloc.c:2437!
>>>>>>   invalid opcode: 0000 [#1] SMP
>>>>>>   CPU: 28 PID: 0 Comm: swapper/28 Tainted: G        W  O      5.19.9 #1
>>>>>>   [..]
>>>>>>   RIP: 0010:__get_vm_area_node+0x120/0x130
>>>>>>    __vmalloc_node_range+0x96/0x1e0
>>>>>>    kvmalloc_node+0x92/0xb0
>>>>>>    bucket_table_alloc.isra.0+0x47/0x140
>>>>>>    rhashtable_try_insert+0x3a4/0x440
>>>>>>    rhashtable_insert_slow+0x1b/0x30
>>>>>>   [..]
>>>>>>
>>>>>> bucket_table_alloc uses kvzallocGPF_ATOMIC).  If kmalloc fails, this now
>>>>>> falls through to vmalloc and hits code paths that assume GFP_KERNEL.
>>>>>>
>>>>>> Revert the problematic change and stay with slab allocator.
>>>>>
>>>>> Why don't you simply fix the caller?
>>>>
>>>> Uh, not following?
>>>>
>>>> kvzalloc(GFP_ATOMIC) was perfectly fine, is this illegal again?
>>>>
>>> <snip>
>>> static struct vm_struct *__get_vm_area_node(unsigned long size,
>>> 		unsigned long align, unsigned long shift, unsigned long flags,
>>> 		unsigned long start, unsigned long end, int node,
>>> 		gfp_t gfp_mask, const void *caller)
>>> {
>>> 	struct vmap_area *va;
>>> 	struct vm_struct *area;
>>> 	unsigned long requested_size = size;
>>>
>>> 	BUG_ON(in_interrupt());
>>> ...
>>> <snip>
>>>
>>> vmalloc is not supposed to be called from the IRQ context.
>>
>> It uses kvzalloc, not vmalloc api.
>>
>> Before 2018, rhashtable did use kzalloc OR kvzalloc, depending on gfp_t.
>>
>> Quote from 93f976b5190df327939 changelog:
>>    As of ce91f6ee5b3b ("mm: kvmalloc does not fallback to vmalloc for
>>    incompatible gfp flags") we can simplify the caller
>>    and trust kvzalloc() to just do the right thing.
>>
>> I fear that if this isn't allowed it will result in hard-to-spot bugs
>> because things will work fine until a fallback to vmalloc happens.
>>
>> rhashtable may not be the only user of kvmalloc api that rely on
>> ability to call it from (soft)irq.
>>
> Doing the "p = kmalloc(sizeof(*p), GFP_ATOMIC);" from an atomic context
> is also a problem nowadays. Such code should be fixed across the kernel
> because of PREEMPT_RT support.

But the "atomic context" here is different, no? Calling kmalloc() from 
IRQ handlers AFAIK is ok as IRQ handlers are threaded on PREEMPT_RT. 
Calling it inside an local_irq_disable() would be a problem on the other 
hand. But then under e.g. spin_lock_irqsave() could be ok as those don't 
really disable irqs on RT.

> --
> Uladzislau Rezki

