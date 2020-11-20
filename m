Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712932BAF86
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 17:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730010AbgKTQCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 11:02:07 -0500
Received: from www62.your-server.de ([213.133.104.62]:52972 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728718AbgKTQCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 11:02:06 -0500
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kg8rG-0003lI-FJ; Fri, 20 Nov 2020 17:01:58 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kg8rG-000MkX-6q; Fri, 20 Nov 2020 17:01:58 +0100
Subject: Re: [PATCH] bpf: Check the return value of dev_get_by_index_rcu()
To:     David Ahern <dsahern@gmail.com>, xiakaixu1987@gmail.com,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andrii@kernel.org, john.fastabend@gmail.com, kpsingh@chromium.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
References: <1605769468-2078-1-git-send-email-kaixuxia@tencent.com>
 <65d8f988-5b41-24c2-8501-7cbbddb1238e@iogearbox.net>
 <f8ff26f0-b1b6-6dd1-738d-4c592a8efdb0@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <41aac020-b7af-e83f-0639-252efa4f7fff@iogearbox.net>
Date:   Fri, 20 Nov 2020 17:01:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <f8ff26f0-b1b6-6dd1-738d-4c592a8efdb0@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25994/Fri Nov 20 14:09:26 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/20/20 4:19 PM, David Ahern wrote:
> On 11/20/20 8:13 AM, Daniel Borkmann wrote:
>> [ +David ]
>>
>> On 11/19/20 8:04 AM, xiakaixu1987@gmail.com wrote:
>>> From: Kaixu Xia <kaixuxia@tencent.com>
>>>
>>> The return value of dev_get_by_index_rcu() can be NULL, so here it
>>> is need to check the return value and return error code if it is NULL.
>>>
>>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
>>> ---
>>>    net/core/filter.c | 2 ++
>>>    1 file changed, 2 insertions(+)
>>>
>>> diff --git a/net/core/filter.c b/net/core/filter.c
>>> index 2ca5eecebacf..1263fe07170a 100644
>>> --- a/net/core/filter.c
>>> +++ b/net/core/filter.c
>>> @@ -5573,6 +5573,8 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *,
>>> skb,
>>>            struct net_device *dev;
>>>              dev = dev_get_by_index_rcu(net, params->ifindex);
>>> +        if (unlikely(!dev))
>>> +            return -EINVAL;
>>>            if (!is_skb_forwardable(dev, skb))
>>>                rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;
> 
> rcu lock is held right? It is impossible for dev to return NULL here.

Yes, we're under RCU read side. Was wondering whether we could unlink it
from the list but not yet free it, but also that seems not possible since
we'd first need to close it which already has a synchronize_net(). So not
an issue what Kaixu describes in the commit msg, agree.
