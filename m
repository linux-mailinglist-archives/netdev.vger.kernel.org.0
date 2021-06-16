Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDE93AA0A8
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 18:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234993AbhFPQCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 12:02:24 -0400
Received: from www62.your-server.de ([213.133.104.62]:57702 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234911AbhFPQCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 12:02:23 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ltXxa-000E80-Jk; Wed, 16 Jun 2021 18:00:10 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ltXxa-0005AQ-6I; Wed, 16 Jun 2021 18:00:10 +0200
Subject: Re: [PATCH RFC bpf-next 0/7] Add bpf_link based TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Vlad Buslov <vladbu@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20210607060724.4nidap5eywb23l3d@apollo>
 <CAM_iQpWA=SXNR3Ya8_L2aoVJGP_uaRP8EYCpDrnq3y8Uf6qu=g@mail.gmail.com>
 <20210608071908.sos275adj3gunewo@apollo>
 <CAM_iQpXFmsWhMA-RO2j5Ph5Ak8yJgUVBppGj2_5NS3BuyjkvzQ@mail.gmail.com>
 <20210613025308.75uia7rnt4ue2k7q@apollo>
 <30ab29b9-c8b0-3b0f-af5f-78421b27b49c@mojatatu.com>
 <20210613203438.d376porvf5zycatn@apollo>
 <4b1046ef-ba16-f8d8-c02e-d69648ab510b@mojatatu.com>
 <bd18943b-8a0e-be8c-6a99-17f7dfdd3bc4@iogearbox.net>
 <7248dc4e-8c07-a25d-5ac3-c4c106b7a266@mojatatu.com>
 <20210616153209.pejkgb3iieu6idqq@apollo>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <05ec2836-7f0d-0393-e916-fd578d8f14ac@iogearbox.net>
Date:   Wed, 16 Jun 2021 18:00:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210616153209.pejkgb3iieu6idqq@apollo>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26203/Wed Jun 16 13:07:58 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/16/21 5:32 PM, Kumar Kartikeya Dwivedi wrote:
> On Wed, Jun 16, 2021 at 08:10:55PM IST, Jamal Hadi Salim wrote:
>> On 2021-06-15 7:07 p.m., Daniel Borkmann wrote:
>>> On 6/13/21 11:10 PM, Jamal Hadi Salim wrote:
>>
>> [..]
>>
>>>> I look at it from the perspective that if i can run something with
>>>> existing tc loading mechanism then i should be able to do the same
>>>> with the new (libbpf) scheme.
>>>
>>> The intention is not to provide a full-blown tc library (that could be
>>> subject to a
>>> libtc or such), but rather to only have libbpf abstract the tc related
>>> API that is
>>> most /relevant/ for BPF program development and /efficient/ in terms of
>>> execution in
>>> fast-path while at the same time providing a good user experience from
>>> the API itself.
>>>
>>> That is, simple to use and straight forward to explain to folks with
>>> otherwise zero
>>> experience of tc. The current implementation does all that, and from
>>> experience with
>>> large BPF programs managed via cls_bpf that is all that is actually
>>> needed from tc
>>> layer perspective. The ability to have multi programs (incl. priorities)
>>> is in the
>>> existing libbpf API as well.
>>
>> Which is a fair statement, but if you take away things that work fine
>> with current iproute2 loading I have no motivation to migrate at all.
>> Its like that saying of "throwing out the baby with the bathwater".
>> I want my baby.
>>
>> In particular, here's a list from Kartikeya's implementation:
>>
>> 1) Direct action mode only

(More below.)

>> 2) Protocol ETH_P_ALL only

The issue I see with this one is that it's not very valuable or useful from a BPF
point of view. Meaning, this kind of check can and typically is implemented from
BPF program anyway. For example, when you have direct packet access initially
parsing the eth header anyway (and from there having logic for the various eth
protos).

That protocol option is maybe more useful when you have classic tc with cls+act
style pipeline where you want a quick skip of classifiers to avoid reparsing the
packet. Given you can do everything inside the BPF program already it adds more
confusion than value for a simple libbpf [tc/BPF] API.

>> 3) Only at chain 0
>> 4) No block support
> 
> Block is supported, you just need to set TCM_IFINDEX_MAGIC_BLOCK as ifindex and
> parent as the block index. There isn't anything more to it than that from libbpf
> side (just specify BPF_TC_CUSTOM enum).
> 
> What I meant was that hook_create doesn't support specifying the ingress/egress
> block when creating clsact, but that typically isn't a problem because qdiscs
> for shared blocks would be set up together prior to the attachment anyway.
> 
>> I think he said priority is supported but was also originally on that
>> list.
>> When we discussed at the meetup it didnt seem these cost anything
>> in terms of code complexity or usability of the API.
>>
>> 1) We use non-DA mode, so i cant live without that (and frankly ebpf
>> has challenges adding complex code blocks).

Could you elaborate on that or provide code examples? Since introduction of the
direct action mode I've never used anything else again, and we do have complex
BPF code blocks that we need to handle as well. Would be good if you could provide
more details on things you ran into, maybe they can be solved?

>> 2) We also use different protocols when i need to
>> (yes, you can do the filtering in the bpf code - but why impose that
>> if the cost of adding it is simple? and of course it is cheaper to do
>> the check outside of ebpf)
>> 3) We use chains outside of zero
>>
>> 4) So far we dont use block support but certainly my recent experiences
>> in a deployment shows that we need to group netdevices more often than
>> i thought was necessary. So if i could express one map shared by
>> multiple netdevices it should cut down the user space complexity.

Thanks,
Daniel
