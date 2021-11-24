Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533BE45B6ED
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbhKXIw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 03:52:58 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:28101 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbhKXIw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 03:52:57 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HzZPs5w9Vz1DJWN;
        Wed, 24 Nov 2021 16:47:13 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 24 Nov 2021 16:49:45 +0800
Subject: Re: [RFC] [PATCH bpf-next 1/1] bpf: Clear the noisy tail buffer for
 bpf_d_path() helper
To:     xufeng zhang <yunbo.xufeng@linux.alibaba.com>, <jolsa@kernel.org>,
        <kpsingh@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>, <ast@kernel.org>,
        <andriin@fb.com>
References: <20211120051839.28212-1-yunbo.xufeng@linux.alibaba.com>
 <20211120051839.28212-2-yunbo.xufeng@linux.alibaba.com>
 <9c83d1c1-f8da-8c5b-74dc-d763ab444774@linux.alibaba.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <26009981-d1a4-ff37-ca60-f21a43fc7a8c@huawei.com>
Date:   Wed, 24 Nov 2021 16:49:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <9c83d1c1-f8da-8c5b-74dc-d763ab444774@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 11/24/2021 12:15 PM, xufeng zhang wrote:
> Jiri and KP,
>
> Any suggestion?
>
>
> Thanks in advance!
>
> Xufeng
>
> 在 2021/11/20 下午1:18, Xufeng Zhang 写道:
>> From: "Xufeng Zhang" <yunbo.xufeng@linux.alibaba.com>
>>
>> The motivation behind this change is to use the returned full path
>> for lookup keys in BPF_MAP_TYPE_HASH map.
>> bpf_d_path() prepend the path string from the end of the input
>> buffer, and call memmove() to copy the full path from the tail
>> buffer to the head of buffer before return. So although the
>> returned buffer string is NULL terminated, there is still
>> noise data at the tail of buffer.
>> If using the returned full path buffer as the key of hash map,
>> the noise data is also calculated and makes map lookup failed.
>> To resolve this problem, we could memset the noisy tail buffer
>> before return.
>>
>> Signed-off-by: Xufeng Zhang <yunbo.xufeng@linux.alibaba.com>
>> ---
>>   kernel/trace/bpf_trace.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
>> index 25ea521fb8f1..ec4a6823c024 100644
>> --- a/kernel/trace/bpf_trace.c
>> +++ b/kernel/trace/bpf_trace.c
>> @@ -903,6 +903,8 @@ BPF_CALL_3(bpf_d_path, struct path *, path, char *, buf,
>> u32, sz)
>>       } else {
>>           len = buf + sz - p;
>>           memmove(buf, p, len);
>> +        /* Clear the noisy tail buffer before return */
>> +        memset(buf + len, 0, sz - len);
Is implementing bpf_memset() helper a better idea ? So those who need to
clear the buffer after the terminated null character can use the helper to
do that.

Regards,
Tao

>>       }
>>         return len;
> .

