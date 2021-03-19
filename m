Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4BE342119
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 16:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhCSPiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 11:38:54 -0400
Received: from www62.your-server.de ([213.133.104.62]:59334 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbhCSPif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 11:38:35 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lNHCl-000Eaz-9N; Fri, 19 Mar 2021 16:38:27 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lNHCl-000QbO-1A; Fri, 19 Mar 2021 16:38:27 +0100
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     Piotr Krysiuk <piotras@gmail.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <20210319111652.474c0939@canb.auug.org.au>
 <CAFzhf4pCdJStzBcveahKYQFHJCKenuT+VZAP+8PWSEQcooKLgQ@mail.gmail.com>
 <4f90ff09-966c-4d86-a3bc-9b52107b6d8a@iogearbox.net>
 <70b99c99-ed58-3b05-92c9-3eaa1e18d722@fb.com>
 <CAADnVQJTXiqZYY1bbKCKwm8_sUvLfUoNaMo8b_Buf=CMhOa+CA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <931588db-5b54-97c2-7042-0be789ae2ed6@iogearbox.net>
Date:   Fri, 19 Mar 2021 16:38:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAADnVQJTXiqZYY1bbKCKwm8_sUvLfUoNaMo8b_Buf=CMhOa+CA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26113/Fri Mar 19 12:14:45 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/19/21 4:33 PM, Alexei Starovoitov wrote:
> On Fri, Mar 19, 2021 at 8:17 AM Yonghong Song <yhs@fb.com> wrote:
>> On 3/19/21 12:21 AM, Daniel Borkmann wrote:
>>> On 3/19/21 3:11 AM, Piotr Krysiuk wrote:
>>>> Hi Daniel,
>>>>
>>>> On Fri, Mar 19, 2021 at 12:16 AM Stephen Rothwell <sfr@canb.auug.org.au>
>>>> wrote:
>>>>
>>>>> diff --cc kernel/bpf/verifier.c
>>>>> index 44e4ec1640f1,f9096b049cd6..000000000000
>>>>> --- a/kernel/bpf/verifier.c
>>>>> +++ b/kernel/bpf/verifier.c
>>>>> @@@ -5876,10 -6056,22 +6060,23 @@@ static int
>>>>> retrieve_ptr_limit(const str
>>>>>                   if (mask_to_left)
>>>>>                           *ptr_limit = MAX_BPF_STACK + off;
>>>>>                   else
>>>>>    -                      *ptr_limit = -off;
>>>>>    -              return 0;
>>>>>    +                      *ptr_limit = -off - 1;
>>>>>    +              return *ptr_limit >= max ? -ERANGE : 0;
>>>>> +       case PTR_TO_MAP_KEY:
>>>>> +               /* Currently, this code is not exercised as the only use
>>>>> +                * is bpf_for_each_map_elem() helper which requires
>>>>> +                * bpf_capble. The code has been tested manually for
>>>>> +                * future use.
>>>>> +                */
>>>>> +               if (mask_to_left) {
>>>>> +                       *ptr_limit = ptr_reg->umax_value + ptr_reg->off;
>>>>> +               } else {
>>>>> +                       off = ptr_reg->smin_value + ptr_reg->off;
>>>>> +                       *ptr_limit = ptr_reg->map_ptr->key_size - off;
>>>>> +               }
>>>>> +               return 0;
>>>>
>>>> PTR_TO_MAP_VALUE logic above looks like copy-paste of old
>>>> PTR_TO_MAP_VALUE
>>>> code from before "bpf: Fix off-by-one for area size in creating mask to
>>>> left" and is apparently affected by the same off-by-one, except this time
>>>> on "key_size" area and not "value_size".
>>>>
>>>> This needs to be fixed in the same way as we did with PTR_TO_MAP_VALUE.
>>>> What is the best way to proceed?
>>>
>>> Hm, not sure why PTR_TO_MAP_KEY was added by 69c087ba6225 in the first
>>> place, I
>>> presume noone expects this to be used from unprivileged as the comment
>>> says.
>>> Resolution should be to remove the PTR_TO_MAP_KEY case entirely from
>>> that switch
>>> until we have an actual user.
>>
>> Alexei suggested so that we don't forget it in the future if
>> bpf_capable() requirement is removed.
>>      https://lore.kernel.org/bpf/c837ae55-2487-2f39-47f6-a18781dc6fcc@fb.com/
>>
>> I am okay with either way, fix it or remove it.
> 
> I prefer to fix it.

If the bpf_capable() is removed, the verifier would bail out on PTR_TO_MAP_KEY
if not covered in the switch given the recent fixes we did. I can fix it up after
merge if we think bpf_for_each_map_elem() will be used by unpriv in future..
