Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F34737D6B
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 21:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfFFTnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 15:43:13 -0400
Received: from www62.your-server.de ([213.133.104.62]:48902 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbfFFTnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 15:43:11 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hYxza-0001X3-FW; Thu, 06 Jun 2019 21:24:06 +0200
Received: from [178.197.249.21] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hYxza-0003h6-9P; Thu, 06 Jun 2019 21:24:06 +0200
Subject: Re: [PATCH net-next v2 1/2] bpf_xdp_redirect_map: Add flag to return
 XDP_PASS on map lookup failure
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>
References: <155982745450.30088.1132406322084580770.stgit@alrua-x1>
 <155982745460.30088.2745998912845128889.stgit@alrua-x1>
 <400a6093-6e9c-a1b4-0594-5b74b20a3d6b@iogearbox.net>
 <CAADnVQKZG6nOZUvqzvxz5xjZZLieQB4DvbkP=AjDF25FQB8Jfg@mail.gmail.com>
 <877e9yd70i.fsf@toke.dk> <9EC7B894-B076-46FA-BD2B-FFE12E55722B@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <709e80ae-a08a-f00e-8f42-50289495d0de@iogearbox.net>
Date:   Thu, 6 Jun 2019 21:24:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <9EC7B894-B076-46FA-BD2B-FFE12E55722B@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25472/Thu Jun  6 10:09:59 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/06/2019 08:15 PM, Jonathan Lemon wrote:
> On 6 Jun 2019, at 9:15, Toke Høiland-Jørgensen wrote:
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>> On Thu, Jun 6, 2019 at 8:51 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>>> On 06/06/2019 03:24 PM, Toke Høiland-Jørgensen wrote:
>>>>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>>>>>
>>>>> The bpf_redirect_map() helper used by XDP programs doesn't return any
>>>>> indication of whether it can successfully redirect to the map index it was
>>>>> given. Instead, BPF programs have to track this themselves, leading to
>>>>> programs using duplicate maps to track which entries are populated in the
>>>>> devmap.
>>>>>
>>>>> This patch adds a flag to the XDP version of the bpf_redirect_map() helper,
>>>>> which makes the helper do a lookup in the map when called, and return
>>>>> XDP_PASS if there is no value at the provided index.
>>>>>
>>>>> With this, a BPF program can check the return code from the helper call and
>>>>> react if it is XDP_PASS (by, for instance, substituting a different
>>>>> redirect). This works for any type of map used for redirect.
>>>>>
>>>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>>>> ---
>>>>>  include/uapi/linux/bpf.h |    8 ++++++++
>>>>>  net/core/filter.c        |   10 +++++++++-
>>>>>  2 files changed, 17 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>>>> index 7c6aef253173..d57df4f0b837 100644
>>>>> --- a/include/uapi/linux/bpf.h
>>>>> +++ b/include/uapi/linux/bpf.h
>>>>> @@ -3098,6 +3098,14 @@ enum xdp_action {
>>>>>       XDP_REDIRECT,
>>>>>  };
>>>>>
>>>>> +/* Flags for bpf_xdp_redirect_map helper */
>>>>> +
>>>>> +/* If set, the help will check if the entry exists in the map and return
>>>>> + * XDP_PASS if it doesn't.
>>>>> + */
>>>>> +#define XDP_REDIRECT_F_PASS_ON_INVALID BIT(0)
>>>>> +#define XDP_REDIRECT_ALL_FLAGS XDP_REDIRECT_F_PASS_ON_INVALID
>>>>> +
>>>>>  /* user accessible metadata for XDP packet hook
>>>>>   * new fields must be added to the end of this structure
>>>>>   */
>>>>> diff --git a/net/core/filter.c b/net/core/filter.c
>>>>> index 55bfc941d17a..2e532a9b2605 100644
>>>>> --- a/net/core/filter.c
>>>>> +++ b/net/core/filter.c
>>>>> @@ -3755,9 +3755,17 @@ BPF_CALL_3(bpf_xdp_redirect_map, struct bpf_map *, map, u32, ifindex,
>>>>>  {
>>>>>       struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>>>>>
>>>>> -     if (unlikely(flags))
>>>>> +     if (unlikely(flags & ~XDP_REDIRECT_ALL_FLAGS))
>>>>>               return XDP_ABORTED;
>>>>>
>>>>> +     if (flags & XDP_REDIRECT_F_PASS_ON_INVALID) {
>>>>> +             void *val;
>>>>> +
>>>>> +             val = __xdp_map_lookup_elem(map, ifindex);
>>>>> +             if (unlikely(!val))
>>>>> +                     return XDP_PASS;
>>>>
>>>> Generally looks good to me, also the second part with the flag. Given we store into
>>>> the per-CPU scratch space and function like xdp_do_redirect() pick this up again, we
>>>> could even propagate val onwards and save a second lookup on the /same/ element (which
>>>> also avoids a race if the val was dropped from the map in the meantime). Given this
>>>> should all still be within RCU it should work. Perhaps it even makes sense to do the
>>>> lookup unconditionally inside bpf_xdp_redirect_map() helper iff we manage to do it
>>>> only once anyway?
>>>
>>> +1
>>>
>>> also I don't think we really need a new flag here.
>>> Yes, it could be considered an uapi change, but it
>>> looks more like bugfix in uapi to me.
>>> Since original behavior was so clunky to use.
>>
>> Hmm, the problem with this is that eBPF programs generally do something
>> like:
>>
>> return bpf_redirect_map(map, idx, 0);
>>
>> after having already modified the packet headers. This will get them a
>> return code of XDP_REDIRECT, and the lookup will then subsequently fail,
>> which returns in XDP_ABORTED in the driver, which you can catch with
>> tracing.
>>
>> However, if we just change it to XDP_PASS, the packet will go up the
>> stack, but because it has already been modified the stack will drop it,
>> more or less invisibly.
>>
>> So the question becomes, is that behaviour change really OK?
> 
> Another option would be treating the flags (or the lower bits of flags)
> as the default xdp action taken if the lookup fails.  0 just happens to
> map to XDP_ABORTED, which gives the initial behavior.  Then the new behavior
> would be:
> 
>     return bpf_redirect_map(map, index, XDP_PASS);

Makes sense, that should work, but as default (flags == 0), you'd have
to return XDP_REDIRECT to stay consistent with existing behavior.

Thanks,
Daniel
