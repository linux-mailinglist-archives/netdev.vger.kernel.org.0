Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAC51D93F4
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 12:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbgESKEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 06:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728633AbgESKEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 06:04:07 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41635C061A0C
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 03:04:06 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id m18so4666031ljo.5
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 03:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dSgfGSiNnkbOZ8VPXvhcr90CHXRE+3/2DUWDJQppWe0=;
        b=JR1/7/YYQFwYrnKlWsTHkrsd+uf0HL5hTGgX6xUzM0pu4VZeydp0HrukGPUNFXU0y/
         LR+LUeUs/fd+c8mNF1m9A8xEoC7azf10uJ3FEWMY4jjyepV5LNsjdJ6RAfy1Ia+FlUVv
         QvJRXtFC1+PvUEVHLFvNuaxIwe9r32fa+6ABE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dSgfGSiNnkbOZ8VPXvhcr90CHXRE+3/2DUWDJQppWe0=;
        b=DjGxz/MYOKit2VY38oj4bgHm20XKmEdFX5WV95pQI2B+eXFYkVCyQnjwZweULbb/Sp
         NuV0haN3VqfBq+l+t8VO7f/+H9NknX/XIRd1VzfCCGw4nXgZA2vOI5N2VeB36+Gof82y
         v6PFXHn1eEv7/gxMWeYIaLhq3CPi8JGqngujpRKvzSi4dKdGogBjwKDn/HuFtvB/8vxp
         KdAp0wHVT6B71H/THrmrkHve3EdXeAokTXpCuqQC5vzAyzg7k0ly84hYXV8bgzex7+UE
         5nDEh+U9FRIyH0YpqtMH5SMbD1ygh3Y2BgGpiJjFlkMp7iM0dWnD4p+payjNbUYdN03q
         S+AQ==
X-Gm-Message-State: AOAM532M+bWkOmdZoKyZfHi8QmLKoaS9w2cqcGnAVM/t1KCvWvQopt94
        rJRtDk2IOKZrBhI8j6luEp9pgQ==
X-Google-Smtp-Source: ABdhPJyq6krE0Ult81m5qKpR5JAUbt4Nc4a1+QGMN3KOBfXCY6aVn/WEERZgZWtFJVHPr61Cd4ZzCA==
X-Received: by 2002:a2e:8e7a:: with SMTP id t26mr6318154ljk.150.1589882644625;
        Tue, 19 May 2020 03:04:04 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x28sm2785910lfg.86.2020.05.19.03.04.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 03:04:02 -0700 (PDT)
Subject: Re: [PATCH net-next 1/6] nexthop: dereference nh only once in
 nexthop_select_path
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     David Ahern <dsahern@gmail.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, idosch@mellanox.com,
        petrm@mellanox.com
References: <1589854474-26854-1-git-send-email-roopa@cumulusnetworks.com>
 <1589854474-26854-2-git-send-email-roopa@cumulusnetworks.com>
 <ecd765d8-4e83-dd20-5d71-8c4bb7b30639@gmail.com>
 <999e09f0-2593-d079-e8f4-f9db6f2f85af@cumulusnetworks.com>
Message-ID: <fb3a4d02-8656-abda-a36e-becaee9da36e@cumulusnetworks.com>
Date:   Tue, 19 May 2020 13:04:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <999e09f0-2593-d079-e8f4-f9db6f2f85af@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/05/2020 11:48, Nikolay Aleksandrov wrote:
> On 19/05/2020 06:25, David Ahern wrote:
>> On 5/18/20 8:14 PM, Roopa Prabhu wrote:
>>> From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
>>>
>>> the ->nh pointer might become suddenly null while we're selecting the
>>> path and we may dereference it. Dereference it only once in the
>>> beginning and use that if it's not null, we rely on the refcounting and
>>> rcu to protect against use-after-free. (This is needed for later
>>> vxlan patches that exposes the problem)
>>>
>>> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
>>> Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
>>> ---
>>>  net/ipv4/nexthop.c | 13 +++++++++----
>>>  1 file changed, 9 insertions(+), 4 deletions(-)
>>>
>>
>> Reviewed-by: David Ahern <dsahern@gmail.com>
>>
>> Should this be a bug fix? Any chance the route path can hit it?
>>
> 
> That was fast, I didn't expect to see it on upstream so quickly. :)
> So I haven't had time to inspect it in detail, but it did seem to me
> that it should be possible to hit from the route path. When I tried
> running a few basic tests to make it happen I couldn't mainly due to the
> fib flush done at nexthop removal, but I still believe with the right
> timing one could hit it.
> 
> In fact I'd go 1 step further and add a null check from the return
> of nexthop_select_path() in the helpers which dereference the value it
> returns like:  nexthop_path_fib6_result() and nexthop_path_fib_result()
> 
> The reason is that the .nh ptr is set and read without any sync primitives
> so in theory it can become null at any point (being cleared on nh group removal),
> and also the nh count in a group (num_nh), when it becomes == 0 while destroying a nh group
> and we hit it then in nexthop_select_path() rc would remain == NULL and we'll
> deref a null ptr. We did see the above with the vxlan code due to it missing the equivalent
> of a fib flush (or rather it being more relaxed), but I haven't had time to see how feasible
> it is to hit it via the route path yet.
> 

