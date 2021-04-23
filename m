Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BE636919E
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 13:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242152AbhDWL6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 07:58:02 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:58168 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230431AbhDWL6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 07:58:01 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=abaci@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UWVQKet_1619179042;
Received: from B-V3K2HV2H-1858.local(mailfrom:abaci@linux.alibaba.com fp:SMTPD_---0UWVQKet_1619179042)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 23 Apr 2021 19:57:23 +0800
Subject: Re: [PATCH] selftests/bpf: fix warning comparing pointer to 0
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1619085648-36826-1-git-send-email-jiapeng.chong@linux.alibaba.com>
 <7ecb85e6-410b-65bb-a042-74045ee17c3f@iogearbox.net>
From:   Abaci Robot <abaci@linux.alibaba.com>
Message-ID: <93957f3e-2274-c389-64a4-235ed8a228bf@linux.alibaba.com>
Date:   Fri, 23 Apr 2021 19:57:22 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <7ecb85e6-410b-65bb-a042-74045ee17c3f@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2021/4/23 上午5:56, Daniel Borkmann 写道:
> On 4/22/21 12:00 PM, Jiapeng Chong wrote:
>> Fix the following coccicheck warning:
>>
>> ./tools/testing/selftests/bpf/progs/fentry_test.c:76:15-16: WARNING
>> comparing pointer to 0.
>>
>> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
>> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> How many more of those 'comparing pointer to 0' patches do you have?
> Right now we already merged the following with similar trivial pattern:
> 
> - ebda107e5f222a086c83ddf6d1ab1da97dd15810
> - a9c80b03e586fd3819089fbd33c38fb65ad5e00c
> - 04ea63e34a2ee85cfd38578b3fc97b2d4c9dd573
> 
> Given they don't really 'fix' anything, I would like to reduce such
> patch cleanup churn on the bpf tree. Please _consolidate_ all other
> such occurrences into a _single_ patch for BPF selftests, and resubmit.
> 
> Thanks!
> 
>> ---
>>   tools/testing/selftests/bpf/progs/fentry_test.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/bpf/progs/fentry_test.c 
>> b/tools/testing/selftests/bpf/progs/fentry_test.c
>> index 52a550d..d4247d6 100644
>> --- a/tools/testing/selftests/bpf/progs/fentry_test.c
>> +++ b/tools/testing/selftests/bpf/progs/fentry_test.c
>> @@ -73,7 +73,7 @@ int BPF_PROG(test7, struct bpf_fentry_test_t *arg)
>>   SEC("fentry/bpf_fentry_test8")
>>   int BPF_PROG(test8, struct bpf_fentry_test_t *arg)
>>   {
>> -    if (arg->a == 0)
>> +    if (!arg->a)
>>           test8_result = 1;
>>       return 0;
>>   }
>>

Hi,

Thanks for your reply.

TLDR:
1. Now all this kind of warning in tools/testing/selftests/bpf/progs/ 
were reported and discussed except this one.
2. We might not do scanning and check reports on 
tools/testing/selftests/bpf/progs/ in the future, because some 
contributors want the progs to stay as close as possible to the way they 
were written. 
(https://patchwork.kernel.org/project/linux-kselftest/patch/1618307549-78149-1-git-send-email-yang.lee@linux.alibaba.com/)


Details:

We have checked the recent linux master (commit: 
16fc44d6387e260f4932e9248b985837324705d8), and the related reports and 
their current status is shown as follows:

./tools/testing/selftests/bpf/progs/fentry_test.c:67:12-13: WARNING 
comparing pointer to 0
(not appear in the bpf-next branch)


./tools/testing/selftests/bpf/progs/fentry_test.c:76:15-16: WARNING 
comparing pointer to 0
(the above patch try to eliminate it)


./tools/testing/selftests/bpf/progs/fexit_test.c:68:12-13: WARNING 
comparing pointer to 0
./tools/testing/selftests/bpf/progs/fexit_test.c:77:15-16: WARNING 
comparing pointer to 0
(eliminated in 
https://kernel.source.codeaurora.cn/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=ebda107e5f222a086c83ddf6d1ab1da97dd15810)

./tools/testing/selftests/bpf/progs/profiler.inc.h:364:18-22: WARNING 
comparing pointer to 0
./tools/testing/selftests/bpf/progs/profiler.inc.h:364:18-22: WARNING 
comparing pointer to 0, suggest !E
./tools/testing/selftests/bpf/progs/profiler.inc.h:537:23-27: WARNING 
comparing pointer to 0
./tools/testing/selftests/bpf/progs/profiler.inc.h:537:23-27: WARNING 
comparing pointer to 0, suggest !E
./tools/testing/selftests/bpf/progs/profiler.inc.h:544:21-25: WARNING 
comparing pointer to 0
./tools/testing/selftests/bpf/progs/profiler.inc.h:544:21-25: WARNING 
comparing pointer to 0, suggest !E
./tools/testing/selftests/bpf/progs/profiler.inc.h:692:29-33: WARNING 
comparing pointer to 0
./tools/testing/selftests/bpf/progs/profiler.inc.h:770:13-17: WARNING 
comparing pointer to 0
(Discussed in 
https://patchwork.kernel.org/project/linux-kselftest/patch/1618307549-78149-1-git-send-email-yang.lee@linux.alibaba.com/)

./tools/testing/selftests/bpf/progs/test_global_func10.c:17:12-13: 
WARNING comparing pointer to 0
(cleanup in 
https://kernel.source.codeaurora.cn/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=04ea63e34a2ee85cfd38578b3fc97b2d4c9dd573)

Thanks.
