Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC65045D29C
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 02:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243816AbhKYBw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 20:52:57 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:37614 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245252AbhKYBvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 20:51:10 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=yunbo.xufeng@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UyBz7c0_1637804876;
Received: from IT-C02XP11YJHD2.local(mailfrom:yunbo.xufeng@linux.alibaba.com fp:SMTPD_---0UyBz7c0_1637804876)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 25 Nov 2021 09:47:58 +0800
Subject: Re: [RFC] [PATCH bpf-next 1/1] bpf: Clear the noisy tail buffer for
 bpf_d_path() helper
To:     Hou Tao <houtao1@huawei.com>, jolsa@kernel.org, kpsingh@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        andriin@fb.com
References: <20211120051839.28212-1-yunbo.xufeng@linux.alibaba.com>
 <20211120051839.28212-2-yunbo.xufeng@linux.alibaba.com>
 <9c83d1c1-f8da-8c5b-74dc-d763ab444774@linux.alibaba.com>
 <26009981-d1a4-ff37-ca60-f21a43fc7a8c@huawei.com>
From:   xufeng zhang <yunbo.xufeng@linux.alibaba.com>
Message-ID: <cd06789a-9f10-097f-0dce-6c1dad2089d1@linux.alibaba.com>
Date:   Thu, 25 Nov 2021 09:47:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <26009981-d1a4-ff37-ca60-f21a43fc7a8c@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tao,

在 2021/11/24 下午4:49, Hou Tao 写道:
> Hi,
>
> On 11/24/2021 12:15 PM, xufeng zhang wrote:
>> Jiri and KP,
>>
>> Any suggestion?
>>
>>
>> Thanks in advance!
>>
>> Xufeng
>>
>> 在 2021/11/20 下午1:18, Xufeng Zhang 写道:
>>> From: "Xufeng Zhang" <yunbo.xufeng@linux.alibaba.com>
>>>
>>> The motivation behind this change is to use the returned full path
>>> for lookup keys in BPF_MAP_TYPE_HASH map.
>>> bpf_d_path() prepend the path string from the end of the input
>>> buffer, and call memmove() to copy the full path from the tail
>>> buffer to the head of buffer before return. So although the
>>> returned buffer string is NULL terminated, there is still
>>> noise data at the tail of buffer.
>>> If using the returned full path buffer as the key of hash map,
>>> the noise data is also calculated and makes map lookup failed.
>>> To resolve this problem, we could memset the noisy tail buffer
>>> before return.
>>>
>>> Signed-off-by: Xufeng Zhang <yunbo.xufeng@linux.alibaba.com>
>>> ---
>>>    kernel/trace/bpf_trace.c | 2 ++
>>>    1 file changed, 2 insertions(+)
>>>
>>> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
>>> index 25ea521fb8f1..ec4a6823c024 100644
>>> --- a/kernel/trace/bpf_trace.c
>>> +++ b/kernel/trace/bpf_trace.c
>>> @@ -903,6 +903,8 @@ BPF_CALL_3(bpf_d_path, struct path *, path, char *, buf,
>>> u32, sz)
>>>        } else {
>>>            len = buf + sz - p;
>>>            memmove(buf, p, len);
>>> +        /* Clear the noisy tail buffer before return */
>>> +        memset(buf + len, 0, sz - len);
> Is implementing bpf_memset() helper a better idea ? So those who need to
> clear the buffer after the terminated null character can use the helper to
> do that.

This is a good point.

I think the reason why mainline has not such a helper yet is because a 
LLVM __builtin_memset() is

already available, but clearly this __builtin_memset() has too much 
limitation which can't meet all the needs,

there might be other concerns to implement such a memset helper which I 
don't know, but I think your suggestion

is a good idea.


Xufeng


>
> Regards,
> Tao
>
>>>        }
>>>          return len;
>> .
