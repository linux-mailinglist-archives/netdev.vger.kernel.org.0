Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C69695EB64D
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 02:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbiI0Ad2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 20:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiI0Ad1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 20:33:27 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDEBEFF46
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 17:33:24 -0700 (PDT)
Message-ID: <dd9b012f-88a2-c9fe-7ee2-863909e33e25@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1664238802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/DNby/GviBEULSsDu+yPNukckm2SDOt+ya98SfHJin4=;
        b=QeH/LmkGUsIPPYxrArHZ7yxi/vnVj2e2NZU7QurFa347kJJ3wUPUWnazYWozBadDGIszaz
        DWDq0Q8eiYBHsP0cIWG7rQ+Tw3UqJZF1jEulu3znMT+1TSM9bkFR8Hk8j9YoTQQDOGGWi4
        CY8X9YE66bJgAQxWEtYrsh5YoDxmqPA=
Date:   Mon, 26 Sep 2022 17:33:18 -0700
MIME-Version: 1.0
Subject: Re: Use of uninit value in inet_bind2_bucket_find
Content-Language: en-US
To:     Alexander Potapenko <glider@google.com>
Cc:     Networking <netdev@vger.kernel.org>, joannelkoong@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
References: <CAG_fn=Ud3zSW7AZWXc+asfMhZVL5ETnvuY44Pmyv4NPv-ijN-A@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CAG_fn=Ud3zSW7AZWXc+asfMhZVL5ETnvuY44Pmyv4NPv-ijN-A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/19/22 6:41 AM, Alexander Potapenko wrote:
> Hi Joanne, Jakub et al.,
> 
> When building next-20220919 with KMSAN I am seeing the following error
> at boot time:
> 
> =====================================================
> BUG: KMSAN: uninit-value in inet_bind2_bucket_find+0x71f/0x790
> net/ipv4/inet_hashtables.c:827
>   inet_bind2_bucket_find+0x71f/0x790 net/ipv4/inet_hashtables.c:827
>   inet_csk_get_port+0x2415/0x32e0 net/ipv4/inet_connection_sock.c:529
>   __inet6_bind+0x1474/0x1a20 net/ipv6/af_inet6.c:406
>   inet6_bind+0x176/0x360 net/ipv6/af_inet6.c:465
>   __sys_bind+0x5b3/0x750 net/socket.c:1776
>   __do_sys_bind net/socket.c:1787
>   __se_sys_bind net/socket.c:1785
>   __x64_sys_bind+0x8d/0xe0 net/socket.c:1785
>   do_syscall_x64 arch/x86/entry/common.c:50
>   do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd ??:?
> 
> Uninit was created at:
>   slab_post_alloc_hook+0x156/0xb40 mm/slab.h:759
>   slab_alloc_node mm/slub.c:3331
>   slab_alloc mm/slub.c:3339
>   __kmem_cache_alloc_lru mm/slub.c:3346
>   kmem_cache_alloc+0x47e/0x9f0 mm/slub.c:3355
>   inet_bind2_bucket_create+0x4b/0x3b0 net/ipv4/inet_hashtables.c:128
>   inet_csk_get_port+0x2513/0x32e0 net/ipv4/inet_connection_sock.c:533
>   __inet_bind+0xbd2/0x1040 net/ipv4/af_inet.c:525
>   inet_bind+0x184/0x360 net/ipv4/af_inet.c:456
>   __sys_bind+0x5b3/0x750 net/socket.c:1776
>   __do_sys_bind net/socket.c:1787
>   __se_sys_bind net/socket.c:1785
>   __x64_sys_bind+0x8d/0xe0 net/socket.c:1785
>   do_syscall_x64 arch/x86/entry/common.c:50
>   do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x63/0xcd ??:?
> 
> CPU: 3 PID: 5983 Comm: sshd Not tainted 6.0.0-rc6-next-20220919 #211
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.16.0-debian-1.16.0-4 04/01/2014
> =====================================================
> 
> I think this is related to "net: Add a bhash2 table hashed by port and
> address", could you please take a look?
> This error is not reported on v6.0-rc5 (note that KMSAN only exists in
> -next and as a v6.0-rc5 fork at https://github.com/google/kmsan).

Hi Alex, thanks for the report.

I have posted a fix [0].  I have problem getting kmsan kernel to boot. 
Could you help to give the patch a try ?  Thanks.

[0]: https://lore.kernel.org/netdev/20220927002544.3381205-1-kafai@fb.com/
