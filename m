Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0314F99564
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 15:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730842AbfHVNqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 09:46:08 -0400
Received: from www62.your-server.de ([213.133.104.62]:41762 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfHVNqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 09:46:08 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i0nPV-0001lp-VF; Thu, 22 Aug 2019 15:45:54 +0200
Received: from [178.197.249.40] (helo=pc-63.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i0nPV-000AAP-LS; Thu, 22 Aug 2019 15:45:53 +0200
Subject: Re: [RFC bpf-next 4/5] iproute2: Allow compiling against libbpf
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        andrii.nakryiko@gmail.com
References: <20190820114706.18546-1-toke@redhat.com>
 <20190820114706.18546-5-toke@redhat.com>
 <9de36bbf-b70d-9320-c686-3033d0408276@iogearbox.net> <87imqppjir.fsf@toke.dk>
 <0c3d78eb-d305-9266-b505-c2f9181d5c89@iogearbox.net> <877e75pftb.fsf@toke.dk>
 <4ca44e39-9b32-909f-df8d-f565eae57498@iogearbox.net> <87zhk1nwvc.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2cf18fed-f2ec-bea3-658e-07ba8124148a@iogearbox.net>
Date:   Thu, 22 Aug 2019 15:45:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87zhk1nwvc.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25549/Thu Aug 22 10:31:26 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/22/19 3:38 PM, Toke Høiland-Jørgensen wrote:
> Daniel Borkmann <daniel@iogearbox.net> writes:
>> On 8/22/19 2:04 PM, Toke Høiland-Jørgensen wrote:
>>> Daniel Borkmann <daniel@iogearbox.net> writes:
>>>> On 8/22/19 12:43 PM, Toke Høiland-Jørgensen wrote:
>>>>> Daniel Borkmann <daniel@iogearbox.net> writes:
>>>>>> On 8/20/19 1:47 PM, Toke Høiland-Jørgensen wrote:
>>>>>>> This adds a configure check for libbpf and renames functions to allow
>>>>>>> lib/bpf.c to be compiled with it present. This makes it possible to
>>>>>>> port functionality piecemeal to use libbpf.
>>>>>>>
>>>>>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>>>>>> ---
>>>>>>>      configure          | 16 ++++++++++++++++
>>>>>>>      include/bpf_util.h |  6 +++---
>>>>>>>      ip/ipvrf.c         |  4 ++--
>>>>>>>      lib/bpf.c          | 33 +++++++++++++++++++--------------
>>>>>>>      4 files changed, 40 insertions(+), 19 deletions(-)
>>>>>>>
>>>>>>> diff --git a/configure b/configure
>>>>>>> index 45fcffb6..5a89ee9f 100755
>>>>>>> --- a/configure
>>>>>>> +++ b/configure
>>>>>>> @@ -238,6 +238,19 @@ check_elf()
>>>>>>>          fi
>>>>>>>      }
>>>>>>>      
>>>>>>> +check_libbpf()
>>>>>>> +{
>>>>>>> +    if ${PKG_CONFIG} libbpf --exists; then
>>>>>>> +	echo "HAVE_LIBBPF:=y" >>$CONFIG
>>>>>>> +	echo "yes"
>>>>>>> +
>>>>>>> +	echo 'CFLAGS += -DHAVE_LIBBPF' `${PKG_CONFIG} libbpf --cflags` >> $CONFIG
>>>>>>> +	echo 'LDLIBS += ' `${PKG_CONFIG} libbpf --libs` >>$CONFIG
>>>>>>> +    else
>>>>>>> +	echo "no"
>>>>>>> +    fi
>>>>>>> +}
>>>>>>> +
>>>>>>>      check_selinux()
>>>>>>
>>>>>> More of an implementation detail at this point in time, but want to
>>>>>> make sure this doesn't get missed along the way: as discussed at
>>>>>> bpfconf [0] best for iproute2 to handle libbpf support would be the
>>>>>> same way of integration as pahole does, that is, to integrate it via
>>>>>> submodule [1] to allow kernel and libbpf features to be in sync with
>>>>>> iproute2 releases and therefore easily consume extensions we're adding
>>>>>> to libbpf to aide iproute2 integration.
>>>>>
>>>>> I can sorta see the point wrt keeping in sync with kernel features. But
>>>>> how will this work with distros that package libbpf as a regular
>>>>> library? Have you guys given up on regular library symbol versioning for
>>>>> libbpf?
>>>>
>>>> Not at all, and I hope you know that. ;-)
>>>
>>> Good! Didn't really expect you had, just checking ;)
>>>
>>>> The reason I added lib/bpf.c integration into iproute2 directly back
>>>> then was exactly such that users can start consuming BPF for tc and
>>>> XDP via iproute2 /everywhere/ with only a simple libelf dependency
>>>> which is also available on all distros since pretty much forever. If
>>>> it was an external library, we could have waited till hell freezes
>>>> over and initial distro adoption would have pretty much taken forever:
>>>> to pick one random example here wrt the pace of some downstream
>>>> distros [0]. The main rationale is pretty much the same as with added
>>>> kernel features that land complementary iproute2 patches for that
>>>> kernel release and as libbpf is developed alongside it is reasonable
>>>> to guarantee user expectations that iproute2 released for kernel
>>>> version x can make use of BPF features added to kernel x with same
>>>> loader support from x.
>>>
>>> Well, for iproute2 I would expect this to be solved by version
>>> dependencies. I.e. iproute2 version X would depend on libbpf version Y+
>>> (like, I dunno, the version of libbpf included in the same kernel source
>>> tree as the kernel version iproute2 is targeting? :)).
>>
>> This sounds nice in theory, but from what I've seen major (!) distros
>> already seem to have a hard time releasing kernel x along with iproute2
>> package x, concrete example was that distro kernel was on 4.13 and its
>> official iproute2 package on 4.9,
> 
> If the iproute2 package is not being updated at all I don't really see
> how it would make any difference whether libbpf is vendored or not? :)
> 
>> adding yet another variable that needs to be in sync with kernel is
>> simply impractical especially for a _core_ package like iproute2 that
>> should have as little dependencies as possible. I also don't want to
>> make a bet on whether libbpf will be available on every distro that
>> also ships iproute2. Hence approach that pahole (and also bcc by the
>> way) takes is most reasonable to have the best user experience.
> 
> Most users are going to get iproute2 from their distro packages anyway,
> so if distros are incompetent at packaging, my bet is that you're going
> to run into issues one way or another.
> 
> But OK, if you think it is easier to work around bad distros by
> vendoring, you guys are the maintainers, so that's up to you. But can we
> at least put in the version dependency and let the build system pick up
> a system libbpf if it exists and is compatible? That way distros that
> *are* competent can still link it dynamically...

Yeah that would be fine by me to use this as a fallback, and I think that
iproute2's configure script should be able to easily handle this situation.
That way we don't compromise on user experience.

Thanks,
Daniel
