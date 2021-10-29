Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0A34405C8
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 01:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbhJ2Xbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 19:31:36 -0400
Received: from www62.your-server.de ([213.133.104.62]:51428 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhJ2Xbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 19:31:35 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mgbIy-0003Jv-0R; Sat, 30 Oct 2021 01:29:00 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mgbIx-0007ES-Pp; Sat, 30 Oct 2021 01:28:59 +0200
Subject: Re: [PATCH bpf-next] bpf: Fix propagation of bounds from 64-bit
 min/max into 32-bit and var_off.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
References: <20211029163102.80290-1-alexei.starovoitov@gmail.com>
 <2d8df23d-175f-3eb8-3ba4-35659664336c@fb.com>
 <CAADnVQLvwGMsawF9s3wDw9Gh_HJpCTkHTS=0MHLLy+VqapLUWQ@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4c43dc61-d8b8-b179-280f-84bc291583ca@iogearbox.net>
Date:   Sat, 30 Oct 2021 01:28:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAADnVQLvwGMsawF9s3wDw9Gh_HJpCTkHTS=0MHLLy+VqapLUWQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26337/Fri Oct 29 10:19:12 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/29/21 9:22 PM, Alexei Starovoitov wrote:
> On Fri, Oct 29, 2021 at 11:29 AM Yonghong Song <yhs@fb.com> wrote:
>> On 10/29/21 9:31 AM, Alexei Starovoitov wrote:
>>> From: Alexei Starovoitov <ast@kernel.org>
>>>
>>> Before this fix:
>>> 166: (b5) if r2 <= 0x1 goto pc+22
>>> from 166 to 189: R2=invP(id=1,umax_value=1,var_off=(0x0; 0xffffffff))
>>>
>>> After this fix:
>>> 166: (b5) if r2 <= 0x1 goto pc+22
>>> from 166 to 189: R2=invP(id=1,umax_value=1,var_off=(0x0; 0x1))
>>>
>>> While processing BPF_JLE the reg_set_min_max() would set true_reg->umax_value = 1
>>> and call __reg_combine_64_into_32(true_reg).
>>>
>>> Without the fix it would not pass the condition:
>>> if (__reg64_bound_u32(reg->umin_value) && __reg64_bound_u32(reg->umax_value))
>>>
>>> since umin_value == 0 at this point.
>>> Before commit 10bf4e83167c the umin was incorrectly ingored.
>>> The commit 10bf4e83167c fixed the correctness issue, but pessimized
>>> propagation of 64-bit min max into 32-bit min max and corresponding var_off.
>>>
>>> Fixes: 10bf4e83167c ("bpf: Fix propagation of 32 bit unsigned bounds from 64 bit bounds")
>>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>>
>> See an unrelated nits below.
>>
>> Acked-by: Yonghong Song <yhs@fb.com>
>>
>>> ---
>>>    kernel/bpf/verifier.c                               | 2 +-
>>>    tools/testing/selftests/bpf/verifier/array_access.c | 2 +-
>>>    2 files changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>>> index 3c8aa7df1773..29671ed49ee8 100644
>>> --- a/kernel/bpf/verifier.c
>>> +++ b/kernel/bpf/verifier.c
>>> @@ -1425,7 +1425,7 @@ static bool __reg64_bound_s32(s64 a)
>>
>> We have
>> static bool __reg64_bound_s32(s64 a)
>> {
>>           return a > S32_MIN && a < S32_MAX;
>> }
>>
>> Should we change to
>>          return a >= S32_MIN && a <= S32_MAX
>> ?
> 
> Probably, but I haven't investigated that yet.

Fix looks good to me as well, we should make it consistent if so given it's the same
logic, but some tests for the S32 would be good if we don't have them yet.

Thanks!
Daniel