Actually got it pretty easy via nexthop replace, that nulls .nh and can cause the above
very quickly if running in parallel with some traffic to those routes.

Here's the route NULL ptr deref:
[  322.517290] BUG: kernel NULL pointer dereference, address: 0000000000000070
[  322.517670] #PF: supervisor read access in kernel mode
[  322.517935] #PF: error_code(0x0000) - not-present page
[  322.518213] PGD 0 P4D 0 
[  322.518388] Oops: 0000 [#1] SMP PTI
[  322.518601] CPU: 1 PID: 58185 Comm: ping Not tainted 5.7.0-rc5+ #190
[  322.518911] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
[  322.519490] RIP: 0010:fib_select_multipath+0x5a/0x2ac
[  322.519776] Code: 85 db 48 89 44 24 08 40 0f 95 c6 31 c9 31 d2 e8 29 13 93 ff 48 85 db 74 58 48 8b 45 18 8b 74 24 04 48 8b 78 68 e8 81 b7 00 00 <48> 8b 58 70 e8 6c 04 8b ff 85 c0 74 31 80 3d cd 89 d4 00 00 75 28
[  322.520536] RSP: 0018:ffff888228f6bac0 EFLAGS: 00010286
[  322.520813] RAX: 0000000000000000 RBX: ffff888228cc3c00 RCX: 0000000000000000
[  322.521152] RDX: ffff888222215080 RSI: ffff888222215930 RDI: ffff888222215080
[  322.521478] RBP: ffff888228f6bbd8 R08: ffff888222215930 R09: 0000000000020377
[  322.521815] R10: 0000000000000000 R11: 784deca9f66dea1e R12: 0000000000000000
[  322.522143] R13: ffff88822a099000 R14: ffff888228f6bbd8 R15: ffffffff8258cc80
[  322.522491] FS:  00007fc5ee6a8000(0000) GS:ffff88822bc80000(0000) knlGS:0000000000000000
[  322.522862] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  322.523236] CR2: 0000000000000070 CR3: 0000000222954001 CR4: 0000000000360ee0
[  322.523657] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  322.524060] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  322.524461] Call Trace:
[  322.524707]  fib_select_path+0x5a/0x2c8
[  322.524998]  ip_route_output_key_hash_rcu+0x2d6/0x636
[  322.525372]  ip_route_output_key_hash+0x9f/0xb6
[  322.525697]  ip_route_output_flow+0x1c/0x58
[  322.525990]  raw_sendmsg+0x5e9/0xca4
[  322.526261]  ? mark_lock+0x68/0x24d
[  322.526536]  ? lock_acquire+0x233/0x24f
[  322.526823]  ? raw_abort+0x3f/0x3f
[  322.527086]  ? inet_send_prepare+0x3b/0x3b
[  322.527418]  ? sock_sendmsg_nosec+0x4f/0x9b
[  322.527721]  ? raw_abort+0x3f/0x3f
[  322.527984]  sock_sendmsg_nosec+0x4f/0x9b
[  322.528274]  __sys_sendto+0xdd/0x100
[  322.528551]  ? sockfd_lookup_light+0x72/0x96
[  322.528851]  ? trace_hardirqs_on_thunk+0x1a/0x1c
[  322.529159]  __x64_sys_sendto+0x25/0x28
[  322.529442]  do_syscall_64+0xd1/0xe1
[  322.529719]  entry_SYSCALL_64_after_hwframe+0x49/0xb3




