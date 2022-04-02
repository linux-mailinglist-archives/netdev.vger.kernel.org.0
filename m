Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A684EFDFC
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 04:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237457AbiDBCks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 22:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiDBCkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 22:40:47 -0400
Received: from 189.cn (ptr.189.cn [183.61.185.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 14186189A27;
        Fri,  1 Apr 2022 19:38:51 -0700 (PDT)
HMM_SOURCE_IP: 10.64.8.43:42730.2126972100
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-123.150.8.42 (unknown [10.64.8.43])
        by 189.cn (HERMES) with SMTP id C2B7B1002B0;
        Sat,  2 Apr 2022 10:38:41 +0800 (CST)
Received: from  ([123.150.8.42])
        by gateway-153622-dep-749df8664c-nmrf6 with ESMTP id d99a69e77d364b26a9abcb0ecc6ee1f3 for yhs@fb.com;
        Sat, 02 Apr 2022 10:38:50 CST
X-Transaction-ID: d99a69e77d364b26a9abcb0ecc6ee1f3
X-Real-From: chensong_2000@189.cn
X-Receive-IP: 123.150.8.42
X-MEDUSA-Status: 0
Sender: chensong_2000@189.cn
Message-ID: <1952745a-40bc-1f42-350b-ed8437e252ce@189.cn>
Date:   Sat, 2 Apr 2022 10:38:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] sample: bpf: syscall_tp_user: print result of verify_map
Content-Language: en-US
To:     Yonghong Song <yhs@fb.com>, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1648777272-21473-1-git-send-email-chensong_2000@189.cn>
 <882349c0-123d-3deb-88e8-d400ec702d1f@fb.com>
 <306ab457-9f3d-4d90-bb31-e6fb08b6a5ad@189.cn>
 <b0b8be03-04e7-eb87-474d-b1584ebe2060@fb.com>
From:   Song Chen <chensong_2000@189.cn>
In-Reply-To: <b0b8be03-04e7-eb87-474d-b1584ebe2060@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

在 2022/4/2 00:28, Yonghong Song 写道:
> 
> 
> On 3/31/22 8:37 PM, Song Chen wrote:
>>
>>
>> 在 2022/4/1 11:01, Yonghong Song 写道:
>>>
>>>
>>> On 3/31/22 6:41 PM, Song Chen wrote:
>>>> syscall_tp only prints the map id and messages when something goes 
>>>> wrong,
>>>> but it doesn't print the value passed from bpf map. I think it's better
>>>> to show that value to users.
>>>>
>>>> What's more, i also added a 2-second sleep before calling verify_map,
>>>> to make the value more obvious.
>>>>
>>>> Signed-off-by: Song Chen <chensong_2000@189.cn>
>>>> ---
>>>>   samples/bpf/syscall_tp_user.c | 4 ++++
>>>>   1 file changed, 4 insertions(+)
>>>>
>>>> diff --git a/samples/bpf/syscall_tp_user.c 
>>>> b/samples/bpf/syscall_tp_user.c
>>>> index a0ebf1833ed3..1faa7f08054e 100644
>>>> --- a/samples/bpf/syscall_tp_user.c
>>>> +++ b/samples/bpf/syscall_tp_user.c
>>>> @@ -36,6 +36,9 @@ static void verify_map(int map_id)
>>>>           fprintf(stderr, "failed: map #%d returns value 0\n", map_id);
>>>>           return;
>>>>       }
>>>> +
>>>> +    printf("verify map:%d val: %d\n", map_id, val);
>>>
>>> I am not sure how useful it is or anybody really cares.
>>> This is just a sample to demonstrate how bpf tracepoint works.
>>> The error path has error print out already.
> 
> Considering we already have
>     printf("prog #%d: map ids %d %d\n", i, map0_fds[i], map1_fds[i]);
> I think your proposed additional printout
>     printf("verify map:%d val: %d\n", map_id, val);
> might be okay. The commit message should be rewritten
> to justify this change something like:
>     we already print out
>       prog <some number>: map ids <..> <...>
>     further print out
>        verify map: ...
>     will help user to understand the program runs successfully.
> 
> I think sleep(2) is unnecessary.

will do, many thanks.

BR

Song

> 
>>>
>>>> +
>>>>       val = 0;
>>>>       if (bpf_map_update_elem(map_id, &key, &val, BPF_ANY) != 0) {
>>>>           fprintf(stderr, "map_update failed: %s\n", strerror(errno));
>>>> @@ -98,6 +101,7 @@ static int test(char *filename, int num_progs)
>>>>       }
>>>>       close(fd);
>>>> +    sleep(2);
>>>
>>> The commit message mentioned this sleep(2) is
>>> to make the value more obvious. I don't know what does this mean.
>>> sleep(2) can be added only if it fixed a bug.
>>
>> The value in bpf map means how many times trace_enter_open_at are 
>> triggered with tracepoint,sys_enter_openat. Sleep(2) is to enlarge the 
>> result, tell the user how many files are opened in the last 2 seconds.
>>
>> It shows like this:
>>
>> sudo ./samples/bpf/syscall_tp
>> prog #0: map ids 4 5
>> verify map:4 val: 253
>> verify map:5 val: 252
>>
>> If we work harder, we can also print those files' name and opened by 
>> which process.
>>
>> It's just an improvement instead of a bug fix, i will drop it if 
>> reviewers think it's unnecessary.
>>
>> Thanks.
>>
>> BR
>>
>> chensong
>>>
>>>>       /* verify the map */
>>>>       for (i = 0; i < num_progs; i++) {
>>>>           verify_map(map0_fds[i]);
>>>
> 
