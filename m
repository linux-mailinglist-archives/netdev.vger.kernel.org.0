Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB6146F729
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 00:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbhLIXHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 18:07:18 -0500
Received: from www62.your-server.de ([213.133.104.62]:60744 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbhLIXHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 18:07:17 -0500
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mvSRw-00065Z-Vc; Fri, 10 Dec 2021 00:03:41 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mvSRw-000LQG-OQ; Fri, 10 Dec 2021 00:03:40 +0100
Subject: Re: [PATCH] bpf: return EOPNOTSUPP when JIT is needed and not
 possible
To:     Ido Schimmel <idosch@idosch.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org
References: <20211209134038.41388-1-cascardo@canonical.com>
 <61b2536e5161d_6bfb2089@john.notmuch> <YbJZoK+qBEiLAxxM@shredder>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b294e66b-0bac-008b-52b4-6f1a90215baa@iogearbox.net>
Date:   Fri, 10 Dec 2021 00:03:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <YbJZoK+qBEiLAxxM@shredder>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26378/Thu Dec  9 10:21:16 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/9/21 8:31 PM, Ido Schimmel wrote:
> On Thu, Dec 09, 2021 at 11:05:18AM -0800, John Fastabend wrote:
>> Thadeu Lima de Souza Cascardo wrote:
>>> When a CBPF program is JITed and CONFIG_BPF_JIT_ALWAYS_ON is enabled, and
>>> the JIT fails, it would return ENOTSUPP, which is not a valid userspace
>>> error code.  Instead, EOPNOTSUPP should be returned.
>>>
>>> Fixes: 290af86629b2 ("bpf: introduce BPF_JIT_ALWAYS_ON config")
>>> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
>>> ---
>>>   kernel/bpf/core.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
>>> index de3e5bc6781f..5c89bae0d6f9 100644
>>> --- a/kernel/bpf/core.c
>>> +++ b/kernel/bpf/core.c
>>> @@ -1931,7 +1931,7 @@ struct bpf_prog *bpf_prog_select_runtime(struct bpf_prog *fp, int *err)
>>>   		fp = bpf_int_jit_compile(fp);
>>>   		bpf_prog_jit_attempt_done(fp);
>>>   		if (!fp->jited && jit_needed) {
>>> -			*err = -ENOTSUPP;
>>> +			*err = -EOPNOTSUPP;
>>>   			return fp;
>>>   		}
>>>   	} else {
>>
>> It seems BPF subsys returns ENOTSUPP in multiple places. This fixes one
>> paticular case and is user facing. Not sure we want to one-off fix them
>> here creating user facing changes over multiple kernel versions. On the
>> fence with this one curious to see what others think. Haven't apps
>> already adapted to the current convention or they don't care?
> 
> Similar issue was discussed in the past. See:
> https://lore.kernel.org/netdev/20191204.125135.750458923752225025.davem@davemloft.net/

With regards to ENOTSUPP exposure, if the consensus is that we should fix all
occurences over to EOPNOTSUPP even if they've been exposed for quite some time
(Jakub?), we could give this patch a try maybe via bpf-next and see if anyone
complains.

Thadeu, I think you also need to fix up BPF selftests as test_verifier, to mention
one example (there are also bunch of others under tools/testing/selftests/), is
checking for ENOTSUPP specifically..

Thanks,
Daniel
