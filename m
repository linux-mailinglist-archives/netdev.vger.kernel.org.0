Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CADA50024B
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 01:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239117AbiDMXKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 19:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239115AbiDMXKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 19:10:35 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A2337AAB;
        Wed, 13 Apr 2022 16:08:13 -0700 (PDT)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nelW0-0000zF-AF; Thu, 14 Apr 2022 00:31:08 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nelW0-000OIB-3B; Thu, 14 Apr 2022 00:31:08 +0200
Subject: Re: [PATCH bpf-next] bpf: move rcu lock management out of
 BPF_PROG_RUN routines
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
References: <20220413183256.1819164-1-sdf@google.com>
 <CAEf4Bzb_-KMy7GBN_NsJCKXHfDnGTtVEZb7i4dmcN-8=cLhO+A@mail.gmail.com>
 <Ylcm/dfeU3AEYqlV@google.com>
 <CAEf4BzYuTd9m4_J9nh5pZ9baoMMQK+m6Cum8UMCq-k6jFTJwEA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <dacc476a-624c-cd05-4a4b-146a2abdc212@iogearbox.net>
Date:   Thu, 14 Apr 2022 00:31:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYuTd9m4_J9nh5pZ9baoMMQK+m6Cum8UMCq-k6jFTJwEA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26511/Wed Apr 13 10:22:45 2022)
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/22 9:52 PM, Andrii Nakryiko wrote:
> On Wed, Apr 13, 2022 at 12:39 PM <sdf@google.com> wrote:
>> On 04/13, Andrii Nakryiko wrote:
>>> On Wed, Apr 13, 2022 at 11:33 AM Stanislav Fomichev <sdf@google.com>
>>> wrote:
>>>>
>>>> Commit 7d08c2c91171 ("bpf: Refactor BPF_PROG_RUN_ARRAY family of macros
>>>> into functions") switched a bunch of BPF_PROG_RUN macros to inline
>>>> routines. This changed the semantic a bit. Due to arguments expansion
>>>> of macros, it used to be:
>>>>
>>>>          rcu_read_lock();
>>>>          array = rcu_dereference(cgrp->bpf.effective[atype]);
>>>>          ...
>>>>
>>>> Now, with with inline routines, we have:
>>>>          array_rcu = rcu_dereference(cgrp->bpf.effective[atype]);
>>>>          /* array_rcu can be kfree'd here */
>>>>          rcu_read_lock();
>>>>          array = rcu_dereference(array_rcu);
>>>>
>>
>>> So subtle difference, wow...
>>
>>> But this open-coding of rcu_read_lock() seems very unfortunate as
>>> well. Would making BPF_PROG_RUN_ARRAY back to a macro which only does
>>> rcu lock/unlock and grabs effective array and then calls static inline
>>> function be a viable solution?
>>
>>> #define BPF_PROG_RUN_ARRAY_CG_FLAGS(array_rcu, ctx, run_prog, ret_flags) \
>>>     ({
>>>         int ret;
>>
>>>         rcu_read_lock();
>>>         ret =
>>> __BPF_PROG_RUN_ARRAY_CG_FLAGS(rcu_dereference(array_rcu), ....);
>>>         rcu_read_unlock();
>>>         ret;
>>>     })
>>
>>
>>> where __BPF_PROG_RUN_ARRAY_CG_FLAGS is what
>>> BPF_PROG_RUN_ARRAY_CG_FLAGS is today but with __rcu annotation dropped
>>> (and no internal rcu stuff)?
>>
>> Yeah, that should work. But why do you think it's better to hide them?
>> I find those automatic rcu locks deep in the call stack a bit obscure
>> (when reasoning about sleepable vs non-sleepable contexts/bpf).
>>
>> I, as the caller, know that the effective array is rcu-managed (it
>> has __rcu annotation) and it seems natural for me to grab rcu lock
>> while work with it; I might grab it for some other things like cgroup
>> anyway.
> 
> If you think that having this more explicitly is better, I'm fine with
> that as well. I thought a simpler invocation pattern would be good,
> given we call bpf_prog_run_array variants in quite a lot of places. So
> count me indifferent. I'm curious what others think.

+1 for explicit, might also be easier to review/audit compared to hidden
in macro.
