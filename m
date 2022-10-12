Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414275FCE4E
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 00:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiJLWUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 18:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiJLWUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 18:20:09 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757395B041;
        Wed, 12 Oct 2022 15:20:07 -0700 (PDT)
Message-ID: <16bcda3b-989e-eadf-b6c3-803470b0afd6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665613205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XPnFWAerAeXy7NqqbkBgHG7dHkoWQXwMsB4p5t6ekQw=;
        b=oZ3pOq5xCw/PRsR1W+ITyjKzMuegcr37NX/899mYpwjVeZkZBE23mDs3AYoGpt7egnvRw/
        Jm7GRr3URKKvoL6oDmbS1aiq2gzLqqlBtBfnvhTCEDsCKgRj9tQW9SyS7Cn+BHPhZqE2/g
        QF65ECQ+qgrEYR5xm1M7n7cdCAWj/CU=
Date:   Wed, 12 Oct 2022 15:20:01 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v4 2/3] selftests/bpf: Add connmark read test
Content-Language: en-US
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        bpf@vger.kernel.org, memxor@gmail.com
References: <cover.1660254747.git.dxu@dxuuu.xyz>
 <d3bc620a491e4c626c20d80631063922cbe13e2b.1660254747.git.dxu@dxuuu.xyz>
 <43bf4a5f-dac9-4fe9-1eba-9ab9beb650aa@linux.dev>
 <20221012220953.i2xevhu36kxyxscl@k2>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221012220953.i2xevhu36kxyxscl@k2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/22 3:09 PM, Daniel Xu wrote:
> Hi Martin,
> 
> On Tue, Oct 11, 2022 at 10:49:32PM -0700, Martin KaFai Lau wrote:
>> On 8/11/22 2:55 PM, Daniel Xu wrote:
>>> Test that the prog can read from the connection mark. This test is nice
>>> because it ensures progs can interact with netfilter subsystem
>>> correctly.
>>>
>>> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
>>> Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>>> ---
>>>    tools/testing/selftests/bpf/prog_tests/bpf_nf.c | 3 ++-
>>>    tools/testing/selftests/bpf/progs/test_bpf_nf.c | 3 +++
>>>    2 files changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
>>> index 88a2c0bdefec..544bf90ac2a7 100644
>>> --- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
>>> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
>>> @@ -44,7 +44,7 @@ static int connect_to_server(int srv_fd)
>>>    static void test_bpf_nf_ct(int mode)
>>>    {
>>> -	const char *iptables = "iptables -t raw %s PREROUTING -j CT";
>>> +	const char *iptables = "iptables -t raw %s PREROUTING -j CONNMARK --set-mark 42/0";
>> Hi Daniel Xu, this test starts failing recently in CI [0]:
>>
>> Warning: Extension CONNMARK revision 0 not supported, missing kernel module?
>>    iptables v1.8.8 (nf_tables): Could not fetch rule set generation id:
>> Invalid argument
>>
>>    Warning: Extension CONNMARK revision 0 not supported, missing kernel module?
>>    iptables v1.8.8 (nf_tables): Could not fetch rule set generation id:
>> Invalid argument
>>
>>    Warning: Extension CONNMARK revision 0 not supported, missing kernel module?
>>    iptables v1.8.8 (nf_tables): Could not fetch rule set generation id:
>> Invalid argument
>>
>>    Warning: Extension CONNMARK revision 0 not supported, missing kernel module?
>>    iptables v1.8.8 (nf_tables): Could not fetch rule set generation id:
>> Invalid argument
>>
>>    test_bpf_nf_ct:PASS:test_bpf_nf__open_and_load 0 nsec
>>    test_bpf_nf_ct:FAIL:iptables unexpected error: 1024 (errno 0)
>>
>> Could you help to take a look? Thanks.
>>
>> [0]: https://github.com/kernel-patches/bpf/actions/runs/3231598391/jobs/5291529292
> 
> [...]
> 
> Thanks for letting me know. I took a quick look and it seems that
> synproxy selftest is also failing:
> 
>      2022-10-12T03:14:20.2007627Z test_synproxy:FAIL:iptables -t raw -I PREROUTING      -i tmp1 -p tcp -m tcp --syn --dport 8080 -j CT --notrack unexpected error: 1024 (errno 2)
> 
> Googling the "Could not fetch rule set generation id" yields a lot of
> hits. Most of the links are from downstream projects recommending user
> downgrade iptables (nftables) to iptables-legacy.

Thanks for looking into it!  We have been debugging a bit today also.  I also 
think iptables-legacy is the one to use.  I posted a patch [0].  Let see how the 
CI goes.

The rules that the selftest used is not a lot.  I wonder what it takes to remove 
the iptables command usage from the selftest?

[0]: https://lore.kernel.org/bpf/20221012221235.3529719-1-martin.lau@linux.dev/

> 
> So perhaps iptables/nftables suffered a regression somewhere. I'll take
> a closer look tonight / tomorrow morning.
> 
> Thanks,
> Daniel

